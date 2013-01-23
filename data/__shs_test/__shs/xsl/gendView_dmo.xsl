<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:al="http://www.eo.ee/xml/xsl/scripts" xmlns:eRegs="http://exslt.org/regular-expressions" xmlns:pref="http://www.eki.ee/dict/dmo" xmlns:x="http://www.eki.ee/dict/dmo" version="1.0" exclude-result-prefixes="msxsl eRegs">
	<xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8"/>
	<!--Chrome ja Safari ei toeta include ja import-->
	<!--<xsl:include href="../xsl/include/incTemplates.xsl"/>-->
	<msxsl:script language="javascript" implements-prefix="al">

    var tagaTyhik = '';
    // &lt;!--m&#xE4;rks&#xF5;na m korral tagab = 1 t&#xFC;hiku mittepanemise--&gt;
    var kyljes = 1;
    var currentLn = '';
    var dic_desc = '';
    var dotNet = '';
    var itad = '';
    var paksud = '';
    
    var dicPr = '?', dicUri = '?';
    var xmlNsMgr;

    function myInit(parDicDesc, parDotNet, parItad, parPaksud, parDicPr, parDicUri) {
        dic_desc = parDicDesc;
        dotNet = parDotNet;
        itad = parItad;
        paksud = parPaksud;
        dicPr = parDicPr;
        dicUri = parDicUri;
        if (dotNet == '1') {
            xmlNsMgr = new XmlNamespaceManager(new NameTable);
            xmlNsMgr.AddNamespace(dicPr, dicUri);
            xmlNsMgr.AddNamespace("pref", dicUri);
        }
        return '';
    }

    function paneKylge(sym) {
      kyljes = 1;
      // Extension function parameters or return values which have Clr type 'ConcatString' are not supported
      return "" + sym;
    }
    
    function paneTyhikJarele(sym) {
      tagaTyhik = ' ';
      // Extension function parameters or return values which have Clr type 'ConcatString' are not supported
      return "" + sym;
    }
    
    function paneTyhikEtte(myNodeList, ln) {
      var retStr;
      var tekst, prevNode, eelmTekst = '';

      if (dotNet == '1') { // kas l&#xE4;heb .NET alt?
        myNodeList.MoveNext();
        var nav = myNodeList.Current;
        tekst = nav.Value;
        prevNode = nav.SelectSingleNode("preceding-sibling::node()[1]");
        if (!prevNode) {
            // k&#xF5;ik on ju tekstid, sellep&#xE4;rast 'parentNode'
            prevNode = nav.SelectSingleNode("../preceding-sibling::node()[1]");
        }
        if (prevNode) {
          eelmTekst = prevNode.Value;
        }
      }
      else {
        tekst = myNodeList[0].text;
        prevNode = myNodeList[0].selectSingleNode("preceding-sibling::node()[1]");
        if (!prevNode) {
            // k&#xF5;ik on ju tekstid, sellep&#xE4;rast 'parentNode'
            prevNode = myNodeList[0].parentNode.selectSingleNode("preceding-sibling::node()[1]");
        }
        if (prevNode) {
          eelmTekst = prevNode.text;
        }
      }

      if (tagaTyhik == ' ')
          retStr = '';
        else {
          if (kyljes == 0) {
            if (ln == currentLn)                                            // omab t&#xE4;hendust ainult elemendi ja tema atribuutide vaheldumisel
              retStr = ' ';
            else {                                                          // algas uus element, atribuudi korral saadetakse ka element ise, mitte atribuut
              if (");:,.!?-".indexOf(tekst.substr(0, 1)) &gt; -1) {            // jooksev
                  if (tekst.length &gt; 1) {
                      if (" .,;:".indexOf(tekst.substr(1, 1)) &gt; -1) {
                        retStr = '';
                      } else {
                        retStr = ' ';
                      }
                  }
                  else
                      retStr = '';
              }
              else {
                  retStr = ' ';
                  if (eelmTekst) {
                      if (dic_desc == "ety") {
                          if ("(".indexOf(eelmTekst.substr(eelmTekst.length - 1, 1)) &gt; -1)
                              retStr = '';
                      } else if (dic_desc == "ss1") {
                          if ("(".indexOf(eelmTekst.substr(eelmTekst.length - 1, 1)) &gt; -1)
                              retStr = '';
                      } else if (dic_desc == "ems") {
                          if ("(".indexOf(eelmTekst.substr(eelmTekst.length - 1, 1)) &gt; -1)
                              retStr = '';
                      } else {
                          if ("(-".indexOf(eelmTekst.substr(eelmTekst.length - 1, 1)) &gt; -1)
                              retStr = '';
                      }
                  }
              } // ");:,.!?-".indexOf(tekst.substr(0, 1)) &gt; -1
            } // ln == currentLn
          } // kyljes == 0
          else
            retStr = '';
        } // tagatyhik == ' '
  //      retStr = currentLn + '- &gt;' + ln + ':' + myNodeList[0].nodeName + ':' + retStr;
        currentLn = ln;
        return retStr;
    }


    function xslNumberToRepString(xslNumber, repStr, lenOffStr) {
        var xslNumbers = xslNumber.split('.');
        var lenOff = parseInt(lenOffStr);
        var rets = '';
        for (var ix = 0; ix &lt; xslNumbers.length + lenOff; ix++) {
            rets += repStr;
        }
        // Extension function parameters or return values which have Clr type 'ConcatString' are not supported
        return "" + rets;
    }


    function capitalize(tekst) {
      return tekst.substr(0, 1).toUpperCase() + tekst.substr(1);
    }

    function unNameXsl(inpStr) {
        var unStr = '', i;
        // unStr = inpStr.replace(/:/, "-");
        for (i = 0; i &lt; inpStr.length; i++) {
            unStr += '_' + inpStr.charCodeAt(i);
        }
        // Extension function parameters or return values which have Clr type 'ConcatString' are not supported
        return "" + unStr;
    }

    function RS(currtext, locName) {
        var ln = locName, currElemNode = null, currParent = null, nt = '';
  
        if (typeof(currtext) == 'object'){ // nodelist
          if (dotNet == '1') {
            // currtext tuleb sisse '{MS.Internal.Xml.XPath.XPathArrayIterator}' t&#xFC;&#xFC;pi
            // see on 'XPathNodeIterator' t&#xFC;&#xFC;pi
            // MoveNext():
            // "moves the XPathNavigator object returned by the Current property to the next node in the selected node set."
            currtext.MoveNext();
            var nav = currtext.Current;
            nt = nav.Value;
            currElemNode = nav.SelectSingleNode("..");
            currParent = currElemNode.SelectSingleNode("..");
          }
          else {
            nt = currtext[0].text;
            currElemNode = currtext[0].parentNode;
            // currParent = currElemNode.parentNode; // psv p&#xE4;rast, ja alati ei pruugi parent olemas olla
          }
        }
        else{
          nt = currtext;
        }
        
        
        
        if (ln == 'src'){
            nt = nt.replace(/^\s*(http:\/\/[^\s]+)\s*$/, "&lt;a href='$1'&gt;$1&lt;/a&gt;"); // 
        }
        
        // siia pane tekstide 'reksAsendused'

        // Jutum&#xE4;rgid nagu raamatus: &lt;&lt;  &gt;&gt; (l&#xF5;petaval on ees konks)
        // nt = nt.replace(/\^"/g, String.fromCharCode(0x00BB));
        // nt = nt.replace(/"/g, String.fromCharCode(0x00AB));
        // nt = nt.replace(/\^"/g, '\u201D');
        // nt = nt.replace(/"/g, '\u201E');
        nt = nt.replace(/"\b/g, '\u201E');
        nt = nt.replace(/\b"/g, '\u201D');

        if (ln == 'm' || ln == 'mvt' || ln == 'tvt')
            nt = nt.replace(/_+$/, ''); // alakriipsud m jt l&#xF5;pust maha
    
        // muutt&#xFC;&#xFC;pides paralleelvormide eraldajad, t&#xFC;&#xFC;binumbrid
        if (ln == 'mt') {
          if ((dic_desc == 'ex_') &amp;&amp; dotNet != '0') {
            var tarr, i, tyyp, lisand;
            tarr = nt.split("_&amp;_");
            for (i = 0; i &lt; tarr.length; i++) {
                tyyp = tarr[i], lisand = '';
                if (tyyp.substr(0, 1) == '0') {
                  tyyp = tyyp.substr(1);
                }
                if (tyyp.substr(tyyp.length - 1, 1) == '?') {
                  tyyp = tyyp.substr(0, tyyp.length - 1);
                  lisand = '?';
                } else if (tyyp.substr(tyyp.length - 1, 1) == '~') {
                  tyyp = tyyp.substr(0, tyyp.length - 1);
                  lisand = '~';
                }
                tarr[i] = "&lt;a href='inc/tyypsonad_" + dic_desc + ".html#tp" + tyyp + "'&gt;" + tyyp + "&lt;/a&gt;" + lisand;
            }
            nt = tarr.join("_&amp;_");
          }
          nt = nt.replace(/_&amp;_/g, " &amp;amp; ");
        }

        if (dic_desc == 'ss_') {
            if (ln == 'vk' || ln == 'sl') {
              nt = nt.replace(/(\s)/g, ".$1");
            }
            if (ln == 'caut') {
              nt = nt.replace(/(\.\s+)/g, ".&amp;#xA0;"); //NO-BREAK SPACE
            }
            if (ln == 'n' || ln == 'c') {
              nt = nt.replace(/(^\.\.\s+)/, "..&amp;#xA0;"); //NO-BREAK SPACE
              nt = nt.replace(/(\s+\.\.)/g, "&amp;#xA0;.."); //NO-BREAK SPACE
            }
            if (ln == 'hev' || ln == 'd') {
              nt = nt.replace(/(-)/g, "&amp;#x2011;"); //NO-BREAKING HYPHEN
            }
        }
        
        if (dic_desc == 'ems') {
            nt = nt.replace(/\-\s\-/g, "\u2011\xA0\u2011"); // murdumatu kriips + murdumatu t&#xFC;hik + murdumatu kriips
            nt = nt.replace(/\-(\S)/g, "\u2011$1");
            nt = nt.replace(/(\S)\-/g, "$1\u2011");
        }

        if (dic_desc == 'ldw') {
            nt = nt.replace(/&#xF5;/g, 'o\u0324\u0323'); // kombineerivad dierees + punkt all
            nt = nt.replace(/&#xD5;/g, 'O\u0324\u0323'); // kombineerivad dierees + punkt all
        }

        if (dic_desc == 'qs_' || dic_desc == 'eos'|| dic_desc == 'kno') {
            // slash / asendus alakaarega, hiljem v&#xF5;ib HTML t&#xF5;ttu juba olla lisa /
            nt = nt.replace(/\//g, String.fromCharCode(0x203F)); //undertie
            nt = nt.replace(/\+/g, String.fromCharCode(0x203F)); //undertie
            
            nt = nt.replace(/(\{(([^{}]*?)([^\s{}]+?)([^{}]*?))\})/g, "&lt;span style='color: gray;'&gt;$2&lt;/span&gt;");
            
            nt = nt.replace(/&#xA4;/g, '\u00b4'); //acute accent
        }

        if (dic_desc == 'psv') {
            if (ln == 'mv') {
                // muutevormide tekstis formatiivipiir ja l&#xF5;puke
                nt = nt.replace(/\[/g, '');
                nt = nt.replace(/\//g, '');
            } else if (ln == 'kol') {
                var esiOsa = nt.substr(0, nt.indexOf(" ") + 1); // koos t&#xFC;hikuga
                if (esiOsa.length &gt; 0) {
                    var tagaOsa = nt.substr(nt.lastIndexOf(" ")); // koos t&#xFC;hikuga
                    if (dotNet == '1') {
                      // esiosad samad: trepist &#xFC;les minema, trepist alla minema
                      if (!currParent.SelectSingleNode("c:kol[not(contains(concat('~~~', .), '~~~" + esiOsa + "'))]", xmlNsMgr)) {
                          if (currElemNode.SelectSingleNode("preceding-sibling::c:kol", xmlNsMgr))
                              nt = nt.substr(nt.indexOf(" ") + 1);
                      // tagaosad samad: kitsas trepp, lai trepp, k&#xF5;rge trepp, j&#xE4;rsk trepp
                      } else if (!currParent.SelectSingleNode("c:kol[not(contains(concat(., '~~~'), '" + tagaOsa + "~~~'))]", xmlNsMgr)) {
                          if (currElemNode.SelectSingleNode("following-sibling::c:kol", xmlNsMgr))
                              nt = nt.substr(0, nt.lastIndexOf(" "));
                      }
                    }
                    else {
                      // esiosad samad: trepist &#xFC;les minema, trepist alla minema
                      if (!currElemNode.parentNode.selectSingleNode("c:kol[not(contains(concat('~~~', .), '~~~" + esiOsa + "'))]")) {
                          if (currElemNode.selectSingleNode("preceding-sibling::c:kol"))
                              nt = nt.substr(nt.indexOf(" ") + 1);
                      // tagaosad samad: kitsas trepp, lai trepp, k&#xF5;rge trepp, j&#xE4;rsk trepp
                      } else if (!currElemNode.parentNode.selectSingleNode("c:kol[not(contains(concat(., '~~~'), '" + tagaOsa + "~~~'))]")) {
                          if (currElemNode.selectSingleNode("following-sibling::c:kol"))
                              nt = nt.substr(0, nt.lastIndexOf(" "));
                      }
                    }
                }
            }
        }

        // liited (sufiksid, prefiksid) paksus kirjas
        if (dic_desc == 'sp_' || dic_desc == 'spi' || dic_desc == 'spp') {
            if (ln == 'ml' || ln == 'mml') {
                var esi = '', taga = nt;
                if (nt.indexOf(":") &gt; -1) {
                    esi = nt.substr(0, nt.indexOf(":"));
                    taga = nt.substr(nt.indexOf(":") + 1);
                }
                taga = taga.replace(/(=(.*?)(#|\+|$))/g, "=&lt;b style='font-weight:bold;'&gt;$2&lt;/b&gt;$3");
                taga = taga.replace(/(,(.*?)(=|\+|~|#|$))/, "-&lt;b style='font-weight:bold;'&gt;$2&lt;/b&gt;$3");
                taga = taga.replace(/#(?!ma$)/g, "");
                if (esi.length &gt; 0) {
                    nt = "&lt;b style='font-weight:bold;'&gt;" + esi + "&lt;/b&gt;:" + taga;
                }
                else {
                    nt = taga;
                }
            }
        }


        // $1-$9, $1 on esimene
        nt = nt.replace(/(&amp;suba;(.+?)&amp;subl;)/g, "$2".sub());
        nt = nt.replace(/(&amp;supa;(.+?)&amp;supl;)/g, "$2".sup());
        nt = nt.replace(/(&amp;la;(.+?)&amp;ll;)/g, "&lt;u&gt;$2&lt;/u&gt;");
        nt = nt.replace(/(&amp;capa;(.+?)&amp;capl;)/g, "&lt;i style='font-weight:bold;font-style:italic;font-variant:small-caps;'&gt;$2&lt;/i&gt;");
        nt = nt.replace(/(&amp;br;)/g, "&lt;br/&gt;");

        // nt = nt.replace(/(&amp;ba;(.+?)&amp;bl;)/g, "$2".bold());
        if (paksud.indexOf(';etvw_' + ln + ';') &gt; -1) { //paksus mitte-paks
            nt = nt.replace(/(&amp;ba;(.+?)&amp;bl;)/g, "&lt;b style='font-weight:normal;'&gt;$2&lt;/b&gt;");
        }
        else {
            nt = nt.replace(/(&amp;ba;(.+?)&amp;bl;)/g, "&lt;b style='font-weight:bold;'&gt;$2&lt;/b&gt;");
        }

        if (itad.indexOf(';etvw_' + ln + ';') &gt; -1) { //kursiivis p&#xF6;&#xF6;rata kursiiv tagasi
            nt = nt.replace(/(&amp;ema;(.+?)&amp;eml;)/g, "&lt;i style='font-style:normal;'&gt;$2&lt;/i&gt;");
        }
        else {
            nt = nt.replace(/(&amp;ema;(.+?)&amp;eml;)/g, "$2".italics());
        }

        // muutujad (entities)
        // nt = nt.replace(/(&amp;(\w+?);)/g, "$2".italics());
        nt = nt.replace(/(&amp;(ehk|Hrl|hrl|ja|jne|jt|ka|nt|puudub|v|vm|vms|vrd|vt|&#x43D;&#x430;&#x43F;&#x440;\.|&#x438; &#x434;&#x440;\.|&#x438; &#x442;\. &#x43F;\.|&#x433;\.);)/g, "$2".italics());

        // 0x1D100 - 0x1D126
/*
        var muss = '';
        for(i=0xDD00; i&lt;=0xDD26; i++) {
            muss += String.fromCharCode(0xD834, i);
        }
        var re = new RegExp("\(\[" + muss + "\]\)", 'g');
        nt = nt.replace(re, "&lt;span style='font-family:symbola;font-size:x-large'&gt;$1&lt;/span&gt;");
*/

        nt = nt.replace(/&amp;gclef;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#xA0;&amp;#xA0;&amp;#xA0;&amp;#x1D11E;&lt;/span&gt;");
        nt = nt.replace(/&amp;gclefottavaalta;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#x1D11F;&lt;/span&gt;");
        nt = nt.replace(/&amp;gclefottavabassa;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#x1D120;&lt;/span&gt;");
        nt = nt.replace(/&amp;cclef;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#xA0;&amp;#xA0;&amp;#xA0;&amp;#x1D121;&lt;/span&gt;");
        nt = nt.replace(/&amp;fclef;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#xA0;&amp;#xA0;&amp;#xA0;&amp;#x1D122;&lt;/span&gt;");
        nt = nt.replace(/&amp;fclefottavaalta;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#x1D123;&lt;/span&gt;");
        nt = nt.replace(/&amp;fclefottavabassa;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#x1D124;&lt;/span&gt;");
        nt = nt.replace(/&amp;drumclef1;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#x1D125;&lt;/span&gt;");
        nt = nt.replace(/&amp;drumclef2;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#x1D126;&lt;/span&gt;");
        nt = nt.replace(/&amp;brevis;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#x1D1B8;&lt;/span&gt;");

        nt = nt.replace(/&amp;fermata;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#x1D110;&lt;/span&gt;");
        nt = nt.replace(/&amp;segno;/g, "&lt;span style='font-family:symbola;font-size:x-large'&gt;&amp;#x1D10B;&lt;/span&gt;");

        if (dic_desc == 'sp_' || dic_desc == 'spi' || dic_desc == 'spp') {
            if (ln == 'ml' || ln == 'mml') {
                nt = nt.replace(/[;\|&#xA4;]/g, "");
            }
            nt = nt.replace(/#/g, "/");
        }

        l6petaTekst();
    
        return nt;
        }

        function l6petaTekst() {
            tagaTyhik = '';
            kyljes = 0;
            return '';
        }

        </msxsl:script>
	<xsl:variable name="pildiJuurikas">../__sr/</xsl:variable>
	<xsl:variable name="dic_desc">dmo</xsl:variable>
	<xsl:variable name="dotNet">0</xsl:variable>
	<xsl:variable name="msie">1</xsl:variable>
	<xsl:variable name="itad">;etvw_r;etvw_hld;etvw_vk;etvw_mt;etvw_sl;etvw_d;etvw_xr;etvw_xvk;etvw_xmt;etvw_xsl;etvw_xz;etvw_xgki;etvw_xd;etvw_n;etvw_nd;etvw_lsd;etvw_xtx;</xsl:variable>
	<xsl:variable name="paksud">;etvw_m;etvw_mm;etvw_n;etvw_LS;</xsl:variable>
	<xsl:variable name="edMode">0</xsl:variable>
	<xsl:variable name="printing">0</xsl:variable>
	<xsl:variable name="showShaded">1</xsl:variable>
	<xsl:template match="/">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<!--dotNet-is tuleb esimesena <A> !!! -->
	<!--Word väljatrükis <sr> -->
	<!--artikli korral DOM ise-->
	<xsl:template match="pref:sr">
		<xsl:if test="function-available('al:myInit')">
			<xsl:value-of select="al:myInit(string($dic_desc), string($dotNet), string($itad), string($paksud), substring-before(name(), ':'), namespace-uri())"/>
		</xsl:if>
		<xsl:variable name="juurStiil">
			<xsl:choose>
				<xsl:when test="$printing = '1'"/>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="body">
			<xsl:attribute name="lang">
				<xsl:choose>
					<xsl:when test="@xml:lang">
						<xsl:value-of select="@xml:lang"/>
					</xsl:when>
					<xsl:otherwise>et</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="$juurStiil != ''">
				<xsl:attribute name="style">
					<xsl:value-of select="$juurStiil"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$showShaded = '1' and $printing = '1'">
				<div>
					<h3 style="background-color: silver;">
						<xsl:value-of select="@qinfo"/>
					</h3>
				</div>
			</xsl:if>
			<xsl:apply-templates select="pref:A[not(@pref:Al = 'all') or $printing = '0']">
				<xsl:with-param name="rada"/>
				<xsl:with-param name="peidus"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	<xsl:template name="elemendiSisemus">
		<xsl:param name="rada"/>
		<xsl:param name="posnr"/>
		<xsl:param name="peidus"/>
		<xsl:choose>
			<xsl:when test="1 = 2"/>
			<xsl:when test="@pref:mT = 'img'">
				<xsl:element name="div">
					<xsl:element name="img">
						<xsl:attribute name="src">
							<xsl:value-of select="concat($pildiJuurikas, $dic_desc, '/__pildid/', .)"/>
						</xsl:attribute>
						<xsl:attribute name="alt">
							<xsl:value-of select="."/>
						</xsl:attribute>
						<xsl:attribute name="title">
							<xsl:value-of select="concat('&lt;', ., '&gt;')"/>
						</xsl:attribute>
						<xsl:if test="@pref:mW">
							<xsl:attribute name="style">
                width:<xsl:value-of select="@pref:mW"/>;
              </xsl:attribute>
						</xsl:if>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@pref:mT = 'html'">
				<xsl:element name="div">
					<xsl:attribute name="class">
						<!--MS Word loeb sisse ainult esimese className-->
						<xsl:value-of select="concat('etvw_', translate(name(), ':', '_'))"/>
						<xsl:choose>
							<xsl:when test="function-available('al:unNameXsl')">
								<xsl:value-of select="al:unNameXsl(local-name())"/>
							</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:copy-of select="node()"/>
				</xsl:element>
			</xsl:when>
			<!-- keeleplokkide valimise järjekord -->
			<xsl:otherwise>
				<xsl:apply-templates select="node()[not(. = '')]">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
					</xsl:with-param>
					<xsl:with-param name="peidus">
						<xsl:value-of select="$peidus"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*"/>
	<xsl:template match="text()">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="function-available('al:paneTyhikEtte')">
				<xsl:value-of select="al:paneTyhikEtte(., local-name(..))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text xml:space="preserve"> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:element name="span">
			<xsl:if test="$printing = '0' and $peidus = ''">
				<xsl:attribute name="tabIndex">0</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($rada, 'text()[', $posnr, ']')"/>
				</xsl:attribute>
				<xsl:attribute name="title">
					<xsl:value-of select="concat($rada, 'text()[', $posnr, ']')"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="class">
				<!--MS Word loeb sisse ainult esimese className-->
				<xsl:value-of select="concat('etvw_', translate(name(..), ':', '_'))"/>
				<xsl:choose>
					<xsl:when test="function-available('al:unNameXsl')">
						<xsl:value-of select="al:unNameXsl(local-name(..))"/>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="$edMode = '1'">
					<xsl:text> noedit</xsl:text>
				</xsl:if>
				<!-- tekstiLink -->
				<xsl:if test="((name(..) = 'x:a') or (name(..) = 'x:mvt') or (name(..) = 'x:tvt')) and $printing = '0'">
					<xsl:value-of select="concat(' lingike G_', ../@pref:aG, ' href_', ../@pref:href, ' dst_', ../@pref:dst)"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:variable name="styleInSpan">
				<xsl:if test="(../@pref:liik=&quot;z&quot;) and name(..) = 'x:m'">font-style:italic;</xsl:if>
				<xsl:if test="name(../..) = 'x:gri' and name(..) = 'x:gki'">font-size:x-small;</xsl:if>
				<xsl:if test="(.=&quot;|vaste|&quot;) and name(..) = 'x:x'">color:red;</xsl:if>
				<xsl:if test="(.=&quot;|t&#xF5;lge|&quot;) and name(..) = 'x:qn'">color:red;</xsl:if>
			</xsl:variable>
			<xsl:if test="string-length($styleInSpan) &gt; 0">
				<xsl:attribute name="style">
					<xsl:value-of select="$styleInSpan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="lang">
				<xsl:call-template name="get_lang"/>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="1 = 2"/>
				<!-- tekstiSisu -->
				<xsl:when test="(. = 'A') and name(..) = 'x:sl'">
					<xsl:choose>
						<xsl:when test="function-available('al:l6petaTekst')">adj<xsl:value-of select="al:l6petaTekst()"/>
						</xsl:when>
						<xsl:otherwise>adj</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="(. = 'S') and name(..) = 'x:sl'">
					<xsl:choose>
						<xsl:when test="function-available('al:l6petaTekst')">s<xsl:value-of select="al:l6petaTekst()"/>
						</xsl:when>
						<xsl:otherwise>s</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="function-available('al:RS')">
							<xsl:value-of select="al:RS(., string(local-name(..)))" disable-output-escaping="yes"/>
						</xsl:when>
						<xsl:when test="function-available('eRegs:replace')">
							<xsl:value-of select="eRegs:replace(., '(&amp;\w+;)', 'g', '')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:param name="rada"/>
		<xsl:element name="span">
			<xsl:if test="$printing = '0'">
				<xsl:attribute name="tabIndex">0</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($rada, '@', name())"/>
				</xsl:attribute>
				<xsl:attribute name="title">
					<xsl:value-of select="concat($rada, '@', name())"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('atvw_', translate(name(..), ':', '_'), '_', translate(name(), ':', '_'))"/>
				<xsl:choose>
					<xsl:when test="function-available('al:unNameXsl')">
						<xsl:value-of select="al:unNameXsl(local-name())"/>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="$edMode = '1'">
					<xsl:text> noedit</xsl:text>
				</xsl:if>
				<!-- atribuudiLink -->
				<xsl:if test="1 = 2">
					<xsl:text> lingike</xsl:text>
				</xsl:if>
			</xsl:attribute>
			<xsl:variable name="styleInSpanAttr"/>
			<xsl:if test="string-length($styleInSpanAttr) &gt; 0">
				<xsl:attribute name="style">
					<xsl:value-of select="$styleInSpanAttr"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="lang">
				<xsl:call-template name="get_lang"/>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="1 = 2"/>
				<!-- atribuudiSisu -->
				<xsl:when test="(. = 'var') and name(..) = 'x:mvt' and name() = 'x:mvtl'">
					<xsl:choose>
						<xsl:when test="function-available('al:l6petaTekst')">
							<i>vt</i>
							<xsl:value-of select="al:l6petaTekst()"/>
						</xsl:when>
						<xsl:otherwise>
							<i>vt</i>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="(. = 'srj') and name(..) = 'x:mvt' and name() = 'x:mvtl'">
					<xsl:choose>
						<xsl:when test="function-available('al:l6petaTekst')">
							<i>vt ka</i>
							<xsl:value-of select="al:l6petaTekst()"/>
						</xsl:when>
						<xsl:otherwise>
							<i>vt ka</i>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="(. = 'l&#xFC;h') and name(..) = 'x:mvt' and name() = 'x:mvtl'">
					<xsl:choose>
						<xsl:when test="function-available('al:l6petaTekst')">
							<i>l&#xFC;h</i>
							<xsl:value-of select="al:l6petaTekst()"/>
						</xsl:when>
						<xsl:otherwise>
							<i>l&#xFC;h</i>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="(. = 'gr') and name(..) = 'x:mvt' and name() = 'x:mvtl'">
					<xsl:choose>
						<xsl:when test="function-available('al:l6petaTekst')">&#x2192;<xsl:value-of select="al:l6petaTekst()"/>
						</xsl:when>
						<xsl:otherwise>&#x2192;</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="(. = 'fr') and name(..) = 'x:mvt' and name() = 'x:mvtl'">
					<xsl:choose>
						<xsl:when test="function-available('al:l6petaTekst')">
							<i>vt</i>
							<xsl:value-of select="al:l6petaTekst()"/>
						</xsl:when>
						<xsl:otherwise>
							<i>vt</i>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="function-available('al:RS')">
							<xsl:value-of select="al:RS(., string(local-name()))" disable-output-escaping="yes"/>
						</xsl:when>
						<xsl:when test="function-available('eRegs:replace')">
							<xsl:value-of select="eRegs:replace(., '(&amp;\w+;)', 'g', '')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="get_lang">
		<xsl:variable name="keel">
			<xsl:for-each select="ancestor-or-self::*[@xml:lang][1]">
				<xsl:value-of select="@xml:lang"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$keel != ''">
				<xsl:value-of select="$keel"/>
			</xsl:when>
			<xsl:otherwise>et</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="x:A">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:if test="$dotNet = '1'">
			<xsl:if test="function-available('al:myInit')">
				<xsl:value-of select="al:myInit(string($dic_desc), string($dotNet), string($itad), string($paksud), substring-before(name(), ':'), namespace-uri())"/>
			</xsl:if>
		</xsl:if>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<p>
			<!-- <atribuut @x:AS> -->
			<xsl:if test="@x:AS">
				<xsl:choose>
					<xsl:when test="function-available('al:paneTyhikEtte')">
						<xsl:value-of select="al:paneTyhikEtte(., local-name())"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>
						</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="@x:AS[string-length(.) &gt; 0]">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			<!-- </atribuut @x:AS> -->
			<xsl:call-template name="elemendiSisemus">
				<xsl:with-param name="rada">
					<xsl:value-of select="$rada"/>
				</xsl:with-param>
				<xsl:with-param name="posnr">
					<xsl:value-of select="$posnr"/>
				</xsl:with-param>
				<xsl:with-param name="peidus">
					<xsl:value-of select="$peidus"/>
				</xsl:with-param>
			</xsl:call-template>
		</p>
	</xsl:template>
	<xsl:template match="x:P">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:mg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:mg']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:m">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- <atribuut @x:i> -->
		<xsl:if test="@x:i">
			<xsl:apply-templates select="@x:i[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<!-- </atribuut @x:i> -->
	</xsl:template>
	<xsl:template match="x:r">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:r'])"> {<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:r']">,</xsl:if>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:r'])">}</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:hld">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:hld'])"> [<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:hld']">,</xsl:if>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:hld'])">] </xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:vk">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:grp">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:grp'])"> &lt;<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:grp']">;</xsl:if>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:grp'])">&gt;</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:mfp">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:mfp']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:mkg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:mkg']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:mk">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:mvg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:mvg']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:mv">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:mv']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:mt">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:mt']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:gri">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:if test="(name(..) = 'x:grp') or (name(..) = 'x:tp')">
			<xsl:variable name="posnr">
				<xsl:number level="single" format="1"/>
			</xsl:variable>
			<!-- <ümbritsev, alustav> -->
			<xsl:choose>
				<xsl:when test="name(..) = 'x:tp' and not(preceding-sibling::node()[1][name() = 'x:gri'])">&lt;<xsl:if test="function-available('al:paneKylge')">
						<xsl:value-of select="al:paneKylge('')"/>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
			<!-- </ümbritsev, alustav> -->
			<xsl:call-template name="elemendiSisemus">
				<xsl:with-param name="rada">
					<xsl:value-of select="$rada"/>
				</xsl:with-param>
				<xsl:with-param name="posnr">
					<xsl:value-of select="$posnr"/>
				</xsl:with-param>
				<xsl:with-param name="peidus">
					<xsl:value-of select="$peidus"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="name(..) = 'x:grp' and following-sibling::node()[1][name() = 'x:gri']">;</xsl:if>
			<xsl:if test="name(..) = 'x:tp' and following-sibling::node()[1][name() = 'x:gri']">;</xsl:if>
			<!-- <ümbritsev, lõpetav> -->
			<xsl:choose>
				<xsl:when test="name(..) = 'x:tp' and not(following-sibling::node()[1][name() = 'x:gri'])">&gt;</xsl:when>
			</xsl:choose>
			<!-- </ümbritsev, lõpetav> -->
		</xsl:if>
	</xsl:template>
	<xsl:template match="x:sl">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:sl']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:gki">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:if test="(name(..) = 'x:gri')">
			<xsl:variable name="posnr">
				<xsl:number level="single" format="1"/>
			</xsl:variable>
			<!-- <ümbritsev, alustav> -->
			<xsl:choose>
				<xsl:when test="name(..) = 'x:gri' and not(preceding-sibling::node()[1][name() = 'x:gki'])"> (<xsl:if test="function-available('al:paneKylge')">
						<xsl:value-of select="al:paneKylge('')"/>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
			<!-- </ümbritsev, alustav> -->
			<xsl:call-template name="elemendiSisemus">
				<xsl:with-param name="rada">
					<xsl:value-of select="$rada"/>
				</xsl:with-param>
				<xsl:with-param name="posnr">
					<xsl:value-of select="$posnr"/>
				</xsl:with-param>
				<xsl:with-param name="peidus">
					<xsl:value-of select="$peidus"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="name(..) = 'x:gri' and following-sibling::node()[1][name() = 'x:gki']">,</xsl:if>
			<!-- <ümbritsev, lõpetav> -->
			<xsl:choose>
				<xsl:when test="name(..) = 'x:gri' and not(following-sibling::node()[1][name() = 'x:gki'])">)</xsl:when>
			</xsl:choose>
			<!-- </ümbritsev, lõpetav> -->
		</xsl:if>
	</xsl:template>
	<xsl:template match="x:v">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <atribuut @x:l> -->
		<xsl:if test="@x:l">
			<xsl:choose>
				<xsl:when test="function-available('al:paneTyhikEtte')">
					<xsl:value-of select="al:paneTyhikEtte(., local-name())"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>
					</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@x:l[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<!-- </atribuut @x:l> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:v']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:s">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <atribuut @x:l> -->
		<xsl:if test="@x:l">
			<xsl:choose>
				<xsl:when test="function-available('al:paneTyhikEtte')">
					<xsl:value-of select="al:paneTyhikEtte(., local-name())"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>
					</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@x:l[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<!-- </atribuut @x:l> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:s']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:a">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:a'])">
				<i>ka </i>
				<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- <atribuut @x:i> -->
		<xsl:if test="@x:i">
			<xsl:apply-templates select="@x:i[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<!-- </atribuut @x:i> -->
		<xsl:if test="following-sibling::node()[1][name() = 'x:a']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:mvt">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <atribuut @x:mvtl> -->
		<xsl:if test="@x:mvtl">
			<xsl:choose>
				<xsl:when test="function-available('al:paneTyhikEtte')">
					<xsl:value-of select="al:paneTyhikEtte(., local-name())"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>
					</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@x:mvtl[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<!-- </atribuut @x:mvtl> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- <atribuut @x:i> -->
		<xsl:if test="@x:i">
			<xsl:apply-templates select="@x:i[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<!-- </atribuut @x:i> -->
		<xsl:if test="following-sibling::node()[1][name() = 'x:mvt']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:S">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:tp">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:if test="(count(../pref:tp) &gt; 1)">
			<br/>
		</xsl:if>
		<!-- <atribuut @x:tnr> -->
		<xsl:if test="@x:tnr and (count(../pref:tp) &gt; 1)">
			<xsl:choose>
				<xsl:when test="function-available('al:paneTyhikEtte')">
					<xsl:value-of select="al:paneTyhikEtte(., local-name())"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>
					</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@x:tnr[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>
			<b>.</b>
		</xsl:if>
		<!-- </atribuut @x:tnr> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:mmg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:mm">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:tg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:tg']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:dg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:dg']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:dt">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- <atribuut @x:i> -->
		<xsl:if test="@x:i">
			<xsl:apply-templates select="@x:i[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<!-- </atribuut @x:i> -->
	</xsl:template>
	<xsl:template match="x:d">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:d'])"> (<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:d']">,</xsl:if>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:d'])">)</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:ld">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:ld']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:xp">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:xg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xg']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:x">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:xr">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:xr'])"> {<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xr']">,</xsl:if>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:xr'])">}</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:xvk">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:xgrp">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:xgrp'])"> &lt;<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:xgrp'])">&gt;</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:xmfp">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xmfp']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:xmvg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xmvg']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:xmv">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xmv']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:xag">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:xa">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:xmt">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xmt']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:xgri">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:xsl">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xsl']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:xz">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xz']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:xgki">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:xgki'])"> (<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:xgki'])">)</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:xdg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xdg']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:xv">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xv']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:xs">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xs']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:xd">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:xd'])"> (<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:xd'])">)</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:xn">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:xn'])"> (<i>&#x43C;&#x443;&#x442;&#x43B;.</i>
				<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:xn'])">)</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:np">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:np'])"> &#x2666; <xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:np']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:ng">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:ng']">; </xsl:if>
	</xsl:template>
	<xsl:template match="x:n">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:n']">, </xsl:if>
	</xsl:template>
	<xsl:template match="x:qnp">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:qnp']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:ndg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:ndg']">;</xsl:if>
	</xsl:template>
	<xsl:template match="x:nd">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:nd'])"> (<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:nd'])">)</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:qng">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:qng']">,</xsl:if>
	</xsl:template>
	<xsl:template match="x:qn">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:tvt">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <atribuut @x:tvtl> -->
		<xsl:if test="@x:tvtl">
			<xsl:choose>
				<xsl:when test="function-available('al:paneTyhikEtte')">
					<xsl:value-of select="al:paneTyhikEtte(., local-name())"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>
					</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@x:tvtl[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<!-- </atribuut @x:tvtl> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- <atribuut @x:i> -->
		<xsl:if test="@x:i">
			<xsl:apply-templates select="@x:i[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<!-- </atribuut @x:i> -->
		<!-- <atribuut @x:t> -->
		<xsl:if test="@x:t">
			<xsl:choose>
				<xsl:when test="function-available('al:paneTyhikEtte')">
					<xsl:value-of select="al:paneTyhikEtte(., local-name())"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>
					</xsl:text>
				</xsl:otherwise>
			</xsl:choose>(<xsl:apply-templates select="@x:t[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>)</xsl:if>
		<!-- </atribuut @x:t> -->
	</xsl:template>
	<xsl:template match="x:LS">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<br/>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:LS'])">&#x25A0;LS: <xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<!-- <atribuut @x:lso> -->
		<xsl:if test="@x:lso">
			<xsl:choose>
				<xsl:when test="function-available('al:paneTyhikEtte')">
					<xsl:value-of select="al:paneTyhikEtte(., local-name())"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>
					</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@x:lso[string-length(.) &gt; 0]">
				<xsl:with-param name="rada">
					<xsl:value-of select="concat($rada, name(), '[', $posnr, ']/')"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<!-- </atribuut @x:lso> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:lsdg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:lsd">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:lsd'])"> (<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:lsd'])">)</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:KOM">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:if test="(($showShaded = '1'))">
			<xsl:variable name="posnr">
				<xsl:number level="single" format="1"/>
			</xsl:variable>
			<xsl:element name="span">
				<xsl:attribute name="class">etvw_x_KOM_75_79_77 etvw_x_KOM</xsl:attribute>
				<xsl:call-template name="elemendiSisemus">
					<xsl:with-param name="rada">
						<xsl:value-of select="$rada"/>
					</xsl:with-param>
					<xsl:with-param name="posnr">
						<xsl:value-of select="$posnr"/>
					</xsl:with-param>
					<xsl:with-param name="peidus">
						<xsl:value-of select="$peidus"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template match="x:komg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<br/>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:kom">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:kaut">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:kaeg">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:maht">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:xtx">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<!-- <ümbritsev, alustav> -->
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::node()[1][name() = 'x:xtx'])"> (<xsl:if test="function-available('al:paneKylge')">
					<xsl:value-of select="al:paneKylge('')"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, alustav> -->
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="following-sibling::node()[1][name() = 'x:xtx']">,</xsl:if>
		<!-- <ümbritsev, lõpetav> -->
		<xsl:choose>
			<xsl:when test="not(following-sibling::node()[1][name() = 'x:xtx'])">)</xsl:when>
		</xsl:choose>
		<!-- </ümbritsev, lõpetav> -->
	</xsl:template>
	<xsl:template match="x:I">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="x:any">
		<xsl:param name="rada"/>
		<xsl:param name="peidus"/>
		<xsl:variable name="posnr">
			<xsl:number level="single" format="1"/>
		</xsl:variable>
		<xsl:call-template name="elemendiSisemus">
			<xsl:with-param name="rada">
				<xsl:value-of select="$rada"/>
			</xsl:with-param>
			<xsl:with-param name="posnr">
				<xsl:value-of select="$posnr"/>
			</xsl:with-param>
			<xsl:with-param name="peidus">
				<xsl:value-of select="$peidus"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
