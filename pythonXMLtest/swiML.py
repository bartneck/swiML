import xml.etree.ElementTree as ET

INSTRUCTION_GROUP = [
                     ('length','c',
                      ['lengthAsDistance','lengthAsTime','lengthAsLaps']
                     ),
                     ('stroke','c',
                     ['standardStroke',
                     ('kicking','c',
                         ['standardKick',
                         ('other','s',
                         ['orientation','legMovement']
                         )
                         ]
                     ),
                     ('drill','s',
                         ['drillName','drillStroke']
                     )
                     ]
                     ),
                     ('rest','c',
                     ['afterStop','sinceStart','sinceLastRest','inOut']
                     ),
                     ('intensity','c',
                      [
                       ('startIntensity','c',
                        ['percentageEffort','zone','percentageHeartRate']
                       ),
                       ('stopIntensity','c',
                        ['percentageEffort','zone','percentageHeartRate']
                       ) 
                      ]
                     ),
                     'breath',
                     'underwater',
                     'equipment',
                     'instructionDescription'
                   ]

def to_time(time):
    '''converts to unit time'''
    return (f'{time[2:3]}:{time[4:6]}')

def basicInstructions(instructions,parents=[]):
    '''given a list of normal instructions objects contained within an instruction class and any data on parent classes '''
    instructionList = []
    for child in instructions:
        if type(child) is Instruction or type(child) is Continue:
            instructionList.append((child,parents))
        else:
            if child.instructions != None:
                instructionList.extend(basicInstructions(child.instructions,parents+[type(child)]))
            else:
                instructionList.append((child,parents))
    return instructionList

def nonBasicInstructions(instructions):
    '''given a list of normal instructions objects contained within an instruction class '''
    #currently unused and is not different from basicInstructions
    instructionList = []
    for child in instructions:
        if type(child) is not Instruction and type(child) is not Continue:
            instructionList.append(child)
        else:
            if child.instructions != None:
                instructionList.extend(basicInstructions(child.instructions))
    return instructionList


def get_total_length(instructions):
    '''returns length of given instructions
    or repetitions if '''
    total_length = 0 
    for inst in instructions:
        if type(inst) is Instruction:
            total_length += int(inst.length[1])
        if type(inst) is Repetition:
            total_length += int(inst.repetitionCount)*get_total_length(inst.instructions)
        if type(inst) is Continue:
            total_length += get_total_length(inst.instructions)
    return int(total_length)

def simplify_repetition(instructions,repetitionCount):
    '''returns either total length or simplified repetitions'''

    #this function isnt perfect as it fails on multiple nested repetitions still
    
    total_repetition = 0
    basicInsts = basicInstructions(instructions)
    if type(instructions[0]) is Repetition:
        for repetition in instructions:
            total_repetition += repetition.repetitionCount
            for instruction in repetition.instructions:
                if instruction.length != basicInsts[0][0].length:
                    raise Exception(F'Cannot simplify continue with repetitions of different lengths  {basicInsts[0][0]} cannot be simplified with {instruction}') 
    else:
        for instruction in instructions:
            total_repetition += 1
            if instruction.length != basicInsts[0][0].length:
                    raise Exception(F'Cannot simplify continue with repetitions of different lengths  {basicInsts[0][0]} cannot be simplified with {instruction}') 
    return f'{total_repetition*repetitionCount} x {basicInsts[0][0].length[1]}'
   


def classToXML(self,root=None):
    if type(self) is not Instruction:
        if root == None:
            root = ET.Element(type(self).__name__.lower())
            if type(self).__name__.lower() == 'program':
                schemaLocation = f'https://github.com/bartneck/swiML/version/{str(self.swiMLVersion).split(".")[0]}/{self.swiMLVersion} https://raw.githubusercontent.com/bartneck/swiML/main/version/{str(self.swiMLVersion).split(".")[0]}/{self.swiMLVersion}/swiML.xsd'
                root.set('xmlns','https://github.com/bartneck/swiML')
                root.set('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance')
                root.set('xsi:schemaLocation',schemaLocation)
        else:
            root = ET.SubElement(root,type(self).__name__.lower())
    instructions = [getattr(self,attr if type(attr) is str else attr[0]) for attr in self.TAG_ORDER]
    tags = self.TAG_ORDER[:]


    if type(self) is Instruction:
        if len(self.inherited) > 0:
            for inherited_element in self.inherited:
                for tag_index,tag in enumerate(tags):
                    if (tag if type(tag) is str else tag[0]) == inherited_element:
                        tags.pop(tag_index)
                        instructions.pop(tag_index)
                
        

    ObjToXML(root,tags,instructions)
    return ET.ElementTree(root)

