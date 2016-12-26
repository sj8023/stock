#! /usr/bin/perl
use LWP 5.64;
use LWP::Simple;
open(ss,">shanghai_stock_history_data.txt");
open(sz,">shenzhen_stock_history_data.txt");
open(list,"list.txt");
my %ss;
my %sz;
while(<list>){
   chomp;
   my @line=split(/\t/,$_);
   if($line[0]=~/ss/){$ss{$line[2]}=$_;
    
    };
   if($line[0]=~/sz/){$sz{$line[2]}=$_;
    
    };
 }
 
foreach(keys %ss){
print ss "\n\n\n$_\t$ss{$_}\n";
eval{my $url = ‘http://table.finance.yahoo.com/table.csv?s=&#8217;;
my $url="$url$_\.ss";
my $content = get $url;
##die "Couldn’t get $url" unless defined $content;
print ss "$content";
}
}
foreach(keys %sz){
print sz "\n\n\n$_\t$sz{$_}\n";
eval{my $url = ‘http://table.finance.yahoo.com/table.csv?s=&#8217;;
my $url="$url$_\.sz";
my $content = get $url;
###die "Couldn’t get $url" unless defined $content;
print sz "$content";
}
}
 
 
 
附注：list.txt为股票名称的list，格式如下;
ss     * 上证综指代码 000001
ss     * 沪深300代码 000300
ss     * 中国石化 600028
ss     * 南方航空 600029
sz     * 杭汽轮Ｂ 200771
sz     * 张裕Ｂ 200869
