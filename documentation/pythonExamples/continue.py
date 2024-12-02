import swiMLTest as swiML



continue0=swiML.Continue(
    instructions=[
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('standardStroke','butterfly')
        ),
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('standardStroke','breaststroke')
        )
    ]
)

continue1=swiML.Continue(
    continueLength=('lengthAsDistance',400),
    instructions=[
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('drill',('any','any'))
        ),
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('standardStroke','any')
        )
    ]
)


continue2=swiML.Continue(
    continueLength=('lengthAsDistance',400),
    instructions=[
        swiML.Instruction(
            length=('lengthAsDistance',50),
            stroke=('standardStroke','freestyle')
        ),
        swiML.Instruction(
            length=('lengthAsDistance',50),
            stroke=('standardStroke','backstroke')
        ),
        swiML.Instruction(
            length=('lengthAsDistance',100),
            stroke=('kicking',('standardKick','any'))
        )        
    ]
)


program=swiML.Program(
    title='Continue Examples',
    author=[('firstName','Callum'),('lastName','Lockhart')],
    programDescription='Examples of continues in swiML',
    poolLength = 25,
    lengthUnit= 'meters',
    programAlign=False,
    numeralSystem='roman',
    swiMLVersion=2.0,
    instructions=[continue0,continue1,continue2]
)

print(program)
swiML.writeXML('pythonExamples/cont.xml',program)