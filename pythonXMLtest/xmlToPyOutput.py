import xml.etree.ElementTree as ET

xmlfile = 'pythonXMLtest\sample.xml'

tree = ET.parse(xmlfile)
root = tree.getroot()

'''
for length in root.iter('lengthAsDistance'):
    new_length = int(length.text) + 25
    length.text = str(new_length)
    length.set('updated', 'yes')
tree.write(xmlfile)
ET.dump(tree)'''

root.find('lengthUnit').text



def to_time(time):
    '''converts to unit time'''
    return (f'{time[2:3]}:{time[4:6]}')

def print_author(author):
    '''returns author string'''
    return [(f'{author[0].text} {author[1].text}'),(f'{author[2].text}' if len(author) > 2 else '')]

def print_length(length,unit):
    '''return pools length string'''
    return f'{length.text} {unit.text} pool'

def print_total_length(length,unit):
    '''return pools length string'''
    return f'{length.text} {unit.text}'

def print_stroke(stroke):
    '''returns line detailing what stroke is being swum'''
    if stroke.tag == 'kicking' or stroke.tag == 'drill':
        for child2 in stroke:
                return (f'{child2.text} {stroke.tag}')
    else:
        return (f'{stroke.text} ')

def print_intensity(intensity):
    '''returns lines for both static and dynamic intenisty
    so can be used for both in an instruction and on the surface of a repitition'''
    # these are very long lines --> need to fix
    if intensity[0].tag == 'staticIntensity':
        return f'{intensity[0][0].text}{"%" if intensity[0][0].tag == "percentageEffort" else "% of max HR" if intensity[0][0].tag == "percentageHeartRate" else ""}'
    else:
        return f'Start: {intensity[0][1].text}{"%" if intensity[0][1].tag == "percentageEffort" else "% of max HR" if intensity[0][1].tag == "percentageHeartRate" else ""} \n End:{intensity[0][2].text}{"%" if intensity[0][2].tag == "percentageEffort" else "% of max HR" if intensity[0][2].tag == "percentageHeartRate" else ""}'

def print_rest(rest):
    '''returns line for rest types'''
    
    if rest.tag == 'sinceStart':
        return f'on {to_time(rest.text)}'
    elif rest.tag == 'afterStop':
        return f' take {to_time(rest.text)} rest'
    elif rest.tag == 'sinceLastRest':
        return f'{to_time(rest.text)}'
    elif rest.tag == 'inOut':
        return f'{rest.text} in First out'

def print_breath(breath):
    '''returns line for breathing style'''
    return f'Breathing every {breath.text}'

def print_equipment(equipment):
    '''returns line for equipment'''
    return (f'with {equipment}')

def print_underwater(under):
    '''return underwater based on boolean input'''
    if under:
        return 'under the water'

def print_continue(child,prefix):
    '''prints continue heading and instructions within 
    adds continue prefix to children instructions'''
    print(f'{child[0].text} {root.find("lengthUnit").text} swim as')
    prefix.append(' | ')
    for instruction in child.findall('./instruction'):
        print_instuction(instruction,prefix)

def print_description(desc):
    '''prints contents'''
    return desc.text
    

def print_repetition(child,prefix):
    '''adds repitition prefix to all children instructions'''
    prefix.append([' | ',child[0].text])
    for instruction in child.findall('./instruction'):
        print_instuction(instruction,prefix)

def print_pyramid(child,prefix):
    #incomplete
    print('Pyramid')
    print(child)

def print_instuction(instruction,prefix):
    '''prints instruction tag and its contents
    checks if instruction contains any non basic instructions'''
    if instruction[0].tag == 'continue':
        print_continue(instruction[0],prefix)
    elif instruction[0].tag == 'repetition':
        print_repetition(instruction[0],prefix)
    elif instruction[0].tag == 'pyramid':
        print_pyramid(instruction[0],prefix)
    else:
        r_strings=['']
        length_boss = instruction[0]
        if length_boss.tag[:6] == 'length':
                if length_boss.tag[-4:] == 'Time':
                    r_strings[0]+= (f'swim for {to_time(length_boss[0].text)}')
                else:
                    r_strings[0]+= (f'{length_boss[0].text} {root.find("lengthUnit").text} ')
        if (instruction.find('./stroke')) != None and len((instruction.find('./stroke'))) > 0:r_strings[0]+= (print_stroke(instruction.find('./stroke')[0]))
        if (instruction.find('./rest')) != None and len((instruction.find('./rest'))) > 0:r_strings[0] += (print_rest(instruction.find('./rest')[0]))
        if instruction.find('./underwater'): r_strings.append(print_underwater(instruction.find('./underwater'))) 
        if (instruction.find('./equipment')) != None and len((instruction.find('./equipment'))) > 0:r_strings.append(print_equipment(instruction.find('./equipment')))
        if (instruction.find('./intensity')) != None and len((instruction.find('./intensity'))) > 0:r_strings.append(print_intensity(instruction.find('./intensity')))
        if (instruction.find('./breath')) != None and (instruction.find('./breath')).text != 'None' : r_strings.append(print_breath(instruction.find('./breath')))
        if (instruction.find('./instructionDescription')) != None and len((instruction.find('./instructionDescription'))) > 0:r_strings.append(print_description(instruction.find('./instructionDescription')))

        #adds buffer for multi indented instructions for easier reading
        if len(prefix) > 1:
            r_strings.insert(0,'')
            r_strings.append('')
        #adds needed prefixes to strings and prints strings for given instruction
        for i,string in enumerate(r_strings):
            for pre in prefix[::-1]:
                if pre == ' | ':
                    string = '  '+pre + string
                else:
                    if i == (len(r_strings)-1) // 2:
                        string = (f'{pre[1]}x{pre[0]}') + string
                    else:
                        string = (f'  {pre[0]}') + string
            print(string)

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
            print_instuction(child,[])
            