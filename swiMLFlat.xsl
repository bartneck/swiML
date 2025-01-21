<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes=""  version="2.0"
    xmlns:myData="http://www.bartneck.de" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:sw="https://github.com/bartneck/swiML">
    
    
    <!-- setting up page to copy surrounding xml tags--> 
    <xsl:variable name="namespace" ><xsl:text>https://github.com/bartneck/swiML</xsl:text></xsl:variable>
    <xsl:variable name="gloalRoot" select="/"/>
    <xsl:output indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <!-- match all nodes in the program-->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- template to copy over each individual instruction -->
    <xsl:template match="sw:instruction">
        <!-- parameter for if inside a continue/repetition or at the end  -->
        <xsl:param name="cont" select="'0|0'"/>
        <!-- parameter giving the relative position of the instruction within its parent instructions -->
        <xsl:param name="pos" select="'None'"/>
        <xsl:choose>
            <!-- For when instruction is not a basic instruction
            apply template and carry over parameters for other instructions -->
            <xsl:when test="sw:repetition or sw:continue or sw:pyramid or sw:segmentName">
                <xsl:apply-templates select="sw:pyramid">
                    <xsl:with-param name="cont" select="$cont"/>
                    <xsl:with-param name="pos" select="$pos"/>
                </xsl:apply-templates>  
                <xsl:apply-templates select="sw:repetition">
                    <xsl:with-param name="cont" select="$cont"/>
                    <xsl:with-param name="pos" select="$pos"/>
                </xsl:apply-templates>  
                <xsl:apply-templates select="sw:continue">
                    <xsl:with-param name="cont" select="$cont"/>
                    <xsl:with-param name="pos" select="$pos"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="sw:segmentName">
                    <xsl:with-param name="cont" select="$cont"/>
                    <xsl:with-param name="pos" select="$pos"/>
                </xsl:apply-templates>  
            </xsl:when>
            <xsl:otherwise>
                <!-- if basic instruction copy over and change/add relevant elements -->
                <xsl:copy>
                    <!-- copy length element -->
                    <xsl:apply-templates select="ancestor-or-self::*/sw:length[last()]"/>
                    
                    <!-- copying/creating stroke element 
                    when instruction is within a medley element it needs to split up the instructions into quarters-->
                    <xsl:choose>
                        <xsl:when test="ancestor-or-self::*/sw:stroke[last()]/sw:standardStroke = 'individualMedleyOrder'">
                            <xsl:element namespace="{$namespace}" name="stroke">
                                <xsl:element namespace="{$namespace}" name="standardStroke">
                                    <!-- find which quarter the instruction is in  -->
                                    <xsl:variable name="quarter">
                                        <xsl:value-of select="myData:quarter($pos,(0,1))"/>
                                    </xsl:variable>
                                    <!-- display relevent stroke -->
                                    <xsl:choose>
                                        <xsl:when test="$quarter = 1">butterfly</xsl:when>
                                        <xsl:when test="$quarter = 2">backstroke</xsl:when>
                                        <xsl:when test="$quarter = 3">breaststroke</xsl:when>
                                        <xsl:when test="$quarter = 4">freestyle</xsl:when>
                                        <xsl:otherwise></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:element> 
                        </xsl:when>
                        <xsl:when test="ancestor-or-self::*/sw:stroke[last()]/sw:drill/sw:drillStroke = 'individualMedleyOrder'">
                            <xsl:element namespace="{$namespace}" name="stroke">
                                <xsl:element namespace="{$namespace}" name="drill">
                                    <xsl:element namespace="{$namespace}" name="drillName">
                                        <xsl:text>any</xsl:text>
                                    </xsl:element>
                                    <xsl:element namespace="{$namespace}" name="drillStroke">
                                        <xsl:variable name="quarter">
                                            <xsl:value-of select="myData:quarter($pos,(0,1))"/>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="$quarter = 1">butterfly</xsl:when>
                                            <xsl:when test="$quarter = 2">backstroke</xsl:when>
                                            <xsl:when test="$quarter = 3">breaststroke</xsl:when>
                                            <xsl:when test="$quarter = 4">freestyle</xsl:when>
                                            <xsl:otherwise></xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>                                    
                                </xsl:element>
                            </xsl:element> 
                        </xsl:when>
                        <xsl:when test="ancestor-or-self::*/sw:stroke[last()]/sw:kicking/sw:standardKick = 'individualMedleyOrder'">
                            <xsl:element namespace="{$namespace}" name="stroke">
                                <xsl:element namespace="{$namespace}" name="kicking">
                                    <xsl:element namespace="{$namespace}" name="standardKick">
                                        <xsl:variable name="quarter">
                                            <xsl:value-of select="myData:quarter($pos,(0,1))"/>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="$quarter = 1">butterfly</xsl:when>
                                            <xsl:when test="$quarter = 2">backstroke</xsl:when>
                                            <xsl:when test="$quarter = 3">breaststroke</xsl:when>
                                            <xsl:when test="$quarter = 4">freestyle</xsl:when>
                                            <xsl:otherwise></xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>                                    
                                </xsl:element>
                            </xsl:element> 
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="ancestor-or-self::*/sw:stroke[last()]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:choose>
                        <!-- when inside a continue need to add a rest = 0 to denote this -->
                        <xsl:when test="$cont = '1|0'">
                            <xsl:element namespace="{$namespace}" name="rest">
                                <xsl:element namespace="{$namespace}" name="afterStop"><xsl:text>PT0M0S</xsl:text></xsl:element>
                            </xsl:element>                        
                        </xsl:when>
                        <!-- if not copy over any present rest tag -->
                        <xsl:otherwise>
                            <xsl:if test="ancestor-or-self::*/sw:rest">
                                <xsl:apply-templates select="ancestor-or-self::*/sw:rest[last()]"/>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- Optional elements -->
                    <xsl:if test="ancestor-or-self::*/sw:intensity">
                        <xsl:apply-templates select="ancestor-or-self::*/sw:intensity[last()]"/>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::*/sw:breath">
                        <xsl:apply-templates select="ancestor-or-self::*/sw:breath[last()]"/>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::*/sw:underwater">
                        <xsl:apply-templates select="ancestor-or-self::*/sw:underwater[last()]"/>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::*/sw:equipment">
                        <xsl:apply-templates select="ancestor-or-self::*/sw:equipment"/>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::*/sw:instructionDescription">
                        <xsl:apply-templates select="ancestor-or-self::*/sw:instructionDescription[last()]"/>
                    </xsl:if>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose> 
    </xsl:template>
    
    <!-- template for dividing up repetition elements -->
    <xsl:template match="sw:repetition">
        <!-- parameters for repetition -->
        <xsl:param name="cont" select="'0|0'"/>
        <xsl:param name="pos" select="'None'"/>
        <xsl:variable name="count">
            <xsl:choose>
                <xsl:when test="sw:repetitionCount"><xsl:value-of select="sw:repetitionCount"/></xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        
        <xsl:variable name="rep" select="."/>
        
        <!-- repeat for each repetition that occurs -->
        <xsl:for-each select="1 to $count">
            
            <!-- variables to split up the repetition -->
            <xsl:variable name="isLast"  select="position() = last()" />
            <xsl:variable name="relPos" select="position()"/>
            <xsl:variable name="fractionTotal" select="myData:repLength($rep) div number($rep/ancestor::sw:program/sw:poolLength)"/>
            <xsl:variable name="repetitionAdd" select="(position()-1)*($fractionTotal div $count)"/>
            
            <!-- repeat for instruction inside the repetition -->
            <xsl:for-each select="$rep/sw:instruction">
                <!-- add position variable giving the relative position of the instruction inside the repetition -->
                <xsl:variable name="position">
                    <xsl:choose>
                        <xsl:when test="$pos = 'None'">
                            <xsl:value-of select="concat(string((sum(./preceding-sibling::*//sw:length/*[1]) div number(ancestor::sw:program/sw:poolLength))+1+$repetitionAdd),','
                                ,string((sum(./preceding-sibling::*//sw:length/*[1])+myData:length(.)) div number(ancestor::sw:program/sw:poolLength)+$repetitionAdd) , ',' , string($fractionTotal))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($pos,'|',string((sum(./preceding-sibling::*//sw:length/*[1]) div number(ancestor::sw:program/sw:poolLength))+1+$repetitionAdd),','
                                ,string((sum(./preceding-sibling::*//sw:length/*[1])+myData:length(.)) div number(ancestor::sw:program/sw:poolLength)+$repetitionAdd), ',' , string($fractionTotal))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- apply instruction template to child with position and whether it is last inside the repetition -->
                <xsl:apply-templates select="." >
                    <xsl:with-param name="cont" select="concat(substring-before($cont, '|'), '|',
                        if (position() = last() and substring-after($cont,'|') = '1' and $isLast) then '1' else '0')"/>
                    <xsl:with-param name="pos" select="$position"/>
                    
                </xsl:apply-templates>     
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <!-- template for dividing up a continue element -->
    <xsl:template match="sw:continue">
        <!-- parameters for continue -->
        <xsl:param name="cont" select="'0|0'"/>
        <xsl:param name="pos" select="'None'"/>
        <xsl:variable name="con" select="."/>
        
        <xsl:variable name="count">
            <xsl:choose>
                <xsl:when test="sw:continueLength">
                    <xsl:value-of select="number(sw:continueLength) div myData:showLength(.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- repeat for each time the continue repeats the instructions inside -->
        <xsl:for-each select="1 to $count">
            <!-- variables to give the relative position of the child instruction inside the continue -->
            <xsl:variable name="isLast"  select="position() = last()" />
            <xsl:variable name="fractionTotal" select="((myData:contLength($con))) div number($con/ancestor::sw:program/sw:poolLength)"/>
            <xsl:variable name="repetitionAdd" select="(position()-1)*($fractionTotal div $count)"/>
            
            <!-- repeat for each instruction inside the continue -->
            <xsl:for-each select="$con/sw:instruction">
                <xsl:variable name="position">
                    <xsl:choose>
                        <xsl:when test="$pos = 'None'">
                            <xsl:value-of select="concat(string((sum(./preceding-sibling::*//sw:length/*[1]) div number(ancestor::sw:program/sw:poolLength))+1+$repetitionAdd),','
                                ,string((sum(./preceding-sibling::*//sw:length/*[1])+myData:length(.)) div number(ancestor::sw:program/sw:poolLength)+$repetitionAdd) , ',' , $fractionTotal)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($pos,'|',string((sum(./preceding-sibling::*//sw:length/*[1]) div number(ancestor::sw:program/sw:poolLength))+1+$repetitionAdd),','
                                ,string((sum(./preceding-sibling::*//sw:length/*[1])+myData:length(.)) div number(ancestor::sw:program/sw:poolLength)+$repetitionAdd) , ',' , $fractionTotal)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                 <xsl:apply-templates select="." >
                    <xsl:with-param name="cont" select="concat('1|', if (position() = last() and $isLast) then '1' else '0')"/>
                    <xsl:with-param name="pos" select="$position" />
                </xsl:apply-templates>            
            </xsl:for-each>
        </xsl:for-each>        
    </xsl:template>
    
    <!-- no copying over of pyramids or segment names yet -->
    <xsl:template match="sw:pyramid"/>
    
    <xsl:template match="sw:segmentName"/>
    
    <!-- function that returns the quarter a instruction is in given its position and the parent instruction -->
    <xsl:function name="myData:quarter">
        <xsl:param name="position" />
        <xsl:param name="range"/>
        <xsl:variable name="segments" select="tokenize($position,'\|')"/>
        
        <xsl:choose>
            <!-- if there are no segments left return error message as it broke -->
            <xsl:when test="count($segments) = 0 ">
                <xsl:message>No valid Quarter Found</xsl:message>
                <xsl:text>No valid Quarter Found</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <!-- variables breaking up the position of the instruction -->
                <xsl:variable name="first_segment" select="$segments[1]" />
                <xsl:variable name="segment_values" select="tokenize($first_segment, ',')" />
                <xsl:variable name="total_size" select="number($segment_values[3])" />
                <xsl:variable name="start" select="(number($segment_values[1])-1) div $total_size" />
                <xsl:variable name="end" select="number($segment_values[2]) div $total_size" />
                
                <!-- gives which quarter the instruction is in -->
                <xsl:choose>
                    <xsl:when test="((($range[2]-$range[1])*$end)+$range[1]) &lt;= 0.25">
                        <xsl:value-of select="1"/>
                    </xsl:when>
                    <xsl:when test="((($range[2]-$range[1])*$start)+$range[1]) &gt;= 0.25 and ((($range[2]-$range[1])*$end)+$range[1]) &lt;= 0.50">
                        <xsl:value-of select="2"/>
                    </xsl:when>
                    <xsl:when test="((($range[2]-$range[1])*$start)+$range[1]) &gt;= 0.50 and ((($range[2]-$range[1])*$end)+$range[1]) &lt;= 0.75">
                        <xsl:value-of select="3"/>
                    </xsl:when>
                    <xsl:when test="((($range[2]-$range[1])*$start)+$range[1]) &gt;= 0.75 ">
                        <xsl:value-of select="4"/>
                    </xsl:when>
                    <!-- if no quarter can be found call function again with given information to split further -->
                    <xsl:otherwise>
                        <xsl:value-of select="myData:quarter(tokenize(substring-after($position, '|'), '\|'),($start,$end))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>   
    </xsl:function>
    
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
    
    
    <!-- returns the length of an element  -->
    <xsl:function name="myData:length">
        <xsl:param name="root" as="node()"/>
        <xsl:sequence select="
            if($root/sw:continue)then(
                myData:contLength($root/sw:continue)
            )else if($root/sw:repetition)then(
                myData:repLength($root/sw:repetition)
            )else if($root/sw:segmentName)then(
            )else if($root/sw:pyramid)then(
            )else if(not($root//sw:instruction))then(
                number($root/*[1]/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()])
            )else(0)
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