def ObjToXML(root,tags,instructions):
    'converts list of tags and instructions to XML'
    for tag_index,tag in enumerate(tags):
        if instructions[tag_index] != None:
            if type(tag) is str:
                if instructions[tag_index] == None:
                    pass
                elif type(instructions[tag_index]) is str or type(instructions[tag_index]) is int:
                    ET.SubElement(root,tag).text = str(instructions[tag_index])
                elif type(instructions[tag_index]) is bool:
                    ET.SubElement(root,tag).text = str(instructions[tag_index]).lower()
                elif type(instructions[tag_index]) is list :
                    for child in instructions[tag_index]:
                        instruction = ET.SubElement(root,'instruction')
                        classToXML(child,instruction)
                elif type(instructions[tag_index]) is tuple :
                    if tag == instructions[tag_index][0]:
                        ET.SubElement(root,tag).text = str(instructions[tag_index][1])        
                else:
                    print('oh no')
            elif type(tag) is tuple:
                parent = ET.SubElement(root,tag[0])
                if tag[1] == 's':
                    #this is a very bad way of removing tags as not always the end tag is removed 
                    if len(tag[2]) == len(instructions[tag_index]):
                        ObjToXML(parent,tag[2],instructions[tag_index])
                    else:
                        ObjToXML(parent,tag[2][:-(len(tag[2])-len(instructions[tag_index]))],instructions[tag_index])
                elif tag[1] == 'c':
                    for choice in tag[2]:
                        if tag[0] == 'intensity' or tag[0] == 'percentageHeartRate':
                            #idk what i didnt finish here
                            #print(parent,[choice],[instructions[tag_index]])
                            pass
                        if instructions[tag_index][0] == choice or instructions[tag_index][0] == choice[0]:
                            ObjToXML(parent,[choice],[instructions[tag_index][1]]) 
        

def XMLToObj(node,curr):
    '''Takes XML input and outputs objects for the contents'''
    curr.append(node.tag)
    if len(node.findall('*')) > 1:
        curr.append([])
        for child in node:            
            curr[-1].append(XMLToObj(child,[]))
        return tuple(curr)
    elif len(node.findall('*')) > 0:
        for child in node:            
            curr.append(XMLToObj(child,[]))
        return tuple(curr)
    else:
        curr.append(node.text)
        return tuple(curr)
    
def nodeToDict(node):
    '''takes XML node and return dictionary of elements and list of instructions classse'''
    data = []
    instructions = []
    for child in node:
        if child.tag == 'instruction':
            instructions.append(XMLToClass(child))
        else:
            data.append(XMLToObj(child,[]))
    return {tup[0]:tup[1] for tup in data},instructions
    
def XMLToClass(node):
    '''takes XML input and outputs class of the contents'''

    instType = node.findall('*')
    
    if len(instType) > 1:
        instDict,instructions = nodeToDict(node)
        return Instruction(**instDict)
    else:
        instDict,instructions = nodeToDict(instType[0])
        if instType[0].tag == 'repetition':
            return Repetition(**instDict,instructions=instructions)
        elif instType[0].tag == 'continue':
            return Continue(**instDict,instructions=instructions)
        elif instType[0].tag == 'pyramid':
            return Pyramid(**instDict,instructions=instructions)


def readXML(filename):
    '''Parses Xml file to Python Classes'''
    tree = ET.parse(filename)
    root = tree.getroot()
    if root.tag == 'program':
        programDict,instructions = nodeToDict(root)
        return Program(**programDict,instructions=instructions)
    else:
        return XMLToClass(root)

def writeXML(filename,node):
    '''converts objects to XML in specified file
        takes filename as input'''
    
    tree = classToXML(node)
    tree.write('pythonXMLtest\\'+filename)

