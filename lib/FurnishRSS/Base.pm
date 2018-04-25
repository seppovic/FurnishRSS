 
package FurnishRSS::Plugin::FeedReader;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
  my ($self, $app, $config) = @_;

  $self->{invite_code} = $config->{invite_code}
    // ($ENV{CONVOS_INVITE_CODE} //= $self->_generate_invite_code($app));
  $app->config->{settings}{invite_code} = $self->{invite_code} ? true : false;

  $app->helper(''    => \&_login);
  $app->helper('auth.logout'   => \&_logout);
  $app->helper('auth.register' => sub { $self->_register(@_) });
}



1;


=pod 

=encoding utf8

=head1 NAME

FurnishRSS::Plugin::FeedReader - reads from feeds

=head1 DESCRIPTION
