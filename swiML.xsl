<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:myData="http://www.bartneck.de" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:sw="https://github.com/bartneck/swiML">

    <!-- version 2.3 -->
    
    <!-- global variables for space calculation -->
    
    <xsl:variable name="gloalRoot" select="/"/>
    
    <!-- variable for length of distance tags in any instruction -->
    <xsl:variable name="instLengths" as="element()*">

        <!-- check if there are any distance tags present -->
        <xsl:choose>
            <xsl:when test="//sw:length/sw:lengthAsDistance[not(../../sw:excludeAlign[text() = 'true'])] or
                //sw:length/sw:lengthAsLaps[not(../../sw:excludeAlign[text() = 'true'])] or
                //sw:length/sw:lengthAsTime[not(../../sw:excludeAlign[text() = 'true'])]">
                <!-- there are distance tags so the result is not 0 -->
                <!-- select each type of tag and add data to array -->
                <!-- this data is the length of the string, section of tag, what parents the tag has and, unique location of tag -->
                <!-- for each type of distance tag this is repeated and added to resultant array -->

                <!-- length as distance tags-->
                <xsl:if test="//sw:length/sw:lengthAsDistance[not(../../sw:excludeAlign[text() = 'true'])]">
                    <xsl:for-each select="//sw:length/sw:lengthAsDistance[not(../../sw:excludeAlign[text() = 'true'])]">
                        <Item>
                            <Length><xsl:value-of select="string-length(myData:number(.))"/></Length>
                            <Section><xsl:value-of select="myData:section(.)"/></Section>
                            <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                            <Location><xsl:value-of select="myData:location(.)"/></Location>
                        </Item>
                    </xsl:for-each>
                </xsl:if>
                <!-- length as laps tags -->
                    <xsl:for-each select="//sw:length/sw:lengthAsLaps[not(../../sw:excludeAlign[text() = 'true'])]">
                        <Item>
                            <Length><xsl:value-of select="string-length(myData:number(.))"/></Length>
                            <Section><xsl:value-of select="myData:section(.)"/></Section>
                            <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                            <Location><xsl:value-of select="myData:location(.)"/></Location>
                        </Item>
                    </xsl:for-each>

                <!-- length as time tags -->
                <xsl:if test="//sw:length/sw:lengthAsTime[not(../../sw:excludeAlign[text() = 'true'])]">
                    <xsl:for-each select="//sw:length/sw:lengthAsTime[not(../../sw:excludeAlign[text() = 'true'])]">
                        <Item>
                            <Length><xsl:value-of select="string-length(concat(myData:number(minutes-from-duration(.)), ':', myData:number(format-number(seconds-from-duration(.), '00'))))" /></Length>
                            <Section><xsl:value-of select="myData:section(.)"/></Section>
                            <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                            <Location><xsl:value-of select="myData:location(.)"/></Location>
                        </Item>
                    </xsl:for-each>
                </xsl:if>

            </xsl:when>
            <!-- if no distance tags present return 0 -->
            <xsl:otherwise><Item>0</Item></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- this function is repeated four times when i only really need one -> fix it (instNodes, contNodes, simpNodes, repNodes are all identical)  note > not >= in instNodes -->
    <!-- helper function for returning lengths within groupings of 10 characters -->
    <!-- given array of nodes from instLengths will return each location with length given as max length within it group of 10 characters  -->
    <xsl:template name="instNodes">

        <!-- uneeded paramater? its unused -->
        <xsl:param name="nodes"/>

        <!-- array of nodes to adjust lengths -->
        <xsl:param name="element"/>
        
        <!-- only run function if there are still elements left in the array -->
        <xsl:if test="$element">
            <!-- for elements within 10 characters of the first element in the array -->
            <xsl:for-each select="$element[./*[1] > max($element/*[1])-9 ]">

                <!-- return location of element and the max length of node within 10 characters-->
                <Item>
                    <Location><xsl:value-of select="./*[4]"/></Location>
                    <Length><xsl:value-of select="max($element/*[1])"/></Length>
                </Item>
            </xsl:for-each>
            
            <!-- recursively call function with any elements that were more than 10 characters longer than the first in the elements array-->
            <xsl:call-template name="instNodes">
                <xsl:with-param name="nodes" select="$nodes"/>
                <xsl:with-param name="element" select="$element[max($element/*[1]) > ./*[1]+9 ]"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- variable for the lengths each instruction distance node needs to be -->
    <!-- this variable is used for display -->
    <xsl:variable name="maxInstLengths" as="element()*">

        <!-- sort all distance nodes by what section they are in -->
        <xsl:for-each-group select="$instLengths" group-by="./*[2]">
            <xsl:sort select='./*[2]' order="ascending" data-type="number" />

            <!-- sort all nodes again this time by what parents the have -->
            <!-- this is stored as a numerical value so can be sorted so the nodes with the same parents will have the same lengths-->
            <!-- NOTE this doensnt group the parents properly, e.g. if same parents but one parent is in different group then they will try to align but be off by 10 cos their not aligned -->
            <xsl:for-each-group select="$instLengths" group-by="./*[3][../Section = current-grouping-key()]">

                <!-- call helper function for each set of nodes that have the same section and parents -->
                <xsl:call-template name="instNodes">
                    <xsl:with-param name="nodes" select="."/>
                    <xsl:with-param name="element" select="current-group()"/>
                </xsl:call-template>
            </xsl:for-each-group> 
        </xsl:for-each-group>
    </xsl:variable>
    

    <!-- variable for length of continue tags -->
    <xsl:variable name="contLengths" as="element()*">
        <xsl:choose>
        
            <!-- check if there are any continue tags in the program-->
            <xsl:when test="//sw:continue[not(../sw:excludeAlign[text() = 'true'])]">
                <!-- check if simplify tag is still needed here cos i dont think it is -->
                <xsl:for-each select="//sw:continue[not(../sw:excludeAlign[text() = 'true'])]">

                    <!-- calculate sum of any inst tags that are top level in the continue -->
                    <xsl:variable name="contInstLength">
                        <xsl:call-template name="sumItems">
                            <xsl:with-param name="nodeSet" select="./*[not(name(.) = 'instruction')]"/>
                        </xsl:call-template>
                    </xsl:variable>

                    <!-- add data for each continue tag to the array -->
                    <!-- this data is the length of each continue, its section, its parents and its unique location -->
                    <Item>
                        <xsl:choose>
                            <!-- different length is given when continue is child of a repetition and only has 1 child instruction as it displays differently (extra addition of repetition count)  this could change-->
                            <!-- length is the length of calculated length node, 3 characters for as, length of any top level instruction tags and the extra spaces they need -->

                            <xsl:when test="../../../sw:repetition/sw:simplify[text()='true']">
                                <Length><xsl:value-of select="4+$contInstLength+count(./*[not(name(.) = 'instruction' or name(.) = 'length' or name(.) = 'excludeAlignContinue' or name(.) = 'continueLength' )])"/></Length>
                            </xsl:when>
                            <xsl:when test="every $node in .//sw:length satisfies $node/sw:lengthAsLaps">
                                <Length><xsl:value-of select="string-length(string(myData:number(myData:contLength(.))))+7+$contInstLength+count(./*[not(name(.) = 'instruction' or name(.) = 'length' or name(.) = 'excludeAlignContinue' or name(.) = 'continueLength' )])"/> </Length>
                            </xsl:when>
                            <xsl:otherwise>
                                <Length><xsl:value-of select="string-length(string(myData:number(myData:contLength(.))))+3+$contInstLength+count(./*[not(name(.) = 'instruction' or name(.) = 'length' or name(.) = 'excludeAlignContinue' or name(.) = 'continueLength' )])"/> </Length>
                            </xsl:otherwise>
                        </xsl:choose>
                        <Section><xsl:value-of select="myData:section(.)"/></Section>
                        <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                        <Location><xsl:value-of select="myData:location(.)"/></Location>
                    </Item>

                </xsl:for-each>
            </xsl:when>
            <!-- return array with 0 if no continue tags in the program -->
            <xsl:otherwise>
                <Item>0</Item>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>


    <!-- helper function for returning lengths within groupings of 10 characters -->
    <!-- given array of nodes from contLengths will return each location with length given as max length within it group of 10 characters  -->
    <xsl:template name="contNodes">

        <!-- uneeded paramater? its unused -->
        <xsl:param name="nodes"/>

        <!-- array of nodes to adjust lengths -->
        <xsl:param name="element"/>
        <!-- only run function if there are still elements left in the array -->
        <xsl:if test="$element">
            <!-- for elements within 10 characters of the first element in the array -->
            <xsl:for-each select="$element[./*[1] >= max($element/*[1])-9 ]">

                <!-- return location of element and the max length of node within 10 characters-->
                <Item>
                    <Location><xsl:value-of select="./*[4]"/></Location>
                    <Length><xsl:value-of select="max($element/*[1])"/></Length>
                </Item>
            </xsl:for-each>
            
            <!-- recursively call function with any elements that were more than 10 characters longer than the first in the elements array-->
            <xsl:call-template name="contNodes">
                <xsl:with-param name="nodes" select="$nodes"/>
                <xsl:with-param name="element" select="$element[max($element/*[1]) > ./*[1]+9 ]"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- variable for the lengths each continue distance node needs to be -->
    <!-- this variable is used for display -->
    <xsl:variable name="maxContLengths" as="element()*">

        <!-- sort all distance nodes by what section they are in -->
        <xsl:for-each-group select="$contLengths" group-by="./*[2]">
            <xsl:sort select='./*[2]' order="ascending" data-type="number" />

            <!-- sort all nodes again this time by what parents the have -->
            <!-- this is stored as a numerical value so can be sorted so the nodes with the same parents will have the same lengths-->
            <xsl:for-each-group select="$contLengths" group-by="./*[3][../Section = current-grouping-key()]">

                <!-- call helper function for each set of nodes that have the same section and parents -->
                <xsl:call-template name="contNodes">
                    <xsl:with-param name="nodes" select="."/>
                    <xsl:with-param name="element" select="current-group()"/>
                </xsl:call-template>

            </xsl:for-each-group> 
        </xsl:for-each-group>
    </xsl:variable>

    <!-- variable for length of simplifying repetition tags -->
    <xsl:variable name="simpLengths" as="element()*">
        <xsl:choose>

            <!-- check if there are any simplifying tags in the program-->
            <xsl:when test=" //sw:repetition[./sw:simplify[text()='true'] and not(../sw:excludeAlign[text() = 'true'])]">
            
                <xsl:for-each select="//sw:repetition[./sw:simplify[text()='true'] and not(../sw:excludeAlign[text() = 'true'])]">

                    <!-- calculate sum of any inst tags that are top level in the simplifying repetition -->
                    <xsl:variable name="simpInstLength">
                        <xsl:call-template name="sumItems">
                            <xsl:with-param name="nodeSet" select="./*[not(name(.) = 'instruction' or name(.) = 'simplify')]"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="isLaps">
                        <xsl:choose>
                            <xsl:when test="(./descendant-or-self::sw:lengthAsLaps)">5</xsl:when>
                            <xsl:otherwise>0</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <!-- add data for each simplifying tag to the array -->
                    <!-- this data is the length of each continue, its section, its parents and its unique location -->
                    <Item>
                        <!-- length is the length of calculated length node, 6 characters for as and multiplier symbol, length of any top level instruction tags and the extra spaces they need -->
                        <Length><xsl:value-of select="string-length(string(myData:number(myData:simpRep(.))))+string-length(string(myData:number(myData:firstInst(.))))+$isLaps+6+$simpInstLength+count(./*[not(name(.) = 'instruction' or name(.) = 'repetitionCount' or name(.) = 'simplify' or name(.) = 'length' or name(.) = 'excludeAlignRepetition' )])"/></Length>
                        <Section><xsl:value-of select="myData:section(.)"/></Section>
                        <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                        <Location><xsl:value-of select="myData:location(.)"/></Location>
                    </Item>

                </xsl:for-each>
            </xsl:when>

            <!-- return array with 0 if no simplifying repetititon tags in the program -->
            <xsl:otherwise>
                <Item>0</Item>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- helper function for returning lengths within groupings of 10 characters -->
    <!-- given array of nodes from simpLengths will return each location with length given as max length within it group of 10 characters  -->
    <xsl:template name="simpNodes">

        <!-- uneeded paramater? its unused -->
        <xsl:param name="nodes"/>

        <!-- array of nodes to adjust lengths -->
        <xsl:param name="element"/>
        <!-- only run function if there are still elements left in the array -->
        <xsl:if test="$element">
            <!-- for elements within 10 characters of the first element in the array -->
            <xsl:for-each select="$element[./*[1] >= max($element/*[1])-9 ]">

                <!-- return location of element and the max length of node within 10 characters-->
                <Item>
                    <Location><xsl:value-of select="./*[4]"/></Location>
                    <Length><xsl:value-of select="max($element/*[1])"/></Length>
                </Item>
            </xsl:for-each>
            
            <!-- recursively call function with any elements that were more than 10 characters longer than the first in the elements array-->
            <xsl:call-template name="simpNodes">
                <xsl:with-param name="nodes" select="$nodes"/>
                <xsl:with-param name="element" select="$element[max($element/*[1]) > ./*[1]+9 ]"/>
            </xsl:call-template>

        </xsl:if>
    </xsl:template>

    <!-- variable for the lengths each simplifying repetition distance node needs to be -->
    <!-- this variable is used for display -->
    <xsl:variable name="maxSimpLengths" as="element()*">

        <!-- sort all distance nodes by what section they are in -->
        <xsl:for-each-group select="$simpLengths" group-by="./*[2]">
            <xsl:sort select='./*[2]' order="ascending" data-type="number" />

            <!-- sort all nodes again this time by what parents the have -->
            <!-- this is stored as a numerical value so can be sorted so the nodes with the same parents will have the same lengths-->
            <xsl:for-each-group select="$simpLengths" group-by="./*[3][../Section = current-grouping-key()]">

                <!-- call helper function for each set of nodes that have the same section and parents -->
                <xsl:call-template name="simpNodes">
                    <xsl:with-param name="nodes" select="."/>
                    <xsl:with-param name="element" select="current-group()"/>
                </xsl:call-template>

            </xsl:for-each-group> 
        </xsl:for-each-group>
    </xsl:variable>
    
    <!-- variable for length of repetition tags -->
    <xsl:variable name="repLengths" as="element()*">
        <xsl:choose>

            <!-- check if there are any repetition tags in the program-->
            <xsl:when test="//sw:repetition[not(./sw:simplify[text()='true']) and not(../sw:excludeAlign[text() = 'true'])]">

                <xsl:for-each select="//sw:repetition[not(./sw:simplify[text()='true']) and not(../sw:excludeAlign[text() = 'true'])]">

                    <!-- calculate sum of any inst tags that are top level in the repetition -->
                    <xsl:variable name="repInstLength">
                        <xsl:call-template name="sumItems">
                            <xsl:with-param name="nodeSet" select="./*[not(name(.) = 'instruction' or name(.) = 'repetitionCount' or name(.) = 'simplify' )]"/>
                        </xsl:call-template>
                    </xsl:variable>

                    <!-- add data for each repetition tag to the array -->
                    <!-- this data is the length of each continue, its section, its parents and its unique location -->
                    <Item>
                        <!-- length is the length of calculated repetition count, 2 characters for multiplier symbol, length of any top level instruction tags and the extra spaces they need -->
                        <Length><xsl:value-of select="string-length(string(myData:number(number(./sw:repetitionCount))))+2+$repInstLength+count(./*[not(name(.) = 'instruction' or name(.) = 'repetitionCount' or name(.) = 'length' or name(.) = 'simplify' or name(.) = 'excludeAlignRepetition' )])"/></Length>
                        <Section><xsl:value-of select="myData:section(.)"/></Section>
                        <Parents><xsl:value-of select="myData:parents(.)"/></Parents>
                        <Location><xsl:value-of select="myData:location(.)"/></Location>
                        <Item><xsl:text>c</xsl:text></Item>
                        <Item><xsl:value-of select="$repInstLength"/></Item>
                    </Item>
                </xsl:for-each>       
            </xsl:when>

            <!-- return array with 0 if no simplifying repetititon tags in the program -->
            <xsl:otherwise>
                <Item>0</Item>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- helper function for returning lengths within groupings of 10 characters -->
    <!-- given array of nodes from repLengths will return each location with length given as max length within it group of 10 characters  -->
    <xsl:template name="repNodes">

        <!-- uneeded paramater? its unused -->
        <xsl:param name="nodes"/>

        <!-- array of nodes to adjust lengths -->
        <xsl:param name="element"/>
        <!-- only run function if there are still elements left in the array -->
        <xsl:if test="$element">
            <!-- for elements within 10 characters of the first element in the array -->
            <xsl:for-each select="$element[./*[1] >= max($element/*[1])-9 ]">

                <!-- return location of element and the max length of node within 10 characters-->
                <Item>
                    <Location><xsl:value-of select="./*[4]"/></Location>
                    <Length><xsl:value-of select="max($element/*[1])"/></Length>
                </Item>
            </xsl:for-each>
            
            <!-- recursively call function with any elements that were more than 10 characters longer than the first in the elements array-->
            <xsl:call-template name="repNodes">
                <xsl:with-param name="nodes" select="$nodes"/>
                <xsl:with-param name="element" select="$element[max($element/*[1]) > ./*[1]+9 ]"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- variable for the lengths each repetition node needs to be -->
    <!-- this variable is used for display -->
    <xsl:variable name="maxRepLengths" as="element()*">

        <!-- sort all distance nodes by what section they are in -->
        <xsl:for-each-group select="$repLengths" group-by="./*[2]">
            <xsl:sort select='./*[2]' order="ascending" data-type="number" />

            <!-- sort all nodes again this time by what parents the have -->
            <!-- this is stored as a numerical value so can be sorted so the nodes with the same parents will have the same lengths-->
            <xsl:for-each-group select="$repLengths" group-by="./*[3][../Section = current-grouping-key()]">

                <!-- call helper function for each set of nodes that have the same section and parents -->
                <xsl:call-template name="repNodes">
                    <xsl:with-param name="nodes" select="."/>
                    <xsl:with-param name="element" select="current-group()"/>
                </xsl:call-template>
            </xsl:for-each-group> 
        </xsl:for-each-group>
    </xsl:variable>
    
    <!-- helper function for adding length of instruction elements together -->
    <!-- this works by adding the translation of each of the nodes to the total length and repeating recurtsively -->
    <!-- some elements may still not work here as they have different formats, e.g drill or kick-->
    <xsl:template name="sumExtras">

        <!-- nodes param gives array of nodes to add lengths of-->
        <xsl:param name="nodes"/>

        <!-- sum of lengths, defaults to 0 when first called-->
        <xsl:param name="tempSum" select="0" />

        <xsl:choose>

        <!-- checks to see if there is another node to add-->
            <xsl:when test="not($nodes)">
                <!-- no more nodes so return counting sum of lengths-->
                <xsl:value-of select="$tempSum" />
            </xsl:when>
            <xsl:otherwise>
                <!--more nodes do add so calculate length of the current node-->
                <xsl:variable name="product">
                    <xsl:value-of select="string-length($thisDocument/xsl:stylesheet/myData:translation/term[@index = string($nodes[1])])"/>
                </xsl:variable>

                <!-- recursively call self with next node and current nodes length added to sum-->
                <xsl:call-template name="sumExtras">
                    <xsl:with-param name="nodes" select="$nodes[position() > 1]" />
                    <xsl:with-param name="tempSum" select="$tempSum + $product" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

    <!-- function returns length of all instruction element nodes given -->
    <xsl:template name="sumItems">

        <!-- nodeSet is an array of nodes which are all instruction elements-->
        <xsl:param name="nodeSet" />

        <!-- sum of lengths, defaults to 0 when first called-->
        <xsl:param name="tempSum" select="0" />
        
        <xsl:choose>

            <!-- check to see if there is another node -->
            <xsl:when test="not($nodeSet)">
                <!-- no more nodes so return the running count-->
                <xsl:value-of select="$tempSum" />
            </xsl:when>

            <xsl:otherwise>
                <!-- there is another node so find its length-->
                <!-- whatever is returned in this variable is the length of the current node-->
                <xsl:variable name="product">
                    <xsl:choose>

                        <!-- is element type is rest return length based on pre-determined formatting -->
                        <xsl:when test="name($nodeSet[1]) = 'rest'">
                            <xsl:choose>

                                <!-- finding the type of rest given -->
                                <xsl:when test="$nodeSet[1]/sw:sinceStart">
                                    <xsl:value-of select="2+string-length(concat(minutes-from-duration(./sw:sinceStart), ':', format-number(seconds-from-duration(./sw:sinceStart), '00')))"/>
                                </xsl:when>

                                <xsl:when test="$nodeSet[1]/sw:afterStop">
                                    <xsl:value-of select="1+string-length(concat(minutes-from-duration(./sw:afterStop), ':', format-number(seconds-from-duration(./sw:afterStop), '00')))"/>
                                </xsl:when>

                                <xsl:when test="$nodeSet[1]/sw:sinceLastRest">
                                    <xsl:value-of select="3+string-length(concat(minutes-from-duration(./sw:sinceLastRest), ':', format-number(seconds-from-duration(./sw:sinceLastRest), '00')))"/>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of select="8+string-length(./sw:inOut)"/>
                                </xsl:otherwise>

                            </xsl:choose>
                        </xsl:when>

                        <!-- intensity elements have pre-determined formatting-->
                        <xsl:when test="name($nodeSet[1]) = 'intensity'">
                           
                            <xsl:choose>
                                <xsl:when test="$nodeSet[1]/sw:stopIntensity">
                                    <xsl:choose>
                                        
                                        <!-- finding the type of rest given -->
                                        <xsl:when test="$nodeSet[1]/sw:startIntensity/sw:percentageEffort">
                                            <xsl:value-of select="2+string-length(string($nodeSet[1]/sw:startIntensity/*))+string-length(string($nodeSet[1]/sw:stopIntensity/*))"/>
                                        </xsl:when>
                                        
                                        <xsl:when test="$nodeSet[1]/sw:startIntensity/sw:percentageHeartRate">
                                            <xsl:value-of select="3+string-length(string($nodeSet[1]/sw:startIntensity/*))+string-length(string($nodeSet[1]/sw:stopIntensity/*))"/>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="1+string-length($thisDocument/xsl:stylesheet/myData:translation/term[@index = string($nodeSet[1]/*[1]/*[1])])+string-length($thisDocument/xsl:stylesheet/myData:translation/term[@index = string($nodeSet[1]/*[2]/*[1])])"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        
                                        <!-- finding the type of rest given -->
                                        <xsl:when test="$nodeSet[1]/sw:startIntensity/sw:percentageEffort">
                                            <xsl:value-of select="1+string-length(string($nodeSet[1]/sw:startIntensity/*))"/>
                                        </xsl:when>
                                        
                                        <xsl:when test="$nodeSet[1]/sw:startIntensity/sw:percentageHeartRate">
                                            <xsl:value-of select="2+string-length(string($nodeSet[1]/sw:startIntensity/*))"/>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="string-length($thisDocument/xsl:stylesheet/myData:translation/term[@index = string($nodeSet[1]/*[1]/*[1])])"/>
                                        </xsl:otherwise>
                                        
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>

                        </xsl:when>

                        <!-- check is remaining node is a stroke element-->
                        <xsl:when test="name($nodeSet[1]) = 'stroke'">
                            <xsl:choose>

                                <!--checking if stroke is kick/drill or standard-->
                                <xsl:when test="name($nodeSet[1]/*[1]) = 'kicking' or name($nodeSet[1]/*[1]) = 'drill'">

                                    <!-- return length of kick/drill stroke-->
                                    <xsl:variable name="strokeExtra">
                                        <xsl:call-template name="sumExtras">
                                            <xsl:with-param name="nodes" select="$nodeSet[1]//text()" />
                                        </xsl:call-template>
                                    </xsl:variable>

                                    <xsl:value-of select="$strokeExtra+2"/>

                                </xsl:when>
                                <xsl:otherwise>

                                    <!-- return length of standard stroke -->
                                    <xsl:call-template name="sumExtras">
                                        <xsl:with-param name="nodes" select="$nodeSet[1]//text()" />
                                    </xsl:call-template>

                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="name($nodeSet[1]) = 'repetitionDescription' or name($nodeSet[1]) = 'continueDescription' or name($nodeSet[1]) = 'instructionDescription' or name($nodeSet[1]) = 'pyramidDescription'">
                            <xsl:value-of select="string-length($nodeSet[1]//text())"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>

                                <!-- check if element is length -->
                                <xsl:when test="name($nodeSet[1]) != 'length'">
                                    <!-- for element types not above (not rest, intensity, stroke or length) return length of string translation-->
                                    <xsl:call-template name="sumExtras">
                                        <xsl:with-param name="nodes" select="$nodeSet[1]//text()" />
                                    </xsl:call-template>
                                </xsl:when>
                                <!-- length elements dont appear in continues or repetition as the total length is calculated separately-->
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <!-- recursively call function with next node and with addition to running count -->
                <xsl:call-template name="sumItems">
                    <xsl:with-param name="nodeSet" select="$nodeSet[position() > 1]" />
                    <xsl:with-param name="tempSum" select="$tempSum + $product" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="/">

        <!-- ============================== -->
        <!-- HTML Document -->
        <!-- ============================== -->

        <html>
            <head>
                <script src="https://kit.fontawesome.com/7414123f18.js" crossorigin="anonymous"></script>
                <meta charset="UTF-8"/>
                <meta property="og:image" content="https://bartneck.github.io/swiML/swiMLLogoGradientFacebook.png"/>
                <meta property="og:image:type" content="image/png"/>
                <meta property="og:image:width" content="1200"/>
                <meta property="og:image:height" content="630"/>
                
                <!-- Main CSS  -->
                <link href="https://bartneck.github.io/swiML/swiML.css" rel="stylesheet" type="text/css"/>
                
                <!-- Google fonts  used to load from google.-->
                <!-- The fonts are currently loaded directly from local font files -->
                <!-- This can be reomved as soon as we are comofrtable with this approach -->
                <!--
                <link rel="preconnect" href="https://fonts.googleapis.com"/>
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
                <link
                    href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800"
                    rel="stylesheet"/>
                -->
                
                <xsl:apply-templates select="sw:program/sw:layoutWidth"/>

                <!-- Favicon icons -->
                <link rel="shortcut icon" href="/swiML/favicon/favicon.ico"/>
                <link rel="icon" sizes="16x16 32x32 64x64" href="/swiML/favicon/favicon.ico"/>
                <link rel="icon" type="image/png" sizes="196x196" href="/swiML/favicon/favicon-192.png"/>
                <link rel="icon" type="image/png" sizes="160x160" href="/swiML/favicon/favicon-160.png"/>
                <link rel="icon" type="image/png" sizes="96x96" href="/swiML/favicon/favicon-96.png"/>
                <link rel="icon" type="image/png" sizes="64x64" href="/swiML/favicon/favicon-64.png"/>
                <link rel="icon" type="image/png" sizes="32x32" href="/swiML/favicon/favicon-32.png"/>
                <link rel="icon" type="image/png" sizes="16x16" href="/swiML/favicon/favicon-16.png"/>
                <link rel="apple-touch-icon" href="/swiML/favicon/favicon-57.png"/>
                <link rel="apple-touch-icon" sizes="114x114" href="/swiML/favicon/favicon-114.png"/>
                <link rel="apple-touch-icon" sizes="72x72" href="/swiML/favicon/favicon-72.png"/>
                <link rel="apple-touch-icon" sizes="144x144" href="/swiML/favicon/favicon-144.png"/>
                <link rel="apple-touch-icon" sizes="60x60" href="/swiML/favicon/favicon-60.png"/>
                <link rel="apple-touch-icon" sizes="120x120" href="/swiML/favicon/favicon-120.png"/>
                <link rel="apple-touch-icon" sizes="76x76" href="/swiML/favicon/favicon-76.png"/>
                <link rel="apple-touch-icon" sizes="152x152" href="/swiML/favicon/favicon-152.png"/>
                <link rel="apple-touch-icon" sizes="180x180" href="/swiML/favicon/favicon-180.png"/>
                <meta name="msapplication-TileColor" content="#FFFFFF"/>
                <meta name="msapplication-TileImage" content="/swiML/favicon/favicon-144.png"/>
                <meta name="msapplication-config" content="/swiML/favicon/browserconfig.xml"/>
                
                <title>
                    <xsl:value-of select="sw:program/sw:title"/>
                </title>
            </head>
            <body>
                <xsl:choose>
                    <xsl:when test="sw:program/sw:hideIntro = 'true'"/>
                    <xsl:otherwise>
                        <div class="intro">
                            <h1>
                                <xsl:value-of select="sw:program/sw:title"/>
                            </h1>
                            <xsl:apply-templates select="sw:program/sw:author"/>
                            <p class="description">
                                <xsl:value-of select="sw:program/sw:programDescription"/>
                            </p>
                            <ul>
                                <li>
                                    <span class="semiBoldTypeFace">Date:</span>
                                    <xsl:value-of
                                        select="format-date(sw:program/sw:creationDate, '[D01] [MNn] [Y0001]')"
                                    />
                                </li>
                                <li>
                                    <span class="semiBoldTypeFace">Pool Size:</span>
                                    <xsl:value-of select="myData:number(sw:program/sw:poolLength)"/>
                                </li>
                                <li>
                                    <span class="semiBoldTypeFace">Units:</span>
                                    <xsl:value-of select="sw:program/sw:lengthUnit"/>
                                </li>
                                <li>
                                    <span class="semiBoldTypeFace">Length:</span>
                                    <xsl:value-of select="myData:number(myData:showLength(sw:program))"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="sw:program/sw:lengthUnit"/>
                                    <xsl:text> / </xsl:text>
                                    <xsl:value-of select="myData:number(myData:showLength(sw:program) div (sw:program/sw:poolLength))"/>
                                    <xsl:text> Laps</xsl:text>
                                </li>
                            </ul>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>

                <!-- The recursive instructions -->
                <div class="program">
                    <xsl:apply-templates select="sw:program/sw:instruction"/>
                    <!--<xsl:value-of select="$repLengths"/>
                    c
                    <xsl:value-of select="$maxRepLengths"/>
                    
                    c
                    <xsl:value-of select="$simpLengths"/>
                    c
                    <xsl:value-of select="$maxSimpLengths"/>
                    <xsl:value-of select="$contLengths"/>
                    c
                    <xsl:value-of select="$maxContLengths"/>-->
                </div>
                
                <!-- footer -->
                <xsl:choose>
                    <xsl:when test="sw:program/sw:hideIntro = 'true'"/>
                    <xsl:otherwise>

                        <div class="bottom">
                            <div class="footnote">made with: </div>
                            <div class="logo">
                                <a href="https://github.com/bartneck/swiML">
                                    <svg class='logoSvg' id="Layer_1" xmlns="http://www.w3.org/2000/svg"
                                        viewBox="0 0 1219.33 460.35" >
                                        <defs>
                                            <style>
                                                .cls-1 {
                                                    fill: #231f20;
                                                }</style>
                                        </defs>
                                        <path class="cls-1"
                                            d="M209,360.8c0,58.3-51.7,99.55-104.5,99.55C39.6,460.35,0,419.65,0,362.45c0-14.3,12.1-26.4,26.4-26.4h39.6c18.7,0,26.4,11.55,26.4,25.85,0,6.6,5.5,12.1,12.1,12.1s12.1-5.5,12.1-12.1v-9.35c0-17.6-6.05-25.85-24.75-33.55l-22.55-9.9C41.25,297,0,279.95,0,225.5v-20.35c0-58.3,44.55-101.75,104.5-101.75,66.55,0,104.5,45.65,104.5,97.35,0,14.3-12.1,26.4-26.4,26.4h-39.6c-15.95,0-26.4-7.7-26.4-25.3,0-6.6-5.5-12.1-12.1-12.1s-12.1,5.5-12.1,12.1v7.7c0,17.05,7.7,27.5,24.2,34.65l23.1,9.9c29.15,12.65,69.3,29.15,69.3,83.6v23.1Z"/>
                                        <path class="cls-1"
                                            d="M556.59,354.2c0,72.05-51.7,106.15-96.25,106.15-19.25,0-35.75-3.3-49.5-12.65l-7.15-4.4c-3.85-2.75-5.5-4.4-9.9-4.4-3.3,0-5.5,1.1-9.9,4.4l-6.6,4.4c-13.75,9.35-30.8,12.65-49.5,12.65-52.25,0-96.8-40.7-96.8-106.15V133.65c0-14.3,12.1-26.4,26.4-26.4h39.6c14.3,0,26.4,13.75,26.4,26.4v233.75c0,6.6,5.5,12.1,12.1,12.1s12.1-5.5,12.1-12.1V133.65c0-14.3,12.1-26.4,26.4-26.4h39.6c14.3,0,26.4,13.75,26.4,26.4v233.75c0,6.6,5.5,12.1,12.1,12.1s12.1-5.5,12.1-12.1V133.65c0-14.3,12.1-26.4,26.4-26.4h40.15c14.3,0,25.85,12.1,25.85,26.4v220.55Z"/>
                                        <path class="cls-1"
                                            d="M672.64,58.85c0,14.3-12.1,26.4-26.4,26.4h-39.6c-14.3,0-26.4-12.1-26.4-26.4V29.15c0-14.3,12.1-26.4,26.4-26.4h39.6c14.3,0,26.4,13.75,26.4,26.4v29.7Zm0,371.25c0,14.3-12.1,26.4-26.4,26.4h-39.6c-14.3,0-26.4-12.1-26.4-26.4V133.65c0-14.3,12.1-26.4,26.4-26.4h39.6c14.3,0,26.4,13.75,26.4,26.4V430.1Z"/>
                                        <path class="cls-1"
                                            d="M1033.99,116.05V430.1c0,14.3-12.1,26.4-26.4,26.4h-43.45c-14.3,0-26.4-13.75-26.4-26.4V105.05c0-6.6-5.5-12.1-12.1-12.1s-12.1,5.5-12.1,12.1V430.1c0,14.3-12.1,26.4-26.4,26.4h-43.45c-14.3,0-26.4-13.75-26.4-26.4V105.05c0-6.6-5.5-12.1-12.1-12.1s-12.1,5.5-12.1,12.1V430.1c0,14.3-12.1,26.4-26.4,26.4h-43.45c-14.3,0-26.4-12.1-26.4-26.4V31.35c0-17.05,13.2-31.35,32.45-31.35,6.6,0,14.3,2.75,19.25,4.95l2.75,1.1c6.05,2.2,8.8,3.85,15.95,3.85,6.05,0,14.85-2.75,22-4.95,7.15-2.2,19.25-4.95,32.45-4.95s23.1,2.75,31.9,5.5c7.15,2.2,15.4,4.4,20.35,4.4s13.2-2.2,20.35-4.4c8.8-2.75,21.45-5.5,34.65-5.5,73.7,0,105.05,43.45,105.05,116.05Z"/>
                                        <path class="cls-1"
                                            d="M1154.43,347.6c0,7.15,4.95,12.65,12.1,12.65h26.4c14.3,0,26.4,12.1,26.4,26.4v43.45c0,14.3-12.1,26.4-26.4,26.4h-108.35c-14.3,0-26.4-12.1-26.4-26.4V29.15c0-14.3,12.1-26.4,26.4-26.4h43.45c14.3,0,26.4,12.1,26.4,26.4V347.6Z"
                                        />
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </body>
        </html>
    </xsl:template>

    <!-- ============================== -->
    <!-- Main Templates -->
    <!-- ============================== -->

    <!-- Author Template -->
    <xsl:template match="sw:author">
        <p class="authorName">
            <xsl:value-of separator=" " select="sw:firstName, sw:lastName"/>
        </p>
        <p class="authorEmail">
            <xsl:value-of select="sw:email"/>
        </p>
    </xsl:template>


    <!-- Instruction Template -->
    <xsl:template match="sw:instruction">
        <xsl:choose>
            <xsl:when test="sw:segmentName or sw:repetition or sw:continue">
                <xsl:apply-templates select="sw:segmentName"/>
                <xsl:apply-templates select="sw:repetition"/>
                <xsl:apply-templates select="sw:continue"/>
            </xsl:when>
            <xsl:otherwise>
                <div class="instruction">
                    <xsl:call-template name="displayInst"/>
                </div> 
            </xsl:otherwise>
        </xsl:choose> 
    </xsl:template>

    <!-- First segment template -->
    <xsl:template match="sw:instruction[1]/sw:segmentName">
        <div class="firstSegmentName">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <!-- Segment name template -->
    <xsl:template match="sw:segmentName">
        <div class="segmentName">
            <xsl:value-of select="."/>
        </div>
    </xsl:template>

    <!-- Repetition Template -->
    <xsl:template match="sw:repetition">

        <!-- gets location int for repetition-->
        <xsl:variable name="location">
            <xsl:value-of select="myData:location(.)"/>
        </xsl:variable>

        <div class="repetition">
            <!-- seperate template for simplifying repetition and for non-simplifying-->
            <xsl:choose>
                <xsl:when test="./sw:simplify[text() = 'true']">
                    <div class="repetitionCount">
                        
                        <!-- check if aligning repetition or not-->
                        <xsl:choose>
                            <xsl:when test="./sw:excludeAlignRepetition[text() = 'true'] or ./ancestor-or-self::sw:program//sw:programAlign[text() = 'false']">
                                <xsl:attribute name="style">
                                    <xsl:text>text-align:center;</xsl:text>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="style">
                                    <xsl:text>min-width:</xsl:text>
                                    <xsl:value-of select="$maxSimpLengths[./*[../Location = $location]]/Length"/>
                                    <xsl:text>ch; text-align:center</xsl:text>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        <span>
                            <xsl:attribute name="style">
                                <xsl:text>margin-left: auto; </xsl:text>
                            </xsl:attribute>
                            <xsl:call-template name="simplifyLength"/>
                            <xsl:text>&#160;&#215;&#160;</xsl:text>
                        </span>

                        <!-- only display distance if one isnt defined at the repetitions level  REMOVED i did this twice so it wouldnt display anything -->
                        <span>                
                            <xsl:attribute name="class">
                                <xsl:text>extraBoldTypeFaceCenter</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="myData:firstInst(.)"/>
                        </span>
                        <xsl:if test="(./descendant-or-self::sw:lengthAsLaps)"><xsl:text>&#160;Laps</xsl:text></xsl:if>
                        <xsl:if test=".//sw:repetitionDescription">
                            <xsl:value-of select="concat('&#160;',sw:repetitionDescription)"/>
                        </xsl:if>
                        <xsl:call-template name="displayInst"/>
                        <xsl:text>&#160;as</xsl:text>
                    </div>

                    <!-- only display repetition symbol if more than one child instruction-->
                    <xsl:choose>
                        <xsl:when test="count(./sw:instruction) > 1">
                            <div class="repetitionSymbol"><xsl:text>&#160;</xsl:text></div>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="(count(.//sw:instruction) > 1) or not(./sw:simplify[text()='true']) ">
                                <xsl:text>&#160;</xsl:text>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>

                    <div class="repetitionContent">
                        <xsl:apply-templates select="sw:instruction"/>
                    </div>
                </xsl:when>

                <xsl:otherwise>

                    <!-- display inner if not in a continue with only one child instruction -->
                    <!-- this if statment may be outdated i need to check -->
                    <xsl:if test="not(count(../../../sw:continue) = 1 and count(.//sw:instruction) = 1 and not(../../sw:simplify[text()='true']))">
                        <span class="repetitionCount">

                            <!-- might be another counter intuitive if statement as its kinda already done is the one above-->
                            <xsl:if test="(count(.//sw:instruction) > 1) or not(../../sw:simplify[text()='true'])">

                                <!-- check for excluding alignment-->
                                <xsl:choose>
                                    <xsl:when test="./sw:excludeAlignRepetition[text() = 'true'] or ./ancestor-or-self::sw:program//sw:programAlign[text() = 'false']">
                                        <xsl:attribute name="style">
                                            <xsl:text>text-align:center;</xsl:text>
                                        </xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="style">
                                            <xsl:text>min-width:</xsl:text>
                                            <xsl:value-of select="$maxRepLengths[./*[../Location = $location]]/Length"/>
                                            <xsl:text>ch;</xsl:text>
                                        </xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                            <span>

                                <xsl:attribute name="style">margin-left:auto</xsl:attribute>

                                
                                <xsl:choose>
                                    <xsl:when test="(count(.//sw:instruction) > 1) or not(../../sw:simplify[text()='true'])  ">
                                        
                                        <xsl:if test="count(./sw:instruction) = 1">
                                            <xsl:attribute name="class">
                                                <xsl:text>extraBoldTypeFaceCenter</xsl:text>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="concat(myData:number(sw:repetitionCount),'&#160;','&#215;')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="count(./sw:instruction) = 1">
                                            <xsl:attribute name="class">
                                                <xsl:text>extraBoldTypeFaceCenter</xsl:text>
                                            </xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="myData:number(sw:repetitionCount)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </span>
                            <xsl:if test=".//sw:repetitionDescription">
                                <xsl:value-of select="concat('&#160;',sw:repetitionDescription)"/>
                            </xsl:if>
                            <xsl:call-template name="displayInst"/>
                        </span>

                        <!-- only use repetition symbol for more than one child instruction-->
                        <xsl:choose>
                            <xsl:when test="count(./sw:instruction) > 1">
                                <div class="repetitionSymbol"><xsl:text>&#160;</xsl:text></div>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="(count(.//sw:instruction) > 1) or not(../../sw:simplify[text()='true']) ">
                                    <xsl:text>&#160;</xsl:text>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    <div class="repetitionContent">
                        <xsl:apply-templates select="sw:instruction"/>
                    </div>
                </xsl:otherwise>
            </xsl:choose>        
        </div>
    </xsl:template>
    
    <!-- Continuation Template -->
    <xsl:template match="sw:continue">

        <!-- gets location int for continue-->
        <xsl:variable name="location">
            <xsl:value-of select="myData:location(.)"/>
        </xsl:variable>

        <div class="continue">
            <div class="continueLength">
                <!-- check for alingment exclusion-->
                <xsl:choose>
                    <xsl:when test="./sw:excludeAlignContinue[text() = 'true']or ./ancestor-or-self::sw:program//sw:programAlign[text() = 'false']">
                        <xsl:attribute name="style">
                            <xsl:text>text-align:center;</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style">
                            <xsl:text>min-width:</xsl:text>
                            <xsl:value-of select="$maxContLengths[./*[../Location = $location]]/Length"/>
                            <xsl:text>ch; text-align:center</xsl:text>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose> 
                <span>                
                    <xsl:attribute name="class">
                        <xsl:text>extraBoldTypeFaceMarginLeft</xsl:text>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="../../../sw:repetition/sw:simplify[text()='true']"><xsl:value-of select="myData:number(1)"/></xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="every $node in .//sw:length satisfies $node/sw:lengthAsLaps"><xsl:value-of select="myData:number(myData:contLength(.) div ./ancestor-or-self::sw:program/sw:poolLength )"/></xsl:when>
                                <xsl:otherwise><xsl:value-of select="myData:number(myData:contLength(.))"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    
                </span>
                <xsl:if test="every $node in .//sw:length satisfies $node/sw:lengthAsLaps"><xsl:text>&#160;Laps</xsl:text></xsl:if>
                <xsl:call-template name="displayInst"/>
                <xsl:text>&#160;as</xsl:text>
            </div>
            <div class="continueSymbol"><xsl:text>&#160;</xsl:text></div>
            <div class="continueContent">
                <xsl:apply-templates select="sw:instruction"/>
            </div>
        </div>
    </xsl:template>
    

    <!-- Instruction Template -->
    <xsl:template name="displayInst">

        <!-- check inst is not a child of a simplifying repetition-->
        
        
        <!-- display 1 as length when in a simplifying repetition and it has siblings -->
        <!-- this should be fine as base level instructions can only be 1 set of a repetition but this needs to be checked -->
        <xsl:if test="name(.) = 'instruction'">
            <xsl:choose>
                <xsl:when test="../sw:repetition/sw:simplify[text()='true']"></xsl:when>
                <xsl:when test="../../sw:repetition/sw:simplify[text()='true']">
                    <xsl:choose>
                        <xsl:when test="count(..//sw:instruction) > 1">
                            <span>                
                                <xsl:attribute name="class">
                                    <xsl:text>extraBoldTypeFaceRight</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="myData:number(1)"/>
                            </span>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="../../../sw:simplify[text() = 'true'] and (../../sw:repetition and count(..//sw:instruction) = 1)"></xsl:when>
                <xsl:otherwise>
                    
                    <!--  check if grandchild of continue, child of repetition and has no siblings -->
                    <!-- this means the length needs to be multiplied by repetition count as it isnt displayed in the repetition part-->
                    <xsl:choose>
                        <xsl:when test="count(../../../../sw:continue) > 0 and (../../sw:repetition and count(..//sw:instruction) = 1)">
                            <span>                
                                <xsl:attribute name="class">
                                    <xsl:text>extraBoldTypeFaceRight</xsl:text>
                                </xsl:attribute>
                                <xsl:apply-templates select="(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()] * ../../sw:repetition/sw:repetitionCount"/>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]"/>
                        </xsl:otherwise>
                        
                        
                    </xsl:choose>          
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>    
        

        <!-- the rest of the instruction element templates-->
        <xsl:apply-templates select="sw:stroke/sw:standardStroke"/>
        <xsl:apply-templates select="sw:stroke/sw:kicking/sw:orientation"/>
        <xsl:apply-templates select="sw:stroke/sw:kicking/sw:standardKick"/>
        <xsl:apply-templates select="sw:stroke/sw:drill"/>
        <xsl:apply-templates select="sw:rest/sw:afterStop"/>
        <xsl:apply-templates select="sw:rest/sw:sinceLastRest"/>
        <xsl:apply-templates select="sw:rest/sw:sinceStart"/>
        <xsl:apply-templates select="sw:rest/sw:inOut"/>
        <xsl:call-template name="showIntensity"/>
        <xsl:apply-templates select="sw:breath"/>
        <xsl:apply-templates select="sw:underwater"/>
        <xsl:apply-templates select="sw:equipment"/>
        <xsl:apply-templates select="sw:instructionDescription"/>
    </xsl:template>
    
    <xsl:template match="sw:length">
        <!-- different length templates-->
        <xsl:apply-templates select="sw:lengthAsDistance"/>
        <xsl:apply-templates select="sw:lengthAsLaps"/>
        <xsl:apply-templates select="sw:lengthAsTime"/>
    </xsl:template>
      
    <!-- Length Templates -->
    <xsl:template match="sw:lengthAsDistance">
        <xsl:variable name="location">
            <xsl:value-of select="myData:location(.)"/>
        </xsl:variable>
        <span>
            <xsl:choose> 
                <xsl:when test="not(../../../sw:repetition) and not(../../sw:excludeAlign[text() = 'true'])and not(./ancestor-or-self::sw:program//sw:programAlign[text() = 'false'])">
                    <xsl:attribute name="style">
                        <xsl:text>min-width:</xsl:text>
                        <xsl:value-of select="($maxInstLengths[./*[../Location = $location]]/Length)[last()]"/>
                        <xsl:text>ch</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="class">
                        <xsl:text>extraBoldTypeFaceRight</xsl:text>
                    </xsl:attribute>
                </xsl:when> 
                <xsl:otherwise>
                    <xsl:attribute name="class">
                        <xsl:text>extraBoldTypeFaceRight</xsl:text>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>            
            <xsl:value-of select="myData:number(../ancestor-or-self::*[sw:lengthAsDistance])"/>
        </span>         
    </xsl:template>

    <xsl:template match="sw:lengthAsLaps">
        <xsl:variable name="location">
            <xsl:value-of select="myData:location(.)"/>
        </xsl:variable>
        <span>
            <xsl:choose> 
                <xsl:when test="not(../../../sw:repetition) and not(../../sw:excludeAlign[text() = 'true'])and not(./ancestor-or-self::sw:program//sw:programAlign[text() = 'false'])">
                    <xsl:attribute name="style">
                        <xsl:text>min-width:</xsl:text>
                        <xsl:value-of select="($maxInstLengths[./*[../Location = $location]]/Length)[last()]"/>
                        <xsl:text>ch</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="class">
                        <xsl:text>extraBoldTypeFaceRight</xsl:text>
                    </xsl:attribute>
                </xsl:when> 
                <xsl:otherwise>
                    <xsl:attribute name="class">
                        <xsl:text>extraBoldTypeFaceRight</xsl:text>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>            
            <xsl:value-of select="myData:number(../ancestor-or-self::*[sw:lengthAsLaps])"/>
        </span>
        <xsl:if test="not(//sw:lengthUnit = 'laps')">
            <xsl:text>&#160;</xsl:text>
            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm" select="'laps'"/>
            </xsl:call-template>
        </xsl:if>          
    </xsl:template>
    
    <xsl:template match="sw:lengthAsTime">
        <!-- not setup for inheritance -->
        <xsl:variable name="location">
            <xsl:value-of select="myData:location(.)"/>
        </xsl:variable>
        <span>
            <xsl:choose> 
                <xsl:when test="not(../../../sw:repetition) and not(../../sw:excludeAlign[text() = 'true']) and not(./ancestor-or-self::sw:program//sw:programAlign[text() = 'false'])">
                    <xsl:attribute name="style">
                        <xsl:text>min-width:</xsl:text>
                        <xsl:value-of select="($maxInstLengths[./*[../Location = $location]]/Length)[last()]"/>
                        <xsl:text>ch</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="class">
                        <xsl:text>extraBoldTypeFaceRight</xsl:text>
                    </xsl:attribute>
                </xsl:when> 
                <xsl:otherwise>
                    <xsl:attribute name="class">
                        <xsl:text>extraBoldTypeFaceRight</xsl:text>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose> 
            <xsl:value-of select="concat(myData:number(minutes-from-duration(.)),':', myData:number(format-number(seconds-from-duration(.), '00')))"/>
        </span>        
    </xsl:template>
    
    <!-- ============================== -->
    <!-- Secondary Templates -->
    <!-- ============================== -->

    <!-- returns total length of the given node -->
    <xsl:template name="showLength">
        <xsl:value-of select="myData:number(myData:showLength(.))"/>
    </xsl:template>

    <!-- returns the number of repetitions needed for a node-->
    <!-- used in simpifying repetitions-->
    <xsl:template name="simplifyLength">
        <xsl:value-of select="myData:number(myData:simpRep(.))"/>        
    </xsl:template>


    <xsl:template match="sw:instructionDescription">
        <span class="italicTypeFace">
            <xsl:value-of select="concat('&#160;', ../sw:instructionDescription)"/>
        </span>
    </xsl:template>

    <xsl:template match="sw:equipment">
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="sw:breath">
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="'breath'"/>
        </xsl:call-template>
        <xsl:value-of select="../sw:breath"/>
    </xsl:template>

    <xsl:template match="sw:underwater">
        <xsl:text>&#160;&#8615;</xsl:text>
    </xsl:template>

    <!-- Intensity -->
    <xsl:template name="showIntensity">
        <xsl:choose>
            <xsl:when test="not(./sw:intensity/sw:stopIntensity)">
                <xsl:call-template name="staticIntensity"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="./sw:intensity">
                    <div class="dynamicIntensity">
                    <xsl:choose>
                        <!-- this is gonna change not sure what too yet -->
                        <xsl:when test="../sw:repetition/sw:intensity or ../sw:continue/sw:intensity">
                            <xsl:call-template name="dynamicIntensity"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="dynamicIntensity"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    </div>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="staticIntensity">
        <!-- static intensity profile -->
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageEffort">
            
            <xsl:value-of
                select="concat('&#160;', ./sw:intensity/sw:startIntensity/sw:percentageEffort, '%')"
            />
        </xsl:if>
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageHeartRate">
            <xsl:value-of
                select="concat('&#160;&#9829;', ./sw:intensity/sw:startIntensity/sw:percentageHeartRate, '%')"
            />
        </xsl:if>
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:zone">
            <xsl:text>&#160;</xsl:text>
            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm" select="./sw:intensity/sw:startIntensity/sw:zone"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="dynamicIntensity">
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageEffort">
            <xsl:value-of
                select="concat('&#160;', ./sw:intensity/sw:startIntensity/sw:percentageEffort, '&#8230;', ./sw:intensity/sw:stopIntensity/sw:percentageEffort, '%')"
            />
        </xsl:if>
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageHeartRate">
            <xsl:value-of
                select="concat('&#160;&#9829;', ./sw:intensity/sw:startIntensity/sw:percentageHeartRate, '&#8230;', ./sw:intensity/sw:stopIntensity/sw:percentageHeartRate, '%')"
            />
        </xsl:if>
        <xsl:if test="./sw:intensity/sw:startIntensity/sw:zone">
            <xsl:text>&#160;</xsl:text>
            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm"
                    select="./sw:intensity/sw:startIntensity/sw:zone"/>
            </xsl:call-template>
            <xsl:text>&#8230;</xsl:text>
            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm"
                    select="./sw:intensity/sw:stopIntensity/sw:zone"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Rest -->
    <xsl:template match="sw:afterStop">
        <xsl:value-of
            select="concat('&#160;&#9684;', minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
        />
