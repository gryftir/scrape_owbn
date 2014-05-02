#!/usr/bin/env perl
use warnings;
use strict;

use WWW::Mechanize;
use HTML::TreeBuilder;

my $mech = WWW::Mechanize->new();
my $start_url = "http://www.owbn.net";
$mech->get($start_url);

my @links = $mech->find_all_links( url_regex => qr/brazil/i );

foreach my $link (@links) {
	$mech->get($link);
	my $tree = HTML::TreeBuilder->new_from_content($mech->content());
	my $game_links = $tree->look_down(_tag =>'tbody')->extract_links( 'a');
	foreach my $game (@$game_links) {
		 my($rel_link, $element, $attr, $tag) = @$game;
		 $mech->get($start_url . $rel_link);
		 my $game_tree = HTML::TreeBuilder->new_from_content($mech->content());
		 foreach my $p_tags ($game_tree->look_down(_tag => 'p') ) {
			 my $string = $p_tags->as_text();
			 if ($string =~ /(ST Email List|Head Storyteller)/i) {
				 print $string, "\n";
			 }
		 }
		 print "\n";
	}
}
