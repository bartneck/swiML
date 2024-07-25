import swiML as swiML
myProgram=[]

# simple instruction
warmUp=swiML.Instruction(
    length=('lengthAsDistance',100),
    stroke=('standardStroke','freestyle'),
    intensity=('startIntensity',('zone','easy')),
)

myProgram.append(warmUp)

#writing the swiML program to disk
def write_program():
    # create the program
    simpleProgram=swiML.Program(
        title='My First Python swiML Program',
        author=[('firstName','Christoph'),('lastName','Bartneck')],
        programDescription='This is a small program to demonstrate how to create a swiML program in Python.',
        poolLength='25',
        creationDate='2024-05-20',
        lengthUnit='meters',
        swiMLVersion='2.1',
        hideIntro=False,
        instructions=myProgram
    )
    # write swiML XML to file
    swiML.writeXML('my_first_swiML_program_xxx.xml',simpleProgram)

# write the swiML program
write_program()