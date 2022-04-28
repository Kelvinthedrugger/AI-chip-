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
//wire mid0, mid1, mid2, mid3, mid4, mid5, mid6, mid7, mid8, mid9, mid10, mid11, mid12, mid13, mid14, mid15;
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
// init 8 bit integer to store multplication result

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


// sum from mid0 ~ mid 11 (3 8b numbers first)

wire s0, s1, s2, s3, s4, s5;//, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;
// c0 = 0
wire c1, c2, c3, c4, c5, c6;//, c7, c8, c9, c10, c11, c12, c13, c14, c15;



endmodule

