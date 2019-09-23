//
// 2^n x m - bit dual-port RAM with NO write-priority
//
`timescale  1ns / 1ns
module  dpram  #(
  parameter  n  =  8 ,
  parameter  m  =  8
)  (
  input  logic           ce1 ,  // Chip enable, port-1
  input  logic           we1 ,  // Write enable, port-1
  input  logic  [n-1:0]  ad1 ,  // Address, port-1
  input  logic  [m-1:0]  di1 ,  // Data input, port-1
  output logic  [m-1:0]  dq1 ,  // Data output, port-1
  input  logic           ce2 ,  // Chip enable, port-2
  input  logic           we2 ,  // Write enable, port-2
  input  logic  [n-1:0]  ad2 ,  // Address, port-2
  input  logic  [m-1:0]  di2 ,  // Data input, port-2
  output logic  [m-1:0]  dq2 ,  // Data output, port-2
  input  logic           ck     // Positive-edge triggered clock
) ;

// Memory array
//
logic  [m-1:0]  mem  [0:2**n-1] ;

// Sync RAM operation for port-1
//
always_ff  @ ( posedge ck )
  if  ( ce1 )  begin                     // If chip enable is active, perform either write or read
    if  ( we1 )  mem[ad1]  <= #1  di1 ;  // If write enable is active, write new data to memory address
    dq1  <= #1  mem[ad1] ;               // Read old data from the same address
  end

// Sync RAM operation for port-2
//
always_ff  @ ( posedge ck )
  if  ( ce2 )  begin                     // If chip enable is active, perform either write or read
    if  ( we2 )  mem[ad2]  <= #1  di2 ;  // If write enable is active, write new data to memory address
    dq2  <= #1  mem[ad2] ;               // Read old data from the same address
  end

endmodule