`timescale  1ns / 1ns
// 16x32 register bank
//
module  regbank  (
  input  logic          rb   ,
  input  logic          ck   ,
  input  logic          load ,
  input  logic   [3:0]  dest ,
  input  logic   [3:0]  srcs ,
  input  logic   [3:0]  srct ,
  input  logic  [31:0]  inp  ,
  input  logic  [31:0]  cout ,
  output logic  [31:0]  outs ,
  output logic  [31:0]  outt ,
  output logic          tzro ,
  output logic          tneg
) ;

// Internal nets
//
logic  [15:0]  ld ;
logic  [31:0]  q  [0:15] ;

// Destination decoder
//
assign  ld[ 1]  =  load  &&  ( dest == 4'h1 ) ;
assign  ld[ 2]  =  load  &&  ( dest == 4'h2 ) ;
assign  ld[ 3]  =  load  &&  ( dest == 4'h3 ) ;
assign  ld[ 4]  =  load  &&  ( dest == 4'h4 ) ;
assign  ld[ 5]  =  load  &&  ( dest == 4'h5 ) ;
assign  ld[ 6]  =  load  &&  ( dest == 4'h6 ) ;
assign  ld[ 7]  =  load  &&  ( dest == 4'h7 ) ;
assign  ld[ 8]  =  load  &&  ( dest == 4'h8 ) ;
assign  ld[ 9]  =  load  &&  ( dest == 4'h9 ) ;
assign  ld[10]  =  load  &&  ( dest == 4'hA ) ;
assign  ld[11]  =  load  &&  ( dest == 4'hB ) ;
assign  ld[12]  =  load  &&  ( dest == 4'hC ) ;
assign  ld[13]  =  load  &&  ( dest == 4'hD ) ;
assign  ld[14]  =  load  &&  ( dest == 4'hE ) ;

// Register operation
//
assign  q[0] =  32'd0 ;
reg32  r1  ( rb , ck , ld[ 1] , inp , q[ 1] ) ;
reg32  r2  ( rb , ck , ld[ 2] , inp , q[ 2] ) ;
reg32  r3  ( rb , ck , ld[ 3] , inp , q[ 3] ) ;
reg32  r4  ( rb , ck , ld[ 4] , inp , q[ 4] ) ;
reg32  r5  ( rb , ck , ld[ 5] , inp , q[ 5] ) ;
reg32  r6  ( rb , ck , ld[ 6] , inp , q[ 6] ) ;
reg32  r7  ( rb , ck , ld[ 7] , inp , q[ 7] ) ;
reg32  r8  ( rb , ck , ld[ 8] , inp , q[ 8] ) ;
reg32  r9  ( rb , ck , ld[ 9] , inp , q[ 9] ) ;
reg32  rA  ( rb , ck , ld[10] , inp , q[10] ) ;
reg32  rB  ( rb , ck , ld[11] , inp , q[11] ) ;
reg32  rC  ( rb , ck , ld[12] , inp , q[12] ) ;
reg32  rD  ( rb , ck , ld[13] , inp , q[13] ) ;
reg32  rE  ( rb , ck , ld[14] , inp , q[14] ) ;
assign  q[15]  =  cout ;

// Source-S multiplexer
//
always_comb
  case  ( srcs )
    4'h0  :  outs  =  q[ 0] ;
    4'h1  :  outs  =  q[ 1] ;
    4'h2  :  outs  =  q[ 2] ;
    4'h3  :  outs  =  q[ 3] ;
    4'h4  :  outs  =  q[ 4] ;
    4'h5  :  outs  =  q[ 5] ;
    4'h6  :  outs  =  q[ 6] ;
    4'h7  :  outs  =  q[ 7] ;
    4'h8  :  outs  =  q[ 8] ;
    4'h9  :  outs  =  q[ 9] ;
    4'hA  :  outs  =  q[10] ;
    4'hB  :  outs  =  q[11] ;
    4'hC  :  outs  =  q[12] ;
    4'hD  :  outs  =  q[13] ;
    4'hE  :  outs  =  q[14] ;
    4'hF  :  outs  =  q[15] ;
  endcase

// Source-T multiplexer
//
always_comb
  case  ( srct )
    4'h0  :  outt  =  q[ 0] ;
    4'h1  :  outt  =  q[ 1] ;
    4'h2  :  outt  =  q[ 2] ;
    4'h3  :  outt  =  q[ 3] ;
    4'h4  :  outt  =  q[ 4] ;
    4'h5  :  outt  =  q[ 5] ;
    4'h6  :  outt  =  q[ 6] ;
    4'h7  :  outt  =  q[ 7] ;
    4'h8  :  outt  =  q[ 8] ;
    4'h9  :  outt  =  q[ 9] ;
    4'hA  :  outt  =  q[10] ;
    4'hB  :  outt  =  q[11] ;
    4'hC  :  outt  =  q[12] ;
    4'hD  :  outt  =  q[13] ;
    4'hE  :  outt  =  q[14] ;
    4'hF  :  outt  =  q[15] ;
  endcase
//
assign  tzro  =  ( outt == 32'd0 ) ;
assign  tneg  =  outt[31] ;

endmodule

