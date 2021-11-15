#!/media/engenheiro/Arquivos Linux/Documents/Jobs/Cactus rockets/TRAINEE/Telemetria/Interface/TelemetryENV/bin/python3
# -*- coding: iso-8859-1 -*-

import time
import serial
 
DELAY = 0.010
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