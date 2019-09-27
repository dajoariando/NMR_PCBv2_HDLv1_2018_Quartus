`timescale 1ps / 1ps

module ADC_LTC1746_DRV_tb;
	
	// parameters are referenced in MHz for calculation
	parameter timescale_ref = 1000000; // reference scale based on timescale => 1ps => 1THz => 1000000 MHz
	parameter CLK_RATE_HZ = 4.3; // in MHz
	localparam integer clockticks = (timescale_ref / CLK_RATE_HZ) / 2.0;
	
	parameter ADC_WIDTH = 14;
	parameter ADC_LATENCY = 5;
	
	// digital data
	reg [ADC_WIDTH-1:0] Q_IN;			// digital data in
	reg Q_IN_OV;						// digital data in overflow
	wire [ADC_WIDTH-1:0] Q_OUT;	// digital data out
	wire Q_OUT_OV;				// digital data out overflow
	
	// control signal
	reg acq_en;			// acquisition starts (synced signal)
	wire data_ready;	// data ready signal for capture
	wire out_en;		// output enable for the ADC
	
	// system signal
	reg SYS_CLK;		// system control clock
	reg CLKOUT;			// clockout generated by the ADC chip
	reg RESET;			// reset
	
	ADC_LTC1746_DRV 
	# (
		.ADC_WIDTH (ADC_WIDTH),		// ADC width given by the datasheet
		.ADC_LATENCY (ADC_LATENCY)	// ADC latency given by the datasheet
	)
	ADC_LTC1746_DRV1
	(
		// digital data
		.Q_IN		(Q_IN),		// digital data in
		.Q_IN_OV		(Q_IN_OV),	// digital data in overflow
		.Q_OUT		(Q_OUT),	// digital data out
		.Q_OUT_OV	(Q_OUT_OV),	// digital data out overflow
		
		// control signal
		.acq_en		(acq_en),		// acquisition starts (synced signal)
		.data_ready	(data_ready),	// data ready signal for capture
		.out_en		(out_en),		// output enable for the ADC
		
		// system signal
		.SYS_CLK		(SYS_CLK),	// system control clock
		.CLKOUT		(CLKOUT),	// clockout generated by the ADC chip
		.RESET		(RESET)	// reset
	);
	
	
	initial begin
		Q_IN = {ADC_WIDTH{1'b0}};
		Q_IN_OV = 1'b0;
		acq_en = 1'b0;
		SYS_CLK = 1'b0;
		
		#(clockticks*1);

		#(clockticks*2) RESET = 1'b1;
		#(clockticks*2) RESET = 1'b0;
		#(clockticks*10)	acq_en = 1'b1;
		#(clockticks*100)	acq_en = 1'b0;
	end
	
	initial begin
		#(clockticks*31);
		forever begin
			#(clockticks*4) Q_IN = Q_IN + 1;
		end
	end
	
	always begin
		#clockticks SYS_CLK = ~SYS_CLK;
	end

endmodule