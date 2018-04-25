package FurnishRSS;
our $VERSION = '1.0.0';
use Mojo::Base 'Mojolicious';
use Carp qw/croak/;
use Try::Tiny;
use Data::Dumper qw/Dumper/;


# This method will run once at server start
sub startup {
  my $self = shift;

  $self->defaults(debug => $self->mode eq 'development' ? ['info'] : []);
  my $config = $self->_config; # let the _config method do the heavy lifting and construct the config

  # TODO
  # instanciate all Provider Objects
  for my $source (keys %{$config->{sources}}) {
      my $provider_string = $config->{sources}->{$source}->{provider}
      eval "require FurnishRSS::Provider::". $provider_string .";1;";
      if ($@) {
        my $err = $@;
      }
  }

  # Plugins
  $self->plugin( 'FurnishRSS' => { $config, route => $app->routes->any('/') });

  unshift @{$app->plugins->namespaces}, 'FurnischRSS::Provider';
  for my $backend ( @{ $app->config->{backends} } ) {
    $app->plugin( @$backend );
  }

  # von yancy geklaut, bewirkt dass die templates aus diesem File
  # geladen werden.
  push @{$app->renderer->classes}, 'FurnishRSS';

  # Normal route to controller
  $r->get('/')->to(template => 'index');
  $r->get('/:source', [source => qr/[a-zA-Z0-9_\.-]+/, format => ["xml", "rss"]] )->name('feed')->to('backend#feed');

}


# read config from file and set defaults:
sub _config {
  my $self   = shift;
  my $configfile = $ENV{MOJO_CONFIG} || 'etc/FurnishRSS.yaml';
  my $config = $self->config;

  # load configfile
  try{
    $config = $self->plugin(yaml_config => {
          file      => $configfile,
          stash_key => 'conf',
          class     => 'YAML::XS'
    }) if $configfile =~ /\.yaml$/;
    $config = $self->plugin(JSONconfig => {
          file      => $configfile,
    }) if $configfile =~ /\.json$/;
    croak 'The only allowed config file formats are .json and .yaml' if $configfile !~ /\.(json|yaml)$/;
  } catch {
    croak 'cant parse config: '. $_;
  };

  # fill in the defaults if they were not specified in config file given above
  $config->{sources} ||= {};

  if ($config->{log_file} ||= $ENV{FURNISH_LOG_FILE} || 'log/FurnishRSS.log') {
    $self->log->path($config->{log_file});
    delete $self->log->{handle} if $self->mode ne 'development';
  }

# noch nicht im gebrach:
#~ $config->{backend_provider} ||= $ENV{FURNISH_BACKEND_PROVIDER} || 'FurnishRSS::Base::Backend::File';
#~  $config->{home} ||= $ENV{FURNISH_HOME}
#~    ||= path(File::HomeDir->my_home, qw(.local share convos))->to_string;
#~  $config->{secure_cookies}    ||= $ENV{CONVOS_SECURE_COOKIES}    || 0;

# interesting idea to split settings into private and public...
#~  # public settings
#~  $config->{settings} = {
#~    contact           => $config->{contact},
#~    default_server    => $config->{default_server},
#~    forced_irc_server => $config->{forced_irc_server}->host ? true : false,
#~    hide              => $config->{hide} ||= {},
#~    organization_name => $config->{organization_name},
#~    organization_url  => $config->{organization_url},
#~    version           => $self->VERSION || '0.01',
#~  };
  $self->log->info('using the following config: '. Dumper($config));
  return $config;
} # END _config

# load the necessary plugins for all providers
sub _plugins {
  my $self    = shift;
  my @plugins = ();
  my %uniq;
  unshift @{$self->plugins->namespaces}, 'FurnishRSS::Plugin';

  foreach my $source (@{$self->config('sources')}) {
    my $provider = $self->config('sources')->{$source}->{provider};
    my $config = $self->config('sources')->{$source}->{provider_args};
    $self->plugin($provider => $config) unless $uniq{$provider}++;

  }

} # END _plugins

1;

__DATA__

@@ not_found.development.html.ep
% layout 'default';
            <h1>Welcome to FurnishRSS</h1>
            <p>This is the not found page.</p>

            <h2>The following Feeds are configured:</h2>
            <%= link_to 'here' => '/index.html' %> for a link to this page and an list of all configured feeds.
            <ul>
              <%= loop.... 
            </ul>
        </div>
    </div>
</main>

                                                                                                                                                 184,0-1      Ende

