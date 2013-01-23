/**
* komponendid.js.
* Kasutatakse ka brauserisõltumatus versioonis.
*
* @class komponendid
*/

/**
* Arvatavasti paneb kokku sõnastike toimetuslogi päringu.
*
* @method showDicLogs
*/
function showDicLogs() {
    var myForward = document.getElementById("forward");
    if (!myForward) {
        myForward = document.createElement("form");
        myForward.setAttribute("name", "forward");
        myForward.setAttribute("method", "post");
        myForward.setAttribute("action", "dicLogs.cgi");
        myForward.setAttribute("target", "_blank");
        myForward.innerHTML = "<input id='dic_desc' name='dic_desc' type='hidden' value=''>" + "<input id='appLang' name='appLang' type='hidden' value=''>" +
                    "<input id='par1' name='par1' type='hidden' value=''>" +
                    "<input id='par2' name='par2' type='hidden' value=''>" +
                    "<input id='par3' name='par3' type='hidden' value=''>" +
                    "<input id='par_S' name='par_S' type='hidden' value=' checked'>" +
                    "<input id='par_L' name='par_L' type='hidden' value=' checked'>" +
                    "<input id='par_K' name='par_K' type='hidden' value=' checked'>" +
                    "<input id='par_T' name='par_T' type='hidden' value=''>" +
                    "<input id='par_I' name='par_I' type='hidden' value=''>" +
                    "<input id='par_W' name='par_W' type='hidden' value=''>" +
                    "<input id='par_C' name='par_C' type='hidden' value=''>" +
                    "<input id='par_H' name='par_H' type='hidden' value=' checked'>" +
                    "<input id='par_GS' name='par_GS' type='hidden' value=''>" +
                    "<input id='par_GV' name='par_GV' type='hidden' value=''>" +
                    "<input id='par_X' name='par_X' type='hidden' value=''>" +
                    "<input id='par_B' name='par_B' type='hidden' value=' checked'>";
        document.body.appendChild(myForward);
    }
    if ((myForward)) {
        myForward.dic_desc.value = dic_desc;
        myForward.appLang.value = sAppLang;
        myForward.par1.value = document.title;
        myForward.submit();
    }
} // showDicLogs


/**
* Kontrollib XMLi valiidsust serveris. TODO: Äkki on köite valideerimine hoopis.
* Kasutab StartOperation(cmdXmlDom);
*
* @method srvXmlValidate
*/
function srvXmlValidate() {

    var seldId, seldTekst, pathName = window.location.pathname; // ilma sabadeta (?, #), algab '/'; nt "/__shs_test/art.cgi"
    var scriptName = pathName.substr(pathName.lastIndexOf('/') + 1);


    if (scriptName == "art.cgi") { // IE versioon
        var volSelElement = document.getElementById("sel_Vol"); // art.cgi, IE versioon
        seldId = volSelElement.options[volSelElement.selectedIndex].id;
        seldTekst = volSelElement.options[volSelElement.selectedIndex].innerHTML;
    } else if (scriptName == "art_dx.cgi") { // "sõltumatu" versioon
        seldId = dhxBar.getListOptionSelected("volSelect");
        seldTekst = dhxBar.getListOptionText("volSelect", seldId);
    }

    if (seldId == sAllVolId) {
        alert(CHK_VOL_ERR);
        return;
    }

    var cmdXml, cmdXmlDom, qM;
//    qM = qryMethod;
    qM = "MySql";

    //    if (window.event.ctrlLeft) {
    //        qM = "XML";
    //    }

    sCmdId = "srvXmlValidate";
    sQryInfo = seldTekst + ": " + "Köite valideerimine";

    // need, kus võib olla muutujaid (entity), ära siia tekstina pane ...
    cmdXml = "<prm>" +
                    "<cmd>" + sCmdId + "</cmd>" +
                    "<vol>" + seldId + "</vol>" +
                    "<nfo>" + sQryInfo + "</nfo>" +
                    "<qn>" + DICPR + ":artikkel</qn>" +
                    "<qM>" + qM + "</qM>" +
                  "</prm>";

    cmdXmlDom = IDD("String", cmdXml, false, false, null);
    if (!(cmdXmlDom && getXmlString(cmdXmlDom))) { // kui on viga, siis IE-s on xml=''
        alert("Viga 'cmdXmlDom'-s");
        return;
    }

    StartOperation(cmdXmlDom);

} // srvXmlValidate

/**
* Näitab eelmist, järgmist, viimast või esimest artiklit. Kutsutakse välja Toimetamisala ülaservast noolenuppudelt.
* 
* @method showPrevNextEntry
* @param {Int} samm Kui 0, siis antakse esimene; kui 1, antakse järgmine; kui -1, antakse eelmine; kui 1000000, antakse viimane.
*/
function showPrevNextEntry(samm) {

    var seldId, seldTekst, pathName = window.location.pathname; // ilma sabadeta (?, #), algab '/'; nt "/__shs_test/art.cgi"
    var scriptName = pathName.substr(pathName.lastIndexOf('/') + 1);

    if (scriptName == "art.cgi") { // IE versioon
        if (salvestaJaKatkesta()) {
            return;
        }
        var volSelElement = document.getElementById("sel_Vol"); // art.cgi, IE versioon
        seldId = volSelElement.options[volSelElement.selectedIndex].id;
        seldTekst = volSelElement.options[volSelElement.selectedIndex].innerHTML;
    } else if (scriptName == "art_dx.cgi") { // "sõltumatu" versioon
        seldId = dhxBar.getListOptionSelected("volSelect");
        seldTekst = dhxBar.getListOptionText("volSelect", seldId);
    }

    if (seldId == sAllVolId) {
        if (scriptName == "art.cgi") { // IE versioon
            sel_Vol.selectedIndex = 0;
            seldId = volSelElement.options[volSelElement.selectedIndex].id;
        } else if (scriptName == "art_dx.cgi") { // "sõltumatu" versioon
            setButtonSelectId("volSelect", dic_desc + "1");
            seldId = dhxBar.getListOptionSelected("volSelect");
        }
    }

    var artGuid = '', art_xpath;
    sCmdId = "prevNextRead";
    if (samm == 0) {
        sQryInfo = NAME_FIRST;
        art_xpath = DICPR + ":A[position() = 1]";
    } else if (samm == 1000000) {
        sQryInfo = NAME_LAST;
        art_xpath = DICPR + ":A[position() = last()]";
    } else { //1 v -1;
        if (oEditDOMRoot.hasChildNodes()) {
            artGuid = getXmlSingleNodeValue(oEditDOMRoot, DICPR + ":A/" + qn_guid);
            if (samm == -1) {
                sQryInfo = NAME_PREVIOUS;
                art_xpath = DICPR + ":A[" + qn_guid + " = '" + artGuid + "']/preceding-sibling::" + DICPR + ":A[1]";
            } else if (samm == 1) {
                sQryInfo = NAME_NEXT;
                art_xpath = DICPR + ":A[" + qn_guid + " = '" + artGuid + "']/following-sibling::" + DICPR + ":A[1]";
            }
        } else {
            sQryInfo = NAME_FIRST;
            samm = 0;
            art_xpath = DICPR + ":A[position() = 1]";
        }
    }

    var cmdXml, cmdXmlDom, qM;
    //    qM = qryMethod;
    qM = "MySql";

    //    if ((window.event.ctrlLeft)) {
    //        qM = "XML";
    //    }

    // need, kus võib olla muutujaid (entity), ära siia tekstina pane ...
    cmdXml = "<prm>" +
                    "<cmd>" + sCmdId + "</cmd>" +
                    "<vol>" + seldId + "</vol>" +
                    "<nfo>" + sQryInfo + "</nfo>" +
                    "<axp>" + art_xpath + "</axp>" +
                    "<exp>" + samm + "</exp>" +
                    "<G>" + artGuid + "</G>" +
                    "<qM>" + qM + "</qM>" +
                  "</prm>";

    cmdXmlDom = IDD("String", cmdXml, false, false, null);
    if (!(cmdXmlDom && getXmlString(cmdXmlDom))) { // kui on viga, siis IE-s on xml=''
        alert("Viga 'cmdXmlDom'-s");
        return;
    }

    StartOperation(cmdXmlDom);

} //showPrevNextEntry


