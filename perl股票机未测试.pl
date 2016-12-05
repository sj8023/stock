#!/user/bin/perl -w
#第一版

#By xti9er www.xtiger.net


use LWP::Simple;
use Color::Output;
use encoding 'gb2312';
Color::Output::Init;

START:
system("cls");
`title --= M y S t o c k S c r e e n e r =--`;
cprin("\tM y S t o c k S c r e e n e r\n\n",7);

cprin("_"x50,13);

$|=1;

if(my $googled=get("http://www.google.cn/finance/info?q=id-690158,id-684321,id-684268,id-697176,id-702734,id-684353,id-709933,id-706853,id-690427,id-697980&infotype=infoquoteall&hl=zh-CN&gl=cn"))
{
    my @info=split(/\,/,$googled);
    print "\n股票码\t开盘价\t最高价\t最低价\t涨跌\t名称\n";
    for my $newinfo(@info)
    {
        if ($newinfo=~/\"(.*)\"\s\:\s\"(.*)\"/)
        {
            my $infot=$1;
            my $infoc=$2;
            next if $infot=~/avvo|ccol|l_cur|lt|fwpe|beta|lo52|hi52/;
            if($infot eq "t"){$t=$infoc}
            if($infot eq "op"){$op=$infoc}
            if($infot eq "hi"){$hi=$infoc}
            if($infot eq "lo"){$lo=$infoc}
            if($infot eq "cp"){$cp=$infoc}
            if($infot eq "lname"){$lname=$infoc}
            if ($infot eq "type")
            {
                print "$t\t";
                print "$op\t";
                cprin("$hi\t",($hi-$op)>0?5:7);
                cprin("$lo\t",($lo-$op)>0?5:7);
                cprin("$cp\t",$cp>0?5:7);
                print "$lname\n";
                print "-----------\n";
            }
        }
    }
}
else
{
    cprin("\n[!] GetInfo Fail\n",5);
}

sleep 10;
goto START;
print "\n","+"x50,"\n";

sub cprin
{
    ($str,$i)=@_;
    cprint("\x03" . $i . " $str\x030


#!/usr/bin/perl -w

#第二版支持代理

#By xti9er www.xtiger.net



use LWP::Simple;
use LWP::UserAgent;
use Color::Output;
Color::Output::Init;

$|=1;
my $fst=0;
my $stimeout;
my $googleq="";
my $nowsc=0;
#my (@scode,@sc,@spr);


#my (@scode,@sc,@spr);


#$scode="0";


my %sc=("","");
my %spr=("","");

system("clear");
#`title --= M y S t o c k S c r e e n e r =--`;



    my $ua = LWP::UserAgent->new;
    #$ua->proxy('http', 'http://172.21.148.5:25880');


    #$ua->max_size( 8192 );


    $ua->env_proxy;

if($fst==0)
{
    cprin("\n程序开始初始化",13);
    my @gettime=localtime();
    if($gettime[2]>15 or $gettime[2]<9){$stimeout=1}
    else{$stimeout=0}

    open(ST,"st.ini") or die $!;
    while(my $info=<ST>)
    {
        chomp($info);
        next if $info=~/^#/;



        ($scode_t,$spr_t,$sc_t)=split(/=/,$info);
        if ($scode_t eq "" or $spr_t eq "" or $sc_t eq "") {die "\n请正确填写需要查看的股票在st.ini中,格式 股票代码=持有价格=持有量\n"}
        $sc{$scode_t}=$sc_t;
        $spr{$scode_t}=$spr_t;
        $googleq=$scode_t.",$googleq";
        #print "$googleq\n";


    }
    $allst=scalar(@scode);
    $fst=1;
    if($googleq eq "") {die "\n请正确填写需要查看的股票在st.ini中,格式 股票代码=持有价格=持有量\n"}

#for(@scode)


#{


# if(my $nowcode=getcode($_))


# {


# $googleq=$googleq."id-$nowcode,";


# print ".";


# }


# else{next;}


#}


    #print "$googleq\n";



}

sub getcode
{
    my $newst=shift;
    my $nowcode=$ua->get("http://www.google.cn/finance?q=$newst");
    $nowcode=$nowcode->as_string;
    if($nowcode=~/<span\sclass=\"pr\"\sid=\"ref_(\d+)_l\"\>/)
    {
        return $1;
    }
    else
    {
        return 0;
    }
}

START:
my $googled;
if($googled=$ua->get("http://www.google.cn/finance/info?q=$googleq&infotype=infoquoteall&hl=zh-CN&gl=cn") and $googled->is_success)
{
        system("clear");
cprin("\tM y S t o c k S c r e e n e r\n\n",7);
cprin("_"x60,13);
        print "\n当前时间：".scalar(localtime())."\n";
            print "\n股票码\t开盘价\t成本价\t持有量\t",$stimeout=0?"当前价\t":"收盘价\t","涨跌\t盈亏\t名称\n";
    my @info=split(/\,/,$googled->as_string);
    #my @info=split(/\}\s,\{/,$for_tt);
    for my $newinfo(@info)
    {
        #print "$newinfo\n";
        #$nowsc=0 if $nowsc>$allst-1;
        my @info1=split(/,/,$newinfo);
      for my $newinfo1(@info1)
      {
        if ($newinfo1=~/\"(.*)\"\s*\:\s*\"(.*)\"/)
        {
            #print "$newinfo+++\n";
            my $infot=$1;
            my $infoc=$2;
            #print "1==$infot,2==$infoc\n";
            next if $infot=~/avvo|ccol|l_cur|lt|fwpe|beta|lo52|hi52/;
            if($infot eq "t"){$t=$infoc}
            if($infot eq "op"){$op=$infoc}
            #if($infot eq "hi"){$hi=$infoc}
            #if($infot eq "lo"){$lo=$infoc}
            if($infot eq "l"){$l=$infoc}
            if($infot eq "c"){$c=$infoc}
            if($infot eq "cp"){$cp=$infoc}
            if($infot eq "lname"){$lname=$infoc}
            if($infot eq "id"){$cursc=$infoc}
            
            if ($infot eq "type")
            {
                print "$t\t";
                print "$op\t";
                #cprin("$hi\t",($hi-$op)>0?5:7);
                #cprin("$lo\t",($lo-$op)>0?5:7);
                #cprin("$l\t",($l-$op)>0?5:7);
                #my $gl=int($sc[$nowsc] * ($l-$spr[$nowsc]));
                #cprin("$gl\t",$gl>0?5:7);
                print("$spr{$t}\t");
                print("$sc{$t}\t");
                print("$l\t");
                cprin("$c\t",$c>0?5:7);
                cprin(($l-$spr{$t})*$sc{$t}-($l*$sc{$t}/1000)."\t",($l-$spr{$t})*$sc{$t}-($l*$sc{$t}/1000)>0?5:7);
                print "$lname\n";
                print "-----------\n";
                $nowsc++;
            }
        }
      }
    }
}
else
{
    cprin("\n[!] GetInfo Fail\n",5);
}

sleep 10;
goto START;

sub cprin
{
    ($str,$i)=@_;
    cprint("\x03" . $i . " $str\x030)
 
 
 
 
 
 
 
 
 

#!/user/bin/perl -w
# 带ini文件配置
#By xti9er www.xtiger.net

use LWP::Simple;
use Color::Output;
Color::Output::Init;

$|=1;
my $fst=0;
my $stimeout;
my $googleq="";
my $nowsc=0;
my (@scode,@sc,@spr);

START:
system("cls");
`title --= M y S t o c k S c r e e n e r =--`;
cprin("\tM y S t o c k S c r e e n e r\n\n",7);
cprin("_"x60,13);
if($fst==0)
{
    cprin("\n程序开始初始化",13);
    my @gettime=localtime();
    if($gettime[2]>15 or $gettime[2]<9){$stimeout=1}
    else{$stimeout=0}

    open(ST,"st.ini") or die $!;
    while(my $info=<ST>)
    {
        chomp($info);
        next if $info=~/^#/;


        my ($scode,$sc,$spr)=split(/=/,$info);
        push(@scode,$scode);
        push(@sc,$sc);
        push(@spr,$spr);
    }
    $allst=scalar(@scode);
    $fst=1;

for(@scode)
{
    if(my $nowcode=getcode($_))
    {
        $googleq=$googleq."id-$nowcode,";
        print ".";
    }
    else{next;}
}
    #print "$googleq\n";


    goto START;
}

sub getcode
{
    my $newst=shift;
    my $nowcode=get("http://www.google.cn/finance?q=$newst");
    if($nowcode=~/<span\sclass=\"pr\"\sid=\"ref_(\d+)_l\"\>/)
    {
        return $1;
    }
    else
    {
        return 0;
    }
}

print "\n当前时间：".scalar(localtime())."\n";
cprin("_"x60,13);

if(my $googled=get("http://www.google.cn/finance/info?q=$googleq&infotype=infoquoteall&hl=zh-CN&gl=cn"))
{
    my @info=split(/\,/,$googled);
    print "\n股票码\t开盘价\t成本价\t持有量\t",$stimeout=0?"当前价\t":"收盘价\t","涨跌\t盈亏\t名称\n";
    for my $newinfo(@info)
    {
        #print "$newinfo\n";
        $nowsc=0 if $nowsc>$allst-1;
        if ($newinfo=~/\"(.*)\"\s\:\s\"(.*)\"/)
        {
            my $infot=$1;
            my $infoc=$2;
            next if $infot=~/avvo|ccol|l_cur|lt|fwpe|beta|lo52|hi52/;
            #print "$infot=$infoc\n";
            if($infot eq "t"){$t=$infoc}
            if($infot eq "op"){$op=$infoc}
            #if($infot eq "hi"){$hi=$infoc}
            #if($infot eq "lo"){$lo=$infoc}
            if($infot eq "l"){$l=$infoc}
            if($infot eq "cp"){$cp=$infoc}
            if($infot eq "lname"){$lname=$infoc}
            
            if ($infot eq "type")
            {
                print "$t\t";
                print "$op\t";
                #cprin("$hi\t",($hi-$op)>0?5:7);
                #cprin("$lo\t",($lo-$op)>0?5:7);
                print "$spr[$nowsc]\t";
                print "$sc[$nowsc]\t";
                cprin("$l\t",($l-$op)>0?5:7);
                cprin("$cp\t",$cp>0?5:7);
                my $gl=int($sc[$nowsc] * ($l-$spr[$nowsc]));
                cprin("$gl\t",$gl>0?5:7);
                print "$lname\n";
                print "-----------\n";
                $nowsc++;
            }
        }
    }
}
else
{
    cprin("\n[!] GetInfo Fail\n",5);
}

sleep 10;
goto START;

sub cprin
{
    ($str,$i)=@_;
    cprint("\x03" . $i . " $str\x030);}


#################################
#1、配置文件st.ini
#内容格式如下：
#
#股票代码=成本价=持有量
#600000=****=39.513
#600022=****=4.169
#600690=****=10.186
#
#2、根据配置文件中的关注股票和持有信息，计算当前盈利状况
#################################