<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:al="http://www.eo.ee/xml/xsl/scripts" xmlns:eRegs="http://exslt.org/regular-expressions" xmlns:pref="http://www.eki.ee/dict/dmo" xmlns:x="http://www.eki.ee/dict/dmo" version="1.0" exclude-result-prefixes="eRegs">
	<xsl:output method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8"/>
	<msxsl:script language="javascript" implements-prefix="al">
    function unNameXslLn(inpStr) {
      var unStr = '', i;
      // unStr = inpStr.replace(/:/, "-");
      // sest sisse tuleb ainult local-name()
      for (i = 0; i &lt; inpStr.length; i++) {
              unStr += '_' + inpStr.charCodeAt(i);
      }
      return unStr;
    }

    function unNameEditQn(inpStr) {
      // sisse tuleb qualified name 'qn'
      var unStr = inpStr.replace(/:/, "-");
      for (var i = 0; i &lt; inpStr.length; i++)
        // _ pluss number, kusjuures teine m&#xE4;rk on koolon (_58)
        unStr += '_' + inpStr.charCodeAt(i);
      return unStr;
    }

      function xslNumberToRepString(xslNumber, repStr, lenOffStr) {
        var xslNumbers = xslNumber.split('.');
        var lenOff = parseInt(lenOffStr);
        var rets = '';
        for (var ix = 0; ix &lt; xslNumbers.length + lenOff; ix++) {
            rets += repStr;
        }
        return (rets + rets);
    }