/**
* Kutsutakse välja nupu "Lisa artikkel" alt (Sõnastiku akna ülaservas kollane tärn).
* 
* @method imgArtAddClick
*/
function imgArtAddClick() {

    var seldId, seldTekst, pathName = window.location.pathname; // ilma sabadeta (?, #), algab '/'; nt "/__shs_test/art.cgi"
    var scriptName = pathName.substr(pathName.lastIndexOf('/') + 1);

    var elemTextValue;

    if (scriptName == "art.cgi") { // IE versioon
        if (salvestaJaKatkesta()) {
            return;
        }
        var volSelElement = document.getElementById("sel_Vol"); // art.cgi, IE versioon
        seldId = volSelElement.options[volSelElement.selectedIndex].id;
        seldTekst = volSelElement.options[volSelElement.selectedIndex].innerHTML;
        elemTextValue = jsTrim(inp_ElemText.value);
    } else if (scriptName == "art_dx.cgi") { // "sõltumatu" versioon
        seldId = dhxBar.getListOptionSelected("volSelect");
        seldTekst = dhxBar.getListOptionText("volSelect", seldId);
        elemTextValue = jsTrim(dhxBar.getValue("txtElemOtsitav"));
    }

    if (seldId == sDeldVolId || seldId == sAllVolId) {
        alert(CHK_VOL_ERR);
        return;
    }

    var seldVolNr = seldId.substr(3, 1);

    var oConfigDOM = IDD("File", "shsconfig_" + dic_desc + ".xml", false, false, null);
    if (!oConfigDOM) {
        alert("Puudub konfiguratsioonifail 'shsconfig_" + dic_desc + ".xml'!");
        return;
    }

    var sParms, smdArgs, psTrue = false, showDlg = true;
    var tarr, msVal = '', homNrVal = '', psVal = '';

    if (dic_desc == "ss_" || dic_desc == "ss1") {
        psTrue = true;
    }

    //    showDlg = jsStringToBoolean(getXmlSingleNodeValue(oConfigDOM.documentElement, "newArtDlg"));
    var cfgElem = oConfigDOM.documentElement.getElementsByTagName("newArtDlg")[0];
    if (cfgElem) {
        showDlg = jsStringToBoolean(getXmlNodeValue(cfgElem));
    }

    if (showDlg) {
        msVal = elemTextValue;
        smdArgs = new Array(seldVolNr, msVal, dic_desc, sAppLang, "", psTrue, msLang);
        sParms = window.showModalDialog("html/newart.htm", smdArgs, "dialogHeight:600px;dialogWidth:800px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
        if (!sParms) {
            return;
        }
        //msval + JR + homnrvalue + JR + psVal
        tarr = sParms.split(JR);

        msVal = jsTrim(tarr[0]);
        homNrVal = jsTrim(tarr[1]);
        psVal = jsTrim(tarr[2]);

        if (dic_vols_count > 1) {
            var vahemik, otsad, v6rreldav, puhas;
            vahemik = getXmlSingleNodeValue(oConfigDOM.documentElement, "vols/vol[@nr = '" + seldVolNr + "']");
            // PSV teine köide 'AB' artiklid: <vol nr="2">AB: A - Y</vol>
            if (vahemik.indexOf(" - ") > -1) {
                vahemik = jsTrim(vahemik.substr(vahemik.indexOf(":") + 1));
                otsad = vahemik.split(" - ");
                if (psVal) {
                    v6rreldav = psVal;
                } else {
                    v6rreldav = msVal;
                }
                puhas = RemoveSymbols(v6rreldav, ""); //'2. parm VÕIB OLLA;
                if (!((jsStrComp(puhas.substr(0, otsad[0].length), otsad[0], 1) >= 0) && (jsStrComp(puhas.substr(0, otsad[1].length), otsad[1], 1) <= 0))) {
                    alert(CHK_VOL_ERR);
                    return;
                }
            }
        }
    }


    var oFrDom, oFrDomRoot;

    if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") { // aõltumatu peaks alati siia jõudma
        oFrDom = IDD("", "", false, false, null);
        oFrDomRoot = oFrDom.appendChild(createMyNSElement(oFrDom, DICPR + ":A", DICURI));
        yldStruNode = getXmlSingleNode(yldStruDom, ".//" + DICPR + ":A");
        getMajors(yldStruNode, oFrDomRoot);
    }
    else {
        oFrDom = IDD("File", "xml/" + dic_desc + "/ag_" + unName(DICPR + ":A") + ".xml", false, false, null);
        if (!oFrDom) {
            alert("pr_sd:ver != '2.0': puudub konfiguratsioonifail 'ag_" + unName(DICPR + ":A") + ".xml'!");
            return;
        }
        oFrDomRoot = oFrDom.documentElement;
        // äkki sõltumatu ikkagi jõuab kuidagi siia?
        try {
            AddEmptyTexts(oFrDom);
        }
        catch (e) {
            alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.");
        }
    }

    if (window.ActiveXObject) { // MSXML, IE
        oFrDom.setProperty("SelectionLanguage", "XPath");
        oFrDom.setProperty("SelectionNamespaces", sXmlNsList);
    }

    var oCNode, uusAttr, srchPtrn;
    oCNode = getXmlSingleNode(oFrDom, first_default);

    if (!showDlg) {
        msVal = jsTrim(getXmlNodeValue(oCNode)); // äkki on skeemi poolt juba täidetud (autonumber vms (vka))
        if (msVal == "") {
            msVal = "-";
        }
    }
    // IE versioonis globaalne
    sMarkSona = msVal;
    setXmlNodeValue(oCNode, sMarkSona);


    if (homNrVal != "") {
        uusAttr = createMyNSAttribute(oFrDom, qn_homnr, DICURI);
        setXmlNodeValue(uusAttr, homNrVal);
        setMyNSNamedItem(oCNode, uusAttr);
    }
    if (psVal != "") {
        uusAttr = createMyNSAttribute(oFrDom, DICPR + ":ps", DICURI);
        setXmlNodeValue(uusAttr, psVal);
        setMyNSNamedItem(oCNode, uusAttr);
    }

    if (dic_desc == "har") {
        uusAttr = createMyNSAttribute(oFrDom, DICPR + ":tyyp", DICURI);
        setXmlNodeValue(uusAttr, "ee"); //'eelistermin;
        setMyNSNamedItem(oCNode, uusAttr);
    } else if (dic_desc == "ss_") {
        uusAttr = createMyNSAttribute(oFrDom, DICPR + ":mliik", DICURI);
        setXmlNodeValue(uusAttr, "uus");
        setMyNSNamedItem(oCNode, uusAttr);
    } else if (dic_desc == "ss1") {
        uusAttr = createMyNSAttribute(oFrDom, DICPR + ":u", DICURI);
        setXmlNodeValue(uusAttr, "uus");
        setMyNSNamedItem(oCNode, uusAttr);
    }

    //mssv alles peale hom-nrt i jt atribuute
    // getSortVal(oCNode, true, true): oMNode, inclHoms, yvOrder
    // IE versioonis globaalne
    sMSortVal = getSortVal(oCNode, true, true);

    uusAttr = createMyNSAttribute(oFrDom, qn_sort_attr, DICURI);
    setXmlNodeValue(uusAttr, sMSortVal);
    setMyNSNamedItem(oCNode, uusAttr);

    srchPtrn = "^" + sMSortVal + "$";


    var sNewGuid, refNode, refXPath; ;
    //           623BCC4E-45B1-4333-A1C1-4AA9BA9CD582
    sNewGuid = "00000001-0002-0003-0004-000000000005";
    oCNode = getXmlSingleNode(oFrDom, DICPR + ":A/" + qn_guid); // oFrDomRoot on 'A'
    if (!oCNode) {
        refXPath = DICPR + ":K | " + DICPR + ":KA | " + DICPR + ":KL | " + DICPR + ":T | " + DICPR + ":TA | " + DICPR + ":TL | " + DICPR + ":PT | " + DICPR + ":PTA | " + DICPR + ":X | " + DICPR + ":XA";
        refNode = getXmlSingleNode(oFrDomRoot, refXPath); // oFrDomRoot on 'A'
        oCNode = oFrDomRoot.insertBefore(createMyNSElement(oFrDom, qn_guid, DICURI), refNode);
    }
    setXmlNodeValue(oCNode, sNewGuid);

    oCNode = getXmlSingleNode(oFrDom, DICPR + ":A/" + qn_autor); // oFrDomRoot on 'A'
    if (!oCNode) {
        refXPath = DICPR + ":KA | " + DICPR + ":KL | " + DICPR + ":T | " + DICPR + ":TA | " + DICPR + ":TL | " + DICPR + ":PT | " + DICPR + ":PTA | " + DICPR + ":X | " + DICPR + ":XA";
        refNode = getXmlSingleNode(oFrDomRoot, refXPath); // oFrDomRoot on 'A'
        oCNode = oFrDomRoot.insertBefore(createMyNSElement(oFrDom, qn_autor, DICURI), refNode);
    }
    setXmlNodeValue(oCNode, sUsrName);
    oCNode = getXmlSingleNode(oFrDom, DICPR + ":A/" + qn_akp); // oFrDomRoot on 'A'
    if (!oCNode) {
        refXPath = DICPR + ":KL | " + DICPR + ":T | " + DICPR + ":TA | " + DICPR + ":TL | " + DICPR + ":PT | " + DICPR + ":PTA | " + DICPR + ":X | " + DICPR + ":XA";
        refNode = getXmlSingleNode(oFrDomRoot, refXPath); // oFrDomRoot on 'A'
        oCNode = oFrDomRoot.insertBefore(createMyNSElement(oFrDom, qn_akp, DICURI), refNode);
    }
    setXmlNodeValue(oCNode, GetXSDDateTime(new Date()));
    oCNode = getXmlSingleNode(oFrDom, DICPR + ":A/" + qn_toimetaja); // oFrDomRoot on 'A'
    if (!oCNode) {
        refXPath = DICPR + ":TA | " + DICPR + ":TL | " + DICPR + ":PT | " + DICPR + ":PTA | " + DICPR + ":X | " + DICPR + ":XA";
        refNode = getXmlSingleNode(oFrDomRoot, refXPath); // oFrDomRoot on 'A'
        oCNode = oFrDomRoot.insertBefore(createMyNSElement(oFrDom, qn_toimetaja, DICURI), refNode);
    }
    setXmlNodeValue(oCNode, sUsrName);
    oCNode = getXmlSingleNode(oFrDom, DICPR + ":A/" + qn_tkp); // oFrDomRoot on 'A'
    if (!oCNode) {
        refXPath = DICPR + ":TL | " + DICPR + ":PT | " + DICPR + ":PTA | " + DICPR + ":X | " + DICPR + ":XA";
        refNode = getXmlSingleNode(oFrDomRoot, refXPath); // oFrDomRoot on 'A'
        oCNode = oFrDomRoot.insertBefore(createMyNSElement(oFrDom, qn_tkp, DICURI), refNode);
    }
    setXmlNodeValue(oCNode, GetXSDDateTime(new Date()));


    // globaalsed
    sQryInfo = sMSortVal;

    var seldQn = qn_ms;  //pärast otsitakse nn homonüümseid märksõnu, st millised veel sama märksõnaga on;
//    qM = qryMethod;
    var qM = "MySql";

    var homonyymsed = '', sql = '', elm_xpath = '', art_xpath = '';
    homonyymsed = first_default.substr(first_default.indexOf("/") + 1) + "[. = " + GCV(msVal, "", 2);
    sql = "SELECT " + dic_desc +
        ".md AS md, msid.ms AS l, msid.ms_att_i AS ms_att_i, msid.ms_att_liik AS ms_att_liik, msid.ms_att_ps AS ms_att_ps, " +
        "msid.ms_att_tyyp AS ms_att_tyyp, msid.ms_att_mliik AS ms_att_mliik, msid.ms_att_k AS ms_att_k, msid.ms_att_mm AS ms_att_mm, " +
        "msid.ms_att_st AS ms_att_st, msid.ms_att_vm AS ms_att_vm, msid.ms_att_all AS ms_att_all, msid.ms_att_uus AS ms_att_uus, " +
        "msid.ms_att_zs AS ms_att_zs, " +
        dic_desc + ".G AS G, " + dic_desc + ".art AS art, " + dic_desc + ".K AS K, " + dic_desc + ".T AS T, " + dic_desc + ".TA AS TA, " +
        dic_desc + ".PT AS PT, " + dic_desc + ".vol_nr AS vol_nr " + "FROM msid, " + dic_desc + " " + 
        "WHERE (" + dic_desc + ".G = msid.G " + "AND msid.dic_code = '" + dic_desc + "' " + "AND (msid.ms = \"" + msVal + "\"";
    homonyymsed = homonyymsed + "]";
    sql = sql + ") " + "AND msid.vol_nr = " + seldVolNr;
    sql = sql + ") "; //'WHERE tingimuse lõpp;
    sql = sql + "ORDER BY " + dic_desc + ".ms_att_OO";
    elm_xpath = homonyymsed;
    homonyymsed = DICPR + ":A[" + homonyymsed + "]";
    art_xpath = homonyymsed;


    var hasHtml = "0";
    var artHtml = "";

    if (scriptName == "art.cgi") { // IE versioon
        showDbgVar("sCmdId", sCmdId, "imgArtAddClick", "lõpp", " ", new Date());
        showDbgVar("sQryInfo", sQryInfo, "imgArtAddClick", "lõpp", " ", new Date());
        showDbgVar("art_xpath", art_xpath, "imgArtAddClick", "lõpp", " ", new Date());
        showDbgVar("elm_xpath", elm_xpath, "imgArtAddClick", "lõpp", " ", new Date());
        showDbgVar("srchPtrn", srchPtrn, "imgArtAddClick", "lõpp", " ", new Date());
        showDbgVar("sql", sql, "imgArtAddClick", "lõpp", " ", new Date());
        showDbgVar("qM", qM, "imgArtAddClick", "lõpp", " ", new Date())

        hasHtml = "1";

        var xslOrigViewDom = IDD("File", "xsl/" + xslViewName + ".xsl", true, false, null);
        if (!(xslOrigViewDom && getXmlString(xslOrigViewDom))) { // kui on viga, siis IE-s on xml=''
            alert("Viga 'xslOrigViewDom'-s");
            return;
        }
        xslOrigViewDom.setProperty("AllowXsltScript", true);
        xslOrigViewDom.setProperty("SelectionLanguage", "XPath");
        xslOrigViewDom.setProperty("SelectionNamespaces", sXmlNsList);

        xslOrigViewDom.documentElement.selectSingleNode("xsl:variable[@name = 'printing']").text = "1";
        xslOrigViewDom.documentElement.selectSingleNode("xsl:variable[@name = 'showShaded']").text = "0";

        artHtml = oEditDOM.transformNode(xslOrigViewDom);
        artHtml = artHtml.replace(" xmlns:al=\"" + scriptsUri + "\"", "");
        artHtml = artHtml.replace(" xmlns:pref=\"" + DICURI + "\"", "");
        artHtml = artHtml.replace(" xmlns:" + DICPR + "=\"" + DICURI + "\"", "");
        artHtml = "<![CDATA[" + artHtml + "]]>";
    }

    sCmdId = "ClientAdd";
    // need, kus võib olla muutujaid (entity), ära siia tekstina pane ...
    var cmdXml = "<prm>" +
                    "<cmd>" + sCmdId + "</cmd>" +
                    "<vol>" + seldId + "</vol>" +
                    "<nfo></nfo>" +
                    "<axp></axp>" +
                    "<exp></exp>" +
                    "<wC>0</wC>" +
                    "<wS>1</wS>" +
                    "<fSrP></fSrP>" +
                    "<sql></sql>" +
                    "<qn>" + seldQn + "</qn>" +
                    "<qM>" + qM + "</qM>" +
                    "<hasHtml>" + hasHtml + "</hasHtml>" +
                    "<html>" + artHtml + "</html>" +
                    "<brVer>" + brVer + "</brVer>" +
                "</prm>";

    var cmdXmlDom = IDD("String", cmdXml, false, false, null);
    if (!(cmdXmlDom && getXmlString(cmdXmlDom))) { // kui on viga, siis IE-s on xml=''
        alert("Viga 'cmdXmlDom'-s");
        return;
    }

    // need, kus võib olla muutujaid (entity), väärtusta nii:
    setXmlSingleNodeValue(cmdXmlDom.documentElement, "nfo", sQryInfo);
    setXmlSingleNodeValue(cmdXmlDom.documentElement, "axp", art_xpath);
    setXmlSingleNodeValue(cmdXmlDom.documentElement, "exp", elm_xpath);
    setXmlSingleNodeValue(cmdXmlDom.documentElement, "fSrP", srchPtrn);
    setXmlSingleNodeValue(cmdXmlDom.documentElement, "sql", sql);

    cmdXmlDom.documentElement.appendChild(oFrDomRoot);
    StartOperation(cmdXmlDom);

} //imgArtAddClick


