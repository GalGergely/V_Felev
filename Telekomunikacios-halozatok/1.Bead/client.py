import json
import sys

if (len(sys.argv) == 2):
    data = json.load(open(sys.argv[1]))
else:
    exit(1)
occupiedCircuits = []
startedDemands = []


def checkIfCircuitAvailable(circuit, demand):
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
    links = data["links"]
    for c in range(0, len(circuit)-1):
        for link in links:
            if (link['points'][0] == circuit[c] and link['points'][1] == circuit[c+1] and link['capacity'] >= demand['demand']):
                link['capacity'] = link['capacity']-demand['demand']
    occupiedCircuits.append([circuit, demand])
    return True


def checkPossibleCircuits(demand):
    circuits = data['possible-circuits']
    for c in circuits:
        start = c[0]
        finish = c[len(c)-1]
        if (demand["end-points"][0] == start and demand["end-points"][1] == finish):
            if (checkIfCircuitAvailable(c, demand)):
                if (allocateTheDemand(c, demand)):
                    startedDemands.append(demand)
                    print("igény foglalás: " + str(demand['end-points'][0])+"<->" +
                          str(demand['end-points'][1])+" st: " + str(demand['start-time'])+' - sikeres')
                    return True
    print("igény foglalás: " + str(demand['end-points'][0])+"<->" +
          str(demand['end-points'][1])+" st:" + str(demand['start-time'])+' - sikertelen')
    return False


def reservationRequest(demand):
    checkPossibleCircuits(demand)


def checkIfSgStarts(time):
    demands = data['simulation']['demands']
    for demand in demands:
        if (demand["start-time"] == time):
            reservationRequest(demand)


def letResourcesDeallocate(demand):
    bul = False
    for d in startedDemands:
        if (d == demand):
            bul = True
    if (bul):
        for c in occupiedCircuits:
            if (c[1] == demand):
                deallocateOneByOne(c[0], demand['demand'])
        print('igény felszabaditasra: ' +
              str(demand['end-points'][0]) + '<->' + str(demand['end-points'][1]) + ' st: ' + str(demand['end-time']) + ' - sikeres')
        return True
    else:
        return False


def deallocateOneByOne(circuit, demandSize):
    for c in range(0, len(circuit)-1):
        for link in data['links']:
            if (link['points'][0] == circuit[c] and link['points'][1] == circuit[c+1]):
                link['capacity'] += demandSize


def checkIfSgStopps(time):
    demands = data['simulation']['demands']
    for demand in demands:
        if (demand["end-time"] == time):
            letResourcesDeallocate(demand)


t = 0
while (t <= data['simulation']['duration']):
    checkIfSgStarts(t)
    checkIfSgStopps(t)
    t = t+1
