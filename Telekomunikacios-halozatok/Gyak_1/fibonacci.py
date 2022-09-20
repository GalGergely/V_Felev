fib = [0, 1]

def addToFib(num) :
    index = 0
    for x in range(1, num-1):
        fib.append(fib[index]+fib[index+1])
        index=index+1
    
addToFib(10)
print(fib)