<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes=""  version="2.0"
    xmlns:myData="http://www.bartneck.de" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:sw="file:/C:/My%20Documents/GitHub/swiML">
    
    
    <xsl:variable name="namespace" ><xsl:text>file:/C:/My%20Documents/GitHub/swiML</xsl:text></xsl:variable>
    <xsl:variable name="gloalRoot" select="/"/>
    <xsl:output indent="yes" method="xml"/>
    <xsl:strip-space elements="*"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="sw:instruction">
        <xsl:param name="cont" select="'0|0'"/>
        <xsl:choose>
            <xsl:when test="sw:repetition or sw:continue or sw:pyramid">
                <xsl:apply-templates select="sw:pyramid">
                    <xsl:with-param name="cont" select="$cont"/>
                </xsl:apply-templates>  
                <xsl:apply-templates select="sw:repetition">
                    <xsl:with-param name="cont" select="$cont"/>
                </xsl:apply-templates>  
                <xsl:apply-templates select="sw:continue">
                    <xsl:with-param name="cont" select="$cont"/>
                </xsl:apply-templates>  
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    
                    <xsl:apply-templates select="ancestor-or-self::*/sw:length[last()]"/>
                    
                    <xsl:apply-templates select="ancestor-or-self::*/sw:stroke[last()]"/>
                    <xsl:choose>
                        <xsl:when test="$cont = '1|0'">
                            <xsl:element namespace="{$namespace}" name="rest">
                                <xsl:element namespace="{$namespace}" name="afterStop"><xsl:text>PT0M0S</xsl:text></xsl:element>
                            </xsl:element>                        
                        </xsl:when>
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
    
    
    <xsl:template match="sw:repetition">
        <xsl:param name="cont" select="'0|0'"/>
        <xsl:variable name="count">
            <xsl:choose>
                <xsl:when test="sw:repetitionCount"><xsl:value-of select="sw:repetitionCount"/></xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        
        <xsl:variable name="rep" select="."/>
        <xsl:for-each select="1 to $count">
            <xsl:variable name="isLast"  select="position() = last()" />
            <xsl:for-each select="$rep/sw:instruction">
                <xsl:apply-templates select="." >
                    <xsl:with-param name="cont" select="concat(substring-before($cont, '|'), '|',
                        if (position() = last() and substring-after($cont,'|') = '1' and $isLast) then '1' else '0')"/>
                </xsl:apply-templates>     
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="sw:continue">
        <xsl:param name="cont" select="'0|0'"/>
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
        <xsl:message><xsl:value-of select="$count"/></xsl:message>
        <xsl:for-each select="1 to $count">
            <xsl:variable name="isLast"  select="position() = last()" />
            <xsl:for-each select="$con/sw:instruction">
                <xsl:apply-templates select="." >
                    <xsl:with-param name="cont" select="concat('1|', if (position() = last() and $isLast) then '1' else '0')"/>
                </xsl:apply-templates>            
            </xsl:for-each>
        </xsl:for-each>        
    </xsl:template>
    
    <xsl:template match="sw:pyramid"/>
    
    
    
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