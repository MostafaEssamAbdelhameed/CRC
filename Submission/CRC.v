`timescale 1ns / 1ps


module CRC  (
    //input [7:0] DATA,
    input DATA,
    input ACTIVE,
    input CLK,
    input RST,
    output reg CRC,
    output reg Valid
    );
    
    parameter [7:0] seed = 8'hD8;
    parameter [7:0] taps = 8'b01000100;
    reg [7:0] LFSR;
    wire feedback ;
    wire done;
    reg [3:0] cntr;
    integer j;
    
    assign done = (cntr == 8)? 1:0;

    assign feedback = LFSR[0] ^ DATA;

    always @(posedge CLK or negedge RST) begin 
        if(!RST) begin
            LFSR <= seed;
            CRC <= 0;
            cntr <= 0;
            Valid <= 0;
            
        end
        else if (ACTIVE && !done) begin
              LFSR[7] <= feedback;
              cntr <= cntr + 1 ;
              if(cntr ==7) Valid = 1;
              for (j=0 ; j<7 ; j=j+1) begin
                if (taps[j]) LFSR[j] <= LFSR[j+1] ^ feedback;
                else LFSR[j] <= LFSR[j+1] ; 
              end
        end
        else if (done==1) begin
            {LFSR[6:0],CRC} <= LFSR ;
            Valid <= 1;

        end   
    end 
    
endmodule
