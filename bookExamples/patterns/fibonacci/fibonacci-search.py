def fibonacci(n):
    if n <= 1:
        return n
    else:
        return (fibonacci(n-1) + fibonacci(n-2))

# set the number of terms to be calculated
n_terms = 10

print("Fibonacci sequence:")
for i in range(n_terms):
    print(fibonacci(i))