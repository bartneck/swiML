import xml.etree.ElementTree as ET

LOAD_VARS = ['title','author','programDescription','poolLength','lengthUnit']
AUTHOR_VARS = ['firstName','lastName','email']
INSTRUCTION_VARS=[['lengthAsDistance','lengthAsTime','lengthAsLaps'],'rest','intensity','stroke','breath','underwater','equipment','instructionDescription']
REPETITION_VARS = ['repetitionCount','repetitionDescription','instruction']

def to_time(time):
    '''converts to unit time'''
    return (f'{time[2:3]}:{time[4:6]}')

def classToXML(root,self):
    if type(self) is Repetition:
        root = ET.SubElement(root,'repetition')
    children = [getattr(self,attr if type(attr) is str else attr[0]) for attr in self.TAG_ORDER]
    tags = self.TAG_ORDER
    
    expandXML(root,tags,children)

def expandXML(root,tags,children):
    'converts list of tags and children to XML'
    print(tags,children)
    for tag_index,tag in enumerate(tags):
        if type(tag) is str:
            if children[tag_index] == None:
                pass
            elif type(children[tag_index]) is str or type(children[tag_index]) is int or type(children[tag_index]) is bool:
                ET.SubElement(root,tag).text = str(children[tag_index])
            elif type(children[tag_index]) is list:
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
    '''program'''

    TAG_ORDER = ['title',('author','s',['firstName','lastName','email']), 'programDescription', 'poollength', 'lengthUnit',  'children']


    def __init__(self,title = None,author = [None,None,None],programDescription = None,poolLength ='25',lengthUnit = 'meter',children = []):
        '''new program'''
        self.title = title
        self.author = author 
        self.programDescription = programDescription
        self.poollength = poolLength
        self.lengthUnit = lengthUnit
        self.children = children 

    def __str__(self):
        '''display program to string'''
        
        title_string = f'\n{self.title}\n{self.author[0]} {self.author[1]}\n{self.programDescription}\n{self.poollength} {self.lengthUnit} pool\n'
        
        return title_string+str(self.children)+'\n'
    
    def toXml(self,filename):
        '''converts objects to XML in specified file'''

        global FILENAME 
        FILENAME = filename
        root = ET.Element('program')
        classToXML(root,self)
        tree = ET.ElementTree(root)
        tree.write('pythonXMLtest\\sample.xml')

class Instruction:
    '''instruction class'''

    TAG_ORDER = [('length','c',['lengthAsDistance','lengthAsTime','lengthAsLaps']),
                 ('rest','c',['afterStop','sinceStart','sinceLastRest']),
                 ('intensity','c',[('staticIntensity','c',['percentageEffort','zone','percentageHeartRate']),('dynamicAcross','s',[('startIntensity','c',['percentageEffort','zone','percentageHeartRate']),('stopIntensity','c',['percentageEffort','zone','percentageHeartRate'])])]),
                 ('stroke','c',['standardStroke',('kicking','c',['standardKick',('other','s',['orientation','legMovement'])]),('drill','s',['drillName','drillStroke'])]),
                 'breath',
                 'underwater',
                 'equipment',
                 'instructionDescription']

    def __init__(self,length,rest=None,intensity=None,stroke=None,breath=None,underwater=False,equipment=None,instructionDescription=None):
        '''create instruction'''
        self.length = length
        self.rest = rest
        self.intensity = intensity
        self.stroke = stroke
        self.breath = breath
        self.underwater = underwater
        self.equipment = equipment
        self.instructionDescription = instructionDescription

    def __str__(self):
        '''display instruction info'''

        
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
        return f'\nNew Instruction\n{self.length[1]} {self.stroke[1]} {rest} \n{underwater}{equipment}{intensity}{breath}{self.instructionDescription}'

class Repetition:
    '''repetition class'''

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
        print(self.children)
        children_string = '\n'.join(map(str,self.children))
        children = str(children_string).split('\n')
        for i,line in enumerate(children):
            if i == (len(children))//2:
                return_list += (f'{self.repetitionCount}x | {line}\n')
            else:
                return_list += (f'   | {line}\n')
        return_list += ('   | \n')

        return return_list