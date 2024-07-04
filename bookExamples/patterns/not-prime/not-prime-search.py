def count_divisors(n):
    #Returns the number of divisors of n
    count = 0
    for i in range(1, int(n**0.5) + 1):
        if n % i == 0:
            count += 2 if i != n // i else 1
    return count

def find_highly_composite_numbers(limit):
    #Finds all Highly Composite Numbers up to a given limit
    highly_composite_numbers = []
    max_divisors = 0
    
    for num in range(1, limit + 1):
        divisors = count_divisors(num)
        if divisors > max_divisors:
            highly_composite_numbers.append(num)
            max_divisors = divisors
    return highly_composite_numbers

# Example usage
limit = 100
hcn_list = find_highly_composite_numbers(limit)
print(f"Highly Composite Numbers up to {limit}: {hcn_list}")