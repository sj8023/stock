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


=head
Get stock information from QQ
=cut
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

输出：



    上一个：Perl的错误处理（1）下一个：[Perl]用log4perl记录日志 

用户评论
登录
我的社区
有事没事说两句...

    评论

1人参与,1条评论

    最新评论

2016年7月23日 7:43 宣璇亲

我只看看
回复
查看更多
ThinkSAAS正在使用畅言
去社区看看吧

    Python之多线程_python_ThinkSAAS
    Python之多线程_python_ThinkSAAS
    Python网络数据采集系列-------概述_python_ThinkSAAS
    Python网络数据采集系列-------概述_python_ThinkSAAS
    抢哪个？诺基亚Lumia920/820/720/620/520合影_开源资讯_ThinkSAAS
    抢哪个？诺基亚Lumia920/820/720/620/520合影_开源资讯_ThinkSAAS
    log4php0.9的详细配置实例说明_PHP教程_ThinkSAAS
    log4php0.9的详细配置实例说明_PHP教程_ThinkSAAS

    Python之多线程_python_ThinkSAAS
    Python网络数据采集系列-------概述_python_ThinkSAAS
    抢哪个？诺基亚Lumia920/820/720/620/520合影_开源资讯_ThinkSAAS
    log4php0.9的详细配置实例说明_PHP教程_ThinkSAAS

热评话题

    log4php0.9的详细配置实例说明_PHP教程_ThinkSAAS
    Linux系统Apache用户授权和拜访把持_PHP教程_ThinkSAAS
    撑不住了，新浪微博支持分享到微信和来往_热点聚合_ThinkSAAS
    jQuery TagBox下载和文档_开源软件_ThinkSAAS
    内存：C/C++编程的重要概念_C++,C语言_ThinkSAAS
    jquery fx分析_Jquery_ThinkSAAS
    SpringMVC+Hibernate+Spring整合（二）_Java_ThinkSAAS

perl学习最新帖子

    Perl生成隨機密碼
    Perl写的查单词利器
    在window平台下自动截屏
    $& $` $' 格式匹配
    Perl 菜鸟解决"易语言难题”  
    kickstart file generate tool use cgi
    动态生成pxelinux菜单文件及kickstart安装脚本
    单体评价手顺书生成工具0.1版
    postfix邮件日志分析工具pflogsumm 分析结果导入数据库
    perl子进程给父进程传数据

perl学习热门帖子

    Perl使用Tesseract-OCR实现验证码识别教程
    Perl内置特殊变量总结
    Perl中的特殊内置变量详细介绍
    perl实现的两个文件对比并对数据进行筛选的脚本代码
    perl哈希的一个实例分析
    perl用{}修饰变量名的写法分享
    Linux/Unix下安装Perl模块的两种方法分享
    perl ping检测功能脚本代码
    Perl操作系统环境变量的脚本代码
    Perl中处理时间的几个函数

