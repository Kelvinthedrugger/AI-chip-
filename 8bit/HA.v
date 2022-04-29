// copy from files/HA.v
/*half adder*/
// i would say it's an 1-bit half adder?
/*
module HA(
    input a,
    input b,
    output sum,carry
);*/

module HA(a,b,sum,carry);
input a,b;
output sum,carry;
wire sum,carry;
assign sum = a ^ b; // a xor b
assign carry = a & b; // a and b
endmodule


