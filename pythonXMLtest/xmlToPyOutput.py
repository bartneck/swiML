import xml.etree.ElementTree as ET


'''
for length in root.iter('lengthAsDistance'):
    new_length = int(length.text) + 25
    length.text = str(new_length)
    length.set('updated', 'yes')
tree.write(xmlfile)
ET.dump(tree)'''

def get_number_of_strings(strings):
    '''returns total number of strings'''
    numberOfStrings = 0
    for string in strings:
        if type(string) is str:
            numberOfStrings+=1
        else:
            numberOfStrings+=get_number_of_strings(string)
    return numberOfStrings


def to_time(time):
    '''converts to unit time'''
    return (f'{time[2:3]}:{time[4:6]}')

def print_author(author):
    '''returns author string'''
    return [(f'{author[0].text.strip()} {author[1].text.strip()}'),(f'{author[2].text.strip()}' if len(author) > 2 else '')]

def print_length(length,unit):
    '''return pools length string'''
    return f'{length.text.strip()} {unit.text.strip()} pool'

def print_total_length(length,unit):
    '''return pools length string'''
    return f'{length.text.strip()} {unit.text.strip()}'

def print_stroke(stroke):
    '''returns line detailing what stroke is being swum'''
    if stroke.tag == 'kicking' or stroke.tag == 'drill':
        for child2 in stroke:
                return (f'{child2.text.strip()} {stroke.tag}')
    else:
        return (f'{stroke.text.strip()} ')

def print_intensity(intensity):
    '''returns lines for both static and dynamic intenisty
    so can be used for both in an instruction and on the surface of a repitition'''
    # these are very long lines --> need to fix
    if intensity[0].tag == 'staticIntensity':
        return f'{intensity[0][0].text.strip()}{"%" if intensity[0][0].tag == "percentageEffort" else "% of max HR" if intensity[0][0].tag == "percentageHeartRate" else ""}'
    else:
        return f'Start: {intensity[0][1].text.strip()}{"%" if intensity[0][1].tag == "percentageEffort" else "% of max HR" if intensity[0][1].tag == "percentageHeartRate" else ""} \n End:{intensity[0][2].text}{"%" if intensity[0][2].tag == "percentageEffort" else "% of max HR" if intensity[0][2].tag == "percentageHeartRate" else ""}'

def print_rest(rest):
    '''returns line for rest types'''
    
    if rest.tag == 'sinceStart':
        return f'on {to_time(rest.text.strip())}'
    elif rest.tag == 'afterStop':
        return f' take {to_time(rest.text.strip())} rest'
    elif rest.tag == 'sinceLastRest':
        return f'{to_time(rest.text.strip())}'
    elif rest.tag == 'inOut':
        return f'{rest.text.strip()} in First out'

def print_breath(breath):
    '''returns line for breathing style'''
    return f'Breathing every {breath.text.strip()}'

def print_equipment(equipment):
    '''returns line for equipment'''
    return (f'with {equipment}')

def print_underwater(under):
    '''return underwater based on boolean input'''
    if under:
        return 'under the water'

def print_continue(child,prefix,root):
    '''prints continue heading and instructions within 
    adds continue prefix to children instructions'''
    print(f'{child[0].text.strip()} {root.find("lengthUnit").text} swim as')
    prefix.append(' | ')
    for instruction in child.findall('./instruction'):
        print_instruction(instruction,prefix,root)

def print_description(desc):
    '''prints contents'''
    return desc.text.strip()
    
def print_instruction_strings(strings):
    '''returns strings for a repetition'''
    prefix = []
    #print(strings)
    total_strings = []
    while len(strings) == 1 and type(strings[0]) is not str:
        [strings] = strings
    number  = get_number_of_strings(strings)
    for pre in strings[1]:
        prefix.append(pre)
    for i,string in enumerate(strings[0]):
        if type(string) is str:
            for index,pre in enumerate(prefix[::-1]):
                
                if i == (len(strings[0])-1) // 2 and index == 0:
                    string = (f'{pre[1]}x{pre[0]}') + string
                else:
                    string = (f'  {pre[0]}') + string
                
            total_strings.append(string)
        elif type(string) is tuple:
            for string in print_instruction_strings(string):
                total_strings.append(string)
    return total_strings
