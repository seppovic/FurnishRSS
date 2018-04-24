package Mojolicious::Plugin::FurnishRSS;

our $VERSION = '1.0.0';

use Mojo::Base 'Mojolicious::Plugin';
use FurnishRSS;
use Mojo::Loader qw( load_class );

sub register {
  my ( $self, $app, $config ) = @_;
  my $route = $config->{route} // $app->routes->any( '/rss' );
  $route->to( return_to => $config->{return_to} // '/' );

  # Resources and templates
  my $share = path( __FILE__ )->sibling( 'FurnishRSS' )->child( 'resources' );
  push @{ $app->renderer->paths }, $share->sibling('templates')->to_string;

  # statische Ressourcen (css, bilder, etc.) können noch wie folgt eingebunden werden:
  # push @{ $app->static->paths }, $share->child( 'public' )->to_string;
  # prüfen was das macht:
  # push @{$app->routes->namespaces}, 'FurnishRSS::TODO';

  # Helpers des Plugins:
  $app->helper( 'furnishrss.config' => sub { return $config} );
  $app->helper( 'furnishrss.route' => sub { return $route } );

  $app->helper( 'furnishrss.backend' => sub {
    # TODO
    # state $backend = load_backend( $config->{backend}, $config->{collections} );
  } );
}
