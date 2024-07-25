import swiML as swiML

warmUp=swiML.Instruction(
    length=('lengthAsDistance',400),
    stroke=('standardStroke','any'),
    intensity=('startIntensity',('zone','easy')),
)

warmUpSegment=swiML.SegmentName('WarmUp')

oneSet1=swiML.Instruction(
    length=('lengthAsDistance',150),
    stroke=('drill',('any','any'))
)

oneSet2Continue=swiML.Continue(
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
    instructions=[oneSet2Continue,oneSet2Continue,oneSet2Continue]
)

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
    poolLength='25',
    creationDate='2024-03-01',
    lengthUnit='meters',
    swiMLVersion='2.0',
    instructions=[warmUpSegment,
                  warmUp,
                  oneSet,
                #   twoSet,
                #   threeSet,
                #   fourSet,
                #   fiveSet,
                #   sixSet,
                #   sevenSet,
                #   eightSet,
                #   warmDown
                  ]
)

print(simpleProgram)
swiML.writeXML('JasiMasters2024022501-dateTest.xml',simpleProgram)
