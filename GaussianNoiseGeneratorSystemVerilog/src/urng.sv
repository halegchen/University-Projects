`timescale  1ns / 1ns

//Uniform random number generator
//numbers are seperated into start,
//stride and mask

//Module Name

module urng(
   input logic         CK,
   input logic         RB,
   input logic         ST,
   output logic [9:0]  start,
   output logic [9:0]  stride,
   output logic [9:0]  mask,
   output logic [31:0] tau
);

//Internal variables
logic [31:0] tau88;
logic [31:0] s1;
logic [31:0] s2;
logic [31:0] s3;
logic [1:0 ] cnt;

//counter
always_ff  @ ( posedge CK , negedge RB )
  if  ( !RB )  cnt <= #1 2'd0;
  else if (ST) cnt <= #1 2'd0;
  else         cnt <= #1 cnt + 2'd1;  

  
always_ff  @ ( posedge CK , negedge RB )
  if  ( !RB )  begin 
      s1  <= #1  32'd0 ;
      s2  <= #1  32'd0 ;
      s3  <= #1  32'd0  ;
  end
  
  else if ( ST ) begin
      s1  <= #1  32'd20 ;
      s2  <= #1  32'd16 ;
      s3  <= #1  32'd7  ;
  end      

  else if ( cnt == 3 ) begin
      s1  <= #1 ((s1 & 32'd4294967294) << 12) ^ (((s1 << 13) ^ s1) >> 19) ;
      s2  <= #1 ((s2 & 32'd4294967288) << 4 ) ^ (((s2 << 2 ) ^ s2) >> 25) ;
      s3  <= #1 ((s3 & 32'd4294967280) << 17) ^ (((s3 << 3 ) ^ s3) >> 11) ;
  end

// outputs
assign tau88  = s1 ^ s2 ^ s3; 
assign tau    = tau88;
assign start  = tau88[31:22];
assign stride = {tau88[21:13], 1'b1};
assign mask   = tau88[12:3];

endmodule 


