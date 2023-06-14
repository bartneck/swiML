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
    children=[swiML.Continue( simplify = True,
    children = [swiML.Repetition(4,'nothing',[instruction]),swiML.Repetition(4,'nothing',[instruction])]
    ),
    swiML.Repetition(repetitionCount=4,repetitionDescription='nothing',children=[instruction,instruction])
    ]
)
program2 = swiML.Program(
    'not fun',
    ['callum','lockhart'],
    'wednesday morning swim',
    '20',
    'meters',
    [instruction]
)
    

swiML.readXML('sample.xml')