#line 1 "C:/Users/user1/Desktop/New folder (2)/MyProject.c"

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


unsigned int temp;
char Temperature[] = " 00.0 C";
char t_temp[6];
int distt = 0;
char text1[7];
int i;
int j;
char t_moist[7];
unsigned int moist;



void myyDelay (unsigned int t);

void interrupt(){

 if(INTCON | 0x02){
 PORTC = PORTC | 0x04;
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
 INTCON = INTCON & 0xFD;
 }

}

void ADC_init(void){
 ADCON1 = 0xC0;
 TRISA = 0x0F;
 ADCON0 = 0x41;

}


unsigned int ADC_read1(){
 unsigned int read = 0;
 ADCON0 = 0x41;
 ADCON0 = ADCON0 | 0x04;
 while(ADCON0 & 0x04);

 read = (ADRESH<<8)|ADRESL ;
 read = (read * 100) / 1023;
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


int dist=0;
TMR1H = 0;
TMR1L = 0;

RC0_BIT = 1;
Delay_us(10);
RC0_BIT = 0;

while(!RC1_BIT);
T1CON.F0 = 1;
while(RC1_BIT);
T1CON.F0 = 0;

dist = (TMR1L | (TMR1H<<8));
dist = dist/58.82;
return dist;
}


void main(){

 TRISC=0x02;
 TRISB=0x01;
 PORTB = PORTB & 0xFE;
 PORTC=0x00;
 INTCON = INTCON | 0x90;

 Lcd_Init();
 myyDelay(2000);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,6,"Hello");

 ADC_init();



 myyDelay(1000);

 myyDelay(1000);

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 T1CON = 0x10;

 while(1){
#line 149 "C:/Users/user1/Desktop/New folder (2)/MyProject.c"
 myyDelay(3000);

 Lcd_Out(1,1,"Distance: ");
 distt = Dist1();
 IntToStr(distt,text1);
 Ltrim(text1);
 Lcd_Out(2,8, text1);
 myyDelay(3000);
 Lcd_Cmd(_LCD_CLEAR);
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
 myyDelay(4000);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 if(moist < 36){
 Lcd_Out(2,1,"Low Moisture");
 myyDelay(4000);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 PORTD = PORTD | 0x02;
 myyDelay(4000);
 PORTD = PORTD & 0x00;
 myyDelay(2000);
 PORTC = PORTC | 0x04;
 myyDelay(5000);
 PORTC = PORTC & 0x00;
 continue;
 }

 else{
 Lcd_Out(1,1,"High Moisture");
 PORTD = PORTD | 0X04;
 myyDelay(4000);
 PORTB = PORTB & 0x00;
 continue;
 }

 }

 }

 }

void myyDelay(unsigned int t){
 for(i = 0;i < t; i++)
 for(j = 0;j < 165; j++);

}
