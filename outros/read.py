#!/media/engenheiro/Arquivos Linux/Documents/Jobs/Cactus rockets/TRAINEE/Telemetria/Interface/TelemetryENV/bin/python3
# -*- coding: iso-8859-1 -*-

import time
import serial
 
DELAY = 0.000
DEVICE='/dev/ttyACM0'
BAUD=9600

1024.00

# Iniciando conexao serial
comport = serial.Serial(DEVICE, BAUD)

while comport.isOpen():
  string = ""
  value = comport.read().decode()
  string = string + value
  while value != '\n':
    value = comport.read().decode()
    string = string + value
  print(string)
  time.sleep(DELAY)

comport.close()