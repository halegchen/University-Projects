`timescale  1ns / 1ns
// Program counter
//
module  pcnt  (
  input  logic          rb   ,
  input  logic          ck   ,
  input  logic          pstr ,
  output logic          prdy ,
  input  logic   [4:0]  opcd ,
  input  logic          tzro ,
  input  logic          tneg ,
  input  logic  [12:0]  badr ,
  input  logic  [12:0]  jadr ,
  input  logic          crdy ,
  output logic  [12:0]  padr
) ;

// Internal Nets
//
logic  [12:0]  pinc ;
logic  [12:0]  pbra ;
logic  [12:0]  pbrb ;
logic  [12:0]  pwai ;
logic  [12:0]  pjmp ;
logic  [12:0]  pnxt ;
//
logic          spsh ;
logic          spop ;
logic  [12:0]  sinp  [0:1] ;
logic  [12:0]  sout  [0:1] ;
logic  [12:0]  ptop ;

// Increment program address
//
assign  pinc  =  padr  +  13'd1 ;

// Branch address
//
assign  pbra  =  padr  +  badr ;
assign  pbrb  =  ( opcd[0] ? tneg : tzro )  ?  pbra  :  pinc ;

// Wait address
//
assign  pwai  =  crdy  ?  pinc  :  padr ;

// Next jump address
//
always_comb
  case  ( opcd[2:1] )
    2'd0  :  pjmp  =  pbrb ;
    2'd1  :  pjmp  =  jadr ;
    2'd2  :  pjmp  =  ptop ;
    2'd3  :  pjmp  =  pwai ;
  endcase
//
assign  pnxt  =  pstr  ?  13'd1 :  ( ( opcd[4:3] == 2'b11 )  ?  pjmp  :  pinc ) ;

// Register operation
//
always_ff  @ ( posedge ck , negedge rb )
  if  ( !rb )  padr  <= #1  13'd0 ;
  else         padr  <= #1  pnxt  ;
//
assign  prdy  =  ( padr == 13'd0 ) ;

// Jump stack
//
assign  spsh  =  ( opcd == 5'b11010 ) ;
assign  spop  =  ( opcd == 5'b11100 ) ;
//
assign  sinp[0]  =  spsh  ?  pinc     :  ( spop  ?  sout[1]  :  sout[0] ) ;
assign  sinp[1]  =  spsh  ?  sout[0]  :  ( spop  ?  13'd0    :  sout[1] ) ;
always_ff  @ ( posedge ck , negedge rb )
  if  ( !rb )  sout  <= #1  {13'd0,13'd0} ;
  else         sout  <= #1  sinp          ;
//
assign  ptop  =  sout[0] ;

endmodule
