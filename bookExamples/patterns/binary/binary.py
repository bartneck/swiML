import math, swiML as swiML

def integer_to_variable_size_binary_array(number, num_bits):
    # Convert the integer to binary representation
    binary_representation = bin(number)[2:]  # [2:] to remove '0b' prefix from binary string
    # Pad the binary representation with leading zeroes to make it num_bits long
    binary_representation = binary_representation.zfill(num_bits)
    # Create an array to store binary digits
    binary_array = [int(digit) for digit in binary_representation]
    return binary_array

def binary_array(number, num_bits):
    binary_array=[]
    i=0
    while i<number:
        binary_array.append(integer_to_variable_size_binary_array(i, num_bits))
        i+=1
    return binary_array

def create_swiML_instructions():
    my_instruction_list=[]
    my_continue_list=[]
    i=j=0

    # main loop to create <instruction> elements based on the binary array
    while j<number:
        while i <num_bits:
            if full_array[j][i]==0:
                current_stroke=zero_stroke
            else:
                current_stroke=one_stroke
            my_instruction_list.append(swiML.Instruction(
                length=('lengthAsDistance',length),
                stroke=('standardStroke',current_stroke),
            ))
            i+=1   
        # add instruction to the <continue> element.
        my_continue_list.append(swiML.Continue(
            instructions=my_instruction_list
        ))
        # reset variable for next iteration
        j+=1
        i=0
        my_instruction_list=[]

    #add the list of <continue> elements to the <repetition> element
    my_repetition_list=swiML.Repetition(
        simplify=True,
        instructions=my_continue_list
    )
    return my_repetition_list

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
    # the main binary instructions
    myInstructions=create_swiML_instructions()
    
    # assemble the description of the swimming program
    description_text="Look at swimming from a binary point of view. Swim "+str(number)+" times "+str(num_bits*length)+" using "+str(num_bits)+" bits."
    
    # create the program
    simpleProgram=swiML.Program(
        title='Binary',
        author=[('firstName','Christoph'),('lastName','Bartneck')],
        programDescription=description_text,
        poolLength='25',
        creationDate='2024-03-25',
        lengthUnit='meters',
        hideIntro=False,
        swiMLVersion='2.1',
        instructions=[swiML.SegmentName('Warm Up'),
                      warmUp,swiML.SegmentName('Binary set'),
                      myInstructions,
                      swiML.SegmentName('Warm Down'),
                      warmDown]
    )
    # write swiML XML to file
    swiML.writeXML('binary-test.xml',simpleProgram)

# counting up the number
number = 8
# length per bit change
length=100
zero_stroke="notFreestyle"
one_stroke="freestyle"
# calculate how many bits are necessary to represent number
num_bits = math.ceil(math.log2(number))
# create an array with the binary representation of number
full_array=binary_array(number, num_bits)
write_program()