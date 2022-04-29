`include "MAC_8bit.v"
`timescale 1ns/10ps

module MAC_8bit_tb;
    reg [7:0]   a;
    reg [7:0]   b;
    reg [23:0]  c;
    wire [23:0] result;
    wire        cout;
    
    reg [23:0]  test_c[5] = {{24{1'b1}}, 24'b0, 24'b010101010101010101010101010101010101, 24'b101010101010101010101010101010101010, 24'b001100110011001100110011001100110011};

    reg [24:0]  extend_a;
    reg [24:0]  extend_b;
    reg [24:0]  answer;

    integer i, j, k;
    integer err;
    int tf;

    MAC_8bit MAC0(
        .a(a),
        .b(b),
        .c(c),
        .result(result),
        .cout(cout)
    );

    initial begin
        err = 0;

        for(i=32'b0; i<=32'b11111111; i=i+1)begin
            for(j=32'b0; j<=32'b11111111; j=j+1)begin
                for(k=0; k<5; k=k+1)begin
                    a = i[7:0];
                    b = j[7:0];
                    c = test_c[k];
                    extend_a = {17'b0, i[7:0]};
                    extend_b = {17'b0, j[7:0]};
                    answer = extend_a * extend_b + {1'b0, test_c[k]};
                    //-----------saturation opration----------
                    /*
                    if(answer < test_c[k])begin
                        answer = {24{1'b1}};
                    end
                    */
                    #1
                    if(answer !== {cout, result}) begin
                        $display("Error in case(%8b*%8b+%24b=%24b,cout=%1b)", i, j, test_c[k], answer[23:0], answer[24]);
                        $display("Your result: (%8b*%8b+%24b=%24b,cout=%1b)", i, j, test_c[k], result, cout);
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
            $display("**   MAC_8bit             **    ;.__     ,;|   > \\");
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
            $display("**   MAC_8bit             **    ;.__     ,;|   > \\");
            $display("**   Simulation PASS!!    **   / ,    / ,  |.-'.-'");
            $display("**                        **  (_/    (_/ ,;|.<`");
            $display("**                        **    \\    ,     ;-`");
            $display("****************************     >   \\    /");
            $display("                                (_,-'`> .'");
            $display("                                     (_,'");
        end
    end

endmodule