<!--        <xsl:text>&#160;</xsl:text>
        <i class="fa-regular fa-clock fa-1x"></i>
        <xsl:value-of
            select="concat(minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
        />-->
    </xsl:template>

    <xsl:template match="sw:sinceStart">
        <xsl:value-of
            select="concat('&#160;@_', minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
        />
    </xsl:template>
    
    <xsl:template match="sw:sinceLastRest">
        <xsl:value-of
            select="concat('&#160;&#8592;@_', minutes-from-duration(.), ':',format-number(seconds-from-duration(.), '00'))"
        />        
    </xsl:template>

    <xsl:template match="sw:inOut">
        <xsl:value-of select="concat('&#160;', ., ' in ',1,' out')"/>
    </xsl:template>

    <!-- Stroke -->
    <xsl:template match="sw:standardStroke">
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="."/>
        </xsl:call-template>
    </xsl:template>

    <!-- Kick -->
    <xsl:template match="sw:orientation">
        <xsl:text>&#160;K&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="."/>
        </xsl:call-template>
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="../sw:legMovement"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="sw:standardKick">
        <xsl:text>&#160;K&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="."/>
        </xsl:call-template>
    </xsl:template>

    <!-- Drill -->
    <xsl:template match="sw:drill">
        <xsl:text>&#160;D&#160;</xsl:text>
        <xsl:if test="sw:drillStroke">
            <xsl:call-template name="toDisplay">
                <xsl:with-param name="fullTerm" select="sw:drillStroke"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:text>&#160;</xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="sw:drillName"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="sw:layoutWidth">
        <style>
            <xsl:text>.intro, .bottom {width: </xsl:text><xsl:value-of select="."/><xsl:text>ch;}</xsl:text>
            <xsl:text>
