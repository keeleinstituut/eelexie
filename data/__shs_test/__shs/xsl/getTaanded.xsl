<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:al_p="http://www.eo.ee/xml/xsl/perlscripts">

  <!--xmlns:al="see_asendatakse_cgi_poolt"-->


  <xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8" />


  <xsl:param name="dic_desc"></xsl:param>
  <xsl:param name="volFile"></xsl:param>


  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="al:sr" />
    </xsl:copy>
  </xsl:template>


  <!-- sõnastik <sr> -->
  <xsl:template match="al:sr">
    <sr>
      <xsl:apply-templates select="art_xpath"/>
    </sr>
  </xsl:template>


  <!-- artikkel <A> -->
  <xsl:template match="al:A">
    <A>
      <vf>
        <xsl:value-of select="$volFile"/>
      </vf>
      <xsl:variable name="marksonad">
        <xsl:choose>
          <xsl:when test="$dic_desc = 'sp_'">
            <xsl:for-each select="al:P/al:mg/al:mag/al:m">
              <xsl:value-of select="concat('; ', .)" />
              <xsl:if test="@al:i">
                <xsl:value-of select="concat(' ', @al:i)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$dic_desc = 'od_'">
            <xsl:for-each select="al:P">
              <xsl:text>; </xsl:text>
              <xsl:value-of select="al:tmnr" />
              <xsl:text>: &amp;ema;</xsl:text>
              <xsl:value-of select="al:tmen"/>
              <!--mõttekriips "en dash"-->
              <xsl:text>&amp;eml; &#x2013; </xsl:text>
              <xsl:value-of select="al:tmet"/>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="$dic_desc = 'evs'">
            <xsl:for-each select="al:pxis/al:pxisgrp/al:ms">
              <xsl:value-of select="concat('; ', .)" />
              <xsl:if test="@al:msnr">
                <xsl:value-of select="concat(' ', @al:msnr)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="al:P/al:mg/al:m">
              <xsl:value-of select="concat('; ', .)" />
              <xsl:if test="@al:i">
                <xsl:value-of select="concat(' ', @al:i)"/>
              </xsl:if>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <md>
        <xsl:value-of select="substring($marksonad, 3)" />
      </md>
      <G>
        <xsl:choose>
          <xsl:when test="$dic_desc = 'evs'">
            <xsl:value-of select="al:artguid"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="al:G"/>
          </xsl:otherwise>
        </xsl:choose>
      </G>
      <xsl:for-each select="elm_xpath">
        <l>
          <e>
            <xsl:value-of select="name()" />
          </e>
          <t>
            <xsl:value-of select="." />
          </t>
          <r>
            <xsl:value-of select="concat(name(../..), '/', name(..))"/>
          </r>
          <gf>
            <xsl:choose>
              <xsl:when test="ancestor::al:mg">
                <xsl:copy-of select="ancestor::al:mg[1]" />
              </xsl:when>
              <xsl:when test="local-name(..) = 't' or local-name(..) = 't0'">
                <xsl:for-each select="..">
                  <xsl:copy>
                    <xsl:copy-of select="*[not(local-name() = 't')]" />
                  </xsl:copy>
                </xsl:for-each>
              </xsl:when>
              <xsl:when test="local-name(../..) = 't' or local-name(../..) = 't0'">
                <xsl:for-each select="../..">
                  <xsl:copy>
                    <xsl:copy-of select="*[not(local-name() = 't')]" />
                  </xsl:copy>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="../..">
                  <xsl:copy>
                    <xsl:copy-of select="*[not(name() = name(..))]" />
                  </xsl:copy>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </gf>
        </l>
      </xsl:for-each>
    </A>
  </xsl:template>


</xsl:stylesheet>
