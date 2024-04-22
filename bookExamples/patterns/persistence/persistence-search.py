def multiply_digits(n):
    result = 1
    while n > 0:
        result *= n % 10
        n //= 10
    return result

def multiplicative_persistence(n):
    persistence = 0
    while n >= 10:
        print(n)
        n = multiply_digits(n)
        persistence += 1
    return persistence

# Example usage
number = 
persistence = multiplicative_persistence(number)
print("The multiplicative persistence of " + str(number) + " is " + str(persistence) + ".")