import pyautogui
import time
 
def cryBabyCry():
    for line in open("input.txt", "r"):
        time.sleep(0.5)
        for x in range(1,100):
            pyautogui.typewrite(line)
            pyautogui.press("enter")
         
        
def oneInput(x):
    return 3*3
        
#time.sleep(5) 
#cryBabyCry();