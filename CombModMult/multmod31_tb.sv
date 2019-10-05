`timescale  1ns / 1ns
//Test Bench for multmod31
//GC
//04/02/2019

module  multmod31_tb ;

//Parameters
parameter  PER  =  10 ;

//I/O variables
logic [4:0] A ;
logic [4:0] B ;
logic [4:0] Y ;
integer  i, j ;

//DUT
multmod31 dut (
    .A ( A ),
    .B ( B ),
    .Y ( Y )
) ;

//Simulation control
initial begin
for(i=0; i<32; i++) begin
    A = i;
    for(j=0; j<32; j++) begin
        B = j;
        #(PER);
    end
end
$stop;
end
//
always begin
  #(PER/2) ;
  $display( "%d * %d = %d MOD 31 = %d" , A , B, i*j, Y ) ;
  #(PER/2) ;
end


endmodule