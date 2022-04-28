/*full adder*/
module FAA(a,b,cin,sum,cout);
input a,b, cin;
output sum,cout;
wire sum,cout;
assign sum = a ^ b ^ cin;
assign cout = (a&b) | (a & cin) | (b & cin);
endmodule

