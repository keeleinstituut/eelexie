/**
* tools.js
* IE verstiooni oma
*
* @class tools
*/

/**
* Hoiab highlight'i ajal ajutist värvi.
* 
* @property str_TDBGCol
* @type {String}
*/
var str_TDBGCol;
var xmlHTTPAsync, myAsync;

// readyState Property (IXMLHTTPRequest)
var XMLHTTP_UNINITIALIZED = 0;
var XMLHTTP_LOADING = 1;
var XMLHTTP_LOADED = 2;
var XMLHTTP_INTERACTIVE = 3;
var XMLHTTP_COMPLETED = 4;



/**
* Tagasatb algus ja lõpu wild characteridest vabastatud otsitava.
*
* @method getSrPn2
* @param {String} algPtrn String, mida puhastada vaja.
* @param {String} mode Päringu tüüp - kas "MySql" või "XML".
* @returns {String} Puhastatud string.
*/
function getSrPn2(algPtrn, mode) {
    //tulemuseks newPtrn - srchPtrn (algus ja lõputärnidest vabastatud otsitav)
    //mode - "MySql", "XML"
    var i, ptrn, newPtrn;
    if ((jsLeft(algPtrn, 1) == "*")) {
        ptrn = jsMid(algPtrn, 1);
        newPtrn = "";
    } else {
        ptrn = algPtrn;
        newPtrn = "^";
    }
    for (i = 0; i < ptrn.length; i++) {
        if ((jsMid(ptrn, i, 1) == "\\")) {
            if ((i < ptrn.length - 1)) {
                if ((jsMid(ptrn, i + 1, 1) == "\\")) {
                    if ((mode == "MySql")) {
                        newPtrn = newPtrn + "\\\\\\\\";
                    } else {
                        newPtrn = newPtrn + "\\\\";
                    }
                    i = i + 1;
                } else if ((jsMid(ptrn, i + 1, 1) == "*")) {
                    if ((mode == "MySql")) {
                        newPtrn = newPtrn + "\\\\*";
                    } else {
                        newPtrn = newPtrn + "\\*";
                    }
                    i = i + 1;
                } else if ((jsMid(ptrn, i + 1, 1) == "?")) {
                    if ((mode == "MySql")) {
                        newPtrn = newPtrn + "\\\\?";
                    } else {
                        newPtrn = newPtrn + "\\?";
                    }
                    i = i + 1;
                } else if ((specCh.indexOf(jsMid(ptrn, i + 1, 1)) > -1)) {
                    if ((mode == "MySql")) {
                        newPtrn = newPtrn + "\\\\" + jsMid(ptrn, i + 1, 1);
                    } else {
                        newPtrn = newPtrn + "\\" + jsMid(ptrn, i + 1, 1);
                    }
                    i = i + 1;
                } else {
                    if ((mode == "MySql")) {
                        //                        newPtrn = newPtrn + "\\\\\\\\";
                    } else {
                        //                        newPtrn = newPtrn + "\\\\";
                    }
                }
            } else {
                if ((mode == "MySql")) {
                    //                    newPtrn = newPtrn + "\\\\\\\\";
                } else {
                    //                    newPtrn = newPtrn + "\\\\";
                }
            }
            if ((i == ptrn.length - 1)) {
                newPtrn = newPtrn + "$";
            }
        } else if ((specCh.indexOf(jsMid(ptrn, i, 1)) > -1)) {
            if ((jsMid(ptrn, i, 1) == "*")) {
                if ((i > 0 && i < ptrn.length - 1)) {
                    newPtrn = newPtrn + ".*";
                }
            } else if ((jsMid(ptrn, i, 1) == "?")) {
                if ((mode == "MySql")) {
                    //MySQL REGEXP otsib baidi, mitte tähe kaupa !!!!!!!!!!!!!!;
                    //                newPtrn = newPtrn + "(.|Š|Ž|Õ|Ä|Ö|Ü|š|ž|õ|ä|ö|ü)"
                    //                newPtrn = newPtrn + "([[:alpha:]]|Š|Ž|Õ|Ä|Ö|Ü|š|ž|õ|ä|ö|ü)"
                    //{1,2} - üks täpitäht v kaks tavalist tähte;
                    newPtrn = newPtrn + ".{1,2}";
                } else {
                    newPtrn = newPtrn + ".";
                }
                if ((i == ptrn.length - 1)) {
                    newPtrn = newPtrn + "$";
                }
            } else {
                if ((mode == "MySql")) {
                    newPtrn = newPtrn + "\\";
                }
                newPtrn = newPtrn + "\\" + jsMid(ptrn, i, 1);
                if ((i == ptrn.length - 1)) {
                    newPtrn = newPtrn + "$";
                }
            }
        } else {
            newPtrn = newPtrn + jsMid(ptrn, i, 1);
            if ((i == ptrn.length - 1)) {
                newPtrn = newPtrn + "$";
            }
        }
    }
    return newPtrn;
} //getSrPn2


