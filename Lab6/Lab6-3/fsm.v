`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:27:40 04/09/2015 
// Design Name: 
// Module Name:    fsm 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define STAT_LEFT 3'd0
`define STAT_RIGHT_ADD 3'd1
`define STAT_RIGHT_MINUS 3'd2
`define STAT_EQUAL_ADD 3'd3
`define STAT_EQUAL_MINUS 3'd4
`define DISABLED 1'b0
`define ENABLED 1'b1
module fsm(
	num_enable1, //number storage enabled 1
	num_enable2, //number storage enabled 2
	ans_enable, //answer enable
	state, //state output
	add, //add button input
	minus, //minus button input
	equal, //equal button input
	clk, //global clock signal
	rst_n //low active reset
);

output num_enable1; //number storage enabled 1
output num_enable2; //number storage enabled 2
output ans_enable; //answer enable
output state; //state output
input clk; //global signal input
input rst_n; //low active reset
input add; //add button input
input minus; //minus button input
input equal; //equal button input

reg num_enable1; //number storage enabled 1
reg num_enable2; //number storage enabled 2 
reg ans_enable; //answer enable
reg [2:0] state; //state of FSM
reg [2:0] next_state; //next state of FSM

//FSM state transition
always @(posedge clk or negedge rst_n)
	if(~rst_n)
		state <= 2'd0;
	else
		state <= next_state;                                      

//FSM state decision
always @*
	case(state)
		`STAT_LEFT:
			if(~add)
				begin
					next_state = `STAT_RIGHT_ADD;
					num_enable1 = `DISABLED;
					num_enable2 = `ENABLED;
					ans_enable = `DISABLED;
				end
			else if(~minus)
				begin
					next_state = `STAT_RIGHT_MINUS;
					num_enable1 = `DISABLED;
					num_enable2 = `ENABLED;
					ans_enable = `DISABLED;
				end
			else
				begin
					next_state = `STAT_LEFT;
					num_enable1 = `ENABLED;
					num_enable2 = `DISABLED;
					ans_enable = `DISABLED;
				end
		`STAT_RIGHT_ADD:
			if(~minus)
				begin
					next_state = `STAT_RIGHT_MINUS;
					num_enable1 = `DISABLED;
					num_enable2 = `ENABLED;
					ans_enable = `DISABLED;
				end
			else if(~equal)
				begin
					next_state = `STAT_EQUAL_ADD;
					num_enable1 = `DISABLED;
					num_enable2 = `DISABLED;
					ans_enable = `ENABLED;
				end
			else
				begin
					next_state = `STAT_RIGHT_ADD;
					num_enable1 = `DISABLED;
					num_enable2 = `ENABLED;
					ans_enable = `DISABLED;
				end
		`STAT_RIGHT_MINUS:
			if(~add)
				begin
					next_state = `STAT_RIGHT_ADD;
					num_enable1 = `DISABLED;
					num_enable2 = `ENABLED;
					ans_enable = `DISABLED;
				end
			else if(~equal)
				begin
					next_state = `STAT_EQUAL_MINUS;
					num_enable1 = `DISABLED;
					num_enable2 = `DISABLED;
					ans_enable = `ENABLED;
				end
			else
				begin
					next_state = `STAT_RIGHT_MINUS;
					num_enable1 = `DISABLED;
					num_enable2 = `ENABLED;
					ans_enable = `DISABLED;
				end
		`STAT_EQUAL_ADD:
			begin
				next_state = `STAT_EQUAL_ADD;
				num_enable1 = `DISABLED;
				num_enable2 = `DISABLED;
				ans_enable = `ENABLED;
			end
		`STAT_EQUAL_MINUS:
			begin
				next_state = `STAT_EQUAL_MINUS;
				num_enable1 = `DISABLED;
				num_enable2 = `DISABLED;
				ans_enable = `ENABLED;
			end
		default:
			begin
				next_state = `STAT_LEFT;
				num_enable1 = `ENABLED;
				num_enable2 = `DISABLED;
				ans_enable = `DISABLED;
			end
	endcase
endmodule