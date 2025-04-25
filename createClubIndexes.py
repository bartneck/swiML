import os
import xml.etree.ElementTree as ET
from datetime import datetime

def extract_date(filename):
    """Extract date (YYYY-MM-DD) and session ID from filename."""
    try:
        base_name = os.path.splitext(filename)[0] 
        date_part = base_name[-10:-2] 
        date = f"{date_part[:4]}-{date_part[4:6]}-{date_part[6:8]}"
        session_id = base_name[-2:]
        return date,session_id
    except Exception:
        return None, None

def parse_program_description(xml_file):
    """Extract program description from an XML file."""
    try:
        tree = ET.parse(xml_file)
        root = tree.getroot()
        desc = root.find("programDescription")
        return desc.text.strip() if desc is not None and desc.text else ""
    except ET.ParseError:
        return ""

def generate_swim_training_xml(folder, club_name,pool_name, club_url, output_file):
    """Generate an XML document following the specified schema."""
    ns = "https://github.com/bartneck/swiML"
    root = ET.Element("swimTraining", xmlns=ns)
    ET.SubElement(root, "clubName").text = club_name
    ET.SubElement(root, "clubURL").text = club_url

    for filename in sorted(os.listdir(folder)):
        if filename.lower().endswith(".xml") and "index" not in filename.lower():
            date,session_id = extract_date(filename)
            if date and session_id:
                session_elem = ET.SubElement(root, "session")
                ET.SubElement(session_elem, "date").text = date
                ET.SubElement(session_elem, "id").text = str(int(session_id))
                ET.SubElement(session_elem, "pool").text = pool_name 

    tree = ET.ElementTree(root)
    ET.indent(tree)
    output_path = os.path.join(folder, output_file)
    tree.write(output_path, encoding="UTF-8", xml_declaration=True)


generate_swim_training_xml("jasiMasters2", "Jasi Masters","Jellie Park", "https://jasimasters.org.nz", "index.xml")