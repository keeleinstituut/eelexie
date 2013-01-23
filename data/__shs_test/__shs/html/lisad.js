/**
* lisad.js.
*
* @class lisad
*/

/**
* Hoiab erimärke.
* 
* @property specCh
* @type {String}
* @default \|(){}[]-+.?*^$
*/
var specCh = "\\|(){}[]-+.?*^$";

/**
* Hoiab eraldusmärki. Sama, mis PD.
* 
* @property JR
* @type {String}
* @default uE001
*/
var PD = "\uE001";

/**
* Hoiab eraldusmärki. Sama, mis JR.
* 
* @property PD
* @type {String}
* @default uE001
*/
var JR = "\uE001";

/**
* Hoiab laiendatud ladina tähestikku.
* 
* @property REG_LETT_LA
* @type {String}
* @default tähestik
*/
var REG_LETT_LA = "aàáâãåāăąǎǡǻȁȃḁạảấầẩẫậắằẳẵặbƃƅḃḅḇcçćĉċčƈḉdðďđƌḋḍḏḑḓeèéêëēĕėęěȅȇḕḗḙḛḝẹẻẽếềểễệfƒḟgĝğġģǥǧǵḡhĥħḣḥḧḩḫiìíîïĩīĭįıǐȉȋḭḯỉịjĵkķƙǩḱḳḵlĺļľŀłḷḹḻḽmḿṁṃnñńņňŋṅṇṉṋoòóôøōŏőơǒǫǭǿȍȏṑṓọỏốồổỗộớờởỡợpƥṕṗqrŕŗřȑȓṙṛṝṟsśŝşṡṣṥṩšṧzźżƶẑẓẕžtţťŧƭṫṭṯṱuùúûũūŭůűųưǔȕȗṳṵṷṹṻụủứừửữựvṽṿwŵẁẃẅẇẉõṍṏäǟöüǖǘǚǜxẋẍyýŷÿƴẏỳỵỷỹ";

/**
* Hoiab vene tähestikku.
* 
* @property REG_LETT_RU
* @type {String}
* @default tähestik
*/
var REG_LETT_RU = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя";

// FSO konstandid
var ForReading = 1; // 	Open a file for reading only. You can't write to this file.
var ForWriting = 2; // 	Open a file for writing. If a file with the same name exists, its previous contents are overwritten.
var ForAppending = 8; // Open a file and write to the end of the file.
var TristateUseDefault = -2; // Opens the file using the system default.
var TristateTrue = -1; // 	Opens the file as Unicode.
var TristateFalse = 0; // Opens the file as ASCII.


/**
* TODO
*
* @method getReqValue
* @param {Object} uusNode 
* @param {Object} origNode
* @return {Boolean} eitea
*/
function getReqValue(uusNode, origNode) {
    var xh, answer, rspDOM, status, reks;
    var org = jsTrim(getXmlNodeValue(origNode));
    switch (org) {
        case "|GUID|":
            xh = exCGISync("tools.cgi", "getGUID" + PD + dic_desc + PD + sUsrName);
            answer = "lähen nüüd GUID-i saama ...";
            if (xh.statusText == "OK") {
                rspDOM = ParseHTTPResponse(xh);
                if (rspDOM) {
                    status = getXmlSingleNodeValue(rspDOM, "rsp/sta");
                    if (status == "Success") {
                        answer = getXmlSingleNodeValue(rspDOM, "rsp/answer");
                    }
                }
            }
            setXmlNodeValue(uusNode, answer);
            break;
        case "|DATETIME|":
            setXmlNodeValue(uusNode, GetXSDDateTime(new Date()));
            break;
        case "|USER|":
            setXmlNodeValue(uusNode, sUsrName);
            break;
        default:
            if (org) {
                reks = /^\|\w+\+\+\|$/; // |kirje_id++|, |m++|
                if (reks.test(org)) {
                    var nimi = org.substr(1, org.length - 4);
                    xh = exCGISync("tools.cgi", "getAutoInc" + PD + dic_desc + PD + sUsrName + PD + nimi);
                    answer = "lähen nüüd autoinc-i saama ...";
                    if (xh.statusText == "OK") {
                        rspDOM = ParseHTTPResponse(xh);
                        if (rspDOM) {
                            status = getXmlSingleNodeValue(rspDOM, "rsp/sta");
                            if (status == "Success") {
                                answer = getXmlSingleNodeValue(rspDOM, "rsp/answer");
                            }
                        }
                    }
                    setXmlNodeValue(uusNode, answer);
                }
                else {
                    setXmlNodeValue(uusNode, org);
                }
            }
            else {
                if (window.ActiveXObject) {
                    setXmlNodeValue(uusNode, org);
                } else {
                    // mitte MS XML dokumendis puudub asi nagu preservewhitespace
                    if (uusNode.nodeType == Node.ELEMENT_NODE) {
                        uusNode.appendChild(oEditDOM.createTextNode(" "));
                    }
                }
            }
            break;
    }
} // getReqValue