/**
* Kontrollib, kas sisendstringis on sümboleid, mis ei ole tähestikus.
*
* @method CheckForSymbols
* @param {String} sQryText String, millest otsitakse.
* @param {String} voivadOlla Lisaks lubatud märgid.
* @returns {Boolean} true, kui leiti.
*/
function CheckForSymbols(sQryText, voivadOlla) {
    var tahed = msAlpha + voivadOlla;
    for (var i = 0; i < sQryText.length; i++) {
        if (tahed.indexOf(sQryText.charAt(i)) < 0) {
            return true;
        }
    }
    return false;
} //CheckForSymbols


/**
* Higlight'ib asju, kui hiirega neile peale minna. Kasutab muutujat str_TDBGCol. 
*
* @method SwitchTD
* @param {Object} obj_evnt  
* @returns {Boolean} true, kui leiti.
*/
function SwitchTD(obj_evnt) {
    var obj_tdelem = obj_evnt.srcElement.parentElement;
    switch (obj_evnt.type) {
        case "mouseover":
            str_TDBGCol = obj_tdelem.style.backgroundColor;
            obj_tdelem.style.borderColor = "Black";
            obj_tdelem.style.backgroundColor = "Background";
            break;
        case "mouseout":
            obj_tdelem.style.borderColor = str_TDBGCol;
            obj_tdelem.style.backgroundColor = str_TDBGCol;
            break;
    }
} //SwitchTD


/**
* Tagastab MSXML dokumendi objekti.
*
* @method CreateMSXMLDocumentObject
* @returns {Object} null, kui ei õnnestu.
*/
function CreateMSXMLDocumentObject() {
    if (typeof (ActiveXObject) != "undefined") {
        //        var progIDs = [
        //                        "Msxml2.DOMDocument.6.0",
        //                        "Msxml2.DOMDocument.5.0",
        //                        "Msxml2.DOMDocument.4.0",
        //                        "Msxml2.DOMDocument.3.0",
        //                        "MSXML2.DOMDocument",
        //                        "MSXML.DOMDocument"
        //                      ];

        var progIDs = [
                        "Msxml2.DOMDocument.6.0",
                        "Msxml2.DOMDocument.3.0",
                        "MSXML2.DOMDocument",
                        "MSXML.DOMDocument"
                      ];
        for (var i = 0; i < progIDs.length; i++) {
            try {
                return new ActiveXObject(progIDs[i]);
            } catch (e) { };
        }
    }
    return null;
} // CreateMSXMLDocumentObject


/**
* Teisendab XML stringi objektiks.
*
* @method BuildXMLFromString
* @param {String} text
* @returns {Object} MSXML dokumendi objekt. null, kui ei õnnestu. 
*/
function BuildXMLFromString(text) {
    var xmlDoc = null;
    if (window.DOMParser) { // all browsers, except IE before version 9
        var parser = new DOMParser();
        try {
            xmlDoc = parser.parseFromString(text, "text/xml");
        } catch (e) {
            // if text is not well-formed, 
            // it raises an exception in IE from version 9
            alert("XML parsing error ('DOMParser()'.'parseFromString').");
            return null;
        }
    }
    else {  // Internet Explorer before version 9
        xmlDoc = CreateMSXMLDocumentObject();
        if (!xmlDoc) {
            alert("Cannot create MSXMLDocument object");
            return null;
        }
        xmlDoc.loadXML(text);
    }

    var errorMsg = null;
    if (xmlDoc.parseError && xmlDoc.parseError.errorCode != 0) {
        errorMsg = "XML Parsing Error: " + xmlDoc.parseError.reason
                          + " at line " + xmlDoc.parseError.line
                          + " at position " + xmlDoc.parseError.linepos;
    }
    else {
        if (xmlDoc.documentElement) {
            if (xmlDoc.documentElement.nodeName == "parsererror") {
                errorMsg = xmlDoc.documentElement.childNodes[0].nodeValue;
            }
        }
        else {
            errorMsg = "XML Parsing Error!";
        }
    }

    if (errorMsg) {
        alert(errorMsg + "\n\n" + text);
        return null;
    }

    return xmlDoc;
} // BuildXMLFromString



