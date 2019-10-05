`timescale  1ns / 1ns
// ALU
//
module  alu  (
  input  logic   [4:0]  opcd ,
  input  logic  [31:0]  inps ,
  input  logic  [31:0]  inpt ,
  input  logic  [31:0]  inpi ,
  input  logic  [31:0]  inpm ,
  output logic  [31:0]  aout
) ;

// Internal nets
//
logic  [31:0]  ando ;
logic  [31:0]  oro  ;
logic  [31:0]  xoro ;
logic  [31:0]  invo ;
logic  [31:0]  logo ;
//
logic  [31:0]  inpx ;
logic  [31:0]  inpa ;
logic  [31:0]  addo ;
//
logic  [31:0]  lsl  [0:4] ;
logic  [31:0]  lsr  [0:4] ;
logic  [31:0]  shfo ;
//
logic  [31:0]  adso ;

// Logic Functions
//
assign  ando  =  inps  &  inpt ;  // AND output
assign  oro   =  inps  |  inpt ;  // OR output
assign  xoro  =  inps  ^  inpt ;  // XOR output
assign  invo  = ~inps ;           // INV output
//
always_comb
  case  ( opcd[1:0] )
    2'd0  :  logo  =  ando ;
    2'd1  :  logo  =  oro  ;
    2'd2  :  logo  =  xoro ;
    2'd3  :  logo  =  invo ;
  endcase

// SrcT / Imm Selection
//
assign  inpx  =  opcd[2]  ?  inpi  :  inpt ;

// Arithmetic Functions
//
assign  inpa  =  {32{opcd[0]}}  ^  inpx ;     // 1's comp of inpx
assign  addo  =  inps  +  inpa  +  opcd[0] ;  // ADD/SUB output

// Shift Functions
//
assign  lsl[0]  =  inpx[0]  ?  { inps  [30:0] ,  1'b0 }  :  inps   ;
assign  lsl[1]  =  inpx[1]  ?  { lsl[0][29:0] ,  2'b0 }  :  lsl[0] ;
assign  lsl[2]  =  inpx[2]  ?  { lsl[1][27:0] ,  4'b0 }  :  lsl[1] ;
assign  lsl[3]  =  inpx[3]  ?  { lsl[2][23:0] ,  8'b0 }  :  lsl[2] ;
assign  lsl[4]  =  inpx[4]  ?  { lsl[3][15:0] , 16'b0 }  :  lsl[3] ;
//
assign  lsr[0]  =  inpx[0]  ?  {  1'b0 , inps  [31: 1] }  :  inps   ;
assign  lsr[1]  =  inpx[1]  ?  {  2'b0 , lsl[0][31: 2] }  :  lsr[0] ;
assign  lsr[2]  =  inpx[2]  ?  {  4'b0 , lsl[1][31: 4] }  :  lsr[1] ;
assign  lsr[3]  =  inpx[3]  ?  {  8'b0 , lsl[2][31: 8] }  :  lsr[2] ;
assign  lsr[4]  =  inpx[4]  ?  { 16'b0 , lsl[3][31:16] }  :  lsr[3] ;
//
assign  shfo  =  opcd[0]  ?  lsr[4]  :  lsl[4] ;

// Arithmetic/Shift Output
//
assign  adso  =  opcd[1]  ?  shfo  :  addo ;

// ALU output
//
assign  aout  =  opcd[4]  ?  inpm  :  ( opcd[3]  ?  adso  :  logo ) ;

endmodule
