import swiML as swiML 


#some basic instructions with all the parameters set

instruction = swiML.Instruction(
    length=('lengthAsDistance',200),
    rest=('sinceStart','PT1M55S'),
    intensity=('startIntensity',('percentageHeartRate',60)),
    stroke=('standardStroke','freestyle'),
    # breath=None,
    # underwater=False,
    # equipment=[],
    # instructionDescription='Description'
)

#an instruction with no defined rest
noRestInstruction = swiML.Instruction(
    length=('lengthAsDistance',200),
    intensity=('startIntensity',('percentageHeartRate',60)),
    stroke=('standardStroke','backstroke'),
    breath=None,
    underwater=False,
    equipment=[],
    instructionDescription='Description'
)

#an instruction with no defined length
noLengthInstruction = swiML.Instruction(
    rest=('sinceStart','PT1M55S'),
    intensity=('startIntensity',('percentageHeartRate',60)),
    stroke=('standardStroke','backstroke'),
    breath=None,
    underwater=False,
    equipment=[],
    instructionDescription='Description'
)

#a second different instruction
instruction2 = swiML.Instruction(
    length=('lengthAsDistance',100),
    rest=('sinceStart','PT1M55S'),
    intensity=('startIntensity',('percentageHeartRate',60)),
    stroke=('drill',('singleArm','backstroke')),
    breath=None,
    underwater=False,
    equipment=[],
    instructionDescription='Description'
)


# a simplifying repetition with its containing instructions
repetition = swiML.Repetition(
    simplify=True,
    repetitionDescription='repetition test',
    instructions=[instruction,instruction]
)

#a continue containing repetitions
cont = swiML.Continue(
    instructions=[repetition,repetition]
)


# a program with all the parameters containing a continue and a repetition
program = swiML.Program(
    title='Jasi Masters',
    author=[('firstName','Callum'),('lastName','Lockhart')],
    programDescription='Our Tuesday evening program in the sun. The target duration was 60 minutes.',
    poolLength='50',
    lengthUnit='meters',
    instructions=[swiML.Continue(
    instructions = [swiML.Repetition(repetitionCount=4,repetitionDescription='nothing',instructions=[instruction,instruction]),swiML.Repetition(repetitionCount=4,repetitionDescription='nothing',instructions=[instruction,instruction]),swiML.Repetition(repetitionCount=4,repetitionDescription='nothing',instructions=[instruction,instruction])]
    ),
    swiML.Repetition(repetitionCount=4,repetitionDescription='nothing',instructions=[instruction2,instruction])
    ])

#display program in terminal
print(program)

#example for reading and writing to an xml document 
#writing will out put the given program or any given class in xml to the given file
swiML.writeXML('cb01.xml',program)