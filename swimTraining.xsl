<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:myData="http://www.bartneck.de" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:sw="https://github.com/bartneck/swiML">
    
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <link href="swimTraining.css" rel="stylesheet" type="text/css"/>
                <link rel="preconnect" href="https://fonts.googleapis.com"/>
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
                <link
                    href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800"
                    rel="stylesheet"/>
                <title>
                    <xsl:value-of select="sw:swimTraining/sw:clubName"/>
                    <xsl:text> Training</xsl:text>
                </title>
            </head>
            
            <body>
                <h1><xsl:value-of select="sw:swimTraining/sw:clubName"/>
                <xsl:text> Training</xsl:text>
                </h1>
                This is the index of the <xsl:value-of select="sw:swimTraining/sw:clubName"/> Training Sessions.
                <ul>
                    <xsl:for-each select="sw:swimTraining/sw:session">
                        <xsl:sort select="sw:date" order="descending"/>
                        <li><xsl:value-of separator=" " select="sw:date, sw:pool"/>
                            <xsl:text> (</xsl:text>
                            <a>                
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat(translate(../sw:clubName,' ',''),format-date(sw:date,'[Y0001][M01][D01]'),'.html')"/>
                                </xsl:attribute>
                                <xsl:text>HTML</xsl:text>
                            </a>
                            <xsl:text>, </xsl:text>
                            <a>                
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat(translate(../sw:clubName,' ',''),format-date(sw:date,'[Y0001][M01][D01]'),'.xml')"/>
                                </xsl:attribute>
                                <xsl:text>XML</xsl:text>
                            </a>
                            <xsl:text>, </xsl:text>
                            <a>                
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat(translate(../sw:clubName,' ',''),format-date(sw:date,'[Y0001][M01][D01]'),'.jpeg')"/>
                                </xsl:attribute>
                                <xsl:text>JEPG</xsl:text>
                            </a>  
                            <xsl:text>)</xsl:text>
                        </li>
                    </xsl:for-each>
                     
                </ul>
            </body>
        </html>
        
    </xsl:template>
    
</xsl:stylesheet>