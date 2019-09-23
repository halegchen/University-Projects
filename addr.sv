//EE412 Project
//Uniform random number generator
//numbers are seperated into start,
//stride and mask

//Module Name

module addr(
   input logic  [9:0]  start,
   input logic  [9:0]  stride,
   input logic  [9:0]  mask,
   output logic [9:0]  p_addr,
   output logic [9:0]  q_addr,
   output logic [9:0]  r_addr,
   output logic [9:0]  s_addr
);

//Internal variables
logic [9:0] p1;
logic [9:0] p2;
logic [9:0] q1;
logic [9:0] q2;
logic [9:0] r1;
logic [9:0] r2;
logic [9:0] s1;
logic [9:0] s2;

//Internal outputs
assign p1 = start;
assign p2 = mask;
assign q1 = start + stride;
assign q2 = mask;
assign r1 = start + {stride[8:0], 1'b0};
assign r2 = mask;
assign s1 = start + {stride[8:0], 1'b0} + stride;
assign s2 = mask;

//Outputs
assign p_addr = p1 ^ p2;
assign q_addr = q1 ^ q2;
assign r_addr = r1 ^ r2;
assign s_addr = s1 ^ s2;

endmodule
