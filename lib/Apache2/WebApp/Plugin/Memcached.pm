#----------------------------------------------------------------------------+
#
#  Apache2::WebApp::Plugin::Memcached - Cache::Memcached module wrapper
#
#  DESCRIPTION
#  Store persistent data using memcached (memory cache daemon).
#
#  AUTHOR
#  Marc S. Brooks <mbrooks@cpan.org>
#
#  This module is free software; you can redistribute it and/or
#  modify it under the same terms as Perl itself.
#
#----------------------------------------------------------------------------+

package Apache2::WebApp::Plugin::Memcached;

use strict;
use base 'Apache2::WebApp::Plugin';
use Cache::Memcached;
use Params::Validate qw( :all );

our $VERSION = 0.04;

#~~~~~~~~~~~~~~~~~~~~~~~~~~[  OBJECT METHODS  ]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#----------------------------------------------------------------------------+
# connect(\%config)
#
# Initialize a new Memcache session across servers.

sub connect {
    my ( $self, $config )
      = validate_pos( @_,
          { type => OBJECT  },
          { type => HASHREF }
          );

    return new Cache::Memcached {
        servers            => [ split( /\,\s+/, $config->{memcached_servers} ) ],
        compress_threshold => $config->{memcached_compress_threshold} || 10_000,
        debug              => $config->{debug}                        || 0,
      };
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~[  PRIVATE METHODS  ]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#----------------------------------------------------------------------------+
# _init(\%config)
#
# Return a reference of $self to the caller.

sub _init {
    my ( $self, $config) = @_;
    return $self;
}

1;

__END__

=head1 NAME

Apache2::WebApp::Plugin::Memcached - Cache::Memcached module wrapper

=head1 SYNOPSIS

  my $obj = $c->plugin('Memcached')->method( ... );     # Apache2::WebApp::Plugin::Memcached->method()

    or

  $c->plugin('Memcached')->method( ... );

=head1 DESCRIPTION

Store persistent data using memcached (memory cache daemon).

L<http://www.danga.com/memcached>

=head1 PREREQUISITES

This package is part of a larger distribution and was NOT intended to be used 
directly.  In order for this plugin to work properly, the following packages
must be installed:

  Apache2::WebApp
  Cache::Memcached
  Params::Validate

=head1 INSTALLATION

From source:

  $ tar xfz Apache2-WebApp-Plugin-Memcached-0.X.X.tar.gz
  $ perl MakeFile.PL PREFIX=~/path/to/custom/dir LIB=~/path/to/custom/lib
  $ make
  $ make test     <--- Make sure you do this before contacting me
  $ make install

Perl one liner using CPAN.pm:

  perl -MCPAN -e 'install Apache2::WebApp::Plugin::Memcached'

Use of CPAN.pm in interactive mode:

  $> perl -MCPAN -e shell
  cpan> install Apache2::WebApp::Plugin:Memcached
  cpan> quit

Just like the manual installation of Perl modules, the user may need root access during
this process to insure write permission is allowed within the installation directory.

=head1 CONFIGURATION

Unless it already exists, add the following to your projects I<webapp.conf>

  [memcached]
  servers            = 127.0.0.1:11211, 192.168.1.1:11212, 192.168.1.2:11213
  compress_threshold = 10_000

=head1 OBJECT METHODS

=head2 connect

Initialize a new Memcache session across servers.

  my $memd = $c->plugin('Memcached')->connect({
      memcached_servers            => '127.0.0.1:11211, 192.168.1.1:11212, 192.168.1.2:11213',
      memcached_compress_threshold => 10_000,
      debug                        => 1,
    });

  $memd->set( "foo", "bar" );

=head1 SEE ALSO

L<Apache2::WebApp>, L<Apache2::WebApp::Plugin>, L<Cache::Memcached>

=head1 AUTHOR

Marc S. Brooks, E<lt>mbrooks@cpan.orgE<gt> - L<http://mbrooks.info>

=head1 COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
