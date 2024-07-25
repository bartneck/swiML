import sys
sys.path.insert(1, '/Users/callo/Documents/GitHub/swiML')
import swiML


seg0 = swiML.SegmentName(
    segmentName='Start'
)

Inst0=swiML.Instruction(
    length=('lengthAsDistance',25),
    stroke=('standardStroke','any'),
)

seg1 = swiML.SegmentName(
    segmentName='Middle'
)

Inst1=swiML.Instruction(
    length=('lengthAsDistance',25),
    stroke=('standardStroke','any'),
)

seg2 = swiML.SegmentName(
    segmentName='End'
)

program=swiML.Program(
    title='Continue Examples',
    author=[('firstName','Callum'),('lastName','Lockhart')],
    programDescription='Examples of continues in swiML',
    poolLength = 25,
    lengthUnit= 'meters',
    programAlign=False,
    swiMLVersion=2.0,
    instructions=[seg0,Inst0,seg1,Inst1,seg2]
)

print(program)