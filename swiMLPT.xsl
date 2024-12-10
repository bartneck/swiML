<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:myData="http://www.bartneck.de" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:sw="file:/C:/My%20Documents/GitHub/swiML">
<!-- version 2.3 -->

<xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:variable name="gloalRoot" select="/"/>

<xsl:template match="/">

    <xsl:apply-templates select="sw:program/sw:instruction"/>
                
</xsl:template>

<!-- ============================== -->
<!-- Main Templates -->
<!-- ============================== -->


<!-- Instruction Template -->
<xsl:template match="sw:instruction">
    <xsl:call-template name="displayInst"/>
</xsl:template>

<!-- Instruction Template -->
<xsl:template name="displayInst">       

    <xsl:apply-templates select="sw:length"/>
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
    <xsl:value-of select="myData:number(../ancestor-or-self::*[sw:lengthAsDistance])"/>
</xsl:template>

<xsl:template match="sw:lengthAsLaps">           
    <xsl:value-of select="myData:number(../ancestor-or-self::*[sw:lengthAsLaps])"/>
    
    <xsl:if test="not(//sw:lengthUnit = 'laps')">
        <xsl:text> </xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="'laps'"/>
        </xsl:call-template>
    </xsl:if>          
</xsl:template>

<xsl:template match="sw:lengthAsTime"> 
    <xsl:value-of select="concat(myData:number(minutes-from-duration(.)),':', myData:number(format-number(seconds-from-duration(.), '00')))"/>
</xsl:template>

<!-- ============================== -->
<!-- Secondary Templates -->
<!-- ============================== -->

<!-- returns total length of the given node -->
<xsl:template name="showLength">
    <xsl:value-of select="myData:number(myData:showLength(.))"/>
</xsl:template>



<xsl:template match="sw:instructionDescription">
    <span class="italicTypeFace">
        <xsl:value-of select="concat(' ', ../sw:instructionDescription)"/>
    </span>
</xsl:template>

<xsl:template match="sw:equipment">
    <xsl:text> </xsl:text>
    <xsl:call-template name="toDisplay">
        <xsl:with-param name="fullTerm" select="."/>
    </xsl:call-template>
</xsl:template>

<xsl:template match="sw:breath">
    <xsl:text> </xsl:text>
    <xsl:call-template name="toDisplay">
        <xsl:with-param name="fullTerm" select="'breath'"/>
    </xsl:call-template>
    <xsl:value-of select="../sw:breath"/>
</xsl:template>

<xsl:template match="sw:underwater">
    <xsl:text> &#8615;</xsl:text>
</xsl:template>

<!-- Intensity -->
<xsl:template name="showIntensity">
    <xsl:choose>
        <xsl:when test="not(./sw:intensity/sw:stopIntensity)">
            <xsl:call-template name="staticIntensity"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:if test="./sw:intensity">
                <xsl:call-template name="dynamicIntensity"/>
            </xsl:if>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="staticIntensity">
    <!-- static intensity profile -->
    <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageEffort">
        
        <xsl:value-of
            select="concat(' ', ./sw:intensity/sw:startIntensity/sw:percentageEffort, '%')"
        />
    </xsl:if>
    <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageHeartRate">
        <xsl:value-of
            select="concat(' &#9829;', ./sw:intensity/sw:startIntensity/sw:percentageHeartRate, '%')"
        />
    </xsl:if>
    <xsl:if test="./sw:intensity/sw:startIntensity/sw:zone">
        <xsl:text> </xsl:text>
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="./sw:intensity/sw:startIntensity/sw:zone"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="dynamicIntensity">
    <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageEffort">
        <xsl:value-of
            select="concat(' ', ./sw:intensity/sw:startIntensity/sw:percentageEffort, '&#8230;', ./sw:intensity/sw:stopIntensity/sw:percentageEffort, '%')"
        />
    </xsl:if>
    <xsl:if test="./sw:intensity/sw:startIntensity/sw:percentageHeartRate">
        <xsl:value-of
            select="concat(' &#9829;', ./sw:intensity/sw:startIntensity/sw:percentageHeartRate, '&#8230;', ./sw:intensity/sw:stopIntensity/sw:percentageHeartRate, '%')"
        />
    </xsl:if>
    <xsl:if test="./sw:intensity/sw:startIntensity/sw:zone">
        <xsl:text> </xsl:text>
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
        select="concat(' &#9684;', minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
    />
<!--        <xsl:text> </xsl:text>
    <i class="fa-regular fa-clock fa-1x"></i>
    <xsl:value-of
        select="concat(minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
    />-->
</xsl:template>

<xsl:template match="sw:sinceStart">
    <xsl:value-of
        select="concat(' @_', minutes-from-duration(.), ':', format-number(seconds-from-duration(.), '00'))"
    />
</xsl:template>

<xsl:template match="sw:sinceLastRest">
    <xsl:value-of
        select="concat(' &#8592;@_', minutes-from-duration(.), ':',format-number(seconds-from-duration(.), '00'))"
    />        
</xsl:template>

<xsl:template match="sw:inOut">
    <xsl:value-of select="concat(' ', ., ' in ',1,' out')"/>
</xsl:template>

<!-- Stroke -->
<xsl:template match="sw:standardStroke">
    <xsl:text> </xsl:text>
    <xsl:call-template name="toDisplay">
        <xsl:with-param name="fullTerm" select="."/>
    </xsl:call-template>
</xsl:template>

<!-- Kick -->
<xsl:template match="sw:orientation">
    <xsl:text> K </xsl:text>
    <xsl:call-template name="toDisplay">
        <xsl:with-param name="fullTerm" select="."/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:call-template name="toDisplay">
        <xsl:with-param name="fullTerm" select="../sw:legMovement"/>
    </xsl:call-template>
</xsl:template>

<xsl:template match="sw:standardKick">
    <xsl:text> K </xsl:text>
    <xsl:call-template name="toDisplay">
        <xsl:with-param name="fullTerm" select="."/>
    </xsl:call-template>
</xsl:template>

<!-- Drill -->
<xsl:template match="sw:drill">
    <xsl:text> D </xsl:text>
    <xsl:if test="sw:drillStroke">
        <xsl:call-template name="toDisplay">
            <xsl:with-param name="fullTerm" select="sw:drillStroke"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:text> </xsl:text>
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
    <term index="snorkle">Snorkle</term>
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


<!-- returns the length of the first instruction swum continuously -->
<xsl:function name="myData:firstInst">
    <xsl:param name="root" as="node()"/>
    <xsl:sequence select="
        for $l in ($root/sw:instruction)[1] return(
            if($l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsDistance)then(
                number($l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsDistance)
            )else if($l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsLaps)then(
                number($l/(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsLaps)
            )else(
                1                
            )
        )
        " />
</xsl:function>

<!-- return total length of children elements -->
<!-- adds all length element while multiplying by any repetition elements that contain them -->
<xsl:function name="myData:showLength">
    <xsl:param name="root" as="node()"/>
    <xsl:sequence select="
        sum(
            for $l in $root/sw:instruction[not(child::sw:segmentName)] return(
                if($l/*[1]//(preceding-sibling::sw:length | ancestor-or-self::*/sw:length)[last()]/sw:lengthAsDistance) then(
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
