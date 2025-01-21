import numpy as np
import csv

# Define the Grime Dice
dice = {
    'A': [2, 2, 4, 4, 9, 9],
    'B': [1, 1, 6, 6, 8, 8],
    'C': [3, 3, 5, 5, 7, 7],
    'D': [1, 1, 2, 2, 11, 11],
    'E': [0, 0, 7, 7, 10, 10]
}

# Function to roll a die
def roll_die(die):
    return np.random.choice(die)

# Function to compare two dice
def compare_dice(die1, die2, rolls=100):
    die1_wins = 0
    die2_wins = 0
    for _ in range(rolls):
        roll1 = roll_die(die1)
        roll2 = roll_die(die2)
        if roll1 > roll2:
            die1_wins += 1
        elif roll2 > roll1:
            die2_wins += 1
    return die1_wins, die2_wins

# Compare all combinations of dice
results = []
dice_names = list(dice.keys())
for i in range(len(dice_names)):
    for j in range(i + 1, len(dice_names)):
        die1_name = dice_names[i]
        die2_name = dice_names[j]
        die1_wins, die2_wins = compare_dice(dice[die1_name], dice[die2_name])
        results.append([die1_name, die2_name, die1_wins, die2_wins])

# Write results to a CSV file
with open('dice_comparison_results.csv', mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Die 1', 'Die 2', 'Die 1 Wins', 'Die 2 Wins'])
    writer.writerows(results)

print("Results have been written to dice_comparison_results.csv")