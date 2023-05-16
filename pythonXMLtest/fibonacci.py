import swiML

strokes = ['freestyle','backstroke']
a = 0 
b = 1
i = 0 
instructions = []
print(a)
print(b)
while i < 9:
    temp = b
    b = a + b 
    a = temp
    i+=1
    print(b)
    instructions.append(swiML.Instruction(
        ('lengthAsDistance',a*25),
        stroke=('standardStroke',strokes[0] if a%2 == 0 else strokes[1]),
    ))

program = swiML.Program(
    'Jasi Masters',
    ['Callum','Lockhart'],
    'Our Tuesday evening program in the sun. The target duration was 60 minutes.',
    '25',
    'meter',
    instructions
)

print(program)
program.toXml('sample.xml')