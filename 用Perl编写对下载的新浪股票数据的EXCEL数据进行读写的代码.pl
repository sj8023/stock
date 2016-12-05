my $dumpFileName = 'abc3.xls';
my @args = stat("$dumpFileName");
my $sizeOfFile = $args[7];


if ($sizeOfFile > 500)
{
 print join(",",localtime()),"\n";   #sidney
 my $book = Spreadsheet::ParseExcel::Workbook->Parse( $dumpFileName);
 my @sheets = @{ $book->{Worksheet} };  
 foreach my $sheet (@sheets )
 {      
  my $sheetName = $sheet->get_name();      
  print "work sheet: $sheetName\n";  #sidney       
  my ( $minRow, $maxRow ) = $sheet->row_range();      
  my ( $minCol, $maxCol) = $sheet->col_range();        
  foreach my $row ( $minRow .. $maxRow )
  {        
   my $cell;      
   $cell = $sheet->get_cell( $row, $timeindex );       
   $tempTime = $cell->value;  
   my @arraya = ($tempTime =~/(\d+)/g);
   #:,$tempTime);       print @arraya;      
   $tempTimeNum = $arraya[0]*10000+$arraya[1]*100+$arraya[2];      
   print $tempTimeNum;      # sidney
   #$tempTime = ~s/\://g;      
   $cell = $sheet->get_cell( $row, $priceindex );       
   $tempPrice = $cell->value;      
   $cell = $sheet->get_cell( $row, $volumeindex );       
   $tempVolume = $cell->value;      
   print "timedata, pricedata, vluemedata: $tempTimeNum $tempPrice $tempVolume \n";        #sidney    
  }
   
 }
}

unlink $dumpFileName;
print join(",",localtime()),"\n";   #sidney
