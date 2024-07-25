

import swiML as swiML
'''
warmUp=swiML.Instruction(
    length=('lengthAsDistance',400),
    stroke=('standardStroke','any'),
    intensity=('startIntensity',('zone','easy')),
)

oneSet1=swiML.Continue(
    continueLength=('lengthAsDistance',400),
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
    continueLength=('lengthAsDistance',400),
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
    continueLength=('lengthAsDistance',400),
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
    length=('lengthAsDistance',200),
    stroke=('standardStroke','any'),
    intensity=('startIntensity',('zone','easy')),
)


simpleProgram=swiML.Program(
    title='Jasi Masters',
    author=[('firstName','Christoph'),('lastName','Bartneck')],
    programDescription='Our Tuesday evening program targeted at one hour. The coach was Matt.',
    pool=[('poolLength',25),('lengthUnit','meters')],
    programAlign=False,
    swiMLVersion=2.0,
    instructions=[swiML.SegmentName('Warm Up'),
                    
                    oneSet,twoSet,threeSet,fourSet,fiveSet,sixSet,sevenSet,eightSet,warmDown
                  ]
)

print(simpleProgram)
swiML.writeXML('pythonXMLtest/sample.xml',simpleProgram)'''

warmUp=swiML.Instruction(
    length=('lengthAsDistance',400),
    stroke=('standardStroke','any'),
    intensity=('startIntensity',('zone','easy')),
)

warmUpSegment=swiML.SegmentName('WarmUp')

oneSet1=swiML.Instruction(
    length=('lengthAsDistance',150),
    stroke=('kicking',('standardKick','any'))
)

oneSet2Continue=swiML.Repetition(
    repetitionCount=3,
    instructions=[
        swiML.Instruction(
            length=('lengthAsDistance',25),
            stroke=('drill',('6KickDrill','freestyle'))
        ),
        swiML.Instruction(
            length=('lengthAsDistance',25),
            stroke=('drill',('singleArm','butterfly'))
        )
    ]
)

oneSet2=swiML.Continue(
    continueLength=('lengthAsDistance',150),
    instructions=[oneSet2Continue]
)
# oneSet2=swiML.Continue(
#     instructions=[oneSet2Continue,oneSet2Continue,oneSet2Continue]
# )

oneSet3=swiML.Instruction(
    length=('lengthAsDistance',150),
    stroke=('standardStroke','any')
)

oneSet=swiML.Repetition(
    simplify=True,
    equipment=('fins'),
    rest=('afterStop','PT0M15S'),
    instructions=[
        oneSet1,
        oneSet2,
        oneSet3
    ]
)

twoSet1One=swiML.Instruction(
    length=('lengthAsDistance',25),
    breath=3
)
twoSet1Two=swiML.Instruction(
    length=('lengthAsDistance',25),
    breath=5
)

twoSet1=swiML.Repetition(
    repetitionCount=2,
    instructions=[swiML.Continue(instructions=[twoSet1One,twoSet1Two])]
)

twoSet2One=swiML.Instruction(
    length=('lengthAsDistance',25),
    breath=3
)
twoSet2Two=swiML.Instruction(
    length=('lengthAsDistance',25),
    breath=7
)

twoSet2=swiML.Repetition(
    repetitionCount=2,
    instructions=[swiML.Continue(
        instructions=[twoSet1One,twoSet1Two]
    )
    ]
)

twoSet3One=swiML.Instruction(
    length=('lengthAsDistance',25),
    breath=3
)
twoSet3Two=swiML.Instruction(
    length=('lengthAsDistance',25),
    breath=5
)
twoSet3Three=swiML.Instruction(
    length=('lengthAsDistance',25),
    breath=7
)
twoSet3Four=swiML.Instruction(
    length=('lengthAsDistance',25),
    breath=3
)

twoSet3=swiML.Continue(
    instructions=[
        twoSet3One,
        twoSet3Two,
        twoSet3Three,
        twoSet3Four
    ]
)


twoSet=swiML.Repetition(
    simplify=False,
    equipment=('pullboy'),
    rest=('afterStop','PT0M15S'),
    stroke=('standardStroke','freestyle'),
    instructions=[
        twoSet1,
        twoSet2,
        twoSet3
    ]
)

simpleProgram=swiML.Program(
    title='Jasi Masters',
    author=[('firstName','Christoph'),('lastName','Bartneck')],
    programDescription='Our Tuesday evening program targeted at one hour. The coach was Matt.',
    poolLength=25,
    lengthUnit='meters',
    # swiMLVersion='2.0',
    creationDate='2024-02-25',
    instructions=[#warmUpSegment,
                #  warmUp,
                #  oneSet,
                #   twoSet,
                #   threeSet,
                #   fourSet,
                #   fiveSet,
                #   sixSet,
                #   sevenSet,
                #   eightSet,
                #   warmDown
                swiML.Instruction(
                    length=('lengthAsDistance',25),
                    stroke=('standardStroke','freestyle')
                ),swiML.Instruction(
                    length=('lengthAsDistance',25),
                    stroke=('standardStroke','freestyle'),
                    excludeAlign=True
                )
                  ]
)

print(simpleProgram)
swiML.writeXML('pythonXMLtest/sample.xml',simpleProgram)