#!/usr/bin/perl -w
use strict;
use LWP::UserAgent;
open OUTPUT,'>','weblist.txt' or die 'weblist.txt error!';
my $get_page = LWP::UserAgent -> new;
$get_page -> timeout(10);
my $page_addr = '';
my $response = '';
my $content = '';
my $pro_name = '';
my $pro_addr = '';
my $web_list = '';
&print_list();
sub print_list{
    foreach (1 .. 10 ){    #
        $page_addr = 'http://www.cheduoshao.com/gas/1_0_null_p'.$_.'.html';#此处是每页的网址
        $response = $get_page -> get( $page_addr );
        $content = $response -> content;
        print $_."done\n";
        $content =~ s#<!DOCTYPE.+?class="jy_6">##xs;
        while ( $content =~ s#class="width310">.+?href=".+?>(.+?)<.+?p>(.+?)<##xs){
            $pro_name = $1;
            $pro_addr = $2;
            print OUTPUT "$pro_name\t$pro_addr\n";
        }

    }
}
