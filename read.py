#!/usr/bin/python
# -*- coding: iso-8859-1 -*-
import time
import serial
 
DELAY = 0.000
DEVICE='/dev/ttyACM0'
BAUD=9600

# Iniciando conexao serial
comport = serial.Serial(DEVICE, BAUD)

while comport.isOpen():
  VALUE_SERIAL=comport.readline()
  print('\n%s' % (VALUE_SERIAL.decode()))

  time.sleep(DELAY)
 
# Fechando conexao serial
comport.close()