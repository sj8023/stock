#!/usr/bin/perl -w
use strict;
use warnings;
use LWP::Simple;
use HTML::TableExtract;
use Encode;
my $stock = $ARGV[0];
my $html = get("http://money.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/$stock.phtml");
my $html2 = encode("utf8",decode("gbk",$html));
my $te = HTML::TableExtract->new();
$te -> parse($html2);
my $table = $te-> first_table_found;
my @history;
foreach my $ts($te->tables){
foreach my $row ($ts->rows){
if ($ts->coords == 18){
push(@history, join(',',@$row));
}
}
}
my $filename = "stock_history.txt";
my $fh;
open $fh, '>', $filename or die "$0:failed to open input.file '$filename':$!\n";select $fh;
print @history;
close $fh or warn "$0:failed to close input.file '$filename':$!\n";

