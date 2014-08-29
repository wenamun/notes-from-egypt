<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:output method="html" />
   <xsl:template match="/">
       
       <xsl:apply-templates select="/TEI/text/body/p/rs"/>
       
   </xsl:template>
    
    <xsl:template match="rs">
        
    </xsl:template>
    
</xsl:stylesheet>    
