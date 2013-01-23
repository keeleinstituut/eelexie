
var specCh = "\\|(){}[]-+.?*^$";
var PD = "\uE001";
var JR = "\uE001";
var REG_LETT_LA = "aàáâãåāăąǎǡǻȁȃḁạảấầẩẫậắằẳẵặbƃƅḃḅḇcçćĉċčƈḉdðďđƌḋḍḏḑḓeèéêëēĕėęěȅȇḕḗḙḛḝẹẻẽếềểễệfƒḟgĝğġģǥǧǵḡhĥħḣḥḧḩḫiìíîïĩīĭįıǐȉȋḭḯỉịjĵkķƙǩḱḳḵlĺļľŀłḷḹḻḽmḿṁṃnñńņňŋṅṇṉṋoòóôøōŏőơǒǫǭǿȍȏṑṓọỏốồổỗộớờởỡợpƥṕṗqrŕŗřȑȓṙṛṝṟsśŝşṡṣṥṩšṧzźżƶẑẓẕžtţťŧƭṫṭṯṱuùúûũūŭůűųưǔȕȗṳṵṷṹṻụủứừửữựvṽṿwŵẁẃẅẇẉõṍṏäǟöüǖǘǚǜxẋẍyýŷÿƴẏỳỵỷỹ";
var REG_LETT_RU = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя";

// FSO konstandid
var ForReading = 1; // 	Open a file for reading only. You can't write to this file.
var ForWriting = 2; // 	Open a file for writing. If a file with the same name exists, its previous contents are overwritten.
var ForAppending = 8; // Open a file and write to the end of the file.
var TristateUseDefault = -2; // Opens the file using the system default.
var TristateTrue = -1; // 	Opens the file as Unicode.
var TristateFalse = 0; // Opens the file as ASCII.


//-----------------------------------------------------------------------------------
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


//-----------------------------------------------------------------------------------
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


//-----------------------------------------------------------------------------------
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


//-----------------------------------------------------------------------------------
function NSResolver(nsPrefix) {
    if (nsPrefix == SDPR) {
        return SDURI;
    } else if (nsPrefix == NS_XS_PR) {
        return NS_XS;
    } else if (nsPrefix == "xml") {
        return NS_XML;
    } else if (nsPrefix == NS_XSL_PR) {
        return NS_XSL;
    }
    return null;
} // NSResolver


//-----------------------------------------------------------------------------------
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


//-----------------------------------------------------------------------------------
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


//-----------------------------------------------------------------------------------
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


//-----------------------------------------------------------------------------------
function getXmlSingleNodeValue(xmlElement, xPath) {
    var xmlNode = getXmlSingleNode(xmlElement, xPath);
    if (xmlNode) {
        return getXmlNodeValue(xmlNode);
    } else {
        return "";
    }
} // getXmlSingleNodeValue


//-----------------------------------------------------------------------------------
function getXmlNodeValue(xmlElement) {
    if ('textContent' in xmlElement) {
        return xmlElement.textContent;
    } else {
        return xmlElement.text;
    }
} // getXmlNodeValue


//-----------------------------------------------------------------------------------
function setXmlNodeValue(xmlElement, tekst) {
    if ('textContent' in xmlElement) {
        xmlElement.textContent = tekst;
    } else {
        xmlElement.text = tekst;
    }
} // setXmlNodeValue


//-----------------------------------------------------------------------------------
function setXmlSingleNodeValue(xmlElement, xPath, thisText) {
    var xmlNode = getXmlSingleNode(xmlElement, xPath);
    if (xmlNode) {
        setXmlNodeValue(xmlNode, thisText);
    }
} // setXmlSingleNodeValue


//-----------------------------------------------------------------------------------
function createMyNSElement(xmlDom, qn, uri) {
    if (xmlDom.createElementNS) { // IE korral on, aga ainult HTML jaoks
        return xmlDom.createElementNS(uri, qn);
    } else if ('createNode' in xmlDom) { // MSXML, IE
        return xmlDom.createNode(NODE_ELEMENT, qn, uri);
    }
    return null;
} // createMyNSElement


//-----------------------------------------------------------------------------------
function createMyNSAttribute(xmlDom, qn, uri) {
    if (xmlDom.createAttributeNS) {
        return oEditDOM.createAttributeNS(uri, qn);
    } else if ('createNode' in xmlDom) { // MSXML, IE
        return xmlDom.createNode(NODE_ATTRIBUTE, qn, uri);
    }
    return null;
} // createMyNSAttribute


//-----------------------------------------------------------------------------------
function setMyNSNamedItem(xmlElement, attNode) {
    if (xmlElement.attributes.setNamedItemNS) {
        xmlElement.attributes.setNamedItemNS(attNode);
    } else if ('setNamedItem' in xmlElement.attributes) {
        xmlElement.attributes.setNamedItem(attNode);
    }
} // setMyNSNamedItem


//-----------------------------------------------------------------------------------
function setMyNSAttribute(xmlElement, uri, qn, val) {

    var boundNode = createMyNSAttribute(xmlElement.ownerDocument, qn, uri);
    setXmlNodeValue(boundNode, val);
    setMyNSNamedItem(xmlElement, boundNode);
    //        selectedNode.setAttributeNS(DICURI, DICPR + ":maut", sUsrName);
    //        selectedNode.setAttributeNS(DICURI, DICPR + ":maeg", GetXSDDateTime(new Date()));
} // setMyNSAttribute


//-----------------------------------------------------------------------------------
function jsTrim(mystring) {
    var r = /^\s+|\s+$/g;
    return mystring.replace(r, "");
} // jsTrim


//-----------------------------------------------------------------------------------
function jsStrRepeat(n, s) { var r = ""; for (var a = 0; a < n; a++) r += s; return r; }


//-----------------------------------------------------------------------------------
function jsArrIndex(arr, val) {
    for (var ix = 0; ix < arr.length; ix++) {
        if (arr[ix] == val) {
            return ix;
        }
    }
    return -1;
} // jsArrIndex


//-----------------------------------------------------------------------------------
function jsStringToBoolean(string) {
    switch (string.toLowerCase()) {
        case "true": case "yes": case "1": return true;
        case "false": case "no": case "0": case "": case null: return false;
        default: return Boolean(string);
    }
} // jsStringToBoolean


//-----------------------------------------------------------------------------------
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


//-----------------------------------------------------------------------------------
function unName(inpStr) {
    var unStr, i;
    unStr = inpStr.replace(/:/, "-");
    for (i = 0; i < inpStr.length; i++) {
        unStr += '_' + inpStr.charCodeAt(i);
    }
    return unStr;
} // unName


//-----------------------------------------------------------------------------------
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


//-----------------------------------------------------------------------------------
function toXmlString(tekst) { // sisendiks po tekst
    return tekst.replace(/&/g, "&amp;");
} // toXmlString


//-----------------------------------------------------------------------------------
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


//-----------------------------------------------------------------------------------
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


//-----------------------------------------------------------------------------------
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


//-----------------------------------------------------------------------------------
function cancelThisEvent(event) {
    if ('cancelable' in event) { // all browsers except in Internet Explorer before version 9
        // in Firefox, the cancelable property always returns true,
        // so the cancelable state of the event cannot be determined
        event.preventDefault(); // all browsers except in Internet Explorer before version 9
    }
    else {
        event.returnValue = false;
    }
    return false;
} // cancelThisEvent
