import json
import sys

if (len(sys.argv) == 2):
    data = json.load(open(sys.argv[1]))
else:
    exit(1)

occupiedCircuits = []
startedDemands = []


def checkIfCircuitAvailable(circuit, demand):
    # ha a kivalaszotott circuit barmelyik linkje nem elerheto false, ha elerheto minden ture
    links = data["links"]
    for c in range(0, len(circuit)-1):
        val = False
        for link in links:
            if (link['points'][0] == circuit[c] and link['points'][1] == circuit[c+1] and link['capacity'] >= demand['demand']):
                val = True
        if (val == False):
            return False
    return True


def allocateTheDemand(circuit, demand):
    # itt mar tudjuk hogy az adott linkek minden resze elerheto,szoval csak a lefoglalast vegzi
    links = data["links"]
    for c in range(0, len(circuit)-1):
        for link in links:
            if (link['points'][0] == circuit[c] and link['points'][1] == circuit[c+1] and link['capacity'] >= demand['demand']):
                #print(str(link['points'][0])+'<=>'+str(link['points'][1])+"; old capacity: "+str(link['capacity']))
                link['capacity'] = link['capacity']-demand['demand']
                #print(str(link['points'][0])+'<=>'+str(link['points'][1])+"; New capacity: "+str(link['capacity']))
    occupiedCircuits.append([circuit, demand])


def checkPossibleCircuits(demand):
    global counter
    circuits = data['possible-circuits']
    for c in circuits:
        start = c[0]
        finish = c[len(c)-1]
        # ellenorzi mely circuit kezdo es vegpontja felel meg a demand kezdo es vegpontjanak
        if (demand["end-points"][0] == start and demand["end-points"][1] == finish):
            if (checkIfCircuitAvailable(c, demand)):
                allocateTheDemand(c, demand)
                startedDemands.append(demand)
                print(str(counter)+". igény foglalás: " + str(demand['end-points'][0])+"<->" +
                      str(demand['end-points'][1])+" st:" + str(demand['start-time'])+' - sikeres')
                counter = counter+1
                return True
    print(str(counter)+". igény foglalás: " + str(demand['end-points'][0])+"<->" +
          str(demand['end-points'][1])+" st:" + str(demand['start-time'])+' - sikertelen')
    counter = counter+1
    return False


def letResourcesDeallocate(demand):
    # eloszor leelenorzi hogy a demand egyaltalan elindult e, es ha igen, akkor a lefoglalt circuitoknak visszaadja a kakaot
    global counter
    bul = False
    for d in startedDemands:
        if (d == demand):
            bul = True
    if (bul):
        for c in occupiedCircuits:
            if (c[1] == demand):
                deallocateOneByOne(c[0], demand['demand'])
        print(str(counter)+'. igény felszabadítás: ' +
              str(demand['end-points'][0]) + '<->' + str(demand['end-points'][1]) + ' st:' + str(demand['end-time']))
        counter = counter+1


def deallocateOneByOne(circuit, demandSize):
    for c in range(0, len(circuit)-1):
        for link in data['links']:
            if (link['points'][0] == circuit[c] and link['points'][1] == circuit[c+1]):
                #print('before'+ str(link['capacity']))
                link['capacity'] += demandSize
                #print('after'+ str(link['capacity']))


def checkIfSgStopps(time):
    # megnezi valami megall e
    demands = data['simulation']['demands']
    for demand in demands:
        if (demand["end-time"] == time):
            letResourcesDeallocate(demand)


def checkIfSgStarts(time):
    # megnezi valami elindul e
    demands = data['simulation']['demands']
    for demand in demands:
        if (demand["start-time"] == time):
            checkPossibleCircuits(demand)


def startProgram(t):
    checkIfSgStarts(t)
    checkIfSgStopps(t)


t = 0
counter = 1
while (t <= data['simulation']['duration']):
    startProgram(t)
    t = t+1
# print(data)
