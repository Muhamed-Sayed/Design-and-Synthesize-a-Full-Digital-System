
module FSM_Controller #(parameter WIDTH = 8 , ALU_FUN_WD = 4)(

input    wire                  CLK,
input    wire                  RST,
input    wire                  Enable,
input    wire [WIDTH-1:0]      ALU_Config0,
input    wire [WIDTH-1:0]      ALU_Config1,
input    wire                  UART_Busy,
output   reg  [ALU_FUN_WD-1:0] ALU_FUN,
output   reg                   ALU_Enable,
output   reg                   CLKG_EN
);

// gray state encoding
parameter   [4:0]      IDLE       = 5'b00000,
                       CHK_ADD    = 5'b00001,
					   CHK_SUB    = 5'b00010,
					   CHK_MULT   = 5'b00011,
					   CHK_DIV    = 5'b00100,
                       CHK_AND    = 5'b00101,
					   CHK_OR     = 5'b00110,
					   CHK_NAND   = 5'b00111,
					   CHK_NOR    = 5'b01000,
					   CHK_XOR    = 5'b01001,					   
					   CHK_XNOR   = 5'b01010,						   
					   CHK_EQ_CMP = 5'b01011,
					   CHK_GR_CMP = 5'b01100,
					   CHK_LS_CMP = 5'b01101,					   
					   CHK_SFT_R  = 5'b01110,
					   CHK_SFT_L  = 5'b01111,
					   CHK_NO_OP  = 5'b10000,
                       WAIT_BUSY_HIGH = 5'b10001,
                       WAIT_BUSY_LOW  = 5'b10010;					   
					   
reg         [4:0]      current_state , 
                       next_state ;
			
reg         [4:0]      state_flag ;
			
//state transiton 
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    current_state <= IDLE ;
   end
  else
   begin
    current_state <= next_state ;
   end
 end


// next state logic
always @ (*)
 begin
  CLKG_EN = 1'b1 ;  
  ALU_FUN = 'b0000 ;
  ALU_Enable = 1'b0 ;  
  case(current_state)
  IDLE      : begin
               CLKG_EN = 1'b1 ;  
			   ALU_FUN = 'b0000 ;
			   ALU_Enable = 1'b0 ;    
               if(Enable)
			    next_state = CHK_ADD ;
			   else
			    next_state = IDLE ; 			
              end
  CHK_ADD   : begin
               CLKG_EN = 1'b1 ; 
               if(ALU_Config0[0])
			    begin
				 ALU_FUN = 'd0 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;				 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;				
			     next_state = CHK_SUB ;               
                end			   
              end
  CHK_SUB   : begin
               CLKG_EN = 1'b1 ; 
               if(ALU_Config0[1])
			    begin
				 ALU_FUN = 'd1 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;				 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_MULT ;               
                end						
              end
  CHK_MULT  : begin
              CLKG_EN = 1'b1 ;  
               if(ALU_Config0[2])
			    begin
				 ALU_FUN = 'd2 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;				 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_DIV ;               
                end						
              end
  CHK_DIV   : begin
              CLKG_EN = 1'b1 ;  
               if(ALU_Config0[3])
			    begin
				 ALU_FUN = 'd3 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;				 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_AND ;               
                end						
              end
  CHK_AND   : begin
              CLKG_EN = 1'b1 ; 
               if(ALU_Config0[4])
			    begin
				 ALU_FUN = 'd4 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;						 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_OR ;               
                end						
              end
  CHK_OR    : begin
              CLKG_EN = 1'b1 ; 
               if(ALU_Config0[5])
			    begin
				 ALU_FUN = 'd5 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;					 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_NAND ;               
                end						
              end
  CHK_NAND  : begin
              CLKG_EN = 1'b1 ; 
               if(ALU_Config0[6])
			    begin
				 ALU_FUN = 'd6 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;						 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_NOR ;               
                end						
              end					   		  
  CHK_NOR  : begin
              CLKG_EN = 1'b1 ;   
               if(ALU_Config0[7])
			    begin
				 ALU_FUN = 'd7 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;						 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_XOR ;               
                end						
              end	
  CHK_XOR  : begin
              CLKG_EN = 1'b1 ;  
               if(ALU_Config1[0])
			    begin
				 ALU_FUN = 'd8 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;					 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_XNOR ;               
                end						
              end	
  CHK_XNOR  : begin
              CLKG_EN = 1'b1 ;  
               if(ALU_Config1[1])
			    begin
				 ALU_FUN = 'd9 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;					 
				end
			   else 
                begin
			     next_state = CHK_EQ_CMP ;               
                end						
              end	
  CHK_EQ_CMP : begin
               CLKG_EN = 1'b1 ;   
               if(ALU_Config1[2])
			    begin
				 ALU_FUN = 'd10 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;				 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_GR_CMP ;               
                end						
              end	
  CHK_GR_CMP : begin
               CLKG_EN = 1'b1 ;    
               if(ALU_Config1[3])
			    begin
				 ALU_FUN = 'd11 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;					 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_LS_CMP ;               
                end						
              end	
  CHK_LS_CMP : begin
               CLKG_EN = 1'b1 ; 
               if(ALU_Config1[4])
			    begin
				 ALU_FUN = 'd12 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;					 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_SFT_R ;               
                end						
              end
  CHK_SFT_R  : begin
               CLKG_EN = 1'b1 ;  
               if(ALU_Config1[5])
			    begin
				 ALU_FUN = 'd13 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;					 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_SFT_L ;               
                end						
              end
  CHK_SFT_L : begin
              CLKG_EN = 1'b1 ;
               if(ALU_Config1[6])
			    begin
				 ALU_FUN = 'd14 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;					 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = CHK_NO_OP ;               
                end						
              end
  CHK_NO_OP : begin
              CLKG_EN = 1'b1 ;
               if(ALU_Config1[7])
			    begin
				 ALU_FUN = 'd15 ;
				 ALU_Enable = 1'b1 ;
			     next_state = WAIT_BUSY_HIGH ;					 
				end
			   else 
                begin
			     ALU_Enable = 1'b0 ;	
			     next_state = IDLE ;               
                end						
              end
  WAIT_BUSY_HIGH : begin
              CLKG_EN = 1'b1 ;
			  ALU_Enable = 1'b0 ; 
               if(UART_Busy)
			    begin
			     next_state = WAIT_BUSY_LOW ;					 
				end
			   else 
                begin
			     next_state = WAIT_BUSY_HIGH ;	            
                end						
              end			  
  WAIT_BUSY_LOW  : begin
               CLKG_EN = 1'b0 ;
			   ALU_Enable = 1'b0 ;				   
               if(UART_Busy)       // still uart is working
			    begin
			     next_state = WAIT_BUSY_LOW ;				 
				end
			   else 
                begin
				 case(state_flag)
				  5'd0  :  next_state = IDLE ;   
				  5'd1  :  next_state = CHK_SUB ;  
		 		  5'd2  :  next_state = CHK_MULT ;  
		 		  5'd3  :  next_state = CHK_DIV ;  
		 		  5'd4  :  next_state = CHK_AND ;  
		 		  5'd5  :  next_state = CHK_OR ;  
		 		  5'd6  :  next_state = CHK_NAND ;  
				  5'd7  :  next_state = CHK_NOR ;  
				  5'd8  :  next_state = CHK_XOR ;  
				  5'd9  :  next_state = CHK_XNOR ;  
				  5'd10 :  next_state = CHK_EQ_CMP ;  
				  5'd11 :  next_state = CHK_GR_CMP ;  
				  5'd12 :  next_state = CHK_LS_CMP ;  
				  5'd13 :  next_state = CHK_SFT_R ;  
				  5'd14 :  next_state = CHK_SFT_L ; 
				  5'd15 :  next_state = CHK_NO_OP ;  
				  5'd16 :  next_state = IDLE ;   		  // finsh checking all the operations	
                  default : next_state = IDLE ; 
                 endcase				 
                end						
              end			  
  default   : begin
			   next_state = IDLE ; 
              end	
  endcase                 	   
 end 

