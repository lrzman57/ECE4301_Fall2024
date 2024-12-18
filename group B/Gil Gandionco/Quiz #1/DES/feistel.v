`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2024 02:34:29 AM
// Design Name: 
// Module Name: feistel_function
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module feistel_function (
    input  [31:0] R_in,          // 32-bit right half
    input  [47:0] round_key,     // 48-bit round key
    output [31:0] R_out          // 32-bit output
);
    wire [47:0] E_out;           // Expanded output
    wire [47:0] xor_out;         // XOR output (with round key)
    wire [31:0] S_out;           // S-box output
    wire [31:0] P_out;           // Permutation output

    // Corrected Expansion E-Box
    assign E_out = {
        R_in[31], R_in[0],  R_in[1],  R_in[2],  R_in[3],  R_in[4],
        R_in[3],  R_in[4],  R_in[5],  R_in[6],  R_in[7],  R_in[8],
        R_in[7],  R_in[8],  R_in[9],  R_in[10], R_in[11], R_in[12],
        R_in[11], R_in[12], R_in[13], R_in[14], R_in[15], R_in[16],
        R_in[15], R_in[16], R_in[17], R_in[18], R_in[19], R_in[20],
        R_in[19], R_in[20], R_in[21], R_in[22], R_in[23], R_in[24],
        R_in[23], R_in[24], R_in[25], R_in[26], R_in[27], R_in[28],
        R_in[27], R_in[28], R_in[29], R_in[30], R_in[31], R_in[0]
    };

    // XOR with round key
    assign xor_out = E_out ^ round_key;

    // S-Box Substitution
    sbox1 s1 (.in(xor_out[47:42]), .out(S_out[31:28]));
    sbox2 s2 (.in(xor_out[41:36]), .out(S_out[27:24]));
    sbox3 s3 (.in(xor_out[35:30]), .out(S_out[23:20]));
    sbox4 s4 (.in(xor_out[29:24]), .out(S_out[19:16]));
    sbox5 s5 (.in(xor_out[23:18]), .out(S_out[15:12]));
    sbox6 s6 (.in(xor_out[17:12]), .out(S_out[11:8]));
    sbox7 s7 (.in(xor_out[11:6]),  .out(S_out[7:4]));
    sbox8 s8 (.in(xor_out[5:0]),   .out(S_out[3:0]));

    // Corrected Permutation P-Box
    assign P_out = {
        S_out[15], S_out[6],  S_out[19], S_out[20],
        S_out[28], S_out[11], S_out[27], S_out[16],
        S_out[0],  S_out[14], S_out[22], S_out[25],
        S_out[4],  S_out[17], S_out[30], S_out[9],
        S_out[1],  S_out[7],  S_out[23], S_out[13],
        S_out[31], S_out[26], S_out[2],  S_out[8],
        S_out[18], S_out[12], S_out[29], S_out[5],
        S_out[21], S_out[10], S_out[3],  S_out[24]
    };

    // Final output after permutation
    assign R_out = P_out;
endmodule