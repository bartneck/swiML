import swiML

warmUp=swiML.Instruction(
    length=('lengthAsDistance',400),
    stroke=('standardStroke','any'),
    intensity=('startIntensity',('zone','easy')),
)

warmUpSegment=swiML.SegmentName('WarmUp')

oneSet1=swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('standardStroke','freestyle')
)

oneSet2=swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('drill',('singleArm','butterfly'))
)

oneSet3=swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('standardStroke','backstroke')
)

oneSet4=swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('standardStroke','breaststroke')
)

oneSet=swiML.Continue(
    equipment=('fins','pads'),
    instructions=[oneSet1,oneSet2,oneSet1,oneSet3,oneSet1,oneSet4]
)

twoSet1=swiML.Instruction(
    length=('lengthAsDistance',100),
    stroke=('standardStroke','freestyle'),
    rest=('afterStop','PT0M15S'),
)

twoSet2=swiML.Instruction(
    length=('lengthAsDistance',200),
    stroke=('standardStroke','freestyle'),
    rest=('afterStop','PT0M30S')
)

twoSet3=swiML.Instruction(
    length=('lengthAsDistance',300),
    stroke=('standardStroke','freestyle'),
    rest=('afterStop','PT0M30S'),
    intensity=('startIntensity',('zone','easy'),'stopIntensity',('zone','max')),
)

simpleProgram=swiML.Program(
    title='Jasi Masters',
    author=[('firstName','Christoph'),('lastName','Bartneck')],
    programDescription='Our sunday evening program targeted at one hour.',
    poolLength='50',
    lengthUnit='meters',
    swiMLVersion='2.0',
    creationDate='2024-03-10',
    instructions=[warmUpSegment,
                  warmUp,
                  oneSet,
                  twoSet1,
                  twoSet2,
                  twoSet3
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
swiML.writeXML('JasiMasters2024031001.xml',simpleProgram)