
module RegFile #(parameter WIDTH = 8, DEPTH = 16, ADDR = 4 )

(
input    wire                CLK,
input    wire                RST,
input    wire                WrEn,
input    wire                RdEn,
input    wire   [ADDR-1:0]   Address,
input    wire   [WIDTH-1:0]  WrData,
output   reg    [WIDTH-1:0]  RdData,
output   wire   [WIDTH-1:0]  REG0,
output   wire   [WIDTH-1:0]  REG1,
output   wire   [WIDTH-1:0]  REG2,
output   wire   [WIDTH-1:0]  REG3,
output   wire   [WIDTH-1:0]  REG4,
output   wire   [WIDTH-1:0]  REG5
);

integer I ; 
  
// register file of 8 registers each of 16 bits width
reg [WIDTH-1:0] regArr [DEPTH-1:0] ;    

always @(posedge CLK or negedge RST)
 begin
   if(!RST)  // Asynchronous active low reset 
    begin
      for (I=0 ; I < DEPTH ; I = I +1)
        begin
          regArr[I] <= 0 ;
        end
     end
   else if (WrEn && !RdEn) // Register Write Operation
     begin
      regArr[Address] <= WrData ;
     end
   else if (RdEn && !WrEn) // Register Read Operation
     begin    
       RdData <= regArr[Address] ;
     end        
  end

assign REG0 = regArr[0] ;
assign REG1 = regArr[1] ;
assign REG2 = regArr[2] ;
assign REG3 = regArr[3] ;
assign REG4 = regArr[4] ;
assign REG5 = regArr[5] ;


endmodule