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
    length=('lengthAsDistance',25),
    stroke=('standardStroke','freestyle'),
    rest=('sinceStart','PT0M60S'),
    intensity=('startIntensity',('zone','max'))
)

oneSet=swiML.Repetition(
    repetitionCount=2,
    instructions=[oneSet1]
)

twoSet1=swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('standardStroke','freestyle'),
)

twoSet2Rep=swiML.Repetition(
    repetitionCount=2,
    instructions=[swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('kicking',('standardKick','any')),
    )]
)

twoSet3Rep=swiML.Repetition(
    repetitionCount=2,
    instructions=[swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('standardStroke','any'),
    equipment=('pullBuoy')
    )]
)

twoSet4=swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('standardStroke','any'),
)

twoSet5Rep=swiML.Repetition(
    repetitionCount=2,
    instructions=[swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('drill',('any','any')),
    )]
)

twoSet6Rep=swiML.Repetition(
    repetitionCount=2,
    instructions=[swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('standardStroke','any'),
    )]
)

twoSet=swiML.Repetition(
    simplify=True,
    instructions=[twoSet1,twoSet2Rep,twoSet3Rep,twoSet4,twoSet5Rep,twoSet6Rep]
)

threeSet1=swiML.Instruction(
    length=('lengthAsDistance',25),
    stroke=('kicking',('standardKick','any')),
    rest=('sinceStart','PT0M60S'),
    intensity=('startIntensity',('zone','max'))
)

threeSet=swiML.Repetition(
    repetitionCount=2,
    instructions=[threeSet1]
)

fourSet1=swiML.Instruction(
    length=('lengthAsDistance',75),
    stroke=('standardStroke','freestyle'),
    rest=('afterStop','PT0M15S')
)

fourSet2=swiML.Instruction(
    length=('lengthAsDistance',75),
    stroke=('standardStroke','individualMedleyOverlap'),
    rest=('afterStop','PT0M15S')
)

fourSet=swiML.Repetition(
    repetitionCount=4,
    instructions=[fourSet1,fourSet2]
)


fourHalfSet1=swiML.Instruction(
    length=('lengthAsDistance',25),
    stroke=('standardStroke','freestyle'),
    rest=('sinceStart','PT0M60S'),
    intensity=('startIntensity',('zone','max')),
    equipment=('pullBuoy')
)

fourHalfSet=swiML.Repetition(
    repetitionCount=2,
    instructions=[fourHalfSet1]
)

fiveSet1=swiML.Instruction(
    length=('lengthAsDistance',100),
    stroke=('standardStroke','freestyle'),
    rest=('afterStop','PT0M15S')
)

fiveSet2=swiML.Instruction(
    length=('lengthAsDistance',100),
    stroke=('standardStroke','individualMedley'),
    rest=('afterStop','PT0M15S')
)

fiveSet=swiML.Repetition(
    repetitionCount=4,
    instructions=[fiveSet1,fiveSet2]
)

sixSet1=swiML.Instruction(
    length=('lengthAsDistance',200),
    stroke=('standardStroke','freestyle'),
)
sixSet2=swiML.Instruction(
    length=('lengthAsDistance',200),
    stroke=('standardStroke','notFreestyle'),    
)

sixSetRep=swiML.Repetition(
    simplify=True,
    equipment=('fins'),
    rest=('afterStop','PT0M30S'),
    instructions=[sixSet1,sixSet2]
)

sevenSet1=swiML.Instruction(
    length=('lengthAsDistance',25),
    stroke=('standardStroke','freestyle'),
    rest=('sinceStart','PT0M60S'),
    intensity=('startIntensity',('zone','max')),
)

sevenSetRep=swiML.Repetition(
    repetitionCount=2,
    instructions=[sevenSet1]
)

simpleProgram=swiML.Program(
    title='Jasi Masters',
    author=[('firstName','Christoph'),('lastName','Bartneck')],
    programDescription='Our Tuesday evening program targeted at one hour.',
    pool=[('poolLength',25),('lengthUnit','meters')],
    #swiMLVersion='2.0',
    creationDate='2024-03-05',
    instructions=[warmUpSegment,
                  warmUp,
                  firstSegment,
                  oneSet,
                  twoSet,
                threeSet,
                fourSet,
                fourHalfSet,
                fiveSet,
                threeSet,
                sixSetRep,
                sevenSetRep,
                warmUp
                  ]
)

print(simpleProgram)
swiML.writeXML('JasiMasters2024030501.xml',simpleProgram)