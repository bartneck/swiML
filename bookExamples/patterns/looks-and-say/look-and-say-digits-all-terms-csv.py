import csv

def count_digits(sequence):
    count_1 = sequence.count('1')
    count_2 = sequence.count('2')
    count_3 = sequence.count('3')
    return count_1, count_2, count_3

def look_and_say(n):
    if n == 1:
        return '1'
    if n == 2:
        return '11'

    s = "11"
    for _ in range(3, n + 1):
        s += '$'
        l = len(s)
        cnt = 1
        tmp = ""
        for j in range(1, l):
            if s[j] != s[j - 1]:
                tmp += str(cnt + 0)
                tmp += s[j - 1]
                cnt = 1
            else:
                cnt += 1
        s = tmp
    
    return s

# Function to count digits for all terms
def count_digits_for_all_terms(n_terms):
    count_1_list = []
    count_2_list = []
    count_3_list = []
    for i in range(1, n_terms + 1):
        sequence = look_and_say(i)
        count_1, count_2, count_3 = count_digits(sequence)
        count_1_list.append(count_1)
        count_2_list.append(count_2)
        count_3_list.append(count_3)
    return count_1_list, count_2_list, count_3_list

# Example usage:
n_terms = 50
count_1_list, count_2_list, count_3_list = count_digits_for_all_terms(n_terms)

# Write counts to CSV file
with open('digit_counts.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Term', 'Count of 1', 'Count of 2', 'Count of 3'])
    for i in range(n_terms):
        writer.writerow([i + 1, count_1_list[i], count_2_list[i], count_3_list[i]])

print("CSV file 'digit_counts.csv' has been created with counts of digits.")
