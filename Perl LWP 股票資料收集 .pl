view source
print
?
01.
# 抓取網頁中的 link
02.
use LWP;
03.
use HTML::TreeBuilder;
04.
use Text::Iconv;
05.
 
06.
# 取得命令列中的網頁位址，放入 $url 中
07.
#my $url=shift || die "您沒有輸入 url 網址!\n";
08.
my $stock=2357;
09.
if(defined $ARGV[0]){
10.
$stock=$ARGV[0];
11.
}
12.
my $url="http://tw.stock.yahoo.com/d/s/dividend_".$stock.".html";
13.
 
14.
my $ua=LWP::UserAgent->new;
15.
my $res=$ua->get($url);
16.
die "Can't get $url ", $res->status_line unless $res->is_success;
17.
my $html=$res->content;
18.
 
19.
$converter = Text::Iconv->new("big5", "utf8");
20.
$html = $converter->convert("$html");
21.
#print "$html\r\n";
22.
 
23.
my $root=HTML::TreeBuilder->new_from_content($html);
24.
 
25.
my @names=$root->look_down(_tag=>'TITLE');
26.
 
27.
foreach my $line(@names){
28.
my $name=$line->as_trimmed_text;
29.
my @items=split(/\-/,$name);
30.
print $items[0],",",$items[1],",\r\n";
31.
}
32.
 
33.
my @links=$root->look_down(
34.
_tag=>'table',
35.
);
36.
for($j=0; $j<=$#links; $j++){
37.
if($j == 9){
38.
#print "\t$j=", $links[$j]->attr('href'),' ', $links[$j]->as_trimmed_text, "\r\n";
39.
my @items=$links[$j]->look_down(_tag=>'tr');
40.
#print "Item $j\r\n";
41.
foreach my $item(@items){
42.
my @datas=$item->look_down(_tag=>'td');
43.
foreach my $data(@datas){
44.
my $tmp=$data->as_trimmed_text;
45.
$tmp =~ s/\ //ge;
46.
$tmp =~ s/\　//ge;
47.
print $tmp,",";
48.
}
49.
print "\r\n";
50.
#print "$j\t", $item->as_trimmed_text,"\r\n";
51.
}
52.
#print "$j=", $links[$j]->as_trimmed_text, "\r\n";
53.
}
54.
}
55.
$root->delete;

這個程式是先跑去抓某個網頁的股票代碼列表(有點舊)然後再去呼叫上面那一支程式把歷史股利政策全抓下來。

