<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:al="http://www.eo.ee/xml/xsl/scripts">


  <xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8" />


  <msxsl:script language="JScript" implements-prefix="al">
    <![CDATA[

		// script line offset algab reast "msxsl:script" ja alates 1-st,
		// ehk "msxsl:script" eelneva rea #-le liita line number.

    // nii '.' ( self::node() ), 'current()', 'text()' kui ka $muutuja korral tulevad parameetrid 'nodelist' objektina
    // string ('') korral mitte objektina



    var tagaTyhik = '';
    // märksõna <m> korral (v mis esimene on) tagab = 1 tühiku mittepanemise
    var kyljes = 1;
    var currentLn = '';
    
    function paneKylge(sym) {
      kyljes = 1;
      return sym;
    }
    
    function paneTyhikJarele(sym) {
      tagaTyhik = ' ';
      return sym;
    }
    
    function paneTyhikEtte(myNodeList, ln) {
      var prevNode;
      var retStr;
      if (tagaTyhik == ' ')
        retStr = '';
      else {
        if (kyljes == 0) {
          if (ln == currentLn)                                            // omab tähendust ainult elemendi ja tema atribuutide vaheldumisel
            retStr = ' ';
          else {                                                          // algas uus element, atribuudi korral saadetakse ka element ise, mitte atribuut
            if (");:,.!?-".indexOf(myNodeList[0].text.substr(0, 1)) > -1)                      // jooksev
              retStr = '';
            else {
              prevNode = myNodeList[0].selectSingleNode("preceding-sibling::node()[1]");
              if (prevNode == null)
                // kõik on ju tekstid, sellepärast 'parentNode'
                prevNode = myNodeList[0].parentNode.selectSingleNode("preceding-sibling::node()[1]");
              if (prevNode == null)
                retStr = ' ';
              else {
                if ("(-".indexOf(prevNode.text.substr(prevNode.text.length - 1, 1)) > -1)
                  retStr = '';
                else
                  retStr = ' ';
              }
            }
          }
        }
        else
          retStr = '';
      }
//      retStr = currentLn + '->' + ln + ':' + myNodeList[0].nodeName + ':' + retStr;
      currentLn = ln;
      return retStr;
    }



    function capitalize(tekst) {
      return tekst.substr(0, 1).toUpperCase() + tekst.substr(1);
    }



		function RS(currtext, itStyle) {
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

		var ss;
		if (typeof(itStyle) == 'object') { // nodelist
			ss = itStyle[0].text;
		}
		else {
			ss = itStyle;
		}

    // nt = nt.replace("<", "&lt;").replace(">", "&gt;");
    // nt = nt.replace("<", "").replace(">", "");
    
    nt = nt.replace(/_+$/, ''); // alakriipsud <m> jt lõpust maha
    
    //Jutumärgid nagu raamatus: <<  >> (lõpetaval on ees konks)
		//nt = nt.replace(/\^"/g, String.fromCharCode(0x00BB));
		//nt = nt.replace(/"/g, String.fromCharCode(0x00AB));
		//nt = nt.replace(/\^"/g, '\u201D');
		//nt = nt.replace(/"/g, '\u201E');
    

    // $1-$9, $1 on esimene
		// nt = nt.replace(/(&suba;(.+?)&subl;)/g, "$2".sub());
		// nt = nt.replace(/(&supa;(.+?)&supl;)/g, "$2".sup());
		nt = nt.replace(/(&ba;(.+?)&bl;)/g, "$2".bold());
    
		if (ss == '1') { //kursiivis pöörata kursiiv tagasi
			nt = nt.replace(/(&ema;(.+?)&eml;)/g, "<span style='font-style:normal;'>$2</span>");
		}
		else {
			nt = nt.replace(/(&ema;(.+?)&eml;)/g, "$2".italics());
		}

		// muutujad (entities)
		// nt = nt.replace(/(&(\w+?);)/g, "$2".italics());
    
    // nt = nt.replace("&", "&amp;");

    tagaTyhik = '';
    kyljes = 0;
    
		return nt;
		}
]]>
  </msxsl:script>


  <xsl:template match="/">
    <html>
      <head>
        <!--<title>Indeks (en)</title>-->
        <!--<meta HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=utf-8'></meta>-->
      </head>
      <body lang="en" style="font-size:xx-small;">
        <xsl:apply-templates select="*"></xsl:apply-templates>
      </body>
    </html>
  </xsl:template>
  <!-- / -->


  <xsl:template match="trmd">
    <xsl:apply-templates select="trmg">
      <xsl:sort select="trm/@O" lang="en"/>
    </xsl:apply-templates>
  </xsl:template>
  <!-- sr -->


  <xsl:template match="trmg">
    <p>
      <xsl:element name="span">
        <xsl:value-of select="al:RS(trm, '0')" disable-output-escaping="yes" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="al:RS(k, '1')" disable-output-escaping="yes" />
      </xsl:element>
    </p>
  </xsl:template>
  <!-- A -->


</xsl:stylesheet>
