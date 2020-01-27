//******************************************************************************
//
//******************************************************************************

module vlog2mif ();

string str1 = "";
integer i, f1, f2, code;

initial
begin
 f1 = $fopen ("test.txt", "r");
 f2 = $fopen ("test.mif", "w");
 i = 0;
 
 $fdisplay(f2, "\n");
 $fdisplay(f2, "\n");
 $fdisplay(f2, "WIDTH=32;");
 $fdisplay(f2, "DEPTH=256;");
 
 $fdisplay(f2, "\n");
 $fdisplay(f2, "ADDRESS_RADIX=HEX;");
 $fdisplay(f2, "DATA_RADIX=HEX;");
 $fdisplay(f2, "\n");
 
 $fdisplay(f2, "   CONTENT   BEGIN");
 
 while ($fgets(str1, f1)) 
 begin
	 $fwrite(f2, "    %3h   :   %s", i, str1);
     i = i + 1;
 end
// while ( i !=255)
// begin
//     $fwrite(f2, "    %3h   :   FFFFFFFF\n", i);
//	 i = i+1;
// end


$fdisplay(f2, "END;");
 
 #1ns;
 $display ("i = %d.vlog2mif is done.", i);
 $fclose (f1);
 $fclose (f2);
end

endmodule

