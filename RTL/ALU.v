module ALU # ( parameter DATA_WIDTH = 8 , 
               parameter FUN_WIDTH = 4
) 
 (
  input wire [DATA_WIDTH-1:0]  A, B,
  input wire [FUN_WIDTH-1:0]   ALU_FUN,
  input wire                   CLK,
  input wire                   RST,
  input wire                   Enable,
  output reg [DATA_WIDTH-1:0]  ALU_OUT,
  output reg                   OUT_VALID
);
  

//internal_signals  
  reg   [DATA_WIDTH-1:0]  ALU_OUT_Comb;
  reg                     OUT_VALID_Comb;


always @(posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    ALU_OUT <= 'b0 ;
    OUT_VALID <= 'b0 ;
   end
  else
   begin
    ALU_OUT <= ALU_OUT_Comb;
    OUT_VALID <= OUT_VALID_Comb;
   end
 end  
  
always @(*)
 begin
  if(Enable)
   begin
     OUT_VALID_Comb = 1'b1 ;
     ALU_OUT_Comb = 1'b0 ;
    case (ALU_FUN) 
    4'b0000: begin
               ALU_OUT_Comb = A+B;
              end
    4'b0001: begin
               ALU_OUT_Comb = A-B;
              end
    4'b0010: begin
               ALU_OUT_Comb = A*B;
              end
    4'b0011: begin
               ALU_OUT_Comb = A/B;
              end
    4'b0100: begin
               ALU_OUT_Comb = A & B;
              end
    4'b0101: begin
               ALU_OUT_Comb = A | B;
              end
    4'b0110: begin
               ALU_OUT_Comb = ~ (A & B);
              end
    4'b0111: begin
               ALU_OUT_Comb = ~ (A | B);
              end     
    4'b1000: begin
               ALU_OUT_Comb =  (A ^ B);
              end
    4'b1001: begin
               ALU_OUT_Comb = ~ (A ^ B);
              end           
    4'b1010: begin
              if (A==B)
                 ALU_OUT_Comb = 16'b1;
              else
                 ALU_OUT_Comb = 16'b0;
              end
    4'b1011: begin
               if (A>B)
                 ALU_OUT_Comb = 16'b1;
               else
                 ALU_OUT_Comb = 16'b0;
              end 
    4'b1100: begin
               if (A<B)
                 ALU_OUT_Comb = 16'b11;
               else
                 ALU_OUT_Comb = 16'b0;
              end     
    4'b1101: begin
              ALU_OUT_Comb = A>>1;
             end
    4'b1110: begin 
              ALU_OUT_Comb = A<<1;
             end
    default: begin
	       OUT_VALID_Comb = 1'b1 ;
               ALU_OUT_Comb = 16'b0;
             end
    endcase
   end
  else
   begin
    OUT_VALID_Comb = 1'b0 ;
    ALU_OUT_Comb = 16'b0;
   end
 end
  
  

endmodule