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


program = swiML.Program(
    'Jasi Masters',
    ['Callum','Lockhart'],
    'Our Tuesday evening program in the sun. The target duration was 60 minutes.',
    '50',
    'meter',
    [swiML.Pyramid(
    25,100,25,'meters',[
    swiML.Instruction(
    rest=('sinceStart','PT1M55S'),
    stroke=('standardStroke','freestyle')
    )]
    ),
    swiML.Repetition(4,'nothing',[instruction,instruction,swiML.Pyramid(
    25,100,25,'meters',[
    swiML.Instruction(
    rest=('sinceStart','PT1M55S'),
    stroke=('standardStroke','freestyle')
    )]
    )])
    ]
)
    

print(program)