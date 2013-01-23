<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:al_p="http://www.eo.ee/xml/xsl/perlscripts">


	<xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8" />


  <xsl:template match="/">
		<xsl:apply-templates select="al:sr" />
	</xsl:template>


	<!-- sõnastik <sr> -->
	<xsl:template match="al:sr">
		<sr>
			<xsl:apply-templates select="art_xpath"></xsl:apply-templates>
		</sr>
	</xsl:template>


	<!-- artikkel <A> (XPath - id ÕS järgi) -->
	<xsl:template match="al:A">
		<A>
      <xsl:variable name="marksonad">
        <xsl:for-each select="siinTulebAsendada">
          <xsl:text> :: </xsl:text>
          <xsl:for-each select="text()">
            <xsl:value-of select="." />
          </xsl:for-each>
        </xsl:for-each>
      </xsl:variable>
      <md>
        <e>m</e>
        <t>
          <xsl:value-of select="substring($marksonad, 5)" />
        </t>
      </md>
      <K>
        <xsl:value-of select="al:K" />
      </K>
      <T>
        <xsl:value-of select="al:T" />
      </T>
      <TA>
        <xsl:value-of select="al:TA" />
      </TA>
      <PT>
        <xsl:value-of select="al:PT" />
      </PT>
      <G>
        <xsl:value-of select="al:G" />
      </G>
      <l>
        <xsl:for-each select="elm_xpath">
          <xsl:copy-of select="."/>
        </xsl:for-each>
      </l>
		</A>
	</xsl:template>


</xsl:stylesheet>