/** 
* Kontrollib artikli xml-i valiidsust ja salvestab artikli. Kutsutakse välja salvestamise nupust (Toimetamisala ülaservas). 
*
* @method imgArtSaveClick
*/
function imgArtSaveClick() {
    // algus v kustutatud
    if (!oEditDOMRoot.hasChildNodes()) {
        return;
    }

    var oArtBackup = oEditDOMRoot.firstChild.cloneNode(true);

    setMsvVals();

    var seldId, seldTekst, pathName = window.location.pathname; // ilma sabadeta (?, #), algab '/'; nt "/__shs_test/art.cgi"
    var scriptName = pathName.substr(pathName.lastIndexOf('/') + 1);

    ArtSaveChecks();  //SP-s mallid, har, geo, med: vasteplokkide järjestamine

    DeleteEmptys(oEditDOMRoot);

    var jooksevArtStr = getXmlString(oEditDOM);
    if (jooksevArtStr == artOrgString) {
        oEditDOMRoot.replaceChild(oArtBackup, oEditDOMRoot.firstChild);
        return;
    }

    var lisad = getXmlSingleNode(oEditDOMRoot.firstChild, DICPR + ":pa");
    while (lisad) {
        lisad.parentNode.removeChild(lisad);
        lisad = getXmlSingleNode(oEditDOMRoot.firstChild, DICPR + ":pa");
    }

    var oTNode, refElem = null;
    oTNode = getXmlSingleNode(oEditDOMRoot.firstChild, qn_toimetaja);
    //Juhuks, kui andmebaasis on algselt toimetaja puudu.
    //Salvestamise kellaaeg <TA> käib ainult serveri kaudu
    if (!oTNode) {
        var follNimed = getFollowingSiblings(qn_art, qn_toimetaja);
        if (follNimed != "Ei saa") {
            if (follNimed.length > 0) {
                refNode = getXmlSingleNode(oEditDOMRoot.firstChild, follNimed);
            }
            oTNode = oEditDOMRoot.firstChild.insertBefore(createMyNSElement(oEditDOM, qn_toimetaja, DICURI), refNode);
        }
    }
    setXmlNodeValue(oTNode, sUsrName);

    if (scriptName == "art.cgi") { // IE versioon
        if (!(ValidateXML(oEditDOM, oXsdSc))) {
            oEditDOMRoot.replaceChild(oArtBackup, oEditDOMRoot.firstChild);
            return;
        }
    }

    var msNode, artGuid;
    msNode = getXmlSingleNode(oEditDOMRoot, first_default);
    artGuid = getXmlSingleNodeValue(oEditDOMRoot, DICPR + ":A/" + qn_guid);

    // IE versioonis globaalsed
    sMSortVal = msNode.getAttribute(qn_sort_attr);
    sMarkSona = getXmlNodeValue(msNode);

    var seldVolNr = sFromVolume.substr(3, 1);

    var srchPtrn = "^" + sMSortVal + "$";
    var homNr = msNode.getAttribute(DICPR + ":i");
    if (!homNr)
        homNr = '';

    var homonyymsed = '', sql = '', elm_xpath = '', art_xpath = '';
    if (!(sMarkSona == sOrgMarkSona && homNr == sOrgHomnr)) {

        homonyymsed = first_default.substr(first_default.indexOf("/") + 1) + "[. = " + GCV(sOrgMarkSona, "", 2);

        sql = "SELECT " + dic_desc + ".md AS md, msid.ms AS l, msid.ms_att_i AS ms_att_i, " +
                    "msid.ms_att_liik AS ms_att_liik, msid.ms_att_ps AS ms_att_ps, msid.ms_att_tyyp AS ms_att_tyyp, " +
                    "msid.ms_att_mliik AS ms_att_mliik, msid.ms_att_k AS ms_att_k, msid.ms_att_mm AS ms_att_mm, " +
                    "msid.ms_att_st AS ms_att_st, msid.ms_att_vm AS ms_att_vm, msid.ms_att_all AS ms_att_all, " +
                    "msid.ms_att_uus AS ms_att_uus, msid.ms_att_zs AS ms_att_zs, " +
                    dic_desc + ".G AS G, " + dic_desc + ".art AS art, " + dic_desc + ".K AS K, " +
                    dic_desc + ".T AS T, " + dic_desc + ".TA AS TA, " + dic_desc + ".PT AS PT, " +
                    dic_desc + ".vol_nr AS vol_nr " +
                    "FROM msid, " + dic_desc + " " +
                    "WHERE (" + dic_desc + ".G = msid.G " + "AND msid.dic_code = '" + dic_desc + "' " +
                    "AND (msid.ms = \"" + toXmlString(sOrgMarkSona) + "\"";
        if (sMarkSona != sOrgMarkSona) {
            homonyymsed = homonyymsed + " or . = " + GCV(sMarkSona, "", 2);
            sql = sql + " OR msid.ms = \"" + toXmlString(sMarkSona) + "\"";
        }
        homonyymsed = homonyymsed + "]";
        sql = sql + ") " + "AND msid.vol_nr = " + seldVolNr;
        sql = sql + ") "; //'WHERE tingimuse lõpp;
        sql = sql + "ORDER BY " + dic_desc + ".ms_att_OO";
        elm_xpath = homonyymsed;
        homonyymsed = DICPR + ":A[" + homonyymsed + "]";
        art_xpath = homonyymsed;
    }

    sCmdId = "ClientWrite";
    sQryInfo = sMSortVal

    var qM, seldQn;
//    qM = qryMethod;
    qM = "MySql";
    seldQn = qn_ms;


    var hasHtml = "0";
    var artHtml = "";

    if (scriptName == "art.cgi") { // IE versioon
        showDbgVar("sOrgMarkSona", "'" + sOrgMarkSona + "'", "imgArtSaveClick", "lõpp", " ", new Date());
        showDbgVar("sMarkSona", "'" + sMarkSona + "'", "imgArtSaveClick", "lõpp", " ", new Date());
        showDbgVar("sOrgHomnr", "'" + sOrgHomnr + "'", "imgArtSaveClick", "lõpp", " ", new Date());
        showDbgVar("homNr", "'" + homNr + "'", "imgArtSaveClick", "lõpp", " ", new Date());
        showDbgVar("sCmdId", sCmdId, "imgArtSaveClick", "lõpp", " ", new Date());
        showDbgVar("sQryInfo", sQryInfo, "imgArtSaveClick", "lõpp", " ", new Date());
        showDbgVar("art_xpath", art_xpath, "imgArtSaveClick", "lõpp", " ", new Date());
        showDbgVar("elm_xpath", elm_xpath, "imgArtSaveClick", "lõpp", " ", new Date());
        showDbgVar("sql", sql, "imgArtSaveClick", "lõpp", " ", new Date());
        showDbgVar("artMuudatused", artMuudatused, "imgArtSaveClick", "lõpp", " ", new Date());
        showDbgVar("qM", qM, "imgArtSaveClick", "lõpp", " ", new Date());

        hasHtml = "1";

        var xslOrigViewDom = IDD("File", "xsl/" + xslViewName + ".xsl", true, false, null);
        if (!(xslOrigViewDom && getXmlString(xslOrigViewDom))) { // kui on viga, siis IE-s on xml=''
            alert("Viga 'xslOrigViewDom'-s");
            return;
        }
        xslOrigViewDom.setProperty("AllowXsltScript", true);
        xslOrigViewDom.setProperty("SelectionLanguage", "XPath");
        xslOrigViewDom.setProperty("SelectionNamespaces", sXmlNsList);

        xslOrigViewDom.documentElement.selectSingleNode("xsl:variable[@name = 'printing']").text = "1";
        xslOrigViewDom.documentElement.selectSingleNode("xsl:variable[@name = 'showShaded']").text = "0";

        artHtml = oEditDOM.transformNode(xslOrigViewDom);
        artHtml = artHtml.replace(" xmlns:al=\"" + scriptsUri + "\"", "");
        artHtml = artHtml.replace(" xmlns:pref=\"" + DICURI + "\"", "");
        artHtml = artHtml.replace(" xmlns:" + DICPR + "=\"" + DICURI + "\"", "");
        artHtml = "<![CDATA[" + artHtml + "]]>";
    }

    var cmdXml, cmdXmlDom;
    // need, kus võib olla muutujaid (entity), ära siia tekstina pane ...
    cmdXml = "<prm>" +
                    "<cmd>" + sCmdId + "</cmd>" +
                    "<vol>" + sFromVolume + "</vol>" +
                    "<nfo></nfo>" +
                    "<axp></axp>" +
                    "<exp></exp>" +
                    "<wC>0</wC>" +
                    "<wS>1</wS>" +
                    "<fSrP></fSrP>" +
                    "<qn>" + seldQn + "</qn>" +
                    "<G>" + artGuid + "</G>" +
                    "<sql></sql>" +
                    "<artCh></artCh>" +
                    "<qM>" + qM + "</qM>" +
                    "<hasHtml>" + hasHtml + "</hasHtml>" +
                    "<html>" + artHtml + "</html>" +
                    "<brVer>" + brVer + "</brVer>" +
                  "</prm>";

    cmdXmlDom = IDD("String", cmdXml, false, false, null);
    if (!(cmdXmlDom && getXmlString(cmdXmlDom))) { // kui on viga, siis IE-s on xml=''
        alert("Viga 'cmdXmlDom'-s");
        return;
    }

    // need, kus võib olla muutujaid (entity), väärtusta nii:
    setXmlSingleNodeValue(cmdXmlDom.documentElement, "nfo", sQryInfo);
    setXmlSingleNodeValue(cmdXmlDom.documentElement, "axp", art_xpath);
    setXmlSingleNodeValue(cmdXmlDom.documentElement, "exp", elm_xpath);
    setXmlSingleNodeValue(cmdXmlDom.documentElement, "fSrP", srchPtrn);
    setXmlSingleNodeValue(cmdXmlDom.documentElement, "sql", sql);
    setXmlSingleNodeValue(cmdXmlDom.documentElement, "artCh", artMuudatused);

    cmdXmlDom.documentElement.appendChild(oEditDOMRoot.firstChild.cloneNode(true));
    StartOperation(cmdXmlDom);

} //imgArtSaveClick