</msxsl:script>
	<xsl:variable name="dic_desc"/>
	<xsl:variable name="appLang">et</xsl:variable>
	<xsl:variable name="segad">;x:m;x:d;x:x;x:n;x:nd;x:qn;</xsl:variable>
	<xsl:variable name="tekstiga">;x:maht;x:r;x:hld;x:vk;x:mkl;x:mk;x:mv;x:mt;x:sl;x:gki;x:v;x:s;x:a;x:mvt;x:mm;x:dt;x:ld;x:xtx;x:xr;x:xvk;x:xmv;x:xa;x:xmt;x:xsl;x:xz;x:xgki;x:xv;x:xs;x:xd;x:xn;x:tvt;x:lsd;x:kom;x:kaut;x:kaeg;x:any;x:G;x:K;x:KA;x:KL;x:T;x:TA;x:TL;x:PT;x:PTA;x:X;x:XA;</xsl:variable>
	<xsl:variable name="attrNoEdit">;x:A/@x:KF;</xsl:variable>
	<xsl:variable name="elemNoEdit">;x:komg/x:kaut;x:komg/x:kaeg;</xsl:variable>
	<xsl:variable name="elemNoDisplay">;x:A/x:G;x:A/x:K;x:A/x:KA;x:A/x:KL;x:A/x:T;x:A/x:TA;x:A/x:TL;x:A/x:PT;x:A/x:PTA;x:A/x:X;x:A/x:XA;</xsl:variable>
	<xsl:variable name="attrNoDisplay">;x:A/@x:KF;x:m/@x:O;</xsl:variable>
	<xsl:variable name="attrNoCreate">;x:A/@x:KF;x:m/@x:O;</xsl:variable>
	<xsl:variable name="tblBrdCol"/>
	<xsl:variable name="addGroupPicture">graphics/justify.ico</xsl:variable>
	<xsl:variable name="delGroupPicture">graphics/delart 16-16.ico</xsl:variable>
	<xsl:variable name="createGroupPicture">graphics/downarrow 16-16.ico</xsl:variable>
	<xsl:variable name="addLisadPicture">graphics/downarrow 16-16.ico</xsl:variable>
	<xsl:variable name="delLisadPicture">graphics/delart 16-16.ico</xsl:variable>
	<xsl:variable name="attrNoDelete">;x:m/@x:O;x:mvt/@x:mvtl;x:tp/@x:tnr;x:ld/@xml:lang;x:xg/@xml:lang;x:qnp/@x:ntnr;x:ld/@xml:lang;x:qng/@xml:lang;x:tvt/@x:tvtl;x:LS/@x:lso;x:tvt/@x:tvtl;</xsl:variable>
	<xsl:variable name="kirjeldavad">
		<e n="x:sr">
			<t l="et">s&#xF5;naraamat</t>
			<t l="en">dictionary</t>
			<t l="ru">&#x441;&#x43B;&#x43E;&#x432;&#x430;&#x440;&#x44C;</t>
		</e>
		<e n="x:A">
			<t l="et">artikkel</t>
			<t l="en">entry</t>
			<t l="ru">&#x441;&#x442;&#x430;&#x442;&#x44C;&#x44F;</t>
		</e>
		<a n="x:KF">
			<t l="et">k&#xF6;ite fail</t>
			<t l="en">k&#xF6;ite fail</t>
			<t l="ru">k&#xF6;ite fail</t>
		</a>
		<a n="x:AS">
			<t l="et">artikli staatus</t>
			<t l="en">artikli staatus</t>
			<t l="ru">artikli staatus</t>
		</a>
		<e n="x:maht">
			<t l="et">mahuklass</t>
			<t l="en">size class</t>
			<t l="ru">&#x43A;&#x43B;&#x430;&#x441;&#x441; &#x43E;&#x431;&#x44A;&#x451;&#x43C;&#x430;</t>
		</e>
		<e n="x:P">
			<t l="et">p&#xE4;is</t>
			<t l="en">head</t>
			<t l="ru">&#x437;&#x430;&#x433;&#x43E;&#x43B;&#x43E;&#x432;&#x43E;&#x43A;</t>
		</e>
		<e n="x:mg">
			<t l="et">m&#xE4;rks&#xF5;na grupp</t>
			<t l="en">headword_grp</t>
			<t l="ru">&#x433;&#x440;&#x443;&#x43F;&#x43F;&#x430; &#x437;&#x430;&#x433;&#x43B;&#x430;&#x432;&#x43D;&#x44B;&#x445; &#x441;&#x43B;&#x43E;&#x432;</t>
		</e>
		<e n="x:m">
			<t l="et">m&#xE4;rks&#xF5;na</t>
			<t l="en">headword</t>
			<t l="ru">&#x437;&#x430;&#x433;&#x43B;&#x430;&#x432;&#x43D;&#x43E;&#x435; &#x441;&#x43B;&#x43E;&#x432;&#x43E;</t>
		</e>
		<a n="x:i">
			<t l="et">hom-number</t>
			<t l="en">homonym number</t>
			<t l="ru">&#x43D;&#x43E;&#x43C;&#x435;&#x440; &#x43E;&#x43C;&#x43E;&#x43D;&#x438;&#x43C;&#x430;</t>
		</a>
		<a n="x:liik">
			<t l="et">m&#xE4;rks&#xF5;na liik</t>
			<t l="en">type of the headword</t>
			<t l="ru">&#x442;&#x438;&#x43F; &#x437;&#x430;&#x433;&#x43B;&#x430;&#x432;&#x43D;&#x43E;&#x433;&#x43E; &#x441;&#x43B;&#x43E;&#x432;&#x430;</t>
		</a>
		<a n="x:ps">
			<t l="et">p&#xF5;his&#xF5;na</t>
			<t l="en">p&#xF5;his&#xF5;na</t>
			<t l="ru">p&#xF5;his&#xF5;na</t>
		</a>
		<a n="x:u">
			<t l="et">uus m&#xE4;rks&#xF5;na</t>
			<t l="en">uus m&#xE4;rks&#xF5;na</t>
			<t l="ru">uus m&#xE4;rks&#xF5;na</t>
		</a>
		<a n="x:O">
			<t l="et">sorteerimisv&#xE4;&#xE4;rtus</t>
			<t l="en">sortvalue</t>
			<t l="ru">&#x437;&#x43D;&#x430;&#x447;&#x435;&#x43D;&#x438;&#x435; &#x441;&#x43E;&#x440;&#x442;&#x438;&#x440;&#x43E;&#x432;&#x43A;&#x438;</t>
		</a>
		<e n="x:r">
			<t l="et">rektsioon</t>
			<t l="en">government (question)</t>
			<t l="ru">&#x443;&#x43F;&#x440;&#x430;&#x432;&#x43B;&#x435;&#x43D;&#x438;&#x435;</t>
		</e>
		<e n="x:hld">
			<t l="et">h&#xE4;&#xE4;ldus</t>
			<t l="en">pronunciation</t>
			<t l="ru">&#x43F;&#x440;&#x43E;&#x438;&#x437;&#x43D;&#x43E;&#x448;&#x435;&#x43D;&#x438;&#x435;</t>
		</e>
		<e n="x:vk">
			<t l="et">vormikood</t>
			<t l="en">morphological code</t>
			<t l="ru">&#x43C;&#x43E;&#x440;&#x444;&#x43E;&#x43B;&#x43E;&#x433;&#x438;&#x447;&#x435;&#x441;&#x43A;&#x438;&#x439; &#x43A;&#x43E;&#x434;</t>
		</e>
		<e n="x:grp">
			<t l="et">grammatika plokk</t>
			<t l="en">grammatika plokk</t>
			<t l="ru">grammatika plokk</t>
		</e>
		<e n="x:mfp">
			<t l="et">morfoloogia plokk</t>
			<t l="en">morfoloogia plokk</t>
			<t l="ru">morfoloogia plokk</t>
		</e>
		<e n="x:mkg">
			<t l="et">morf.kirje grupp</t>
			<t l="en">morf.kirje grupp</t>
			<t l="ru">morf.kirje grupp</t>
		</e>
		<e n="x:mkl">
			<t l="et">morf.kirje l&#xFC;hikujul</t>
			<t l="en">morf.kirje l&#xFC;hikujul</t>
			<t l="ru">morf.kirje l&#xFC;hikujul</t>
		</e>
		<e n="x:mk">
			<t l="et">morf.kirje</t>
			<t l="en">morf.kirje</t>
			<t l="ru">morf.kirje</t>
		</e>
		<e n="x:mvg">
			<t l="et">muutevormi grupp</t>
			<t l="en">muutevormi grupp</t>
			<t l="ru">muutevormi grupp</t>
		</e>
		<e n="x:mv">
			<t l="et">muutevormid</t>
			<t l="en">inflectional forms</t>
			<t l="ru">&#x444;&#x43E;&#x440;&#x43C;&#x44B; &#x441;&#x43B;&#x43E;&#x432;&#x43E;&#x438;&#x437;&#x43C;&#x435;&#x43D;&#x435;&#x43D;&#x438;&#x44F;</t>
		</e>
		<e n="x:mt">
			<t l="et">muutt&#xFC;&#xFC;p</t>
			<t l="en">inflectional type number</t>
			<t l="ru">&#x442;&#x438;&#x43F; &#x441;&#x43B;&#x43E;&#x432;&#x43E;&#x438;&#x437;&#x43C;&#x435;&#x43D;&#x435;&#x43D;&#x438;&#x44F;</t>
		</e>
		<e n="x:gri">
			<t l="et">grammatiline info</t>
			<t l="en">grammatiline info</t>
			<t l="ru">grammatiline info</t>
		</e>
		<e n="x:sl">
			<t l="et">s&#xF5;naliik</t>
			<t l="en">part of speech</t>
			<t l="ru">&#x447;&#x430;&#x441;&#x442;&#x44C; &#x440;&#x435;&#x447;&#x438;</t>
		</e>
		<a n="x:rk">
			<t l="et">rektsioonikood</t>
			<t l="en">rektsioonikood</t>
			<t l="ru">rektsioonikood</t>
		</a>
		<e n="x:gki">
			<t l="et">gr.kasutusinfo</t>
			<t l="en">usage hints (grammatical information)</t>
			<t l="ru">&#x433;&#x440;&#x430;&#x43C;&#x43C;&#x430;&#x442;&#x438;&#x447;&#x435;&#x441;&#x43A;&#x430;&#x44F; &#x438;&#x43D;&#x444;&#x43E;&#x440;&#x43C;&#x430;&#x446;&#x438;&#x44F; &#x43E; &#x43F;&#x440;&#x438;&#x43C;&#x435;&#x43D;&#x435;&#x43D;&#x438;&#x438;</t>
		</e>
		<e n="x:v">
			<t l="et">vald</t>
			<t l="en">domain</t>
			<t l="ru">&#x441;&#x444;&#x435;&#x440;&#x430; &#x438;&#x441;&#x43F;&#x43E;&#x43B;&#x44C;&#x437;&#x43E;&#x432;&#x430;&#x43D;&#x438;&#x44F;</t>
		</e>
		<a n="x:l">
			<t l="et">kasutuslisand</t>
			<t l="en">usage hint</t>
			<t l="ru">&#x43F;&#x440;&#x438;&#x43B;&#x43E;&#x436;&#x435;&#x43D;&#x438;&#x435;</t>
		</a>
		<e n="x:s">
			<t l="et">stiil</t>
			<t l="en">register</t>
			<t l="ru">&#x441;&#x442;&#x438;&#x43B;&#x44C;</t>
		</e>
		<e n="x:a">
			<t l="et">alternatiiv</t>
			<t l="en">alternative</t>
			<t l="ru">&#x430;&#x43B;&#x44C;&#x442;&#x435;&#x440;&#x43D;&#x430;&#x442;&#x438;&#x432;&#x430;</t>
		</e>
		<e n="x:mvt">
			<t l="et">m&#xE4;rks&#xF5;naviide</t>
			<t l="en">headword reference</t>
			<t l="ru">&#x441;&#x441;&#x44B;&#x43B;&#x43A;&#x430; &#x437;&#x430;&#x433;&#x43B;&#x430;&#x432;&#x43D;&#x43E;&#x433;&#x43E; &#x441;&#x43B;&#x43E;&#x432;&#x430;</t>
		</e>
		<a n="x:t">
			<t l="et">t&#xE4;h-number</t>
			<t l="en">t&#xE4;h-number</t>
			<t l="ru">t&#xE4;h-number</t>
		</a>
		<a n="x:mvtl">
			<t l="et">m.viite liik</t>
			<t l="en">type of the headword reference</t>
			<t l="ru">&#x442;&#x438;&#x43F; &#x441;&#x441;&#x44B;&#x43B;&#x43E;&#x447;&#x43D;&#x43E;&#x439; &#x441;&#x442;&#x430;&#x442;&#x44C;&#x438;</t>
		</a>
		<e n="x:S">
			<t l="et">sisu</t>
			<t l="en">body</t>
			<t l="ru">&#x441;&#x43E;&#x434;&#x435;&#x440;&#x436;&#x430;&#x43D;&#x438;&#x435;</t>
		</e>
		<e n="x:tp">
			<t l="et">t&#xE4;hendusnumbri plokk</t>
			<t l="en">sense number_block</t>
			<t l="ru">&#x431;&#x43B;&#x43E;&#x43A; &#x437;&#x43D;&#x430;&#x447;&#x435;&#x43D;&#x438;&#x439;</t>
		</e>
		<a n="x:tnr">
			<t l="et">t&#xE4;hendusnumber</t>
			<t l="en">sense number</t>
			<t l="ru">&#x43D;&#x43E;&#x43C;&#x435;&#x440; &#x437;&#x43D;&#x430;&#x447;&#x435;&#x43D;&#x438;&#x44F;</t>
		</a>
		<a n="x:as">
			<t l="et">elemendi staatus</t>
			<t l="en">elemendi staatus</t>
			<t l="ru">elemendi staatus</t>
		</a>
		<e n="x:mmg">
			<t l="et">allm&#xE4;rks&#xF5;na grupp</t>
			<t l="en">allm&#xE4;rks&#xF5;na grupp</t>
			<t l="ru">allm&#xE4;rks&#xF5;na grupp</t>
		</e>
		<e n="x:mm">
			<t l="et">allm&#xE4;rks&#xF5;na</t>
			<t l="en">allm&#xE4;rks&#xF5;na</t>
			<t l="ru">allm&#xE4;rks&#xF5;na</t>
		</e>
		<e n="x:tg">
			<t l="et">t&#xE4;hendusgrupp</t>
			<t l="en">sense_grp</t>
			<t l="ru">&#x433;&#x440;&#x443;&#x43F;&#x43F;&#x430; &#x437;&#x43D;&#x430;&#x447;&#x435;&#x43D;&#x438;&#x439;</t>
		</e>
		<e n="x:dg">
			<t l="et">definitsioonigrupp</t>
			<t l="en">definition_grp</t>
			<t l="ru">&#x433;&#x440;&#x443;&#x43F;&#x43F;&#x430; &#x43F;&#x43E;&#x44F;&#x441;&#x43D;&#x435;&#x43D;&#x438;&#x439;</t>
		</e>
		<e n="x:dt">
			<t l="et">tulenemisseletus</t>
			<t l="en">derived from</t>
			<t l="ru">&#x43F;&#x43E;&#x44F;&#x441;&#x43D;&#x435;&#x43D;&#x438;&#x435; &#x43F;&#x440;&#x43E;&#x438;&#x441;&#x445;&#x43E;&#x436;&#x434;&#x435;&#x43D;&#x438;&#x44F;</t>
		</e>
		<e n="x:d">
			<t l="et">seletus</t>
			<t l="en">definition</t>
			<t l="ru">&#x43F;&#x43E;&#x44F;&#x441;&#x43D;&#x435;&#x43D;&#x438;&#x435;</t>
		</e>
		<e n="x:ld">
			<t l="et">ladina termin</t>
			<t l="en">latin definition</t>
			<t l="ru">&#x43B;&#x430;&#x442;&#x438;&#x43D;&#x441;&#x43A;&#x438;&#x439; &#x442;&#x435;&#x440;&#x43C;&#x438;&#x43D;</t>
		</e>
		<e n="x:xp">
			<t l="et">vastete plokk</t>
			<t l="en">equivalent block</t>
			<t l="ru">&#x431;&#x43B;&#x43E;&#x43A; &#x441;&#x43E;&#x43E;&#x442;&#x432;&#x435;&#x442;&#x441;&#x442;&#x432;&#x438;&#x439;</t>
		</e>
		<e n="x:xg">
			<t l="et">vastegrupp</t>
			<t l="en">equivalent group</t>
			<t l="ru">&#x433;&#x440;&#x443;&#x43F;&#x43F;&#x430; &#x441;&#x43E;&#x43E;&#x442;&#x432;&#x435;&#x442;&#x441;&#x442;&#x432;&#x438;&#x439;</t>
		</e>
		<e n="x:xtx">
			<t l="et">t&#xE4;psustus</t>
			<t l="en">specification</t>
			<t l="ru">&#x443;&#x442;&#x43E;&#x447;&#x43D;&#x435;&#x43D;&#x438;&#x435;</t>
		</e>
		<e n="x:x">
			<t l="et">vaste</t>
			<t l="en">equivalent</t>
			<t l="ru">&#x441;&#x43E;&#x43E;&#x442;&#x432;&#x435;&#x442;&#x441;&#x442;&#x432;&#x438;&#x435;</t>
		</e>
		<a n="x:xliik">
			<t l="et">vaste liik</t>
			<t l="en">vaste liik</t>
			<t l="ru">vaste liik</t>
		</a>
		<a n="x:xall">
			<t l="et">vaste p&#xE4;ritolu</t>
			<t l="en">vaste p&#xE4;ritolu</t>
			<t l="ru">vaste p&#xE4;ritolu</t>
		</a>
		<e n="x:xr">
			<t l="et">rektsioon</t>
			<t l="en">government (question)</t>
			<t l="ru">&#x443;&#x43F;&#x440;&#x430;&#x432;&#x43B;&#x435;&#x43D;&#x438;&#x435;</t>
		</e>
		<e n="x:xvk">
			<t l="et">vormikood</t>
			<t l="en">morphological code</t>
			<t l="ru">&#x43C;&#x43E;&#x440;&#x444;&#x43E;&#x43B;&#x43E;&#x433;&#x438;&#x447;&#x435;&#x441;&#x43A;&#x438;&#x439; &#x43A;&#x43E;&#x434;</t>
		</e>
		<e n="x:xgrp">
			<t l="et">vaste grammatika plokk</t>
			<t l="en">vaste grammatika plokk</t>
			<t l="ru">vaste grammatika plokk</t>
		</e>
		<e n="x:xmfp">
			<t l="et">vaste morfoloogia plokk</t>
			<t l="en">vaste morfoloogia plokk</t>
			<t l="ru">vaste morfoloogia plokk</t>
		</e>
		<e n="x:xmvg">
			<t l="et">vaste muutevormigrupp</t>
			<t l="en">vaste muutevormigrupp</t>
			<t l="ru">vaste muutevormigrupp</t>
		</e>
		<e n="x:xmv">
			<t l="et">muutevormid</t>
			<t l="en">inflectional forms</t>
			<t l="ru">&#x444;&#x43E;&#x440;&#x43C;&#x44B; &#x441;&#x43B;&#x43E;&#x432;&#x43E;&#x438;&#x437;&#x43C;&#x435;&#x43D;&#x435;&#x43D;&#x438;&#x44F;</t>
		</e>
		<e n="x:xag">
			<t l="et">gr.variandi grupp</t>
			<t l="en">gr.variandi grupp</t>
			<t l="ru">gr.variandi grupp</t>
		</e>
		<e n="x:xa">
			<t l="et">gr.variant</t>
			<t l="en">gr.variant</t>
			<t l="ru">gr.variant</t>
		</e>
		<a n="x:xgk">
			<t l="et">gr.kood</t>
			<t l="en">gr.kood</t>
			<t l="ru">gr.kood</t>
		</a>
		<e n="x:xmt">
			<t l="et">vaste muutt&#xFC;&#xFC;p</t>
			<t l="en">vaste muutt&#xFC;&#xFC;p</t>
			<t l="ru">vaste muutt&#xFC;&#xFC;p</t>
		</e>
		<e n="x:xgri">
			<t l="et">vaste grammatiline info</t>
			<t l="en">vaste grammatiline info</t>
			<t l="ru">vaste grammatiline info</t>
		</e>
		<e n="x:xsl">
			<t l="et">s&#xF5;naliik</t>
			<t l="en">part of speech</t>
			<t l="ru">&#x447;&#x430;&#x441;&#x442;&#x44C; &#x440;&#x435;&#x447;&#x438;</t>
		</e>
		<e n="x:xz">
			<t l="et">gr.sugu</t>
			<t l="en">gr.sugu</t>
			<t l="ru">gr.sugu</t>
		</e>
		<e n="x:xgki">
			<t l="et">gr.kasutusinfo</t>
			<t l="en">gr.kasutusinfo</t>
			<t l="ru">gr.kasutusinfo</t>
		</e>
		<e n="x:xdg">
			<t l="et">vaste definitsioonigrupp</t>
			<t l="en">vaste definitsioonigrupp</t>
			<t l="ru">vaste definitsioonigrupp</t>
		</e>
		<e n="x:xv">
			<t l="et">vald</t>
			<t l="en">domain</t>
			<t l="ru">&#x441;&#x444;&#x435;&#x440;&#x430; &#x443;&#x43F;&#x43E;&#x442;&#x440;&#x435;&#x431;&#x43B;&#x435;&#x43D;&#x438;&#x44F;</t>
		</e>
		<e n="x:xs">
			<t l="et">stiil</t>
			<t l="en">register</t>
			<t l="ru">&#x441;&#x442;&#x438;&#x43B;&#x44C;</t>
		</e>
		<e n="x:xd">
			<t l="et">vaste seletus</t>
			<t l="en">definition</t>
			<t l="ru">&#x43F;&#x43E;&#x44F;&#x441;&#x43D;&#x435;&#x43D;&#x438;&#x435;</t>
		</e>
		<e n="x:xn">
			<t l="et">vaste kasutusn&#xE4;ide</t>
			<t l="en">vaste kasutusn&#xE4;ide</t>
			<t l="ru">vaste kasutusn&#xE4;ide</t>
		</e>
		<e n="x:np">
			<t l="et">n&#xE4;idete plokk</t>
			<t l="en">examples_block</t>
			<t l="ru">&#x431;&#x43B;&#x43E;&#x43A; &#x43F;&#x440;&#x438;&#x43C;&#x435;&#x440;&#x43E;&#x432;</t>
		</e>
		<e n="x:ng">
			<t l="et">n&#xE4;itegrupp</t>
			<t l="en">examples_grp</t>
			<t l="ru">&#x433;&#x440;&#x443;&#x43F;&#x43F;&#x430; &#x43F;&#x440;&#x438;&#x43C;&#x435;&#x440;&#x43E;&#x432;</t>
		</e>
		<e n="x:n">
			<t l="et">n&#xE4;ide</t>
			<t l="en">example</t>
			<t l="ru">&#x438;&#x43B;&#x43B;&#x44E;&#x441;&#x442;&#x440;&#x430;&#x442;&#x438;&#x432;&#x43D;&#x44B;&#x439; &#x43F;&#x440;&#x438;&#x43C;&#x435;&#x440;</t>
		</e>
		<a n="x:nrl">
			<t l="et">v&#xE4;ljendi roll</t>
			<t l="en">role of an expression</t>
			<t l="ru">&#x440;&#x43E;&#x43B;&#x44C; &#x432;&#x44B;&#x440;&#x430;&#x436;&#x435;&#x43D;&#x438;&#x44F;</t>
		</a>
		<e n="x:qnp">
			<t l="et">n&#xE4;itet&#xF5;lgete plokk</t>
			<t l="en">translations (of the examples)_block</t>
			<t l="ru">&#x431;&#x43B;&#x43E;&#x43A; &#x43F;&#x435;&#x440;&#x435;&#x432;&#x43E;&#x434;&#x43E;&#x432; &#x438;&#x43B;&#x43B;&#x44E;&#x441;&#x442;&#x440;&#x430;&#x442;&#x438;&#x432;&#x43D;&#x44B;&#x445; &#x43F;&#x440;&#x438;&#x43C;&#x435;&#x440;&#x43E;&#x432;</t>
		</e>
		<a n="x:ntnr">
			<t l="et">n&#xE4;ite t&#xE4;hendusnumber</t>
			<t l="en">sense number (of the example)</t>
			<t l="ru">&#x43D;&#x43E;&#x43C;&#x435;&#x440; &#x437;&#x43D;&#x430;&#x447;&#x435;&#x43D;&#x438;&#x44F; &#x43F;&#x440;&#x438;&#x43C;&#x435;&#x440;&#x430;</t>
		</a>
		<e n="x:ndg">
			<t l="et">n&#xE4;ite definitsioonigrupp</t>
			<t l="en">definition (of the examples)_group</t>
			<t l="ru">&#x433;&#x440;&#x443;&#x43F;&#x43F;&#x430; &#x43F;&#x43E;&#x44F;&#x441;&#x43D;&#x435;&#x43D;&#x438;&#x44F; &#x43F;&#x440;&#x438;&#x43C;&#x435;&#x440;&#x43E;&#x432;</t>
		</e>
		<e n="x:nd">
			<t l="et">n&#xE4;ite seletus</t>
			<t l="en">definition of the example</t>
			<t l="ru">&#x43F;&#x43E;&#x44F;&#x441;&#x43D;&#x435;&#x43D;&#x438;&#x435; &#x43F;&#x440;&#x438;&#x43C;&#x435;&#x440;&#x430;</t>
		</e>
		<e n="x:qng">
			<t l="et">n&#xE4;itet&#xF5;lke grupp</t>
			<t l="en">translation group</t>
			<t l="ru">&#x433;&#x440;&#x443;&#x43F;&#x43F;&#x430; &#x43F;&#x435;&#x440;&#x435;&#x432;&#x43E;&#x434;&#x430; &#x43F;&#x440;&#x438;&#x43C;&#x435;&#x440;&#x43E;&#x432;</t>
		</e>
		<e n="x:qn">
			<t l="et">n&#xE4;itet&#xF5;lge</t>
			<t l="en">translation</t>
			<t l="ru">&#x43F;&#x435;&#x440;&#x435;&#x432;&#x43E;&#x434; &#x43F;&#x440;&#x438;&#x43C;&#x435;&#x440;&#x430;</t>
		</e>
		<e n="x:tvt">
			<t l="et">t&#xE4;hendusviide</t>
			<t l="en">sense reference</t>
			<t l="ru">&#x43B;&#x435;&#x43A;&#x441;&#x438;&#x43A;&#x43E;-&#x441;&#x435;&#x43C;&#x430;&#x43D;&#x442;&#x438;&#x447;&#x435;&#x441;&#x43A;&#x430;&#x44F; &#x441;&#x441;&#x44B;&#x43B;&#x43A;&#x430;</t>
		</e>
		<a n="x:tvtl">
			<t l="et">t.viite liik</t>
			<t l="en">type of the sense reference</t>
			<t l="ru">&#x442;&#x438;&#x43F; &#x441;&#x441;&#x44B;&#x43B;&#x43E;&#x447;&#x43D;&#x43E;&#x439; &#x441;&#x442;&#x430;&#x442;&#x44C;&#x438;</t>
		</a>
		<e n="x:LS">
			<t l="et">liits&#xF5;nade plokk</t>
			<t l="en">compound words_block</t>
			<t l="ru">&#x431;&#x43B;&#x43E;&#x43A; &#x441;&#x43B;&#x43E;&#x436;&#x43D;&#x44B;&#x445; &#x441;&#x43B;&#x43E;&#x432;</t>
		</e>
		<a n="x:lso">
			<t l="et">liits&#xF5;naosa</t>
			<t l="en">liits&#xF5;naosa</t>
			<t l="ru">liits&#xF5;naosa</t>
		</a>
		<e n="x:lsdg">
			<t l="et">ls. definitsioonigrupp</t>
			<t l="en">ls. definitsioonigrupp</t>
			<t l="ru">ls. definitsioonigrupp</t>
		</e>
		<e n="x:lsd">
			<t l="et">liits&#xF5;naosa seletus</t>
			<t l="en">definition of compound words_block</t>
			<t l="ru">&#x43F;&#x43E;&#x44F;&#x441;&#x43D;&#x435;&#x43D;&#x438;&#x435; &#x43A;&#x43E;&#x43C;&#x43F;&#x43E;&#x43D;&#x435;&#x43D;&#x442;&#x430; &#x441;&#x43B;&#x43E;&#x436;&#x43D;&#x43E;&#x433;&#x43E; &#x441;&#x43B;&#x43E;&#x432;&#x430;</t>
		</e>
		<e n="x:KOM">
			<t l="et">kommentaarid</t>
			<t l="en">comments</t>
			<t l="ru">&#x43A;&#x43E;&#x43C;&#x43C;&#x435;&#x43D;&#x442;&#x430;&#x440;&#x438;&#x438;</t>
		</e>
		<e n="x:komg">
			<t l="et">kommentaari grupp</t>
			<t l="en">comment_grp</t>
			<t l="ru">&#x433;&#x440;&#x443;&#x43F;&#x43F;&#x430; &#x43A;&#x43E;&#x43C;&#x43C;&#x435;&#x43D;&#x442;&#x430;&#x440;&#x438;&#x435;&#x432;</t>
		</e>
		<e n="x:kom">
			<t l="et">kommentaar</t>
			<t l="en">comment</t>
			<t l="ru">&#x43A;&#x43E;&#x43C;&#x43C;&#x435;&#x43D;&#x442;&#x430;&#x440;&#x438;&#x439;</t>
		</e>
		<e n="x:kaut">
			<t l="et">kommentaari autor</t>
			<t l="en">author of the comment</t>
			<t l="ru">&#x430;&#x432;&#x442;&#x43E;&#x440; &#x43A;&#x43E;&#x43C;&#x43C;&#x435;&#x43D;&#x442;&#x430;&#x440;&#x438;&#x44F;</t>
		</e>
		<e n="x:kaeg">
			<t l="et">kommenteerimisaeg</t>
			<t l="en">date of the comment</t>
			<t l="ru">&#x434;&#x430;&#x442;&#x430; &#x43A;&#x43E;&#x43C;&#x43C;&#x435;&#x43D;&#x442;&#x430;&#x440;&#x438;&#x44F;</t>
		</e>
		<e n="x:I">
			<t l="et">imporditud artiklid</t>
			<t l="en">imporditud artiklid</t>
			<t l="ru">imporditud artiklid</t>
		</e>
		<e n="x:any">
			<t l="et">artikkel</t>
			<t l="en">artikkel</t>
			<t l="ru">artikkel</t>
		</e>
		<e n="x:G">
			<t l="et">GUID</t>
			<t l="en">GUID</t>
			<t l="ru">GUID</t>
		</e>
		<e n="x:K">
			<t l="et">artikli koostaja</t>
			<t l="en">created by</t>
			<t l="ru">&#x441;&#x43E;&#x441;&#x442;&#x430;&#x432;&#x438;&#x442;&#x435;&#x43B;&#x44C; &#x441;&#x442;&#x430;&#x442;&#x44C;&#x438;</t>
		</e>
		<e n="x:KA">
			<t l="et">koostamisaeg</t>
			<t l="en">date of creation</t>
			<t l="ru">&#x432;&#x440;&#x435;&#x43C;&#x44F; &#x441;&#x43E;&#x441;&#x442;&#x430;&#x432;&#x43B;&#x435;&#x43D;&#x438;&#x44F;</t>
		</e>
		<e n="x:KL">
			<t l="et">koostamise l&#xF5;pp</t>
			<t l="en">end of creation</t>
			<t l="ru">&#x437;&#x430;&#x432;&#x435;&#x440;&#x448;&#x435;&#x43D;&#x438;&#x435; &#x441;&#x43E;&#x441;&#x442;&#x430;&#x432;&#x43B;&#x435;&#x43D;&#x438;&#x44F;</t>
		</e>
		<e n="x:T">
			<t l="et">artikli toimetaja</t>
			<t l="en">modified by</t>
			<t l="ru">&#x440;&#x435;&#x434;&#x430;&#x43A;&#x442;&#x43E;&#x440; &#x441;&#x442;&#x430;&#x442;&#x44C;&#x438;</t>
		</e>
		<e n="x:TA">
			<t l="et">toimetamisaeg</t>
			<t l="en">date of modification</t>
			<t l="ru">&#x432;&#x440;&#x435;&#x43C;&#x44F; &#x440;&#x435;&#x434;&#x430;&#x43A;&#x442;&#x438;&#x440;&#x43E;&#x432;&#x430;&#x43D;&#x438;&#x44F;</t>
		</e>
		<e n="x:TL">
			<t l="et">toimetamise l&#xF5;pp</t>
			<t l="en">end of modification</t>
			<t l="ru">&#x437;&#x430;&#x432;&#x435;&#x440;&#x448;&#x435;&#x43D;&#x438;&#x435; &#x440;&#x435;&#x434;&#x430;&#x43A;&#x442;&#x438;&#x440;&#x43E;&#x432;&#x430;&#x43D;&#x438;&#x44F;</t>
		</e>
		<e n="x:PT">
			<t l="et">artikli peatoimetaja</t>
			<t l="en">signed by</t>
			<t l="ru">x:PT</t>
		</e>
		<e n="x:PTA">
			<t l="et">peatoimetamise aeg</t>
			<t l="en">date of signing</t>
			<t l="ru">x:PTA</t>
		</e>
		<e n="x:X">
			<t l="et">artikli kustutaja</t>
			<t l="en">deleted by</t>
			<t l="ru">&#x443;&#x434;&#x430;&#x43B;&#x438;&#x442;&#x435;&#x43B;&#x44C; &#x441;&#x442;&#x430;&#x442;&#x44C;&#x438;</t>
		</e>
		<e n="x:XA">
			<t l="et">kustutamise aeg</t>
			<t l="en">date of deletion</t>
			<t l="ru">&#x432;&#x440;&#x435;&#x43C;&#x44F; &#x443;&#x434;&#x430;&#x43B;&#x435;&#x43D;&#x438;&#x44F;</t>
		</e>
		<e n="x:mf">
			<t l="et">morfonoloogiline vorm</t>
			<t l="en">morphonological form</t>
			<t l="ru">&#x43C;&#x43E;&#x440;&#x444;&#x43E;&#x43B;&#x43E;&#x433;&#x438;&#x447;&#x435;&#x441;&#x43A;&#x430;&#x44F; &#x444;&#x43E;&#x440;&#x43C;&#x430;</t>
		</e>
		<e n="x:all">
			<t l="et">allikas</t>
			<t l="en">source</t>
			<t l="ru">&#x438;&#x441;&#x442;&#x43E;&#x447;&#x43D;&#x438;&#x43A;</t>
		</e>
		<e n="x:data">
			<t l="et">algtekst</t>
			<t l="en">source text</t>
			<t l="ru">&#x438;&#x441;&#x445;&#x43E;&#x434;&#x43D;&#x44B;&#x439; &#x442;&#x435;&#x43A;&#x441;&#x442;</t>
		</e>
		<a n="x:src">
			<t l="et">allikas</t>
			<t l="en">source</t>
			<t l="ru">&#x438;&#x441;&#x442;&#x43E;&#x447;&#x43D;&#x438;&#x43A;</t>
		</a>
		<a n="x:k">
			<t l="et">kustuta</t>
			<t l="en">kustuta</t>
			<t l="ru">kustuta</t>
		</a>
		<a n="x:aT">
			<t l="et">toimetaja</t>
			<t l="en">toimetaja</t>
			<t l="ru">toimetaja</t>
		</a>
		<a n="x:aTA">
			<t l="et">toimetamise aeg</t>
			<t l="en">toimetamise aeg</t>
			<t l="ru">toimetamise aeg</t>
		</a>
		<a n="x:g">
			<t l="et">genereeritud</t>
			<t l="en">genereeritud</t>
			<t l="ru">genereeritud</t>
		</a>
	</xsl:variable>
	<xsl:template match="/">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<xsl:template match="pref:sr">
		<!--<xsl:processing-instruction name="xml-stylesheet">
      <xsl:text>type="text/css" href="../css/gendEdit_psv.css"</xsl:text>
    </xsl:processing-instruction>-->
		<xsl:variable name="srLang">
			<xsl:choose>
				<xsl:when test="@xml:lang">
					<xsl:value-of select="@xml:lang"/>
				</xsl:when>
				<xsl:otherwise>et</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<body lang="{$srLang}">
			<table border="1" frame="box" rules="all" bordercolor="{$tblBrdCol}" style="width:100%;">
				<xsl:apply-templates select="pref:A">
					<xsl:with-param name="rada"/>
				</xsl:apply-templates>
			</table>
		</body>
	</xsl:template>
	<xsl:template match="*" mode="nodeInMixed">
		<xsl:param name="rada"/>
		<xsl:variable name="elPos">
			<xsl:value-of select="name()"/>
			<xsl:text>[</xsl:text>
			<xsl:number level="single" format="1"/>
			<xsl:text>]</xsl:text>
		</xsl:variable>
		<xsl:variable name="elId">
			<xsl:value-of select="concat($rada, $elPos)"/>
		</xsl:variable>
		<xsl:variable name="k">
			<xsl:call-template name="sekeldaNimi"/>
		</xsl:variable>
		<xsl:text xml:space="preserve"> </xsl:text>
		<xsl:element name="span">
			<xsl:attribute name="id">
				<xsl:value-of select="$elId"/>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat('`', $k, '` ', $elPos)"/>
			</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="function-available('al:unNameEditQn')">
						<xsl:value-of select="concat('enmx enmx_', al:unNameEditQn(name()), ' noedit')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('enmx enmx_', translate(name(), ':', '-'), ' noedit')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="tabIndex">0</xsl:attribute>
			<xsl:value-of select="local-name()"/>
		</xsl:element>
		<xsl:apply-templates select="@*[not(contains($attrNoDisplay, concat(';', name(..), '/@', name(), ';')))]" mode="nodeInMixed">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($elId, '/')"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:if test="@pref:mT = 'snd'">
			<xsl:element name="img">
				<xsl:attribute name="id">
					<xsl:value-of select="concat('sndListen||', $elId)"/>
				</xsl:attribute>
				<xsl:attribute name="src">graphics/sound_.ico</xsl:attribute>
				<xsl:attribute name="alt">k&#xF5;lar</xsl:attribute>
				<xsl:attribute name="title">kl&#xF5;psa kuulamiseks</xsl:attribute>
				<xsl:attribute name="style">width:16px;</xsl:attribute>
				<xsl:attribute name="tabIndex">0</xsl:attribute>
			</xsl:element>
		</xsl:if>
		<xsl:apply-templates select="node()[not(contains($elemNoDisplay, concat(';', name(..), '/', name(), ';')))]" mode="nodeInMixed">
			<xsl:with-param name="rada">
				<xsl:value-of select="concat($elId, '/')"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="@*" mode="nodeInMixed">
		<xsl:param name="rada"/>
		<xsl:variable name="qn">
			<xsl:value-of select="name()"/>
		</xsl:variable>
		<xsl:variable name="elPos">
			<xsl:text>@</xsl:text>
			<xsl:value-of select="$qn"/>
		</xsl:variable>
		<xsl:variable name="elId">
			<xsl:value-of select="concat($rada, $elPos)"/>
		</xsl:variable>
		<xsl:variable name="k">
			<xsl:value-of select="document('')//xsl:variable[@name = 'kirjeldavad']/a[@n = $qn]/t[@l = $appLang]"/>
		</xsl:variable>
		<xsl:variable name="sisu">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:element name="span">
			<xsl:attribute name="id">
				<xsl:value-of select="$elId"/>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat('`', $k, '` ', $elPos)"/>
			</xsl:attribute>
			<xsl:variable name="noEdit">
				<xsl:choose>
					<xsl:when test="contains($attrNoEdit, concat(';', name(..), '/@', $qn, ';'))"> noedit</xsl:when>
					<xsl:otherwise> edit</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="function-available('al:unNameEditQn')">
						<xsl:value-of select="concat('atmx atmx_', al:unNameEditQn(string($qn)), $noEdit)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('atmx atmx_', translate($qn, ':', '-'), $noEdit)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="string-length($sisu) &lt; 2">
				<xsl:attribute name="style">width:16px;display:inline-block;</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$sisu"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="text()" mode="nodeInMixed">
		<xsl:param name="rada"/>
		<xsl:variable name="elPos">
			<xsl:text>text()</xsl:text>
			<xsl:text>[</xsl:text>
			<xsl:number level="single" format="1"/>
			<xsl:text>]</xsl:text>
		</xsl:variable>
		<xsl:variable name="elId">
			<xsl:value-of select="concat($rada, $elPos)"/>
		</xsl:variable>
		<xsl:variable name="qn">
			<xsl:value-of select="name(..)"/>
		</xsl:variable>
		<xsl:variable name="k">
			<xsl:value-of select="document('')//xsl:variable[@name = 'kirjeldavad']/e[@n = $qn]/t[@l = $appLang]"/>
		</xsl:variable>
		<xsl:variable name="sisu">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:if test="preceding-sibling::*">
			<xsl:text xml:space="preserve"> </xsl:text>
		</xsl:if>
		<xsl:element name="span">
			<xsl:attribute name="id">
				<xsl:value-of select="$elId"/>
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="concat('`', $k, '` ', $elPos)"/>
			</xsl:attribute>
			<xsl:variable name="noEdit">
				<xsl:choose>
					<xsl:when test="contains($elemNoEdit, concat(';', name(../..), '/', $qn, ';'))"> noedit</xsl:when>
					<xsl:otherwise> edit</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="function-available('al:unNameEditQn')">
						<xsl:value-of select="concat('et et_', al:unNameEditQn(string($qn)), $noEdit)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('et et_', translate($qn, ':', '-'), $noEdit)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="string-length($sisu) &lt; 2">
				<xsl:attribute name="style">width:16px;display:inline-block;</xsl:attribute>
			</xsl:if>
			<xsl:if test="../@xml:lang">
				<xsl:attribute name="lang">
					<xsl:value-of select="../@xml:lang"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="tabIndex">0</xsl:attribute>
			<xsl:value-of select="$sisu"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="*">
		<xsl:param name="rada"/>
		<xsl:variable name="qn">
			<xsl:value-of select="name()"/>
		</xsl:variable>
		<xsl:variable name="elPos">
			<xsl:value-of select="name()"/>
			<xsl:text>[</xsl:text>
			<xsl:number level="single" format="1"/>
			<xsl:text>]</xsl:text>
		</xsl:variable>
		<xsl:variable name="elId">
			<xsl:value-of select="concat($rada, $elPos)"/>
		</xsl:variable>
		<xsl:variable name="k">
			<xsl:call-template name="sekeldaNimi"/>
		</xsl:variable>
		<xsl:variable name="xn">
			<xsl:number level="multiple" from="pref:A" count="*" format="1"/>
		</xsl:variable>
		<tr>
			<td width="32px">
				<xsl:variable name="paljuMindOn">
					<xsl:value-of select="count(../*[name() = $qn])"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="self::x:maht[name(..) = 'x:A']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:mg[name(..) = 'x:P']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 1">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:r[name(..) = 'x:m']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:hld[name(..) = 'x:mg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:vk[name(..) = 'x:mg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:grp[name(..) = 'x:mg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:mfp[name(..) = 'x:grp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:mkg[name(..) = 'x:mfp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:mkl[name(..) = 'x:mkg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:mk[name(..) = 'x:mkg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:mvg[name(..) = 'x:mfp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:vk[name(..) = 'x:mvg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:mv[name(..) = 'x:mvg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:mt[name(..) = 'x:mfp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:gri[name(..) = 'x:grp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:sl[name(..) = 'x:gri']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:gki[name(..) = 'x:gri']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:r[name(..) = 'x:gri']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:v[name(..) = 'x:mg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:s[name(..) = 'x:mg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:a[name(..) = 'x:P']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:mvt[name(..) = 'x:P']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:S[name(..) = 'x:A']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:tp[name(..) = 'x:S']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 1">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:mmg[name(..) = 'x:tp']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:vk[name(..) = 'x:mmg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:gri[name(..) = 'x:tp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:tg[name(..) = 'x:tp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:dg[name(..) = 'x:tg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:v[name(..) = 'x:dg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:s[name(..) = 'x:dg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:dt[name(..) = 'x:dg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:d[name(..) = 'x:dg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:ld[name(..) = 'x:d']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xp[name(..) = 'x:tg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xg[name(..) = 'x:xp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 1">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xtx[name(..) = 'x:xg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xr[name(..) = 'x:x']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:hld[name(..) = 'x:xg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xvk[name(..) = 'x:xg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xgrp[name(..) = 'x:xg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xmfp[name(..) = 'x:xgrp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xmvg[name(..) = 'x:xmfp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xvk[name(..) = 'x:xmvg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xmv[name(..) = 'x:xmvg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xag[name(..) = 'x:xmfp']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xa[name(..) = 'x:xag']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xmv[name(..) = 'x:xag']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xmt[name(..) = 'x:xmfp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xgri[name(..) = 'x:xgrp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xsl[name(..) = 'x:xgri']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xz[name(..) = 'x:xgri']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xgki[name(..) = 'x:xgri']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xr[name(..) = 'x:xgri']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xdg[name(..) = 'x:xg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xv[name(..) = 'x:xdg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xs[name(..) = 'x:xdg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xd[name(..) = 'x:xdg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xn[name(..) = 'x:xdg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:np[name(..) = 'x:tp']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:ng[name(..) = 'x:np']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 1">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:n[name(..) = 'x:ng']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 1">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:r[name(..) = 'x:n']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:qnp[name(..) = 'x:ng']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 1">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:ndg[name(..) = 'x:qnp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:v[name(..) = 'x:ndg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:s[name(..) = 'x:ndg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:nd[name(..) = 'x:ndg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:ld[name(..) = 'x:nd']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:qng[name(..) = 'x:qnp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 1">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xtx[name(..) = 'x:qng']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xr[name(..) = 'x:qn']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xv[name(..) = 'x:qng']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:xs[name(..) = 'x:qng']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:tvt[name(..) = 'x:tp']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:LS[name(..) = 'x:S']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:lsdg[name(..) = 'x:LS']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:v[name(..) = 'x:lsdg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:s[name(..) = 'x:lsdg']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:lsd[name(..) = 'x:lsdg']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:np[name(..) = 'x:LS']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:tvt[name(..) = 'x:LS']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:KOM[name(..) = 'x:A']">
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:komg[name(..) = 'x:KOM']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 1">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="self::x:I[name(..) = 'x:A']">
						<img id="{concat('addgrupp||', $elId)}" src="{$addGroupPicture}" alt="lisa" title="{concat('Lisa `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						<xsl:if test="$paljuMindOn &gt; 0">
							<img id="{concat('delgrupp||', $elId)}" src="{$delGroupPicture}" alt="kustuta" title="{concat('Kustuta `', $k, '` &lt;', name(), '&gt;!')}" tabIndex="0"/>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</td>
			<td width="33%">
				<xsl:variable name="xn2">
					<xsl:choose>
						<xsl:when test="function-available('al:xslNumberToRepString')">
							<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', -1)"/>
						</xsl:when>
						<xsl:when test="function-available('eRegs:replace')">
							<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:element name="span">
					<xsl:value-of select="$xn2"/>
				</xsl:element>
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="$elId"/>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="$elPos"/>
					</xsl:attribute>
					<xsl:attribute name="class">
						<xsl:choose>
							<xsl:when test="function-available('al:unNameEditQn')">
								<xsl:value-of select="concat('en en_', al:unNameEditQn(name()), ' noedit')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('en en_', translate(name(), ':', '-'), ' noedit')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:if test="not(contains($segad, concat(';', name(), ';')) or contains($tekstiga, concat(';', name(), ';')))">
						<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="tabIndex">0</xsl:attribute>
					<xsl:value-of select="$k"/>
				</xsl:element>
				<xsl:if test="contains($segad, concat(';', name(), ';'))">
					<span> +</span>
				</xsl:if>
				<!--atribuudid-->
				<xsl:text>&#xA0;</xsl:text>
				<xsl:choose>
					<xsl:when test="name() = 'x:m'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:m/@x:i</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:m/@x:liik</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:m/@x:ps</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:m/@x:u</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:sl'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:sl/@x:rk</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:v'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:v/@x:l</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:s'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:s/@x:l</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:a'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:a/@x:i</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:mvt'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:mvt/@x:i</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:mvt/@x:t</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:mvt/@x:mvtl</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:v'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:v/@x:l</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:s'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:s/@x:l</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:dt'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:dt/@x:i</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:dt/@x:t</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:ld'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:ld/@xml:lang</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:x'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:x/@x:xliik</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:x/@x:xall</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:xa'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:xa/@x:xgk</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:n'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:n/@x:nrl</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:v'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:v/@x:l</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:s'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:s/@x:l</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:ld'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:ld/@xml:lang</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:tvt'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:tvt/@x:i</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:tvt/@x:t</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:tvt/@x:tvtl</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:v'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:v/@x:l</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:s'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:s/@x:l</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:tvt'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:tvt/@x:i</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:tvt/@x:t</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:tvt/@x:tvtl</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="@pref:mT = 'snd'">
					<xsl:text>&#xA0;</xsl:text>
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('sndListen||', $elId)"/>
						</xsl:attribute>
						<xsl:attribute name="src">graphics/sound_.ico</xsl:attribute>
						<xsl:attribute name="alt">k&#xF5;lar</xsl:attribute>
						<xsl:attribute name="title">kl&#xF5;psa kuulamiseks</xsl:attribute>
						<xsl:attribute name="style">width:16px;</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="contains($segad, concat(';', name(), ';'))">
						<xsl:apply-templates select="node()[not(contains($elemNoDisplay, concat(';', name(..), '/', name(), ';')))]" mode="nodeInMixed">
							<xsl:with-param name="rada">
								<xsl:value-of select="concat($elId, '/')"/>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="contains($tekstiga, concat(';', name(), ';'))">
						<xsl:element name="span">
							<xsl:attribute name="id">
								<xsl:value-of select="concat($elId, '/text()[1]')"/>
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="concat('`', $k, '` ', $elPos, '/text()[1]')"/>
							</xsl:attribute>
							<xsl:variable name="noEdit">
								<xsl:choose>
									<xsl:when test="contains($elemNoEdit, concat(';', name(..), '/', $qn, ';'))"> noedit</xsl:when>
									<xsl:otherwise> edit</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="function-available('al:unNameEditQn')">
										<xsl:value-of select="concat('et et_', al:unNameEditQn(name()),  $noEdit, ' etws')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat('et et_', translate(name(), ':', '-'),  $noEdit, ' etws')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:if test="@xml:lang">
								<xsl:attribute name="lang">
									<xsl:value-of select="@xml:lang"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="tabIndex">0</xsl:attribute>
							<xsl:choose>
								<xsl:when test="@pref:mT = 'html'">
									<!--<xsl:value-of select="." disable-output-escaping="yes"></xsl:value-of>-->
									<xsl:copy-of select="current()"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="name() = 'x:sr'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:sr/@xml:lang</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:A'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:A/@x:AS</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:tp'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:tp/@x:tnr</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:tp/@x:as</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:tg'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:tg/@x:as</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:xg'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:xg/@xml:lang</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:xg/@x:as</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:ng'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:ng/@x:as</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:qnp'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:qnp/@x:ntnr</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:qng'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:qng/@xml:lang</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="name() = 'x:LS'">
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:LS/@x:lso</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="sekeldaAtribuut">
							<xsl:with-param name="elId">
								<xsl:value-of select="$elId"/>
							</xsl:with-param>
							<xsl:with-param name="fullQn">x:LS/@x:as</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</td>
			<td width="32px">
				<!--lisaelemendid ja tühjade kustutamine-->
				<xsl:if test="*[normalize-space(.) = '']">
					<xsl:element name="img">
						<xsl:attribute name="id">
							<xsl:value-of select="concat('dellisad||', $elId)"/>
						</xsl:attribute>
						<xsl:attribute name="src">
							<xsl:value-of select="$delLisadPicture"/>
						</xsl:attribute>
						<xsl:attribute name="alt">kustuta_t&#xFC;hjad</xsl:attribute>
						<xsl:attribute name="title">Kustuta t&#xFC;hjad elemendid!</xsl:attribute>
						<xsl:attribute name="tabIndex">0</xsl:attribute>
					</xsl:element>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="name() = 'x:mkg'">
						<xsl:if test="not(x:mkl and x:mk)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:mvg'">
						<xsl:if test="not(x:vk and x:mv)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:mfp'">
						<xsl:if test="not(x:mkg and x:mvg and x:mt)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:gri'">
						<xsl:if test="not(x:sl and x:gki and x:r)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:grp'">
						<xsl:if test="not(x:mfp and x:gri)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:mg'">
						<xsl:if test="not(x:m and x:hld and x:vk and x:grp and x:v and x:s)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:P'">
						<xsl:if test="not(x:mg and x:a and x:mvt)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:mmg'">
						<xsl:if test="not(x:mm and x:vk)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:gri'">
						<xsl:if test="not(x:sl and x:gki and x:r)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:dg'">
						<xsl:if test="not(x:v and x:s and x:dt and x:d)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:xmvg'">
						<xsl:if test="not(x:xvk and x:xmv)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:xag'">
						<xsl:if test="not(x:xa and x:xmv)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:xmfp'">
						<xsl:if test="not(x:xmvg and x:xag and x:xmt)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:xgri'">
						<xsl:if test="not(x:xsl and x:xz and x:xgki and x:xr)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:xgrp'">
						<xsl:if test="not(x:xmfp and x:xgri)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:xdg'">
						<xsl:if test="not(x:xv and x:xs and x:xd and x:xn)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:xg'">
						<xsl:if test="not(x:xtx and x:x and x:hld and x:xvk and x:xgrp and x:xdg)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:xp'">
						<xsl:if test="not(x:xg)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:tg'">
						<xsl:if test="not(x:dg and x:xp)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:ndg'">
						<xsl:if test="not(x:v and x:s and x:nd)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:qng'">
						<xsl:if test="not(x:xtx and x:qn and x:xv and x:xs)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:qnp'">
						<xsl:if test="not(x:ndg and x:qng)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:ng'">
						<xsl:if test="not(x:n and x:qnp)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:np'">
						<xsl:if test="not(x:ng)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:tp'">
						<xsl:if test="not(x:mmg and x:gri and x:tg and x:np and x:tvt)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:lsdg'">
						<xsl:if test="not(x:v and x:s and x:lsd)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:np'">
						<xsl:if test="not(x:ng)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:LS'">
						<xsl:if test="not(x:lsdg and x:np and x:tvt)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:S'">
						<xsl:if test="not(x:tp and x:LS)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:komg'">
						<xsl:if test="not(x:kom and x:kaut and x:kaeg)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:KOM'">
						<xsl:if test="not(x:komg)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:I'">
						<xsl:if test="not(x:any)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:A'">
						<xsl:if test="not(x:maht and x:P and x:S and x:KOM and x:I)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					<xsl:when test="name() = 'x:sr'">
						<xsl:if test="not(x:A)">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('addlisad||', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$addLisadPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">lisa_puuduvad</xsl:attribute>
								<xsl:attribute name="title">Lisa puuduvad elemendid!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</td>
		</tr>
		<xsl:choose>
			<xsl:when test="name() = 'x:sr'">
				<xsl:apply-templates select="x:A">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:A'">
				<xsl:if test="not(x:maht)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:maht|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `mahuklass` &lt;x:maht&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>mahuklass</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:maht">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="x:P">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:S)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:S|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `sisu` &lt;x:S&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>sisu</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:S">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:KOM)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:KOM|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `kommentaarid` &lt;x:KOM&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>kommentaarid</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:KOM">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:I)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:I|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `imporditud artiklid` &lt;x:I&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>imporditud artiklid</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:I">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:P'">
				<xsl:apply-templates select="x:mg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:a)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:a|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `alternatiiv` &lt;x:a&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>alternatiiv</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:a">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:mvt)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:mvt|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `m&#xE4;rks&#xF5;naviide` &lt;x:mvt&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>m&#xE4;rks&#xF5;naviide</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:mvt">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:mg'">
				<xsl:apply-templates select="x:m">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:hld)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:hld|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `h&#xE4;&#xE4;ldus` &lt;x:hld&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>h&#xE4;&#xE4;ldus</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:hld">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:vk)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:vk|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vormikood` &lt;x:vk&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vormikood</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:vk">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:grp)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:grp|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `grammatika plokk` &lt;x:grp&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>grammatika plokk</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:grp">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:v)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:v|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vald` &lt;x:v&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vald</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:v">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:s)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:s|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `stiil` &lt;x:s&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>stiil</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:s">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:grp'">
				<xsl:if test="not(x:mfp)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:mfp|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `morfoloogia plokk` &lt;x:mfp&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>morfoloogia plokk</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:mfp">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:gri)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:gri|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `grammatiline info` &lt;x:gri&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>grammatiline info</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:gri">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:mfp'">
				<xsl:if test="not(x:mkg)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:mkg|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `morf.kirje grupp` &lt;x:mkg&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>morf.kirje grupp</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:mkg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:mvg)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:mvg|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `muutevormi grupp` &lt;x:mvg&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>muutevormi grupp</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:mvg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:mt)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:mt|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `muutt&#xFC;&#xFC;p` &lt;x:mt&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>muutt&#xFC;&#xFC;p</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:mt">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:mkg'">
				<xsl:if test="not(x:mkl)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:mkl|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `morf.kirje l&#xFC;hikujul` &lt;x:mkl&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>morf.kirje l&#xFC;hikujul</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:mkl">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:mk)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:mk|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `morf.kirje` &lt;x:mk&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>morf.kirje</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:mk">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:mvg'">
				<xsl:if test="not(x:vk)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:vk|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vormikood` &lt;x:vk&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vormikood</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:vk">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:mv)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:mv|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `muutevormid` &lt;x:mv&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>muutevormid</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:mv">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:gri'">
				<xsl:if test="not(x:sl)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:sl|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `s&#xF5;naliik` &lt;x:sl&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>s&#xF5;naliik</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:sl">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:gki)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:gki|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `gr.kasutusinfo` &lt;x:gki&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>gr.kasutusinfo</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:gki">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:r)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:r|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `rektsioon` &lt;x:r&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>rektsioon</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:r">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:S'">
				<xsl:apply-templates select="x:tp">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:LS)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:LS|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `liits&#xF5;nade plokk` &lt;x:LS&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>liits&#xF5;nade plokk</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:LS">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:tp'">
				<xsl:if test="not(x:mmg)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:mmg|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `allm&#xE4;rks&#xF5;na grupp` &lt;x:mmg&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>allm&#xE4;rks&#xF5;na grupp</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:mmg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:gri)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:gri|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `grammatiline info` &lt;x:gri&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>grammatiline info</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:gri">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:tg)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:tg|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `t&#xE4;hendusgrupp` &lt;x:tg&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>t&#xE4;hendusgrupp</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:tg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:np)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:np|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `n&#xE4;idete plokk` &lt;x:np&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>n&#xE4;idete plokk</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:np">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:tvt)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:tvt|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `t&#xE4;hendusviide` &lt;x:tvt&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>t&#xE4;hendusviide</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:tvt">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:mmg'">
				<xsl:apply-templates select="x:mm">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:vk)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:vk|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vormikood` &lt;x:vk&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vormikood</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:vk">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:gri'">
				<xsl:if test="not(x:sl)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:sl|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `s&#xF5;naliik` &lt;x:sl&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>s&#xF5;naliik</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:sl">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:gki)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:gki|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `gr.kasutusinfo` &lt;x:gki&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>gr.kasutusinfo</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:gki">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:r)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:r|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `rektsioon` &lt;x:r&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>rektsioon</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:r">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:tg'">
				<xsl:if test="not(x:dg)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:dg|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `definitsioonigrupp` &lt;x:dg&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>definitsioonigrupp</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:dg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xp)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xp|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vastete plokk` &lt;x:xp&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>vastete plokk</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xp">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:dg'">
				<xsl:if test="not(x:v)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:v|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vald` &lt;x:v&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vald</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:v">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:s)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:s|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `stiil` &lt;x:s&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>stiil</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:s">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:dt)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:dt|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `tulenemisseletus` &lt;x:dt&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>tulenemisseletus</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:dt">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:d)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:d|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `seletus` &lt;x:d&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>seletus</xsl:element>
							<span> +</span>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:d">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:xp'">
				<xsl:apply-templates select="x:xg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:xg'">
				<xsl:if test="not(x:xtx)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xtx|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `t&#xE4;psustus` &lt;x:xtx&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>t&#xE4;psustus</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xtx">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="x:x">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:hld)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:hld|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `h&#xE4;&#xE4;ldus` &lt;x:hld&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>h&#xE4;&#xE4;ldus</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:hld">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xvk)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xvk|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vormikood` &lt;x:xvk&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vormikood</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xvk">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xgrp)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xgrp|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vaste grammatika plokk` &lt;x:xgrp&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>vaste grammatika plokk</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xgrp">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xdg)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xdg|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vaste definitsioonigrupp` &lt;x:xdg&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>vaste definitsioonigrupp</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xdg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:xgrp'">
				<xsl:if test="not(x:xmfp)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xmfp|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vaste morfoloogia plokk` &lt;x:xmfp&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>vaste morfoloogia plokk</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xmfp">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xgri)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xgri|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vaste grammatiline info` &lt;x:xgri&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>vaste grammatiline info</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xgri">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:xmfp'">
				<xsl:if test="not(x:xmvg)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xmvg|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vaste muutevormigrupp` &lt;x:xmvg&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>vaste muutevormigrupp</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xmvg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xag)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xag|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `gr.variandi grupp` &lt;x:xag&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>gr.variandi grupp</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xag">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xmt)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xmt|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vaste muutt&#xFC;&#xFC;p` &lt;x:xmt&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vaste muutt&#xFC;&#xFC;p</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xmt">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:xmvg'">
				<xsl:if test="not(x:xvk)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xvk|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vormikood` &lt;x:xvk&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vormikood</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xvk">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xmv)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xmv|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `muutevormid` &lt;x:xmv&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>muutevormid</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xmv">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:xag'">
				<xsl:if test="not(x:xa)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xa|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `gr.variant` &lt;x:xa&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>gr.variant</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xa">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xmv)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xmv|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `muutevormid` &lt;x:xmv&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>muutevormid</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xmv">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:xgri'">
				<xsl:if test="not(x:xsl)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xsl|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `s&#xF5;naliik` &lt;x:xsl&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>s&#xF5;naliik</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xsl">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xz)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xz|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `gr.sugu` &lt;x:xz&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>gr.sugu</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xz">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xgki)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xgki|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `gr.kasutusinfo` &lt;x:xgki&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>gr.kasutusinfo</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xgki">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xr)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xr|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `rektsioon` &lt;x:xr&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>rektsioon</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xr">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:xdg'">
				<xsl:if test="not(x:xv)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xv|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vald` &lt;x:xv&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vald</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xv">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xs)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xs|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `stiil` &lt;x:xs&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>stiil</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xs">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xd)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xd|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vaste seletus` &lt;x:xd&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vaste seletus</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xd">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xn)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xn|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vaste kasutusn&#xE4;ide` &lt;x:xn&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vaste kasutusn&#xE4;ide</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xn">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:np'">
				<xsl:apply-templates select="x:ng">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:ng'">
				<xsl:apply-templates select="x:n">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="x:qnp">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:qnp'">
				<xsl:if test="not(x:ndg)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:ndg|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `n&#xE4;ite definitsioonigrupp` &lt;x:ndg&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>n&#xE4;ite definitsioonigrupp</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:ndg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="x:qng">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:ndg'">
				<xsl:if test="not(x:v)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:v|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vald` &lt;x:v&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vald</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:v">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:s)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:s|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `stiil` &lt;x:s&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>stiil</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:s">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:nd)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:nd|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `n&#xE4;ite seletus` &lt;x:nd&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>n&#xE4;ite seletus</xsl:element>
							<span> +</span>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:nd">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:qng'">
				<xsl:if test="not(x:xtx)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xtx|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `t&#xE4;psustus` &lt;x:xtx&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>t&#xE4;psustus</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xtx">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="x:qn">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xv)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xv|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vald` &lt;x:xv&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vald</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xv">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:xs)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:xs|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `stiil` &lt;x:xs&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>stiil</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:xs">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:LS'">
				<xsl:if test="not(x:lsdg)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:lsdg|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `ls. definitsioonigrupp` &lt;x:lsdg&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>ls. definitsioonigrupp</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:lsdg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:np)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:np|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `n&#xE4;idete plokk` &lt;x:np&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
								<xsl:attribute name="style">text-decoration:underline;</xsl:attribute>n&#xE4;idete plokk</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:np">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:tvt)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:tvt|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `t&#xE4;hendusviide` &lt;x:tvt&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>t&#xE4;hendusviide</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:tvt">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:lsdg'">
				<xsl:if test="not(x:v)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:v|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `vald` &lt;x:v&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>vald</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:v">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:s)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:s|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `stiil` &lt;x:s&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>stiil</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:s">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="not(x:lsd)">
					<tr>
						<td width="16px">
							<xsl:element name="img">
								<xsl:attribute name="id">
									<xsl:value-of select="concat('creategrupp|x:lsd|', $elId)"/>
								</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:value-of select="$createGroupPicture"/>
								</xsl:attribute>
								<xsl:attribute name="alt">loo</xsl:attribute>
								<xsl:attribute name="title">Loo `liits&#xF5;naosa seletus` &lt;x:lsd&gt;!</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>
							</xsl:element>
						</td>
						<td width="33%">
							<xsl:variable name="xn2">
								<xsl:choose>
									<xsl:when test="function-available('al:xslNumberToRepString')">
										<xsl:value-of select="al:xslNumberToRepString(string($xn), '&#xA0;', 0)"/>
									</xsl:when>
									<xsl:when test="function-available('eRegs:replace')">
										<xsl:value-of select="eRegs:replace($xn, '(\d+(\.)?)', 'g', '&#xA0;')"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:element name="span">
								<xsl:value-of select="$xn2"/>
							</xsl:element>
							<xsl:element name="span">
								<xsl:attribute name="class">ec noedit</xsl:attribute>
								<xsl:attribute name="tabIndex">0</xsl:attribute>liits&#xF5;naosa seletus</xsl:element>
						</td>
						<td/>
						<td width="32px"/>
					</tr>
				</xsl:if>
				<xsl:apply-templates select="x:lsd">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:np'">
				<xsl:apply-templates select="x:ng">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:KOM'">
				<xsl:apply-templates select="x:komg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:komg'">
				<xsl:apply-templates select="x:kom">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="x:kaut">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="x:kaeg">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="name() = 'x:I'">
				<xsl:apply-templates select="x:any">
					<xsl:with-param name="rada">
						<xsl:value-of select="concat($elId, '/')"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="sekeldaNimi">
		<xsl:variable name="qn">
			<xsl:value-of select="name()"/>
		</xsl:variable>
		<xsl:variable name="k">
			<xsl:value-of select="document('')//xsl:variable[@name = 'kirjeldavad']/e[@n = $qn]/t[@l = $appLang]"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$k = ''">
				<xsl:value-of select="name()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$k"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="sekeldaAtribuut">
		<xsl:param name="elId"/>
		<xsl:param name="fullQn"/>
		<xsl:variable name="qn">
			<xsl:value-of select="substring-after($fullQn, '@')"/>
		</xsl:variable>
		<xsl:variable name="k">
			<xsl:value-of select="document('')//xsl:variable[@name = 'kirjeldavad']/a[@n = $qn]/t[@l = $appLang]"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@*[name() = $qn]">
				<xsl:variable name="sisu">
					<xsl:value-of select="@*[name() = $qn]"/>
				</xsl:variable>
				<xsl:if test="not(contains($attrNoDelete, concat(';', $fullQn, ';')))">
					<span class="delatt">&#xA0;&#xA0;</span>
				</xsl:if>
				<xsl:element name="span">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($elId, '/@', $qn)"/>
					</xsl:attribute>
					<xsl:attribute name="title">
						<xsl:value-of select="concat('`', $k, '` @', $qn)"/>
					</xsl:attribute>
					<xsl:variable name="noEdit">
						<xsl:choose>
							<xsl:when test="contains($attrNoEdit, concat(';', $fullQn, ';'))"> noedit</xsl:when>
							<xsl:otherwise> edit</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="class">
						<xsl:choose>
							<xsl:when test="function-available('al:unNameEditQn')">
								<xsl:value-of select="concat('at at_', al:unNameEditQn(string($qn)),  $noEdit)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('at at_', translate($qn, ':', '-'),  $noEdit)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:if test="string-length($sisu) &lt; 2">
						<xsl:attribute name="style">width:16px;display:inline-block;</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$sisu"/>
				</xsl:element>
				<xsl:text>&#xA0;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="not(contains($attrNoCreate, concat(';', $fullQn, ';')))">
					<img src="graphics/struprop_16-16.ico" alt="loo" border="1" id="{concat('addAttr|', $qn, '|', $elId)}" title="{concat('Loo `', $k, '` @', $qn, '!')}"/>
					<xsl:text>&#xA0;</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
