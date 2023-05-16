import swiMLclasstest as swiML

instruction = [
    {'lengthAsDistance':1000},
    {'sinceStart':'PT1M35S'},
    {'staticIntensity':{'percentageHeartRate':80}},
    {'standardStroke':'freestyle'},
    None,
    False,
    [],
    'boopy doop'
]
instruction2 = [
    {'lengthAsDistance':200},
    {'sinceStart':'PT1M55S'},
    {'staticIntensity':{'percentageHeartRate':60}},
    {'standardStroke':'backstroke'},
    None,
    False,
    [],
    'boopy doopy doop'
]



program = swiML.Program(
    'Jasi Masters',
    ['Callum','Lockhart'],
    'Our Tuesday evening program in the sun. The target duration was 60 minutes.',
    '50',
    'meter',
    [swiML.Repetition(3,
                     'outer repetition',
            [
                swiML.Instruction(
                ('lengthAsDistance',200),
                ('sinceStart','PT1M55S'),
                ('staticIntensity',('percentageHeartRate',60)),
                ('standardStroke','backstroke'),
                None,
                False,
                [],
                'boopy doopy doop')
                ,
                swiML.Repetition(3,
                                'inner repetition',
                    [
                        swiML.Instruction(
                        ('lengthAsDistance',200),
                        ('sinceStart','PT1M55S'),
                        ('staticIntensity',('percentageHeartRate',60)),
                        ('standardStroke','backstroke'),
                        None,
                        False,
                        [],
                        'boopy doopy doop')
                        ,
                        swiML.Instruction(
                        ('lengthAsDistance',200),
                        ('sinceStart','PT1M55S'),
                        ('staticIntensity',('percentageHeartRate',60)),
                        ('standardStroke','backstroke'),
                        None,
                        False,
                        [],
                        'boopy doopy doop')
                    ]
                )
            ]
        )
    ]
)

program.toXml('sample.xml')
