`timescale  1ns / 1ns
// Simple processor
//
module  processor412  (
  input  logic          rb    ,
  input  logic          ck    ,
  input  logic          start ,
  output logic          ready ,
  input  logic          dcen  ,
  input  logic          dwen  ,
  input  logic   [8:0]  dadr  ,
  input  logic  [31:0]  dinp  ,
  output logic  [31:0]  dout
) ;

// Internal nets
//
logic  [12:0]  padr ;
logic  [17:0]  inst ;
//
logic   [4:0]  opcd ;
logic  [12:0]  badr ;
logic  [12:0]  jadr ;
//
logic          load ;
logic   [3:0]  dest ;
logic   [3:0]  srcs ;
logic   [3:0]  srct ;
logic  [31:0]  imm  ;
logic  [31:0]  sout ;
logic  [31:0]  tout ;
logic          tzro ;
logic          tneg ;
//
logic  [31:0]  aout ;
//
logic          mcen ;
logic          mwen ;
logic   [8:0]  madr ;
logic  [31:0]  minp ;
logic  [31:0]  mout ;
//
logic          cstr ;  // Co-processor start
logic          crdy ;  // Co-processor ready
logic          cwen ;  // Co-processor write-enable
logic  [31:0]  cinp ;  // Co-processor input
logic          cren ;  // Co-processor read-enable
logic  [31:0]  cout ;  // Co-processor output

// Program counter
//
pcnt  u_pcnt  (
  .rb   ( rb    ) ,
  .ck   ( ck    ) ,
  .pstr ( start ) ,
  .prdy ( ready ) ,
  .opcd ( opcd  ) ,
  .tzro ( tzro  ) ,
  .tneg ( tneg  ) ,
  .badr ( badr  ) ,
  .jadr ( jadr  ) ,
  .crdy ( crdy  ) ,
  .padr ( padr  )
) ;

// Program memory
//
pmem  u_pmem  (
  .padr ( padr ) ,
  .dout ( inst )
) ;

// Program decoding
//
assign  opcd  =  inst[17:13] ;
assign  dest  =  inst[12: 9] ;
assign  srcs  =  inst[ 8: 5] ;
assign  srct  =  inst[ 3: 0] ;
assign  imm   =  { {28{inst[4]}} , inst[3:0] } ;
assign  badr  =  { {5{inst[12]}} , inst[11:4] } ;
assign  jadr  =  inst[12:0] ;
//
assign  load  =  ( opcd[4] == 1'b0 )  ||  ( opcd == 5'b10000 ) ;
//
assign  mcen  =  ( opcd[4:1] == 4'b1000 ) ;
assign  mwen  =  opcd[0] ;
assign  madr  =  sout[8:0] ;
assign  minp  =  tout ;

// Register bank
//
regbank  u_rbnk  (
  .rb   ( rb   ) ,
  .ck   ( ck   ) ,
  .load ( load ) ,
  .dest ( dest ) ,
  .srcs ( srcs ) ,
  .srct ( srct ) ,
  .inp  ( aout ) ,
  .cout ( cout ) ,
  .outs ( sout ) ,
  .outt ( tout ) ,
  .tzro ( tzro ) ,
  .tneg ( tneg )
) ;

// ALU
//
alu  u_alu  (
  .opcd ( opcd ) ,
  .inps ( sout ) ,
  .inpt ( tout ) ,
  .inpi ( imm  ) ,
  .inpm ( mout ) ,
  .aout ( aout )
) ;

// Data memory
//
dmem  u_dmem  (
  .ck   ( ck   ) ,
  .cena ( dcen ) ,
  .wena ( dwen ) ,
  .adra ( dadr ) ,
  .inpa ( dinp ) ,
  .outa ( dout ) ,
  .cenb ( mcen ) ,
  .wenb ( mwen ) ,
  .adrb ( madr ) ,
  .inpb ( minp ) ,
  .outb ( mout )
) ;

// Co-processor
//
assign  cstr  =  ( opcd == 5'b10110 ) ;
assign  cwen  =  ( ( opcd[4] == 1'b0 ) || ( opcd == 5'b10000 ) )  &&  ( dest == 4'hF ) ;
assign  cinp  =  aout ;
assign  cren  =  ( ( opcd[4] == 1'b0 ) || ( opcd[4:1] == 4'b1000 ) )  &&  ( ( srcs == 4'hF ) || ( srct == 4'hF ) ) ;
copro  u_copro  (
  .rb    ( rb   ) ,
  .ck    ( ck   ) ,
  .start ( cstr ) ,
  .ready ( crdy ) ,
  .dpsh  ( cwen ) ,
  .dinp  ( cinp ) ,
  .dpop  ( cren ) ,
  .dout  ( cout )
) ;

endmodule
