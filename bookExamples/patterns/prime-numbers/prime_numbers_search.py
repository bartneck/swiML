# Simple Python program to find prime numbers in a range
import time

# prime search function
def is_prime(n):
 if n <= 1:
  return False
 for i in range(2, n):
  if n % i == 0:
   return False
 return True

# setup variables
start_time = time.time() # start time
count_primes = 0 # for counting
search_range = 100000 # search up to this value

# main loop
for n in range(1, search_range):
 x = is_prime(n)
 count_primes += x

# report result
print("Total prime numbers in range :", count_primes)
stop_time = time.time()
print("Time required :", stop_time - start_time)