/** 
* Kustutab elemendi seest tühjad elemendid.
*
* @method DeleteEmptys
* @param {Object} deleteFrom Element, mille seest kustutatakse.
*/
function DeleteEmptys(deleteFrom) {
    var maha, vanem;
    maha = getXmlSingleNode(deleteFrom, ".//*[normalize-space(.) = ''][not(local-name() = 'lTL' or local-name() = 'eTL')]");
    while (maha) {
        maha.parentNode.removeChild(maha);
        maha = getXmlSingleNode(deleteFrom, ".//*[normalize-space(.) = ''][not(local-name() = 'lTL' or local-name() = 'eTL')]");
    }
    maha = getXmlSingleNode(deleteFrom, ".//*[not(text() or *)][not(local-name() = 'lTL' or local-name() = 'eTL')]");
    while (maha) {
        maha.parentNode.removeChild(maha);
        maha = getXmlSingleNode(deleteFrom, ".//*[not(text() or *)][not(local-name() = 'lTL' or local-name() = 'eTL')]");
    }
    maha = getXmlSingleNode(deleteFrom, ".//@*[. = ''][not(local-name() = 'mm' or local-name() = 'mlm')]");
    while (maha) {
        vanem = getXmlSingleNode(maha, ".."); // 'ownerElement' ei lähe mitte
        vanem.removeAttributeNode(maha);
        maha = getXmlSingleNode(deleteFrom, ".//@*[. = ''][not(local-name() = 'mm' or local-name() = 'mlm')]");
    }
} //DeleteEmptys


