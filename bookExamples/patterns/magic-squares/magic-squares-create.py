import itertools
import time
import random

def check(attempt):
    for i in range(0,4):
        if sum(attempt[i*4:i*4+4]) != 34:
            return False
        if sum(attempt[i+j*4] for j in range(0,4)) != 34:
            return False
    if sum(attempt[i+i*4] for i in range(0,4)) != 34:
        return False
    if sum(attempt[3-i+i*4] for i in range(0,4)) != 34:
        return False
    return True

def row(pos, field, rest, solutions):
    base = 34 - sum(field[pos*4:pos*4+pos])
    for p in itertools.permutations(rest, 3-pos):
        r = base - sum(p)
        s = rest - set(p)
        if r in s:
            for i in range(pos,3):
                field[pos*4+i] = p[i-pos]
            field[pos*4+3] = r
            column(pos, field, s-{r}, solutions)

def column(pos, field, rest, solutions):
    if len(rest) == 0:
        if check(field):
            solutions.append(field.copy())
        return
    base = 34 - sum([field[pos+4*i] for i in range(0,pos+1)])
    for p in itertools.permutations(rest, 2-pos):
        r = base - sum(p)
        s = rest - set(p)
        if r in s:
            for i in range(pos+1,3):
                field[pos+i*4] = p[i-pos-1]
            field[pos+4*3] = r
            row(pos+1, field, s-{r}, solutions)

start = time.time()
solutions = []

row(0, [0]*16, set(range(1,17)), solutions)

print("Total Solutions:", len(solutions))

# Randomly select one solution
selected_solution = random.choice(solutions)

# Print the selected solution
print("Selected Solution:")
for i in range(4):
    print(selected_solution[i*4:i*4+4])

print("Time taken:", time.time()-start)
