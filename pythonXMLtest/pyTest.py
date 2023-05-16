import swiML as swiML

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
    [swiML.Repetition(3,
                     'outer repetition',
            [
                instruction
                ,
                swiML.Continue(
                    [
                        instruction,instruction
                    ]
                )
            ]
        )
    ]
)
print(program)
program.toXml('sample.xml')
