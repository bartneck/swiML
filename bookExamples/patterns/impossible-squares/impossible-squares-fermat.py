from collections import Counter
import math, swiML

def is_sum_of_two_squares(n):
    # Get the prime factorization of n
    prime_factorization = Counter()
    i = 2
    while i * i <= n:
        while n % i == 0:
            prime_factorization[i] += 1
            n = n // i
        i += 1
    if n > 1:
        prime_factorization[n] += 1
    
    # Check that every prime of the form (4k + 3) occurs an 
    # even number of times
    for prime, count in prime_factorization.items():
        if prime % 4 == 3 and count % 2 != 0:
            return False
    return True

def is_square_number(num):
    # Check if the square root of the number is an integer
    square_root = math.sqrt(num)
    return square_root.is_integer()

def find_squares(number):
    impossible_squares=[]
    i=1
    # check for every number if it is regular, slanted or impossible
    # return a list of the result
    while i <= number:
        if is_square_number(i):
            impossible_squares.append(["backstroke","regular"])
        elif is_sum_of_two_squares(i):
            impossible_squares.append(["breaststroke","slanted"])
        else: 
            impossible_squares.append(["freestyle","impossible"])
        i+=1
    return impossible_squares

def create_swiML_instructions(my_list):
    my_instruction_list=[]
    i=1
    # write an instruction for each list item
    # return list of instructions
    while i in range(len(my_list)):
        my_instruction_list.append(swiML.Instruction(
            length=('lengthAsLaps',i),
            stroke=('standardStroke',my_list[i-1][0]),
            instructionDescription=(my_list[i-1][1]),
            rest=('afterStop','PT0M15S')
        ))
        i+=1
    return my_instruction_list

def write_program(myInstructions):
    warmUp=swiML.Instruction(
        length=('lengthAsDistance',400),
        stroke=('standardStroke','any'),
        intensity=('startIntensity',('zone','easy')),
    )
    
    # warm up instructions
    myInstructions[:0]=[swiML.SegmentName('WarmUp'),warmUp]

    simpleProgram=swiML.Program(
        title='Impossible Squares',
        author=[('firstName','Christoph'),('lastName','Bartneck')],
        programDescription='Swim regular, slanted and impossible squares.',
        poolLength='25',
        creationDate='2024-03-15',
        lengthUnit='meters',
        hideIntro=True,
        swiMLVersion='2.0',
        instructions=myInstructions
    )
    # write swiML XML to file
    swiML.writeXML('impossible-squares.xml',simpleProgram)

# the maximum number of laps which is equal to the number of instructions given.
length_program=16
# find if the numbers up to length_program are impossible squares
squares_list=find_squares(length_program)
# create the swiML instructions based on the squares_list
instruction_list=create_swiML_instructions(squares_list)
# write the swiML XML program to disk
write_program(instruction_list)