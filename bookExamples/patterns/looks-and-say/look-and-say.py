# Program to find the terms of the Look and Say sequence
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

# n_terms defines how many terms you want to know:
n_terms = 16
for i in range(1, n_terms + 1):
    print(f"Term {i}: {look_and_say(i)}")
