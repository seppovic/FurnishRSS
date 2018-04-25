package FurnishRSS::Provider;
use Mojo::Base -base; 

use Module::Load;
use warnings;
use strict;
require Exporter;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(


);


# loading providers by name; code from Alambic::Model::Plugins
sub new {
  my ($class) = @_;
  # Clean hashes before reading files.
  %plugins         = ();
  %plugins_type    = ();
  %plugins_ability = ();

  # Read plugins directory.
  my @plugins_list = <lib/Alambic/Plugins/*.pm>;
  foreach my $plugin_path (@plugins_list) {
    $plugin_path =~ m!lib/(.+).pm!;
    my $plugin = $1;
    $plugin =~ s!/!::!g;

    $plugin_path =~ m!.+/([^/\\]+).pm!;
    my $plugin_name = $1;

    autoload $plugin;

    my $conf = $plugin->get_conf();
    $plugins{$conf->{'id'}} = $plugin;
    push(@{$plugins_type{$conf->{'type'}}}, $conf->{'id'});
    foreach my $a (@{$conf->{'ability'}}) {
      push(@{$plugins_ability{$a}}, $conf->{'id'});
    }
  }


  return bless {}, $class;
}