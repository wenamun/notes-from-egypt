<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="translate(., '_', '')"/>
    </xsl:template>
    <xsl:template match="*:hi[@rendition='italic']">
        <span style="font-style:italic"><xsl:apply-templates select="@* | node()"/></span>
    </xsl:template>
    <xsl:template match="*:foreign">
        <span style="font-style:italic"><xsl:apply-templates select="@* | node()"/></span>
    </xsl:template>
</xsl:stylesheet>