.program {width: </xsl:text><xsl:value-of select=".-2"/><xsl:text>ch;}</xsl:text>
            <xsl:text>
.continue, .instruction, .repetition, .firstSegmentName, .segmentName {max-width:</xsl:text><xsl:value-of select=".-2"/><xsl:text>ch;}</xsl:text> 
        </style>
    </xsl:template>

    <!-- ============================== -->
    <!-- Helper -->
    <!-- ============================== -->
    <xsl:variable name="thisDocument" select="document('')"/>

    <xsl:template name="toDisplay">
        <xsl:param name="fullTerm"/>
        <xsl:value-of
            select="$thisDocument/xsl:stylesheet/myData:translation/term[@index = string($fullTerm)]"
        />
    </xsl:template>

    <myData:translation>
        <term index="butterfly">FL</term>
        <term index="backstroke">BK</term>
        <term index="breaststroke">BR</term>
        <term index="freestyle">FR</term>
        <term index="individualMedley">IM</term>
        <term index="reverseIndividualMedley">IM Reverse</term>
        <term index="individualMedleyOverlap">IM Overlap</term>
        <term index="individualMedleyOrder">IM Order</term>
        <term index="reverseIndividualMedleyOrder">IM Reverse Order</term>
        <term index="any">Any</term>
        <term index="nr1">Nr 1</term>
        <term index="nr2">Nr 2</term>
        <term index="nr3">Nr 3</term>
        <term index="nr4">Nr 4</term>
        <term index="notButterfly">Not FL</term>
        <term index="notBackstroke">Not BK</term>
        <term index="notBreaststroke">Not BR</term>
        <term index="notFreestyle">Not FR</term>
        <term index="flutter">Flutter</term>
        <term index="dolphin">Dolphin</term>
        <term index="scissor">Scissor</term>
        <term index="front">Front</term>
        <term index="back">Back</term>
        <term index="left">Left</term>
        <term index="right">Right</term>
        <term index="side">Side</term>
        <term index="vertical">Vertical</term>
        <term index="easy">Easy</term>
        <term index="threshold">Threshold</term>
        <term index="endurance">Endurance</term>
        <term index="racePace">Race Pace</term>
        <term index="max">Max</term>
        <term index="6KickDrill">6KD</term>
        <term index="8KickDrill">8KD</term>
        <term index="10KickDrill">10KD</term>
        <term index="12KickDrill">12KD</term>
        <term index="fingerTrails">FT</term>
        <term index="123">123</term>
        <term index="bigDog">Big Dog</term>
        <term index="scull">Scull</term>
        <term index="singleArm">Single Arm</term>
        <term index="technic">Technic</term>
        <term index="dogPaddle">Dog Paddle</term>
        <term index="tarzan">Tarzan</term>
        <term index="fist">Fist</term>
        <term index="3Kick1Pull">3K1P</term>
        <term index="3Kick1Pull">2K1P</term>
        <term index="3Kick1Pull">3P1K</term>
        <term index="3Kick1Pull">2P1K</term>
        <term index="board">Board</term>
        <term index="pads">Pads</term>
        <term index="pullBuoy">Pullbuoy</term>
        <term index="fins">Fins</term>
        <term index="snorkel">Snorkel</term>
        <term index="chute">Chute</term>
        <term index="stretchCord">Stretch Cord</term>
        <term index="other">other</term>
        <term index="breath">b</term>
        <term index="laps">laps</term>
        <term index="meters">m</term>
        <term index="yards">yd</term>
    </myData:translation>
    
    <xsl:function name="myData:roman" as="xs:string">
        <xsl:param name="value" as="xs:integer"/>
        <xsl:number value="$value" format="I"/>
    </xsl:function>
    
    <xsl:function name="myData:number">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="number($value) = number($value) and not(contains(string($value), 'NaN'))">
                <xsl:variable name="number">
                    <xsl:value-of select="number($value)"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$gloalRoot/sw:program/sw:numeralSystem[text() = 'roman']">
                        <xsl:value-of select="myData:roman($number)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$value"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- Calculation for the length of the program -->
    <!-- Does not work if mixed length units, such as laps, meters, time -->
    <!-- Works fine if all lengths are exclusively meters or laps -->
    <xsl:function name="myData:product" as="xs:decimal">
        <xsl:param name="numbers" as="xs:decimal*"/>
        <xsl:sequence select="
                if (empty($numbers))
                then
                    1
                else
                    $numbers[1] * myData:product($numbers[position() gt 1])"/>
    </xsl:function>

    <!-- Returns how far right a node is -->
    <!-- This is almost number of parents // 2 as each 
    continue/repetition has instruction element then continue/repetition element-->
    <xsl:function name="myData:breadth">
        <!-- node parameter is the node which depth will be returned-->
        <xsl:param name="node" as="node()"/>
        <xsl:choose>
            <!-- when direct parent node is instruction then -1 from # of ancestors to give correct number-->
            <xsl:when test="name($node/../..) = 'instruction'">
                <xsl:value-of select="(count($node/ancestor::*)-1) div 2"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="count($node/ancestor::*) div 2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- returns number denoting the parents of a given node and what type of node it is-->
    <!-- each digit in the node represents a different parent-->
    <!-- 0:Instruction,1:continue,2:repetition,3:pyramid,4:segmentName-->
    <xsl:function name="myData:parents">
        <xsl:param name="node" as="node()"/>
        <xsl:value-of select="
            string-join(
            for $parent in $node/ancestor-or-self::sw:instruction return
            if ($parent/sw:continue)
            then 
            (1)
            else
            if ($parent/sw:repetition)
            then
            (2)
            else
            if($parent/sw:pyramid)
            then
            (3)
            else
            if ($parent/sw:segmentName)
            then
            (4)
            else(0),'')
            "/>
    </xsl:function>
    
    <!-- returns location of a node as a number, by returning the depth at which each parent and itself is located -->
    <!-- this results in each node returning a unique number from this function -->
    <xsl:function name="myData:location">
        <xsl:param name="node" as="node()"/>
        <xsl:value-of select="
            string-join(
            for $parent in $node/ancestor-or-self::sw:instruction return
            myData:depth($parent),'')
            "/>
    </xsl:function>
     
     <!-- return what section a node is in -->
     <!-- section is defined by the number of segment names above it -->
     <!-- so section 0 has none and section 2 is below the second segment name -->
    <xsl:function name="myData:section">
        <xsl:param name="node" as="node()"/>
        <xsl:value-of select="count($node/ancestor-or-self::sw:instruction[last()]/preceding-sibling::sw:instruction/sw:segmentName)"/>
    </xsl:function>
    
    <!-- returns how many top level instructions are above a node -->
    <!-- the first instruction will be 0 the last will be n-1-->
    <!-- any children instructions have the same depth as parent instruction -->
    <!-- may need change to make relative depth, so depth inside current instruction/program-->
    <xsl:function name="myData:depth">
        <xsl:param name="node" as="node()" />
        <xsl:value-of select="count($node/ancestor-or-self::sw:instruction[1]/preceding-sibling::sw:instruction)"/>
    </xsl:function>
    
    <!-- returns total number of repetitions needed for a simplifying continue -->
    <!-- achieved by getting total length of children then dividing by length of single instruction to give how many times it needs to be repeated -->  
    <xsl:function name="myData:simpRep">
        <xsl:param name="root" as="node()"/>    

        <xsl:sequence select="
            if($root//sw:lengthAsLaps) then(
                (myData:repLength($root) div myData:firstInst($root)) div $root/ancestor-or-self::sw:program/sw:poolLength
            ) else(
                myData:repLength($root) div myData:firstInst($root) 
            )
        "/>
    </xsl:function>
    
    <!-- returns the length of the first instruction swum continuously -->
    <xsl:function name="myData:firstInst">
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="
            for $l in ($root/sw:instruction)[1] return(
                if(name($l/*[1]) = 'continue') then(
                    myData:contLength($l/*[1])
                )else if(name($l/*[1]) = 'repetition') then(
                    myData:firstInst($l/*[1])
                )else if(name($l/*[1]) = 'repetition') then(
                    1
                )else(
                    if($l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsDistance)then(
                        number($l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsDistance)
                    )else if($l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsLaps)then(
                        number($l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsLaps)
                    )else(
                        1
                    )
                
                )
            )
            " />
    </xsl:function>
    
    
    <!-- function to return length of a continue -->
    <xsl:function name="myData:contLength">
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="
            if($root/sw:continueLength)then(
                number($root/sw:continueLength)
            )else(
                myData:showLength($root)
            )
            "/>
    </xsl:function>
    
    <!-- function to return length of a repetition-->
    <xsl:function name="myData:repLength">
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="
            if($root/sw:simplify[text() = 'true'])then(
                (
                    myData:showLength($root)
                )*( 
                    if($root/sw:repetitionCount)then(
                        number($root/sw:repetitionCount)
                    )else(
                        1
                    )
                )
            )else(
                (
                    myData:showLength($root)
                )*( 
                    number($root/sw:repetitionCount)
                )
            )
            "/>
    </xsl:function>
    
    <!-- return total length of children elements -->
    <!-- adds all length element while multiplying by any repetition elements that contain them -->
    <xsl:function name="myData:showLength">
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="
            sum(
                for $l in $root/sw:instruction[not(child::sw:segmentName)] return(
                    if(name($l/*[1]) = 'repetition')then(
                        myData:repLength($l/*[1])
                    )else if(name($l/*[1]) = 'continue')then(
                        myData:contLength($l/*[1])
                    )else if(name($l/*[1]) = 'pyramid')then(
                        1
                    )else if($l/*[1]//(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsDistance) then(
                        number($l/*[1]/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsDistance)
                    )else if($l/*[1]//(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsLaps) then(
                        number($l/*[1]/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsLaps) * $root/ancestor-or-self::sw:program/sw:poolLength
                    )else(
                    0
                    )
                )
            )
            "/>
    </xsl:function>
 
</xsl:stylesheet>
