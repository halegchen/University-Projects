`timescale  1ns / 1ns
// 32-bit loadable register
//
module  reg32  (
  input  logic          rb ,
  input  logic          ck ,
  input  logic          ld ,
  input  logic  [31:0]  d  ,
  output logic  [31:0]  q
) ;

// Register operation
//
always_ff  @ ( posedge ck , negedge rb )
  if       ( !rb )  q  <= #1  32'd0 ;
  else if  ( ld  )  q  <= #1  d     ;

endmodule
