def is_prime(num):
    var = True
    for i in range(2, num-1):
        if (num % i == 0):
            var = False
            break
    return var


for i in range(1, 20):
    if (is_prime(i + 1)):
        print(i + 1, end=" ")