class Program:
    '''Defines a program'''

    TAG_ORDER = ['title',('author','s',['firstName','lastName','email']), 'programDescription', 'poolLength', 'lengthUnit','instructions']


    def __init__(self,title = None,author = [None,None,None],programDescription = None,poolLength ='25',lengthUnit = 'meter',swiMLVersion=1.1,instructions = []):
        '''program initialiser function
            with specified program data 
            as well as all instructions for the program
        '''
        self.title = title
        self.author = author 
        self.programDescription = programDescription
        self.poolLength = poolLength
        self.lengthUnit = lengthUnit
        self.swiMLVersion = swiMLVersion
        self.instructions = instructions
        
    def __str__(self):
        '''returns string for program data 
        adds each string of all the instructions contained within the program 
        using each individual to string function 
        '''
        title_string = f'\n{self.title}\n{self.author[0][1]} {self.author[1][1]}\n{self.programDescription}\n{self.poolLength} {self.lengthUnit} pool\n'
        instructions_string = '\n'.join([str(child) for child in self.instructions])
        return title_string+instructions_string+'\n'
    

    def add(self,instruction=None,index=0):
        '''adds instruction to specified index or end of program if unspecified'''
        if index > len(self.instructions):
            index = 0
        if type(instruction) is Instruction:
            if index == 0:
                self.instructions.append(instruction)
            else:
                self.instructions.insert(index-1,instruction)
        else:
            print('invalid instruciton input')

        print(self)

class Instruction:
    '''Defines a basic instruction'''

    TAG_ORDER = INSTRUCTION_GROUP

    def __init__(self,length=None,rest=None,intensity=None,stroke=None,breath=None,underwater=None,equipment=[],instructionDescription=None):
        '''Initialises an instruction instance and defines all attributes'''
        self.length = length
        self.rest = rest
        self.intensity = intensity
        self.stroke = stroke
        self.breath = breath
        self.underwater = underwater
        self.equipment = equipment
        self.instructionDescription = instructionDescription
        self.inherited = []

    def __str__(self):
        '''returns a string for an instruction object that can easily be read'''
        rest = '' if self.rest == None else f'on {to_time(self.rest[1])}' if self.rest[0] == 'sinceStart' else f' take {to_time(self.rest[1])} rest' if self.rest[0] == 'afterStop' else f'{to_time(self.rest[1])}' if self.rest[0] == 'sinceLastRest' else f'{self.rest[1]} in First out'
        underwater = 'underwater\n' if self.underwater == True else ''
        equipment = ', '.join(self.equipment)[:-2]+'\n' if len(self.equipment) > 0 and self.equipment != None else ''
        if self.intensity != None:
            if type(self.intensity) is tuple:
                intensity =  f'{self.intensity[1][1]}{"%" if self.intensity[1][0] == "percentageEffort" else "% of max HR" if self.intensity[1][0] == "percentageHeartRate" else ""}\n'
            else:
                intensity =  f'Start: {self.intensity[1][1]}{"%" if self.intensity[1][1] == "percentageEffort" else "% of max HR" if self.intensity[1][1] == "percentageHeartRate" else ""} \n End:{self.intensity[2][1]}{"%" if self.intensity[2][0] == "percentageEffort" else "% of max HR" if self.intensity[2][0] == "percentageHeartRate" else ""}\n'
        else:
            intensity = ''
        
        breath = f'Breathing every {self.breath}\n' if self.breath != None else ''
        #need to get length units in here somehow
        length ='' if self.length == None else f'{self.length[1]} Laps' if self.length[0] == 'lengthAsLaps' else f'{self.length[1]} meters' if self.length[0] == 'lengthAsDistance' else f'Swim for {self.length[1]}'
        instructionDescription = self.instructionDescription if self.instructionDescription != None else ''
        stroke = '' if self.stroke == None else self.stroke[1] if self.stroke[0] == 'standardStroke' else f'{self.stroke[1][1][1]} drill {self.stroke[1][0][1]}' if self.stroke[0] == 'drill' else self.stroke[1][1]
        inherit = '' if len(self.inherited) == 0 else self.inherited
        line1 = f'\n{length} {stroke} {rest} '
        line2 = f'\n{underwater}{equipment}{intensity}{breath}{instructionDescription}{inherit}'
        line1 = line1 if len(line1) > 0 else ''
        line2 = line2 if len(line2) > 0 else ''
        return line1 + line2 



