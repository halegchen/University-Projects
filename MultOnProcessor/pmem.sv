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
    13'd000  :  dout  =  { 5'b11000 , 9'b000000000      , 4'b0000  } ;  // BRZ  R0, 0
	
	//32-bit multiplication
	13'd001  :  dout  =  { 5'b10000 , 4'b0001 , 4'b0000 , 5'b00000 } ;  // LD   R0, R1
	13'd002  :  dout  =  { 5'b01100 , 4'b0011 , 4'b0000 , 5'b00001 } ;  // ADDI R3, R0, 1
    13'd003  :  dout  =  { 5'b10000 , 4'b0010 , 4'b0011 , 5'b00000 } ;  // LD   R3, R2
	13'd004  :  dout  =  { 5'b01100 , 4'b0011 , 4'b0000 , 5'b01111 } ;  // ADDI R3, R0, 5’b01111
	13'd005  :  dout  =  { 5'b01110 , 4'b0011 , 4'b0011 , 5'b00100 } ;  // LSLI R3, R3, 4
	13'd006  :  dout  =  { 5'b01100 , 4'b0011 , 4'b0011 , 5'b01111 } ;  // ADDI R3, R3, 5’b01111
	13'd007  :  dout  =  { 5'b01110 , 4'b0011 , 4'b0011 , 5'b00100 } ;  // LSLI R3, R3, 4
	13'd008  :  dout  =  { 5'b01100 , 4'b0011 , 4'b0011 , 5'b01111 } ;  // ADDI R3, R3, 5’b01111
	13'd009  :  dout  =  { 5'b01110 , 4'b0011 , 4'b0011 , 5'b00100 } ;  // LSLI R3, R3, 4
	13'd010  :  dout  =  { 5'b01100 , 4'b0011 , 4'b0011 , 5'b01111 } ;  // ADDI R3, R3, 5’b01111
	13'd011  :  dout  =  { 5'b01110 , 4'b0100 , 4'b0011 , 5'b10000 } ;  // LSLI R4, R3, 16
	13'd012  :  dout  =  { 5'b00000 , 4'b0101 , 4'b0011 , 5'b00001 } ;  // AND  R5, R3, R1
	13'd013  :  dout  =  { 5'b00000 , 4'b0110 , 4'b0011 , 5'b00010 } ;  // AND  R6, R3, R2
	
	13'd014  :  dout  =  { 5'b11010 , 13'b0000011001000            } ;  // JMP  13’d200
	
	13'd015  :  dout  =  { 5'b00000 , 4'b0111 , 4'b0011 , 5'b00101 } ;  // AND  R7, R3, R5
	13'd016  :  dout  =  { 5'b01111 , 4'b1000 , 4'b0101 , 5'b10000 } ;  // LSRI R8, R5, 16
	13'd017  :  dout  =  { 5'b00000 , 4'b0101 , 4'b0100 , 5'b00001 } ;  // AND  R5, R4, R1
	13'd018  :  dout  =  { 5'b01111 , 4'b0101 , 4'b0101 , 5'b10000 } ;  // LSRI R5, R5, 16
	13'd019  :  dout  =  { 5'b00000 , 4'b0110 , 4'b0011 , 5'b00010 } ;  // AND  R6, R3, R2
	
	13'd020  :  dout  =  { 5'b11010 , 13'b0000011001000            } ;  // JMP  13’d200
	
	13'd021  :  dout  =  { 5'b00000 , 4'b1001 , 4'b0011 , 5'b00101 } ;  // AND  R9, R3, R5
	13'd022  :  dout  =  { 5'b01000 , 4'b1000 , 4'b1000 , 5'b01001 } ;  // ADD  R8, R8, R9
	13'd023  :  dout  =  { 5'b01111 , 4'b1001 , 4'b0101 , 5'b10000 } ;  // LSRI R9, R5, 16
	13'd024  :  dout  =  { 5'b00000 , 4'b0101 , 4'b0011 , 5'b00001 } ;  // AND  R5, R3, R1
	13'd025  :  dout  =  { 5'b00000 , 4'b0110 , 4'b0100 , 5'b00010 } ;  // AND  R6, R4, R2
	13'd026  :  dout  =  { 5'b01111 , 4'b0110 , 4'b0110 , 5'b10000 } ;  // LSRI R6, R6, 16
	
	13'd027  :  dout  =  { 5'b11010 , 13'b0000011001000            } ;  // JMP  13’d200
	
	13'd028  :  dout  =  { 5'b00000 , 4'b1010 , 4'b0011 , 5'b00101 } ;  // AND  RA, R3, R5
	13'd029  :  dout  =  { 5'b01000 , 4'b1000 , 4'b1000 , 5'b01010 } ;  // ADD  R8, R8, RA
	13'd030  :  dout  =  { 5'b01110 , 4'b1010 , 4'b1000 , 5'b10000 } ;  // LSLI RA, R8, 16
	13'd031  :  dout  =  { 5'b00001 , 4'b0111 , 4'b0111 , 5'b01010 } ;  // OR   R7, R7, RA
	13'd032  :  dout  =  { 5'b01100 , 4'b0110 , 4'b0000 , 5'b00010 } ;  // ADDI R6, R0, 2
	13'd033  :  dout  =  { 5'b10001 , 4'b0000 , 4'b0110 , 5'b00111 } ;  // ST   R6, R7
	13'd034  :  dout  =  { 5'b01111 , 4'b0101 , 4'b0101 , 5'b10000 } ;  // LSRI R5, R5, 16
	13'd035  :  dout  =  { 5'b01111 , 4'b1000 , 4'b1000 , 5'b10000 } ;  // LSRI R8, R8, 16
	13'd036  :  dout  =  { 5'b01000 , 4'b1001 , 4'b1001 , 5'b01000 } ;  // ADD  R9, R9, R8
	13'd037  :  dout  =  { 5'b01000 , 4'b1001 , 4'b1001 , 5'b00101 } ;  // ADD  R9, R9, R5
	13'd038  :  dout  =  { 5'b00000 , 4'b0101 , 4'b0100 , 5'b00001 } ;  // AND  R5, R4, R1
	13'd039  :  dout  =  { 5'b01111 , 4'b0101 , 4'b0101 , 5'b10000 } ;  // LSRI R5, R5, 16
	13'd040  :  dout  =  { 5'b00000 , 4'b0110 , 4'b0100 , 5'b00010 } ;  // AND  R6, R4, R2
	13'd041  :  dout  =  { 5'b01111 , 4'b0110 , 4'b0110 , 5'b10000 } ;  // LSRI R6, R6, 16
	
	13'd042  :  dout  =  { 5'b11010 , 13'b0000011001000            } ;  // JMP  13’d200
	
	13'd043  :  dout  =  { 5'b01000 , 4'b0101 , 4'b0101 , 5'b01001 } ;  // ADD  R5, R5, R9
	13'd044  :  dout  =  { 5'b01100 , 4'b0011 , 4'b0000 , 5'b00011 } ;  // ADDI R3, R0, 3
	13'd045  :  dout  =  { 5'b10001 , 4'b0000 , 4'b0011 , 5'b00101 } ;  // ST   R3, R5
	//13'd041  :  dout  =  { 5'b11000 , 13'b0000000000000            } ;  // BRZ  R0, 0
	
	//Subroutine to calculate 16bit*16bit multiplication
	13'd200  :  dout  =  { 5'b11000 , 9'b000000110, 4'b0110        } ;  // BRZ  R6, 6
	13'd201  :  dout  =  { 5'b01000 , 4'b1011 , 4'b0101 , 5'b00000 } ;  // ADD  RB, R5, R0
	13'd202  :  dout  =  { 5'b01101 , 4'b0110 , 4'b0110 , 5'b00001 } ;  // SUBI R6, R6, 1
	13'd203  :  dout  =  { 5'b11000 , 9'b000000100, 4'b0110        } ;  // BRZ  R6, 4
	13'd204  :  dout  =  { 5'b01000 , 4'b0101 , 4'b0101 , 5'b01011 } ;  // ADD  R5, R5, RB
	13'd205  :  dout  =  { 5'b11000 , 9'b111111101, 4'b0000        } ;  // BRZ  R0, -3
	13'd206  :  dout  =  { 5'b01001 , 4'b0101 , 4'b0101 , 5'b00101 } ;  // SUB  R5, R5, R5
	13'd207  :  dout  =  { 5'b11100 , 13'b0000000000000            } ;  // RET
    
	/*
    All other lines of the program are defaulted to "Jump to 0" in order to
    ensure that the processor goes back to the initial infinite loop and
    "processor ready" is set for the next operation
    */
    default  :  dout  =  { 5'b11010 , 13'b0000000000000            } ;  // JMP  0
  endcase

endmodule