/**
* Teeb (Ajax) päringust xml objekti.
*
* @method ParseHTTPResponse
* @param {Object} myRequest 
* @returns {Object} MSXML dokumendi objekt. null, kui ei õnnestu. 
*/
function ParseHTTPResponse(myRequest) {
    var xmlDoc = myRequest.responseXML;

    // if responseXML is not valid, try to create the XML document from the responseText property
    if (!xmlDoc || !xmlDoc.documentElement) {
        xmlDoc = BuildXMLFromString(myRequest.responseText);
    }

    // if there was an error while parsing the XML document
    var errorMsg = null;
    if (xmlDoc) {
        if (xmlDoc.parseError && xmlDoc.parseError.errorCode != 0) {
            errorMsg = "XML Parsing Error: " + xmlDoc.parseError.reason
                  + " at line " + xmlDoc.parseError.line
                  + " at position " + xmlDoc.parseError.linepos;
        }
        else {
            if (xmlDoc.documentElement) {
                if (xmlDoc.documentElement.nodeName == "parsererror") {
                    errorMsg = xmlDoc.documentElement.childNodes[0].nodeValue;
                }
            }
        }
    }
    if (errorMsg) {
        alert(errorMsg);
        return null;
    }

    // ok, the XML document is valid
    return xmlDoc;
} // ParseHTTPResponse


/**
* InitDomDoc. Luuakse uus xmldomdoc.
*
* @method IDD
* @param {String} domsrc Allika tüüp. "string", "file", "".
* @param {String} domstr Viide allikale või allikas ise, sõltuvalt muutuja domsrc väärtusest. Kui domsrc on "", siis funktsioon loob tühja dokumendi.
* @param {Boolean} res_ext Kas lahendada välised viited.
* @param {Boolean} val_on_parse Kas laadimisel valideeritakse.
* @param {Object} domsc Skeem või null.
* @returns {Object} xmldomdoc objekt.
*/
function IDD(domsrc, domstr, res_ext, val_on_parse, domsc) {

    var tempdom = new ActiveXObject("Msxml2.DOMDocument.6.0");
    tempdom.async = false;
    tempdom.preserveWhiteSpace = false;
    tempdom.resolveExternals = res_ext;
    tempdom.validateOnParse = val_on_parse;
    if (domsc != null) {
        tempdom.schemas = domsc;
    }
    var domsta;
    switch (domsrc.toLowerCase()) {
        case "string":
            domsta = tempdom.loadXML(domstr);
            break;
        case "file":
            domsta = tempdom.load(domstr);
            break;
        case "":
            domsta = true;
            break;
    }
    return tempdom;
} // IDD


/**
* Sünkroonne cgi postituspäring.
*
* @method exCGISync
* @param {String} srvCGIFile Aadress, kuhu postitatakse.
* @param {String} cmdId Postituse sisu.
* @returns {Object} Request object.
*/
function exCGISync(srvCGIFile, cmdId) {
    var xh = getXmlHttpObject();
    if (xh == null) {
        alert("Your browser does not support XMLHttp!");
        window.status = "";
        return null;
    }
    xh.open("POST", srvCGIFile, false); //async = false
    xh.setRequestHeader("Content-Type", "text/plain; charset='utf-8';");
    xh.send(cmdId);
    return xh;
} // exCGISync


/**
* Tagastab Ajax objekti. 
*
* @method getXmlHttpObject
* @returns {Object} = new XMLHttpRequest();
*/
function getXmlHttpObject() {
    var xmlHttp = null;
    var moodus = '';
    try {
        // Firefox, Opera 8.0+, Safari, IE 7+
        xmlHttp = new XMLHttpRequest();
        moodus = 'new XMLHttpRequest()';
    }
    catch (e) {
        try {
            // Internet Explorer 6+
            xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
            moodus = 'new ActiveXObject("Msxml2.XMLHTTP")';
        }
        catch (e) {
            // IE 5.5+
            xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            moodus = 'new ActiveXObject("Microsoft.XMLHTTP")';
        }
    }
    return xmlHttp;
}



/**
* Teeb asünkroonse päringu servfuncs.cgi-st ja vastus läheb funktsiooni doHttpReadyStateChange.
*
* @method QueryResponseAsync
* @param {Object} oPrmDom XML objekt päringuga.
*/
function QueryResponseAsync(oPrmDom) {
    xmlHTTPAsync = getXmlHttpObject();
    xmlHTTPAsync.onreadystatechange = doHttpReadyStateChange;
    xmlHTTPAsync.open("POST", "srvfuncs.cgi", true);
    xmlHTTPAsync.setRequestHeader("Content-Type", "text/xml; charset='utf-8';");
    // cmd, vol, nfo, axp, exp[, q:A]
    xmlHTTPAsync.send(oPrmDom.xml);
} //QueryResponseAsync


