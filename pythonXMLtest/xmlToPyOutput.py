import xml.etree.ElementTree as ET

xmlfile = 'pythonXMLtest\sample.xml'

tree = ET.parse(xmlfile)
root = tree.getroot()

'''ET.dump(tree)

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
    return [f'{author[0].text} {author[1].text}',f'{author[2].text}' if len(author) > 2 else '']

def print_length(length,unit):
    '''return pools length string'''
    return f'{length.text} {unit.text} pool'

def print_total_length(length,unit):
    '''return pools length string'''
    return f'{length.text} {unit.text}'

def print_stroke(stroke):
    '''returns line detailing what stroke is being swum'''
    for  child in stroke:
        if child.tag == 'kicking' or child.tag == 'drill':
            for child2 in child:
                 return (f'{child2.text} {child.tag}')
        else:
            return (f'{child.text} ')

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
    for rest_type in rest:
        if rest_type.tag == 'sinceStart':
            return f'on {to_time(rest_type.text)}'
        elif rest_type.tag == 'afterStop':
            return f' take {to_time(rest_type.text)} rest'
        elif rest_type.tag == 'sinceLastRest':
            return f'{to_time(rest_type.text)}'
        elif rest_type.tag == 'inOut':
            return f'{rest_type.text} in First out'

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
    for instruction in child[1:]:
        print_instuction(instruction,prefix)

def print_description(desc):
    '''prints contents'''
    return desc.text
    

def print_repetition(child,prefix):
    '''adds repitition prefix to all children instructions'''
    prefix.append([' | ',child[0].text])
    for instruction in child[1:]:
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
        
        # instruction group checks
        for child in instruction:
            if child.tag[:6] == 'length':
                if child.tag[-4:] == 'Time':
                    r_strings[0]+= (f'swim for {to_time(child.text)}')
                else:
                    r_strings[0]+= (f'{child.text} {root.find("lengthUnit").text} ')
            elif child.tag == 'stroke':
                r_strings[0]+= (print_stroke(child))
            elif child.tag == 'equipment':
                r_strings[0]+= (print_equipment(child))
            elif child.tag == 'underwater':
                r_strings.append(print_underwater(child))
            elif child.tag == 'intensity':
                r_strings.append(print_intensity(child))
            elif child.tag == 'rest':
                r_strings.append(print_rest(child))
            elif child.tag == 'breath':
                r_strings.append(print_breath(child))
            elif child.tag == 'instructionDescription':
                r_strings.append(print_description(child))

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
print()
for child2 in root:
    if child2.tag == 'hideIntro':
        if child2.text == 'true':
            for child in root:
                if child.tag == 'instruction':
                    #print all instructions
                    print('new instruction')
                    print_instuction(child,[])
        else:
            for child in root:
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
                elif child.tag == 'instruction':
                    #print all instructions
                    print(' \nnew instruction')
                    print_instuction(child,[])
            