`timescale  1ns / 1ns
// Data memory (RAM)
//
module  dmem  (
  input  logic          ck   ,
  input  logic          cena ,
  input  logic          wena ,
  input  logic   [8:0]  adra ,
  input  logic  [31:0]  inpa ,
  output logic  [31:0]  outa ,
  input  logic          cenb ,
  input  logic          wenb ,
  input  logic   [8:0]  adrb ,
  input  logic  [31:0]  inpb ,
  output logic  [31:0]  outb
) ;

// Internal nets
//
logic  [31:0]  mem  [0:511] ;

// Write operation
//
always_ff  @ ( posedge ck )
  if       ( cena && wena )  mem[adra]  <= #1  inpa ;
  else if  ( cenb && wenb )  mem[adrb]  <= #1  inpb ;

// Read operation
//
assign  outa  =  mem[adra] ;
assign  outb  =  mem[adrb] ;

endmodule

