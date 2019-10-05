`timescale  1ns / 1ns
// Sample co-processor - sorts nibbles within 64-bits
//
module  copro  (
  input  logic          rb    ,
  input  logic          ck    ,
  input  logic          start ,
  output logic          ready ,
  input  logic          dpsh  ,
  input  logic  [31:0]  dinp  ,
  input  logic          dpop  ,
  output logic  [31:0]  dout
) ;

// Internal Nets
//
logic          act  ;
logic   [3:0]  cnt  ;
logic  [63:0]  dreg ;
logic  [63:0]  dsre ;
logic  [63:0]  dsro ;
logic  [63:0]  dsrt ;

// Active, count and ready
//
always_ff  @ ( posedge ck , negedge rb )
  if       ( !rb )                      act  <= #1  1'b0 ;
  else if  ( start )                    act  <= #1  1'b1 ; 
  else if  ( act && ( cnt == 4'd15 ) )  act  <= #1  1'b0 ;
//
always_ff  @ ( posedge ck , negedge rb )
  if       ( !rb )    cnt  <= #1  4'd0 ;
  else if  ( start )  cnt  <= #1  4'd0 ;
  else if  ( act   )  cnt  <= #1  cnt  +  4'd1 ;
//
always_ff  @ ( posedge ck , negedge rb )
  if  ( !rb )  ready  <= #1  1'b0 ;
  else         ready  <= #1  ( act && ( cnt == 4'd15 ) ) ;

// Data register
//
always_ff  @ ( posedge ck , negedge rb )
  if       ( !rb  )  dreg  <= #1  64'd0 ;
  else if  ( dpsh )  dreg  <= #1  { dreg[31:0] , dinp } ;
  else if  ( dpop )  dreg  <= #1  { dreg[31:0] , dreg[63:32] } ;
  else if  ( act  )  dreg  <= #1  dsrt ;

// Data sorting
//
assign  dsre  =  { ( ( dreg[63:60] > dreg[59:56] )  ?  { dreg[59:56] , dreg[63:60] }  :  { dreg[63:60] , dreg[59:56] } ) ,
                   ( ( dreg[55:52] > dreg[51:48] )  ?  { dreg[51:48] , dreg[55:52] }  :  { dreg[55:52] , dreg[51:48] } ) ,
                   ( ( dreg[47:44] > dreg[43:40] )  ?  { dreg[43:40] , dreg[47:44] }  :  { dreg[47:44] , dreg[43:40] } ) ,
                   ( ( dreg[39:36] > dreg[35:32] )  ?  { dreg[35:32] , dreg[39:36] }  :  { dreg[39:36] , dreg[35:32] } ) ,
                   ( ( dreg[31:28] > dreg[27:24] )  ?  { dreg[27:24] , dreg[31:28] }  :  { dreg[31:28] , dreg[27:24] } ) ,
                   ( ( dreg[23:20] > dreg[19:16] )  ?  { dreg[19:16] , dreg[23:20] }  :  { dreg[23:20] , dreg[19:16] } ) ,
                   ( ( dreg[15:12] > dreg[11: 8] )  ?  { dreg[11: 8] , dreg[15:12] }  :  { dreg[15:12] , dreg[11: 8] } ) ,
                   ( ( dreg[ 7: 4] > dreg[ 3: 0] )  ?  { dreg[ 3: 0] , dreg[ 7: 4] }  :  { dreg[ 7: 4] , dreg[ 3: 0] } ) } ;
//
assign  dsro  =  {     dreg[63:60] ,
                   ( ( dreg[59:56] > dreg[55:52] )  ?  { dreg[55:52] , dreg[59:56] }  :  { dreg[59:56] , dreg[55:52] } ) ,
                   ( ( dreg[51:48] > dreg[47:44] )  ?  { dreg[47:44] , dreg[51:48] }  :  { dreg[51:48] , dreg[47:44] } ) ,
                   ( ( dreg[43:40] > dreg[39:36] )  ?  { dreg[39:36] , dreg[43:40] }  :  { dreg[43:40] , dreg[39:36] } ) ,
                   ( ( dreg[35:32] > dreg[31:28] )  ?  { dreg[31:28] , dreg[35:32] }  :  { dreg[35:32] , dreg[31:28] } ) ,
                   ( ( dreg[27:24] > dreg[23:20] )  ?  { dreg[23:20] , dreg[27:24] }  :  { dreg[27:24] , dreg[23:20] } ) ,
                   ( ( dreg[19:16] > dreg[15:12] )  ?  { dreg[15:12] , dreg[19:16] }  :  { dreg[19:16] , dreg[15:12] } ) ,
                   ( ( dreg[11: 8] > dreg[ 7: 4] )  ?  { dreg[ 7: 4] , dreg[11: 8] }  :  { dreg[11: 8] , dreg[ 7: 4] } ) ,
                       dreg[ 3: 0] } ;
//
assign  dsrt  =  cnt[0]  ?  dsro  :  dsre ;

// Output
//
assign  dout  =  dreg[63:32] ;

endmodule
