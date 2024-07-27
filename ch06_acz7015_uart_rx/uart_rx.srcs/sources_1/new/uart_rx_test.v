//////////////////////////////////////////////////////////////////////////////////
// Company: �人о·��Ƽ����޹�˾
// Engineer: www.corecourse.cn
// 
// Create Date: 2021/09/20 00:00:00
// Design Name: uart_rx
// Module Name: uart_rx_test
// Project Name: uart_rx
// Target Devices: xc7z020clg400-2
// Tool Versions: Vivado 2018.3
// Description: ���ڽ��հ弶���Զ���
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module uart_rx_test(
	clk,
	reset_n,

	uart_rx
);
    wire reset;
	assign reset=~reset_n;

	input clk; //ϵͳʱ�����룬50M
	input reset_n; //��λ�ź����룬����Ч

	input uart_rx; //���������ź�
	
	wire [7:0]data_byte_rx;
	wire rx_done;
  
	reg [7:0]data_byte_reg;	
	
	uart_byte_rx uart_byte_rx(
		.clk(clk),
		.reset_n(reset_n),

		.baud_set(3'd0),
		.uart_rx(uart_rx),
		
		.data_byte(data_byte_rx),
		.rx_done(rx_done)
	);

	vio_0 vio_0 (
		.clk(clk),  // input wire clk
		.probe_in0(data_byte_reg)   // input wire [7 : 0] probe_in0
	);

	always@(posedge clk or posedge reset)
	if(reset)
		data_byte_reg <= 8'd0;
	else if(rx_done)
		data_byte_reg <= data_byte_rx;
	else
		data_byte_reg <= data_byte_reg;

endmodule