/** 
* Otsib kõik default_query märksõnad ja lisab neile sorteerimisväärtuse (atribuut @O). Kasutab getSortVal.
*
* @method setMsvVals
*/
function setMsvVals() {

    var mNodes = getXmlNodesSnapshot(oEditDOMRoot, default_query);
    var mNode, ix;
    if ('snapshotLength' in mNodes) {
        for (ix = 0; ix < mNodes.snapshotLength; ix++) {
            mNode = mNodes.snapshotItem(ix);
            setMyNSAttribute(mNode, DICURI, qn_sort_attr, getSortVal(mNode, true, true));
        }
    } else if ('length' in mNodes) { // nodeList, MSXML
        for (ix = 0; ix < mNodes.length; ix++) {
            mNode = mNodes[ix];
            setMyNSAttribute(mNode, DICURI, qn_sort_attr, getSortVal(mNode, true, true));
        }
    }
} //setMsvVals


/** 
* Arvutab sorteerimisväärtuse. 
*
* @method getSortVal
* @param {Object} oMNode Element, millest tekst võtta.
* @param {Boolean} inclHoms Kas lisada homonüüminumber.
* @param {Boolean} yvOrder Kas sorteerida põhisõna juurde.
* @returns {String} sorteerimisväärtus
*/
function getSortVal(oMNode, inclHoms, yvOrder) {

    var nmVal, tekstNood, i, rex;

    nmVal = "";
    //nmVal = oMNode.text
    //*** <r> märksõna sees peab jääma järjestusest välja ([kedagi] risti lööma)
    var tekstNoodid = getXmlNodes(oMNode, "text()");
    if (tekstNoodid.iterateNext) {
        tekstNood = tekstNoodid.iterateNext();
        while (tekstNood) {
            nmVal += getXmlNodeValue(tekstNood);
            tekstNood = tekstNoodid.iterateNext();
        }
    } else if ('length' in tekstNoodid) { // nodeList, MSXML
        for (i = 0; i < tekstNoodid.length; i++) {
            nmVal += tekstNoodid[i].text;
        }
    }
    nmVal = jsTrim(nmVal);
    if (nmVal == "") {
        nmVal = "-";
    }

    //muutujad (entities) maha
    rex = /&\w+;/g;
    nmVal = nmVal.replace(rex, "");

    //Unicode koodid maha
    rex = /#U([\dA-Fa-f]{4})/g;
    nmVal = nmVal.replace(rex, String.fromCharCode("0x\1"));
    rex = /\\u([\dA-Fa-f]{4})/g;
    nmVal = nmVal.replace(rex, String.fromCharCode("0x\1"));

    //ASCII koodid maha
    rex = /#(\d{2})/g;
    nmVal = nmVal.replace(rex, String.fromCharCode("0x\1"));

    nmVal = nmVal.replace(/€/g, "E");
    nmVal = nmVal.replace(/µ/g, "m");
    nmVal = nmVal.replace(/Ω/g, "O");
    nmVal = nmVal.replace(/©/g, "C");
    nmVal = nmVal.replace(/®/g, "R");
    nmVal = nmVal.replace(/™/g, "tm");
    nmVal = nmVal.replace(/Å/g, "A");
    

    //Ligatuurid kaheks
    nmVal = nmVal.replace(/Æ/g, "AE");
    nmVal = nmVal.replace(/æ/g, "ae");

    nmVal = nmVal.replace(/Ĳ/g, "IJ");
    nmVal = nmVal.replace(/ĳ/g, "ij");
    nmVal = nmVal.replace(/Œ/g, "OE");
    nmVal = nmVal.replace(/œ/g, "oe");

    nmVal = nmVal.replace(/Ǆ/g, "DŽ");
    nmVal = nmVal.replace(/ǅ/g, "Dž");
    nmVal = nmVal.replace(/ǆ/g, "dž");
    nmVal = nmVal.replace(/Ǉ/g, "LJ");
    nmVal = nmVal.replace(/ǈ/g, "Lj");
    nmVal = nmVal.replace(/ǉ/g, "lj");
    nmVal = nmVal.replace(/Ǌ/g, "NJ");
    nmVal = nmVal.replace(/ǋ/g, "Nj");
    nmVal = nmVal.replace(/ǌ/g, "nj");

    nmVal = nmVal.replace(/Ǣ/g, "AE");
    nmVal = nmVal.replace(/ǣ/g, "ae");

    nmVal = nmVal.replace(/Ǳ/g, "DZ");
    nmVal = nmVal.replace(/ǲ/g, "Dz");
    nmVal = nmVal.replace(/ǳ/g, "dz");

    nmVal = nmVal.replace(/Ǽ/g, "AE");
    nmVal = nmVal.replace(/ǽ/g, "ae");


    if (dic_desc == "evs") {
        //numbrite ees olevate alakriipsude hulka vähendatakse ühe võrra;
        rex = /_(?=\d)/;
        nmVal = nmVal.replace(rex, "");

        //[+] (EVS-is) on ainult ms alguses (valikuline liitsõnapiir);
        rex = new RegExp("\\[\\" + msLsp + "\\]", "g");
        nmVal = nmVal.replace(rex, msLsp);

        var vt = "%"; //'EVS-is ms alguses, tähistab viidet;
        if (nmVal.substr(0, 1) == vt) { //EVS
            i = nmVal.indexOf("_");
            if (i > 0) {
                //EVS viidete korral toimib järjestus ainult kuni alakriipsudeni;
                nmVal = nmVal.substr(1, i - 1) + vt;
            } else {
                nmVal = nmVal.substr(1) + vt;
            }
        }
    }

    if (msLsp.length > 0) {
        //lsp - dest jäetakse viimane ja esimene alles, kuna määravad järjestust (liitsõnapiiridega sõnad on viimased);
        rex = new RegExp("(?!^)\\" + msLsp + "(?!($|_))", "g");
        nmVal = nmVal.replace(rex, "")

        //märksõna alguse liitsõnapiir viiakse lõppu (vajadusel _te ette);
        if (nmVal.substr(0, 1) == msLsp) {
            i = nmVal.indexOf("_");
            if (i > -1) {
                nmVal = nmVal.substr(1, i - 1) + msLsp + nmVal.substr(i);
            } else {
                nmVal = nmVal.substr(1) + msLsp;
            }
        }
    }

    //_ ei võeta maha, kuna määrab järjestust
    var MSSV_PUNCT = "_" + msLsp;
    if (dic_desc == "evs") {
        MSSV_PUNCT += " ";
    }

    //    if (dic_desc == "od_" || dic_desc == "its") {
    //        MSSV_PUNCT += "0123456789";
    //    }

    //    // transliteration
    //    // enam-vähem kõik ladina tähed, akuudid, põikipulgad jne
    //    var tr_from = CAP_LETT_LA + REG_LETT_LA;
    //    var tr_to = BASIC_LA //"tõlgib eesti keelde" ... (Š, Ž, ÕÄÖÜ jäävad nendeks samadeks);
    //    for (i = 0; i < tr_from.length; i++) {
    //        nmVal = jsReplace(nmVal, tr_from.charAt(i), tr_to.charAt(i));
    //    }

    //    // need, mida pole 'CAP_LETT_LA'-s;
    //    var eriT6lk, eriVaste;
    //    eriT6lk = "Å"; //'ongström;
    //    eriVaste = "A";
    //    for (i = 0; i < eriT6lk.length; i++) {
    //        nmVal = jsReplace(nmVal, eriT6lk.charAt(i), eriVaste.charAt(i));
    //    }

    for (i = 0; i < msTranslSrc.length; i++) {
        if (i < msTranslDst.length) {
            nmVal = nmVal.replace(msTranslSrc.charAt(i), msTranslDst.charAt(i));
        }
        else {
            nmVal = nmVal.replace(msTranslSrc.charAt(i), "");
        }
    }


    // lubatud = MSSV_PUNCT + CAP_LETT_ET + REG_LETT_ET + CAP_LETT_RU + REG_LETT_RU;
    var lubatud = MSSV_PUNCT + msAlpha;

    //Nüüd kõik liigsed sümbolid maha ...
    var newVal = "";
    for (i = 0; i < nmVal.length; i++) {
        if (lubatud.indexOf(nmVal.charAt(i)) > -1) {
            newVal += nmVal.charAt(i);
        }
    }
    if (newVal == "") //'polnud ühtegi lubatud tähte
        newVal = "A"; //'et midagi oleks ja oleks kohe ees nähtaval
    nmVal = newVal;

    // sõnaalguline 'h' ei lähe arvesse, kusjuures ilma 'h'-ta kuju peab olema eeespool ('aab' 'haab')
    // peale märkide eemaldamist ...
    if (dic_desc == "ems") {
        while (nmVal.substr(0, 1).toLowerCase() == "h") {
            nmVal = nmVal.substr(1);
        }
    }

    var psVal;
    //f - fraseologismid
    if (oMNode.getAttribute(DICPR + ":liik") == "f") {
        //@ps - põhisõna;
        psVal = oMNode.getAttribute(DICPR + ":ps");
        if (psVal) {
            nmVal = psVal + "^" + nmVal;
        }
    }

    //y - ühendid
    if (yvOrder && oMNode.getAttribute(DICPR + ":liik") == "y") {
        //@ps - põhisõna;
        psVal = oMNode.getAttribute(DICPR + ":ps");
        if (psVal) {
            nmVal = psVal + "^^" + nmVal;
        } else {
            if (dic_desc == "evs") {
                nmVal = nmVal.substr(nmVal.indexOf(" ") + 1) + " " + nmVal.substr(0, nmVal.indexOf(" "));
            }
        }
    }

    //hom-nr MSSV lõppu
    var hnr = oMNode.getAttribute(qn_homnr);
    if (inclHoms && hnr) {
        // Tehakse ainult kohanimeraamatu (knr) korral.;
        if (dic_desc == "knr") {
            if (hnr.length == 1) {
                hnr = "0" + hnr;
            }
        }
        if ((msLsp.length > 0) && (nmVal.charAt(nmVal.length - 1) == msLsp)) {
            nmVal = nmVal.substr(0, nmVal.length - 1) + hnr + msLsp;
        } else {
            nmVal = nmVal + hnr;
        }
    }

    return nmVal;

} //getSortVal



