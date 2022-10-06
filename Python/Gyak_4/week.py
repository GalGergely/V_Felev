weekdays = ('monday', ' tuesday', 'wednesday',
            'thursday', 'friday', 'saturday', 'sunday')
try:
    weekdays[0] = 'my size is small'
except TypeError:
    print('you cant')
finally:
    print('bye')
