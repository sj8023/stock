01.use strict;

02.use warnings;

03.use Carp;

04.use LWP::UserAgent;

05.use Getopt::Std;

06.

07.use constant MAXNUMBER => 500;

08.use constant LINE => 30;

09.use constant PROXY => 'http://10.40.14.56:80';

10.$| = 1; 

11.

12.my %opts;

13.getopts('cdfm:', \%opts);

14.

15.my %market = (

16.        sh => sub {map {"sh$_"} ('600001' .. '602100')},

17.        sz => sub {map {"sz$_"} ('000001' .. '001999')},

18.        zx => sub {map {"sz$_"} ('002001' .. '002999')},

19.        cy => sub {map {"sz$_"} ('300001' .. '300400')},

20.);

21.

22.my @defaultstock = qw(sh601818 sz300229 sz002649 sz002368 sh600667 sz000858);

23.

24.if($opts{c}){

25.        system 'cls';

26.}

27.my $func = $opts{f} ? \&DrawStock : \&DrawMarket;

28.my @stock;

29.if($opts{d}){

30.        @stock = @defaultstock;

31.}

32.elsif($opts{m} && exists $market{lc $opts{m}}){

33.        @stock = $market{lc $opts{m}}->();

34.}

35.else{

36.        @stock =  grep {/s[hz]\d{6}/} map {lc} @ARGV;

37.}

38.Stocks($func,@stock) if @stock;

39.

40.

41.sub Stocks{

42.        my $drawfunc = shift;

43.        

44.        my @stocklist = grep {/s[hz]\d{6}/i} map {lc} @_;

45.        return unless @stocklist;

46.        

47.        while(my @tmp = splice @stocklist,0,MAXNUMBER){

48.                my $strs = GetStockValue(@tmp);

49.                for(split /;/,$strs){

50.                        my ($code,$value) = /hq_str_(s[hz]\d{6})="([^"]*)"/;

51.                        if($value){

52.                                $drawfunc->($code,$value);

53.                        }

54.                }

55.        }

56.}

57.

58.sub GetStockValue{

59.        croak "Length > MAXNUMBER" if @_>MAXNUMBER;

60.        

61.        my $ua = LWP::UserAgent->new();

62.        #~ $ua->proxy('http', PROXY);

63.        

64.        my $res = $ua->get("http://hq.sinajs.cn/list=".join(',',@_));

65.        if($res->is_success){

66.                return $res->content;

67.        }

68.}

69.

70.sub DrawMarket{

71.        my ($stockcode,$value) = @_;

72.        my @list = split /,/, $value;

73.        

74.        $^ = "MARKET_TOP";

75.        $~ = "MARKET";

76.        $= = LINE+3;

77.        write;

78.        

79.        format MARKET_TOP = 

80.

81.code     name          current (   +/-       %)    open   close          low(ch)        high(ch)  S(W)    $(W) [             buy <=>   sell          ]

82.======================================================================================================================================================

83..

84.

85.        format MARKET = 

86.@<<<<<<< @<<<<<<<<<<<< @###.## (@##.## @##.##%) @###.## @###.## @###.## (@##.##) @###.## (@#.##) @#### @###### [@########@###.## <=>@###.##@######## ]

87.$stockcode,$list[0],$list[3],$list[3]-$list[2],$list[2]>0?($list[3]-$list[2])*100/$list[2]:0,$list[1],$list[2],$list[5],$list[5]-$list[2],$list[4],$list[4]-$list[2],$list[8]/10000,$list[9]/10000,$list[10],$list[11],$list[21],$list[20],

88..

89.}

90.

91.sub DrawStock{

92.        my ($stockcode,$value) = @_;

93.        my @list = split /,/, $value;

94.        

95.        $~ = "STOCK";

96.        write;

97.

98.        format STOCK = 

99.=====================================================================

100.@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<@>>>>>>>>>>>>>>>>>>

101."$stockcode: $list[0]","$list[30] $list[31]",

102.=====================================================================

103.current:@###.## (@##.##@##.##%) |@########@###.## <=>@###.##@########

104.$list[3],$list[3]-$list[2],$list[2]>0?($list[3]-$list[2])*100/$list[2]:0,$list[10],$list[11],$list[21],$list[20],

105.close:  @###.##                 |@########@###.## <=>@###.##@########

106.$list[2],$list[12],$list[13],$list[23],$list[22],

107.open:   @###.##                 |@########@###.## <=>@###.##@########

108.$list[1],$list[14],$list[15],$list[25],$list[24],

109.low:    @###.## (@##.##)        |@########@###.## <=>@###.##@########

110.$list[5],$list[5]-$list[2],$list[16],$list[17],$list[27],$list[26],

111.high:   @###.## (@##.##)        |@########@###.## <=>@###.##@########

112.$list[4],$list[4]-$list[2],$list[18],$list[19],$list[29],$list[28],

113.S(W):    @#####                 |------------------------------------

114.$list[8]/10000,

115.$(W):    @#####                 |@########                  @########

116.$list[9]/10000,$list[10]+$list[12]+$list[14]+$list[16]+$list[18],$list[20]+$list[22]+$list[24]+$list[26]+$list[28],

117.

118..

119.}
