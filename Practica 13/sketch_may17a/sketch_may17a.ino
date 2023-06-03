#include <SoftwareSerial.h>
#include <LiquidCrystal.h>
                //RS,E,D4,D5,D6,D7
LiquidCrystal lcd(7,6,5,4,3,2);
                  //Tx,Rx
SoftwareSerial BT(10, 11);  
char c;
String cad;
int inicio = 1;
void setup() {
  lcd.begin(16,2);
  BT.begin(9600);
  Serial.begin(9600);
  BT.println("Conexion Abierta");
 
}
void loop() {
  if(inicio ==1) {
    lcd.print("LCD Inicializada");
    delay(2000);
    lcd.clear();
    
    inicio = 0;
  }
  if (BT.available()) {
    c = BT.read();
    if (c == 'A') {
      lcd.scrollDisplayLeft();
    } else if (c == 'B') {
      lcd.scrollDisplayRight();
    } else if( c == 'C'){
      lcd.setCursor(0, 0);
      lcd.clear();
    }
      else {
      lcd.print(c);
    }
    Serial.write(c);

  }
}
