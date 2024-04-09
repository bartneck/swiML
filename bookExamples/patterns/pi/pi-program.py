import swiML, mpmath, math

def pi_digits(n):
    # Set the number of decimal places
    mpmath.mp.dps = n + 1
    # Get Pi as a string with desired precision
    pi_str = str(mpmath.pi)
    # Convert Pi string to array of digits
    pi_digits_array = [int(digit) for digit in pi_str.replace('.', '')]
    return pi_digits_array

def create_swiML_instructions():
    my_instruction_list=[]
    for i in range(0, digits):
        if pi_array[i]%2==0:
            current_stroke="notFreestyle"
        else:
            current_stroke="freestyle"
        intensity_list=["max","racePace","endurance","threshold","easy"]
        current_intensity=intensity_list[math.floor(pi_array[i]/2)]
        my_instruction_list.append(swiML.Instruction(
                length=('lengthAsLaps',pi_array[i]),
                stroke=('standardStroke',current_stroke),
                intensity=('startIntensity',('zone',current_intensity)),
                rest=('afterStop','PT0M15S')
        ))
        i+=1
    return my_instruction_list

#writing the swiML program to disk
def write_program():
    # warm up instructions
    warmUp=swiML.Instruction(
        length=('lengthAsDistance',400),
        stroke=('standardStroke','any'),
        intensity=('startIntensity',('zone','easy')),
    )
    # warm down instruction
    warmDown=swiML.Instruction(
        length=('lengthAsDistance',200),
        stroke=('standardStroke','any'),
        intensity=('startIntensity',('zone','easy')),
    )
    # assembly of the main instructions
    myInstructions=create_swiML_instructions()
    myInstructions[:0]=[swiML.SegmentName('Warm Up'),warmUp]
    myInstructions.insert(2,swiML.SegmentName('Pi set'))
    myInstructions.append(swiML.SegmentName('Warm down'))
    myInstructions.append(warmDown)
    
    # assemble the description of the swimming program
    description_text="Swim the first "+str(digits-1)+" digits of Pi while increasing the intensity for shorter distances. "
    
    # create the program
    simpleProgram=swiML.Program(
        title='Palatial Pi Program',
        author=[('firstName','Christoph'),('lastName','Bartneck')],
        programDescription=description_text,
        poolLength='50',
        creationDate='2024-04-09',
        lengthUnit='laps',
        hideIntro=False,
        swiMLVersion='2.1',
        instructions=myInstructions
    )
    # write swiML XML to file
    swiML.writeXML('patterns/pi/pi-program.xml',simpleProgram)

# Number of digits desired
digits = 14
pi_array = pi_digits(digits)
# write the swiML program
write_program()