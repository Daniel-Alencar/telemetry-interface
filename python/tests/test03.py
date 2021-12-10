
import time
import serial
 
DELAY = 0.100
DEVICE='/dev/ttyACM0'
BAUD=9600

1024.00

# Iniciando conexao serial
arduinoData = serial.Serial(DEVICE, BAUD)

while arduinoData.isOpen():
  bytesToRead = arduinoData.inWaiting()
  string = arduinoData.read(bytesToRead).decode()

  print(string)
  time.sleep(DELAY)

arduinoData.close()