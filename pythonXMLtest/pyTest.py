import swiML 

instruction = swiML.Instruction(
    ('lengthAsDistance',200),
    ('sinceStart','PT1M55S'),
    ('staticIntensity',('percentageHeartRate',60)),
    ('standardStroke','backstroke'),
    None,
    False,
    [],
    'boopy doopy doop'
)
instruction2 = swiML.Instruction(
    ('lengthAsDistance',100),
    ('sinceStart','PT1M55S'),
    ('staticIntensity',('percentageHeartRate',60)),
    ('standardStroke','backstroke'),
    None,
    False,
    [],
    'boopy doopy doop'
)

program = swiML.Program(
    'Jasi Masters',
    ['Callum','Lockhart'],
    'Our Tuesday evening program in the sun. The target duration was 60 minutes.',
    '50',
    'meter',
    [swiML.Continue( simplify = True,
    children = [swiML.Repetition(4,'nothing',[instruction]),swiML.Repetition(4,'nothing',[instruction])]
    ),
    swiML.Repetition(4,'nothing',[instruction,instruction])
    ]
)
    

print(program)
#program.toXml('sample.xml')