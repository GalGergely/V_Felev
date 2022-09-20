dates = []
with open('szokoev.txt', 'r') as f:
    for line in f:
       dates += line.strip().split(',')

def isSzokoev(date) :
    if(date % 4 == 0) :
        if(date % 100 != 0) :
            print(date, "szokoev")
        elif(date % 400 == 0) :
            print(date, "szokoev")
        else :
            print(date, "nem szokoev")
    else :
        print(date, "nem szokoev")

for x in dates:
    isSzokoev(int(x))
