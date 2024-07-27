
//////////////////////////////////////////////////////////////////////////////////
// Company: �人о·��Ƽ����޹�˾
// Engineer: www.corecourse.cn
// 
// Create Date: 2021/09/20 00:00:00
// Design Name: uart_tx
// Module Name: uart_byte_tx
// Project Name: uart_tx
// Target Devices: xc7z015clg485-1
// Tool Versions: Vivado 2018.3
// Description: ���ڷ���
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_byte_tx(
	clk,
	reset_n,
  
	data_byte,
	send_en,   
	baud_set,  
	
	uart_tx,  
	tx_done,   
	uart_state 
);

	input clk ;    //ģ��ȫ��ʱ�����룬50M
	input reset_n;    //��λ�ź����룬����Ч
	input [7:0]data_byte;  //������8bit����
	input send_en;    //����ʹ��
	input [2:0]baud_set;   //����������
	
	output reg uart_tx;    //��������ź�
	output reg tx_done;    //1byte���ݷ�����ɱ�־
	output reg uart_state; //��������״̬
	
	wire reset=~reset_n;
	localparam START_BIT = 1'b0;
	localparam STOP_BIT = 1'b1; 
	
	reg bps_clk;	     //������ʱ��	
	reg [15:0]div_cnt;      //��Ƶ������	
	reg [15:0]bps_DR;       //��Ƶ�������ֵ	
	reg [3:0]bps_cnt;      //������ʱ�Ӽ�����	
	reg [7:0]data_byte_reg;//data_byte�Ĵ������
	
	always@(posedge clk or posedge reset)
	if(reset)
		uart_state <= 1'b0;
	else if(send_en)
		uart_state <= 1'b1;
	else if(bps_cnt == 4'd11)
		uart_state <= 1'b0;
	else
		uart_state <= uart_state;
	
	always@(posedge clk or posedge reset)
	if(reset)
		data_byte_reg <= 8'd0;
	else if(send_en)
		data_byte_reg <= data_byte;
	else
		data_byte_reg <= data_byte_reg;
	
	always@(posedge clk or posedge reset)
	if(reset)
		bps_DR <= 16'd5207;
	else begin
		case(baud_set)
			0:bps_DR <= 16'd5207;//9600
			1:bps_DR <= 16'd2603;//19200
			2:bps_DR <= 16'd1301;//38400
			3:bps_DR <= 16'd867;//57600
			4:bps_DR <= 16'd433;//115200
			default:bps_DR <= 16'd5207;			
		endcase
	end	
	
	//counter
	always@(posedge clk or posedge reset)
	if(reset)
		div_cnt <= 16'd0;
	else if(uart_state)begin
		if(div_cnt == bps_DR)
			div_cnt <= 16'd0;
		else
			div_cnt <= div_cnt + 1'b1;
	end
	else
		div_cnt <= 16'd0;
	
	// bps_clk gen
	always@(posedge clk or posedge reset)
	if(reset)
		bps_clk <= 1'b0;
	else if(div_cnt == 16'd1)
		bps_clk <= 1'b1;
	else
		bps_clk <= 1'b0;
	
	//bps counter
	always@(posedge clk or posedge reset)
	if(reset)	
		bps_cnt <= 4'd0;
	else if(bps_cnt == 4'd11)
		bps_cnt <= 4'd0;
	else if(bps_clk)
		bps_cnt <= bps_cnt + 1'b1;
	else
		bps_cnt <= bps_cnt;
		
	always@(posedge clk or posedge reset)
	if(reset)
		tx_done <= 1'b0;
	else if(bps_cnt == 4'd11)
		tx_done <= 1'b1;
	else
		tx_done <= 1'b0;
		
	always@(posedge clk or posedge reset)
	if(reset)
		uart_tx <= 1'b1;
	else begin
		case(bps_cnt)
			0:uart_tx <= 1'b1;
			1:uart_tx <= START_BIT;
			2:uart_tx <= data_byte_reg[0];
			3:uart_tx <= data_byte_reg[1];
			4:uart_tx <= data_byte_reg[2];
			5:uart_tx <= data_byte_reg[3];
			6:uart_tx <= data_byte_reg[4];
			7:uart_tx <= data_byte_reg[5];
			8:uart_tx <= data_byte_reg[6];
			9:uart_tx <= data_byte_reg[7];
			10:uart_tx <= STOP_BIT;
			default:uart_tx <= 1'b1;
		endcase
	end	

endmodule
