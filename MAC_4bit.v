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
/* step 1: do and operation, PPG
wHAt we do was to decompose the multiplier 
since we can only do one bit at a time
*/

// produce shifted multipland

// a * b
// do And operation BIT BY BIT
wire mid0, mid1, mid2, mid3, mid4, mid5, mid6, mid7, mid8, mid9, mid10, mid11, mid12, mid13, mid14, mid15;
assign mid0 = a[0] & b[0];
assign mid1 = a[1] & b[0];
assign mid2 = a[2] & b[0];
assign mid3 = a[3] & b[0];
assign mid4 = a[0] & b[1];
assign mid5 = a[1] & b[1];
assign mid6 = a[2] & b[1];
assign mid7 = a[3] & b[1];
assign mid8 = a[0] & b[2];
assign mid9 = a[1] & b[2];
assign mid10 = a[2] & b[2];
assign mid11 = a[3] & b[2];
assign mid12 = a[0] & b[3];
assign mid13 = a[1] & b[3];
assign mid14 = a[2] & b[3];
assign mid15 = a[3] & b[3];

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
FA FA0(
  .a(mid0), 
  .b(1'b0), 
  .cin(1'b0),
  .sum(s0),
  .cout(c1)
);
/*
FA(mid1, mid4, 0,s1,c2);
FA(mid2, mid5, mid8,s2,c3);
FA(mid3, mid6, mid9,s3,c4);
FA(0, mid7, mid10,s4,c5);
FA(mid11,0,0,s5,c6); // pay attention to c6
*/
FA FA1(.a(mid1), .b(mid4), .cin(1'b0),.sum(s1),.cout(c2));
FA FA2(.a(mid2), .b(mid5), .cin(mid8),.sum(s2),.cout(c3));
FA FA3(.a(mid3), .b(mid6), .cin(mid9),.sum(s3),.cout(c4));
FA FA4(.a(1'b0), .b(mid7), .cin(mid10),.sum(s4),.cout(c5));
FA FA5(.a(mid11), .b(1'b0), .cin(1'b0),.sum(s5),.cout(c6));

// in step 2
wire c1p, c2p, c3p, c4p, c5p, c6p, c7p;//, c8p, c9p, c10p, c11p, c12p, c13p, c14p, c15p;

wire sum0, sum1, sum2, sum3, sum4, sum5, sum6;//, sum7, sum8, sum9, sum10, sum11, sum12, sum13, sum14, sum15;
/*
HA(s0,0,sum0,c1p);
FA(s1,c1,c1p,sum1,c2p);
FA(s2,c2,c2p,sum2,c3p);
FA(s3,c3,c3p,sum3,c4p);
FA(s4,c4,c4p,sum4,c5p);
FA(s5,c5,c5p,sum5,c6p);
FA(0,c6,c6p,sum6,c7p); // since s6 is not yet used
*/
HA HA1(.a(s0), .b(1'b0), .sum(sum0), .carry(c1p));
FA FA6(.a(s1),.b(c1),.cin(c1p),.sum(sum1),.cout(c2p));
FA FA7(.a(s2),.b(c2),.cin(c2p),.sum(sum2),.cout(c3p));
FA FA8(.a(s3),.b(c3),.cin(c3p),.sum(sum3),.cout(c4p));
FA FA9(.a(s4),.b(c4),.cin(c4p),.sum(sum4),.cout(c5p));
FA FA10(.a(s5),.b(c5),.cin(c5p),.sum(sum5),.cout(c6p));
FA FA11(.a(1'b0),.b(c6),.cin(c6p),.sum(sum6),.cout(c7p));


// calculate sum[6:0] + mid12~mid15
// first sum0,1,2 won't involve since it's 0 at the corresponding position at mid
// z = 0 here
wire ss0,ss1,ss2,ss3;
wire cc1, cc2, cc3, cc4; 
/*
FA(sum3,mid12,0,ss0,cc1);
FA(sum4,mid13,0,ss1,cc2);
FA(sum5,mid14,0,ss2,cc3);
FA(sum6,mid15,0,ss3,cc4); // attention to cc4
*/
FA FA12(.a(sum3),.b(mid12),.cin(1'b0),.sum(ss0),.cout(cc1));
FA FA13(.a(sum4),.b(mid13),.cin(1'b0),.sum(ss1),.cout(cc2));
FA FA14(.a(sum5),.b(mid14),.cin(1'b0),.sum(ss2),.cout(cc3));
FA FA15(.a(sum6),.b(mid15),.cin(1'b0),.sum(ss3),.cout(cc4));

// step 2 again
wire cc1p,cc2p,cc3p,cc4p,cc5p;
wire summ0, summ1, summ2, summ3, summ4;

// check here again
/*
HA HA2(ss0,0,summ0,cc1p);
FA(ss1,cc1,cc1p,summ1,cc2p);
FA(ss2,cc2,cc2p,summ2,cc3p);
FA(ss3,cc3,cc3p,summ3,cc4p);
FA(c7p,cc4,cc4p,summ4,cc5p); // cc5p should be always equal to 0, since we only 
*/
HA HA2(.a(ss0), .b(1'b0), .sum(summ0), .carry(cc1p));
FA FA16(.a(ss1),.b(cc1),.cin(cc1p),.sum(summ1),.cout(cc2p));
FA FA17(.a(ss2),.b(cc2),.cin(cc2p),.sum(summ2),.cout(cc3p));
FA FA18(.a(ss3),.b(cc3),.cin(cc3p),.sum(summ3),.cout(cc4p));
// check the c7p again
FA FA19(.a(c7p),.b(cc4),.cin(cc4p),.sum(summ4),.cout(cc5p));


// result: from high to low, from left to right
// summ4,3,2,1,0, sum2,1,0
// 8 bit in total


// cpa
// and input argument c[11:0] here
wire sa0, sa1, sa2, sa3, sa4, sa5, sa6, sa7, sa8, sa9, sa10, sa11;
wire ca1, ca2, ca3, ca4, ca5, ca6, ca7, ca8, ca9, ca10, ca11, ca12;
/*
HA(sum0,c[0],sa0,ca1);
FA(sum1,c[1],ca1,sa1,ca2);
FA(sum2,c[2],ca2,sa2,ca3);
FA(summ0,c[3],ca3,sa3,ca4);
FA(summ1,c[4],ca4,sa4,ca5);
FA(summ2,c[5],ca5,sa5,ca6);
FA(summ3,c[6],ca6,sa6,ca7);
FA(summ4,c[7],ca7,sa7,ca8);
FA(0,c[8],ca8,sa8,ca9);
FA(0,c[9],ca9,sa9,ca10);
FA(0,c[10],ca10,sa10,ca11);
FA(0,c[11],ca11,sa11,ca12);
*/

HA HA3(.a(sum0), .b(c[0]), .sum(sa0), .carry(ca1));
//20
FA FA20(.a(sum1),.b(c[1]),.cin(ca1),.sum(sa1),.cout(ca2));
FA FA21(.a(sum2),.b(c[2]),.cin(ca2),.sum(sa2),.cout(ca3));
FA FA22(.a(summ0),.b(c[3]),.cin(ca3),.sum(sa3),.cout(ca4));
FA FA23(.a(summ1),.b(c[4]),.cin(ca4),.sum(sa4),.cout(ca5));
FA FA24(.a(summ2),.b(c[5]),.cin(ca5),.sum(sa5),.cout(ca6));
FA FA25(.a(summ3),.b(c[6]),.cin(ca6),.sum(sa6),.cout(ca7));
FA FA26(.a(summ4),.b(c[7]),.cin(ca7),.sum(sa7),.cout(ca8));
FA FA27(.a(1'b0),.b(c[8]),.cin(ca8),.sum(sa8),.cout(ca8));
FA FA28(.a(1'b0),.b(c[9]),.cin(ca9),.sum(sa9),.cout(ca9));
FA FA29(.a(1'b0),.b(c[10]),.cin(ca10),.sum(sa10),.cout(ca10));
FA FA30(.a(1'b0),.b(c[11]),.cin(ca11),.sum(sa11),.cout(ca11));

// step2
wire sap0, sap1, sap2, sap3, sap4, sap5, sap6, sap7, sap8, sap9, sap10, sap11;
wire cap1, cap2, cap3, cap4, cap5, cap6, cap7, cap8, cap9, cap10, cap11;

/*
HA(sa0,0,result[0],cap1);
FA(sa1,ca1,cap1,result[1],cap2);
FA(sa2,ca2,cap2,result[2],cap3);
FA(sa3,ca3,cap3,result[3],cap4);
FA(sa4,ca4,cap4,result[4],cap5);
FA(sa5,ca5,cap5,result[5],cap6);
FA(sa6,ca6,cap6,result[6],cap7);
FA(sa7,ca7,cap7,result[7],cap8);
FA(sa8,ca8,cap8,result[8],cap9);
FA(sa9,ca9,cap9,result[9],cap10);
FA(sa10,ca10,cap10,result[10],cap11);
FA(sa11,ca11,cap11,result[11],cout);
*/

HA HA4(.a(sa0), .b(1'b0), .sum(result[0]), .carry(cap1));
FA FA31(.a(sa1), .b(ca1), .cin(cap1), .sum(result[1]), .cout(cap2));
FA FA32(.a(sa2), .b(ca2), .cin(cap2), .sum(result[2]), .cout(cap3));
FA FA33(.a(sa3), .b(ca3), .cin(cap3), .sum(result[3]), .cout(cap4));
FA FA34(.a(sa4), .b(ca4), .cin(cap4), .sum(result[4]), .cout(cap5));
FA FA35(.a(sa5), .b(ca5), .cin(cap5), .sum(result[5]), .cout(cap6));
FA FA36(.a(sa6), .b(ca6), .cin(cap6), .sum(result[6]), .cout(cap7));
FA FA37(.a(sa7), .b(ca7), .cin(cap7), .sum(result[7]), .cout(cap8));
FA FA38(.a(sa8), .b(ca8), .cin(cap8), .sum(result[8]), .cout(cap9));
FA FA39(.a(sa9), .b(ca9), .cin(cap9), .sum(result[9]), .cout(cap10));
FA FA40(.a(sa10), .b(ca10), .cin(cap10), .sum(result[10]), .cout(cap11));
FA FA41(.a(sa11), .b(ca11), .cin(cap11), .sum(result[11]), .cout(cout));

endmodule

