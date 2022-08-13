
module fsm  (

 input   wire                  CLK,
 input   wire                  RST,
 input   wire                  Data_Valid, 
 input   wire                  ser_done, 
 output  reg                   Ser_enable,
 output  reg     [1:0]         mux_sel, 
 output  reg                   busy
);


// gray state encoding
parameter   [2:0]      IDLE   = 3'b000,
                       start  = 3'b001,
					   data   = 3'b011,
					   parity = 3'b010,
					   stop   = 3'b110 ;

reg         [2:0]      current_state , next_state ;
			

			
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
  case(current_state)
  IDLE   : begin
            if(Data_Valid)
			 next_state = start ;
			else
			 next_state = IDLE ; 			
           end
  start  : begin
			 next_state = data ;  
           end
  data   : begin
            if(ser_done)
			 next_state = parity ;
			else
			 next_state = data ; 			
           end
  parity : begin
			 next_state = stop ; 
           end
  stop   : begin
			 next_state = IDLE ; 
           end	
  default: begin
			 next_state = IDLE ; 
           end	
  endcase                 	   
 end 

 
// output logic
always @ (*)
 begin
  case(current_state)
  IDLE   : begin
            busy = 1'b0 ;
			Ser_enable = 1'b0 ;
            mux_sel = 2'b00 ;				
           end
  start  : begin
			Ser_enable = 1'b1 ;  
            busy = 1'b1 ;
            mux_sel = 2'b00 ;	
           end
  data   : begin  
            busy = 1'b1 ;
            mux_sel = 2'b01 ;	
            if(ser_done)
			 Ser_enable = 1'b0 ;  
			else
 			 Ser_enable = 1'b1 ;              			 
           end
  parity : begin
            busy = 1'b1 ;
            mux_sel = 2'b10 ;	
           end
  stop   : begin
            busy = 1'b1 ;
            mux_sel = 2'b11 ;			
           end		
  default: begin
            busy = 1'b0 ;
			Ser_enable = 1'b0 ;
            mux_sel = 2'b00 ;		
           end	
  endcase         	              
 end 
 
 
 
 

endmodule
 