<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0">

    <xsl:output indent="yes"/>

    <xsl:variable name="places" select="//tei:p/tei:placeName"/>

    <xsl:template name="entry" match="/">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Title</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <listPlace>
                        <place>
                            <xsl:for-each select="$places">
                                <xsl:sort select="."/>
                                <place>
                                    <xsl:attribute name="uri"
                                        >http://pleiades.stoa.org/places/</xsl:attribute>
                                    <xsl:attribute name="id" select="position()"/>
                                    <name>
                                        <xsl:value-of select="."/>
                                    </name>
                                    <coord>
                                        <long/>
                                        <lat/>
                                    </coord>
                                </place>
                            </xsl:for-each>
                        </place>
                    </listPlace>
                </body>
            </text>
        </TEI>


    </xsl:template>



</xsl:stylesheet>
