import json

f = open('zhszamolo.json')
data = json.load(f)

maxPont = data["socketPont"]["max"]+data["zhPont"]["max"]+data["mininetPont"]["max"]
kettes = maxPont * 0.5
harmas = maxPont * 0.6
negyes = maxPont * 0.7
otos = maxPont * 0.8

def hanyasLesz(szam) :
    elertOssz = data["socketPont"]["elert"]+data["zhPont"]["elert"]
    if(elertOssz >= szam) :
        print("megvan")
    elif(elertOssz+data["mininetPont"]["max"] > szam) :
        print(szam-elertOssz)
    else :
        print("eselytelen")

print("kettes:", end =" ")
hanyasLesz(kettes)
print("harmas:", end =" ")
hanyasLesz(harmas)
print("negyes:", end =" ")
hanyasLesz(negyes)
print("otos:", end =" ")
hanyasLesz(otos)