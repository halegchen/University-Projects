`timescale  1ns / 1ns
// Testbench 
// Test 0x12345678 * 0xFEDCBA98 = 0x121FA00A 0X35068740
module  processor412_tb ;

// Parameters
//
parameter  per  =  10 ;  // Clock period

// I/O and variables
//
logic          rb    ;
logic          ck    ;
logic          start ;
logic          ready ;
logic          dcen  ;
logic          dwen  ;
logic   [8:0]  dadr  ;
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
processor412  dut  (
  .rb    ( rb    ) ,
  .ck    ( ck    ) ,
  .start ( start ) ,
  .ready ( ready ) ,
  .dcen  ( dcen  ) ,
  .dwen  ( dwen  ) ,
  .dadr  ( dadr  ) ,
  .dinp  ( dinp  ) ,
  .dout  ( dout  )
) ;

// Stimulus and simulation control
//
initial begin
  #1 ;
  #(per/2) ;
  start  =  1'b0 ;
  dcen   =  1'b0 ;
  dwen   =  1'b0 ;
  dadr   =  13'd0 ;
  dinp   =  32'd0 ;
  #(per) ;
  // Write 0x12345678FEDCBA98 to dmem[0-1]
  dcen   =  1'b1 ;
  dwen   =  1'b1 ;
  dadr   =  13'd0 ;
  dinp   =  32'h12345678 ;
  #(per) ;
  dadr   =  13'd1 ;
  dinp   =  32'hFEDCBA98 ; // MULT_Result = 0X121FA00A 0X35068740
  #(per) ;
  dcen   =  1'b0 ;
  dwen   =  1'b0 ;
  dadr   =  13'd0 ;  // optional
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
  // Read from dmem[2-3]
  dcen   =  1'b1 ;
  dwen   =  1'b0 ;
  dadr   =  13'd2 ;
  #(per) ;
  dadr   =  13'd3 ;
  #(per) ;
  $stop ;
end

endmodule
