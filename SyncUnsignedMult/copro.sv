`timescale  1ns / 1ns
// Co-processor for 32-bit multiplication
// GC
//
module  copro  (
  input  logic          rb    , //clear registers
  input  logic          ck    , //clock
  input  logic          start , //start signal
  output logic          ready , //ready signal
  input  logic          dpsh   , //write enable
  input  logic  [31:0]  dinp  , //data input
  input  logic          dpop   , //read enable
  output logic  [31:0]  dout    //data output
) ;

// Internal Nets
//
logic          act  ; //active
logic  [4:0]   cnt  ; //counter counting from 0 to 31
logic  [31:0]  areg ; //A register to store the 1st mult term
logic  [31:0]  breg ; //B register to store the 2nd mult term
logic  [31:0]  mh   ; //multiplication higher bits register
logic  [31:0]  ml   ; //multiplication lower bits register
logic  [63:0]  sum  ; //sum of a single iteration

// Active
//
always_ff  @ ( posedge ck , negedge rb )
  if       ( !rb )                      act  <= #1  1'b0 ;
  else if  ( start )                    act  <= #1  1'b1 ; 
  else if  ( act && ( cnt == 5'd31 ) )  act  <= #1  1'b0 ;

// Counter
//
always_ff  @ ( posedge ck , negedge rb )
  if       ( !rb )    cnt  <= #1  5'd0 ;
  else if  ( start )  cnt  <= #1  5'd0 ;
  else if  ( act   )  cnt  <= #1  cnt  +  5'd1 ;

// Ready
//
always_ff  @ ( posedge ck , negedge rb )
  if  ( !rb )  ready  <= #1  1'b0 ;
  else         ready  <= #1  ( act && ( cnt == 5'd31 ) ) ;

// Data register for multiplication
// areg
// 
always_ff  @ ( posedge ck , negedge rb )
  if       ( !rb  )  areg  <= #1  32'd0 ;
  else if  ( dpsh  )  areg  <= #1  breg  ;
  else if  ( act  )  areg  <= #1  { 1'b0 , areg[31:1] } ;

// breg 
//
always_ff  @ ( posedge ck , negedge rb )
  if       ( !rb  )  breg  <= #1  32'd0 ;
  else if  ( dpsh  )  breg  <= #1  dinp  ;



// mh
//
always_ff  @ ( posedge ck , negedge rb )
  if       ( !rb  )  mh    <= #1  32'd0 ;
  else if  ( dpop  )  mh    <= #1  ml    ;
  else if  ( act  )  mh    <= #1  sum[63:32] ;

// ml
//
always_ff  @ ( posedge ck , negedge rb )
  if       ( !rb  )  ml    <= #1  32'd0 ;
  else if  ( dpop  )  ml    <= #1  mh    ;
  else if  ( act  )  ml    <= #1  sum[31:0] ;

// 64-bit adder for one iteration
//
assign sum = (areg[0]? { 1'b0, breg, 31'b0 } : 32'b0) + { 1'b0, mh[31:0], ml[31:1] } ;

// data output
//
assign dout = mh;

endmodule

