# swiML

![logo swiML](https://bartneck.github.io/swiML/swiMLLogoGradient.png)

A project to formalise swimming training programs using XML.

The goal of this project is to develop a communication standard for swim training programs that can be used to exchange training programs between web services, apps, and fitness trackers. While there are some standards available for loggin your exercises, none focus on what you want to swim.

Each trainer has his/her own taxonomy and nomenclatures for the various exercises. The Swimming Markup Lanuguage (swiML) will provide a standard for naming. The goal is to also allow for customisations to accomodate local preferences. In addition, it features a transformation of turing valid XML files into beautifuly formatted instructions that can be printed or displayed on devices.

We recommend an XML authoring tool, such as [Oxygen Author](https://www.oxygenxml.com/xml_author.html) to write, validate and transform swiML documents. Alternatively, there are XML plugins for [Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-xml) and [Eclipse](https://marketplace.eclipse.org/content/eclipse-xml-editors-and-tools). You can use the swiML Schema (swiML.xsd) to validate your swiML file. You can then use the XSLT (swiML.xsl) to tranformation the swiML XML to HTML. 

We also developed a Python library that you can use to code your swimming program. It is available as a package over at [PyPi](https://pypi.org/project/swiml_python_xml/). 

A first test implementation showing the [training sessions](https://bartneck.github.io/swiML/jasiMasters/) for the [Jasi Masters](https://jasimasters.org.nz) swimming club in Christchurch, New Zealand is available.

Christoph Bartneck
