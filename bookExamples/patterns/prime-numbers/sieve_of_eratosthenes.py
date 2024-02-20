import time
def sieve_of_eratosthenes(limit):
    primes = []
    is_prime = [True] * (limit + 1)
    is_prime[0] = is_prime[1] = False

    for num in range(2, int(limit**0.5) + 1):
        if is_prime[num]:
            primes.append(num)
            for multiple in range(num * num, limit + 1, num):
                is_prime[multiple] = False

    for num in range(int(limit**0.5) + 1, limit + 1):
        if is_prime[num]:
            primes.append(num)

    return primes

# Example: Find prime numbers up to 50
start_time = time.time()
limit = 100000
prime_numbers = sieve_of_eratosthenes(limit)
stop_time = time.time()
print("Prime numbers up to", limit, "are:", prime_numbers)
print("Time required:", stop_time - start_time)