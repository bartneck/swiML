def is_perfect_number(num):
    divisors = []
    for i in range(1, num):
        if num % i == 0:
            divisors.append(i)
    print(divisors)
    if sum(divisors) == num:
        return True
    else:
        return False

# Test the function with a specific number
number = 28  # Example number
if is_perfect_number(number):
    print(number, "is a perfect number.")
else:
    print(number, "is not a perfect number.")