/* This is the source code of Brain Programming Language.
 * It is licensed under GNU GPL v. 3 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Brain, 2016.
 */

#include <SPI.h>
#include <EEPROM.h>
#include <boards.h>
#include <RBL_nRF8001.h>
#include <Brain.h>
#include <BrainStation.h>
#include <LiquidCrystal.h>

byte human1[8] = {
  B01100,
  B01100,
  B00000,
  B01110,
  B11100,
  B01100,
  B11010,
  B10011
};

byte human2[8] = {
  B01100,
  B01100,
  B00000,
  B01100,
  B01100,
  B01100,
  B01100,
  B01010
};

byte monster1[8] = {
  0b01110,
  0b11111,
  0b01110,
  0b11111,
  0b11111,
  0b01110,
  0b01010,
  0b10001
};

byte monster2[8] = {
  0b01110,
  0b11111,
  0b01110,
  0b11111,
  0b11111,
  0b01110,
  0b00100,
  0b00100
};


byte *sprites[] = {
  (byte*)human1,
  (byte*)human2,
  (byte*)monster1,
  (byte*)monster2,
};

LiquidCrystal lcd(7, 6, 5, 4, 3, 2);
BrainStation brain_station = BrainStation(&lcd, sprites, 4);
Brain brain = Brain(&lcd, &Serial, &brain_station, analogRead(0));

void setup()
{    
  // Set your BLE Shield name here, max. length 10
  //ble_set_name("My Name");
  
  ble_begin();
  
  // Enable serial debug
  Serial.begin(57600);

  lcd.begin(16, 2);
  lcd.noAutoscroll();
  brain.setCode(">?->>>>>>>>>>>-<<<<<<<<<:>>;?->>>>>>>>>+<<<<<:>>>>;?:++;>>?:++;>+%>>>>?:++;>+%++>?-:+++++++++++++++;");
}

void loop()
{
  Serial.print(brain.getValue(15));
  while (ble_available()) {
      char str[3];
      for (int i = 0; i < 3; i++) {
          str[i] = ble_read();
      }
      
      brain_station.handleEvents(&brain, str, 3);
  }
  
  brain.run();
  ble_do_events();
  delay(200);
}
