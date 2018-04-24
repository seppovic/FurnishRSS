package FurnishRSS;
our $VERSION = '1.0.0';
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Plugins
  $self->plugin( 'FurnishRSS' => { $config, route => $app->routes->any('/') });

  unshift @{$app->plugins->namespaces}, 'FurnischRSS::Provider';
  for my $backend ( @{ $app->config->{backends} } ) {
    $app->plugin( @$backend );
  }

  # von yancy geklaut, bewirkt dass die templates aus diesem File
  # geladen werden.
  push @{$app->renderer->classes}, 'FurnishRSS';
}

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

