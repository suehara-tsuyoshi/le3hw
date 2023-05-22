// Copyright (C) 2017  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to  
// suit user's needs .Comments are provided in each section to help the user    
// fill out necessary details.                                                  
// *****************************************************************************
// Generated on "04/19/2021 12:00:27"
                                                                                
// Verilog Test Bench template for design : simple
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ps
module simple_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg clock;
reg [15:0] outside_input;
reg reset;
// wires                                               
wire [3:0]  cond_register;
wire [15:0]  data_register;
wire [15:0]  instruciton_register;
wire [15:0]  mdr;
wire [15:0]  program_counter;
wire [15:0]  r0;
wire [15:0]  r1;
wire [15:0]  r2;
wire [15:0]  r3;
wire [2:0]  state_out;
wire [15:0] m0;
wire [15:0] dfw;
wire [15:0] add;
wire wren_out;

// assign statements (if any)                          
simple i1 (
// port map - connection between master ports and signals/registers   
	.clock(clock),
	.cond_register(cond_register),
	.data_register(data_register),
	.instruciton_register(instruciton_register),
	.mdr(mdr),
	.outside_input(outside_input),
	.program_counter(program_counter),
	.r0(r0),
	.r1(r1),
	.r2(r2),
	.r3(r3),
	.reset(reset),
	.state_out(state_out),
	.m0(m0),
	.dfw(dfw),
	.add(add),
	.wren_out(wren_out)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin   

	reset <= 1'b0;
	clock <= 1'b0;
	outside_input <= 16'b0000_0000_0000_0000;                       
                                                       
// --> end                                             
$display("Running testbench");                       
end                                                    
always                                                 
// optional sensitivity list                           
// @(event1 or event2 or .... eventn)                  
begin                                                  
// code executes for every event on sensitivity list   
// insert code here --> begin      

	#70
	reset <= 1'b1;                    
                                                       
@eachvec;                                              
// --> end                                             
end           
always begin
	#50
	clock = ~clock;
end                                         
endmodule

