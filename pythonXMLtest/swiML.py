import xml.etree.ElementTree as ET

LOAD_VARS = ['title','author','programDescription','poolLength','lengthUnit']
AUTHOR_VARS = ['firstName','lastName','email']
INSTRUCTION_VARS=[['lengthAsDistance','lengthAsTime','lengthAsLaps'],'rest','intensity','stroke','breath','underwater','equipment','instructionDescription']
REPETITION_VARS = ['repetitionCount','repetitionDescription','instruction']

def to_time(time):
    '''converts to unit time'''
    return (f'{time[2:3]}:{time[4:6]}')

def get_total_length(instructions):
    '''returns length of given instructions
    or repetitions if '''
    total_length = 0 
    for inst in instructions:
        if type(inst) is Instruction:
            total_length += inst.length[1]
        if type(inst) is Repetition:
            total_length += inst.repetitionCount*get_total_length(inst.children)
        if type(inst) is Continue:
            total_length += inst.totalLength
    return total_length

def continue_length(simplify,children):
    '''returns either total length or simplified repetitions'''

    if simplify:
        total_repetition = 0
        first_inst = children[0].children[0]
        for repetition in children:
            total_repetition += repetition.repetitionCount
            for instruction in repetition.children:
                if instruction.length != first_inst.length:
                    raise Exception(F'Cannot simplify continue with repetitions of different lengths  {first_inst} cannot be simplified with {instruction}') 
        return f'{total_repetition} x {first_inst.length[1]}'
    else:
        return get_total_length(children)

def classToXML(root,self):
    #print(type(self).__name__) --> gives class name could just give to subelement
    if type(self) is Repetition:
        root = ET.SubElement(root,'repetition')
    if type(self) is Continue:
        root = ET.SubElement(root,'continue')
    if type(self) is Pyramid:
        root = ET.SubElement(root,'pyramid')
    children = [getattr(self,attr if type(attr) is str else attr[0]) for attr in self.TAG_ORDER]
    tags = self.TAG_ORDER
    
    expandXML(root,tags,children)

def expandXML(root,tags,children):
    'converts list of tags and children to XML'
    for tag_index,tag in enumerate(tags):
        if children[tag_index] != None:
            if type(tag) is str:
                if children[tag_index] == None:
                    pass
                elif type(children[tag_index]) is str or type(children[tag_index]) is int or type(children[tag_index]) is bool:
                    ET.SubElement(root,tag).text = str(children[tag_index])
                elif type(children[tag_index]) is list :
                    for child in children[tag_index]:
                        instruction = ET.SubElement(root,'instruction')
                        classToXML(instruction,child)
                else:
                    print('oh no')
            elif type(tag) is tuple:
                parent = ET.SubElement(root,tag[0])
                if tag[1] == 's':
                    if len(tag[2]) == len(children[tag_index]):
                        expandXML(parent,tag[2],children[tag_index])
                    else:
                        expandXML(parent,tag[2][:-(len(tag[2])-len(children[tag_index]))],children[tag_index])
                elif tag[1] == 'c':
                    for choice in tag[2]:
                        if children[tag_index][0] == choice:
                            expandXML(parent,[choice],[children[tag_index][1]]) 
        

class Program:
    '''Defines a program'''

    TAG_ORDER = ['title',('author','s',['firstName','lastName','email']), 'programDescription', 'poollength', 'lengthUnit',  'children']


    def __init__(self,title = None,author = [None,None,None],programDescription = None,poolLength ='25',lengthUnit = 'meter',children = []):
        '''program initialiser function
            with specified program data 
            as well as all instructions for the program
        '''
        self.title = title
        self.author = author 
        self.programDescription = programDescription
        self.poollength = poolLength
        self.lengthUnit = lengthUnit
        self.children = children 

    def __str__(self):
        '''returns string for program data 
        adds each string of all the instructions contained within the program 
        using each individual to string function 
        '''
        title_string = f'\n{self.title}\n{self.author[0]} {self.author[1]}\n{self.programDescription}\n{self.poollength} {self.lengthUnit} pool\n'
        children_string = ''.join([str(child) for child in self.children])
        return title_string+children_string+'\n'
    
    def toXml(self,filename):
        '''converts objects to XML in specified file
        takes filename as input'''

        global FILENAME 
        FILENAME = filename
        root = ET.Element('program')
        classToXML(root,self)
        tree = ET.ElementTree(root)
        tree.write('pythonXMLtest\\'+filename)

