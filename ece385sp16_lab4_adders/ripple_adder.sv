//a 16 bit ripple adder using the 4 bit ripple adder
module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  
	  logic c0, c1, c2; //carry lines

     
	  four_bit_radder fbra0(.x(A[3:0]), .y(B[3:0]), .c_in(0), .s(Sum[3:0]), .cout(c0));	//same concept from the 4 bit ripple adder, send carry bit to input carry
	  four_bit_radder fbra1(.x(A[7:4]), .y(B[7:4]), .c_in(c0), .s(Sum[7:4]), .cout(c1)); //of the next 4 bit rippler adder
	  four_bit_radder fbra2(.x(A[11:8]), .y(B[11:8]), .c_in(c1), .s(Sum[11:8]), .cout(c2));
	  four_bit_radder fbra3(.x(A[15:12]), .y(B[15:12]), .c_in(c2), .s(Sum[15:12]), .cout(CO));
	    
	  
endmodule


//a 4 bit rippler adder using the full adder below
module four_bit_radder( input [3:0] x,
								input [3:0] y,
								input c_in,
								output logic [3:0] s,
								output logic cout);
								
	logic c0, c1, c2; //carry lines
	
	full_adder fa0(.x(x[0]), .y(y[0]), .c_in(c_in), .s(s[0]), .cout(c0)); //this cout goes to c_in of next full adder (fa1)
	full_adder fa1(.x(x[1]), .y(y[1]), .c_in(c0), .s(s[1]), .cout(c1));	//same idea for all fa's
	full_adder fa2(.x(x[2]), .y(y[2]), .c_in(c1), .s(s[2]), .cout(c2));
	full_adder fa3(.x(x[3]), .y(y[3]), .c_in(c2), .s(s[3]), .cout(cout));

endmodule


//a full adder using 1 bit
module full_adder(input x, 
						input y, 
						input c_in, 
						output logic s,
						output logic cout);
			
	assign s = x ^ y ^ c_in;
	assign cout = (x & y) | (y & c_in) | (x & c_in);
	
						
endmodule 