/**
* Tagastab brauseri versiooni.
*
* @method getBrowserData
* @return {String} kujul: browser + ";" + verNr + ";" + opSys
*/
function getBrowserData() {
    var agent = navigator.userAgent.toLowerCase();
    var browser = "Unknown browser", verStr = "Unknown", brLang = "xx-YY", winStr = "Unknown";
    if (agent.search("msie") > -1) {
        browser = "Internet Explorer";
        verStr = "MSIE ";
        brLang = navigator.browserLanguage;
        winStr = "Windows"; //;
    }
    else {
        if (agent.search("firefox") > -1) {
            browser = "Firefox";
            verStr = "Firefox\/";
            brLang = navigator.language;
            winStr = "Windows"; //;
        }
        else {
            if (agent.search("opera") > -1) {
                browser = "Opera";
                verStr = "Version\/";
                brLang = navigator.language;
                winStr = "Windows"; //;
            }
            else {
                if (agent.search("safari") > -1) {
                    if (agent.search("chrome") > -1) {
                        browser = "Chrome";
                        verStr = "Chrome\/";
                        brLang = navigator.language;
                        winStr = "Windows"; //)
                    }
                    else {
                        browser = "Safari";
                        verStr = "Version\/";
                        brLang = navigator.language;
                        winStr = "Windows"; //)
                    }
                }
            }
        }
    }
    var verNr = "x.y";
    var re = new RegExp(verStr + "(\[\\d\\.\]\+)");
    if (re.test(navigator.userAgent)) {
        verNr = RegExp.$1;
    }
    var opSys = "Juku";
    re = new RegExp("(" + winStr + "\.\+\?)(;\|\\))");
    if (re.test(navigator.userAgent)) {
        opSys = RegExp.$1;
    }
    return (browser + ";" + verNr + ";" + opSys);
} // getBrowserData


/**
* Sisendstringist kustutatakse ära kõik sümbolid, mis ei kuulu tähestikku msAlpha ega muutujasse voivadOlla.
*
* @method RemoveSymbols
* @param {String} inpstr Sisendstring, millest kustutatakse. Kustutatakse ka &amp; järjendid. 
* @param {String} voivadOlla Nimekiri sümbolitest, mis alles jäävad.
* @return {String} Puhastatud string.
*/
function RemoveSymbols(inpstr, voivadOlla) {
    var inps = inpstr.replace(/(&amp;)/g, '&');
    inps = inps.replace(/(&\w+;)/g, "");

    var rsstr = '';
    var tahed = msAlpha + voivadOlla;
    for (var i = 0; i < inps.length; i++) {
        if (tahed.indexOf(inps.charAt(i).toLowerCase()) > -1) {
            rsstr += inps.charAt(i);
        }
    }
    return rsstr;
} //RemoveSymbols

