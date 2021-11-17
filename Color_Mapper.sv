//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size, 
							  input			[9:0] MarioX, MarioY, Mario_size,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on;
	 logic Mario_on;
	 
	 logic [9:0] Mario_addr;
	 logic [23:0] Mario_rgb;
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 
	 int Mario_DistX,Mario_DistY;
	 assign Mario_DistX=DrawX-MarioX+Mario_size;	//figure out whether or not we are within Mario's bounds
	 assign Mario_DistY=DrawY-MarioY+Mario_size;
	  
    always_comb
    begin:Ball_on_proc
        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
				
			if (Mario_DistX <= (Mario_size*2) && Mario_DistY <= (Mario_size*2) && Mario_DistX >= 10'd0 && Mario_DistY >= 10'd0) begin
				Mario_on = 1'b1;
				Mario_addr = Mario_DistX+(Mario_DistY*32);
			end
			else begin
				Mario_on = 1'b0;
				Mario_addr=10'b0;
			end
     end 
      
	 mario_jump mario_rgb(.read_address(Mario_addr), .RGB_val(Mario_rgb));
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'h55;
            Blue = 8'h00;
        end       
		  else if (Mario_on==1'b1 && Mario_rgb!=24'h0) begin
				Red = Mario_rgb[23:16];
				Green = Mario_rgb[15:8];
				Blue = Mario_rgb[7:0];
		  end
        else 
        begin 
            Red = 8'ha2; 
            Green = 8'had;
            Blue = 8'hfe;
        end      
    end 
    
endmodule