/**
* Töötleb päringu vastust ja edastatakse funktsiooniga asyncCompleted.
*
* @method doHttpReadyStateChange
*/
function doHttpReadyStateChange() {
    if (xmlHTTPAsync.readyState == XMLHTTP_COMPLETED) {
        var oSrvRspDOM, rspNode, domsta;
        if (xmlHTTPAsync.statusText == "OK") {
            // sta, cnt, vol[, q:A|q:sr]
            oSrvRspDOM = IDD("", "", false, false, null);
            domsta = oSrvRspDOM.loadXML(xmlHTTPAsync.responseText); //responseXML: TypeName = DomDocument
            if (!domsta) {
                var pe = oSrvRspDOM.parseError;
                if (pe.errorCode != 0) {
                    ShowXMLParseError(oSrvRspDOM);
                }
                oSrvRspDOM = IDD("String", "<rsp/>", false, false, null);
                rspNode = oSrvRspDOM.documentElement.appendChild(oSrvRspDOM.createNode(NODE_ELEMENT, "appSta", ""));
                rspNode.text = "AppFailure";
            }
            else {
                rspNode = oSrvRspDOM.documentElement.appendChild(oSrvRspDOM.createNode(NODE_ELEMENT, "appSta", ""));
                rspNode.text = "AppSuccess";
            }
        }
        else
            oSrvRspDOM = IDD("String", "<rsp/>", false, false, null);

        rspNode = oSrvRspDOM.documentElement.appendChild(oSrvRspDOM.createNode(NODE_ELEMENT, "statusText", ""));
        rspNode.text = xmlHTTPAsync.statusText;
        rspNode = oSrvRspDOM.documentElement.appendChild(oSrvRspDOM.createNode(NODE_ELEMENT, "status", ""));
        rspNode.text = xmlHTTPAsync.status;

        var nRTLen = 512;
        rspNode = oSrvRspDOM.documentElement.appendChild(oSrvRspDOM.createNode(NODE_ELEMENT, "responseText", ""));
        if (xmlHTTPAsync.responseText.length > nRTLen)
            rspNode.text = xmlHTTPAsync.responseText.substr(0, nRTLen) + " ...";
        else
            rspNode.text = xmlHTTPAsync.responseText;
        oSrvRspDOM.setProperty("SelectionLanguage", "XPath");
        oSrvRspDOM.setProperty("SelectionNamespaces", sXmlNsList);

        asyncCompleted(oSrvRspDOM);
    }
} //doHttpReadyStateChange


/**
* Teeb asünkroonse päringu  antud aadressil ja vastus läheb funktsiooni myAsyncStateChanged.
*
* @method exCGIASync
* @param {String} srvCGIFile Aadress.
* @param {String} cmdId Postituse sisu.
*/
function exCGIASync(srvCGIFile, cmdId) {
    myAsync = getXmlHttpObject();
    if (myAsync != null) {
        myAsync.onreadystatechange = myAsyncStateChanged;
        myAsync.open("POST", srvCGIFile, true); // async == true
        myAsync.setRequestHeader("Content-Type", "text/plain; charset='utf-8';");
        myAsync.send(cmdId);
    }
    return;
} // exCGIASync


/**
* Kontrollib, kas päring on valmis, kui on, siis saadab selle edasi funktsioonile toCaller.
*
* @method myAsyncStateChanged
*/
function myAsyncStateChanged() {
    if (myAsync.readyState == XMLHTTP_COMPLETED) {
        toCaller(myAsync);
    }
}


/**
* Otsustab kumba väljatrükki kasutada.
*
* @method ExportToWord
* @param {String} nStartPageNumber
* @param {String} bRemoveShaded
* @param {String} sWordFileName
* @param {String} checkSpellingAndGrammar
* @param {String} oPrintXSL
* @param {String} sCSS
* @param {String} oErrDisp
* @param {String} srNode
* @returns {Int} erinevad
*/
function ExportToWord(nStartPageNumber,
                        bRemoveShaded,
                        sWordFileName,
                        checkSpellingAndGrammar,
                        oPrintXSL,
                        sCSS,
                        oErrDisp,
                        srNode) {

    
    return ExportToWordS(nStartPageNumber,bRemoveShaded,sWordFileName,checkSpellingAndGrammar,oPrintXSL,sCSS,oErrDisp,srNode);
    try{
      //return ExportToWordS(nStartPageNumber,bRemoveShaded,sWordFileName,checkSpellingAndGrammar,oPrintXSL,sCSS,oErrDisp,srNode);
    }catch(err){
        alert("Viga trükkimisel: Kontrolli IE sätteid.");
        
        //if(err.number == -2146827859){
        //    return ExportToWordNS(nStartPageNumber,bRemoveShaded,sWordFileName,checkSpellingAndGrammar,oPrintXSL,sCSS,oErrDisp,srNode);
        //}else{
        //    alert("Trüki viga: "+err.number+"\n message: "+err.message);
        //}
    }
    //mingi viga hoopis vastata
    return 0;
} //ExportToWordNS

