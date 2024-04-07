# Initialize the sequence with the first term
seq = [0]
steps = []

# Calculate the remaining terms
for i in range(1, 10):
    # Calculate the next term using the recurrence relation
    next_term = seq[-1] - i

    # If the next term is negative or has already appeared in the sequence,
    # use the formula with addition instead
    if next_term in seq or next_term < 0:
        next_term = seq[-1] + i

    # Determine whether the step is forward or backward
    step = 'forward' if next_term > seq[-1] else 'backward'
    steps.append(step)

    # Add the next term to the sequence
    seq.append(next_term)

# Output the sequence and steps
print('Sequence:', seq)
print('Steps:', steps)