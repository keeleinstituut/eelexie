<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" omit-xml-declaration="no" indent="no" encoding="utf-8"/>

  <xsl:variable name="dic_desc">xxx</xsl:variable>

  <!--23. sept 2011-->
  <xsl:variable name="fr_sym">?</xsl:variable>
  <xsl:variable name="to_sym">?</xsl:variable>


 <xsl:template match="/">
    <xsl:copy>
      <!--outDOM: outDOM/sr
      tavaline sõnastik: sr-->
      <xsl:apply-templates select="*" />
    </xsl:copy>
  </xsl:template>


  <xsl:template match="outDOM">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="al:sr" />
    </xsl:copy>
  </xsl:template>


  <xsl:template match="al:sr">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:choose>
        <xsl:when test="$dic_desc = 'od_'">
          <xsl:apply-templates select="al:A">
            <xsl:sort select="al:P/al:tmnr/@al:O" data-type="number" order="ascending" case-order="lower-first" />
          </xsl:apply-templates>
        </xsl:when>
        <!--<xsl:when test="$dic_desc = 'ief'">
          <xsl:apply-templates select="al:A">
            <xsl:sort select="concat(translate(al:P/al:terg/al:ter/@al:O, $fr_sym, $to_sym), al:P/al:terg/al:ter/@al:O)" data-type="text" order="ascending" />
            <xsl:sort select="al:P/al:terg/al:ter/@al:i" data-type="text" order="ascending" />
          </xsl:apply-templates>
        </xsl:when>-->

        <xsl:otherwise>
          <xsl:apply-templates select="al:A">
            <xsl:sort select="siinTulebAsendada" data-type="text" order="ascending" />
            <!--<xsl:sort select="translate(al:P/al:mg/al:m/@al:O, $fr_sym, $to_sym)" data-type="text" order="ascending" />-->
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="al:A">
    <xsl:copy-of select="current()" />
  </xsl:template>


</xsl:stylesheet>
