`include "MAC_4bit.v"
`timescale 1ns/10ps

module MAC_4bit_tb;
    reg [3:0]   a;
    reg [3:0]   b;
    reg [11:0]  c;
    wire [11:0] result;
    wire        cout;

    reg [11:0]  test_c[5] = {{12{1'b1}}, 12'b0, 12'b010101010101, 12'b101010101010, 12'b001100110011};

    reg [12:0]  extend_a;
    reg [12:0]  extend_b;
    reg [12:0]  answer;

    integer i, j, k;
    integer err;
    int tf;

    MAC_4bit MAC0(
        .a(a),
        .b(b),
        .c(c),
        .result(result),
        .cout(cout)
    );

    initial begin
        err = 0;

        for(i=32'b0; i<=32'b1111; i=i+1)begin
            for(j=32'b0; j<=32'b1111; j=j+1)begin
                for(k=0; k<5; k=k+1)begin
                    a = i[3:0];
                    b = j[3:0];
                    c = test_c[k];
                    extend_a = {9'b0, i[3:0]};
                    extend_b = {9'b0, j[3:0]};
                    answer = extend_a * extend_b + {1'b0, test_c[k]};
                    //-----------saturation opration----------
                    /*
                    if(answer < test_c[k])begin
                        answer = {12{1'b1}};
                    end
                    */
                    #1
                    if(answer !== {cout, result}) begin
                        $display("Error in case(%4b*%4b+%12b=%12b,cout=%1b)", i, j, test_c[k], answer[11:0], answer[12]);
                        $display("Your result: (%4b*%4b+%12b=%12b,cout=%1b)", i, j, test_c[k], result, cout);
                        err = err + 1;
                    end
                end
            end
        end
        if(err > 0)begin
            $display("****************************   /*\\_...._/*^\\");
            $display("**                        **  (/^\\       / \\)  ,");
            $display("**                        **    / X   X  \\   .' `-._");
            $display("**   OOPS!                **   |)  .    ()\\ /   _.'");
            $display("**                        **   \\   ^     ,; '. <");
            $display("**   MAC_4bit             **    ;.__     ,;|   > \\");
            $display("**   Simulation Failed!!  **   / ,    / ,  |.-'.-'");
            $display("**                        **  (_/    (_/ ,;|.<`");
            $display("**                        **    \\    ,     ;-`");
            $display("****************************     >   \\    /");
            $display("                                (_,-'`> .'");
            $display("                                     (_,'");
            $display("Totally has %d errors", err);
        end 
        else begin
            $display("                            `;-.          ___,");
            $display("****************************  `.`\\_...._/`.-\"`");
            $display("**                        **    \\        /      ,");
            $display("**                        **    /()   () \\   .' `-._");
            $display("**   Congratulations !!   **   |)  .    ()\\ /   _.'");
            $display("**                        **   \\  -'-     ,; '. <");
            $display("**   MAC_4bit             **    ;.__     ,;|   > \\");
            $display("**   Simulation PASS!!    **   / ,    / ,  |.-'.-'");
            $display("**                        **  (_/    (_/ ,;|.<`");
            $display("**                        **    \\    ,     ;-`");
            $display("****************************     >   \\    /");
            $display("                                (_,-'`> .'");
            $display("                                     (_,'");
        end
    end

endmodule