/**
* Leiab elemendi õed-vennad.
*
* @method getFollowingSiblings
* @param {String} elId Rada elemendini.
* @param {String} qn xPath.
* @return {String} Siblingite nimed loeteluna. Või "Ei saa" või "". 
*/
function getFollowingSiblings(elId, qn) {
    var yldStruAsukoht, yldStruNode, i;
    var yldStruNodePath = elId.replace(/(\[\d+\])/g, "");
    yldStruAsukoht = getXmlSingleNode(yldStruDom.documentElement, yldStruNodePath);
    if (yldStruAsukoht) {
        yldStruNode = getXmlSingleNode(yldStruAsukoht, qn);
        if (yldStruNode) {
            var follSibls = getXmlNodes(yldStruNode, "following-sibling::*");
            if (follSibls) {
                var nimed = "";
                if (follSibls.iterateNext) {
                    var iter = follSibls.iterateNext();
                    while (iter) {
                        if (nimed.length > 0) {
                            nimed += "|";
                        }
                        nimed += iter.nodeName;
                        iter = follSibls.iterateNext();
                    }
                } else if ('length' in follSibls) { // nodeList, MSXML
                    for (i = 0; i < follSibls.length; i++) {
                        if (nimed.length > 0) {
                            nimed += "|";
                        }
                        nimed += follSibls[i].nodeName;
                    }
                }
                return nimed;
            }
            else {
                return "";
            }
        }
        else {
            return "Ei saa";
        }
    }
    else {
        return "Ei saa";
    }
} // getFollowingSiblings


/**
* Teeb xml-nodest sellise xml-stringi, mis on xml.
*
* @method getXmlString
* @param {Object} node 
* @return {String} xml teksti kujul.
*/
function getXmlString(node) {
    var xmlString;
    // IE MSXML esimesena, kuigi "if (window.XMLSerializer)" läheb IE9 all läbi.
    // IE9-s toetab ainult xmldocument objekti, mitte elementi,
    // IE8-s muidugi ei olegi "XMLSerializer" tuge
    if ('xml' in node) {
        xmlString = node.xml;
    } else if (window.XMLSerializer) {
        var serializer = new XMLSerializer();
        xmlString = serializer.serializeToString(node);
    }
    return xmlString;
} // getXmlString


/**
* Tehakse xPath päring ja väljastatakse nodede nimekiri. XPathResult.ORDERED_NODE_ITERATOR_TYPE,
*
* @method getXmlNodes
* @param {Object} xmlElement Element, millelt päring tehakse.
* @param {String} xPath 
* @return {Object} null või nodelist. 
*/
function getXmlNodes(xmlElement, xPath) {
    var xmlDom;
    if (xmlElement.ownerDocument) {
        xmlDom = xmlElement.ownerDocument;
    }
    else {
        xmlDom = xmlElement;
    }
    // IE test tagapool
    if (xmlDom.evaluate) {
        var xpathResult = xmlDom.evaluate(xPath, xmlElement, NSResolver, XPathResult.ORDERED_NODE_ITERATOR_TYPE, null);
        if (xpathResult.resultType == XPathResult.ORDERED_NODE_ITERATOR_TYPE) {
            return xpathResult;
        }
        else {
            return null;
        }
    } else if ('selectNodes' in xmlDom) {
        return xmlElement.selectNodes(xPath);
    }
    else {
        return null;
    }
} // getXmlNodes


