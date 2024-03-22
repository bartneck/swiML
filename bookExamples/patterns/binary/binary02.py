import math

def integer_to_variable_size_binary_array(number):
    # Determine the number of bits necessary to represent the number
    num_bits = math.ceil(math.log2(number + 1))  # Add 1 to handle the case when number is 0

    # Convert the integer to binary representation
    binary_representation = bin(number)[2:]  # [2:] to remove '0b' prefix from binary string

    # Pad the binary representation with leading zeroes to make it num_bits long
    binary_representation = binary_representation.zfill(num_bits+1)

    # Create an array to store binary digits
    binary_array = [int(digit) for digit in binary_representation]

    return binary_array, num_bits

# Example usage
number = 42
binary_array, num_bits = integer_to_variable_size_binary_array(number)
print(f"Binary representation of {number} with {num_bits} bits: {binary_array}")
