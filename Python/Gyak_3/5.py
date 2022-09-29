user_word = input()
user_word = user_word.upper()
vowes = ['A', 'E', 'I', 'O', 'U']
for u in user_word :
    if(vowes.__contains__(u)) :
        print(end="")
    else :
        print(u, end="")