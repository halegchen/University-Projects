`timescale  1ns / 1ns
// Program memory (ROM)
//
module  pmem  (
  input  logic  [12:0]  padr ,
  output logic  [17:0]  dout
) ;

// ROM contents as a lookup table
//
always_comb
  case( padr )
    /*
    The very first line should always be "Branch unconditional to 0" or
    "Jump to 0", i.e. an infinite loop. This also sets "processor ready" to 1.
    The infinite loop can only be broken by an external "processor start"
    which will set program counter to 1. By default, 1 is the start
    address for the actual program
    */
    13'd000  :  dout  =  { 5'b11000 , 9'b000000000      ,  4'b0000 } ;  // BRZ R0, 0
    /*
    Load 0x01234567 into R2 from dmem[1], shuffle it and write back to dmem[1]
    */
    13'd001  :  dout  =  { 5'b01100 , 4'b0001 , 4'b0000 , 5'b00000 } ;  // ADDI R1 R0 0
    13'd002  :  dout  =  { 5'b10000 , 4'b1111 , 4'b0001 , 5'b00000 } ;  // LD   R1 RF
    13'd003  :  dout  =  { 5'b01100 , 4'b0001 , 4'b0001 , 5'b00001 } ;  // ADDI R1 R1 1
    13'd004  :  dout  =  { 5'b10000 , 4'b1111 , 4'b0001 , 5'b00000 } ;  // LD   R1 RF
    13'd005  :  dout  =  { 5'b10110 , 13'b0000000000000            } ;  // START
    13'd006  :  dout  =  { 5'b11110 , 13'b0000000000000            } ;  // WAIT
    13'd007  :  dout  =  { 5'b01100 , 4'b0001 , 4'b0000 , 5'b00010 } ;  // ADDI R1 R0 2
    13'd008  :  dout  =  { 5'b10001 , 4'b0000 , 4'b0001 , 5'b01111 } ;  // ST   R1 RF
    13'd009  :  dout  =  { 5'b01100 , 4'b0001 , 4'b0001 , 5'b00001 } ;  // ADDI R1 R1 1
    13'd010  :  dout  =  { 5'b10001 , 4'b0000 , 4'b0001 , 5'b01111 } ;  // ST   R1 RF
    /*
    All other lines of the program are defaulted to "Jump to 0" in order to
    ensure that the processor goes back to the initial infinite loop and
    "processor ready" is set for the next operation
    */
    default  :  dout  =  { 5'b11010 , 13'b0000000000000            } ;  // JMP  0
  endcase

endmodule

