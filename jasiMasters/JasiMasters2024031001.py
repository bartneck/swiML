import swiML

warmUp=swiML.Instruction(
    length=('lengthAsDistance',400),
    stroke=('standardStroke','any'),
    intensity=('startIntensity',('zone','easy')),
)

warmUpSegment=swiML.SegmentName('Warm Up')
firstSegment=swiML.SegmentName('First set')
secondSegment=swiML.SegmentName('Second set')

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
    rest=('afterStop','PT0M45S'),
    intensity=('startIntensity',('zone','easy')),
    intensity=('stopIntensity',('zone','max'))
)

twoSet4=swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('standardStroke','freestyle'),
    rest=('afterStop','PT0M30S'),
    intensity=('startIntensity',('zone','max')),
)
twoSet5=swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('kicking',('standardKick','any')),
    rest=('afterStop','PT0M30S')
)

threeSet1=swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('standardStroke','any'),
    rest=('afterStop','PT0M30S'),
    equipment=('pullBuoy','pads')
)
threeSet2=swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('standardStroke','freestyle'),
    rest=('afterStop','PT0M60S'),
    intensity=('startIntensity',('zone','max')),
    equipment=('pullBuoy','pads')
)

threeSet3=swiML.Instruction(
    length=('lengthAsDistance',100),
    stroke=('standardStroke','freestyle'),
    rest=('afterStop','PT0M15S'),
    equipment=('pullBuoy','pads')
)

threeSet4=swiML.Instruction(
    length=('lengthAsDistance',200),
    stroke=('standardStroke','freestyle'),
    rest=('afterStop','PT0M30S'),
    equipment=('pullBuoy','pads')
)

threeSet5=swiML.Instruction(
    length=('lengthAsDistance',300),
    stroke=('standardStroke','freestyle'),
    rest=('afterStop','PT0M45S'),
    equipment=('pullBuoy','pads'),
    intensity=('startIntensity',('zone','easy'),'stopIntensity',('zone','max')),
)

fourSet1=swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('standardStroke','notFreestyle'),
    rest=('sinceStart','PT0M65S'),
)

fourSet=swiML.Repetition(
    repetitionCount=6,
    instructions=[fourSet1]

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
                  firstSegment,
                  twoSet1,
                  twoSet2,
                  twoSet3,
                  twoSet2,
                  twoSet1,
                  twoSet4,
                  twoSet5,
                  secondSegment,
                  threeSet1,
                  threeSet2,
                  threeSet3,
                  threeSet4,
                  threeSet5,
                  threeSet4,
                  threeSet3,
                  fourSet
                  ]
)

print(simpleProgram)
swiML.writeXML('JasiMasters2024031001.xml',simpleProgram)