
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2015 03:17:37
// Design Name: 
// Module Name: diigi_clk
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////








module digi(clk,rst,set1,tg,inc,dec,CA,CB,CC,CD,CE,CF,CG,AN,DP,ld,PWM,SD);

  


output PWM,SD;

//declartion 
input clk,rst,inc,dec,set1,tg;
output CA,CB,CC,CD,CE,CF,CG;                //a,b,c,d,e,f,g,
output [7:0]AN;                       //led0 is enable
output DP,ld;

wire CA,CB,CC,CD,CE,CF,CG;
reg [7:0]temp_AN;
reg temp_DP,temp_DP_data,light1;

//reg counter declaration
reg [25:0]count_clk;
reg clk_snd=0;
reg [5:0] count_sec,count_min,count_min_alm;    //60 value count
reg [4:0] count_hr,count_hr_alm;               //24 value count
reg [1:0]temp_tg=2'b0;
reg [6:0]bcd0,bcd1,bcd2,bcd3,bcd4,bcd5,bcd6,bcd7,temp_data;

//display
reg [19:0]d_count;


//clk conversion.............................................................clk
always @(posedge clk)
begin
   if(count_clk==49999999) begin           //--count 0-49999
       clk_snd<=~clk_snd;
       count_clk<=0;
   end
   else begin
      count_clk<=count_clk+1;
   end
end

