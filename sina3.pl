use HTML::TableExtract;
use Data::Dumper qw(Dumper);
my $html_string = join("", <DATA>);
$te = HTML::TableExtract->new();
$te->parse($html_string);
print Dumper($te), "\n";
foreach $ts ($te->tables) {
    print "Table (", join(',', $ts->coords), "):\n";
    foreach $row ($ts->rows) {
        print join(',', @$row), "\n";
    }
}

__DATA__
<table border="1" cellspacing="0" cellpadding="6">
  <tr><td><a href="x">x</a></td><td><a href="y">y</a></td></tr>
  <tr><td>1</td><td>2</td></tr>
</table>
