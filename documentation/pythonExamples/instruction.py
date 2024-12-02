import sys
sys.path.insert(1, '/Users/callo/Documents/GitHub/swiML')
import swiML


Inst0=swiML.Instruction(
    length=('lengthAsDistance',400),
    stroke=('standardStroke','any'),
    intensity=('startIntensity',('zone','easy')),
)

Inst1 = swiML.Instruction(
    length=('lengthAsDistance',25),
    stroke=('standardStroke','freestyle'),
    intensity=('startIntensity',('zone','max')),
    rest=('sinceStart','PT0M45S'),
    equipment=('pullBuoy')
)

Inst2 = swiML.Instruction(
    length=('lengthAsDistance',50),
    stroke=('kicking',('standardKick','freestyle')),
    intensity=('startIntensity',('zone','max')),
    rest=('sinceStart','PT0M55S'),
    underwater=True
)

Inst3 = swiML.Instruction(
    length=('lengthAsDistance',200),
    stroke=('drill',('6KickDrill','freestyle'))
)

Inst4 = swiML.Instruction(
    length=('lengthAsDistance',100),
    rest=('afterStop','PT0M20S'),
    stroke=('standardStroke','freestyle'),
    breath=3,
    instructionDescription='100 fr breathing every 3rd stroke',
    excludeAlign=True
)

program=swiML.Program(
    title = 'Continue Examples',
    author = [('firstName','Callum'),('lastName','Lockhart')],
    programDescription = 'Examples of continues in swiML',
    poolLength = 25,
    lengthUnit = 'meters',
    programAlign = False,
    swiMLVersion = 2.0,
    instructions = [Inst0,Inst1,Inst2,Inst3,Inst4]
)

print(program)