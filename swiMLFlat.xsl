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
                    <xsl:apply-templates select="sw:length"/>
                    <xsl:apply-templates select="sw:stroke"/>
                    <xsl:if test="$cont = '1|0'">
                        <xsl:element namespace="{$namespace}" name="rest">
                            <xsl:element namespace="{$namespace}" name="afterStop"><xsl:text>PT0M0S</xsl:text></xsl:element>
                        </xsl:element>                        
                    </xsl:if>
                    <xsl:apply-templates select="node()[not(self::sw:length or self::sw:stroke)]"/>                    
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
        
        <xsl:for-each select="$con/sw:instruction">
            <xsl:apply-templates select="." >
                <xsl:with-param name="cont" select="concat('1|', if (position() = last()) then '1' else '0')"/>
            </xsl:apply-templates>            
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="sw:pyramid"/>
</xsl:stylesheet>