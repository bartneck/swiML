

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
            length=('lengthAsDistance',50),
            stroke=('standardStroke','any')
        ),
        swiML.Instruction(
            length=('lengthAsDistance',50),
            stroke=('standardStroke','any')
        ),
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('kicking',('standardKick','any'))
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
    simplify=True,
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
        stroke=('kicking',('standardKick','freestyle')),
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
            equipment=('pads','pullBuoy')
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
    stroke=('kicking',('standardKick','any')),
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
    swiMLVersion=2.0,
    instructions=[swiML.SegmentName('Warm Up'),
                    
                    oneSet
                  ]
)

print(simpleProgram)
swiML.writeXML('pythonXMLtest\sample.xml',simpleProgram)