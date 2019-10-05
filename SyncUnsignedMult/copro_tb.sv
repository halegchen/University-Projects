`timescale  1ns / 1ns
// testbench for coprocessor of 32-bit mult
// GC
module  copro_tb ;

// Parameters
//
parameter  per  =  10 ;  // Clock period

// I/O and variables
//
logic          rb    ;
logic          ck    ;
logic          start ;
logic          ready ;
logic          dpop  ;
logic          dpsh  ;
logic  [31:0]  dinp  ;
logic  [31:0]  dout  ;

// Define reset
//
initial  rb  =  1'b0 ;
initial  #(per)  rb  =  1'b1 ;

// Define clock
//
initial  ck  =  1'b0 ;
always  #(per/2)  ck  =  ~ ck ;

// Device under test
//
copro  dut  (
  .rb    ( rb    ) ,
  .ck    ( ck    ) ,
  .start ( start ) ,
  .ready ( ready ) ,
  .dpop  ( dpop  ) ,
  .dpsh  ( dpsh  ) ,
  .dinp  ( dinp  ) ,
  .dout  ( dout  )
) ;

// Stimulus and simulation control
//
initial begin
  #1 ;
  #(per/2) ;
  start  =  1'b0 ;
  dpop   =  1'b0 ;
  dpsh   =  1'b0 ;
  dinp   =  32'd0 ;
  #(per) ;
  dpsh   =  1'b1 ;
  // Write 0x12345678FEDCBA98 to dmem[0-1]
  dinp   =  32'h12345678 ;
  #(per) ;
  dinp   =  32'hFEDCBA98 ; // MULT_Result = 0x121FA00A 0X35068740
  #(per) ;
  dpsh   =  1'b0 ;
  dinp   =  32'd0 ;  // optional
  #(per) ;
  // Send Start to Processor
  start  =  1'b1 ;
  #(per) ;
  start  =  1'b0 ;
  #(per) ;
  // Wait for Ready from Processor
  @( posedge ready ) ;
  #(per) ;
  // Read from register
  dpop   =  1'b1 ;
  dpsh   =  1'b0 ;
  #(2*per) ;
  dpop   =  1'b0 ; 
  $stop ;
end

endmodule
