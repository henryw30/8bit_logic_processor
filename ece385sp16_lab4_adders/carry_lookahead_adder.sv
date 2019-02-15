module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     
	  logic pg0, pg4, pg8, pg12;
	  logic gg0, gg4, gg8, gg12;
	  
	  
	  four_bit_cla cla0(.x(A[3:0]), .y(B[3:0]), .c_in(0), .s(Sum[3:0]), .pg(pg0), .gg(gg0));
	  
	  assign c4 = gg0; //| (c_in & pg0);
	  
	  
	  four_bit_cla cla1(.x(A[7:4]), .y(B[7:4]), .c_in(c4), .s(Sum[7:4]), .pg(pg4), .gg(gg4));
	  
	  assign c8 = gg4 | (gg0 & pg4); //| (c_in & pg0 & pg4);
	  four_bit_cla cla2(.x(A[11:8]), .y(B[11:8]), .c_in(c8), .s(Sum[11:8]), .pg(pg8), .gg(gg8));
	  
	  assign c12 = gg8 | (gg4 & pg8) | (gg0 & pg8 & pg4); //| (c_in & pg8 & pg4 & pg0);
	  four_bit_cla cla3(.x(A[15:12]), .y(B[15:12]), .c_in(c12), .s(Sum[15:12]), .pg(pg12), .gg(gg12));
	  
	  assign CO = gg12 | (gg8 & pg12) | (gg4 & pg12 & pg8) | (gg0 & pg12 & pg8 & pg4); //| (c_in & pg12 & pg8 & pg4 & pg0)
	  
endmodule

module four_bit_cla(
							input [3:0] x,
							input [3:0] y,
							input c_in,
							output [3:0] s,
							output logic pg,
							output logic gg
							);
	
	//calculating P
	assign  p0 = x[0] ^ y[0];
	assign  p1 = x[1] ^ y[1];
	assign  p2 = x[2] ^ y[2];
	assign  p3 = x[3] ^ y[3];
	
	//calculating G
	assign  g0 = x[0] & y[0];
	assign  g1 = x[1] & y[1];
	assign  g2 = x[2] & y[2];
	assign  g3 = x[3] & y[3];
	
	//calculating Pp and Gg
	assign pg = p0 & p1 & p2 & p3;
	assign gg = g3 | (g2 & p3) | (g1 & p3 & p2) | (g0 & p3 & p2 & p1);
	
	
	//generating carry bits
	assign  c1 = (c_in & p0) | g0;
	assign  c2 = (c_in & p0 & p1) | (g0 & p1) | g1;
	assign  c3 = (c_in & p0 & p1 & p2) | (g0 & p1 & p2) | (g1 & p2) | g2;
	//c_out =           (c_in & p0 & p1 & p2 & p3) | (g0 & p1 & p2 & p3) | (g1 & p2 & p3) | (g2 & p3) | g3;
	
	//doing addition					
	one_bit_cla fa0(.x(x[0]), .y(y[0]), .c_in(c_in), .s(s[0]));
	one_bit_cla fa1(.x(x[1]), .y(y[1]), .c_in( c1 ), .s(s[1]));
	one_bit_cla fa2(.x(x[2]), .y(y[2]), .c_in( c2 ), .s(s[2]));
	one_bit_cla fa3(.x(x[3]), .y(y[3]), .c_in( c3 ), .s(s[3]));
	
endmodule 


//1 bit full adder; generates sum
module one_bit_cla(
							input x,
							input y,
							input c_in,
							output logic s
						);
						
	assign s = x ^ y ^ c_in;
						
						
endmodule 