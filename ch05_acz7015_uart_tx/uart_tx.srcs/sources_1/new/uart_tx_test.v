
//////////////////////////////////////////////////////////////////////////////////
// Company: �人о·��Ƽ����޹�˾
// Engineer: www.corecourse.cn
// 
// Create Date: 2021/09/20 00:00:00
// Design Name: uart_tx
// Module Name: uart_tx_test
// Project Name: uart_tx
// Target Devices: xc7z020clg400-2
// Tool Versions: Vivado 2018.3
// Description: ���ڷ����ϰ���Զ���
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module uart_tx_test(
	clk,
	reset_n,

	uart_tx,
	led
);
    wire reset;
	assign reset=~reset_n;

	input clk; //ϵͳʱ�����룬50M
	input reset_n; //��λ�ź����룬����Ч

	output uart_tx; //��������ź�
	output led;     //ledָʾ���ݷ���״̬
	
	wire send_en;    //����ʹ��
	wire [7:0]data_byte;  //������8bit����
	wire test_en;    //������־�ź�
	reg test_en_dly1;
	reg test_en_dly2;

	always@(posedge clk)
	begin
		test_en_dly1 <= test_en;
		test_en_dly2 <= test_en_dly1;
	end

  //VIO��������źſ��Ʒ���ʹ��
	assign send_en = test_en_dly1 & !test_en_dly2;

  //ʹ��vio���ô��ڷ�������
	vio_0 vio_0 (
		.clk(clk),  // input wire clk
		.probe_out0(test_en),  // output wire [0 : 0] probe_out0
		.probe_out1(data_byte)   // output wire [7 : 0] probe_out1
	);

	uart_byte_tx uart_byte_tx(
		.clk(clk),
		.reset_n(reset_n),

		.data_byte(data_byte),
		.send_en(send_en),
		.baud_set(3'd0),
		
		.uart_tx(uart_tx),
		.tx_done( ),
		.uart_state(led)
	);	

endmodule
