import swiML

def triangular_sequence(n):
    # Initialize an empty array to store the sequence
    sequence = []

    # Generate the sequence and store it in the array
    for i in range(1, n + 1):
        triangular_number = (i * (i + 1)) // 2
        sequence.append(triangular_number)
    
    return sequence

def create_swiML_instructions():
    my_instruction_list=[]
    for i in range(0, nr_terms):
        my_instruction_list.append(swiML.Instruction(
                length=('lengthAsLaps',triangular_numbers[i]),
                # stroke=('standardStroke',steps[i]),
                rest=('afterStop','PT0M15S')
        ))
        i+=1
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
        length=('lengthAsDistance',200),
        stroke=('standardStroke','any'),
        intensity=('startIntensity',('zone','easy')),
    )
    # assembly of the main instructions
    myInstructions=create_swiML_instructions()
    myInstructions[:0]=[swiML.SegmentName('Warm Up'),warmUp]
    myInstructions.insert(2,swiML.SegmentName('Recaman set'))
    myInstructions.append(swiML.SegmentName('Warm down'))
    myInstructions.append(warmDown)
    
    # assemble the description of the swimming program
    description_text="Swim the first "+str(nr_terms)+" terms of the triangular numbers sequence."
    
    # create the program
    simpleProgram=swiML.Program(
        title='Traingular Numbers',
        author=[('firstName','Christoph'),('lastName','Bartneck')],
        programDescription=description_text,
        poolLength='25',
        creationDate='2024-04-22',
        lengthUnit='meters',
        hideIntro=False,
        swiMLVersion='2.1',
        instructions=myInstructions
    )
    # write swiML XML to file
    swiML.writeXML('patterns/handshake/handshake-program.xml',simpleProgram)

# define the number of terms
nr_terms=8

triangular_numbers = triangular_sequence(nr_terms)
print("Sequence of", nr_terms, "triangular numbers:", triangular_numbers)

# write the swiML program
write_program()

