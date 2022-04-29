`include "MAC_4bit.v"
module MAC_8bit (
    input   [7:0]   a,
    input   [7:0]   b,
    input   [23:0]  c,
    output  [23:0]  result,
    output          cout
);

/* Here is your code */
/*
module MAC_4bit (
    input   [3:0]   a,
    input   [3:0]   b,
    input   [11:0]  c,
    output  [11:0]  result,
    output          cout
);
*/
wire [3:0] a1;
wire [3:0] a2;
//assign a1[%d] = a[%d];
assign a1[0] = a[0];
assign a1[1] = a[1];
assign a1[2] = a[2];
assign a1[3] = a[3];

assign a2[0] = a[4];
assign a2[1] = a[5];
assign a2[2] = a[6];
assign a2[3] = a[7];

wire [3:0] b1;
wire [3:0] b2;

assign b1[0] = b[0];
assign b1[1] = b[1];
assign b1[2] = b[2];
assign b1[3] = b[3];

assign b2[0] = b[4];
assign b2[1] = b[5];
assign b2[2] = b[6];
assign b2[3] = b[7];

// expansion
wire [11:0] one;
wire cone; // cone == 0, since a1 * b1 = 8 bit
MAC_4bit MAC_4bit0(.a(a1[3:0]),.b(b1[3:0]),.c(12'b0),.result(one[11:0]),.cout(cone));

// shift: only frist 8 bit is what we want

// shift: 4 bit
wire [11:0] twop;
wire ctwo; // ctwo == 0
MAC_4bit MAC_4bit1(.a(a1[3:0]),.b(b2[3:0]),.c(12'b0),.result(twop[11:0]),.cout(ctwo));

wire [11:0] threep;
wire cthree; // == 0
MAC_4bit MAC_4bit2(.a(a2[3:0]),.b(b1[3:0]),.c(12'b0),.result(threep[11:0]),.cout(cthree));


// shift: 8 bit
wire [11:0] fourp;
wire cfour; // == 0
MAC_4bit MAC_4bit3(.a(a2[3:0]),.b(b2[3:0]),.c(12'b0),.result(fourp[11:0]),.cout(cfour));


// shift those (twop, threep, fourp)
wire [11:0] two;
wire [11:0] three;

// shift 8 bit + 12 bit = 20 bit
wire [19:0] four;

assign two[0] = 1'b0;
assign two[1] = 1'b0;
assign two[2] = 1'b0;
assign two[3] = 1'b0;

assign three[0] = 1'b0;
assign three[1] = 1'b0;
assign three[2] = 1'b0;
assign three[3] = 1'b0;

assign four[0] = 1'b0;
assign four[1] = 1'b0;
assign four[2] = 1'b0;
assign four[3] = 1'b0;
assign four[4] = 1'b0;
assign four[5] = 1'b0;
assign four[6] = 1'b0;
assign four[7] = 1'b0;

// fill the numbers back in
assign two[4] = twop[0];
assign two[5] = twop[1];
assign two[6] = twop[2];
assign two[7] = twop[3];
assign two[8] = twop[4];
assign two[9] = twop[5];
assign two[10] = twop[6];
assign two[11] = twop[7];

assign three[4] = threep[0];
assign three[5] = threep[1];
assign three[6] = threep[2];
assign three[7] = threep[3];
assign three[8] = threep[4];
assign three[9] = threep[5];
assign three[10] = threep[6];
assign three[11] = threep[7];


assign four[8] = fourp[0];
assign four[9] = fourp[1];
assign four[10] = fourp[2];
assign four[11] = fourp[3];
assign four[12] = fourp[4];
assign four[13] = fourp[5];
assign four[14] = fourp[6];
assign four[15] = fourp[7];
assign four[16] = fourp[8];
assign four[17] = fourp[9];
assign four[18] = fourp[10];
assign four[19] = fourp[11];


// consider the carry

// CSA again

// step 1

// res = a + b + c 
// or, res = one + two + three
wire [11:0] res; 
// carry: 12 bit // from 0
wire [11:0] car; 

//FA FA%d(.a(one[%d]),.b(two[%d]),.cin(three[%d]),.sum(res[%d]),.cout(car[%d]));

FA FA0(.a(one[0]),.b(two[0]),.cin(three[0]),.sum(res[0]),.cout(car[0]));
FA FA1(.a(one[1]),.b(two[1]),.cin(three[1]),.sum(res[1]),.cout(car[1]));
FA FA2(.a(one[2]),.b(two[2]),.cin(three[2]),.sum(res[2]),.cout(car[2]));
FA FA3(.a(one[3]),.b(two[3]),.cin(three[3]),.sum(res[3]),.cout(car[3]));
FA FA4(.a(one[4]),.b(two[4]),.cin(three[4]),.sum(res[4]),.cout(car[4]));
FA FA5(.a(one[5]),.b(two[5]),.cin(three[5]),.sum(res[5]),.cout(car[5]));
FA FA6(.a(one[6]),.b(two[6]),.cin(three[6]),.sum(res[6]),.cout(car[6]));
FA FA7(.a(one[7]),.b(two[7]),.cin(three[7]),.sum(res[7]),.cout(car[7]));
FA FA8(.a(one[8]),.b(two[8]),.cin(three[8]),.sum(res[8]),.cout(car[8]));
FA FA9(.a(one[9]),.b(two[9]),.cin(three[9]),.sum(res[9]),.cout(car[9]));
FA FA10(.a(one[10]),.b(two[10]),.cin(three[10]),.sum(res[10]),.cout(car[10]));
FA FA11(.a(one[11]),.b(two[11]),.cin(three[11]),.sum(res[11]),.cout(car[11])); // car[11] ?? 

// step 2
wire tmpsum[12:0];
wire carp[12:0];

HA HA0(.a(res[0]),.b(1'b0),.sum(tmpsum[0]),.carry(carp[0]));

//FA FA%d(.a(res[%d]),.b(car[%d]),.cin(carp[%d]),.sum(tmpsum[%d]),.cout(carp[%d]));
FA FA12(.a(res[1]),.b(car[0]),.cin(carp[0]),.sum(tmpsum[1]),.cout(carp[1]));
FA FA13(.a(res[2]),.b(car[1]),.cin(carp[1]),.sum(tmpsum[2]),.cout(carp[2]));
FA FA14(.a(res[3]),.b(car[2]),.cin(carp[2]),.sum(tmpsum[3]),.cout(carp[3]));
FA FA15(.a(res[4]),.b(car[3]),.cin(carp[3]),.sum(tmpsum[4]),.cout(carp[4]));
FA FA16(.a(res[5]),.b(car[4]),.cin(carp[4]),.sum(tmpsum[5]),.cout(carp[5]));
FA FA17(.a(res[6]),.b(car[5]),.cin(carp[5]),.sum(tmpsum[6]),.cout(carp[6]));
FA FA18(.a(res[7]),.b(car[6]),.cin(carp[6]),.sum(tmpsum[7]),.cout(carp[7]));
FA FA19(.a(res[8]),.b(car[7]),.cin(carp[7]),.sum(tmpsum[8]),.cout(carp[8]));
FA FA20(.a(res[9]),.b(car[8]),.cin(carp[8]),.sum(tmpsum[9]),.cout(carp[9]));
FA FA21(.a(res[10]),.b(car[9]),.cin(carp[9]),.sum(tmpsum[10]),.cout(carp[10]));
// attention to carp[11] !!, which should be at 12th bit (from 0)
FA FA22(.a(res[11]),.b(car[10]),.cin(carp[10]),.sum(tmpsum[11]),.cout(carp[11])); // carp[11] ?

// car[11] and carp[11]
FA FA100(.a(1'b0),.b(car[11]),.cin(carp[11]),.sum(tmpsum[12]),.cout(carp[12])); // carp[12] 

// CPA
// tmpsum + four

// step 1
wire [20:0] re;
wire [19:0] ca;

HA HA1(.a(tmpsum[0]),.b(four[0]),.sum(re[0]),.carry(ca[0]));

//FA FA%d(.a(tmpsum[%d]),.b(four[%d]),.cin(ca[%d]),.sum(re[%d]),.cout(ca[%d]));
FA FA23(.a(tmpsum[1]),.b(four[1]),.cin(ca[0]),.sum(re[1]),.cout(ca[1]));
FA FA24(.a(tmpsum[2]),.b(four[2]),.cin(ca[1]),.sum(re[2]),.cout(ca[2]));
FA FA25(.a(tmpsum[3]),.b(four[3]),.cin(ca[2]),.sum(re[3]),.cout(ca[3]));
FA FA26(.a(tmpsum[4]),.b(four[4]),.cin(ca[3]),.sum(re[4]),.cout(ca[4]));
FA FA27(.a(tmpsum[5]),.b(four[5]),.cin(ca[4]),.sum(re[5]),.cout(ca[5]));
FA FA28(.a(tmpsum[6]),.b(four[6]),.cin(ca[5]),.sum(re[6]),.cout(ca[6]));
FA FA29(.a(tmpsum[7]),.b(four[7]),.cin(ca[6]),.sum(re[7]),.cout(ca[7]));
FA FA30(.a(tmpsum[8]),.b(four[8]),.cin(ca[7]),.sum(re[8]),.cout(ca[8]));
FA FA31(.a(tmpsum[9]),.b(four[9]),.cin(ca[8]),.sum(re[9]),.cout(ca[9]));
FA FA32(.a(tmpsum[10]),.b(four[10]),.cin(ca[9]),.sum(re[10]),.cout(ca[10]));
FA FA33(.a(tmpsum[11]),.b(four[11]),.cin(ca[10]),.sum(re[11]),.cout(ca[11]));

FA FA34(.a(tmpsum[12]),.b(four[12]),.cin(ca[11]),.sum(re[12]),.cout(ca[12]));
FA FA35(.a(carp[12]),.b(four[13]),.cin(ca[12]),.sum(re[13]),.cout(ca[13]));

FA FA36(.a(1'b0),.b(four[14]),.cin(ca[13]),.sum(re[14]),.cout(ca[14]));
FA FA37(.a(1'b0),.b(four[15]),.cin(ca[14]),.sum(re[15]),.cout(ca[15]));

// fill the rest re[20:16] with four[19:16] 
FA FA38(.a(1'b0),.b(four[16]),.cin(ca[15]),.sum(re[16]),.cout(ca[16]));
FA FA39(.a(1'b0),.b(four[17]),.cin(ca[16]),.sum(re[17]),.cout(ca[17]));
FA FA40(.a(1'b0),.b(four[18]),.cin(ca[17]),.sum(re[18]),.cout(ca[18]));
FA FA41(.a(1'b0),.b(four[19]),.cin(ca[18]),.sum(re[19]),.cout(ca[19]));
assign re[20] = ca[19]; // 21 bit in re in total


// step 2
// since z == 0, it's negligible ?

// be careful about the carry ca[19]


// end of multiplication


// re[20:0] + c[23:0]
// plain addition

wire ccc[22:0]; // carry

HA HA2(.a(re[0]),.b(c[0]),.sum(result[0]),.carry(ccc[0]));

//FA FA%d(.a(re[%d]),.b(c[%d]),.cin(ccc[%d]),.sum(result[%d]),.cout(ccc[%d]));
FA FA42(.a(re[1]),.b(c[1]),.cin(ccc[0]),.sum(result[1]),.cout(ccc[1]));
FA FA43(.a(re[2]),.b(c[2]),.cin(ccc[1]),.sum(result[2]),.cout(ccc[2]));
FA FA44(.a(re[3]),.b(c[3]),.cin(ccc[2]),.sum(result[3]),.cout(ccc[3]));
FA FA45(.a(re[4]),.b(c[4]),.cin(ccc[3]),.sum(result[4]),.cout(ccc[4]));
FA FA46(.a(re[5]),.b(c[5]),.cin(ccc[4]),.sum(result[5]),.cout(ccc[5]));
FA FA47(.a(re[6]),.b(c[6]),.cin(ccc[5]),.sum(result[6]),.cout(ccc[6]));
FA FA48(.a(re[7]),.b(c[7]),.cin(ccc[6]),.sum(result[7]),.cout(ccc[7]));
FA FA49(.a(re[8]),.b(c[8]),.cin(ccc[7]),.sum(result[8]),.cout(ccc[8]));
FA FA50(.a(re[9]),.b(c[9]),.cin(ccc[8]),.sum(result[9]),.cout(ccc[9]));
FA FA51(.a(re[10]),.b(c[10]),.cin(ccc[9]),.sum(result[10]),.cout(ccc[10]));
FA FA52(.a(re[11]),.b(c[11]),.cin(ccc[10]),.sum(result[11]),.cout(ccc[11]));
FA FA53(.a(re[12]),.b(c[12]),.cin(ccc[11]),.sum(result[12]),.cout(ccc[12]));
FA FA54(.a(re[13]),.b(c[13]),.cin(ccc[12]),.sum(result[13]),.cout(ccc[13]));
FA FA55(.a(re[14]),.b(c[14]),.cin(ccc[13]),.sum(result[14]),.cout(ccc[14]));
FA FA56(.a(re[15]),.b(c[15]),.cin(ccc[14]),.sum(result[15]),.cout(ccc[15]));
FA FA57(.a(re[16]),.b(c[16]),.cin(ccc[15]),.sum(result[16]),.cout(ccc[16]));
FA FA58(.a(re[17]),.b(c[17]),.cin(ccc[16]),.sum(result[17]),.cout(ccc[17]));
FA FA59(.a(re[18]),.b(c[18]),.cin(ccc[17]),.sum(result[18]),.cout(ccc[18]));
FA FA60(.a(re[19]),.b(c[19]),.cin(ccc[18]),.sum(result[19]),.cout(ccc[19]));
FA FA61(.a(re[20]),.b(c[20]),.cin(ccc[19]),.sum(result[20]),.cout(ccc[20]));

FA FA62(.a(1'b0),.b(c[21]),.cin(ccc[20]),.sum(result[21]),.cout(ccc[21]));
FA FA63(.a(1'b0),.b(c[22]),.cin(ccc[21]),.sum(result[22]),.cout(ccc[22]));
FA FA64(.a(1'b0),.b(c[23]),.cin(ccc[22]),.sum(result[23]),.cout(cout));



endmodule


