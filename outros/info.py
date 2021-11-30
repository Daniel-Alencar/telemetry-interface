
import sys
import time
import serial

DEVICE='/dev/ttyACM0'
BAUD=9600
TIME_OUT=1
 
def Info():
    print ('\nObtendo informacoes sobre a comunicacao serial...\n')

    # Iniciando conexao serial
    comport = serial.Serial(DEVICE, BAUD, timeout=TIME_OUT)
    time.sleep(1.8)

    print('Status da Porta: %s ' % (comport.isOpen()))
    print('Device conectado: %s ' % (comport.name))
    print('Dump da configuracao: %s ' % (comport))

    # Fechando conexao serial
    comport.close()
 
""" main """
if __name__ == '__main__':
    Info()