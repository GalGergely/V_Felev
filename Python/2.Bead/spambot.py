import pyautogui, time
import sys
time.sleep(5)
filename = "input.txt"
forlength = 1
if(len(sys.argv) == 3):
    forlength = int(sys.argv[2])
    filename = sys.argv[1]
elif (len(sys.argv) == 2):
    filename = sys.argv[1]
elif(len(sys.argv) == 1):
    filename = "input.txt"
f = open(filename,'r')
for word in f:
    for i in range(0, forlength):
        pyautogui.typewrite(word)
        pyautogui.press('enter')