import swiML

def fibonacci(n):
    fib_sequence = [1, 1]  # Initialize with the first two terms
    
    # Generate Fibonacci sequence up to n terms
    for i in range(2, n):
        next_term = fib_sequence[-1] + fib_sequence[-2]
        fib_sequence.append(next_term)
    return fib_sequence

def create_swiML_instructions():
    my_instruction_list=[]
    j=0
    # main loop to create <instruction> elements based on the fibonacci array
    while j<number:
        if full_array[j]%2==0:
            current_stroke=even_stroke
        else:
            current_stroke=uneven_stroke
        my_instruction_list.append(swiML.Instruction(
            length=('lengthAsLaps',full_array[j]),
            stroke=('standardStroke',current_stroke),
            rest=('afterStop','PT0M15S')
        ))
        j+=1   
    return my_instruction_list

#writing the swiML program to disk
def write_program():
    # warm up instructions
    warmUp=swiML.Instruction(
        length=('lengthAsDistance',400),
        stroke=('standardStroke','any'),
        intensity=('startIntensity',('zone','easy')),
    )

    # warm down instruction
    warmDown=swiML.Instruction(
        length=('lengthAsDistance',400),
        stroke=('standardStroke','any'),
        intensity=('startIntensity',('zone','easy')),
    )
    # the create the main instructions
    myInstructions=create_swiML_instructions()
    myInstructions[:0]=[swiML.SegmentName('Warm Up'),warmUp]
    myInstructions.insert(2,swiML.SegmentName('Fibonacci set'))
    myInstructions.append(swiML.SegmentName('Warm down'))
    myInstructions.append(warmDown)

    # assemble the description of the swimming program
    description_text="Swim the first "+str(number)+" terms of the Fibonacci sequence."
    
    # create the program
    simpleProgram=swiML.Program(
        title='Fibonacci Sequence',
        author=[('firstName','Christoph'),('lastName','Bartneck')],
        programDescription=description_text,
        poolLength='25',
        creationDate='2024-03-25',
        lengthUnit='laps',
        hideIntro=False,
        swiMLVersion='2.1',
        instructions=myInstructions
    )
    # write swiML XML to file
    swiML.writeXML('patterns/fibonacci/fibonacci.xml',simpleProgram)

# counting up the number
number = 9
even_stroke="notFreestyle"
uneven_stroke="freestyle"

# create an array of the fibonacci sequence and write the program
full_array=fibonacci(number)
write_program()