/**
* Salvestab väljatrüki faili.
*
* @method ExportToWordNS
* @param {String} nStartPageNumber
* @param {String} bRemoveShaded
* @param {String} sWordFileName
* @param {String} checkSpellingAndGrammar
* @param {String} oPrintXSL
* @param {String} sCSS
* @param {String} oErrDisp
* @param {String} srNode
* @returns {Int} 0
*/
function ExportToWordNS(nStartPageNumber,
                        bRemoveShaded,
                        sWordFileName,
                        checkSpellingAndGrammar,
                        oPrintXSL,
                        sCSS,
                        oErrDisp,
                        srNode) {


    window.status = "Streamita ...";
    var oXSL = oPrintXSL.cloneNode(true);

    oXSL.documentElement.selectSingleNode(NS_XSL_PR + ":variable[@name = 'printing']").text = "1";
    if (bRemoveShaded) {
        oXSL.documentElement.selectSingleNode(NS_XSL_PR + ":variable[@name = 'showShaded']").text = "0";
    }

    var tekst = "<html>" +
		            "\r\n<head>" +
			            "\r\n<META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=utf-8'>" +
			            "\r\n<style>\r\n" +
			                sCSS +
			            "</style>" +
		            "\r\n</head>\r\n" +
		            srNode.transformNode(oXSL) +
	            "\r\n</html>";

   window.open("data:application/octet-stream," + encodeURIComponent(tekst));

//window.open("data:application/octet-stream;filename=file.doc," + encodeURIComponent(tekst), "file.doc");

    return 0;
} //ExportToWordNS

