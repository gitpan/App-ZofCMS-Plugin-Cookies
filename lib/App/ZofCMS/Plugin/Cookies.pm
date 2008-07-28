package App::ZofCMS::Plugin::Cookies;

use warnings;
use strict;

our $VERSION = '0.0101';

sub new { return bless {}, shift }

sub process {
    my ( $self, $template, $query, $config ) = @_;

    my $cgi = $config->cgi;
    $template->{d}{cookies} = {
        map +( $_ => $cgi->cookie($_) ),
            $cgi->cookie
    };

    if ( $template->{set_cookies} ) {
        my $cookies = delete $template->{set_cookies};
        if ( ref $cookies eq 'HASH' or not ref $cookies->[0] ) {
            $cookies = [ $cookies ];
        }
        for ( @$cookies ) {
            my $cookie;
            if ( ref eq 'HASH' ) {
                $cookie = $cgi->cookie( %$_ );
            }
            else {
                $cookie = $cgi->cookie( -name => $_->[0], -value => $_->[1] );
            }
            print "Set-Cookie: $cookie\n";
        }
    }

    return;
}

1;
__END__

=head1 NAME

App::ZofCMS::Plugin::Cookies - HTTP Cookie handling plugin for ZofCMS

=head1 SYNOPSIS

In your ZofCMS template, or in your main config file (under C<template_defaults>
or C<dir_defaults>):

    set_cookies => [
        [ 'name', 'value' ],
        {
            -name    => 'sessionID',
            -value   => 'xyzzy',
            -expires => '+1h',
            -path    => '/cgi-bin/database',
            -domain  => '.capricorn.org',
            -secure  => 1,
        },
    ],

=head1 DESCRIPTION

This module is a plugin for L<App::ZofCMS> which provides means to
read and set HTTP cookies.

=head1 SETTING COOKIES

    # example 1
    set_cookies => [ 'name', 'value' ],

    # OR

    # example 2
    set_cookies => {
            -name    => 'sessionID',
            -value   => 'xyzzy',
            -expires => '+1h',
            -path    => '/cgi-bin/database',
            -domain  => '.capricorn.org',
            -secure  => 1,
    },

    # OR

    # example 3
    set_cookies => [
        [ 'name', 'value' ],
        {
            -name    => 'sessionID',
            -value   => 'xyzzy',
            -expires => '+1h',
            -path    => '/cgi-bin/database',
            -domain  => '.capricorn.org',
            -secure  => 1,
        },
    ],

To set cookies use C<set_cookies> first level key of your ZofCMS template.
It's value can be
either an arrayref or a hashref. When the value is an arrayref elements
of which are not arrayrefs or hashrefs (example 1 above), or when the value
is a hashref (example 2 above) it is encapsulated into an arrayref
automatically to become as shown in (example 3 above). With that in mind,
each element of an arrayref, which is a value of C<set_cookies> key,
specifies a certain cookie which plugin must set. When element of that
arrayref is an arrayref, it must contain two elements. The first element
will be the name of the cookie and the second element will be the value
of the cookie. In other words:

    set_cookies => [ 'name', 'value', ]

    # which is the same as

    set_cookies => [ [ 'name', 'value', ]

    # which is the same as

    CGI->new->cookie( -name => 'name', -value => 'value' );

When the element is a hashref, it will be dereferenced directy into
L<CGI>'s C<cookie()> method, in other words:

    set_cookies => { -name => 'name', -value => 'value' }

    # is the same as

    CGI->new->cookie( -name => 'name', -value => 'value' );

See documentation of L<CGI> module for possible values.

If C<set_cookies> key is not present, no cookies will be set.

=head1 READING COOKIES

All of the cookies are read by the plugin automatically and put into
C<< {d}{cookies} >> (the special key C<{d}> (data) of your ZofCMS template)

You can read those either via C<exec> code (NOT C<exec_before>, plugins
are run after) (If you don't know what C<exec> or C<exec_before> are
read L<App::ZofCMS::Template>). Other plugins can also read those cookies,
just make sure they are run I<after> the Cookies plugin is run (set
higher priority number). Below is an example of reading a cookie and
displaying it's value in your L<HTML::Template> template using
L<App::ZofCMS::Plugin::Tagged> plugin.

    # In your ZofCMS template:

        plugins     => [ { Cookies => 10 }, { Tagged => 20 }, ],
        set_cookies => [ foo => 'bar' ],
        t => {
            cookie_foo => '<TAG:TNo cookies:{d}{cookies}{foo}>',
        },

    # In one of your HTML::Template templates which are referenced by
    # ZofCMS plugin above:

    Cookie 'foo': <tmpl_var name="cookie_foo">

When this page is run the first time, no cookies are set, thus
{d}{cookies} will be empty and you will see the default value of
"No cookies" which we set in Tagged's tag:

    Cookie 'foo': No cookies

When the page s run the second time, Cookies plugin will read cookie
'foo' which it set on the first run and will stick its value
into {d}{cookies}{foo}. Our Tagged tag will read that value and enter
it into the C<< <tmpl_var> >> we allocated in L<HTML::Template> plugin,
thus the result will be:

    Cookie 'foo': bar

That's all there is to it, enjoy!

=head1 AUTHOR

Zoffix Znet, C<< <zoffix at cpan.org> >>
(L<http://zoffix.com>, L<http://haslayout.net>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-zofcms-plugin-cookies at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-ZofCMS-Plugin-Cookies>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::ZofCMS::Plugin::Cookies

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-ZofCMS-Plugin-Cookies>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-ZofCMS-Plugin-Cookies>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-ZofCMS-Plugin-Cookies>

=item * Search CPAN

L<http://search.cpan.org/dist/App-ZofCMS-Plugin-Cookies>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 Zoffix Znet, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

