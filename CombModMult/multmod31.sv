//Mod 31 modular multiplier
//GC
//04/02/2019

module multmod31 (
    input  logic [4:0] A ,
    input  logic [4:0] B ,
    output logic [4:0] Y 
    //output logic [9:0] M
) ;

//Internal variables
logic [4:0] P0,P1,P2,P3,P4;
logic [4:0]    S1,S2,S3,S4;
logic [6:0]             S5;
logic      CO1,CO2,CO3,CO4;
logic [9:0]            	 M;

//B multiplies A bit by bit
assign P0 = B[0]?A : 0;
assign P1 = B[1]?A : 0;
assign P2 = B[2]?A : 0;
assign P3 = B[3]?A : 0;
assign P4 = B[4]?A : 0;

//Add the bit multiplication results
addn #(5) u5_add1 (.a({1'b0, P0[4:1]}), .b(P1[4:0]), .s(S1), .co(CO1));
addn #(5) u5_add2 (.a({CO1,  S1[4:1]}), .b(P2[4:0]), .s(S2), .co(CO2));
addn #(5) u5_add3 (.a({CO2,  S2[4:1]}), .b(P3[4:0]), .s(S3), .co(CO3));
addn #(5) u5_add4 (.a({CO3,  S3[4:1]}), .b(P4[4:0]), .s(M[8:4]), .co(M[9]));

//Multiplication results of the lower 4 bits
assign M[0] = P0[0];
assign M[1] = S1[0];
assign M[2] = S2[0];
assign M[3] = S3[0];

//Perform Mod31 operation
addn #(5) u5_add5 (.a(M[9:5]), .b(M[4:0]), .s(S4), .co(CO4));
addn #(7) u7_add6 (.a({1'b0,CO4,S4}), .b(7'b1100001), .s(S5), .co());

assign Y = S5[6]?S4 : S5[4:0];

endmodule

