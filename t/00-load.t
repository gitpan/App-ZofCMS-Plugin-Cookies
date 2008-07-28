#!/usr/bin/env perl

use Test::More tests => 1;

BEGIN {
	use_ok( 'App::ZofCMS::Plugin::Cookies' );
}

diag( "Testing App::ZofCMS::Plugin::Cookies $App::ZofCMS::Plugin::Cookies::VERSION, Perl $], $^X" );
