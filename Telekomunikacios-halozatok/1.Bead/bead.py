import json

f = open('cs1.json')
data = json.load(f)


def checkIfCircuitAvailable(circuit, demand):
    links = data["links"]
    circuitFirst = 0
    circuitSecond = 1
    for c in circuit:
        val = False
        for link in links:
            if (link['points'][0] == circuit[circuitFirst] and link['points'][1] == circuit[circuitSecond] and link['capacity'] >= demand['demand']):
                val = True
        if (val == False):
            return False
    circuitFirst = circuitFirst+1
    circuitSecond = circuitSecond+1
    return True


def checkPossibleCircuits(demand):
    circuits = data['possible-circuits']
    for c in circuits:
        start = c[0]
        finish = c[len(c)-1]
        if (demand["end-points"][0] == start and demand["end-points"][1] == finish):
           # print("Start:" + start + " Finish:" + finish)
            print(checkIfCircuitAvailable(c, demand))


def reservationRequest(demand):
    checkPossibleCircuits(demand)


def checkIfSgStarts(time):
    demands = data['simulation']['demands']
    for demand in demands:
        if (demand["start-time"] == time):
            reservationRequest(demand)
            print(demand)


def checkIfSgStopps(time):
    demands = data['simulation']['demands']
    for demand in demands:
        if (demand["end-time"] == time):
            print(demand)


t = 0
while (t <= data['simulation']['duration']):
    print(t)
    checkIfSgStarts(t)
    checkIfSgStopps(t)
    t = t+1
