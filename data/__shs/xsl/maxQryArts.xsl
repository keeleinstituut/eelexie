<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8" />


	<xsl:param name="maxNr"></xsl:param>


	<xsl:template match="/">
		<xsl:apply-templates select="sr" />
	</xsl:template>


  <xsl:template match="sr">
    <xsl:copy>
      <xsl:copy-of select="A[position() &lt;= $maxNr]"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
