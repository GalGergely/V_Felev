# step1
beatles = []

# step2
members = ['John Lennon', 'Paul McCartney', 'George Harrison']
i = 0
for m in members:
    beatles.append(i, m)
    i = i+1

# step3
print("you have to add the remaining members")
for x in range(1, 2):
    inp = input()
    beatles.append(i, inp)
    i = i+1

# not worth the time
