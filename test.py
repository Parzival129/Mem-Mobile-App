import random

verbs = {'fermer':'to close', 'jouer':'to play'}
print(verbs['fermer'])

while True:
    indexThing = random.randint(0, len(verbs))
    verbGuess = verbs[indexThing]
    print(verbGuess + '?')
    input()
    print('A: ' + meanings[indexThing])
    print ("")
