<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output method="xml" version="1.0" encoding="utf-8"
       indent="yes" />

   <xsl:template match="project">
       <remove-project>
           <xsl:copy-of select="@*" />
           <xsl:apply-templates />
       </remove-project>
   </xsl:template>

   <xsl:template match="manifest">
       <manifest>
           <xsl:copy-of select="@*" />
           <xsl:apply-templates select="project"/>
       </manifest>
   </xsl:template>

   <xsl:template match="*">
     <xsl:copy-of select="."/>
   </xsl:template>

</xsl:stylesheet>

