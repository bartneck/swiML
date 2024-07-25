import swiML as swiML

def find_recaman(terms):
    for i in range(1, terms):
        # Calculate the next term using the recurrence relation
        next_term = seq[-1] - i

        # If the next term is negative or has already appeared in the sequence,
        # use the formula with addition instead
        if next_term in seq or next_term < 0:
            next_term = seq[-1] + i

        # Determine whether the step is forward or backward
        step = 'freestyle' if next_term > seq[-1] else 'backstroke'
        steps.append(step)

        # Add the next term to the sequence
        seq.append(next_term)

def create_swiML_instructions():
    my_instruction_list=[]
    for i in range(1, nr_terms+1):
        my_instruction_list.append(swiML.Instruction(
                length=('lengthAsLaps',seq[i]),
                stroke=('standardStroke',steps[i]),
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
    description_text="Swim the first "+str(nr_terms)+" terms of the Recaman sequence. "
    
    # create the program
    simpleProgram=swiML.Program(
        title='Recaman Sequence',
        author=[('firstName','Christoph'),('lastName','Bartneck')],
        programDescription=description_text,
        poolLength='25',
        creationDate='2024-03-05',
        lengthUnit='meters',
        hideIntro=False,
        swiMLVersion='2.1',
        instructions=myInstructions
    )
    # write swiML XML to file
    swiML.writeXML('patterns/recaman/recaman-program.xml',simpleProgram)

# define the number of terms
nr_terms=10
# Initialize the sequence with the first term
seq = [0]
steps = []
# find the terms
find_recaman(nr_terms+2)
# write the swiML program
write_program()