/**
* Vastutab Wordi trükkimise eest. (ActiveXObject("ADODB.Stream");)
*
* @method ExportToWordS
* @param {String} nStartPageNumber
* @param {String} bRemoveShaded
* @param {String} sWordFileName
* @param {String} checkSpellingAndGrammar
* @param {String} oPrintXSL
* @param {String} sCSS
* @param {String} oErrDisp
* @param {String} srNode
* @returns {Int} erinevad
*/
function ExportToWordS(nStartPageNumber,
                        bRemoveShaded,
                        sWordFileName,
                        checkSpellingAndGrammar,
                        oPrintXSL,
                        sCSS,
                        oErrDisp,
                        srNode) {


    // 'sWordFileName' siin üldse ei kasutata ...

    window.status = "Preparing XSL ...";
    var oXSL = oPrintXSL.cloneNode(true);

    oXSL.documentElement.selectSingleNode(NS_XSL_PR + ":variable[@name = 'printing']").text = "1";
    if (bRemoveShaded) {
        oXSL.documentElement.selectSingleNode(NS_XSL_PR + ":variable[@name = 'showShaded']").text = "0";
    }

    //    window.status = "Accessing query results ...";
    //    var usrUnName = "", i;
    //    for (i = 0; i < sUsrName.length; i++) {
    //        if (i > 0)
    //            usrUnName += '_';
    //        usrUnName += sUsrName.charCodeAt(i);
    //    }
    //    var srvDoc = IDD("File", "temp/printDOM_" + usrUnName + ".xml", false, false, null);
    //    var xslIndented = IDD("File", "xsl/tools/indented_copy.xsl", false, false, null);
    //    srvDoc.transformNodeToObject(xslIndented, srvDoc);

    //    srvDoc.setProperty("SelectionLanguage", "XPath");
    //    srvDoc.setProperty("SelectionNamespaces", "xmlns:" + DICPR + "='" + DICURI + "'");


    //    var dicConfDom, cfgElem, viewFont, wordFontSize;
    //    dicConfDom = IDD("File", "shsconfig_" + dic_desc + ".xml", false, false, null);
    //    cfgElem = dicConfDom.documentElement.selectSingleNode("colorsFonts/viewArea/viewFont");
    //    if (cfgElem) {
    //        viewFont = cfgElem.text;
    //    }
    //    cfgElem = dicConfDom.documentElement.selectSingleNode("colorsFonts/viewArea/wordFontSize");
    //    if (cfgElem) {
    //        wordFontSize = parseInt(cfgElem.text);
    //    }


    // Word doc sulgemine peab enne uue kirjutamist käima ...
    window.status = "Accessing Word object ...";
    var oWord = eelexSWCtl.propWordApp;
    if (oWord == null) {
        window.status = "MS Word objekt pole kättesaadav (loomine)!";
        return -1;
    }

    try {
        oWord.Visible = true;
    }
    catch (e) {
        window.status = "MS Word objekt pole kättesaadav (nähtav)!";
        return -1;
    }

    window.status = "Enumerating Word documents ...";
    var oEnum = new Enumerator(oWord.Documents);
    for (; !oEnum.atEnd(); oEnum.moveNext()) {
        if (oEnum.item().Name == 'artiklid.txt')
            oEnum.item().Close(wdDoNotSaveChanges);
    }

    window.status = "Writing local file ...";
    //    var d = new Date();
    //    var qInfoStr = lcRoot.selectSingleNode("itm[@n = 'QUERY'][@l = '" + sAppLang + "']").text + ": " +
    //        sQryInfo + "; " + outDOM.childNodes.length + " " +
    //        lcRoot.selectSingleNode("itm[@n = 'ENTRIES'][@l = '" + sAppLang + "']").text +
    //        " (" + d.toLocaleString() + ").";
    //    outDOM.setAttribute("qinfo", qInfoStr);

    // "c:/EELex/Väljatrükid/artiklid.txt"
    var fn = eelexSWCtl.propActualVtr;
    var tekst = "<html>" +
		            "\r\n<head>" +
			            "\r\n<META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=utf-8'>" +
			            "\r\n<style>\r\n" +
			                sCSS +
			            "</style>" +
		            "\r\n</head>\r\n" +
		            srNode.transformNode(oXSL) +
	            "\r\n</html>";

    var strm = new ActiveXObject("ADODB.Stream");
    strm.Type = adTypeText;
    strm.Charset = "utf-8";
    strm.LineSeparator = adCRLF;
    strm.Open();
    strm.WriteText(tekst);
    strm.SaveToFile(fn, adSaveCreateOverWrite);
    strm.Close();
    strm = null;

    //var sta;
    //try {
    //    sta = eelexSWCtl.setTempPrintFile(tekst);
    //}
    //catch (e) {
    //    window.status = "MS Word väljatrükk pole kättesaadav (.setTempPrintFile)!";
    //    return -1;
    //}
    //if (sta != 1) {
    //    window.status = "MS Word väljatrükk pole kättesaadav (.setTempPrintFile -> sta)!";
    //    return -1;
    //}

    window.status = "Loading Word document ...";
    // 2003 VBA ...
    // Open: FileName, ConfirmConversions, ReadOnly, AddToRecentFiles, PasswordDocument, PasswordTemplate, Revert,
    //          WritePasswordDocument, WritePasswordTemplate, Format, Encoding, Visible,
    //          OpenConflictDocument, OpenAndRepair , DocumentDirection, NoEncodingDialog
    var oLastQueryDoc = oWord.Documents.Open(fn, false, true, false, '', '', true, '', '', wdOpenFormatWebPages, msoEncodingUTF8, true);
    if (checkSpellingAndGrammar)
        oLastQueryDoc.Content.NoProofing = false;
    else
        oLastQueryDoc.Content.NoProofing = true;


    window.status = "Customizing Word doc ...";
    oLastQueryDoc.ActiveWindow.View.Type = wdPrintView;

    // ss_: kõik 'Indent' ja 'Alignment' tehakse XSL-is ja CSS-is
    if (!(dic_desc == "ss_")) { //  || dic_desc == "sp_"
        oLastQueryDoc.Content.ParagraphFormat.Alignment = wdAlignParagraphLeft;
    }

    //    if (viewFont) {
    //        oLastQueryDoc.Content.Font.Name = viewFont
    //    }
    //    if (wordFontSize) {
    //        oLastQueryDoc.Content.Font.Size = wordFontSize
    //    }

    try {

        switch (dic_desc) {
            case 'sp_':
                // sp_ korral UL (OL) - ide jaoks ei 'LeftIndent' sobi: (toob kõik bulletid vasakusse äärde)
                oLastQueryDoc.PageSetup.TopMargin = oWord.CentimetersToPoints(2);
                oLastQueryDoc.PageSetup.BottomMargin = oWord.CentimetersToPoints(2);
                oLastQueryDoc.PageSetup.LeftMargin = oWord.CentimetersToPoints(2);
                oLastQueryDoc.PageSetup.RightMargin = oWord.CentimetersToPoints(3);
                //                oLastQueryDoc.Content.ParagraphFormat.SpaceBefore = oWord.CentimetersToPoints(0);
                break;
            case 'ss_':
                // ss_: kõik 'Indent' ja 'Alignment' tehakse XSL-is ja CSS-is
                //                oLastQueryDoc.PageSetup.TextColumns.SetCount(2);
                //                oLastQueryDoc.PageSetup.TextColumns.EvenlySpaced = true;
                break;
            case 'ems':
                break;
            default:
                oLastQueryDoc.PageSetup.TopMargin = oWord.CentimetersToPoints(2);
                oLastQueryDoc.PageSetup.BottomMargin = oWord.CentimetersToPoints(2);
                oLastQueryDoc.PageSetup.LeftMargin = oWord.CentimetersToPoints(3);
                oLastQueryDoc.PageSetup.RightMargin = oWord.CentimetersToPoints(4);

                oLastQueryDoc.Content.ParagraphFormat.LeftIndent = oWord.CentimetersToPoints(0.5);
                oLastQueryDoc.Content.ParagraphFormat.RightIndent = oWord.CentimetersToPoints(0);
                oLastQueryDoc.Content.ParagraphFormat.FirstLineIndent = oWord.CentimetersToPoints(-0.5);
                break;
        }

        oLastQueryDoc.Content.ParagraphFormat.LineSpacingRule = wdLineSpaceSingle;
    }
    catch (e) {
        oErrDisp.innerHTML += "\n<u>ParagraphFormat (" + dic_desc + ")</u>: there was a MS Word " + e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.";
    }


    if (nStartPageNumber > -1) {
        try {
            oLastQueryDoc.Sections(1).Footers(wdHeaderFooterPrimary).PageNumbers.NumberStyle = wdPageNumberStyleArabic;
            oLastQueryDoc.Sections(1).Footers(wdHeaderFooterPrimary).PageNumbers.IncludeChapterNumber = false;
            oLastQueryDoc.Sections(1).Footers(wdHeaderFooterPrimary).PageNumbers.RestartNumberingAtSection = true;
            oLastQueryDoc.Sections(1).Footers(wdHeaderFooterPrimary).PageNumbers.StartingNumber = nStartPageNumber;
            //	Add: 1. - align, 2. - FirstPage
            oLastQueryDoc.Sections(1).Footers(wdHeaderFooterPrimary).PageNumbers.Add(wdAlignPageNumberCenter, true);
        }
        catch (e) {
            oErrDisp.innerHTML += "\n<u>PageNumbers (" + dic_desc + ")</u>: there was a MS Word " + e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.";
        }
    }


    //	ComputeStatistics: 1. - statistic, 2. - IncludeFootnotesAndEndnotes
    //	var nPageCount = oArtsDoc.ComputeStatistics(wdStatisticPages, false);

    oWord.Visible = true;
    oWord.Activate();
    oWord = null;

    return 0;

} //ExportToWordS


