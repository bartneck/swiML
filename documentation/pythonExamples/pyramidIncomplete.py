import sys
sys.path.insert(1, '/Users/callo/Documents/GitHub/swiML')
import swiML


pyramid = swiML.Pyramid(
    startLength=50,
    stopLength=200,
    increment=50,
    incrementLengthUnit='meters',
    isPointy=False
)

program=swiML.Program(
    title='Continue Examples',
    author=[('firstName','Callum'),('lastName','Lockhart')],
    programDescription='Examples of continues in swiML',
    poolLength = 25,
    lengthUnit= 'meters',
    programAlign=False,
    swiMLVersion=2.0,
    instructions=[pyramid]
)

print(program)