import swiML 

instruction = swiML.Instruction(
    length=('lengthAsDistance',200),
    rest=('sinceStart','PT1M55S'),
    intensity=('startIntensity',('percentageHeartRate',60)),
    stroke=('standardStroke','backstroke'),
    breath=None,
    underwater=False,
    equipment=[],
    instructionDescription='boopy doopy doop'
)
instruction2 = swiML.Instruction(
    length=('lengthAsDistance',100),
    rest=('sinceStart','PT1M55S'),
    intensity=('startIntensity',('percentageHeartRate',60)),
    stroke=('standardStroke','backstroke'),
    breath=None,
    underwater=False,
    equipment=[],
    instructionDescription='boopy doopy doop'
)

program = swiML.Program(
    title='Jasi Masters',
    author=[('firstName','Callum'),('lastName','Lockhart')],
    programDescription='Our Tuesday evening program in the sun. The target duration was 60 minutes.',
    poolLength='50',
    lengthUnit='meters',
    instructions=[swiML.Continue( simplify = True,
    instructions = [swiML.Repetition(repetitionCount=4,repetitionDescription='nothing',instructions=[instruction,instruction]),swiML.Repetition(repetitionCount=4,repetitionDescription='nothing',instructions=[instruction,instruction])]
    ),
    swiML.Repetition(repetitionCount=4,repetitionDescription='nothing',instructions=[instruction,instruction])
    ]
)
program2 = swiML.Program(
    'not fun',
    [('firstName','Callum'),('lastName','Lockhart')],
    'wednesday morning swim',
    '20',
    'meters',
    [instruction]
)
    

program = swiML.readXML('pythonXMLtest/sample.xml')
print(program)