// praegu - 21juun12 - ainult art.cgi (IE)
// 
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
/** 
* Lisab valmispäringud funktsiooniga LisaKoondParing. Valmispäringud on siin funktsioonis. Ainult art.cgi (IE).
*
* @method valmisParingud
*/
function valmisParingud() {

    //'class = 'mi'; id = sFullPath; value = 'qname|name|URI|IsElement|kirjeldav', name po "", kirjeldav näitab, mis valitud
    //'id, val, tekst, submenu
    //'Toimetamist vajavad keeleplokid
    //par: rowId, rowVal, cellText1, subMenu
    //§h:KL and (not(.//h:xp[@xml:lang = 'ru']) || .//h:xp[@xml:lang = 'ru' and not(@h:aKL)])

    //LisaKoondParing("q:A/.//q:avk[%s] || .//q:lvk[%s] || .//q:qvk[%s] || .//q:svk[%s] || .//q:evk[%s]",  //                    "q:avk, q:evk, q:lvk, q:qvk, q:svk||" + DICURI + "|0|vormilühendid",  //                    "Vormilühendid (q:avk, q:evk, q:lvk, q:qvk, q:svk)",  //                    "")
    //atribuutide alusel
    //LisaKoondParing("q:A/.//*[@q:liik=""d""][%s]", "@q:liik=""d""|||0|tuletised", "Tuletised (@q:liik=""d"")", "")
    //LisaKoondParing("q:A/.//*[@q:anto=""ap""][%s]", "@q:anto=""ap""|||0|anto-paarid", "Anto-paarid (@q:anto=""ap"")", "")
    //LisaKoondParing("q:A/.//*[@q:soov=""hv""][%s]", "@q:soov=""hv""|||0|soov-paarid: {} vasakul", "Soov-paarid: {} vasakul (@q:soov=""hv"")", "")
    //LisaKoondParing("q:A/.//*[@q:soov=""ep""][%s]", "@q:soov=""ep""|||0|soov-paarid: ""parem:""", "Soov-paarid: ""parem:"" (@q:soov=""ep"")", "")
    //LisaKoondParing("q:A/.//*[@q:soov=""np""][%s]", "@q:soov=""np""|||0|soov-paarid: ""parem kui""", "Soov-paarid: ""parem kui"" (@q:soov=""np"")", "")

    //suvaline element
    //LisaKoondParing("q:A/.//*[%s]", "*|||0|ükskõik milline element", "*", "")

    if (asuKoht.indexOf("/__shs_test/") < 0) {
        if (qryMethodOrg == "MySql") {
            //            LisaKoondParing("SELECT ss1.md AS md, msid.ms AS l, msid.ms_att_i AS ms_att_i, msid.ms_att_liik AS ms_att_liik, msid.ms_att_ps AS ms_att_ps, msid.ms_att_tyyp AS ms_att_tyyp, msid.ms_att_mliik AS ms_att_mliik, msid.ms_att_k AS ms_att_k, msid.ms_att_mm AS ms_att_mm, msid.ms_att_st AS ms_att_st, msid.ms_att_vm AS ms_att_vm, msid.ms_att_all AS ms_att_all, msid.ms_att_uus AS ms_att_uus, msid.ms_att_zs AS ms_att_zs, msid.ms_att_u AS ms_att_u, msid.ms_att_em AS ms_att_em, ss1.G AS G, ss1.art AS art, ss1.K AS K, ss1.KL AS KL, ss1.T AS T, ss1.TA AS TA, ss1.TL AS TL, ss1.PT AS PT, ss1.PTA AS PTA, ss1.vol_nr AS vol_nr FROM msid, ss1 WHERE (msid.dic_code = 'ss1' AND ss1.vol_nr [%köiteTing%] AND ([%msVäli%] IN (SELECT [%msVäli%] FROM msid WHERE msid.dic_code = 'psv' AND msid.vol_nr > 0 AND [%msVäli%] LIKE [%t])) AND ss1.G = msid.G) ORDER BY ss1.vol_nr, ss1.ms_att_OO",
            //                "s:m||" + DICURI + "|0|märksõnad, mis sisalduvad PSV-s|MySql",
            //                "Märksõnad, mis sisalduvad PSV-s    <--    'tingimus'",
            //                BLACK_RIGHT_POINTING_POINTER);
            LisaKoondParing("mySqlYhisedMs",
                "||" + DICURI + "|0|Ühised märksõnad: `" + dic_desc + "`|MySql",
                "Ühised märksõnad: `" + dic_desc + "` ja ...",
                BLACK_RIGHT_POINTING_POINTER);
        }
    }

    if (dic_desc == "har") {
        LisaKoondParing("h:A/h:KL and (not(.//h:xp[@xml:lang = \"[%t]\"]) || .//h:xp[@xml:lang = \"[%t]\" and not(@h:aKL)])",
            "h:A||" + DICURI + "|0|koostamata keeleplokid",
            "Koostamata keeleplokid    <--    'xml:lang'", 
            "");
    } else if (dic_desc == "psv") {
        LisaKoondParing("c:A/.//c:m[%s] or .//c:m/@c:ps[%s]",
            "c:m||" + DICURI + "|0|märksõna ja tema ühendid|XML",
            "Märksõna ja tema ühendid (c:m või c:m/@s:ps)    <--    'märksõna'",
            "");
    } else if (dic_desc == "qs_") {
        //suvaline element
        LisaKoondParing("q:A/.//*[%s]",
            "*|||0|ükskõik milline element|XML",
            "*", 
            "");
    } else if (dic_desc == "ss_") {
        LisaKoondParing("s:A/.//s:m[%s] or .//s:m/@s:ps[%s]",
            "s:m||" + DICURI + "|0|märksõna ja tema ühendid|XML",
            "Märksõna ja tema ühendid (s:m või s:m/@s:ps)    <--    'lemma'", 
            "");
    } else if (dic_desc == "ss1") {
        LisaKoondParing("s:A/.//s:m[%s] or .//s:m/@s:ps[%s]",
            "s:m||" + DICURI + "|0|märksõna ja tema ühendid|XML",
            "Märksõna ja tema ühendid (s:m või s:m/@s:ps)    <--    'lemma'",
            "");
    }

} // valmisParingud;

/** 
* Müstiline funktsioon, mida kasutatakse funktsioonis valmisParingud. Ainult art.cgi (IE).
*
* @method LisaKoondParing
* @param {String} rowId 
* @param {String} rowVal
* @param {String} cellText1
* @param {String} subMenu
*/
function LisaKoondParing(rowId, rowVal, cellText1, subMenu) {
    var oNewTableRow, oNewRowCell;

    oNewTableRow = oElMenuTable.insertRow();
    oNewTableRow.className = "mi";
    oNewTableRow.id = rowId;
    oNewTableRow.setAttribute("value", rowVal);

    oNewRowCell = oNewTableRow.insertCell();
    oNewRowCell.colSpan = 4;
    oNewRowCell.innerText = cellText1;

    oNewRowCell = oNewTableRow.insertCell();
    oNewRowCell.innerHTML = subMenu;
} //LisaKoondParing


