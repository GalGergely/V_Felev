# remove number repetitives

from operator import truediv


my_list = [1, 2, 4, 4, 1, 4, 2, 6, 2, 9]
new_list = []
for i in my_list:
    var = False
    for j in new_list:
        if (i == j):
            var = True
    if (var == False):
        new_list.append(i)
my_list = new_list
# Write your code here.
#
print("The list with unique elements only:")
print(my_list)
