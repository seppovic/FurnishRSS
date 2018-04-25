package FurnishRSS::Controller::Backend;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper qw/Dumper/;


sub feed {
  my $self = shift;
  my $c = $self->config;

  #return $self->render(message => "Feed not found", status => 400, ) if !$c->{sources}->{$self->stash('source')}{provider};
  return $self->redirect_to('/') if !$c->{sources}->{$self->stash('source')};
  
  
  $self->render(text => 
    Dumper($self->stash('source')). "<br>\n".
    Dumper($c->{sources}->{$self->stash('source')}). "<br>\n".
    Dumper($c->{sources}). "<br>\n"
  );
}
1;
