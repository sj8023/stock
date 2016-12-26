use utf8;
use Encode;

use strict;
use warnings;
use LWP::UserAgent;
use threads (exit => 'threads_only',);
use threads::shared;

use constant URL	=> 'http://qt.gtimg.cn/q=';
use constant PROXY	=> 'http://10.40.14.56:80'; #使用代理修改此处并去掉下边代码中的注释
use constant MAXNUMBER	=> 50; #腾讯每次最多取60个左右的股票信息，设置一个整数，HTTP GET中使用

use constant CONFIG	=> 'detail';
use constant COLUMN	=> qw(1 2 3 4 5 7 8 10 9 19 20 31 32 36 37 38 39 46 44 45); #要显示的列，自己根据需要修改
use constant ORDER	=> 2; #要排序的列

my @result : shared 	= ();
my @stocklist 		= (
	sub { map {"sh$_"} ('600001' .. '602100') }->(),
	sub { map {"sz$_"} ('000001' .. '001999') }->(),
	sub { map {"sz$_"} ('002001' .. '002999') }->(),
	sub { map {"sz$_"} ('300001' .. '300400') }->(),
);

my %config = (
	detail => {
		method => sub { @_ },
		0 	=> '未知',
		1 	=> '名字',
		2 	=> '代码',
		3 	=> '当前价格',
		4 	=> '昨收',
		5 	=> '今开',
		6 	=> '成交量',
		7 	=> '外盘',
		8 	=> '内盘',
		9 	=> '买一',
		10 	=> '买一量',
		19 	=> '卖一',
		20 	=> '卖一量',
		29 	=> '最近逐笔成交',
		30 	=> '时间',
		31 	=> '涨跌',
		32 	=> '涨跌%',
		33 	=> '最高',
		34 	=> '最低',
		35 	=> '价格/成交量（手）/成交额',
		36 	=> '成交量',
		37 	=> '成交:万',
		38 	=> '换手率%',
		39 	=> '市盈率',
		40 	=> '',
		41 	=> '最高',
		42 	=> '最低',
		43 	=> '振幅%',
		44 	=> '流通市值',
		45 	=> '总市值',
		46 	=> '市净率',
		47 	=> '涨停价',
		48 	=> '跌停价',
	},
);

GetStocks();
@result = sort { ($a->[ORDER] || 0) <=> ($b->[ORDER] || 0) } @result; #可以使用grep添加更多过滤条件
PrintStock();

sub GetStockInfomation{
	return unless @_;
	
	my $ua = LWP::UserAgent->new();
	# $ua->proxy('http', PROXY);
	
	my $res = $ua->get(URL.join(',', $config{&CONFIG}{method}->(@_)));
	if($res->is_success){
		for(split /;/,$res->content){
			if(/"(.+)"/){
				my @tmp = split /~/,$1;
				push @result, shared_clone(@tmp);
			}
		}
	}
}

sub GetStocks{
	while(my @tmp = splice @stocklist,0,MAXNUMBER){
		threads->create(&GetStockInfomation, @tmp);
	}

	# $_->join() for threads->list();
	while(threads->list()){
		$_->join for threads->list(threads::joinable);
	}

}

=head
Print stock information
=cut
sub PrintStock{
	my $j = 0;
	for(@result){
		unless($j++ % MAXNUMBER){
			print "n";
			# for my $col (COLUMN){
			# 	printf "%10s",encode('gb2312',$config{&CONFIG}{$col});
			# }
			printf "%10s" x COLUMN, map {encode('gb2312',$config{&CONFIG}{$_})} COLUMN;
			print "n", '=' x 10 x COLUMN, "n";
		}
		# for my $col (COLUMN){
		# 	printf "%10s",$_->[$col];
		# }
		printf "%10s" x COLUMN, @$_[COLUMN];
		print "n";
	}

	print "nTotal: ",$#result;
}
