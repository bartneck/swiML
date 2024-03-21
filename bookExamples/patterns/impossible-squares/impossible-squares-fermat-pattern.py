from collections import Counter

def is_sum_of_two_squares(n):
    # Get the prime factorization of n
    prime_factorization = Counter()
    i = 2
    while i * i <= n:
        while n % i == 0:
            prime_factorization[i] += 1
            n = n // i
        i += 1
    if n > 1:
        prime_factorization[n] += 1
    
    # Check that every prime of the form (4k + 3) occurs an 
    # even number of times
    for prime, count in prime_factorization.items():
        if prime % 4 == 3 and count % 2 != 0:
            return False
    
    return True

print(is_sum_of_two_squares(14)) # False
print(is_sum_of_two_squares(15)) # True