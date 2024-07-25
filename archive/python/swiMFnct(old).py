#import xmlToPyOutput as OUT
import xml.etree.ElementTree as ET

FILENAME = ''
LOAD_VARS = ['title','author','programDescription','poolLength','lengthUnit']
AUTHOR_VARS = ['firstName','lastName','email']
INSTRUCTION_VARS=[['lengthAsDistance','lengthAsTime','lengthAsLaps'],'rest','intensity','stroke','breath','underwater','equipment','instructionDescription']
REPETITION_VARS = ['repetitionCount','repetitionDescription','instruction']

def edit_tag(root,tag,child):
    act_tag = root.find(tag)
    if act_tag != None:
        if tag == 'author':
            for i,name in enumerate(child):
                act_tag[i].text = name
        else:
            act_tag.text = child
    else:
        return

def sub_tag(root,tag,child):
    if type(child) is dict:
        if type(tag) is list:
            for tag_choice in tag:
                print(list(child.keys()))
                if tag_choice == list(child.keys())[0]:
                    ET.SubElement(root,tag_choice).text = str(child[tag_choice])
        else:
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
    #OUT.print_program(root)
    tree = ET.ElementTree(root)
    tree.write('pythonXMLtest\\'+filename+'.xml')
    
def test_load(filename,title = None,author = [None,None],programDescription = None,poolLength ='25',lengthUnit = 'meter'):
    global FILENAME 
    FILENAME = filename
    open('pythonXMLtest\\'+filename+'.xml', 'w').close()
    open('pythonXMLtest\\'+filename+'.xml','w')
    root = ET.Element('program')

    program_data = [title,author,programDescription,poolLength,lengthUnit]
    
    for index,point in enumerate(program_data):
        sub_tag(root,LOAD_VARS[index],point)
    
    #OUT.print_program(root)
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
    
    #OUT.print_program(root)
    tree = ET.ElementTree(root)
    tree.write('pythonXMLtest\\'+filename+'.xml')

def instruction(instruction_data,root=None):
    '''new instruction'''
    tree = ET.parse('pythonXMLtest\\'+FILENAME+'.xml')
    if not root:
        root = tree.getroot()
    
    instruction_node = ET.SubElement(root,'instruction')

    for index,element in enumerate(instruction_data):
        sub_tag(instruction_node,INSTRUCTION_VARS[index],element)
    #ET.dump(root)
    #OUT.print_program(root)
    #tree.write('pythonXMLtest\\'+FILENAME+'.xml')

def repetition(instruction_data,repetition=1,repetitionDescription=''):
    '''A repetition of instructions'''
    tree = ET.parse('pythonXMLtest\\'+FILENAME+'.xml')
    root = tree.getroot()
    repetition_data = [repetition,repetitionDescription]

    instruction_node = ET.SubElement(root,'instruction')
    repetition_node = ET.SubElement(instruction_node,'repetition')

    for index,element in enumerate(repetition_data):
        sub_tag(repetition_node,REPETITION_VARS[index],element)
    #ET.dump(root)
    for instruc in instruction_data:
        instruction(instruc,root=repetition_node)
    ET.dump(root)
    #OUT.print_program(root)
    tree.write('pythonXMLtest\\'+FILENAME+'.xml')



def close():
    '''close file'''
    global FILENAME
    FILENAME = ''