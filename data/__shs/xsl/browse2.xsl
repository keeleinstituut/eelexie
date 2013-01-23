<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:al="http://www.eo.ee/xml/xsl/scripts"
xmlns:msxsl="urn:schemas-microsoft-com:xslt">

  <xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8" />


  <msxsl:script language="JScript" implements-prefix="al">
    <![CDATA[

    // script line offset algab reast "msxsl:script" ja alates 1-st,
    // ehk "msxsl:script" eelneva rea #-le liita line number.

    // nii '.' ( self::node() ), 'current()', 'text()' kui ka $muutuja korral tulevad parameetrid 'nodelist' objektina
    // string ('') korral mitte objektina

    function RS(currtext) {
      var nt;
  
      if (typeof(currtext) == 'object') { // nodelist
        if (currtext.length == 0) {
          return '';
        }
        nt = currtext[0].text;
      }
      else {
        nt = currtext;
      }

      nt = nt.replace(/(&suba;(.+?)&subl;)/g, "$2".sub());
      nt = nt.replace(/(&supa;(.+?)&supl;)/g, "$2".sup());
      nt = nt.replace(/(&ba;(.+?)&bl;)/g, "$2".bold());
      nt = nt.replace(/(&la;(.+?)&ll;)/g, "<u>$2</u>");
      nt = nt.replace(/(&ema;(.+?)&eml;)/g, "$2".italics());

      // muutujad (entities)
      // teeme nüüd nii, et ainult teatud asjad asendame (et jääksid oma loomulikku rada kehtima &apos;, &#x0011; jne)
      nt = nt.replace(/(&(ja|jne|jt|ka|ehk|Hrl|hrl|nt|puudub|v|vm|vms|напр\.|и др\.|и т\. п\.|г\.);)/g, "$2".italics());

      return nt;
    }
]]>
  </msxsl:script>


  <xsl:template match="outDOM">

    <html>
      <head>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8"/>
        <style type="text/css">
          .\_md {text-decoration:underline;color:blue;cursor:hand;}
          .\_xsmall {font-size:x-small;}
          .\_xsmall2 {font-size:x-small;color:blue;cursor:hand;}
          .\_hl {background-color:yellow;font-weight:bold;}
          .\_bhl {background-color:pink;font-weight:bold;}
          .\_b {font-weight:bold;}
          .mvt, .tvt, .lvt {background-color:cyan;}
          .m, .ter {color:maroon;font-weight:bold;}
          .t, .d {color:green;font-style:italic;}
          .n {color:blue;}
          .k, .k1, .k2 {color:gray;font-style:italic;}
          .sl, .v, .v1, .v2, .s, .s1, .s2 {font-size:x-small;text-transform:uppercase;}
          .ml {color:sienna;}
        </style>
        <script type="text/javascript" src="html/tools.js"></script>
        <script type="text/javascript">
          <![CDATA[
          var ws, lexListDom;
          function n2itaNimetus(event) {
            var target = event.target ? event.target : event.srcElement;
            var tekstiElem, tekst;
            if (!lexListDom) {
              lexListDom = IDD("File", "../lexlist.xml", false, false, null);
            }
            if (target.tagName == "SPAN" && target.className == "_xsmall2") {
              switch (event.type) {
                case "mouseover":
                  ws = window.status;
                  tekstiElem = lexListDom.documentElement.selectSingleNode("lex[@id = '" + target.innerHTML + "']/name[@l = 'et']");
                  if (tekstiElem) {
                    tekst =  target.innerHTML + ' - ' + xmlElementTextValue(tekstiElem);
                    window.status = tekst;
                  }
                  break;
                case "mouseout":
                  window.status = ws;
                  break;
              }
            }
          }
          ]]>
        </script>
      </head>
      <body id="browseFrameBodyId">
        <table id="opTable" style="width:100%;">
          <tr>
            <td style="vertical-align:middle;font-size:normal;font-weight:bold;">
              <xsl:value-of select="concat(r/i[@n = 'q'], ': ', @qinfo, ' - ')"/>
              <xsl:if test="@leide != ''">
                <!-- <xsl:number value="@leide" grouping-separator=" " grouping-size="3"/> -->
                <xsl:choose>
                  <xsl:when test="contains(@leide, '+')">
                    <xsl:number value="substring-before(@leide, '+')" grouping-separator=" " grouping-size="3"/>
                    <xsl:value-of select="concat('+', substring-after(@leide, '+'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:number value="@leide" grouping-separator=" " grouping-size="3"/>
                  </xsl:otherwise>
                </xsl:choose>
                <!--<xsl:value-of select="@leide"/>-->
                <xsl:value-of select="concat(' ', r/i[@n = 'l'], ', ')"/>
              </xsl:if>
              <!--<xsl:number value="../cnt" grouping-separator=" " grouping-size="3"/>-->
              <xsl:choose>
                <xsl:when test="contains(../cnt, '+')">
                  <xsl:number value="substring-before(../cnt, '+')" grouping-separator=" " grouping-size="3"/>
                  <xsl:value-of select="concat('+', substring-after(../cnt, '+'))"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:number value="../cnt" grouping-separator=" " grouping-size="3"/>
                </xsl:otherwise>
              </xsl:choose>
              <!--<xsl:value-of select="../cnt"/>-->
              <xsl:value-of select="concat(' ', r/i[@n = 'e'], '.')"/>
              <span id="maxPrintArts" style="font-weight:normal;font-size:x-small;">
                (<xsl:value-of select="r/i[@n = 'mpa']"/>)
              </span>
            </td>
            <td>
              <img id="changeTable" title="Muuda tabelit" style="cursor:hand;" src="graphics/TableHS.png" alt="tabeli sisu"></img>
            </td>
            <td>
              <img id="copyTable" title="Kopeeri tabel" src="graphics/CopyHS.png" alt="kopeeri tabel"></img>
            </td>
            <td align="right">
              <img id="eeLex" src="graphics/EELEX_tume.png" title="EELex logo" style="height:13px;"></img>
            </td>
            <td>
              <xsl:element name="img">
                <xsl:attribute name="id">qryMethod</xsl:attribute>
                <xsl:attribute name="src">
                  <xsl:value-of select="concat('graphics/', r/qM)"/>
                </xsl:attribute>
              </xsl:element>
            </td>
          </tr>
        </table>

        <xsl:variable name="dic_desc">
          <xsl:value-of select="r/dd"/>
        </xsl:variable>

        <xsl:variable name="TITLE_FLT_TEXT">
          <xsl:value-of select="r/i[@n = 'flt']"/>
        </xsl:variable>

        <xsl:variable name="TITLE_SORT_TEXT">
          <xsl:value-of select="r/i[@n = 'ts']"/>
        </xsl:variable>

        <div id="browseTableDiv" style="width:100%;height:90%;overflow:auto;border:1px solid black;">
          <table id="browseTable" border="1" style="width:100%;" soors="fromServer">

            <thead style="background-color:navy;color:white;cursor:hand;font-size:x-small;">
              <tr>
                <th nowrap="true" style='width:2cm' title='{$TITLE_SORT_TEXT}'>
                  <xsl:value-of select="r/i[@n = 'nr']" />
                </th>
                <th id="../vf" title='{$TITLE_SORT_TEXT}' style='width:2cm'>
                  <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                  <xsl:value-of select="r/i[@n = 'v']" />
                </th>
                <xsl:if test="$dic_desc = 'mar' or $dic_desc = 'ex_'">
                  <th id="../maht" title='{$TITLE_SORT_TEXT}'>
                    <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                    <xsl:value-of select="r/i[@n = 'capy']" />
                  </th>
                </xsl:if>
                <th id="../md" title='{$TITLE_SORT_TEXT}'>
                  <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                  <xsl:value-of select="r/i[@n = 'hw']" />
                </th>
                <th id="../ddStr" title='{$TITLE_SORT_TEXT}'>
                  <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                  <xsl:value-of select="r/i[@n = 'contIn']" />
                </th>
                <th id="t" title='{$TITLE_SORT_TEXT}' style='width:2cm'>
                  <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                  <xsl:value-of select="r/i[@n = 'm']" />
                </th>
                <xsl:if test="$dic_desc = 'od_'">
                  <th id="../tlkn" title='{$TITLE_SORT_TEXT}'>
                    <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                    <xsl:value-of select="r/i[@n = 'tr']" />
                  </th>
                </xsl:if>
                <th id="../K" title='{$TITLE_SORT_TEXT}' style='width:2cm'>
                  <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                  <xsl:value-of select="r/i[@n = 'K']" />
                </th>
                <th id="../KL" title='{$TITLE_SORT_TEXT}' style='width:2cm'>
                  <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                  <xsl:value-of select="r/i[@n = 'KL']" />
                </th>
                <th id="../T" title='{$TITLE_SORT_TEXT}'>
                  <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                  <xsl:value-of select="r/i[@n = 'T']" />
                </th>
                <th id="../TA" title='{$TITLE_SORT_TEXT}'>
                  <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                  <xsl:value-of select="r/i[@n = 'TA']" />
                </th>
                <th id="../TL" title='{$TITLE_SORT_TEXT}' style='width:2cm'>
                  <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                  <xsl:value-of select="r/i[@n = 'TL']" />
                </th>
                <th id="../PT" title='{$TITLE_SORT_TEXT}'>
                  <img id="filterImg" style="width:16px;float:left;" src="graphics/minus.ico" title="{$TITLE_FLT_TEXT}"></img>
                  <xsl:value-of select="r/i[@n = 'PT']" />
                </th>
              </tr>
            </thead>

            <tbody>
              <xsl:for-each select="sr/A/l[not(@show = 'false')]">
                <!-- <xsl:sort> koht -->
                <tr>
                  <td>
                    <!--<l> position() on sama mis <A> korral-->
                    <xsl:number grouping-separator=" " grouping-size="3" value="position()" />
                    <xsl:text>: </xsl:text>
                    <span style="font-size:x-small;">
                      <xsl:value-of select="../s" />
                    </span>
                  </td>
                  <td align="center">
                    <xsl:number value="substring(../vf, 4, 1)" format="I" />
                  </td>
                  <xsl:if test="$dic_desc = 'mar' or $dic_desc = 'ex_'">
                    <td>
                      <xsl:value-of select="../maht" />
                    </td>
                  </xsl:if>
                  <td>
                    <xsl:element name="span">
                      <xsl:attribute name="class">_md</xsl:attribute>
                      <xsl:attribute name="value">
                        <xsl:value-of select="concat(../vf, '||', ../G)" />
                      </xsl:attribute>
                      <xsl:value-of select="al:RS(string(../md/t))" disable-output-escaping="yes" />
                      <!--<xsl:value-of select="../md/t" />-->
                    </xsl:element>
                  </td>
                  <td class="_koondParing" onmouseover="n2itaNimetus(event)" onmouseout="n2itaNimetus(event)">
                    <xsl:choose>
                      <xsl:when test="../ddStr = ''">&#xa0;</xsl:when>
                      <xsl:otherwise>
                        <xsl:for-each select="../ddStr/node()">
                          <xsl:copy-of select="current()" />
                        </xsl:for-each>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:for-each select="t/*">
                      <span class="_b">
                        <xsl:value-of select="concat('&#x2039;', local-name())"/>
                        <xsl:for-each select="@*[local-name() = 'i']">
                          <xsl:call-template name="att"></xsl:call-template>
                        </xsl:for-each>
                        <xsl:value-of select="'&#x203A;'"/>
                      </span>
                      <xsl:apply-templates select="node()"/>
                      <xsl:if test="position() &lt; last()">
                        <xsl:text> :: </xsl:text>
                      </xsl:if>
                    </xsl:for-each>
                  </td>
                  <xsl:if test="$dic_desc = 'od_'">
                    <td class='_xsmall'>
                      <xsl:choose>
                        <xsl:when test="../tlkn = ''">&#xa0;</xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="../tlkn" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </xsl:if>
                  <td class='_xsmall'>
                    <xsl:choose>
                      <xsl:when test="../K = ''">&#xa0;</xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="../K" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td class='_xsmall'>
                    <xsl:choose>
                      <xsl:when test="../KL = ''">&#xa0;</xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="../KL" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td class='_xsmall'>
                    <xsl:choose>
                      <xsl:when test="../T = ''">&#xa0;</xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="../T" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td class='_xsmall'>
                    <xsl:choose>
                      <xsl:when test="../TA = ''">&#xa0;</xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="../TA" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td class='_xsmall'>
                    <xsl:choose>
                      <xsl:when test="../TL = ''">&#xa0;</xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="../TL" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td class='_xsmall'>
                    <xsl:choose>
                      <xsl:when test="../PT = ''">&#xa0;</xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="../PT" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody>

          </table>
        </div>

      </body>
    </html>
    
  </xsl:template>


  <xsl:template match="*">
    <!--<span class="_b">
      <xsl:value-of select="concat('&#x2039;', local-name())"/>
      <xsl:for-each select="@*[not(local-name() = 'O')]">
        <xsl:call-template name="att"></xsl:call-template>
      </xsl:for-each>
      <xsl:value-of select="'&#x203A;'"/>
    </span>-->
    <xsl:apply-templates select="node()"></xsl:apply-templates>
    <xsl:for-each select="@*[local-name() = 'i']">
      <xsl:call-template name="att2"></xsl:call-template>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="text()">
    <xsl:if test="not(local-name(..) = 'A')">
      <xsl:text> &#x25AA;</xsl:text>
      <xsl:element name="span">
        <xsl:attribute name="class">
          <xsl:value-of select="local-name(..)"/>
        </xsl:attribute>
        <xsl:value-of select="al:RS(string(.))" disable-output-escaping="yes"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template name="att">
    <span class="_xsmall">
      <xsl:value-of select="concat(' &#x25AB;', local-name(), '=')" />
      <xsl:text>"</xsl:text>
      <xsl:value-of select="." />
      <xsl:text>"</xsl:text>
    </span>
  </xsl:template>


  <xsl:template name="att2">
    <span class="_xsmall">
      <xsl:value-of select="concat('[&#x25AB;', local-name(), '=')" />
      <xsl:text>"</xsl:text>
      <xsl:value-of select="." />
      <xsl:text>"]</xsl:text>
    </span>
  </xsl:template>


</xsl:stylesheet>
