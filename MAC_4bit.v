/*copied from ..\MAC_4bit */
// this should work, but the import is stupid
`include "HA.v"
`include "FA.v"
module MAC_4bit (
    input   [3:0]   a,
    input   [3:0]   b,
    input   [11:0]  c,
    output  [11:0]  result,
    output          cout
);

/* Here is your code */
/* 
step 1: do and operation, PPG
what we do was to decompose the multiplier 
since we can only do one bit at a time
*/

// produce shifted multipland

// a * b
// do And operation BIT BY BIT
// 16 pink dots
wire mid[15:0];
assign mid[0] = a[0] & b[0];
assign mid[1] = a[1] & b[0];
assign mid[2] = a[2] & b[0];
assign mid[3] = a[3] & b[0];
assign mid[4] = a[0] & b[1];
assign mid[5] = a[1] & b[1];
assign mid[6] = a[2] & b[1];
assign mid[7] = a[3] & b[1];
assign mid[8] = a[0] & b[2];
assign mid[9] = a[1] & b[2];
assign mid[10] = a[2] & b[2];
assign mid[11] = a[3] & b[2];
assign mid[12] = a[0] & b[3];
assign mid[13] = a[1] & b[3];
assign mid[14] = a[2] & b[3];
assign mid[15] = a[3] & b[3];

// csa
/*
3 numbers as a group
step1: 
  FA:
    x0, y0; z0 -> c1, s0

step2:
  ci + si (mostly FA, for i == 0, HA)
    -> c(i+1)', sum_i
*/

/*
MAC_4bit MAC0(
        .a(a),
        .b(b),
        .c(c),
        .result(result),
        .cout(cout)
    );
*/

// do mid from 0 to 11 first
// 7 bit tmp sum
wire tmpsum[6:0]; 
// c0 = 0
wire ca[5:0];//1, c2, c3, c4, c5, c6;//, c7, c8, c9, c10, c11, c12, c13, c14, c15;
FA FA0(.a(mid[0]),.b(1'b0),.cin(1'b0),.sum(tmpsum[0]),.cout(ca[0]));
FA FA1(.a(mid[1]),.b(mid[4]),.cin(1'b0),.sum(tmpsum[1]),.cout(ca[1]));
FA FA2(.a(mid[2]),.b(mid[5]),.cin(mid[8]),.sum(tmpsum[2]),.cout(ca[2]));
FA FA3(.a(mid[3]),.b(mid[6]),.cin(mid[9]),.sum(tmpsum[3]),.cout(ca[3]));
FA FA4(.a(1'b0),.b(mid[7]),.cin(mid[10]),.sum(tmpsum[4]),.cout(ca[4]));
FA FA5(.a(1'b0),.b(1'b0),.cin(mid[11]),.sum(tmpsum[5]),.cout(ca[5]));



endmodule

