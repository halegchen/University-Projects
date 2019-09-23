//
// n-bit register
//
`timescale  1ns / 1ns
module  regn  #(
  parameter  n  =  8
)  (
  input  logic  [n-1:0]  d  ,
  output logic  [n-1:0]  q  ,
  input  logic           ck ,
  input  logic           rb
) ;

// Function
//
always_ff  @ ( posedge ck , negedge rb )
  if  ( !rb )  q  <= #1  {n{1'b0}} ;
  else         q  <= #1  d ;

endmodule