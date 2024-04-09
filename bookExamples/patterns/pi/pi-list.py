import mpmath

def pi_digits(n):
    mpmath.mp.dps = n + 1  # Set the number of decimal places
    pi_str = str(mpmath.pi)  # Get Pi as a string with desired precision
    pi_digits_array = [int(digit) for digit in pi_str.replace('.', '')]  # Convert Pi string to array of digits
    return pi_digits_array

# Example usage
n = 20  # Number of digits desired
pi_array = pi_digits(n)
print(pi_array)