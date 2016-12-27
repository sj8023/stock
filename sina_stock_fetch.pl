#!/usr/bin/perl -w
use strict;
use warnings;
use Carp;
use LWP::UserAgent;
use Getopt::Std;
use Encode;
use constant MAXNUMBER => 500;
use constant LINE => 30;
use constant PROXY => 'http://192.168.178.241';
$| = 1;

my %opts;
getopts('cdfm:', \%opts);

my %market = (
        sh => sub {map {"sh$_"} ('600001' .. '602100')},
        sz => sub {map {"sz$_"} ('000001' .. '001999')},
        zx => sub {map {"sz$_"} ('002001' .. '002999')},
        cy => sub {map {"sz$_"} ('300001' .. '300400')},
);

my @defaultstock = qw(sh601818 sz300229 sz002649 sz002368 sh600667 sz000858);

if($opts{c}){
        system 'cls';
}
my $func = $opts{f} ? \&DrawStock : \&DrawMarket;
my @stock;
if($opts{d}){
        @stock = @defaultstock;
}
elsif($opts{m} && exists $market{lc $opts{m}}){
        @stock = $market{lc $opts{m}}->();
}
else{
        @stock =  grep {/s[hz]\d{6}/} map {lc} @ARGV;
}
Stocks($func,@stock) if @stock;


sub Stocks{
        my $drawfunc = shift;
       
        my @stocklist = grep {/s[hz]\d{6}/i} map {lc} @_;
        return unless @stocklist;
       
        while(my @tmp = splice @stocklist,0,MAXNUMBER){
                my $strs = GetStockValue(@tmp);
                for(split /;/,$strs){
                        my ($code,$value) = /hq_str_(s[hz]\d{6})="([^"]*)"/;
                        if($value){
                                $drawfunc->($code,$value);
                        }
                }
        }
}
sub GetStockValue{
        croak "Length > MAXNUMBER" if @_>MAXNUMBER;
       
        my $ua = LWP::UserAgent->new();
       
       
        my $res = $ua->get("http://hq.sinajs.cn/list=".join(',',@_));
        if($res->is_success){
                return $res->content;
        }
}
sub DrawMarket{
        my ($stockcode,$value) = @_;
        my @list = split /,/, $value;
       
        $^ = "MARKET_TOP";
        $~ = "MARKET";
        $= = LINE+3;
        write;
       
        format MARKET_TOP =
code     name          current (   +/-       %)    open   close          low(ch)        high(ch)  S(W)    $(W) [             buy <=>   sell          ]
======================================================================================================================================================
.
        format MARKET =
@<<<<<<< @<<<<<<<<<<<< @###.## (@##.## @##.##%) @###.## @###.## @###.## (@##.##) @###.## (@#.##) @#### @###### [@########@###.## <=>@###.##@######## ]
$stockcode,$list[0],$list[3],$list[3]-$list[2],$list[2]>0?($list[3]-$list[2])*100/$list[2]:0,$list[1],$list[2],$list[5],$list[5]-$list[2],$list[4],$list[4]-$list[2],$list[8]/10000,$list[9]/10000,$list[10],$list[11],$list[21],$list[20],
.
}
sub DrawStock{
        my ($stockcode,$value) = @_;
        my @list = split /,/, $value;
        $list[0] = encode ("utf8", decode ("gb2312", $list[0]));
        $~ = "STOCK";
        write;
        format STOCK =
=====================================================================
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<@>>>>>>>>>>>>>>>>>>
"$stockcode: $list[0]","$list[30] $list[31]",
=====================================================================
current:@###.## (@##.##@##.##%) |@########@###.## <=>@###.##@########
$list[3],$list[3]-$list[2],$list[2]>0?($list[3]-$list[2])*100/$list[2]:0,$list[10],$list[11],$list[21],$list[20],
close:  @###.##                 |@########@###.## <=>@###.##@########
$list[2],$list[12],$list[13],$list[23],$list[22],
open:   @###.##                 |@########@###.## <=>@###.##@########
$list[1],$list[14],$list[15],$list[25],$list[24],
low:    @###.## (@##.##)        |@########@###.## <=>@###.##@########
$list[5],$list[5]-$list[2],$list[16],$list[17],$list[27],$list[26],
high:   @###.## (@##.##)        |@########@###.## <=>@###.##@########
$list[4],$list[4]-$list[2],$list[18],$list[19],$list[29],$list[28],
S(W):    @#####                 |------------------------------------
$list[8]/10000,
$(W):    @#####                 |@########                  @########
$list[9]/10000,$list[10]+$list[12]+$list[14]+$list[16]+$list[18],$list[20]+$list[22]+$list[24]+$list[26]+$list[28],
.
}
