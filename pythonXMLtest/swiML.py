import xmlToPyOutput as OUT
import xml.etree.ElementTree as ET

FILENAME = ''
LOAD_VARS = ['title','author','programDescription','poolLength','lengthUnit']
AUTHOR_VARS = ['firstName','lastName','email']
INSTRUCTION_VARS=['length','rest','intensity','stroke','breath','underwater','equipment','instructionDescription']

def edit_tag(root,tag,child):

    act_tag = root.find(tag)
    if act_tag != None:
        if tag == 'author':
            if len(act_tag) > 0:
                for i,name in enumerate(child):
                    act_tag[i].text = name
            else:
                for i,name in enumerate(child):
                    ET.SubElement(act_tag,AUTHOR_VARS[i]).text = name
        else:
            act_tag.text = child
    else:
        return

def sub_tag(root,tag,child):
    if type(child) is dict:
        parent = ET.SubElement(root,tag)
        for element in child:
            sub_tag(parent,element,child[element])
    
    elif type(child) is list:
            
        for i,name in enumerate(child):
            ET.SubElement(root,AUTHOR_VARS[i]).text = name
    else:
        ET.SubElement(root,tag).text = str(child)




def load(filename,title = None,author = [None,None],programDescription = None,poolLength ='25',lengthUnit = 'meter'):
    global FILENAME 
    FILENAME = filename
    tree = ET.parse('pythonXMLtest\\'+filename+'.xml')
    root = tree.getroot()

    program_data = [title,author,programDescription,poolLength,lengthUnit]
    
    for index,point in enumerate(program_data):
        edit_tag(root,LOAD_VARS[index],point)
    OUT.print_program(root)
    tree = ET.ElementTree(root)
    tree.write('pythonXMLtest\\'+filename+'.xml')
    
    
def new(filename,title = None,author = None,programDescription = None,poolLength ='25',lengthUnit = 'meters'):

    file = open('pythonXMLtest\\'+filename+'.xml','x')
    global FILENAME 
    FILENAME = filename
    root = ET.Element('program')

    program_data = [title,author,programDescription,poolLength,lengthUnit]
    
    for index,point in enumerate(program_data):
        sub_tag(root,LOAD_VARS[index],point)
    
    OUT.print_program(root)
    tree = ET.ElementTree(root)
    tree.write('pythonXMLtest\\'+filename+'.xml')

def instruction(length,rest = 'none',intensity='',stroke='freestyle',breath='Any',underwater=False,equipment=[],instructionDescription=''):
    '''new instruction'''
    filename = FILENAME
    tree = ET.parse('pythonXMLtest\\'+filename+'.xml')
    root = tree.getroot()

    instruction_data=[length,rest,intensity,stroke,breath,underwater,equipment,instructionDescription]
    
    instruction_node = ET.SubElement(root,'instruction')

    for index,element in enumerate(instruction_data):
        sub_tag(instruction_node,INSTRUCTION_VARS[index],element)
    ET.dump(root)
    OUT.print_program(root)

def close():
    '''close file'''
    global FILENAME
    FILENAME = ''