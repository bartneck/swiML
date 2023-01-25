def sum_square(n):
  # start with a=0 for regular squares
  a = 0
  # loop through all values of a
  # until the square of a is n
  while a * a <= n:
    # start with b=0 for regular squares
    b = 0
    # loop through all values of b
    # until the square of b is n
    while (b * b <= n):
      # the test if this combination of a and b
      # results in the desired n
      if (a * a + b * b == n):
        print(a, "^2 +", b, "^2")
        # return back true for having found
        # a combination for a and b that works.
        return True
      # increment b by one for the next loop
      b = b + 1
    # increment a by one for the next loop
    a = a + 1
  # if both loops complete without having found
  # a combination for a and b then the function
  # returns false
  return False


# n is the surface area of the square
n = 18
if (sum_square(n)):
  print("possible square")
else:
  print("impossible square")