/**
* Teisendab täpitähed %HH kujule (näiteks õ - %F5).
*
* @method val1257
* @param {String} s Sisend.
* @returns {String} Väljund.
*/
function val1257(s) {
    var arg1257 = s;
    arg1257 = arg1257.replace(/õ/g, "%F5");
    arg1257 = arg1257.replace(/ä/g, "%E4");
    arg1257 = arg1257.replace(/ö/g, "%F6");
    arg1257 = arg1257.replace(/ü/g, "%FC");

    arg1257 = arg1257.replace(/Õ/g, "%D5");
    arg1257 = arg1257.replace(/Ä/g, "%C4");
    arg1257 = arg1257.replace(/Ö/g, "%D6");
    arg1257 = arg1257.replace(/Ü/g, "%DC");

    arg1257 = arg1257.replace(/ž/g, "%FE");
    arg1257 = arg1257.replace(/Ž/g, "%DE");
    arg1257 = arg1257.replace(/š/g, "%F0");
    arg1257 = arg1257.replace(/Š/g, "%D0");
    return arg1257;
} // val1257


/**
* Valideerib XMLi. Näitab errorit. 
*
* @method ValidateXML
* @param {Object} oXMLNode XMLi objekt.
* @param {Object} oSchemaCache Läheb IDD viimaseks väärtuseks.
* @returns {Boolean} true, kui valiidne. 
*/
function ValidateXML(oXMLNode, oSchemaCache) {
    var tempdom = IDD("", "", false, true, oSchemaCache);
    var domsta = tempdom.loadXML(oXMLNode.xml);
    if (!domsta) {
        var pe = tempdom.parseError;
        if (pe.errorCode != 0) {
            ShowXMLParseError(tempdom);
        }
        return false;
    }
    else
        return true;
} // ValidateXML


/**
* Näitab kasutajale XMLi valideerimise viga.
*
* @method ShowXMLParseError
* @param {Object} srcDOM XML objekt, kus viga oli.
*/
function ShowXMLParseError(srcDOM) {
    var sValErrTxt, pikkus = 100;
    var pe = srcDOM.parseError;
    var pestr = FILE_WORD + ":\t" + pe.url + "\n" +
					ERROR_WORD + "\t0x" + hex(pe.errorCode, true) + " (" + pe.errorCode + "): " + pe.reason + "\n" +
					LINE_WORD + "\t" + pe.line + ", pos " + pe.linepos + " (filepos " + pe.filepos + ").\n\n" +
					SRC_TEXT + ":\t" + pe.srcText;
    alert(VAL_ERR + '\n\n' + pestr);
} // ShowXMLParseError


/**
* Unikaalse nime koostamiseks tõstutundetule keskkonnale (näiteks css). Tähed teisendatakse numbrilisteks koodideks. 
*
* @method unNameXsl 
* @param {String} inpStr Sisendstring
* @return {String} 
*/
function unNameXsl(inpStr) {
    var unStr = '', i;
    // unStr = inpStr.replace(/:/, "-");
    for (i = 0; i < inpStr.length; i++) {
        unStr += '_' + inpStr.charCodeAt(i);
    }
    return unStr;
} // unNameXsl


