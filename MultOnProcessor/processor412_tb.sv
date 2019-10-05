`timescale  1ns / 1ns
// Testbench for 32-bit multiplication 
//Test 0x1F142570 * 0x00022F82
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
  // Write 0x1F142570 0x001200C2 to dmem[0-1]
  // Multiplicaiton result=0x00022F82(H) 0x2F245EE0(L)
  dcen   =  1'b1 ;
  dwen   =  1'b1 ;
  dadr   =  13'd0 ;
  dinp   =  32'h1F142570 ;//Fist multiplication term
  #(per) ;
  dadr   =  13'd1 ;
  dinp   =  32'h001200C2 ;//Second Multiplicaiton term
  #(per) ;
  dcen   =  1'b0 ;
  dwen   =  1'b0 ;
  dadr   =  13'd0 ;
  dinp   =  32'd0 ;
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
  dadr   =  13'd2 ;// 0x2F245EE0
  #(per) ;
  dadr   =  13'd3 ;// 0x00022F82
  #(per) ;
  $stop ;
end

endmodule
