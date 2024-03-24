import math, swiML

def integer_to_variable_size_binary_array(number, num_bits):
    # Determine the number of bits necessary to represent the number
    # num_bits = math.ceil(math.log2(number + 1))  # Add 1 to handle the case when number is 0

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
    while i<=number:
        binary_array.append(integer_to_variable_size_binary_array(i, num_bits))
        print("counter: ",i," array: ",binary_array[i])
        i+=1
    return binary_array

def create_swiML_instructions():
    my_instruction_list=[]
    i=0
    j=0
    # write an instruction for each list item
    # return list of instructions
    while j<number:
        while i <num_bits:
            if full_array[j][i]==0:
                current_stroke=zero_stroke
            else:
                current_stroke=one_stroke
                
            my_instruction_list.append(swiML.Instruction(
                length=('lengthAsDistance',length),
                stroke=('standardStroke',current_stroke),
                rest=('afterStop','PT0M15S')
            ))
            i+=1
        return my_instruction_list



# Example usage
number = 8
num_bits = math.ceil(math.log2(number + 1))  # Add 1 to handle the case when number is 0
length=25
zero_stroke="notFreestyle"
one_stroke="freestyle"
full_array=binary_array(number, num_bits)
instructions=create_swiML_instructions()


print(full_array)

