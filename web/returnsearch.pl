#!/usr/bin/perl
use warnings;
use strict;

use HTML::Template;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Data::Dumper;
use lib "../";
use Helper;
use QueryResultFormatter;

sub artist {
	my $ref;
	(my $search_for, my $search_by) = @_;
	$ref = QueryResultFormatter::get_possible_artists($search_for);
	
	my $template = HTML::Template->new( filename => 'templates/artist.html' );
	
	$template->param(SEARCH_FOR => $search_for);
	$template->param(SEARCH_BY => $search_by);
	
	my @artists;

	foreach my $key ( keys %{$ref} ) {
		push(
			@artists,
			{
				ID       => $key,
				SORTNAME => $ref->{$key}{'sort-name'},
				SCORE    => $ref->{$key}{'ext:score'}
			}
		);
	}
	
	$template->param(SONG_INFO => [@artists]);

	print "Content-Type: text/html\n\n", $template->output;
}

sub song {
	my $ref;
	(my $search_for, my $search_by) = @_;
	QueryResultFormatter::get_possible_recordings($search_for);
	my $template = HTML::Template->new( filename => 'templates/returnsearch.html' );
	$template->param(SEARCH_FOR => $search_for);
	$template->param(SEARCH_BY => $search_by);
	$template->param(
		SONG_INFO => [
			{ ARTIST => 'dillen', ALBUM => 'sucks', SONG => 'FUCK MY NUTS'},
			{ ARTIST => 'Terrance', ALBUM => 'greatest hits', SONG => 'Fuck you'},
		]
	);

	print "Content-Type: text/html\n\n", $template->output;
}

sub album {
	my $ref;
	(my $search_for, my $search_by) = @_;
	QueryResultFormatter::get_possible_albums($search_for);
	my $template = HTML::Template->new( filename => 'templates/returnsearch.html' );
	$template->param(SEARCH_FOR => $search_for);
	$template->param(SEARCH_BY => $search_by);
	$template->param(
		SONG_INFO => [
			{ ARTIST => 'dillen', ALBUM => 'sucks', SONG => 'FUCK MY NUTS'},
			{ ARTIST => 'Terrance', ALBUM => 'greatest hits', SONG => 'Fuck you'},
		]
	);

	print "Content-Type: text/html\n\n", $template->output;
}


sub returnSearch {
	(my $search_for, my $search_by) = @_;
	my $ref;
	if ($search_by eq "artist") {
		artist($search_for, $search_by);
	}
	elsif ($search_by eq "song") {
		song($search_for, $search_by);
	}
	else { #Default to Album
		album($search_for, $search_by);
	}
	
	
}

my $query      = new CGI;
my $search_for = $query->param("main-search-text");
my $search_by  = $query->param("main-search-by");

if ($search_for eq "" || $search_by eq "") {
	Helper::error("No Parameters Set in CGI");
} 
else {
	returnSearch($search_for, $search_by);
}