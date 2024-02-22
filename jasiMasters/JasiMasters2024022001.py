# import sys
 
# # setting path
# sys.path.append('../swiML')

# from pythonXMLtest.swiML import swiML 

import swiML 

warmUp=swiML.Instruction(
    length=('lengthAsDistance',400),
    stroke=('standardStroke','any'),
    intensity=('startIntensity',('zone','easy')),
)

oneSet1=swiML.Continue(
    instructions=[
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('drill',('any','any'))
        ),
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('standardStroke','any')
        )
    ]
)
oneSet2=swiML.Continue(
    instructions=[
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('standardStroke','any')
        ),
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('kickin',('standardKick','any'))
        )        
    ]
)
oneSet3=swiML.Continue(
    instructions=[
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('drill',('any','any'))
        ),
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('standardStroke','any'),
            equipment=('pullBuoy')
        )
    ]
)

oneSet=swiML.Repetition(
    repetitionCount=3,
    simplify=False,
    instructions=[
        oneSet1,
        oneSet2,
        oneSet3
    ]
)

twoSet=swiML.Repetition(
    repetitionCount=6,
    instructions=[swiML.Instruction(
        length=('lengthAsDistance',25),
        stroke=('kickin',('standardKick','freestyle')),
        intensity=('startIntensity',('zone','max')),
        rest=('sinceStart','PT0M45S')
        )
    ]
)

threeSet=swiML.Repetition(
    repetitionCount=3,
    instructions=[
        swiML.Instruction(
            length=('lengthAsDistance',200),
            stroke=('standardStroke','freestyle'),
            rest=('sinceStart','PT3M10S'),
            equipment=('pullBuoy','pads')
        )
    ]
)

fourSet=swiML.Repetition(
    repetitionCount=6,
    instructions=[swiML.Instruction(
        length=('lengthAsDistance',25),
        stroke=('standardStroke','freestyle'),
        intensity=('startIntensity',('zone','max')),
        rest=('sinceStart','PT0M45S'),
        equipment=('pullBuoy')
        )
    ]
)


fiveSet=swiML.Instruction(
    length=('lengthAsDistance',400),
    stroke=('kickin',('standardKick','any')),
    equipment=('fins')
)

sixSet=swiML.Repetition(
    repetitionCount=4,
    instructions=[swiML.Instruction(
        length=('lengthAsDistance',25),
        stroke=('standardStroke','freestyle'),
        intensity=('startIntensity',('zone','max')),
        rest=('sinceStart','PT0M45S')
        )
    ]
)

sevenSet=swiML.Instruction(
    length=('lengthAsDistance',200),
    stroke=('standardStroke','any')
)

eightSet=swiML.Repetition(
    repetitionCount=4,
    instructions=[swiML.Instruction(
        length=('lengthAsDistance',25),
        stroke=('standardStroke','individualMedleyOrder'),
        intensity=('startIntensity',('zone','max')),
        rest=('sinceStart','PT0M50S')
        )
    ]
)

warmDown=swiML.Instruction(
    length=('lengthAsDistance',100),
    stroke=('standardStroke','any'),
    intensity=('startIntensity',('zone','easy')),
)


simpleProgram=swiML.Program(
    title='Jasi Masters',
    author=[('firstName','Christoph'),('lastName','Bartneck')],
    programDescription='Our Tuesday evening program targeted at one hour. The coach was Matt.',
    poolLength='25',
    lengthUnit='meters',
    instructions=[warmUp,
                  oneSet,
                  twoSet,
                  threeSet,
                  fourSet,
                  fiveSet,
                  sixSet,
                  sevenSet,
                  eightSet,
                  warmDown
                  ]
)

print(simpleProgram)
swiML.writeXML('JasiMasters2024022001.xml',simpleProgram)