class Instruction:
    '''Defines a basic instruction'''

    TAG_ORDER = [('length','c',['lengthAsDistance','lengthAsTime','lengthAsLaps']),
                 ('rest','c',['afterStop','sinceStart','sinceLastRest']),
                 ('intensity','c',[('staticIntensity','c',['percentageEffort','zone','percentageHeartRate']),('dynamicAcross','s',[('startIntensity','c',['percentageEffort','zone','percentageHeartRate']),('stopIntensity','c',['percentageEffort','zone','percentageHeartRate'])])]),
                 ('stroke','c',['standardStroke',('kicking','c',['standardKick',('other','s',['orientation','legMovement'])]),('drill','s',['drillName','drillStroke'])]),
                 'breath',
                 'underwater',
                 'equipment',
                 'instructionDescription']

    def __init__(self,length=None,rest=None,intensity=None,stroke=None,breath=None,underwater=False,equipment=[],instructionDescription=None):
        '''Initialises an instruction instance and defines all attributes'''
        self.length = length
        self.rest = rest
        self.intensity = intensity
        self.stroke = stroke
        self.breath = breath
        self.underwater = underwater
        self.equipment = equipment
        self.instructionDescription = instructionDescription

    def __str__(self):
        '''returns a string for an instruction object that can easily be read'''

        rest = '' if self.rest == None else f'on {to_time(self.rest[1])}' if self.rest[0] == 'sinceStart' else f' take {to_time(self.rest[1])} rest' if self.rest[0] == 'afterStop' else f'{to_time(self.rest[1])}' if self.rest[0] == 'sinceLastRest' else f'{self.rest[1]} in First out'
        underwater = 'underwater\n' if self.underwater else ''
        equipment = ', '.join(self.equipment)[:-2]+'\n' if len(self.equipment) > 0 and self.equipment != None else ''
        if self.intensity != None:
            if self.intensity[0] == 'staticIntensity':
                intensity =  f'{self.intensity[1][1]}{"%" if self.intensity[1][0] == "percentageEffort" else "% of max HR" if self.intensity[1][0] == "percentageHeartRate" else ""}\n'
            else:
                intensity =  f'Start: {intensity[1][1]}{"%" if intensity[1][1] == "percentageEffort" else "% of max HR" if intensity[1][1] == "percentageHeartRate" else ""} \n End:{intensity[2][1]}{"%" if intensity[2][0] == "percentageEffort" else "% of max HR" if intensity[2][0] == "percentageHeartRate" else ""}\n'
        else:
            intensity = ''
        breath = f'Breathing every {self.breath}\n' if self.breath != None else ''
        length ='' if self.length == None else f'{self.length[1]} Laps' if self.length[0] == 'lengthAsLaps' else f'{self.length[1]} units' if self.length[0] == 'lengthAsDistance' else f'Swim for {self.length[1]}'
        instructionDescription = self.instructionDescription if self.instructionDescription != None else ''

        return f'\n{length} {self.stroke[1]} {rest} \n{underwater}{equipment}{intensity}{breath}{instructionDescription}'



class Repetition:
    '''Defines a repetition'''

    TAG_ORDER = ['repetitionCount','repetitionDescription','children']

    def __init__(self,repetitions,repetitionDescription = None,children=[]):
        '''create repetition'''
        self.repetitionCount = repetitions
        self.repetitionDescription = repetitionDescription
        self.children = children

    def __str__(self):
        '''returns string for repetition'''
        return_list =''
        #return_string = ''
        children_string = '\n'.join(map(str,self.children))
        children = str(children_string).split('\n')
        for i,line in enumerate(children[1:]):
            if i == (len(children)-1)//2:
                return_list += (f'{self.repetitionCount}x | {line}\n')
            else:
                return_list += (f'   | {line}\n')

        return '\n'+return_list[:-2]
    
class Continue:
    '''Defines a continuation'''

    TAG_ORDER = ['totalLength','children']

    def __init__(self,totalLength=0,simplify=False,children=[]):
        '''create continue'''
        self.children = children
        self.simplify = simplify
        self.totalLength = continue_length(simplify,children) if totalLength == 0 else totalLength
    def __str__(self):
        '''returns string for continue'''
        return_list =''
        #return_string = ''
        children_string = '\n'.join(map(str,self.children))
        children = str(children_string).split('\n')
        for i,line in enumerate(children[1:]):
            return_list += (f'   | {line}\n')

        return f'\n{self.totalLength} swim as\n'+return_list[:-2]+'\n'

class Pyramid:
    '''Defines a pyramid'''
    
    TAG_ORDER = ['startLength','stopLength','increment','lengthUnit','children']
    
    def __init__(self,startLength,stopLength,increment,lengthUnit,children):
        '''create repetition'''
        self.startLength = startLength
        self.stopLength = stopLength
        self.increment = increment
        self.lengthUnit = lengthUnit
        self.children = children

    def __str__(self):
        '''returns string for repetition'''
        outChildren = []
        length = self.startLength
        while length <= self.stopLength:
            inst = self.children[0]
            setattr(inst,'length',('lengthAsDistance',length))
            outChildren.append(str(inst))
            length += self.increment
        length -= 2*self.increment
        while length >= self.startLength:
            inst = self.children[0]
            setattr(inst,'length',('lengthAsDistance',length))
            outChildren.append(str(inst))
            length -= self.increment
        rChildren = '\n'.join([f'   | {line.strip()}' for line in outChildren])
        return '\n  Pyramid\n'+str(rChildren)+'\n'