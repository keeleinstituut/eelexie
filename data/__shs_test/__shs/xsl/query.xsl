<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:al_p="http://www.eo.ee/xml/xsl/perlscripts">


	<xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8" />


	<xsl:param name="vf"></xsl:param>


	<xsl:variable name="dic_desc">
    <xsl:value-of select="substring($vf, 1, 3)" />
  </xsl:variable>

	<xsl:variable name="art_xpath">*</xsl:variable>
	<xsl:variable name="elm_xpath">*</xsl:variable>
	
	<xsl:variable name="attNicht">;KF;O;g;G;aG;aKF;Gt;</xsl:variable>
	<xsl:variable name="elmNicht">;G;K;KA;KL;T;TA;TL;PT;PTA;X;XA;</xsl:variable>


	<xsl:template match="/">
		<xsl:apply-templates select="al:sr" />
	</xsl:template>


	<!-- sõnastik <sr> -->
	<xsl:template match="al:sr">
		<sr>
			<xsl:apply-templates select="$art_xpath"></xsl:apply-templates>
		</sr>
	</xsl:template>


	<!-- artikkel <A> (XPath - id ÕS järgi) -->
	<xsl:template match="al:A">
		<A>
			<vf>
				<xsl:value-of select="$vf"/>
			</vf>
      <s>
        <xsl:value-of select="floor(string-length(.) div 1024) + 1"></xsl:value-of>
      </s>
			<xsl:variable name="marksonad">
        <xsl:choose>
          <xsl:when test="$dic_desc = 'od_'">
            <xsl:for-each select="al:P">
              <xsl:text> :: </xsl:text>
              <xsl:value-of select="al:tmnr" />
              <xsl:text>: &amp;ema;</xsl:text>
              <xsl:value-of select="al:tmen"/>
              <!--mõttekriips "en dash"-->
              <xsl:text>&amp;eml; &#x2013; </xsl:text>
              <xsl:value-of select="al:tmet"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="siinTulebAsendada">
              <xsl:text> :: </xsl:text>
              <xsl:for-each select="text()">
                <xsl:value-of select="." />
              </xsl:for-each>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
			</xsl:variable>
			<md>
				<e>
					<xsl:choose>
            <xsl:when test="$dic_desc = 'od_'">tmen - tmet</xsl:when>
            <xsl:otherwise>_m_</xsl:otherwise>
          </xsl:choose>
				</e>
				<t>
					<xsl:value-of select="substring($marksonad, 5)" />
				</t>
			</md>
			<O>
        <xsl:value-of select="siinTulebVeelAsendada" />
      </O>
      <tlkn>
        <xsl:value-of select="al:P[1]/al:tlkn[1]" />
      </tlkn>
      <maht>
        <xsl:for-each select="al:maht">
          <xsl:if test="position() > 1">:</xsl:if>
          <xsl:value-of select="." />
        </xsl:for-each>
      </maht>
      <K>
				<xsl:value-of select="al:K" />
			</K>
      <KL>
        <xsl:value-of select="translate(al:KL, 'T', ' ')" />
      </KL>
      <T>
				<xsl:value-of select="al:T" />
			</T>
      <TA>
        <xsl:value-of select="translate(al:TA, 'T', ' ')" />
      </TA>
      <TL>
        <xsl:value-of select="translate(al:TL, 'T', ' ')" />
      </TL>
      <PT>
				<xsl:value-of select="al:PT" />
			</PT>
      <PTA>
        <xsl:value-of select="translate(al:PTA, 'T', ' ')" />
      </PTA>
      <G>
				<xsl:value-of select="al:G" />
			</G>
      <l>
        <t>
          <xsl:for-each select="$elm_xpath">
            <span class="_b" nr="{position()}">
              <!--2039 - vasak väike nurksulg-->
              <xsl:value-of select="concat('&#x2039;', local-name())"/>
              <xsl:for-each select="@*[not(contains($attNicht, concat(';', local-name(), ';')))]">
                <xsl:call-template name="att"></xsl:call-template>
              </xsl:for-each>
              <!--203A - parem väike nurksulg-->
              <xsl:text>&#x203A;</xsl:text>
            </span>
            <xsl:for-each select=".//text()[not(contains($elmNicht, concat(';', local-name(..), ';')))]">
              <!--25AA - must väike ruuduke, tühik ees, et murraks -->
              <xsl:text> &#x25AA;</xsl:text>
              <xsl:element name="span">
                <xsl:attribute name="class">
                  <xsl:value-of select="local-name(..)"/>
                </xsl:attribute>
                <!--<xsl:value-of select="al_p:showHL(.)" disable-output-escaping="no"/>-->
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:for-each>
            <xsl:if test="position() &lt; last()">
              <xsl:text> :: </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </t>
      </l>
		</A>
	</xsl:template>


	<xsl:template name="att">
    <!--25AB - valge väike ruuduke-->
		<xsl:value-of select="concat(' &#x25AB;', local-name(), '=')" />
		<xsl:text>"</xsl:text>
		<xsl:value-of select="." />
		<xsl:text>"</xsl:text>
	</xsl:template>


</xsl:stylesheet>
