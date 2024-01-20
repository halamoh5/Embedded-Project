// LCD module connections
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB6_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB6_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;
// End LCD module connections

unsigned int temp;
char Temperature[] = " 00.0 C";
char t_temp[6];
int distt = 0;
char text1[7];
int i;
int j;
char t_moist[7];
unsigned int moist;
//int flag = 0


void myyDelay (unsigned int t);          //Delay function

void interrupt(){
      //flag = 1;
      if(INTCON | 0x02){    //
           PORTC = PORTC | 0x04; //0000 0100
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           delay_100ms();
           PORTC = PORTC & 0x00;
           INTCON = INTCON & 0xFD; //clear the flag
      }

}

void ADC_init(void){
     ADCON1 = 0xC0; // right justified, all channels are analog    //0001 1100
     TRISA = 0x0F; // Port A is input
     ADCON0 = 0x41; //prescale 16, channel3, dont start conversion, power on ATD

}


unsigned int ADC_read1(){
         unsigned int read = 0;
         ADCON0 = 0x41;      // 0100 1001      RA0                 0010 0001
         ADCON0 = ADCON0 | 0x04; // GO
         while(ADCON0 & 0x04);      // until finish reading
        // msDelay(5000);
         read     =   (ADRESH<<8)|ADRESL  ;
         read =  (read * 100) / 1023;
         return read;

}

unsigned int check_moisture(void){

     moist = ADC_read1();
     return moist;
}

void buzz(){
     TRISD = 0x00;
     PORTD = 0x00;
     PORTD = PORTD | 0x01;
     myyDelay(1000);
     PORTD = PORTD & 0x00;
     myyDelay(1000);
}

int Dist1(){
//Trigger on RC0 ,, Echo on RC1

int dist=0;
TMR1H = 0;                  //Sets the Initial Value of Timer
TMR1L = 0;                  //Sets the Initial Value of Timer

RC0_BIT = 1;               //TRIGGER HIGH
Delay_us(10);               //10uS Delay
RC0_BIT = 0;               //TRIGGER LOW

while(!RC1_BIT);           //Waiting for Echo
T1CON.F0 = 1;               //Timer Starts
while(RC1_BIT);            //Waiting for Echo goes LOW
T1CON.F0 = 0;               //Timer Stops

dist = (TMR1L | (TMR1H<<8));   //Reads Timer Value
dist = dist/58.82;                //Converts Time to Distance
return dist;
}


void main(){

   TRISC=0x02;
   TRISB=0x01;       //port b is output
   PORTB = PORTB & 0xFE;
   PORTC=0x00;
   INTCON = INTCON | 0x90; // GIE and Local Enable the External Interrupt RB0

   Lcd_Init();                   // Initialize LCD
   myyDelay(2000);
   Lcd_Cmd(_LCD_CLEAR);          // Clear display
   Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off
   Lcd_Out(1,6,"Hello");

   ADC_init();

   //TRISB = 0x01;         // Push buttonon RB0

   myyDelay(1000);
   //INTCON = 0X90;
   myyDelay(1000);

   Lcd_Cmd(_LCD_CLEAR);               // Clear display
   Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off

   T1CON = 0x10;                 //Initialize Timer Module

   while(1){

       /*if(flag == 1){
               Lcd_Out(1,1,"Manual Irrigation System");*/
       myyDelay(3000);

       Lcd_Out(1,1,"Distance: ");         // Cursor off
       distt = Dist1();
       IntToStr(distt,text1);
       Ltrim(text1);
       Lcd_Out(2,8, text1);
       myyDelay(3000);
       Lcd_Cmd(_LCD_CLEAR);               // Clear display
       Lcd_Cmd(_LCD_CURSOR_OFF);

       if(distt > 6){
           buzz();
       }
       else{
            Lcd_Out(1,1,"Moisture: ");
            moist = check_moisture();
            IntToStr(moist,t_moist);
            ltrim(t_moist);
            Lcd_Out(2,8, t_moist );
            Lcd_Out_cp("%");
            myyDelay(4000);     // Write text in first row
            Lcd_Cmd(_LCD_CLEAR);               // Clear display
            Lcd_Cmd(_LCD_CURSOR_OFF);

            if(moist < 36){
                     Lcd_Out(2,1,"Low Moisture");
                     myyDelay(4000);
                     Lcd_Cmd(_LCD_CLEAR);
                     Lcd_Cmd(_LCD_CURSOR_OFF);                // Clear display
                     PORTD = PORTD | 0x02;  //0000 0010
                     myyDelay(4000);
                     PORTD = PORTD & 0x00;
                     myyDelay(2000);
                     PORTC = PORTC | 0x04; //0000 0100
                     myyDelay(5000);
                     PORTC = PORTC & 0x00;  //0000 0000
                     continue;
            }

             else{
                   Lcd_Out(1,1,"High Moisture");                                                                                   //0000 0000 (bit 0 & 1 output)
                   PORTD = PORTD | 0X04;     //0000 0100
                   myyDelay(4000);
                   PORTB = PORTB & 0x00;
                   continue;
             }

       }

   }

 }

void myyDelay(unsigned int t){
     for(i = 0;i < t; i++)
            for(j = 0;j < 165; j++); //delay of 1 ms

}