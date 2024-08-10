import swiML as swiML

def simple_loop():
    instruction_list=[]
    for i in range (nr_loops):
        instruction_list.append(swiML.Instruction(
                length=('lengthAsDistance',25),
                stroke=('standardStroke','butterfly'),
        ))
    return instruction_list
        
def pyramid_loop():
    instruction_list=[]
    for i in range(nr_loops):
        instruction_list.append(swiML.Instruction(
                length=('lengthAsDistance',(i+1)*25),
                stroke=('standardStroke','notFreestyle'),
        ))
        instruction_list.append(swiML.Instruction(
                length=('lengthAsDistance',(nr_loops-i)*25),
                stroke=('standardStroke','freestyle'),
        ))
    return instruction_list

def nested_loop():
    instruction_list=[]
    for i in range(nr_inner_loops):
        instruction_list.append(swiML.Instruction(
                length=('lengthAsDistance',(i+1)*25),
                stroke=('standardStroke','freestyle'),
        ))
        for j in range(i+1):
            instruction_list.append(swiML.Instruction(
                length=('lengthAsDistance',100),
                stroke=('standardStroke','backstroke'),
        ))
    return instruction_list

#writing the swiML program to disk
def write_program():

    # assembly of the main instructions
    myInstructions=[swiML.SegmentName('Simple Loop')]
    myInstructions.extend(simple_loop())
    myInstructions.append(swiML.SegmentName('Double Loop'))
    myInstructions.extend(pyramid_loop())
    myInstructions.append(swiML.SegmentName('Nested Loop'))
    myInstructions.extend(nested_loop())
    
    # create the program
    simpleProgram=swiML.Program(
        title='Loops',
        author=[('firstName','Christoph'),('lastName','Bartneck')],
        programDescription='A program that showcases the loop function.',
        poolLength='25',
        creationDate='2024-08-10',
        lengthUnit='meters',
        hideIntro=True,
        swiMLVersion='main',
        instructions=myInstructions
    )
    # write swiML XML to file
    swiML.writeXML('patterns/loops/loops-program.xml',simpleProgram)

# define the number iterations for the loops
nr_loops=4
nr_inner_loops=3
# write the swiML program
write_program()