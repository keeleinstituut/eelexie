/**
* tools_dx.js
* Brauserisõltumatu verstiooni oma
*
* @class tools_dx
*/

/**
* Hoiab highlight'i ajal ajutist värvi.
* 
* @property str_TDBGCol
* @type {String}
*/
var str_TDBGCol;
var xmlHTTPAsync, myAsync;
var httpRequest = null;

// readyState Property (IXMLHTTPRequest)
var XMLHTTP_UNINITIALIZED = 0;
var XMLHTTP_LOADING = 1;
var XMLHTTP_LOADED = 2;
var XMLHTTP_INTERACTIVE = 3;
var XMLHTTP_COMPLETED = 4;



/**
* Eventhandler. Higlight'ib asju, kui hiirega neile peale minna. Kasutab muutujat str_TDBGCol.
*
* @method SwitchTD
* @param {Object} event
* @returns {Boolean} true, kui leiti.
*/
function SwitchTD(event) {
    var obj_tdelem = event.target.parentNode;
    switch (event.type) {
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
* InitDomDoc. Luuakse uus xmldomdoc.
*
* @method IDD
* @param {String} domsrc Allika tüüp. "string", "file", "".
* @param {String} domstr Viide allikale või allikas ise, sõltuvalt muutuja domsrc väärtusest. Kui domsrc on "", siis funktsioon loob tühja dokumendi.
* @param {Boolean} res_ext Kas lahendada välised viited. (Ei kasutata.)
* @param {Boolean} val_on_parse Kas laadimisel valideeritakse. (Ei kasutata.)
* @param {Object} domsc Skeem või null. (Ei kasutata.)
* @returns {Object} xmldomdoc objekt.
*/
function IDD(domsrc, domstr, res_ext, val_on_parse, domsc) {

    var xmlDoc = null;
    switch (domsrc.toLowerCase()) {
        case "string":
            xmlDoc = BuildXMLFromString(domstr);
            break;
        case "file":
            //            if (!httpRequest) {
            httpRequest = CreateHTTPRequestObject();
            //            }
            if (httpRequest) {
                // The requested file must be in the same domain that the page is served from.
                // kas GET korral on lootus/oht saada käšitud XML faile? Jah, konf failgi on käšitud, GET on kasutu.
                // method, url, async, user, pw
                httpRequest.open("POST", domstr, false, '', '');
                httpRequest.send();

                if (httpRequest.statusText == "OK") {
                    xmlDoc = ParseHTTPResponse(httpRequest);
                }
            }
            break;
        case "":
            //  && document.implementation.createDocumentType
            if (document.implementation.createDocument) {
//                var fruitDocType = document.implementation.createDocumentType("fruit", "SYSTEM", "<!ENTITY tf 'tropical fruit'>");
//                object.createDocument (namespaceURI, qualifiedName, docTypeObj);
//                xmlDoc = document.implementation.createDocument("", "fruits", fruitDocType);

                //Note: The createDocument method is supported in Internet Explorer from version 9, but it creates an HTML document, not an XML document. 
                xmlDoc = document.implementation.createDocument("", "", null);

//                var fruitNode = xmlDoc.createElement("fruit");
//                fruitNode.setAttribute("name", "avocado");
//                xmlDoc.documentElement.appendChild(fruitNode);
            }
            break;
    }

    return xmlDoc;

} // IDD



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
* Tagastab MSXML dokumendi objekti. (IE funktsioon. Tõenäoliselt ei kasutata.)
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
* Tagastab Http requesti objekti.
*
* @method CreateHTTPRequestObject
* @returns {Object} 
*/
function CreateHTTPRequestObject() {
    // although IE supports the XMLHttpRequest object, it does not work on local files.
    var forceActiveX = (window.ActiveXObject && location.protocol === "file:");
    if (window.XMLHttpRequest && !forceActiveX) {
        // Firefox, Opera 8.0+, Safari, IE 7+
        return new XMLHttpRequest();
    }
    else {
        try {
            // IE 5.5+
            // 6+ korral on: new ActiveXObject("Msxml2.XMLHTTP");
            return new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {
            alert("Your browser doesn't support HTTP request ('XMLHttpRequest'/'Microsoft.XMLHTTP' object)!\n\n" + e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.");
        }
    }
    return null;
}



/**
* Tagastab Ajax objekti. 
*
* @method getXmlHttpObject
* @returns {Object} = new XMLHttpRequest();
*/
function getXmlHttpObject() {
    var xmlHttp = null;
    try {
        // Firefox, Opera 8.0+, Safari, IE 7+
        xmlHttp = new XMLHttpRequest();
    }
    catch (e) {
        try {
            // Internet Explorer 6+
            xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch (e) {
            // IE 5.5+
            xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
    }
    return xmlHttp;
}


/**
* Returns whether the HTTP request was successful.
*
* @method IsRequestSuccessful
* @param {Object} httpRequest
* @returns {Boolean} 
*/
function IsRequestSuccessful(httpRequest) {
    // IE: sometimes 1223 instead of 204
    var success = (httpRequest.status == 0 ||
        (httpRequest.status >= 200 && httpRequest.status < 300) ||
        httpRequest.status == 304 || httpRequest.status == 1223);

    return success;
}


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
* Ülakomade panemine millegi järgi. 
*
* @method GCV
* @param {String} sInpStr
* @param {String} lisa String, mis lisatakse vahele.
* @param {Int} kuhu Positsioon, kuhu lisatakse.
* @returns {String} 
*/
function GCV(sInpStr, lisa, kuhu) {
    var sGCV, i, tarr;
    sGCV = ""

    if (sInpStr == "'") {
        if (kuhu == 0) {
            sGCV = "\"" + lisa + "'\"";
        } else {
            sGCV = "\"'" + lisa + "\"";
        }
    } else if (sInpStr.indexOf("'") > -1) {
        tarr = sInpStr.split("'");
        for (i = 0; i < tarr.length; i++) {
            if (tarr[i]) {
                sGCV = sGCV + ",'" + tarr[i] + "'";
            }

            if (i < tarr.length - 1) {
                sGCV = sGCV + ",\"'\"";
            }
        }
        if (lisa) {
            if (kuhu == 0) {
                sGCV = "concat('" + lisa + "', " + sGCV.substr(1) + ")";
            } else {
                sGCV = "concat(" + sGCV.substr(1) + ", '" + lisa + "')";
            }
        } else {
            sGCV = "concat(" + sGCV.substr(1) + ")";
        }
    } else {
        if (kuhu == 0) {
            sGCV = "'" + lisa + sInpStr + "'";
        } else {
            sGCV = "'" + sInpStr + lisa + "'";
        }
    }
    return sGCV;
} //GCV

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
    xmlHTTPAsync.send(getXmlString(oPrmDom));
} //QueryResponseAsync


/**
* Töötleb päringu vastust ja edastatakse funktsiooniga asyncCompleted.
*
* @method doHttpReadyStateChange
*/
function doHttpReadyStateChange() {
    if (xmlHTTPAsync.readyState == XMLHTTP_COMPLETED) {
        if (IsRequestSuccessful(xmlHTTPAsync)) {
            var oSrvRspDOM = ParseHTTPResponse(xmlHTTPAsync);
            asyncCompleted(oSrvRspDOM);
        } else {
            alert(xmlHTTPAsync.statusText);
            asyncCompleted(null);
        }
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
    //    myAsync = getXmlHttpObject();
    if (myAsync = getXmlHttpObject()) { // jah, siin on tõesti omistamine, mitte võrdlus
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
* Valideerib XMLi. Näitab errorit. (Aga IDD on tegemata.)
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
*  Sorteerimise abifunktsioon. Võrdleb esimese sisendstringi esitähte teise stringiga (mõlemad lowercase).
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
* Tagasatb algus- ja lõpu wild characteridest vabastatud otsitava.
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
* Tagastab MySQLi päringu.
*
* @method getSqlQuery
* @param {String} qn
* @param {String} txt
* @param {String} onTeksti
* @param {String} wsym
* @param {String} wcase
* @param {String} extvalpath
* @param {String} elRada
* @param {String} msAttCond
* @returns {String}
*/
function getSqlQuery(qn, txt, onTeksti, wsym, wcase, extvalpath, elRada, msAttCond) {
    var rexBinary, volId, volCond, ret;
    rexBinary = "";
    if (wcase == 1) {
        rexBinary = "BINARY ";
    }
    volId = dhxBar.getListOptionSelected("volSelect");
    volCond = dic_desc + ".vol_nr = " + jsMid(volId, 3, 1);
    if (volId == dic_desc + "All") {
        volCond = dic_desc + ".vol_nr > 0";
    }

    //MySQL LIKE on tegelikult string võrdlemise funktsioon: expr LIKE pat
    //"lihtne" regexp
    var mySqlLikePtrn = getMySqlLikePtrn(txt)

    var mySqlPtrn = getSrPn2(txt, "MySql");
    //need kuradi ^ või [:<:] EI OLE MySQL-is üks ja sama stringi alguse korral!
    mySqlPtrn = jsReplace(mySqlPtrn, "^", "(^|[[:<:]])");
    mySqlPtrn = jsReplace(mySqlPtrn, "$", "($|[[:>:]])");

    ret = "";
    if (qn == qn_ms) {
        var msTekstTing;
        if (txt == "*") {
            msTekstTing = "";
        } else {
            msTekstTing = "msid.ms LIKE " + rexBinary + mySqlLikePtrn;
            //withSymbols: 0-sümboliteta; -1-sümboliteta ja fak tekstiga; 1-sümbolitega;
            if (wsym < 1) {
                msTekstTing = "msid.ms_nos LIKE " + rexBinary + mySqlLikePtrn;
                if (fakult.length > 0 && wsym == -1) {
                    msTekstTing = msTekstTing + " OR msid.ms_nos_alt LIKE " + rexBinary + mySqlLikePtrn;
                }
            }
            msTekstTing = " AND (" + msTekstTing + ")";
        }
        ret = "SELECT " + dic_desc + ".md AS md, " + "msid.ms AS l, " +
            "msid.ms_att_i AS ms_att_i, msid.ms_att_liik AS ms_att_liik, " +
            "msid.ms_att_ps AS ms_att_ps, msid.ms_att_tyyp AS ms_att_tyyp, msid.ms_att_mliik AS ms_att_mliik, " +
            "msid.ms_att_k AS ms_att_k, msid.ms_att_mm AS ms_att_mm, msid.ms_att_st AS ms_att_st, " +
            "msid.ms_att_vm AS ms_att_vm, msid.ms_att_all AS ms_att_all, msid.ms_att_uus AS ms_att_uus, " +
            "msid.ms_att_zs AS ms_att_zs, msid.ms_att_u AS ms_att_u, msid.ms_att_em AS ms_att_em, " +
            dic_desc + ".G AS G, " + dic_desc + ".art AS art, " +
            dic_desc + ".K AS K, " + dic_desc + ".KL AS KL, " +
            dic_desc + ".T AS T, " + dic_desc + ".TA AS TA, " + dic_desc + ".TL AS TL, " +
            dic_desc + ".PT AS PT, " + dic_desc + ".PTA AS PTA, " +
            dic_desc + ".vol_nr AS vol_nr " + "FROM msid, " + dic_desc +
            " WHERE (" + dic_desc + ".G = msid.G" +
            " AND msid.dic_code = '" + dic_desc + "'" + msTekstTing + msAttCond + " AND " + volCond + ")" +
            " ORDER BY " + dic_desc + ".ms_att_OO";
    } else {
        var elementValNimi, artValNimi, elementTing, fromTing;
        elementValNimi = "val";
        artValNimi = "art";
        if (wsym < 1) {
            elementValNimi = "val_nos";
            artValNimi = "art_alt";
        }
        if (onTeksti && mySqlDataVer == "2") {
            elementTing = "elemendid_" + dic_desc + ".nimi = '" + qn + "'";
            if (txt == "*") {
            } else {
                //siin peaks midagi optimiseerima, nt päring sl='*';
                elementTing = elementTing + " AND elemendid_" + dic_desc + "." + elementValNimi + " LIKE " + rexBinary + mySqlLikePtrn;
            }
            if (!(jsLeft(elRada, 3) == ".//" || elRada == "")) { //'on lokaalne; ".//" korral on globaalne, "" korral on 'art';
                elementTing = elementTing + " AND elemendid_" + dic_desc + ".rada = '" + elRada + "'";
            }
            elementTing = " AND (" + elementTing + msAttCond + ")";
            fromTing = "";
            if ((msAttCond.indexOf("atribuudid_" + dic_desc) > -1)) {
                //1 = 1;
                if ((msAttCond.indexOf("select " + dic_desc, 1) < 0)) {
                    fromTing = ", atribuudid_" + dic_desc;
                }
            }
            ret = "SELECT " + dic_desc + ".md AS md, " + "elemendid_" + dic_desc + ".val AS l, " +
                dic_desc + ".G AS G, " + dic_desc + ".art AS art, " +
                dic_desc + ".K AS K, " + dic_desc + ".KL AS KL, " +
                dic_desc + ".T AS T, " + dic_desc + ".TA AS TA, " + dic_desc + ".TL AS TL, " +
                dic_desc + ".PT AS PT, " + dic_desc + ".PTA AS PTA, " +
                dic_desc + ".vol_nr AS vol_nr " + "FROM " + dic_desc + ", elemendid_" + dic_desc + fromTing +
                " WHERE (" + dic_desc + ".G = elemendid_" + dic_desc + ".G" + elementTing +
                " AND " + volCond + ")" +
                " ORDER BY " + dic_desc + ".ms_att_OO";
        } else {
            if (txt == "*") {
                elementTing = " != ''";
            } else if (txt == "=NULL") {
                elementTing = " != ''";
            } else if (txt.substr(0, 1) == "§") {
                elementTing = " != ''";
            } else {
                elementTing = " regexp " + rexBinary + "'" + mySqlPtrn + "'";
            }
            ret = "SELECT " + dic_desc + ".md AS md, " +
                "ExtractValue(" + dic_desc + ".art, \"" + extvalpath + "\") AS l, " +
                dic_desc + ".G AS G, " + dic_desc + ".art AS art, " +
                dic_desc + ".K AS K, " + dic_desc + ".KL AS KL, " +
                dic_desc + ".T AS T, " + dic_desc + ".TA AS TA, " + dic_desc + ".TL AS TL, " +
                dic_desc + ".PT AS PT, " + dic_desc + ".PTA AS PTA, " +
                dic_desc + ".vol_nr AS vol_nr " + "FROM " + dic_desc +
                " WHERE (ExtractValue(" + dic_desc + "." + artValNimi + ", \"" + extvalpath + "\")" + elementTing +
                " AND " + volCond + ")" +
                " ORDER BY " + dic_desc + ".ms_att_OO";
        }
    }

    return ret;
} //getSqlQuery

/**
* Muudetakse (asendatakse, iskeibitakse) MySQL-like päring.
*
* @method getMySqlLikePtrn 
* @param {String} inp MySQL-like päring.
* @param {String} Muudetud päring.
*/
function getMySqlLikePtrn(inp) {
    var ret, escCh, escCl;
    ret = inp;

    //MySql LIKE bug:
    //select * from msid where dic_code='ss_' && vol_nr>0;
    // select * from msid where dic_code='ss_' && vol_nr>0 && ms like '%\\\\%';
    // select * from msid where dic_code='ss_' && vol_nr>0 && locate('\\', ms)>0;
    // select * from msid where dic_code='ss_' && vol_nr>0 && ms like '%\\tõde';
    // select * from msid where dic_code='ss_' && vol_nr>0 && ms like '%\\kirjandus';
    // select * from msid where dic_code='ss_' && vol_nr>0 && ms like '%€\%' escape '€';

    if (ret.indexOf("\\") > -1) {
        escCh = "¡";
        escCl = " ESCAPE '¡'";
    } else {
        escCh = "\\";
        escCl = "";
    }
    // märksõnad <m>
    // ss_ (sama puuk mis allpool?: (msid.ms LIKE '%¡\kon%' ESCAPE '¡') annab nii kaldkriipsu kui ka 'kon')
    ret = jsReplace(ret, "\\\\", "\uE003");
    // ss1
    ret = jsReplace(ret, "\\*", "\uE001");
    // ss_, fin
    ret = jsReplace(ret, "\\?", "\uE002");
    // qs_, evs
    ret = jsReplace(ret, "_", "\\_");
    // qs_
    ret = jsReplace(ret, "'", escCh + "'");
    // evs (puuk?: (msid.ms LIKE '%\%m%') annab justnagu '%' ning 'm')
    ret = jsReplace(ret, "%", escCh + "%");
    ret = jsReplace(ret, "?", "_");
    ret = jsReplace(ret, "*", "%");
    ret = jsReplace(ret, "\uE001", "*");
    ret = jsReplace(ret, "\uE002", "?");
    ret = jsReplace(ret, "\uE003", escCh + "\\");
    if (ret.indexOf("'") > -1) {
        ret = "\"" + ret + "\"";
    } else {
        ret = "'" + ret + "'";
    }
    ret = ret + escCl

    return ret;
} //getMySqlLikePtrn


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
* @return {Boolean} true või false
*/
function jsIsDate(sDate) {
    var scratch = new Date(sDate);
    if (scratch.toString() == "NaN" || scratch.toString() == "Invalid Date") {
        return false;
    } else {
        return true;
    }
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


/**
* Asendab funktsiooni showModalDialog(url, par, feat); mis on Operas puudu. Näitab dialoogi ja tagastab selle vastuse.
*
* @method modalDlg 
* @param {String} url Aadress dialoogile.
* @param {String} par Dialoogi parameetrid.
* @param {String} feat Features, kas resizable jms. 
* @return {String} 
*/
function modalDlg(url, par, feat) {
    var retVal;
    if (window.showModalDialog) {
        retVal = showModalDialog(url, par, feat);
    }
    else {
        // kasutada on mõtet:
        // dialogHeight, dialogLeft, dialogTop, dialogWidth, center, resizable, scroll, status
        // open puhul:
        // left, top, height, width, location, menubar, scrollbars, status, titlebar, toolbar
        var newFeats = feat.toLowerCase();
        newFeats = newFeats.replace(/dialog/gi, " ");
        newFeats = newFeats.replace(/:/g, "=");
        newFeats = newFeats.replace(/;/g, ",");
        newFeats = newFeats.replace(/\bscroll\b/g, "scrollbars");
        newFeats = jsTrim(newFeats);
        newFeats += ",location=no,menubar=no,titlebar=yes,toolbar=no";

        //        // for similar functionality in Opera, but it's not modal!
        //        // url, nimi (_blank, _parent, _self, _top, 'name'), omadused, mingi ajalugu sättimine
        //        var modal = window.open(url, "eelexDlg", newFeats, null);
        //        modal.dialogArguments = sharedObject;

        var sMD_element = document.getElementById('eeLexDlg');
        var sMD_frame;
        if (sMD_element) {
            sMD_frame = sMD_element.getElementsByTagName("iframe")[0];
            sMD_frame.setAttribute("src", url);
            sMD_element.style.display = 'block';
        }
        else {
            var sMD_width, sMD_height;
            //        sMD_width = screen.availWidth - 100;
            //        sMD_height = screen.availHeight - 200;

            var tarr = newFeats.split(",");
            for (var i in tarr) {
                tarr[i] = tarr[i].replace(/\bpx\b/, "");
                if (tarr[i].indexOf("width") >= 0) sMD_width = tarr[i].substr(tarr[i].indexOf("=") + 1);
                if (tarr[i].indexOf("height") >= 0) sMD_height = tarr[i].substr(tarr[i].indexOf("=") + 1);
            }

            document.getElementById('spn_eeLexDlgParms').innerHTML = par;

            var sMD_container, sMD_top;
            sMD_element = document.createElement('div');
            sMD_element.style = "position: fixed; top:0; left: 0; padding:0; margin:0; width: 100%; height: 100%; min-height:100%; background:#333333; z-index:2147483647";
            sMD_element.setAttribute("align", "center");
            sMD_element.setAttribute("id", "eeLexDlg");

            sMD_container = document.createElement('div');
            //            sMD_container.style = "padding:0;margin:0;margin-top:10px;width:" + sMD_width + "px;height:" + sMD_height + "px;background:#FFFFFF;";
            sMD_container.style = "padding:0;margin:0;margin-top:10px;width:" + sMD_width + "px;height:" + sMD_height + "px;background:#333333;";
            sMD_element.appendChild(sMD_container);

            sMD_top = document.createElement('div');
            sMD_top.style = "padding:2;margin:0;width:100%;height:14px;background:#34586E;color:#FFFFFF;font-family:Arial;font-size:11px;border-top: 1px solid #5E8399;border-left:1px solid #668BA1;border-right:1px solid #162E3D;border-bottom:1px solid #162E3D;cursor:pointer;";
            sMD_top.setAttribute("align", "center");
            sMD_top.setAttribute("onclick", "javascript:document.getElementById('eeLexDlg').style.display='none';");
            sMD_top.innerHTML = "Opera valedialoog v0.0 - Sulgemiseks vajuta siia";

            //el iframe
            sMD_frame = document.createElement('iframe');
            sMD_frame.setAttribute("src", url);
            sMD_frame.setAttribute("width", sMD_width);
            sMD_frame.setAttribute("height", sMD_height);
            sMD_frame.setAttribute("scrolling", "auto");

            sMD_container.appendChild(sMD_top);
            sMD_container.appendChild(sMD_frame);

            document.body.appendChild(sMD_element);
        }
    }
    return retVal;
}


/**
* Eventhandler. Nagu ei tee midagi.
*
* @method onDomTextModified 
* @param {Object} event
*/
function onDomTextModified(event) {
    // event.prevValue
    var currentValue = event.newValue;
    if (currentValue != event.target.data) { // Firefox
        currentValue = event.target.data;
    }

    document.getElementById('eeLexDlg').style.display = 'none';

    if (currentValue != "0") {
        var dlgId = currentValue.substr(0, currentValue.indexOf(JR));
        var retVal = currentValue.substr(currentValue.indexOf(JR) + 1);

        if (dlgId == "eelex_setup") {
            eelexSetupOK(retVal);
        }
    }
}
