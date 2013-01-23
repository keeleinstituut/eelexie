<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:output method="text" omit-xml-declaration="yes" indent="no" encoding="utf-8" />


  <xsl:template match="*|@*">
    <xsl:call-template name="get_lang"></xsl:call-template>
  </xsl:template>


  <!--viimane jääb jõussse ...-->
  <xsl:include href="../include/incTemplates.xsl" />


</xsl:stylesheet>
