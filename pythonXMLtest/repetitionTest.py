import swiML

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

oneSet2=swiML.Repetition(
    repetitionCount=2,
    instructions=[oneSet2Continue]
)

oneSet3=swiML.Instruction(
    length=('lengthAsDistance',150),
    stroke=('standardStroke','any')
)

oneSet=swiML.Repetition(
    simplify=True,
    rest=('afterStop','PT0M15S'),
    instructions=[
        oneSet1,
        oneSet2,
        oneSet3
    ]
)

simpleProgram=swiML.Program(
    title='Jasi Masters',
    author=[('firstName','Christoph'),('lastName','Bartneck')],
    programDescription='Our Tuesday evening program targeted at one hour. The coach was Matt.',
    poolLength='25',
    lengthUnit='meters',
    swiMLVersion='2.0',
    creationDate='2024-02-25',
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
swiML.writeXML('JasiMasters2024022501.xml',simpleProgram)