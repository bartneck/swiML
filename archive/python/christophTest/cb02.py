import swiML as swiML 

simple100=swiML.Instruction(
    length=('lengthAsDistance',100),
    stroke=('standardStroke','freestyle')
)

simple200=swiML.Instruction(
    length=('lengthAsDistance',200),
    stroke=('standardStroke','freestyle')
)

simpleProgram=swiML.Program(
    title='Jasi Masters',
    author=[('firstName','Christoph'),('lastName','Bartneck')],
    programDescription='My first Python swiML Program',
    poolLength='50',
    lengthUnit='meters',
    instructions=[simple100,
                  swiML.Repetition(repetitionCount=4,instructions=[simple200]),
                  swiML.Instruction(
                      length=('lengthAsDistance',100),
                      stroke=('standardStroke','butterfly')
                  )]
)

print(simpleProgram)
swiML.writeXML('cb02.xml',simpleProgram)