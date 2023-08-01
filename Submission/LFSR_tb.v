`timescale 1ns / 1ps

module LFSR_tb();

/*--------------------------------------------------------------------*/         
parameter Test_Cases = 10 ;
parameter clk_period =100; // 100ns == 10MHz
reg clk_tb = 0;
always #(clk_period/2) clk_tb = ~clk_tb;

integer Operation;
reg [7:0] gener_out ;

/*--------------------------------------------------------------------*/         
reg DATA_tb;
reg ACTIVE_tb;
reg RST_tb;
wire CRC_tb;
wire Valid_tb;

CRC DUT (  .DATA(DATA_tb),
            .ACTIVE(ACTIVE_tb),
            .CLK(clk_tb),
            .RST(RST_tb),
            .CRC(CRC_tb),
            .Valid(Valid_tb)
         ); 
/*--------------------------------------------------------------------*/ 
        
reg    [7:0]   Test_Data   [0:Test_Cases-1] ;
reg    [7:0]   Expec_Outs   [0:Test_Cases-1] ;
 
  
/*--------------------------------------------------------------------*/         

         
initial begin

$readmemh("DATA_h.txt", Test_Data);
$readmemh("Expec_Out_h.txt", Expec_Outs);  

  initialize() ;
  
 for (Operation=0 ; Operation<Test_Cases ; Operation=Operation+1)
  begin
   do_oper(Test_Data[Operation]) ; 
   check_out(Expec_Outs[Operation],Operation) ;      
  end
 #100;
 $finish ;     
end         
/*--------------------------------------------------------------------*/         

task reset ;
 begin
  RST_tb =  'b1;
  #(clk_period);
  RST_tb  = 'b0;
  #(clk_period);
  RST_tb  = 'b1;
 end
endtask
/*--------------------------------------------------------------------*/         

task initialize ;
 begin
  RST_tb  = 'b0;
  ACTIVE_tb = 'b0; 
  #(clk_period);
 
 end
endtask
/*--------------------------------------------------------------------*/         

task do_oper ;
 input [7:0] DATA_file ;
 integer i ;

 begin
   reset();
   #(clk_period);
   ACTIVE_tb = 1'b1;
   for(i=0 ; i<8 ; i=i+1) begin
   DATA_tb = DATA_file[i];
   #(clk_period);
   end
   ACTIVE_tb = 1'b0;
   #(clk_period);

 end
endtask
/*--------------------------------------------------------------------*/         

task check_out ;
 input  reg [7:0] expec_out ;
 input  integer  Oper_Num ; 
 integer j ;

 begin
  //@(posedge Valid_tb)
  for(j=0; j<8; j=j+1)
   begin
    gener_out[j] = CRC_tb ;
    #(clk_period) ;
   end
   if(gener_out == expec_out) 
    begin
     $display("Test Case %d is succeeded",Oper_Num);
    end
   else
    begin
     $display("Test Case %d is failed", Oper_Num);
    end
 end
endtask
endmodule
