def liters_100km_to_miles_gallon(num):
    gallon = num / 3.785411784
    miles = 100 / 1.609344
    return (miles/gallon)


def miles_gallon_to_liters_100km(num):
    km = num*1.609344
    # print(km)
    liter = 3.785411784
    var = 100/km
    # print(var)
    return liter*var


print(liters_100km_to_miles_gallon(3.9))
print(liters_100km_to_miles_gallon(7.5))
print(liters_100km_to_miles_gallon(10.))
print(miles_gallon_to_liters_100km(60.3))
print(miles_gallon_to_liters_100km(31.4))
print(miles_gallon_to_liters_100km(23.5))