class Repetition:
    '''Defines a repetition'''

    TAG_ORDER = ['repetitionCount','simplify','repetitionDescription']+INSTRUCTION_GROUP+['instructions']

    def __init__(self,repetitionCount=1,simplify=False,repetitionDescription = None,length=None,rest=None,intensity=None,stroke=None,breath=None,underwater=None,equipment=[],instructions=[]):
        '''create repetition'''
        self.simplify = simplify
        self.repetitionCount = repetitionCount
        if simplify == True:
            self.simpRep = simplify_repetition(instructions,repetitionCount)
        self.repetitionDescription = repetitionDescription
        self.length = length
        self.rest = rest
        self.intensity = intensity
        self.stroke = stroke
        self.breath = breath
        self.underwater = underwater
        self.equipment = equipment
        self.instructionDescription = None
        self.instructions = instructions
        basicInsts = basicInstructions(instructions)
        for inst in basicInsts:
            for tag in self.TAG_ORDER[3:-2]:
                tag = tag if type(tag) is str else tag[0]
                if getattr(inst[0],tag) == None and getattr(self,tag) != None and all([getattr(parent,tag) == None for parent in inst[1][1:]]):
                    setattr(inst[0],tag,getattr(self,tag))
                    inst[0].inherited.append(tag)

    def __str__(self):
        '''returns string for repetition'''
        return_list =''
        #return_string = ''
        instructions_string = '\n'.join(map(str,self.instructions))
        instructions = str(instructions_string).split('\n')
        for i,line in enumerate(instructions[1:]):
            if i+1 == (len(instructions)+1)//2 and self.repetitionCount != 1:
                return_list += (f'{self.repetitionCount}x | {line}\n')
            else:
                return_list += (f'   | {line}\n')

        if self.simplify == True:
            return f'\n{self.simpRep} swim as\n'+return_list[:-1]+'\n'
        else:
            return '\n'+return_list[:-1]+'\n'
    
        
    
    def add(self,instruction=None,index=0):
        '''adds instruction to specified index or end of repetition if unspecified'''
        if index > len(self.instructions):
            index = 0
        if type(instruction) is Instruction:
            if index == 0:
                self.instructions.append(instruction)
            else:
                self.instructions.insert(index-1,instruction)
        else:
            print('invalid instruciton input')

        print(self)
    
class Continue:
    '''Defines a continuation'''

    TAG_ORDER = ['instructions']

    def __init__(self,length=None,rest=None,intensity=None,stroke=None,breath=None,underwater=None,equipment=[],instructions=[]):
        '''create continue'''
        
        self.length = length
        self.rest = rest
        self.intensity = intensity
        self.stroke = stroke
        self.breath = breath
        self.underwater = underwater
        self.equipment = equipment
        self.instructionDescription = None
        self.instructions = instructions
        basicInsts = basicInstructions(instructions)
        for inst in basicInsts:
            if inst[0].length == None and self.length != None and all([parent.length == None for parent in inst[1][1:]]):
                inst[0].length = self.length
                inst[0].inherited.append('length')
        self.totalLength = get_total_length(instructions)
    def __str__(self):
        '''returns string for continue'''
        return_list =''
        #return_string = ''
        instructions_string = '\n'.join(map(str,self.instructions))
        instructions = str(instructions_string).split('\n')
        for i,line in enumerate(instructions[1:]):
            return_list += (f'   | {line}\n')

        return f'\n{self.totalLength} swim as\n'+return_list[:-2]+'\n'
    
    def add(self,instruction=None,index=0):
        '''adds instruction to specified index or end of continue if unspecified'''
        if index > len(self.instructions):
            index = 0
        if type(instruction) is Instruction:
            if index == 0:
                self.instructions.append(instruction)
            else:
                self.instructions.insert(index-1,instruction)
        else:
            print('invalid instruciton input')

        print(self)

class Pyramid:
    '''Defines a pyramid'''
    
    TAG_ORDER = ['startLength','stopLength','increment','lengthUnit','instructions']
    
    def __init__(self,startLength,stopLength,increment,lengthUnit,length=None,rest=None,intensity=None,stroke=None,breath=None,underwater=None,equipment=[],instructions=[]):
        '''create repetition'''
        self.startLength = startLength
        self.stopLength = stopLength
        self.increment = increment
        self.lengthUnit = lengthUnit
        self.length = length
        self.rest = rest
        self.intensity = intensity
        self.stroke = stroke
        self.breath = breath
        self.underwater = underwater
        self.equipment = equipment
        self.instructions = instructions

    def __str__(self):
        '''returns string for repetition'''
        outinstructions = []
        length = self.startLength
        while length <= self.stopLength:
            inst = self.instructions[0]
            setattr(inst,'length',('lengthAsDistance',length))
            outinstructions.append(str(inst))
            length += self.increment
        length -= 2*self.increment
        while length >= self.startLength:
            inst = self.instructions[0]
            setattr(inst,'length',('lengthAsDistance',length))
            outinstructions.append(str(inst))
            length -= self.increment
        rinstructions = '\n'.join([f'   | {line.strip()}' for line in outinstructions])
        return '\n  Pyramid\n'+str(rinstructions)+'\n'
    

