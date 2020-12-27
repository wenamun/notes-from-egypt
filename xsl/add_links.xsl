<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="html"/>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- make links from name elements -->
    <xsl:template match="*:name[@type='place']">
        <xsl:variable name="target" select="@ref"/>
        <a href="./show_place.html?placename={substring($target, 2)}" style="color:#ed4933;">
            <xsl:apply-templates select="@* | node()"/>
        </a>
    </xsl:template>
    <xsl:template match="*:name[@type='person']">
        <xsl:variable name="target" select="@ref"/>
        <a href="./show_person.html?personname={substring($target, 2)}" style="color:#ed4933;">
            <xsl:apply-templates select="@* | node()"/>
        </a>
    </xsl:template>
    
    <!-- remove some attributes -->
    <xsl:template match="@ref"/>
    <xsl:template match="@type"/>
    <xsl:template match="@xmlns"/>
    <xsl:template match="@full"/>
</xsl:stylesheet>