/**
* Teeb sisendstringi esitähe suureks. 
*
* @method captl 
* @param {String} inpStr Sisendstring
* @return {String} Väljund.
*/
function captl(inpStr) {
    return inpStr.substr(0, 1).toUpperCase() + inpStr.substr(1);
} // captl

/**
* Sorteerib järjendi (array) kasutades funktsiooni arrSort. Liidab vastuse \b-ga
*
* @method arrSort 
* @param {Array} myArr
* @return {String} 
*/
function arrSort(myArr) {
    return myArr.sort(ciSort).join('\b');
    //    return myArr.toArray().sort(ciSort).join('\b');
}


/**
* Sorteerimise abifunktsioon ( ci - "case insensitive", tõstutundetu).
*
* @method ciSort 
* @param {String} param1
* @param {String} param2
* @return {Int}  String.localeCompare
*/
function ciSort(param1, param2) {
    var first = param1.toLowerCase();
    var second = param2.toLowerCase();
    return first.localeCompare(second);
}

/**
*  
*
* @method mdArrSortCi 
* @param {String} param1 ?
* @param {String} param2
* @return {Int} String.localeCompare
*/
function mdArrSortCi(param1, param2) {
    var first = param1[0].toLowerCase();
    var second = param2.toLowerCase();
    return first.localeCompare(second);
}


/**
*  Tagastab sisendstringi positsioonilt mystart stringi pikkusega mylength.
*
* @method jsMid 
* @param {String} mystring Sisendstring.
* @param {Int} mystart Alguspositsioon.
* @param {Int} mylength Tähtede arv.
* @return {String} 
*/
function jsMid(mystring, mystart, mylength) {
    return mystring.substr(mystart, mylength);
}

/**
*   Stringi vasakust poolest niipalju kui vaja.
*
* @method jsLeft 
* @param {String} mystring
* @param {Int} mylength
* @return {String} 
*/
function jsLeft(mystring, mylength) {
    return mystring.substr(0, mylength);
}


/**
*  Stringi paremast poolest niipalju kui vaja.
*
* @method jsRight 
* @param {String} mystring
* @param {Int} mylength
* @return {String} 
*/
function jsRight(mystring, mylength) {
    return mystring.substr(mystring.length - mylength);
}

/**
*  Asendab mystringi seest jupp oldStr stringiga newStr.
*
* @method jsReplace 
* @param {String} mystring
* @param {String} oldStr
* @param {String} newStr
* @return {String} 
*/
function jsReplace(mystring, oldStr, newStr) {
    //    return mystring.replace(oldStr, newStr);
    //    var r = new RegExp(oldStr, "g");
    //    return mystring.replace(r, newStr);
    //    var rets = mystring;
    //    var j = 0;
    //    while (rets.indexOf(oldStr) > -1) {
    //        rets = rets.replace(oldStr, newStr);
    //        j += 1;
    //        if (j > 20)
    //            blahh;
    //    }
    //    return rets;
    return mystring.split(oldStr).join(newStr);
}


/**
*  return myNum.toFixed(myDd);
*
* @method jsFormatNumber 
* @param {Int} myNum
* @param {Int} myDd
* @return {String} 
*/
function jsFormatNumber(myNum, myDd) {
    return myNum.toFixed(myDd);
}


/**
*  Kontrollib, kas objekt on undefined.
*
* @method jsIsNull 
* @param {Object} thing Kontrollitav objekt.
* @return {Boolean} true, kui undefined.
*/
function jsIsNull(thing) {
    if (typeof (thing) == "undefined")
        return true;
    else
        return false;
}


/**
*  Kontrollib, kas objekt on tüüpi date.
*
* @method jsIsDate 
* @param {String} sDate Kontrollitav kuupäev.
* @return {Boolean} true
*/
function jsIsDate(sDate) {
    var scratch = new Date(Date.parse(sDate));
    return true;
    //    if (scratch.toString() == "NaN" || scratch.toString() == "Invalid Date") {
    //        return false;
    //    } else {
    //        return true;
    //    }
}


/**
*  Keerab stringi tagurpidi.
*
* @method jsStrReverse 
* @param {String} s  
* @return {String} 
*/
function jsStrReverse(s) {
    var rets = '';
    for (var ixChar = 0; ixChar < s.length; ixChar++) {
        rets = s.charAt(ixChar) + rets;
    }
    return rets;
}

/**
*  Tagastab XML elemendi väärtuse. 
*
* @method xmlElementTextValue 
* @param {Object} myElem  XML element.
* @return {String} 
*/
function xmlElementTextValue(myElem) {
    if (!myElem)
        return '';
    if ('textContent' in myElem)
        return myElem.textContent;
    else
        return myElem.text; // MSXML
}