//clk tick...........................................................................
always @(posedge clk_snd )
begin 
    if(rst)
    begin
    count_sec<=6'd0;
    count_min<=6'd0;
    count_hr<=5'd0;
    count_min_alm<=6'd0;
    count_hr_alm<=5'd0;
    
    temp_tg<=1'b0;
    end

    else if(set1) 
    begin
    
   // task                                          //task blink
    // toggle , increment, decrement
          if(tg)
          begin
          temp_tg<=temp_tg+2'd1;
          end
          
          case (temp_tg)
          2'd1:begin 
                                    
               if(inc)//hr set1
               begin
               count_hr<=count_hr+1;
               end
               else if (dec)
               begin
               count_hr<=count_hr-1;
               end
               else 
               begin
               count_hr<=count_hr;
               end
               end
          2'd0:begin 
               
               if (inc)//min set1
               begin
               count_min<=count_min+1;
               end
               else if (dec)
               begin
               count_min<=count_min-1;
               end
               else 
               begin
               count_min<=count_min;
               end
               end
          2'd2:begin 
                              
              if (inc)//min set1
              begin
              count_min_alm<=count_min_alm+1;
              end
              else if (dec)
              begin
              count_min_alm<=count_min_alm-1;
              end
              else 
              begin
              count_min_alm<=count_min_alm;
              end
              end
        
          
          2'd3:begin 
                                        
              if (inc)//min set1
              begin
              count_hr_alm<=count_hr_alm+1;
              end
              else if (dec)
              begin
              count_hr_alm<=count_hr_alm-1;
              end
              else 
              begin
              count_hr_alm<=count_hr_alm;
              end
              end
          endcase
    end
    //normal clock tick 
 if(set1==0)
 begin
      count_sec<=count_sec+6'd1;
       if(count_sec==6'd59)
       begin
             count_sec<=6'd0;
             count_min<=count_min+6'd1;
             if (count_min==6'd59)
             begin
                       count_min<=6'd0;
                       count_hr<=count_hr+5'd1;
                       if(count_hr==5'd23)
                       begin
                                 count_hr<=5'd0;
                      end
            end
        end
  end

end         
    
    
   reg swt1; 
//Alarm
always @(posedge clk)
 begin
 if(count_min==count_min_alm && count_hr==count_hr_alm && (!count_hr))
 begin
   light1<=1'b1;
   swt1<=1'b1;
 end
 else
 begin 
   light1<=1'b0;
   swt1<=1'b0;
 end
end


//sec..............................................................................................sec blink DP
reg [6:0]temp_d_blink;
always @(clk_snd)
begin
   if (clk_snd)
   begin
      temp_DP=1'b1;
      temp_d_blink=7'b1110111;
   end
   else
   begin
      temp_DP=1'b0;
      temp_d_blink=7'b1111111;
   end
end
   


//min..........................................................................................................................
always @(*)
begin
     
     case (count_min)
     //a,b,c,d,e,f,g......pull down
     //0      7'b0000001;
    // 1      7'b1001111;
   //  2      7'b0010010;
   //  3      7'b0000110;
   //  4       7'b1001100;
   //  5       7'b0100100;
   //  6       7'b0100000;
   //  7       7'b0001111;
   //  8       7'b0000000;
   //  9       7'b0000100; 
     
     6'd0 : begin  bcd1<=7'b0000001; bcd0 <= 7'b0000001; end
     6'd1 : begin  bcd1<=7'b0000001; bcd0 <= 7'b1001111; end
     6'd2 : begin  bcd1<=7'b0000001; bcd0 <= 7'b0010010; end
     6'd3 : begin  bcd1<=7'b0000001; bcd0 <= 7'b0000110; end
     6'd4 : begin  bcd1<=7'b0000001; bcd0 <= 7'b1001100; end
     6'd5 : begin  bcd1<=7'b0000001; bcd0 <= 7'b0100100; end
     6'd6 : begin  bcd1<=7'b0000001; bcd0 <= 7'b0100000; end
     6'd7 : begin  bcd1<=7'b0000001; bcd0 <= 7'b0001111; end
     6'd8 : begin  bcd1<=7'b0000001; bcd0 <= 7'b0000000; end
     6'd9 : begin  bcd1<=7'b0000001; bcd0 <= 7'b0000100; end
    
     6'd10 : begin  bcd1<=7'b1001111; bcd0 <= 7'b0000001; end
     6'd11 : begin  bcd1<=7'b1001111; bcd0 <= 7'b1001111; end
     6'd12 : begin  bcd1<=7'b1001111; bcd0 <= 7'b0010010; end
     6'd13 : begin  bcd1<=7'b1001111; bcd0 <= 7'b0000110; end
     6'd14 : begin  bcd1<=7'b1001111; bcd0 <= 7'b1001100; end
     6'd15 : begin  bcd1<=7'b1001111; bcd0 <= 7'b0100100; end
     6'd16 : begin  bcd1<=7'b1001111; bcd0 <= 7'b0100000; end
     6'd17 : begin  bcd1<=7'b1001111; bcd0 <= 7'b0001111; end
     6'd18 : begin  bcd1<=7'b1001111; bcd0 <= 7'b0000000; end
     6'd19 : begin  bcd1<=7'b1001111; bcd0 <= 7'b0000100; end
     
     6'd20 : begin  bcd1<=7'b0010010; bcd0 <= 7'b0000001; end
     6'd21 : begin  bcd1<=7'b0010010; bcd0 <= 7'b1001111; end
     6'd22 : begin  bcd1<=7'b0010010; bcd0 <= 7'b0010010; end
     6'd23 : begin  bcd1<=7'b0010010; bcd0 <= 7'b0000110; end
     6'd24 : begin  bcd1<=7'b0010010; bcd0 <= 7'b1001100; end
     6'd25 : begin  bcd1<=7'b0010010; bcd0 <= 7'b0100100; end
     6'd26 : begin  bcd1<=7'b0010010; bcd0 <= 7'b0100000; end
     6'd27 : begin  bcd1<=7'b0010010; bcd0 <= 7'b0001111; end
     6'd28 : begin  bcd1<=7'b0010010; bcd0 <= 7'b0000000; end
     6'd29 : begin  bcd1<=7'b0010010; bcd0 <= 7'b0000100; end
     
     6'd30 : begin  bcd1<=7'b0000110; bcd0 <= 7'b0000001; end
     6'd31 : begin  bcd1<=7'b0000110; bcd0 <= 7'b1001111; end
     6'd32 : begin  bcd1<=7'b0000110; bcd0 <= 7'b0010010; end
     6'd33 : begin  bcd1<=7'b0000110; bcd0 <= 7'b0000110; end
     6'd34 : begin  bcd1<=7'b0000110; bcd0 <= 7'b1001100; end
     6'd35 : begin  bcd1<=7'b0000110; bcd0 <= 7'b0100100; end
     6'd36 : begin  bcd1<=7'b0000110; bcd0 <= 7'b0100000; end
     6'd37 : begin  bcd1<=7'b0000110; bcd0 <= 7'b0001111; end
     6'd38 : begin  bcd1<=7'b0000110; bcd0 <= 7'b0000000; end
     6'd39 : begin  bcd1<=7'b0000110; bcd0 <= 7'b0000100; end
     
     6'd40 : begin  bcd1<=7'b1001100; bcd0 <= 7'b0000001; end
     6'd41 : begin  bcd1<=7'b1001100; bcd0 <= 7'b1001111; end
     6'd42 : begin  bcd1<=7'b1001100; bcd0 <= 7'b0010010; end
     6'd43 : begin  bcd1<=7'b1001100; bcd0 <= 7'b0000110; end
     6'd44 : begin  bcd1<=7'b1001100; bcd0 <= 7'b1001100; end
     6'd45 : begin  bcd1<=7'b1001100; bcd0 <= 7'b0100100; end
     6'd46 : begin  bcd1<=7'b1001100; bcd0 <= 7'b0100000; end
     6'd47 : begin  bcd1<=7'b1001100; bcd0 <= 7'b0001111; end
     6'd48 : begin  bcd1<=7'b1001100; bcd0 <= 7'b0000000; end
     6'd49 : begin  bcd1<=7'b1001100; bcd0 <= 7'b0000100; end
     
     6'd50 : begin  bcd1<=7'b0100100; bcd0 <= 7'b0000001; end
     6'd51 : begin  bcd1<=7'b0100100; bcd0 <= 7'b1001111; end
     6'd52 : begin  bcd1<=7'b0100100; bcd0 <= 7'b0010010; end
     6'd53 : begin  bcd1<=7'b0100100; bcd0 <= 7'b0000110; end
     6'd54 : begin  bcd1<=7'b0100100; bcd0 <= 7'b1001100; end
     6'd55 : begin  bcd1<=7'b0100100; bcd0 <= 7'b0100100; end
     6'd56 : begin  bcd1<=7'b0100100; bcd0 <= 7'b0100000; end
     6'd57 : begin  bcd1<=7'b0100100; bcd0 <= 7'b0001111; end
     6'd58 : begin  bcd1<=7'b0100100; bcd0 <= 7'b0000000; end
     6'd59 : begin  bcd1<=7'b0100100; bcd0 <= 7'b0000100; end
     
    
     default : begin bcd1<=7'b0000001; bcd0<= 7'b0000001; end
    
    endcase
end


//hr.......................................................................................................................
always @(*)
begin
     
     case (count_hr)
     //a,b,c,d,e,f,g......pull down
     //0      7'b0000001;
    // 1      7'b1001111;
   //  2      7'b0010010;
   //  3      7'b0000110;
   //  4       7'b1001100;
   //  5       7'b0100100;
   //  6       7'b0100000;
   //  7       7'b0001111;
   //  8       7'b0000000;
   //  9       7'b0000100; 
     
     6'd0 : begin  bcd3<=7'b0000001; bcd2 <= 7'b0000001; end
     6'd1 : begin  bcd3<=7'b0000001; bcd2 <= 7'b1001111; end
     6'd2 : begin  bcd3<=7'b0000001; bcd2 <= 7'b0010010; end
     6'd3 : begin  bcd3<=7'b0000001; bcd2 <= 7'b0000110; end
     6'd4 : begin  bcd3<=7'b0000001; bcd2 <= 7'b1001100; end
     6'd5 : begin  bcd3<=7'b0000001; bcd2 <= 7'b0100100; end
     6'd6 : begin  bcd3<=7'b0000001; bcd2 <= 7'b0100000; end
     6'd7 : begin  bcd3<=7'b0000001; bcd2 <= 7'b0001111; end
     6'd8 : begin  bcd3<=7'b0000001; bcd2 <= 7'b0000000; end
     6'd9 : begin  bcd3<=7'b0000001; bcd2 <= 7'b0000100; end
     
     6'd10 : begin  bcd3<=7'b1001111; bcd2 <= 7'b0000001; end
     6'd11 : begin  bcd3<=7'b1001111; bcd2 <= 7'b1001111; end
     6'd12 : begin  bcd3<=7'b1001111; bcd2 <= 7'b0010010; end
     6'd13 : begin  bcd3<=7'b1001111; bcd2 <= 7'b0000110; end
     6'd14 : begin  bcd3<=7'b1001111; bcd2 <= 7'b1001100; end
     6'd15 : begin  bcd3<=7'b1001111; bcd2 <= 7'b0100100; end
     6'd16 : begin  bcd3<=7'b1001111; bcd2 <= 7'b0100000; end
     6'd17 : begin  bcd3<=7'b1001111; bcd2 <= 7'b0001111; end
     6'd18 : begin  bcd3<=7'b1001111; bcd2 <= 7'b0000000; end
     6'd19 : begin  bcd3<=7'b1001111; bcd2 <= 7'b0000100; end
     
     6'd20 : begin  bcd3<=7'b0010010; bcd2 <= 7'b0000001; end
     6'd21 : begin  bcd3<=7'b0010010; bcd2 <= 7'b1001111; end
     6'd22 : begin  bcd3<=7'b0010010; bcd2 <= 7'b0010010; end
     6'd23 : begin  bcd3<=7'b0010010; bcd2 <= 7'b0000110; end
     
    
     default : begin bcd3<=7'b0000001; bcd2<= 7'b0000001; end
    
    endcase
end
//--------------------------------------Alarm min
always @(*)
begin
     
     case (count_min_alm)
     //a,b,c,d,e,f,g......pull down
     //0      7'b0000001;
    // 1      7'b1001111;
   //  2      7'b0010010;
   //  3      7'b0000110;
   //  4       7'b1001100;
   //  5       7'b0100100;
   //  6       7'b0100000;
   //  7       7'b0001111;
   //  8       7'b0000000;
   //  9       7'b0000100; 
     
     6'd0 : begin  bcd5<=7'b0000001; bcd4 <= 7'b0000001; end
     6'd1 : begin  bcd5<=7'b0000001; bcd4 <= 7'b1001111; end
     6'd2 : begin  bcd5<=7'b0000001; bcd4 <= 7'b0010010; end
     6'd3 : begin  bcd5<=7'b0000001; bcd4 <= 7'b0000110; end
     6'd4 : begin  bcd5<=7'b0000001; bcd4 <= 7'b1001100; end
     6'd5 : begin  bcd5<=7'b0000001; bcd4 <= 7'b0100100; end
     6'd6 : begin  bcd5<=7'b0000001; bcd4 <= 7'b0100000; end
     6'd7 : begin  bcd5<=7'b0000001; bcd4 <= 7'b0001111; end
     6'd8 : begin  bcd5<=7'b0000001; bcd4 <= 7'b0000000; end
     6'd9 : begin  bcd5<=7'b0000001; bcd4 <= 7'b0000100; end
    
     6'd10 : begin  bcd5<=7'b1001111; bcd4 <= 7'b0000001; end
     6'd11 : begin  bcd5<=7'b1001111; bcd4 <= 7'b1001111; end
     6'd12 : begin  bcd5<=7'b1001111; bcd4 <= 7'b0010010; end
     6'd13 : begin  bcd5<=7'b1001111; bcd4 <= 7'b0000110; end
     6'd14 : begin  bcd5<=7'b1001111; bcd4 <= 7'b1001100; end
     6'd15 : begin  bcd5<=7'b1001111; bcd4 <= 7'b0100100; end
     6'd16 : begin  bcd5<=7'b1001111; bcd4 <= 7'b0100000; end
     6'd17 : begin  bcd5<=7'b1001111; bcd4 <= 7'b0001111; end
     6'd18 : begin  bcd5<=7'b1001111; bcd4 <= 7'b0000000; end
     6'd19 : begin  bcd5<=7'b1001111; bcd4 <= 7'b0000100; end
     
     6'd20 : begin  bcd5<=7'b0010010; bcd4 <= 7'b0000001; end
     6'd21 : begin  bcd5<=7'b0010010; bcd4 <= 7'b1001111; end
     6'd22 : begin  bcd5<=7'b0010010; bcd4 <= 7'b0010010; end
     6'd23 : begin  bcd5<=7'b0010010; bcd4 <= 7'b0000110; end
     6'd24 : begin  bcd5<=7'b0010010; bcd4 <= 7'b1001100; end
     6'd25 : begin  bcd5<=7'b0010010; bcd4 <= 7'b0100100; end
     6'd26 : begin  bcd5<=7'b0010010; bcd4 <= 7'b0100000; end
     6'd27 : begin  bcd5<=7'b0010010; bcd4 <= 7'b0001111; end
     6'd28 : begin  bcd5<=7'b0010010; bcd4 <= 7'b0000000; end
     6'd29 : begin  bcd5<=7'b0010010; bcd4 <= 7'b0000100; end
     
     6'd30 : begin  bcd5<=7'b0000110; bcd4 <= 7'b0000001; end
     6'd31 : begin  bcd5<=7'b0000110; bcd4 <= 7'b1001111; end
     6'd32 : begin  bcd5<=7'b0000110; bcd4 <= 7'b0010010; end
     6'd33 : begin  bcd5<=7'b0000110; bcd4 <= 7'b0000110; end
     6'd34 : begin  bcd5<=7'b0000110; bcd4 <= 7'b1001100; end
     6'd35 : begin  bcd5<=7'b0000110; bcd4 <= 7'b0100100; end
     6'd36 : begin  bcd5<=7'b0000110; bcd4 <= 7'b0100000; end
     6'd37 : begin  bcd5<=7'b0000110; bcd4 <= 7'b0001111; end
     6'd38 : begin  bcd5<=7'b0000110; bcd4 <= 7'b0000000; end
     6'd39 : begin  bcd5<=7'b0000110; bcd4 <= 7'b0000100; end
     
     6'd40 : begin  bcd5<=7'b1001100; bcd4 <= 7'b0000001; end
     6'd41 : begin  bcd5<=7'b1001100; bcd4 <= 7'b1001111; end
     6'd42 : begin  bcd5<=7'b1001100; bcd4 <= 7'b0010010; end
     6'd43 : begin  bcd5<=7'b1001100; bcd4 <= 7'b0000110; end
     6'd44 : begin  bcd5<=7'b1001100; bcd4 <= 7'b1001100; end
     6'd45 : begin  bcd5<=7'b1001100; bcd4 <= 7'b0100100; end
     6'd46 : begin  bcd5<=7'b1001100; bcd4 <= 7'b0100000; end
     6'd47 : begin  bcd5<=7'b1001100; bcd4 <= 7'b0001111; end
     6'd48 : begin  bcd5<=7'b1001100; bcd4 <= 7'b0000000; end
     6'd49 : begin  bcd5<=7'b1001100; bcd4 <= 7'b0000100; end
     
     6'd50 : begin  bcd5<=7'b0100100; bcd4 <= 7'b0000001; end
     6'd51 : begin  bcd5<=7'b0100100; bcd4 <= 7'b1001111; end
     6'd52 : begin  bcd5<=7'b0100100; bcd4 <= 7'b0010010; end
     6'd53 : begin  bcd5<=7'b0100100; bcd4 <= 7'b0000110; end
     6'd54 : begin  bcd5<=7'b0100100; bcd4 <= 7'b1001100; end
     6'd55 : begin  bcd5<=7'b0100100; bcd4 <= 7'b0100100; end
     6'd56 : begin  bcd5<=7'b0100100; bcd4 <= 7'b0100000; end
     6'd57 : begin  bcd5<=7'b0100100; bcd4 <= 7'b0001111; end
     6'd58 : begin  bcd5<=7'b0100100; bcd4 <= 7'b0000000; end
     6'd59 : begin  bcd5<=7'b0100100; bcd4 <= 7'b0000100; end
     
    
     default : begin bcd5<=7'b0000001; bcd4<= 7'b0000001; end
    
    endcase
end


//hr.......................................................................................................................
always @(*)
begin
     
     case (count_hr_alm)
     //a,b,c,d,e,f,g......pull down
     //0      7'b0000001;
    // 1      7'b1001111;
   //  2      7'b0010010;
   //  3      7'b0000110;
   //  4       7'b1001100;
   //  5       7'b0100100;
   //  6       7'b0100000;
   //  7       7'b0001111;
   //  8       7'b0000000;
   //  9       7'b0000100; 
     
     6'd0 : begin  bcd7<=7'b0000001; bcd6 <= 7'b0000001; end
     6'd1 : begin  bcd7<=7'b0000001; bcd6 <= 7'b1001111; end
     6'd2 : begin  bcd7<=7'b0000001; bcd6 <= 7'b0010010; end
     6'd3 : begin  bcd7<=7'b0000001; bcd6 <= 7'b0000110; end
     6'd4 : begin  bcd7<=7'b0000001; bcd6 <= 7'b1001100; end
     6'd5 : begin  bcd7<=7'b0000001; bcd6 <= 7'b0100100; end
     6'd6 : begin  bcd7<=7'b0000001; bcd6 <= 7'b0100000; end
     6'd7 : begin  bcd7<=7'b0000001; bcd6 <= 7'b0001111; end
     6'd8 : begin  bcd7<=7'b0000001; bcd6 <= 7'b0000000; end
     6'd9 : begin  bcd7<=7'b0000001; bcd6 <= 7'b0000100; end
     
     6'd10 : begin  bcd7<=7'b1001111; bcd6 <= 7'b0000001; end
     6'd11 : begin  bcd7<=7'b1001111; bcd6 <= 7'b1001111; end
     6'd12 : begin  bcd7<=7'b1001111; bcd6 <= 7'b0010010; end
     6'd13 : begin  bcd7<=7'b1001111; bcd6 <= 7'b0000110; end
     6'd14 : begin  bcd7<=7'b1001111; bcd6 <= 7'b1001100; end
     6'd15 : begin  bcd7<=7'b1001111; bcd6 <= 7'b0100100; end
     6'd16 : begin  bcd7<=7'b1001111; bcd6 <= 7'b0100000; end
     6'd17 : begin  bcd7<=7'b1001111; bcd6 <= 7'b0001111; end
     6'd18 : begin  bcd7<=7'b1001111; bcd6 <= 7'b0000000; end
     6'd19 : begin  bcd7<=7'b1001111; bcd6 <= 7'b0000100; end
     
     6'd20 : begin  bcd7<=7'b0010010; bcd6 <= 7'b0000001; end
     6'd21 : begin  bcd7<=7'b0010010; bcd6 <= 7'b1001111; end
     6'd22 : begin  bcd7<=7'b0010010; bcd6 <= 7'b0010010; end
     6'd23 : begin  bcd7<=7'b0010010; bcd6 <= 7'b0000110; end
     
    
     default : begin bcd7<=7'b0000001; bcd6<= 7'b0000001; end
    
    endcase
end
//display1....................................................................................

                                                 //display mux
always @(posedge clk)
begin
  if (set1==1'b0)                                                                        //1.
  begin
        if(d_count==0)begin
            temp_data=bcd0;
            temp_AN=8'b11111110;
            temp_DP_data=1'b1;
       end
       if(d_count==2000)
       begin
            temp_data=bcd1;
            temp_AN=8'b11111101;
            temp_DP_data=1'b1;
       end
    
      if(d_count==4000)begin
            temp_data=bcd2;
            temp_AN=8'b11111011;
            temp_DP_data=temp_DP;
      end
      if(d_count==6000)begin
           temp_data=bcd3;
           temp_AN=8'b11110111;
           temp_DP_data=1'b1;
        end
      if(d_count==8000)begin
               temp_data=bcd4;              //alarm '0'
               temp_AN=8'b11101111;
               temp_DP_data=1'b1;
        end
      if(d_count==10000)begin
               temp_data=bcd5;              //alarm '0'
               temp_AN=8'b11011111;
               temp_DP_data=1'b1;
            end
      if(d_count==12000)begin
               temp_data=bcd6;              //alarm '0'
               temp_AN=8'b10111111;
               temp_DP_data=temp_DP;
            end
       if(d_count==14000)begin
               temp_data=bcd6;              //alarm '0'
               temp_AN=8'b01111111;
               temp_DP_data=1'b1;
            end
       else begin
              temp_data=temp_data;
              temp_AN=temp_AN;
           end
  end
  
  else                                                                        //2.
      begin
      
       if(d_count==0)begin
             temp_data=bcd0;
             temp_AN=8'b11111110;
             temp_DP_data=1'b1;
            end
         if(d_count==2000)
           begin
            temp_data=bcd1;
            temp_AN=8'b11111101;
            temp_DP_data=1'b1;
          end
          
         if(d_count==4000)begin
             temp_data=bcd2;
             temp_AN=8'b11111011;
             temp_DP_data=temp_DP;
          end
          if(d_count==6000)begin
                 temp_data=bcd3;
                 temp_AN=8'b11110111;
                 temp_DP_data=1'b1;
              end
          if(d_count==8000)begin
                     temp_data=bcd4;              //alarm 'g'
                     temp_AN=8'b11101111;
                     temp_DP_data=1'b1;
                  end
         if(d_count==10000)begin
                     temp_data=bcd5;              //alarm 'g'
                     temp_AN=8'b11011111;
                     temp_DP_data=1'b1;
                  end
         if(d_count==12000)begin
                     temp_data=bcd6;              //alarm 'g'
                     temp_AN=8'b10111111;
                     temp_DP_data=temp_DP;
                  end
         if(d_count==14000)begin
                     temp_data=bcd7;              //alarm 'g'
                     temp_AN=8'b01111111;
                     temp_DP_data=1'b1;
                  end
                  
         if(d_count==16000)
         begin
              case(temp_tg)
              
              2'd0:begin          temp_data=temp_d_blink;              //blink 'd'
                                  temp_AN=8'b11111110;
                                  temp_DP_data=1'b1;
                                  end
              2'd1:begin          temp_data=temp_d_blink;              //blink 'd'
                                  temp_AN=8'b11111011;
                                  temp_DP_data=temp_DP;
                                  end
              2'd2:begin          temp_data=temp_d_blink;              //blink 'd'
                                  temp_AN=8'b11101111;
                                  temp_DP_data=1'b1;
                                  end
              2'd3:begin          temp_data=temp_d_blink;              //blink 'd'
                                  temp_AN=8'b10111111;
                                  temp_DP_data=temp_DP;
                                  end
              endcase
          end
         else 
         begin
                temp_data=temp_data;
                temp_AN=temp_AN;
       
          end
  end        
end        


                          // display counter 
always @(posedge clk)
begin

   if(d_count==18000)
     begin

      d_count<=20'd0;
      
      end
   else 
   begin
   d_count<=d_count+20'd1;
   end
end


assign {CA,CB,CC,CD,CE,CF,CG}= temp_data;
assign AN=temp_AN;
assign DP=temp_DP_data;
assign ld=light1;

//sound ..................................................................................................................

 

reg [19:0]temp_count;
reg temp_PWM,temp_sd;
reg speaker;

always @(posedge clk)
  begin
  if(swt1)
  begin
       temp_PWM<=speaker;
       temp_sd<=1'b1;
  end
  else 
  begin
       temp_PWM<=1'b0;
       temp_sd<=1'b0;
  end
  end
  
  assign PWM=temp_PWM;
  assign SD=temp_sd;
  
 

parameter clkdivider = 25000000/440/2;
 
 reg [23:0] tone;
 always @(posedge clk) tone <= tone+1;
 
 reg [14:0] counter;
 always @(posedge clk) if(counter==0) counter <= (tone[23] ? clkdivider-1 : clkdivider/2-1); else counter <= counter-1;
 
 //reg speaker;
 always @(posedge clk) if(counter==0) speaker <= ~speaker;
 
 
endmodule