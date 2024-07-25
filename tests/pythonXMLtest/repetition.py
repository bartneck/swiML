import sys
sys.path.insert(1, '/Users/callo/Documents/GitHub/swiML')
import swiML

rep0=swiML.Repetition(
    repetitionCount=3,
    instructions=[
        swiML.Instruction(
            length=('lengthAsDistance',25),
            stroke=('standardStroke','freestyle')
        ),
        swiML.Instruction(
            length=('lengthAsDistance',25),
            stroke=('standardStroke','backstroke')
        )
    ]
)

rep1=swiML.Repetition(
    repetitionCount=4,
    instructions=[swiML.Instruction(
        length=('lengthAsDistance',25),
        stroke=('standardStroke','freestyle'),
        intensity=('startIntensity',('zone','max')),
        rest=('sinceStart','PT0M45S')
        )
    ]
)

rep2=swiML.Repetition(
    simplify=True,
    instructions=[
        swiML.Instruction(
            length=('lengthAsDistance',25),
            stroke=('standardStroke','freestyle')
        ),
        swiML.Instruction(
            length=('lengthAsDistance',25),
            stroke=('standardStroke','backstroke')
        )
    ]
)

rep3=swiML.Repetition(
    simplify=True,
    instructions=[
        swiML.Repetition(
            repetitionCount=4,
            instructions=[swiML.Instruction(
                length=('lengthAsDistance',25),
                stroke=('standardStroke','freestyle'),
                intensity=('startIntensity',('zone','max')),
                rest=('sinceStart','PT0M45S')
                )
            ]
        ),
        swiML.Repetition(
            repetitionCount=8,
            instructions=[swiML.Instruction(
                length=('lengthAsDistance',25),
                stroke=('standardStroke','backstroke'),
                intensity=('startIntensity',('zone','max')),
                rest=('sinceStart','PT0M45S')
                )
            ]
        )
    ]
)

rep4=swiML.Repetition(
    repetitionCount=3,
    simplify=True,
    instructions=[
        swiML.Instruction(
            length=('lengthAsDistance',25),
            stroke=('standardStroke','freestyle')
        ),
        swiML.Instruction(
            length=('lengthAsDistance',25),
            stroke=('standardStroke','backstroke')
        )
    ]
)

program=swiML.Program(
    title='Continue Examples',
    author=[('firstName','Callum'),('lastName','Lockhart')],
    programDescription='Examples of continues in swiML',
    poolLength = 25,
    lengthUnit= 'meters',
    programAlign=False,
    swiMLVersion=2.0,
    instructions=[rep0,rep1,rep2,rep3,rep4]
)

print(program)