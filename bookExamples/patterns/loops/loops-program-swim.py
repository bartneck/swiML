import swiML as swiML

def nested_loop():
    instruction_list=[]
    for i in range(nr_inner_loops):
        instruction_list.append(swiML.Instruction(
                length=('lengthAsDistance',(i+1)*25),
                stroke=('standardStroke','breaststroke'),
                rest=('afterStop',"PT0M15S"),
                breath=i+1
            ))
        for j in range(i+1):
            instruction_list.append(swiML.Instruction(
                length=('lengthAsDistance',100),
                stroke=('standardStroke','freestyle'),
                rest=('sinceStart',"PT1M"+str((40+(j*5)))+"S"),
                intensity=('startIntensity',('percentageEffort',(100-(10*nr_inner_loops))+(j*10)))
            ))
            instruction_list.append(swiML.Instruction(
                length=('lengthAsDistance',(j+1)*25),
                stroke=('standardStroke','backstroke'),
                rest=('sinceStart',"PT0M"+str((j+1)*35)+"S")
            ))
    return instruction_list

#writing the swiML program to disk
def write_program():

    # assembly of the main instructions
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
    # assembly of the main instructions
    myInstructions=[swiML.SegmentName('Warm Up'),warmUp]
    myInstructions.append(swiML.SegmentName('Nested Loop'))
    myInstructions.extend(nested_loop())
    myInstructions.extend([swiML.SegmentName('Warm down'),warmDown])
    
    # create the program
    simpleProgram=swiML.Program(
        title='Nested Loops',
        author=[('firstName','Christoph'),('lastName','Bartneck')],
        programDescription='A program that showcases nested loops.',
        poolLength='25',
        creationDate='2024-08-10',
        lengthUnit='meters',
        hideIntro=False,
        swiMLVersion='main',
        instructions=myInstructions
    )
    # write swiML XML to file
    swiML.writeXML('loops-program-swim.xml',simpleProgram)

# define the number iterations for the loops
nr_loops=4
nr_inner_loops=4
# write the swiML program
write_program()