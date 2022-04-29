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

// PPG : ok
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

// CSA
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

// CSA
// do mid from 0 to 11 first

// step 1
// 6 bit tmp sum
wire tmpsum[5:0]; 
wire ca[5:0];
// ca[0] == 0, 
// put here so that it's less prone to error
FA FA0(.a(mid[0]),.b(1'b0),.cin(1'b0),.sum(tmpsum[0]),.cout(ca[0]));
FA FA1(.a(mid[1]),.b(mid[4]),.cin(1'b0),.sum(tmpsum[1]),.cout(ca[1]));
FA FA2(.a(mid[2]),.b(mid[5]),.cin(mid[8]),.sum(tmpsum[2]),.cout(ca[2]));
FA FA3(.a(mid[3]),.b(mid[6]),.cin(mid[9]),.sum(tmpsum[3]),.cout(ca[3]));
FA FA4(.a(1'b0),.b(mid[7]),.cin(mid[10]),.sum(tmpsum[4]),.cout(ca[4]));
// almost certain ca[5] is 0
FA FA5(.a(1'b0),.b(1'b0),.cin(mid[11]),.sum(tmpsum[5]),.cout(ca[5]));

// step 2
// summing tmpsum first
// tmpsum = x + y + z
// sum0 = tmpsum + ca
// sum0: 7 bit, summation of 12 pink dots: mid[11:0]
wire sum0[6:0];
wire cap[6:0]; // carry
// HA0: b(0), since there is no previous bit
HA HA0(.a(tmpsum[0]),.b(1'b0),.sum(sum0[0]),.carry(cap[0]));

// FA7: b(ca[0]), by definition of step 2 in CSA
// FA7: cin(cap[0]), since it's the carry from previous bit
FA FA7(.a(tmpsum[1]),.b(ca[0]),.cin(cap[0]),.sum(sum0[1]),.cout(cap[1]));
FA FA8(.a(tmpsum[2]),.b(ca[1]),.cin(cap[1]),.sum(sum0[2]),.cout(cap[2]));
FA FA9(.a(tmpsum[3]),.b(ca[2]),.cin(cap[2]),.sum(sum0[3]),.cout(cap[3]));
FA FA10(.a(tmpsum[4]),.b(ca[3]),.cin(cap[3]),.sum(sum0[4]),.cout(cap[4]));
FA FA11(.a(tmpsum[5]),.b(ca[4]),.cin(cap[4]),.sum(sum0[5]),.cout(cap[5]));

// pay attention to cap[6] however
FA FA12(.a(1'b0),.b(ca[5]),.cin(cap[5]),.sum(sum0[6]),.cout(cap[6])); 


// summing the rest pink dots
// CPA here?

// fill in the previous summation first
wire re[7:0];
assign re[0] = sum0[0];
assign re[1] = sum0[1];
assign re[2] = sum0[2];

// CHECK BELOW AGAIN
// summing it
wire tmpsum1[3:0];
wire ca1[3:0];

// should be CPA
// step1
// calculate Sumxy
HA HA1(.a(sum0[3]),.b(mid[12]),.sum(tmpsum1[0]),.carry(ca1[0]));
FA FA14(.a(sum0[4]),.b(mid[13]),.cin(ca1[0]),.sum(tmpsum1[1]),.cout(ca1[1]));
FA FA15(.a(sum0[5]),.b(mid[14]),.cin(ca1[1]),.sum(tmpsum1[2]),.cout(ca1[2]));
// ca1[3] is not used ??
FA FA16(.a(sum0[6]),.b(mid[15]),.cin(ca1[2]),.sum(tmpsum1[3]),.cout(ca1[3]));


// step2
wire cap1[4:0];
// zi = 0 here
// calculate Sumxyz = Sumxy + z
HA HA2(.a(tmpsum1[0]),.b(1'b0),.sum(re[3]),.carry(cap1[0]));
FA FA17(.a(tmpsum1[1]),.b(1'b0),.cin(cap1[0]),.sum(re[4]),.cout(cap1[1])); 
FA FA18(.a(tmpsum1[2]),.b(1'b0),.cin(cap1[1]),.sum(re[5]),.cout(cap1[2]));
FA FA19(.a(tmpsum1[3]),.b(1'b0),.cin(cap1[2]),.sum(re[6]),.cout(cap1[3]));
FA FA20(.a(cap[6]),.b(/*1'b0*/ca1[3]),.cin(cap1[3]),.sum(re[7]),.cout(cap1[4])); // cap1[4] overflow 8-bit integer, just neglect

// end of multiplication


// re[7:0]: previous summation result, 8 bit

// summing c[11:0] and re[7:0] to result[11:0]

// declare carry
wire car[10:0];
HA HA3(.a(re[0]),.b(c[0]),.sum(result[0]),.carry(car[0]));
FA FA21(.a(re[1]),.b(c[1]),.cin(car[0]),.sum(result[1]),.cout(car[1])); 
FA FA22(.a(re[2]),.b(c[2]),.cin(car[1]),.sum(result[2]),.cout(car[2]));
FA FA23(.a(re[3]),.b(c[3]),.cin(car[2]),.sum(result[3]),.cout(car[3]));
FA FA24(.a(re[4]),.b(c[4]),.cin(car[3]),.sum(result[4]),.cout(car[4]));
FA FA25(.a(re[5]),.b(c[5]),.cin(car[4]),.sum(result[5]),.cout(car[5]));
FA FA26(.a(re[6]),.b(c[6]),.cin(car[5]),.sum(result[6]),.cout(car[6]));
FA FA27(.a(re[7]),.b(c[7]),.cin(car[6]),.sum(result[7]),.cout(car[7]));
FA FA28(.a(1'b0),.b(c[8]),.cin(car[7]),.sum(result[8]),.cout(car[8]));
FA FA29(.a(1'b0),.b(c[9]),.cin(car[8]),.sum(result[9]),.cout(car[9]));
FA FA30(.a(1'b0),.b(c[10]),.cin(car[9]),.sum(result[10]),.cout(car[10]));
// cout is deemed as noise 
FA FA31(.a(1'b0),.b(c[11]),.cin(car[10]),.sum(result[11]),.cout(cout)); 


endmodule

