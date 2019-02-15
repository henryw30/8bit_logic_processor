//16 bit carry select adder
module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     
   logic c4, c8, c12;
   
	//initial adder (only 1 carry ripple adder)
   four_bit_radder a0(.x(A[3:0]), .y(B[3:0]), .c_in(0), .s(Sum[3:0]), .cout(c4));
   
	//other 3 adders (with 2 carry ripple adders)
	two_cra a1(.x(A[7:4]), .y(B[7:4]), .c_in(c4), .s(Sum[7:4]), .c_out(c8));
	two_cra a2(.x(A[11:8]), .y(B[11:8]), .c_in(c8), .s(Sum[11:8]), .c_out(c12));
   two_cra a3(.x(A[15:12]), .y(B[15:12]), .c_in(c12), .s(Sum[15:12]), .c_out(CO));
     
endmodule


//2 carry ripple adder for carry select adder
module two_cra(
               input [3:0] x,
               input [3:0] y,
               input c_in,
               output logic [3:0] s,
               output c_out
               );
               
   logic [3:0] mux_0; //output for ripple adder 0
   logic [3:0] mux_1; //output for ripple adder 1
		
   logic c_out_0;     //carry for ripple adder 0
   logic c_out_1;     //carry for ripple adder 1

   //add x and y for c_in as both 0 and 1
   four_bit_radder add_0(.x(x[3:0]), .y(y[3:0]), .c_in(0), .s(mux_0), .cout(c_out_0));
   four_bit_radder add_1(.x(x[3:0]), .y(y[3:0]), .c_in(1), .s(mux_1), .cout(c_out_1));
   
   assign c_out = (c_out_1 & c_in) | c_out_0;
	
	//mux; if c_in = 1, make sum = output of MUX 1; else = output of MUX 2
	always_comb
	begin: select
		if(c_in == 1'b1)
		begin
			s = mux_1;
		end else begin
			s = mux_0;
		end
   end
   
   
endmodule 