def print_repetition(child,prefix,root):
    '''adds repitition prefix to all children instructions'''
    prefix2 = prefix.copy()
    r_strings = [{'blank':[['']]}]
    flat_lines = []
    total_strings = []
    prefix2.append([' | ',child[0].text.strip()])
    for instruction in child.findall('./instruction'):
         r_strings.append(print_instruction(instruction,prefix2,root))
         r_strings.append({'blank':[['']]})
    print(r_strings)
    for multiLine in r_strings:
        print(multiLine)
        item = next(iter(multiLine.items()))
        # stopped here --> giving me blank reps when it shouldnt
        if item[0] == 'rep':
            print(multiLine,'rep')
        else:
            print(item[1],'not')
                
            #flat_lines.append(line[0])
    number  = get_number_of_strings(flat_lines)
    for i,string in enumerate(flat_lines):
        
        for index,pre in enumerate(prefix2[::-1]):
            
            if i == (len(flat_lines)-1) // 2 and index == 0:
                string = (f'{pre[1]}x{pre[0]}') + string
            else:
                string = (f'  {pre[0]}') + string
            
        total_strings.append(string)
        
    return {'rep':total_strings}
    '''
    total_strings = []
    while len(strings) == 1 and type(strings[0]) is not str:
        [strings] = strings
    number  = get_number_of_strings(strings)
    for pre in strings[1]:
        prefix.append(pre)
    for i,string in enumerate(strings[0]):
        if type(string) is str:
            for index,pre in enumerate(prefix[::-1]):
                
                if i == (len(strings[0])-1) // 2 and index == 0:
                    string = (f'{pre[1]}x{pre[0]}') + string
                else:
                    string = (f'  {pre[0]}') + string
                
            total_strings.append(string)
        elif type(string) is tuple:
            for string in print_repetition(string):
                total_strings.append(string)
    return total_strings'''


def print_pyramid(child,prefix):
    #incomplete
    print('Pyramid')
    print(child)

def print_instruction(instruction,prefix,root):
    total_return_strings = []
    '''prints instruction tag and its contents
    checks if instruction contains any non basic instructions'''
    if instruction[0].tag == 'continue':
        return print_continue(instruction[0],prefix,root)
    elif instruction[0].tag == 'repetition':
        return print_repetition(instruction[0],prefix,root)
    elif instruction[0].tag == 'pyramid':
        return print_pyramid(instruction[0],prefix,root)
    else:
        r_strings=['']
        length_boss = instruction[0]
        if length_boss.tag[:6] == 'length':
                if length_boss.tag[-4:] == 'Time':
                    r_strings[0]+= (f'swim for {to_time(length_boss.text)}')
                else:
                    r_strings[0]+= (f'{length_boss.text.strip()} {root.find("lengthUnit").text.strip()} ')
        if (instruction.find('./stroke')) != None and len((instruction.find('./stroke'))) > 0:r_strings[0]+= (print_stroke(instruction.find('./stroke')[0]))
        if (instruction.find('./rest')) != None and len((instruction.find('./rest'))) > 0:r_strings[0] += (print_rest(instruction.find('./rest')[0]))
        if instruction.find('./underwater'): r_strings.append(print_underwater(instruction.find('./underwater'))) 
        if (instruction.find('./equipment')) != None and len((instruction.find('./equipment'))) > 0:r_strings.append(print_equipment(instruction.find('./equipment')))
        if (instruction.find('./intensity')) != None and len((instruction.find('./intensity'))) > 0:r_strings.append(print_intensity(instruction.find('./intensity')))
        if (instruction.find('./breath')) != None and (instruction.find('./breath')).text != 'None' : r_strings.append(print_breath(instruction.find('./breath')))
        if (instruction.find('./instructionDescription')) != None and len((instruction.find('./instructionDescription'))) > 0:r_strings.append(print_description(instruction.find('./instructionDescription')))

        
        new_r_strings = [(string,prefix) for string in r_strings]
        return {'inst':new_r_strings}

def print_program(root):
    hide_intro=False
    #ET.dump(root)
    print()
    for child2 in root:
        if child2.tag == 'hideIntro' and child2.text == 'true':
            hide_intro = True
        
    for child in root:
        if not hide_intro:
            if child.tag == 'title':
                print(child.text)
            elif child.tag == 'author':
                for line in print_author(child):
                    if len(line) > 0:
                        print(line)
            elif child.tag == 'programDescription':
                print(print_description(child))
            elif child.tag == 'creationDate':
                print(child.text)
            elif child.tag == 'poolLength':
                print(print_length(child,root.find("lengthUnit")))
            elif child.tag == 'programLength':
                print(print_total_length(child,root.find("lengthUnit")))
        if child.tag == 'instruction':
            #print all instructions
            print(' \nnew instruction')
            for string in print_instruction(child,[],root):
                print(string)
               


xmlfile = 'pythonXMLtest\\test.xml'

tree = ET.parse(xmlfile)
root = tree.getroot()
print_program(root)