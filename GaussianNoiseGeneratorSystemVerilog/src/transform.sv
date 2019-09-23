//EE412 Project
//Noise generation without normalization

//Module Name
`timescale  1ns / 1ns
module transform (
   input  logic         CK    ,
   input  logic         RB    ,
   input  logic         start ,
   input  logic [9:0 ]  p_addr,
   input  logic [9:0 ]  q_addr,
   input  logic [9:0 ]  r_addr,
   input  logic [9:0 ]  s_addr,
   output logic [23:0]  C      //noise without normalization
);

logic [9:0 ] cnt1, cnt_ram;
logic [1:0 ] cnt2, sel_C;
logic [2:0 ] cnt3; 
logic [9:0 ] addr_A, addr_B;
logic [23:0] rom_o;
logic [23:0] data_A, data_B;
//input of transformation
//input of transformation
//output of transformation
//output of transformation
logic [23:0] A_i, B_i, A_o, B_o;

logic [23:0] r1, r2, r3, r33, r4, rti, rti1, rti2, rti_sum;
logic [23:0] rt, rp, rq, rr, rs;
logic [23:0] rp1, rp2, rq1, rq2, rr1, rr2, rs1, rs2;
logic [23:0] rpo, rqo, rro, rso;

logic       init;
logic       sel_addr, sel_ram, sel_pqrs, sel_AB;
logic       CE1, CE2;//chip enable
logic       WE1,WE2;//write enable


//counter 1 for initialization in reading rom
always_ff  @ ( posedge CK , negedge RB )
  if(!RB)        cnt1 <= #1 10'b0;
  else if(start) cnt1 <= #1 10'b0;
  else if(init)  cnt1 <= #1 cnt1 + 10'd1; 

//counter for ram initialization
always_ff  @ ( posedge CK , negedge RB )
  if(!RB)        cnt_ram <= #1 10'b0;
  else           cnt_ram <= #1 cnt1;

//initialization signal
always_ff  @ ( posedge CK , negedge RB )
  if(!RB)        init <= #1 1'b0;
  else if(start) init <= #1 1'b1;
  else if(init && (cnt1 == 10'd1023)) init <= #1 1'b0;
  
//p,q,r,s address selection
always_ff  @ ( posedge CK , negedge RB )
  if(!RB)        sel_addr <= #1 1'b0;
  else if(start) sel_addr <= #1 1'b0;
  else if(init)  sel_addr <= #1 1'b0;
  else           sel_addr <= #1 ~sel_addr;

always_ff  @ ( posedge CK , negedge RB )
  if(!RB)                 sel_pqrs <= #1 1'b0;
  else if(start)          sel_pqrs <= #1 1'b0;
  else if(cnt2 == 2'd3)   sel_pqrs <= #1 ~sel_pqrs;
  

//RAM address selection
always_ff  @ ( posedge CK , negedge RB )
  if(!RB)        sel_ram  <= #1 1'b0;
  else if(start) sel_ram  <= #1 1'b0;
  else           sel_ram  <= #1 ~init  ;
 
assign addr_A = sel_ram?(sel_addr?p_addr:r_addr):cnt_ram;
assign addr_B = sel_addr?q_addr:s_addr;

//init pool rom
rom1024x24 rom_init ( .clk(CK), .cen(init), .adr(cnt1), .dout(rom_o) );


//counter 2 for write enable of the ram
always_ff  @ ( posedge CK , negedge RB )
  if(!RB)        cnt2 <= #1 2'b0;
  else if(start) cnt2 <= #1 2'b0;
  else if(init ) cnt2 <= #1 2'b0;
  else           cnt2 <= #1 cnt2 + 2'd1;

//counter 3 for write enable of the ram
always_ff  @ ( posedge CK , negedge RB )
  if(!RB)        cnt3 <= #1 3'b0;
  else if(start) cnt3 <= #1 3'b0;
  else if(init ) cnt3 <= #1 3'b0;
  else if(~(cnt3 == 3'd7)) cnt3 <= #1 cnt3 + 1;


//chip enable 1
always_ff  @ ( posedge CK , negedge RB )
  if(!RB)        CE1 <= #1 1'b0;
  else if(start) CE1 <= #1 1'b1;

//chip enable 2
assign CE2 = CE1;

  
//write enable 1
always_ff  @ ( posedge CK , negedge RB )
  if(!RB)        WE1 <= #1 1'b0;
  else if(start) WE1 <= #1 1'b1;
  else if(init ) WE1 <= #1 1'b1;
  else if(((cnt2 == 2'd1) || (cnt2 == 2'd2))&&(cnt3 == 3'd7)) WE1 <= #1 1'b1;
  else WE1 <= #1 1'b0;

//write enable 2
always_ff  @ ( posedge CK , negedge RB )
  if(!RB)        WE2 <= #1 1'b0;
  else if(start) WE2 <= #1 1'b0;
  else if(init ) WE2 <= #1 1'b0;
  else if(((cnt2 == 2'd1) || (cnt2 == 2'd2))&&(cnt3 == 3'd7)) WE2 <= #1 1'b1;
  else WE2 <= #1 1'b0;

//select c
always_ff  @ ( posedge CK , negedge RB )
  if(!RB)        sel_C <= #1 1'b0;
  else if(start) sel_C <= #1 1'b1;
  else if(init ) sel_C <= #1 1'b1;
  else           sel_C <= #1 sel_C + +2'd1;
 

//ram
dpram #(.n(10),.m(24)) ram_pool ( .ce1(CE1), .we1(WE1), .ad1(addr_A), .di1(data_A), .dq1(A_i), .ce2(CE2), .we2(WE2), .ad2(addr_B), .di2(data_B), .dq2(B_i), .ck(CK) );
//data input of ram
assign data_A = sel_ram?B_o:rom_o;
assign data_B = A_o;

//transformation circuit

//register for transformation
regn #(24) R1  (.d(A_i), .q(r1), .ck(CK), .rb(RB));
regn #(24) R2  (.d(B_i), .q(r2), .ck(CK), .rb(RB));
regn #(24) R3  (.d(r1+r2), .q(r3), .ck(CK), .rb(RB));

regn #(24) R33 (.d(r3), .q(r33), .ck(CK), .rb(RB));

regn #(24) R4  (.d(r1+r2), .q(r4), .ck(CK), .rb(RB));
regn #(24) Rt  (.d(rti), .q(rt), .ck(CK), .rb(RB));
regn #(24) Rp  (.d(r1), .q(rp), .ck(CK), .rb(RB));
regn #(24) Rq  (.d(r2), .q(rq), .ck(CK), .rb(RB));
regn #(24) Rr  (.d(r1), .q(rr), .ck(CK), .rb(RB));
regn #(24) Rs  (.d(r2), .q(rs), .ck(CK), .rb(RB));
regn #(24) Rpo (.d(rp1+(~rp2)+1), .q(rpo), .ck(CK), .rb(RB));
regn #(24) Rqo (.d(rq1+(~rq2)+1), .q(rqo), .ck(CK), .rb(RB));
regn #(24) Rro (.d(rr1+(~rr2)+1), .q(rro), .ck(CK), .rb(RB));
regn #(24) Rso (.d(rs1+(~rs2)+1), .q(rso), .ck(CK), .rb(RB));

assign rti_sum = r33 + r4;
assign rti1 = ~rti_sum + 1;
assign rti2 = {1'b1, ~rti1[23:1]} + 1;
assign rti = rti_sum[23]?rti2 : {1'b0, rti_sum[23:1]};

assign rp1 = sel_pqrs? rt:rp;
assign rp2 = sel_pqrs? rp:rt;

assign rq1 = sel_pqrs? rq:rt;
assign rq2 = sel_pqrs? rt:rq;

assign rr1 = sel_pqrs? rr:rt;
assign rr2 = sel_pqrs? rt:rr;

assign rs1 = sel_pqrs? rs:rt;
assign rs2 = sel_pqrs? rt:rs;

assign A_o = sel_addr? rpo:rro;
assign B_o = sel_addr? rqo:rso;
assign C   = sel_C[0]?(sel_C[1]?rso:rqo) : (sel_C[1]?rro:rpo);


endmodule