// state flag logic
always @ (posedge CLK or negedge RST)
begin
 if(!RST)
  begin
   state_flag <= 5'd0 ;  
  end
 else  
  case(current_state)
  IDLE      : begin	
			   state_flag <= 5'd0 ;    
              end
  CHK_ADD   : begin
			   state_flag <= 5'd1 ;     
              end
  CHK_SUB   : begin
			   state_flag <= 5'd2 ;  			
              end
  CHK_MULT  : begin
			  state_flag <= 5'd3 ;    		
              end
  CHK_DIV   : begin
			  state_flag <= 5'd4 ;    				
              end
  CHK_AND   : begin
			  state_flag <= 5'd5 ;    				
              end
  CHK_OR    : begin
			  state_flag <= 5'd6 ;    					
              end
  CHK_NAND  : begin
			  state_flag <= 5'd7 ;    		
              end					   		  
  CHK_NOR  : begin
			  state_flag <= 5'd8 ;    		
              end	
  CHK_XOR  : begin
			  state_flag <= 5'd9 ;    	
              end	
  CHK_XNOR  : begin
			  state_flag <= 5'd10 ;    		
              end	
  CHK_EQ_CMP : begin
			   state_flag <= 5'd11 ;    			
              end	
  CHK_GR_CMP : begin
			   state_flag <= 5'd12 ;    				
              end	
  CHK_LS_CMP : begin
  			   state_flag <= 5'd13 ;  		
              end
  CHK_SFT_R  : begin
  			   state_flag <= 5'd14 ;  	
              end
  CHK_SFT_L : begin
  			  state_flag <= 5'd15 ;  
              end
  CHK_NO_OP : begin
  			  state_flag <= 5'd16 ;  			
              end
  WAIT_BUSY_HIGH : begin				
                   end			  
  WAIT_BUSY_LOW  : begin
                   end
  default   : begin
			   state_flag <= 5'd0 ;   
              end	
  endcase                 	   
 end 

endmodule