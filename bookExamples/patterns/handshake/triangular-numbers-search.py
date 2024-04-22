def triangular_sequence(n):
    # Initialize an empty array to store the sequence
    sequence = []

    # Generate the sequence and store it in the array
    for i in range(1, n + 1):
        triangular_number = (i * (i + 1)) // 2
        sequence.append(triangular_number)
    
    return sequence

# define number of terms
n = 10
# calculate sequence
triangular_numbers = triangular_sequence(n)
print("Sequence of", n, "triangular numbers:", triangular_numbers)
