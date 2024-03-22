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
    count_1_total = 0
    count_2_total = 0
    count_3_total = 0
    for i in range(1, n_terms + 1):
        sequence = look_and_say(i)
        count_1, count_2, count_3 = count_digits(sequence)
        count_1_total += count_1
        count_2_total += count_2
        count_3_total += count_3
    return count_1_total, count_2_total, count_3_total

# Example usage:
n_terms = 100
count_1_total, count_2_total, count_3_total = count_digits_for_all_terms(n_terms)
print(f"Total count of 1: {count_1_total}, Total count of 2: {count_2_total}, Total count of 3: {count_3_total}")
