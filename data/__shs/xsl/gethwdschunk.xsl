<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8" />


  <xsl:param name="pos1"></xsl:param>
  <xsl:param name="pos2"></xsl:param>


  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select=".//sr" />
    </xsl:copy>
	</xsl:template>


	<!-- sõnastik <sr> -->
	<xsl:template match="sr">
    <xsl:copy>
      <xsl:copy-of select="A[position() &gt;= number($pos1) and position() &lt;= number($pos2)]"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
