`timescale  1ns / 1ns
//Testbench for uniform random number generator
//EE412 Gaussian noise generator project

module noise_tb;
//Parameters
parameter  per  =  10 ;

//I/O variables
logic       CK     ;
logic       RB     ;
logic       ST     ;//START Signal pulse
logic [9:0] start  ;
logic [9:0] stride ;
logic [9:0] mask   ;
logic [31:0] tau   ;
logic [9:0] p_addr ;
logic [9:0] q_addr ;
logic [9:0] r_addr ;
logic [9:0] s_addr ;
logic [23:0] C     ;

// Define reset
//
initial  RB  =  1'b0 ;
initial  #(per)  RB  =  1'b1 ;

// Define clock
//
initial  CK  =  1'b0 ;
always  #(per/2)  CK  =  ~ CK ;

//DUT
urng dut_urng (
    .CK     ( CK ),
    .RB     ( RB ),
	.ST     ( ST ),
    .start  ( start ),
    .stride ( stride),
    .mask   ( mask  ),
    .tau    ( tau   )
) ;

addr dut_addr (
    .start  ( start  ),
    .stride ( stride ),
    .mask   ( mask   ),
    .p_addr ( p_addr ),
    .q_addr ( q_addr ),
    .r_addr ( r_addr ),
    .s_addr ( s_addr )   
) ;

transform trans (
    .CK     ( CK     ),
	.RB     ( RB     ),   
	.start  ( ST     ),
	.p_addr ( p_addr ),
	.q_addr ( q_addr ),
	.r_addr ( r_addr ),
	.s_addr ( s_addr ),
	.C      ( C      )
) ;

// Stimulus and simulation control
//
integer data;
initial begin
  #1
  ST = 1'b0;
  #(2*per);
  ST = 1'b1;
  #(per);
  ST = 1'b0;
  #(1032*per);
  //open file and generate 10,000 samples
  data = $fopen("noise.txt","w+"); 
  #(10000*per) ;		 
  //close file
  $fclose(data);  
  $stop ;
end

always@(negedge CK) $fwrite(data,"%b\n", C); 


endmodule
