import swiML 

instruction = swiML.Instruction(
    length=('lengthAsDistance',200),
    rest=('sinceStart','PT1M55S'),
    intensity=('startIntensity',('percentageHeartRate',60)),
    stroke=('standardStroke','backstroke'),
    breath=None,
    underwater=False,
    equipment=[],
    instructionDescription='boopy doopy doop'
)
noLengthInstruction = swiML.Instruction(
    rest=('sinceStart','PT1M55S'),
    intensity=('startIntensity',('percentageHeartRate',60)),
    stroke=('standardStroke','backstroke'),
    breath=None,
    underwater=False,
    equipment=[],
    instructionDescription='boopy doopy doop'
)
instruction2 = swiML.Instruction(
    length=('lengthAsDistance',100),
    rest=('sinceStart','PT1M55S'),
    intensity=('startIntensity',('percentageHeartRate',60)),
    stroke=('standardStroke','backstroke'),
    breath=None,
    underwater=False,
    equipment=[],
    instructionDescription='boopy doopy doop'
)

repetition = swiML.Repetition(
    repetitionCount=4,
    repetitionDescription='repetition test',
    length=('lengthAsDistance',100),
    instructions=[instruction,instruction]
)

cont = swiML.Continue(
    simplify=True,
    instructions=[repetition]
)

#print(cont)
#print(repetition)