/**
* Tehakse xPath päring ja väljastatakse nodede nimekiri. XPathResult.ORDERED_NODE_SNAPSHOT_TYPE
* 
* @method getXmlNodesSnapshot
* @param {Object} xmlElement Element, millelt päring tehakse.
* @param {String} xPath 
* @return {Object} null või nodelist. 
*/
function getXmlNodesSnapshot(xmlElement, xPath) {
    var xmlDom;
    if (xmlElement.ownerDocument) {
        xmlDom = xmlElement.ownerDocument;
    }
    else {
        xmlDom = xmlElement;
    }
    if (xmlDom.evaluate) {
        var xpathResult = xmlDom.evaluate(xPath, xmlElement, NSResolver, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
        if (xpathResult.resultType == XPathResult.ORDERED_NODE_SNAPSHOT_TYPE) {
            return xpathResult;
        }
        else {
            return null;
        }
    } else if ('selectNodes' in xmlDom) {
        return xmlElement.selectNodes(xPath);
    }
    else {
        return null;
    }
} // getXmlNodesSnapshot


/**
* Teeb xPath päringu ja vastab ühe node'i.
*
* @method getXmlSingleNode
* @param {Object} xmlElement Algpunkt, kust päring tehakse.
* @param {String} xPath Rada.
* @return {Object} Leitud node või null. 
*/
function getXmlSingleNode(xmlElement, xPath) {
    var xmlDom;
    if (xmlElement.ownerDocument) {
        xmlDom = xmlElement.ownerDocument;
    }
    else {
        xmlDom = xmlElement;
    }
    // IE test tagapool
    if (xmlDom.evaluate) {
        var xpathResult = xmlDom.evaluate(xPath, xmlElement, NSResolver, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
        if (xpathResult.singleNodeValue) {
            return xpathResult.singleNodeValue;
        }
        else {
            return null;
        }
    } else if ('selectSingleNode' in xmlDom) {
        return xmlElement.selectSingleNode(xPath);
    } else {
        return null;
    }
} // getXmlSingleNode


/**
* Teeb xPath päringu ja vastab ühe node'i väärtuse.
*
* @method getXmlSingleNodeValue
* @param {Object} xmlElement Algpunkt, kust päring tehakse.
* @param {String} xPath Rada.
* @return {String} Väärtus stringina või tühi string.
*/
function getXmlSingleNodeValue(xmlElement, xPath) {
    var xmlNode = getXmlSingleNode(xmlElement, xPath);
    if (xmlNode) {
        return getXmlNodeValue(xmlNode);
    } else {
        return "";
    }
} // getXmlSingleNodeValue


/**
* Tagastab sisendnode'i väärtuse.
*
* @method getXmlNodeValue
* @param {Object} xmlElement Sisendnode.
* @return {String} Väärtus stringina.
*/
function getXmlNodeValue(xmlElement) {
    if ('textContent' in xmlElement) {
        return xmlElement.textContent;
    } else {
        return xmlElement.text;
    }
} // getXmlNodeValue


/**
* Omistab sisendnode'ile etteantud väärtuse.
*
* @method setXmlNodeValue
* @param {Object} xmlElement Sisendnode, millele väärtust omistatakse.
* @param {String} tekst Väärtus, mis node'le omistatakse.
*/
function setXmlNodeValue(xmlElement, tekst) {
    if ('textContent' in xmlElement) {
        xmlElement.textContent = tekst;
    } else {
        xmlElement.text = tekst;
    }
} // setXmlNodeValue


/**
* xPathi päringu esimesele vastele omistatakse argumendi thisText väärtus. 
*
* @method setXmlSingleNodeValue
* @param {Object} xmlElement Sisendnode.
* @param {String} xPath Rada.
* @param {String} thisText Väärtus, mis node'ile omistatakse.
*/
function setXmlSingleNodeValue(xmlElement, xPath, thisText) {
    var xmlNode = getXmlSingleNode(xmlElement, xPath);
    if (xmlNode) {
        setXmlNodeValue(xmlNode, thisText);
    }
} // setXmlSingleNodeValue


/**
* Loob uue elemendi.
*
* @method createMyNSElement
* @param {Object} xmlDom Element, kes saab endale uue lapse.
* @param {String} qn Loodava elemendi nimi.
* @param {String} uri Nimeruum.
* @return {Object} Uus element või null.
*/
function createMyNSElement(xmlDom, qn, uri) {
    if (xmlDom.createElementNS) { // IE korral on, aga ainult HTML jaoks
        return xmlDom.createElementNS(uri, qn);
    } else if ('createNode' in xmlDom) { // MSXML, IE
        return xmlDom.createNode(NODE_ELEMENT, qn, uri);
    }
    return null;
} // createMyNSElement


/**
* Loob elemendile uue atribuudi.
*
* @method createMyNSAttribute
* @param {Object} xmlDom Element, millele luuakse atribuut.
* @param {String} qn Loodava atribuudi nimi.
* @param {String} uri Nimeruum.
* @return {Object} Uus atribuut või null.
*/
function createMyNSAttribute(xmlDom, qn, uri) {
    if (xmlDom.createAttributeNS) {
        return oEditDOM.createAttributeNS(uri, qn);
    } else if ('createNode' in xmlDom) { // MSXML, IE
        return xmlDom.createNode(NODE_ATTRIBUTE, qn, uri);
    }
    return null;
} // createMyNSAttribute


/**
* xmlElement.attributes.setNamedItem(attNode); Kas see tähendab atribuudi loomist? 
*
* @method setMyNSNamedItem
* @param {Object} xmlElement Element, millele liidetakse 
* @param {Object} attNode
*/
function setMyNSNamedItem(xmlElement, attNode) {
    if (xmlElement.attributes.setNamedItemNS) {
        xmlElement.attributes.setNamedItemNS(attNode);
    } else if ('setNamedItem' in xmlElement.attributes) {
        xmlElement.attributes.setNamedItem(attNode);
    }
} // setMyNSNamedItem


/**
* Loob elemendile atribuudi või kirjutab vanale uue väärtuse.
* @example
	setMyNSAttribute(selectedNode, DICURI, DICPR + ":maut", sUsrName); 
	setMyNSAttribute(selectedNode, DICURI, DICPR + ":maeg", GetXSDDateTime(new Date()));
* @method setMyNSAttribute
* @param {Object} xmlElement Element, millele tehakse atribuut.
* @param {String} uri Nimeruum.
* @param {String} qn Atribuudi nimi.
* @param {String} val Väärtus.
*/
function setMyNSAttribute(xmlElement, uri, qn, val) {

    var boundNode = createMyNSAttribute(xmlElement.ownerDocument, qn, uri);
    setXmlNodeValue(boundNode, val);
    setMyNSNamedItem(xmlElement, boundNode);
    //        selectedNode.setAttributeNS(DICURI, DICPR + ":maut", sUsrName);
    //        selectedNode.setAttributeNS(DICURI, DICPR + ":maeg", GetXSDDateTime(new Date()));
} // setMyNSAttribute


/**
* Võtab stringi algusest ja lõpust tühikud ära.
*
* @method setMyNSAttribute
* @param {String} mystring 
* @return {String} mystring.replace(/^\s+|\s+$/g, "");
*/
function jsTrim(mystring) {
    var r = /^\s+|\s+$/g;
    return mystring.replace(r, "");
} // jsTrim


/**
* Korrutab sisendstringi n korda.
*
* @method jsStrRepeat
* @param {String} n Niimitu korda kordab stringi s.
* @param {String} s Sisendstring, mida korrutatakse n korda.
* @return {String} n korda korrutatud s-i.
*/
function jsStrRepeat(n, s) { 
	var r = ""; 
	for (var a = 0; a < n; a++) {
		r += s; 
		}
	return r; 
	}


/**
* Väljastab esimese positsiooni järjendis, kus asub val.
*
* @method jsArrIndex
* @param {Array} arr Stringide järjend.
* @param {String} val Otsitav string.
* @return {Int} Mitmendal positsioonil oli otsitav string. Kui ei leia, siis -1.
*/
function jsArrIndex(arr, val) {
    for (var ix = 0; ix < arr.length; ix++) {
        if (arr[ix] == val) {
            return ix;
        }
    }
    return -1;
} // jsArrIndex


/**
* Teeb stringist booleani. True, yes, 1 lähevad true'ks. False, no, 0, tühi string, null lähevad false'ks.
*
* @method jsStringToBoolean
* @param {String} string
* @return {Boolean} true või false.
*/
function jsStringToBoolean(string) {
    switch (string.toLowerCase()) {
        case "true": case "yes": case "1": return true;
        case "false": case "no": case "0": case "": case null: return false;
        default: return Boolean(string);
    }
} // jsStringToBoolean


/**
* Võrdleb sisendstringe, arvestab tõstutundlikkust.
*
* @method jsStrComp
* @param {String} s1 Sisendstring 1.
* @param {String} s2 Sisendstring 2. 
* @param {Int} cs Case sensitive. Kui 1, siis case insensitive. 
* @return {Int}  0 : It string matches 100% <br/>
*  1 : no match, and the parameter value comes before the string object's value in the locale sort order<br/>
*   -1 : no match, and the parameter value comes after the string object's value in the locale sort order
*/
function jsStrComp(s1, s2, cs) {
    var str1, str2;
    if (cs == 1) {
        str1 = s1.toLowerCase();
        str2 = s2.toLowerCase();
    }
    else {
        str1 = s1;
        str2 = s2;
    }
    //    return ((str1 == str2) ? 0 : ((str1 > str2) ? 1 : -1));
    // nt Türgi-eesti sõnastiku korral mis teeb??
    if (msLang != "et") {
        // alert("localeCompare:\n" + msLang);
    }
    return str1.localeCompare(str2);
} // jsStrComp


/**
* Unikaalse nime koostamiseks tõstutundetule keskkonnale (näiteks css). Koolonid muutuvad sidekriipsudeks, tähed teisendatakse numbrilisteks koodideks. 
*
* @method unName 
* @param {String} inpStr Sisendstring
* @return {String} 
*/
function unName(inpStr) {
    var unStr, i;
    unStr = inpStr.replace(/:/, "-");
    for (i = 0; i < inpStr.length; i++) {
        unStr += '_' + inpStr.charCodeAt(i);
    }
    return unStr;
} // unName


/**
* Teisendab numbri 16-süsteemi.
*
* @method hex
* @param {Int} nmb Sisendnumber.
* @param {Boolean} uCase TRUE puhul on väljundis suured tähed.
* @return {String} 16-süsteemis väljund.
*/
function hex(nmb, uCase) {
    var hexNmb;
    if (nmb > 0)
        hexNmb = nmb.toString(16);
    else
        hexNmb = (nmb + 0x100000000).toString(16);
    if (uCase)
        return hexNmb.toUpperCase();
    else
        return hexNmb;
} // hex


/**
* Vahetab sisendstringis ampersandid (&) &amp;-ide vastu.
* XML-is ei tohi peale nende &amp; eriti midagi olla. Näiteks &amp;br; (leia parem näitelause).
* 
* @method toXmlString
* @param {String} tekst Sisendiks po tekst.
* @return {String} Teisendatud tekst.
*/
function toXmlString(tekst) { // sisendiks po tekst
    return tekst.replace(/&/g, "&amp;");
} // toXmlString


/**
* Teisendab numbrid rooma numbriteks.
*
* @method romanize
* @param {Int} num Number.
* @return {String} Rooma number.
*/
function romanize(num) {
    var lookup = { M: 1000, CM: 900, D: 500, CD: 400, C: 100, XC: 90, L: 50, XL: 40, X: 10, IX: 9, V: 5, IV: 4, I: 1 },
      roman = '',
      i;
    for (i in lookup) {
        while (num >= lookup[i]) {
            roman += i;
            num -= lookup[i];
        }
    }
    return roman;
} // romanize

/**
* Teisendab rooma numbri numbriks. 
*
* @method deromanize
* @param {String} romanIn Rooma number.
* @return {Int} Number.
*/
function deromanize(romanIn) {
    var roman = romanIn.toUpperCase(),
      lookup = { I: 1, V: 5, X: 10, L: 50, C: 100, D: 500, M: 1000 },
      arabic = 0,
      i = roman.length;
    while (i--) {
        if (lookup[roman[i]] < lookup[roman[i + 1]])
            arabic -= lookup[roman[i]];
        else
            arabic += lookup[roman[i]];
    }
    return arabic;
} // deromanize


/**
* Teisendab entity'd html-iks. Näiteks replace(/(&br;)/g, "<br/>"); ja palju muud.
*
* @method entitiesToHtml
* @param {String} tekst Sisendstring.
* @return {String} HTML-ilaadsem string.
*/
function entitiesToHtml(tekst) {
    var rets = tekst;

    var erisus = "color:red;";

    rets = rets.replace(/(&suba;(.+?)&subl;)/g, "<sub style='" + erisus + "'>$2</sub>");
    rets = rets.replace(/(&supa;(.+?)&supl;)/g, "<sup style='" + erisus + "'>$2</sup>");
    rets = rets.replace(/(&la;(.+?)&ll;)/g, "<u style='" + erisus + "'>$2</u>");
    rets = rets.replace(/(&capa;(.+?)&capl;)/g, "<i style='" + erisus + "font-weight:bold;font-variant:small-caps;'>$2</i>");
    rets = rets.replace(/(&br;)/g, "<br/>");

    rets = rets.replace(/(&ba;(.+?)&bl;)/g, "<b style='" + erisus + "'>$2</b>");
    //    if (paksud.indexOf(';etvw_' + ln + ';') > -1) { //paksus mitte-paks
    //        rets = rets.replace(/(&ba;(.+?)&bl;)/g, "<b style='font-weight:normal;'>$2</b>");
    //    }
    //    else {
    //        rets = rets.replace(/(&ba;(.+?)&bl;)/g, "<b style='font-weight:bold;'>$2</b>");
    //    }

    rets = rets.replace(/(&ema;(.+?)&eml;)/g, "<i style='" + erisus + "'>$2</i>");
    //     if (itad.indexOf(';etvw_' + ln + ';') > -1) { //kursiivis pöörata kursiiv tagasi
    //        rets = rets.replace(/(&ema;(.+?)&eml;)/g, "<i style='font-style:normal;'>$2</i>");
    //    }
    //    else {
    //        rets = rets.replace(/(&ema;(.+?)&eml;)/g, "$2".italics());
    //    }

    // muutujad (entities)
    // rets = rets.replace(/(&(\w+?);)/g, "$2".italics());
    rets = rets.replace(/(&(ehk|Hrl|hrl|ja|jne|jt|ka|nt|puudub|v|vm|vms|vrd|vt|напр\.|и др\.|и т\. п\.|г\.);)/g, "<i style='" + erisus + "'>$2</i>");

    //    // 0x1D100 - 0x1D126
    //    var muss = '';
    //    for (i = 0xDD00; i <= 0xDD26; i++) {
    //        muss += String.fromCharCode(0xD834, i);
    //    }
    //    rets = rets.replace(/([" + muss + "])/g, "<span style='" + erisus + "font-family:symbola;font-size:x-large'>$1</span>");

    //    rets = rets.replace(/&gclef;/g, "<span style='font-family:symbola;font-size:x-large'>&#xA0;&#xA0;&#xA0;&#x1D11E;</span>");
    //    rets = rets.replace(/&gclefottavaalta;/g, "<span style='font-family:symbola;font-size:x-large'>&#x1D11F;</span>");
    //    rets = rets.replace(/&gclefottavabassa;/g, "<span style='font-family:symbola;font-size:x-large'>&#x1D120;</span>");
    //    rets = rets.replace(/&cclef;/g, "<span style='font-family:symbola;font-size:x-large'>&#xA0;&#xA0;&#xA0;&#x1D121;</span>");
    //    rets = rets.replace(/&fclef;/g, "<span style='font-family:symbola;font-size:x-large'>&#xA0;&#xA0;&#xA0;&#x1D122;</span>");
    //    rets = rets.replace(/&fclefottavaalta;/g, "<span style='font-family:symbola;font-size:x-large'>&#x1D123;</span>");
    //    rets = rets.replace(/&fclefottavabassa;/g, "<span style='font-family:symbola;font-size:x-large'>&#x1D124;</span>");
    //    rets = rets.replace(/&drumclef1;/g, "<span style='font-family:symbola;font-size:x-large'>&#x1D125;</span>");
    //    rets = rets.replace(/&drumclef2;/g, "<span style='font-family:symbola;font-size:x-large'>&#x1D126;</span>");
    //    rets = rets.replace(/&brevis;/g, "<span style='font-family:symbola;font-size:x-large'>&#x1D1B8;</span>");

    //    rets = rets.replace(/&fermata;/g, "<span style='font-family:symbola;font-size:x-large'>&#x1D110;</span>");
    //    rets = rets.replace(/&segno;/g, "<span style='font-family:symbola;font-size:x-large'>&#x1D10B;</span>");

    rets = rets.replace(/(&\w+?;)/g, "");

    return rets;

} // entitiesToHtml


