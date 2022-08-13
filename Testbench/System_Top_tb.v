`timescale 1ns/1ns

module System_Top_tb (); 

parameter  WIDTH = 8 , 
           ADDR = 4 , 
		   ALU_FUN_WD = 4 ;
		   
		   
parameter CLK_PERIOD = 50 ;           //  Frequency 20 MHz
		   

reg                 CONTROL_EN_TB;
reg                 CLKDIV_EN_TB;
reg                 CLK_TB;
reg                 RST_TB;
reg                 WrEn_TB;
reg                 RdEn_TB;
reg   [ADDR-1:0]    Address_TB;
reg   [WIDTH-1:0]   WrData_TB;
wire  [WIDTH-1:0]   RdData_TB;
wire                SYS_OUT_TB;
wire                SYS_VLD_TB;



//Initial 
initial
 begin

//initialization
initialize() ;

//Reset the design
reset();

//Register Write Operations
do_write('d0,'h0D) ;                      // ALU Operand A        
do_write('d1,'h0C) ;                      // ALU Operand B
do_write('d2,'hFF) ;                      // ALU Config0
do_write('d3,'hFF) ;                      // ALU Config1
do_write('d4,'h03) ;                      // UART Config
do_write('d5,'h01) ;                      // DIV RATIO



//Enable System Finite state machine
#200
CONTROL_EN_TB = 1'b1 ;   

#12000 ;
CONTROL_EN_TB = 1'b0 ; 
//$stop ;

end


////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize ;
 begin
  CONTROL_EN_TB = 1'b0;
  CLKDIV_EN_TB = 1'b1;
  CLK_TB = 1'b0;
  RST_TB = 1'b1;
  WrEn_TB = 1'b0;
  RdEn_TB = 1'b0;
  Address_TB = 'b0;
  WrData_TB = 'b0;
 end
endtask

///////////////////////// RESET /////////////////////////

task reset ;
 begin
  RST_TB = 1'b1  ;  
  #10
  RST_TB = 1'b0  ;  
  #10
  RST_TB = 1'b1  ;  
 end
endtask

////////////////// Do write Operation ////////////////////

task do_write ;
 input  [ADDR-1:0]     address ;
 input  [WIDTH-1:0]    data ;
 
 begin
  #CLK_PERIOD
  WrEn_TB = 1'b1;
  RdEn_TB = 1'b0 ;
  Address_TB = address;
  WrData_TB = data;
 end
endtask

/*
/////////////// Do read Operation & Check /////////////////

task do_read_and_check ;
 input  [ADDR-1:0]     address ;
 input  [WIDTH-1:0]    expected_data ;
 
 begin

 #10
 WrEn_TB = 1'b0 ;
 RdEn_TB = 1'b1 ;
 Address_TB = address;
 #10
  if(RdData_TB != expected_data)
    $display("READ Operation IS Failed");
  else
   $display("READ Operation IS Passed");
 
 end
endtask

*/

////////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////

always #(CLK_PERIOD/2) CLK_TB = ~CLK_TB ;       


////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////
System_Top DUT (
.CLK(CLK_TB),
.RST(RST_TB),
.RdEn(RdEn_TB),
.WrEn(WrEn_TB),
.Address(Address_TB),
.WrData(WrData_TB),
.RdData(RdData_TB),
.CONTROL_EN(CONTROL_EN_TB),
.CLKDIV_EN(CLKDIV_EN_TB),
.SYS_OUT(SYS_OUT_TB),
.SYS_VLD(SYS_VLD_TB)
);

endmodule