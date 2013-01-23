
//-------------------------------uuemad ------------------------------------------
function getMajors(yldStruNode, editDomNode) {
    var useRequiredStr = yldStruNode.getAttribute("pr_sd:useRequired");
    if (useRequiredStr) {
        useRequiredStr = useRequiredStr.substr(1, useRequiredStr.length - 2); // semikoolonid alguses ja lõpus
        var useRequired = useRequiredStr.split(";");
        for (var ix2 in useRequired) {
            var requiredAttr = yldStruNode.attributes.getNamedItem(useRequired[ix2]);
            var newAttr = editDomNode.attributes.setNamedItem(oEditDOM.importNode(requiredAttr, true));
            getReqValue(newAttr, requiredAttr);
        }
    }
    if (yldStruNode.getAttribute("pr_sd:ct") != 2) { // 1, 3, ''
        getReqValue(editDomNode, yldStruNode);
    }
    var majorElements = yldStruNode.selectNodes("*[@pr_sd:major = '1']");
    for (var ix = 0; ix < majorElements.length; ix++) {
        var majorElement = majorElements[ix];
        var frDocNode = editDomNode.appendChild(oEditDOM.createNode(NODE_ELEMENT, majorElement.nodeName, DICURI));
        getMajors(majorElement, frDocNode);
    }
} // getMajors


//-------------------------------   edit värk ---------------------------------------
//-----------------------------------------------------------------------------------
//-------------------------------   vanad   -----------------------------------------
//-----------------------------------------------------------------------------------
function HandleEditClick() {
    var tnode, gspq, tarr;
    var frdoc, refnode;
    var lisanimed, t2, lisanode;
    var i, chkNode, chkNodes, osel;

    var xh, oRespDom, sta, elXml, aenode

    var oSrc = window.event.srcElement;

    //parandamisel vaate stiilis:
    //entiteedid pannakase kaldkirjas, alakaareke mingi teise (MS Mincho) fondiga;
    //hiirega saab pihta ainult "I" - le, "B" - le või "FONT" - ile; osa spane on em teisendustest
    if ((oSrc.tagName == "FONT" || oSrc.tagName == "B" || oSrc.tagName == "I")) {
        oSrc = oSrc.parentElement;
    }

    //siinne 'LI' saab olla ainult toimetamisala 'LI'
    //xsl1 - s ei ole LI-del id-sid, SP uuel toimetamisel (17juun11) on ja vaates tehakse halliks terve vastav 'LI'
    if (oSrc.tagName == "SPAN" || oSrc.tagName == "LI") {
        oClicked = oSrc;
        if (oClicked.className == "delatt") {
            var attElement = oClicked.nextSibling;
            var attId = attElement.id;
            if (attId) {
                var attXmlNode = oEditDOMRoot.selectSingleNode(attId);
                if (attXmlNode) {
                    var attrOwner = attXmlNode.selectSingleNode("..");
                    attrOwner.removeAttributeNode(attXmlNode);
                    setATTAPlokid(attrOwner);
                    vaatedRefresh(2);
                    return;
                }
            }
        }
        if (trueIfrDocClick && jsTrim(oClicked.id).length > 0) {
            SetIfrViewElement();
        }
        SetVars();
        if (clEditable) {
            SetEdits();
        }
    } else if (oSrc.tagName == "UL") {
        //SP, 17juun11

    } else if (oSrc.tagName == "IMG") {
        //0 - creategrupp/addgrupp/addlisad/dellisad ... kinniLahti ...;
        //1 - MIDA luua/lisada (QN);
        //2 - rajaID;
        tarr = oSrc.id.split("|");

        var frDocRoot, yldStruNode, lisatavad, lisatav;

        if (tarr[0] == "creategrupp" || tarr[0] == "addgrupp" || tarr[0] == "addlisad" || tarr[0] == "dellisad" || tarr[0] == "delgrupp" || tarr[0] == "addAllLisad" || tarr[0] == "kinniLahti") {

            tnode = oEditDOMRoot.selectSingleNode(tarr[2])

            var tooEtte = '', plNr, oEditObj;

            if (tarr[0] == "kinniLahti") {
                //SP, 24. juuni 2011;
                var edO, avatud, edOAttr;
                edO = tnode.getAttribute(DICPR + ":edO");
                if ((edO == "1")) {
                    avatud = "0";
                } else {
                    avatud = "1";
                }
                edOAttr = oEditDOM.createNode(NODE_ATTRIBUTE, DICPR + ":edO", DICURI);
                edOAttr.text = avatud;
                tnode.attributes.setNamedItem(edOAttr);
                setATTAPlokid(tnode);
                vaatedRefresh(2);
            } else if (tarr[0] == "creategrupp") {
                //GetSchemaPosQuery: following-sibling nimed
                gspq = GetSchemaPosQuery(tnode, tarr[1]);
                if (gspq != "Ei saa") {
                    if (gspq == "Suvaline" || gspq == "/..") {
                        refnode = null;
                    } else {
                        refnode = tnode.selectSingleNode(gspq);
                    }
                    if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                        frdoc = oEditDOM.createDocumentFragment();
                        frDocRoot = frdoc.appendChild(oEditDOM.createNode(NODE_ELEMENT, tarr[1], DICURI));
                        yldStruNode = yldStruDom.selectSingleNode(".//" + tarr[1]);
                        getMajors(yldStruNode, frDocRoot);
                        lisatav = frDocRoot;
                    }
                    else {
                        lisatav = GetAddElementFromFile(tarr[1], DICURI);
                    }
                    tnode.insertBefore(lisatav, refnode);
                    AddGruppChecks(lisatav);  //@nrl, tähendusnumbrite ümberarvutused;
                    setATTAPlokid(lisatav);
                    vaatedRefresh(2);
                }
            } else if (tarr[0] == "addgrupp") {
                refnode = tnode.nextSibling;
                if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                    frdoc = oEditDOM.createDocumentFragment();
                    frDocRoot = frdoc.appendChild(oEditDOM.createNode(NODE_ELEMENT, tnode.nodeName, DICURI));
                    yldStruNode = yldStruDom.selectSingleNode(".//" + tnode.nodeName);
                    getMajors(yldStruNode, frDocRoot);
                    lisatav = frDocRoot;
                }
                else {
                    lisatav = GetAddElementFromFile(tnode.nodeName, DICURI);
                }
                tnode.parentNode.insertBefore(lisatav, refnode);
                AddGruppChecks(lisatav);  //@nrl, tähendusnumbrite ümberarvutused;
                tooEtte = tarr[2];
                tooEtte = tooEtte.sub(0, tooEtte.length - 1);  //lõpu ] maha;
                plNr = tooEtte.substr(tooEtte.lastIndexOf("[") + 1);
                tooEtte = tooEtte.substr(0, tooEtte.lastIndexOf("[")) + "[" + parseInt(plNr + 1) + "]";
                setATTAPlokid(lisatav);
                vaatedRefresh(2);
            } else if (tarr[0] == "addlisad") {
                lisanimed = ";";
                chkNodes = tnode.selectNodes("*");
                for (i = 0; i < chkNodes.length; i++) {
                    chkNode = chkNodes[i];
                    lisanimed += chkNode.nodeName + ";";
                }
                if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                    yldStruNode = yldStruDom.selectSingleNode(".//" + tnode.nodeName);
                    // [not(@pr_sd:ct = '2')]
                    lisatavad = yldStruNode.selectNodes("*");
                    for (i = 0; i < lisatavad.length; i++) {
                        lisatav = lisatavad[i];
                        if (lisanimed.indexOf(';' + lisatav.nodeName + ';') < 0) {
                            gspq = GetSchemaPosQuery(tnode, lisatav.nodeName);
                            if (gspq != "Ei saa") {
                                if (gspq == "Suvaline" || gspq == "/..") {
                                    refnode = null;
                                } else {
                                    refnode = tnode.selectSingleNode(gspq);
                                }
                                aenode = oEditDOM.createNode(NODE_ELEMENT, lisatav.nodeName, DICURI);
                                getMajors(lisatav, aenode);
                                lisanode = tnode.insertBefore(aenode, refnode);
                            }
                        }
                    }
                }
                else {
                    frdoc = IDD("file", "xml/" + dic_desc + "/al_" + unName(tnode.nodeName) + ".xml", false, false, null);
                    if (frdoc.parseError.errorCode == 0) {
                        lisatavad = frdoc.documentElement.text.split('|');
                        for (i = 0; i < lisatavad.length; i++) {
                            if (lisanimed.indexOf(';' + lisatavad[i] + ';') < 0) {
                                gspq = GetSchemaPosQuery(tnode, lisatavad[i]);
                                if (gspq != "Ei saa") {
                                    if (gspq == "Suvaline" || gspq == "/..") {
                                        refnode = null;
                                    } else {
                                        refnode = tnode.selectSingleNode(gspq);
                                    }
                                    aenode = oEditDOM.createNode(NODE_ELEMENT, lisatavad[i], DICURI);
                                    AddEmptyTexts(aenode);
                                    lisanode = tnode.insertBefore(aenode, refnode);
                                }
                            }
                        }
                    } else {
                        alert(frdoc.parseError.reason);
                        return;
                    }
                }
                setATTAPlokid(tnode);
                vaatedRefresh(2);
            } else if (tarr[0] == "addAllLisad") { // ainult sp_ ?
                lisanimed = ";";
                chkNodes = tnode.selectNodes("*");
                for (i = 0; i < chkNodes.length; i++) {
                    chkNode = chkNodes[i];
                    lisanimed = lisanimed + chkNode.nodeName + ";";
                }
                //15. juuli 2011;
                //aeglase internetiühenduse okkaline tee...;
                // Kõu ühendus:;
                // Läbiviimise aeg: 15.07.2011 00:27:45;
                // Kliendi IP-aadress: 77.233.84.152;
                // Kliendi AS-number (päringu tekitajat ja teenusepakkujat identifitseeriv info): IP-aadress ei kuulu ühegi autonoomse süsteemi (AS) alla;
                // Testi tüüp: Java;
                // Üleslaadimise kiirus: 121.21 kbit/sek;
                // Allalaadimise kiirus: 807.99 kbit/sek;
                var aalNode, aalAlamNode;
                aalNode = yldStruDom.documentElement.selectSingleNode(".//" + tnode.nodeName);
                var aalAlamNoded = aalNode.selectNodes("*");
                for (i = 0; i < aalAlamNoded.length; i++) {
                    aalAlamNode = aalAlamNoded[i];
                    if ((lisanimed.indexOf(";" + aalAlamNode.nodeName + ";") < 0)) {
                        aenode = GetAddElementFromFile(aalAlamNode.nodeName, DICURI);
                        gspq = GetSchemaPosQuery(tnode, aenode.nodeName);
                        if (!(gspq == "Ei saa")) {
                            if ((gspq == "Suvaline")) {
                                refnode = null;
                            } else {
                                refnode = tnode.selectSingleNode(gspq);
                            }
                            lisanode = tnode.insertBefore(aenode, refnode);
                        }
                    }
                }
                setATTAPlokid(tnode);
                vaatedRefresh(2);
            } else if (tarr[0] == "dellisad") {
                osel = tnode.selectNodes("*[normalize-space(.) = '']");
                osel.removeAll();
                setATTAPlokid(tnode);
                vaatedRefresh(2);
            } else if (tarr[0] == "delgrupp") {
                tnode.parentNode.removeChild(tnode);
                setATTAPlokid(tnode);
                vaatedRefresh(2);
            }

            //        if((Len(tooEtte) > 0)){
            //  oEditObj = oEditAll(tooEtte)
            //   if(! (oEditObj == null)){
            //    oEditObj.scrollIntoView()
            //            }
            //        }
        } else if (tarr[0] == "addAttr") {

            tnode = oEditDOMRoot.selectSingleNode(tarr[2])

            var newAttr, newId, newLang, newElem;

            if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                yldStruNode = yldStruDom.selectSingleNode(".//" + tnode.nodeName);
                var lisatavAttr = yldStruNode.attributes.getNamedItem(tarr[1]);
                newAttr = tnode.attributes.setNamedItem(oEditDOM.importNode(lisatavAttr, true));
            }
            else {
                newAttr = tnode.attributes.setNamedItem(oEditDOM.createNode(NODE_ATTRIBUTE, tarr[1], DICURI));
            }

            setATTAPlokid(tnode);

            selectedNode = newAttr;
            fatherNode = selectedNode.selectSingleNode(".."); //'atribuudil ei ole parentNode-t;
            snDecl = oXmlSc.getDeclaration(selectedNode);

            if (newAttr.value == '') {
                if (snDecl.type.enumeration.length == 1) {
                    newAttr.value = snDecl.type.enumeration[0];
                }
            }

            newId = tarr[2] + "/@" + tarr[1];

            vaatedRefresh(2);

            newElem = oEditAll(newId);
            newElem.focus();
            newElem.click();

            //newId = tarr[2] + "/@" + tarr[1];
            //newLang = tnode.transformNode(strLangXsl);
            //oSrc.outerHTML = "<span id='" + newId + "' class='at at_" + unName(tarr[1]) + " edit' style='width:16px;background-color:white;border:black 1px solid;font-family:\"Times New Roman\";' lang='" + newLang + "'></span>";
            //oEditAll("ifrdiv").setAttribute("xmlChanged", 1);
            //newElem = document.all(newId);
            //newElem.focus();
            //newElem.click();

        } else if ((tarr[0] == "sndListen")) {
            var nX, nY;
            nX = event.clientX;
            nY = event.clientY - (div_ArtJWPlayerImage.style.pixelWidth / 2); // ico on ruudukujuline, height asemel width
            div_ArtJWPlayerImage.style.pixelLeft = nX;
            div_ArtJWPlayerImage.style.pixelTop = nY;
            tnode = oEditDOMRoot.selectSingleNode(tarr[2]);
            var flvFile = "__sr/" + dic_desc + "/__heli/" + tnode.text;
            var opts = {
                autostart: true,
                flashplayer: "html/jwplayer/player.swf",
                file: flvFile,
                controlbar: "none",
                icons: false,
                wmode: "transparent",
                width: 0,
                height: 0,
                events: { onError: function (event) { sndError(event); }, onPlay: function (event) { sndStarted(event); }, onComplete: function () { sndCompleted(); } }
            };
            jwplayer("div_ArtJWPlayer").setup(opts);
        }
    } else if ((oSrc.tagName == "A")) {
        window.open(oSrc.href, oSrc.target);
        window.event.returnValue = false;
    }
} //HandleEditClick


//-----------------------------------------------------------------------------------
function sndError(evnt) {
    div_ArtJWPlayerImage.style.display = "none";
    alert(evnt.message);
}


//-----------------------------------------------------------------------------------
function sndStarted(evnt) {
    div_ArtJWPlayerImage.style.display = "";
    //    alert('started:\n' + evnt.oldstate);
}


//-----------------------------------------------------------------------------------
function sndCompleted() {
    div_ArtJWPlayerImage.style.display = "none";
}


//-----------------------------------------------------------------------------------
function SetIfrViewElement() {
    if (!(ivde == null)) {
        ivde.style.backgroundColor = ivdebgc;
    }
    ivde = oViewAll(oClicked.id);
    if (!(ivde == null)) {
        ivdebgc = ivde.style.backgroundColor;
        ivde.style.backgroundColor = "silver";
        ivde.scrollIntoView();
    }
} //SetIfrViewElement


//-----------------------------------------------------------------------------------
function SetVars() {

    scv = oClicked.innerText

    elemlang = oClicked.lang

    nodepath = oClicked.id;
    if ((jsMid(nodepath, 0, 5) == "HTML:")) {
        nodepath = jsMid(nodepath, nodepath.indexOf("/") + 1);
    }
    spn_NodeInfo.innerText = nodepath

    var tarr;
    tarr = oClicked.className.split(" ");
    //"ehitatud" elementidel on struktuur, tühja koha klikkamine ei tohi pahandusi tekitada
    //className peab alati koosnema vähemalt 3-st
    if ((tarr.length > 2)) {
        clType = jsLeft(tarr[0], 2) //et, etx1, etvw jt;
    } else {
        clType = "";
        clEditable = false;
        clickedNode = null;
        selectedNode = null
        snDecl = null;
        fatherNode = null;
        pnDecl = null;
        snQName = "";
        cmHeading = "";
        snKirjeldavQName = "";
        spn_NodeInfo.title = "[" + oClicked.tagName + ": " + snKirjeldavQName + "]: lang: '" + elemlang + "'; className: '" + oClicked.className + "'";
        return;
    }


    //clickedNode mõte on eristada #text erinevaid tükke elementide sees

    //väärtuse klikkamisel on:
    //elemendi teksti korral on clickedNode-iks #text ning selectedNode-ks element ise
    //atribuudi teksti korral on nii clickedNode-iks kui ka selectedNode-ks atribuut ise
    //kommentaari teksti korral on clickedNode-iks #comment ning selectedNode-ks element, milles kommentaar paikneb

    //nime klikkamisel on:
    //nii elemendi kui ka atribuudi (praegu - 20mai 2006 - pole) nime korral on clickedNode-ks ja selectedNode-ks
    //element või atribuut ise

    //fatherNode on:
    //elemendi korral elemendi parentElement
    //atribuudi korral element, millele atribuut kuulub

    if (nodepath) { //'nt ec ("element create") korral = ""
        var xsdPath, xsdNode, sPr;

        //viga juhul, kui clickedNode on null, nt ANY sees mitte ettenähtud element ??;
        clickedNode = oEditDOMRoot.selectSingleNode(nodepath);
        if (clickedNode.nodeType == NODE_TEXT || clickedNode.nodeType == NODE_COMMENT || clickedNode.nodeType == NODE_CDATA_SECTION) {
            selectedNode = clickedNode.parentNode;
        } else {
            selectedNode = clickedNode;
        }
        fatherNode = selectedNode.selectSingleNode(".."); //'atribuudil ei ole parentNode-t

        try {
            //viga juhul, kui elementi skeemis pole ...;
            snDecl = oXmlSc.getDeclaration(selectedNode);
            if (!(snDecl.namespaceURI == "")) {
                sPr = oXmlNsm.getPrefixes(snDecl.namespaceURI).item(0);
                if ((sPr == "")) {
                    snQName = snDecl.name;
                } else {
                    snQName = sPr + ":" + snDecl.name;
                }
            } else {
                snQName = snDecl.name;
            }
            if (snDecl.itemType == SOMITEM_ELEMENT) {
                xsdPath = ".//" + NS_XS_PR + ":element[@name='" + snDecl.name + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + sAppLang + "']";
            } else if ((snDecl.itemType == SOMITEM_ATTRIBUTE)) {
                xsdPath = ".//" + NS_XS_PR + ":attribute[@name='" + snDecl.name + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + sAppLang + "']";
            }
            xsdNode = oXsdDOM.documentElement.selectSingleNode(xsdPath);
            if (xsdNode) {
                cmHeading = jsReplace(jsTrim(xsdNode.text), ";", "");
            } else {
                cmHeading = snQName;
            }
            snKirjeldavQName = cmHeading + " (";
            if (snDecl.itemType == SOMITEM_ATTRIBUTE) {
                snKirjeldavQName = snKirjeldavQName + "@";
            }
            snKirjeldavQName = snKirjeldavQName + snQName + ")"
        }
        catch (e) {
            snDecl = null;
            snQName = clickedNode.nodeName;
            cmHeading = snQName;
            snKirjeldavQName = cmHeading;
        }

        try {
            //juhul, kui elementi skeemis pole ...;
            pnDecl = oXmlSc.getDeclaration(fatherNode);
        }
        catch (e) {
            pnDecl = null;
        }

        if ((clType == "en" || clType == "an")) {
            cmHeading = "'" + cmHeading + "'";
        } else if ((clType == "et" || clType == "ct")) {
            cmHeading = "'" + cmHeading + "' " + jsMid(nodepath, nodepath.lastIndexOf("/") + 1);
        } else if ((clType == "at")) {
            cmHeading = "'@" + cmHeading + "' " + VALUE_WORD;
        }
        spn_NodeInfo.title = "[" + oClicked.tagName + ": " + snKirjeldavQName + "]: lang: '" + elemlang + "'; className: '" + oClicked.className + "'; nodeType: " + clickedNode.nodeType + " (" + clickedNode.nodeTypeString + ")"

    } else { //nt ec ("element create") korral = "";
        clickedNode = null;
        selectedNode = null
        snDecl = null;
        fatherNode = null;
        pnDecl = null;
        snQName = "";
        cmHeading = "";
        snKirjeldavQName = "";
        spn_NodeInfo.title = "[" + oClicked.tagName + ": " + snKirjeldavQName + "]: lang: '" + elemlang + "'; className: '" + oClicked.className + "'";
        return;
    }

    var elemNoEditOtsitav, attrNoEditOtsitav;
    if (neElems.indexOf("/") > -1) {
        elemNoEditOtsitav = fatherNode.nodeName + "/" + selectedNode.nodeName;
    } else {
        elemNoEditOtsitav = selectedNode.nodeName;
    }
    if (neAttribs.indexOf("/") > -1) {
        attrNoEditOtsitav = fatherNode.nodeName + "/@" + selectedNode.nodeName;
    } else {
        attrNoEditOtsitav = selectedNode.nodeName;
    }
    clEditable = false;
    if (!(clickedNode == null)) {
        //teiste (NODE_ELEMENT, NODE_COMMENT, NODE_CDATA_SECTION, ...) vt eespool;
        if ((clickedNode.nodeType == NODE_TEXT)) {
            if (!(tarr[2] == "noedit")) {
                clEditable = true;
            }
            if ((neElems.indexOf(";" + elemNoEditOtsitav + ";") > -1)) {
                clEditable = false;
            }
        } else if ((clickedNode.nodeType == NODE_ATTRIBUTE)) {
            if (!(tarr[2] == "noedit")) {
                clEditable = true;
            }
            if ((neAttribs.indexOf(";" + attrNoEditOtsitav + ";") > -1)) {
                clEditable = false;
            }
        }
        if ((clickedNode.nodeType == NODE_TEXT || clickedNode.nodeType == NODE_ATTRIBUTE)) {
            if ((zeus.indexOf(";" + sUsrName + ";") > -1)) {
                clEditable = true;
            }
            if ((window.event.ctrlLeft && eeLexAdmin.indexOf(";" + sUsrName + ";") > -1)) {
                clEditable = true;
            }
        }
    }

} //SetVars


//-----------------------------------------------------------------------------------
function SetEdits() {
    if (snDecl == null) {
        return;
    }

    var cee, optstr, selind, i, oType, xsdPath, xsdNode, optTitle; // <julius> lisatud alates 'oType' kuni 'optTitle'
    cee = oClicked;

    oClickedBorder = oClicked.style.border;
    if (oClickedBorder == "") {
        oClickedBorder = jsTrim(oClicked.currentStyle.borderColor + " " + oClicked.currentStyle.borderWidth + " " + oClicked.currentStyle.borderStyle);
    }


    //mT - meedia tüüp
    var smdArgs, retVal, mT = '', tyybiFail, importDOM;

    oClicked.style.border = "red 2px solid";
    optstr = "";
    selind = -1;

    if (selectedNode.nodeType == NODE_ELEMENT) {
        if (snQName != "x:link") { // its::<link> elemendil on küll @mT, kuid parandada tuleb @href ennast
            mT = selectedNode.getAttribute(DICPR + ":mT"); //'Pärtel Lippus - foneetika terminite sõnastik, pildifail;
            if (!mT) {
                mT = "";
            }
        }
    } else if (selectedNode.nodeType == NODE_ATTRIBUTE) { // 'its' link/@href
        //        if (selectedNode.baseName == 'href') {
        //            mT = fatherNode.getAttribute(DICPR + ":mT");
        //        }
    }

    if (mT == "") {
        if (snQName == "n:aa") { //'Eesti kohanimeraamat: kirjandus; teos: autor aasta;
            mT = "pikkLoend";
        } else if (snQName == "x:stn") { // its: standard
            mT = "pikkLoend";
        } else if (snQName == "c:vbf") { //'põhisõnavara sõnastik; viipe fail;
            mT = "flashPlayer";
        } else if (snQName == "x:pilt") { //'its pilt <pilt>
            mT = "flashPlayerImage";
        } else if (snQName == "x:dst") { //'its: link pildile iref/@dst
            mT = "flashPlayerImage";
        }
    } else {
        if (mT == "img") { //'pilt;
            mT = "flashPlayerImage";
        } else if (mT == "f?v") {
            mT = "flashPlayer";
        } else if (mT == "snd") {
            mT = "flashPlayerSound";
        }
    }

    if (!trueIfrDocClick) {
        if (mT != "") {
            oClicked.style.border = oClickedBorder
            return;
        }
    }

    //oType, tyybiFail, importDOM
    if ((snDecl.type.enumeration.length > 0)) {
        if ((snDecl.type.name == "")) {
            oType = snDecl.type.baseTypes[0];
        } else {
            oType = snDecl.type;
        }
        if ((oType.namespaceURI != DICURI)) {
            tyybiFail = "xsd/" + impSchemaLocations.item(oType.namespaceURI);
            importDOM = IDD("File", tyybiFail, false, false, null);
            importDOM.setProperty("SelectionLanguage", "XPath");
            importDOM.setProperty("SelectionNamespaces", jsTrim(sXsdNsList));
        } else {
            tyybiFail = "xsd/schema_" + dic_desc + ".xsd";
            importDOM = oXsdDOM;
        }
    }

    if (mT == "pikkLoend") {
        smdArgs = new Array(dic_desc, tyybiFail, oType.name, scv, sAppLang);
        retVal = window.showModalDialog("html/listingLoend.htm", smdArgs, "dialogHeight:300px;dialogWidth:1024px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
        oClicked.style.border = oClickedBorder;
        if (retVal != scv && retVal != null) {
            clickedNode.nodeValue = retVal;
            oClicked.innerText = retVal;
            updMuudatused("S", retVal);
            ValueChecks(retVal, scv) //märksõna, hom.nr, kom;
            vaatedRefresh(1);
        }
        return;
    } else if (mT == "flashPlayer") {
        smdArgs = new Array(dic_desc, sAppLang, sUsrName, scv, "/__video/");
        retVal = window.showModalDialog("html/showVideo.htm", smdArgs, "dialogHeight:600px;dialogWidth:800px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
        oClicked.style.border = oClickedBorder;
        if (retVal) {
            if (retVal != scv) {
                clickedNode.nodeValue = retVal;
                oClicked.innerText = retVal;
                updMuudatused("S", retVal);
                vaatedRefresh(1);
            }
        }
        return;
    } else if (mT == "flashPlayerImage") {
        smdArgs = new Array(dic_desc, sAppLang, sUsrName, scv, "/__pildid/");
        retVal = window.showModalDialog("html/showVideo.htm", smdArgs, "dialogHeight:600px;dialogWidth:800px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
        oClicked.style.border = oClickedBorder;
        if (retVal) {
            if (retVal != scv) {
                clickedNode.nodeValue = retVal;
                oClicked.innerText = retVal;
                updMuudatused("S", retVal);
                vaatedRefresh(1);
            }
        }
        return;
    } else if ((mT == "flashPlayerSound")) {
        smdArgs = new Array(dic_desc, sAppLang, sUsrName, scv, "/__heli/");
        retVal = window.showModalDialog("html/showVideo.htm", smdArgs, "dialogHeight:600px;dialogWidth:800px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
        oClicked.style.border = oClickedBorder;
        if (retVal) {
            if (retVal != scv) {
                clickedNode.nodeValue = retVal;
                oClicked.innerText = retVal;
                updMuudatused("S", retVal);
                vaatedRefresh(1);
            }
        }
        return;
    } else if ((snDecl.type.enumeration.length > 0)) {
        for (i = 0; i < snDecl.type.enumeration.length; i++) {
            xsdPath = NS_XS_PR + ":simpleType[@name = '" + oType.name + "']//" + NS_XS_PR + ":enumeration[@value = '" + snDecl.type.enumeration[i] + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang = '" + sAppLang + "']";
            xsdNode = importDOM.documentElement.selectSingleNode(xsdPath);
            optTitle = snDecl.type.enumeration[i];
            if (xsdNode) {
                optTitle = optTitle + " - " + jsTrim(xsdNode.text);
                if (dest_language) {
                    xsdPath = NS_XS_PR + ":simpleType[@name = '" + oType.name + "']//" + NS_XS_PR + ":enumeration[@value='" + snDecl.type.enumeration[i] + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + dest_language + "']";
                    xsdNode = importDOM.documentElement.selectSingleNode(xsdPath);
                    if (xsdNode) {
                        optTitle = optTitle + " / " + jsTrim(xsdNode.text);
                    }
                }
            }
            optstr = optstr + "<option id='" + snDecl.type.enumeration[i] + "'>" + optTitle + "</option>";
            if ((snDecl.type.enumeration[i] == scv)) {
                selind = i + 1; //sest ette tuleb veel tühi;
            }
        } // for
        oClicked.innerHTML = "<select id='oClickedSelect' style='width:10cm;' name='oClickedSelect' tabIndex='0'>" + "<option id=''></option>" + optstr + "</select>";
        cee = oClicked.all("oClickedSelect");
        if ((selind > -1)) {
            cee.options(selind).selected = true;
        }
    } else if ((snDecl.name == "lang" && snDecl.namespaceURI == NS_XML)) {
        optstr = getKeeledOptString(scv);
        oClicked.innerHTML = "<select id='oClickedSelect' name='oClickedSelect' tabIndex='0'>" + "<option id=''></option>" + optstr + "</select>";
        cee = oClicked.all("oClickedSelect");
    } else if ((snDecl.type.itemType == SOMITEM_DATATYPE_BOOLEAN)) {
        optstr = optstr + "<option id='false'>ei  - false</option>";
        optstr = optstr + "<option id='true'>jah - true</option>";
        if ((scv == "false")) {
            selind = 1; //sest ette tuleb veel tühi;
        } else if ((scv == "true")) {
            selind = 2; //sest ette tuleb veel tühi;
        }
        oClicked.innerHTML = "<select id='oClickedSelect' name='oClickedSelect' tabIndex='0'>" + "<option id=''></option>" + optstr + "</select>";
        cee = oClicked.all("oClickedSelect");
        if ((selind > -1)) {
            cee.options(selind).selected = true;
        }
    } else {
        var pte, textRng, textRects, spWidth, spRows;
        pte = oClicked.parentTextEdit;
        textRng = pte.createTextRange();
        textRng.moveToElementText(oClicked);
        textRects = textRng.getClientRects();

        spRows = textRects.length;

        if (!(oXslEdit === oXsl2)) {
            spWidth = oClicked.offsetWidth;
            if ((spRows == 1)) {
                spWidth = spWidth + 25; //textArea scrollbar laius on ca 23;
            }
            //tühja välja korral viskab miskipärast kasti paremale ...;
            if ((spWidth < (document.body.clientWidth * 0.5))) {
                spWidth = parseInt(document.body.clientWidth * 0.5);
            }
        } else {
            spWidth = oClicked.parentElement.offsetWidth + 32;
            if ((spWidth < 64)) {
                spWidth = 64;
            }
        }
        spRows = spRows + 1;
        if (spRows > 8) {
            spRows = 8;
        }

        var taStyle = 'width:' + spWidth + 'px;';
        //        if (textEditFont) {
        //            taStyle += 'font-family:"' + textEditFont + '";';
        //        }
        oClicked.innerHTML = "<TEXTAREA id='oClickedTextArea' name='oClickedTextArea' " + "style='" + taStyle + "' rows='" + spRows + "' tabIndex='0'>" + scv + "</TEXTAREA>";
        cee = oClicked.all("oClickedTextArea");

        if (scv == "-???-" || scv == "|???|" || scv == "|vaste|" || scv == "|tõlge|") {
            cee.select();
        }
    }

    cee.onblur = HandleCeeBlur;
    cee.onfocus = ceeOnFocus;
    cee.setActive();
    cee.focus();

} //SetEdits


//-----------------------------------------------------------------------------------
function vbSetKBLang(l) {
    //siin tulevad nüüd need 3-tähelised keelekoodid, tavaliselt on nad mingi keele alamosa
    if (l == "vro") { //'võru
        l = "et";
    } else if (l == "mhr") { //'mari;
        l = "ru";
    } else if (l == "x-mhr") { //'mari;
        l = "ru";
    } else if (l == "mrj") { //'mari;
        l = "ru";
    } else if (l == "ex") { //'Eesti-X;
        return;
    }
    var sta, msgSisu;
    try {
        sta = eelexSWCtl.setKeyboardLayout(l);
        if (sta < -1) {
            //-1: vigased sisendparameetrid;
            //-2: ei leitud locale-t (nt Windows XP-s on locale name 'null'!);
            //-3: ei leitud klaviatuuri paigutust;
            msgSisu = "<img src='graphics/error.ico' width='16'><b>setKeyboardLayout:</b> " + sta;
            spn_msg.innerHTML = msgSisu;
        }
    }
    catch (e) {
        //        alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.");
    }
} //vbSetKBLang


//-----------------------------------------------------------------------------------
function inp_ElemTextOnFocus() {
    var kbLang;
    if ((setKeyboard)) {
        if ((mnuElemLang.length > 0)) {
            kbLang = mnuElemLang;
        } else {
            kbLang = orgKBLayoutLang;
        }
        vbSetKBLang(kbLang);
    }
} //inp_ElemTextOnFocus


//-----------------------------------------------------------------------------------
function ceeOnFocus() {
    var oSrc = window.event.srcElement;
    if (oSrc.id == "oClickedTextArea") {
        if (setKeyboard) {
            vbSetKBLang(elemlang);
        }
    }
} //ceeOnFocus


//-----------------------------------------------------------------------------------
function documentOnFocusOut() {
    if ((setKeyboard)) {
        if (!document.hasFocus()) {
            vbSetKBLang(orgKBLayoutLang);
        }
    }
} //documentOnFocusOut


//-----------------------------------------------------------------------------------
function HandleCeeBlur() {
    var nsv; //new span value

    var oBlur = window.event.srcElement;

    var checkSta = false, kontrollida = true;

    if (oBlur.tagName == "SELECT") {
        if (oBlur.selectedIndex > -1) {
            nsv = oBlur.options(oBlur.selectedIndex).id;
        } else {
            nsv = scv; //vana väärtus tagasi;
        }
        kontrollida = false;
    } else if (oBlur.id == "oClickedTextArea") {
        //        nsv = jsTrim(oBlur.value);
        nsv = jsTrim(oBlur.innerText);
        if (!(nsv == "" && scv == "")) {
            //ISchemaElement.type.isvalid(...) ei tööta nt ComplexType-i korral;
            if ((snDecl.type.itemType == SOMITEM_COMPLEXTYPE)) {
                if ((snDecl.type.contentType == SCHEMACONTENTTYPE_MIXED)) {
                    checkSta = CheckCeeValue(nsv, "string");
                } else if ((snDecl.type.contentType == SCHEMACONTENTTYPE_ELEMENTONLY)) { //nt kommentaar elemendi sees;
                    checkSta = CheckCeeValue(nsv, "string");
                } else if ((snDecl.type.contentType == SCHEMACONTENTTYPE_TEXTONLY)) {
                    if ((snDecl.type.baseTypes.length > 0)) {
                        checkSta = CheckCeeValue(nsv, snDecl.type.baseTypes[0].name);
                    } else {
                        checkSta = CheckCeeValue(nsv, "string");
                    }
                }
            } else if ((snDecl.type.itemType == SOMITEM_SIMPLETYPE)) { //kui element on mittestandardse tüübiga (type = ...);
                checkSta = CheckCeeValue(nsv, snDecl.type.baseTypes[0].name);
            } else if ((snDecl.type.itemType == SOMITEM_DATATYPE_DATETIME)) {
                checkSta = CheckCeeValue(nsv, "dateTime");
            } else if ((snDecl.type.itemType == SOMITEM_DATATYPE_POSITIVEINTEGER)) {
                checkSta = CheckCeeValue(nsv, "positiveInteger");
            } else if ((snDecl.type.itemType == SOMITEM_DATATYPE_UNSIGNEDBYTE)) {
                checkSta = CheckCeeValue(nsv, "positiveInteger");
            } else if ((snDecl.type.itemType == SOMITEM_DATATYPE_DECIMAL)) {
                nsv = jsReplace(nsv, ",", ".");
                oBlur.value = nsv;
                checkSta = CheckCeeValue(nsv, "decimal");
            } else if ((snDecl.type.itemType == SOMITEM_DATATYPE_STRING)) {
                checkSta = CheckCeeValue(nsv, "string");
            }
            if (!(checkSta)) {
                oBlur.setActive();
                oBlur.focus();
                oBlur.select();
                return;
            }
        }
    }

    oBlur.onfocus = null;
    oBlur.onblur = null;
    oBlur = null;
    oClicked.style.border = oClickedBorder;

    oClicked.innerText = scv;

    if (nsv != scv) {

        if (kontrollida) {
            nsv = tekstiTeisendused(nsv);
        }

        clickedNode.nodeValue = nsv;
        oClicked.innerText = nsv;

        updMuudatused("S", nsv);

        ValueChecks(nsv, scv);  //märksõna, hom.nr, kom;

        vaatedRefresh(2);
    }

    oClicked.focus();

} //HandleCeeBlur


//-----------------------------------------------------------------------------------
function vaatedRefresh(nr) {
    var oclid;
    if (oClicked) {
        oclid = oClicked.id;
    }

    oEditAll("ifrdiv").setAttribute("xmlChanged", nr);
    if (oclid) {
        oClicked = oEditAll(oclid);
    }
    if (oViewAll("_copyDiv") == null) {
        if (dic_desc == "evs") {
            var domCopy;
            domCopy = oEditDOM.cloneNode(true);
            TeisendaDOM(domCopy);
            oViewAll("ifrviewdiv").innerHTML = domCopy.transformNode(oXslView);
        } else {
            oViewAll("ifrviewdiv").innerHTML = oEditDOM.transformNode(oXslView);
        }
    }
} //vaatedRefresh


//-----------------------------------------------------------------------------------
function CheckCeeValue(chkvalue, dt) {
    var CheckCeeValue;
    var spellValue;
    var rex;
    switch (dt) {
        case "positiveInteger":
            var posintvalue = true;
            if (isNaN(chkvalue)) {
                posintvalue = false;
            } else {
                if ((parseInt(chkvalue) < 1 || chkvalue.indexOf(".") > -1 || chkvalue.indexOf(",") > -1)) {
                    posintvalue = false;
                }
            }
            if (!(posintvalue)) {
                alert(REQUIRED_POS_INT, jsvbCritical, snKirjeldavQName);
            }
            CheckCeeValue = posintvalue;
            break;
        case "decimal":
            CheckCeeValue = !isNaN(chkvalue);
            break;
        case "dateTime":
            rex = /^\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}$/;
            if (chkvalue.match(rex)) {
                CheckCeeValue = true;
            } else {
                alert(REQUIRED_DATE_TIME);
                CheckCeeValue = false;
            }
            break;
        case "string":
            if ((doSpellCheck)) {
                var sta, nameLocal, msgSisu;
                nameLocal = jsStrRepeat(255, String.fromCharCode(0));
                try {
                    sta = eelexSWCtl.mySpellCheck(chkvalue, elemlang, nameLocal);
                    if ((sta == 0)) {
                        msgSisu = "<img src='graphics/warning.ico' width='16'> " + CHECK_SPELLING + "<b>" + chkvalue + "</b>, " + LANGUAGE_WORD + "'" + elemlang + "' (" + nameLocal + ")!";
                        spn_msg.innerHTML = msgSisu;
                    } else if ((sta == 1)) {
                        spn_msg.innerHTML = '';
                    } else {
                        //-1: vigased sisendparameetrid;
                        //-2: ei leitud locale-t (nt Windows XP-s on locale name 'null'!);
                        //-3: puudub MS Word;
                        //-4: pole local-le vastavat Word language-t;
                        //-5: puudub antud keelele vastav Wordi õigekirjakontrolli sõnastik (ehk siis speller ei ole installitud);
                        msgSisu = "<img src='graphics/error.ico' width='16'><b>mySpellCheck:</b> " + sta;
                        if ((sta == -3)) {
                            msgSisu = msgSisu + " (puudub MS Office Word).";
                        } else if ((sta == -5)) {
                            msgSisu = msgSisu + " (ei ole installeeritud keelele vastavat õigekirjakontrolli).";
                        }
                        spn_msg.innerHTML = msgSisu;
                    }
                }
                catch (e) {
                    alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description + "'.");
                }
            }
            CheckCeeValue = true;
            break;
        default:
            CheckCeeValue = true;
            break;
    }
    return CheckCeeValue;
} //CheckCeeValue


//-----------------------------------------------------------------------------------
function HandleViewClick() {

    if (ivde) {
        ivde.style.backgroundColor = ivdebgc;
    }

    var oSrc = window.event.srcElement;

    //entiteedid pannakase kaldkirjas, alakaareke mingi teise (MS Mincho) fondiga;
    //hiirega saab pihta ainult "I" - le, "B" - le või "FONT" - ile; osa spane on em teisendustest
    if (oSrc.tagName == "FONT" || oSrc.tagName == "B" || oSrc.tagName == "I" || oSrc.tagName == "U") {
        oSrc = oSrc.parentElement;
    }

    window.event.returnValue = false;

    var elId, thisElement, msTekst, tNode;
    if (oSrc.tagName == "A") {
        elId = oSrc.parentElement.id; //SPAN id, nt "f:A[1]/f:P[1]/f:mvt[1]/text()[1]";
    } else {
        elId = oSrc.id; //SPAN id, nt "f:A[1]/f:P[1]/f:mvt[1]/text()[1]";
    }
    //HTML:li
    if (jsMid(elId, 0, 5) == "HTML:") {
        elId = elId.substr(elId.indexOf("/") + 1);
    }

    //tekstist üles elemendile
    //kaob elemendi (text()[x])
    if (elId.length > 0) {
        thisElement = oEditDOMRoot.selectSingleNode(elId);
    }
    msTekst = "";

    if (!thisElement) { // nt pildid vaates on ilma ID-ta
        if (oSrc.tagName != "IMG")
            return;
    }

    if (thisElement) { //nt "divFrameView" ei ole
        if (thisElement.nodeType == NODE_TEXT) {
            var tNoded = thisElement.parentNode.selectNodes("text()");
            for (i = 0; i < tNoded.length; i++) {
                msTekst = msTekst + tNoded[i].xml;
            }
        } else if (thisElement.nodeType == NODE_ATTRIBUTE) { // ÕS 2006 mvt/@kuhu
            msTekst = thisElement.value;
        }
        thisElement = thisElement.selectSingleNode(".."); //'teksti v atribuudi pealt üles elemendile;
    }

    if (oSrc.tagName == "A" || (oSrc.tagName == "SPAN" && oSrc.className.indexOf(" lingike") > -1)) {

        if (salvestaJaKatkesta()) {
            return;
        }


        // kui aga klõpsamisel on vaja hoopis näidata pilti (its: iref/@dst)
        var dstAttr, href, fullHREF;
        dstAttr = thisElement.selectSingleNode("@" + DICPR + ":dst");
        if (dstAttr) {
            href = thisElement.getAttribute(DICPR + ":dst");
            fullHREF = asuKoht + '__sr/' + dic_desc + '/__pildid/' + href;
            window.open(fullHREF, '_blank');
            return;
        }
        // its: stn/@href
        dstAttr = thisElement.selectSingleNode("@" + DICPR + ":href");
        if (dstAttr) {
            href = thisElement.getAttribute(DICPR + ":href");
            window.open(href, '_blank');
            return;
        }


        // nt har viidatakse artiklis 'performance' märksõnale 'happening', mis on tsitaatsõna (liik='z')
        // teistes aga vsl: 'pentaad' -> 'pent-'

        var qM;
        qM = "MySql";
        //Ctrl + click on IE-8 uue saki avamise otsetee (?), nagunii ei töötaks <a> korral;
        //<a> tuleks teha <span style=cursor:hand>;
        if (oSrc.tagName == "SPAN" && window.event.ctrlLeft) {
            qM = "XML";
        }

        sQryInfo = jsTrim(msTekst);

        var kfAttr, gAttr;
        kfAttr = thisElement.selectSingleNode("@" + DICPR + ":KF"); // # "ief1" jne
        if (kfAttr == null) {
            kfAttr = thisElement.selectSingleNode("@" + DICPR + ":aKF");
        }
        gAttr = thisElement.selectSingleNode("@" + DICPR + ":g");
        if (gAttr == null) {
            gAttr = thisElement.selectSingleNode("@" + DICPR + ":aG");
        }
        //combo valikust saadud andmed ...;
        if (!(kfAttr == null || gAttr == null)) {
            var kf, g;
            kf = kfAttr.text; //nt "ief1";
            g = gAttr.text;

            sCmdId = "BrowseRead"

            sPrmDomXml = "<prm>" +
                             "<cmd>" + sCmdId + "</cmd>" +
                             "<vol>" + kf + "</vol>" +
                             "<nfo>" + sQryInfo + "</nfo>" +
                             "<G>" + g + "</G>" +
                             "<qM>" + qM + "</qM>" +
                         "</prm>";

            oPrmDom = IDD("String", sPrmDomXml, false, false, null);
            if ((oPrmDom.parseError.errorCode != 0)) {
                ShowXMLParseError(oPrmDom);
                return;
            }
            StartOperation(oPrmDom)

        } else {

            var i, vahemik;
            //vajalik köide paika!;
            //(vali "Kõik köited");
            //(sel_Vol.selectedIndex = sel_Vol.options.length - 2);
            if (dic_vols_count > 1) {
                var oConfigDOM, vollid, otsad;
                oConfigDOM = IDD("File", "shsconfig_" + dic_desc + ".xml", false, false, null);
                if (oConfigDOM.parseError.errorCode != 0) {
                    ShowXMLParseError(oConfigDOM);
                    return;
                }
                vollid = oConfigDOM.documentElement.selectNodes("vols/vol");
                for (i = 0; i < vollid.length; i++) {
                    vahemik = vollid[i].text;
                    // PSV teine köide 'AB' artiklid: <vol nr="2">AB: A - Y</vol>
                    if (vahemik.indexOf(":") > -1) {
                        vahemik = jsTrim(vahemik.substr(vahemik.indexOf(":") + 1));
                    }
                    otsad = vahemik.split(" - ");
                    if (((jsStrComp(jsLeft(RemoveSymbols(msTekst, " "), otsad[0].length), otsad[0], 1) >= 0) && (jsStrComp(jsLeft(RemoveSymbols(msTekst, " "), otsad[1].length), otsad[1], 1) <= 0))) {
                        sel_Vol.selectedIndex = i;
                        break;
                    }
                }
                oConfigDOM = null;
            }

            var vHomTing, homNrNode, mySqlMsAttCond;
            vHomTing = "";
            mySqlMsAttCond = "";
            //<mvt>  -viide märksõnale; <lvt> - SP-s viide pereliikmele;
            homNrNode = thisElement.selectSingleNode("@" + DICPR + ":iv");
            if (homNrNode == null) {
                homNrNode = thisElement.selectSingleNode(DICPR + ":vhom");
            }
            if (homNrNode == null) {
                //sõnaperedes ja SS1-s <mvt> küljes;
                homNrNode = thisElement.selectSingleNode("@" + DICPR + ":i");
            }
            if (homNrNode) {
                vHomTing = "[@" + DICPR + ":i = '" + homNrNode.text + "']";
            }

            var qn, otsitav = msTekst;
            if (thisElement.baseName == "lvt") { // sp_ viide pereliikmele
                qn = DICPR + ":ml";
                if (vHomTing.length > 0) {
                    //lähtutud SP pereliikmete @i, temale viidatakse <lvt> abil;
                    mySqlMsAttCond = " AND atribuudid_" + dic_desc + ".nimi = '" + DICPR + ":i'" + " AND atribuudid_" + dic_desc + ".val = '" + homNrNode.text + "'" + " AND atribuudid_" + dic_desc + ".elG = elemendid_" + dic_desc + ".elG";
                }
            } else if (thisElement.baseName == "mstvt") { // its viide mõistele
                qn = DICPR + ":Gmst";
                otsitav = thisElement.getAttribute(DICPR + ":Gmst");
            } else {
                qn = qn_ms;
                if ((vHomTing.length > 0)) {
                    mySqlMsAttCond = " AND msid.ms_att_i = " + homNrNode.text;
                }
            }

            if (!otsitav)
                return;

            //tuleb märkidega ja tõstutundlik otsing (Liivi-saksas tõstutundetu);
            var srchPtrn = getSrPn2(otsitav, "XML")

            var elpred, arttingimus, art_xpath, elm_xpath, evPath, pQrySql;
            var withCase, withSymbols;
            withSymbols = "1";
            withCase = "1";
            elpred = "[. = " + GCV(otsitav, "", 2) + "]";
            if ((dic_desc == "ldw")) {
                withCase = "0";
                elpred = "[al_p:srch(.) > 0]";
            }

            arttingimus = ".//" + qn + vHomTing + elpred;
            art_xpath = jsMid(default_query, 0, default_query.indexOf("/")) + "[" + arttingimus + "]";
            elm_xpath = arttingimus;
            evPath = ".//" + qn + vHomTing + "/text()";

            pQrySql = getSqlQuery(qn, otsitav, true, withSymbols, withCase, evPath, "", mySqlMsAttCond);

            sCmdId = "ClientRead";

            var sPrmDomXml, oPrmDom

            showDbgVar("elpred", elpred, "HandleViewClick", "lõpp", " ", new Date());
            showDbgVar("arttingimus", arttingimus, "HandleViewClick", "lõpp", " ", new Date());
            showDbgVar("art_xpath", art_xpath, "HandleViewClick", "lõpp", " ", new Date());
            showDbgVar("elm_xpath", elm_xpath, "HandleViewClick", "lõpp", " ", new Date());
            showDbgVar("srchPtrn", srchPtrn, "HandleViewClick", "lõpp", " ", new Date());
            showDbgVar("pQrySql", pQrySql, "HandleViewClick", "lõpp", " ", new Date());
            showDbgVar("evPath", evPath, "HandleViewClick", "lõpp", " ", new Date());
            showDbgVar("qM", qM, "HandleViewClick", "lõpp", " ", new Date())

            sPrmDomXml = "<prm>" +
                            "<cmd>" + sCmdId + "</cmd>" +
                            "<vol>" + sel_Vol.options(sel_Vol.selectedIndex).id + "</vol>" +
                            "<nfo>" + sQryInfo + "</nfo>" +
                            "<axp>" + art_xpath + "</axp>" +
                            "<exp>" + elm_xpath + "</exp>" +
                            "<wC>" + withCase + "</wC>" +
                            "<wS>" + withSymbols + "</wS>" +
                            "<fSrP>" + srchPtrn + "</fSrP>" +
                            "<qn>" + qn + "</qn>" +
                            "<qM>" + qM + "</qM>" +
                            "<pQrySql>" + pQrySql + "</pQrySql>" +
                         "</prm>";

            oPrmDom = IDD("String", sPrmDomXml, false, false, null);
            if ((oPrmDom.parseError.errorCode != 0)) {
                ShowXMLParseError(oPrmDom);
                return;
            }
            StartOperation(oPrmDom)

        }

    } else if ((oSrc.tagName == "SPAN")) {
        //korraliku ID qn pärast;
        if ((oSrc.id.length > 0)) {
            if ((oSrc.id.indexOf(":") > -1)) {

                ivde = oSrc;

                ivdebgc = ivde.style.backgroundColor;
                ivde.style.backgroundColor = "silver"

                var oEditObj, edOAttr, oliKinni;
                oEditObj = oEditAll(ivde.id);
                if (oEditObj) {
                    oEditObj.scrollIntoView();
                    divFrameEdit.doScroll("up");
                    oEditObj.setActive();
                    oEditObj.focus();
                    trueIfrDocClick = false;
                    oEditObj.click();
                    trueIfrDocClick = true;
                } else {
                    edOAttr = oEditDOM.createNode(NODE_ATTRIBUTE, DICPR + ":edO", DICURI);
                    edOAttr.value = "1";
                    oliKinni = false;
                    tNode = thisElement.selectSingleNode("ancestor::*[@" + DICPR + ":edO = '0']");
                    while (tNode != null) {
                        tNode.attributes.setNamedItem(edOAttr.cloneNode(true));
                        oliKinni = true;
                        tNode = tNode.selectSingleNode("ancestor::*[@" + DICPR + ":edO = '0']");
                    }
                    if (oliKinni) {
                        vaatedRefresh(2);
                        oEditObj = oEditAll(ivde.id);
                        if (oEditObj) {
                            oEditObj.scrollIntoView();
                            divFrameEdit.doScroll("up");
                            oEditObj.setActive();
                            oEditObj.focus();
                            trueIfrDocClick = false;
                            oEditObj.click();
                            trueIfrDocClick = true;
                        }
                    }
                }

            }
        }
    } else if ((oSrc.tagName == "IMG")) {
        if ((oSrc.id == "exit_copy")) {
            if ((dic_desc == "evs")) {
                var domCopy;
                domCopy = oEditDOM.cloneNode(true);
                TeisendaDOM(domCopy);
                oViewAll("ifrviewdiv").innerHTML = domCopy.transformNode(oXslView);
            } else {
                oViewAll("ifrviewdiv").innerHTML = oEditDOM.transformNode(oXslView);
            }
        }
        else {
            window.open(oSrc.src, '_blank');
        }
    }

} //HandleViewClick


//-----------------------------------------------------------------------------------
function HandleViewContextClick() {
    if ((window.event.ctrlLeft && window.event.shiftLeft && window.event.AltLeft)) {
        return;
    }
    window.event.returnValue = false;
} //HandleViewContextClick


//Otsinguteksti kasti kontekstmenüü
//-----------------------------------------------------------------------------------
function HandleWindowContextClick() {
    var i, cmhtml, smhtml;
    var srcx, srcy, mdivs, mheight;
    var mvh, mvv //menüü horis, vertik vahe;
    mvh = 60;
    mvv = 20;

    contextClicked = window.event.srcElement;
    window.event.returnValue = false

    cmhtml = "";
    cmhtml = cmhtml + insert_symbols.innerHTML;
    if ((cmhtml != "")) {
        cmhtml = "<div style='width:100%' class='md'>#text</div>" + cmhtml;
    }
    tn_cmenu.innerHTML = cmhtml;
    if ((tn_cmenu.innerHTML != "")) {
        if ((window.event.clientX + tn_cmenu.style.pixelWidth + insert_entities.style.pixelWidth + big_character.style.pixelWidth / 2 + mvh > window.document.body.clientWidth)) {
            srcx = window.event.screenX - (tn_cmenu.style.pixelWidth + mvh);
        } else {
            srcx = window.event.screenX + mvh;
        }
        mdivs = tn_cmenu.all.tags("DIV").length;
        mheight = (mdivs * 16) + 6;
        if ((window.event.clientY + mheight + mvv > window.document.body.clientHeight)) {
            srcy = window.event.screenY - window.screenTop - (mheight + mvv);
        } else {
            srcy = window.event.screenY - window.screenTop + mvv;
        }
        DisplayTNCMenu(srcx, srcy) //läheb pixelLeft-i ja pixelTop-i;
    }
} //HandleWindowContextClick


//teksti (textarea) kontekstmenüü
//-----------------------------------------------------------------------------------
function HandleContextClick() {
    if (window.event.ctrlLeft && window.event.shiftLeft && window.event.AltLeft) {
        return;
    }

    window.event.returnValue = false;

    var i, delimwidth, delimline;
    //110px / 26 kriipsu (55/13)~4
    delimwidth = tn_cmenu.style.pixelWidth / 16;
    delimline = "";
    for (i = 0; i < delimwidth; i++) {
        delimline = delimline + EN_DASH;
    }

    var oSrc, cmhtml, smhtml, elc, assembleAndComplete;
    var subelem, thisinfo, tarr;
    var mvh, mvv //menüü horis, vertik vahe;
    mvh = 60;
    mvv = 20

    var srcx, srcy, mdivs, mheight, rng;

    oSrc = window.event.srcElement

    //parandamisel vaate stiilis:
    //entiteedid pannakase kaldkirjas, alakaareke mingi teise (MS Mincho) fondiga;
    //hiirega saab pihta ainult "I" - le, "B" - le või "FONT" - ile; osa spane on em teisendustest
    if ((oSrc.tagName == "FONT" || oSrc.tagName == "B" || oSrc.tagName == "I" || oSrc.tagName == "U")) {
        oSrc = oSrc.parentElement;
    }

    assembleAndComplete = false;

    if (oSrc.tagName == "SPAN" || oSrc.tagName == "LI") {
        oClicked = oSrc;
        SetVars();
        cmhtml = "";
        cmenu.innerHTML = cmhtml;
        if (clType == "en" && !(oXslEdit === oXsl3)) {
            sm_before.innerHTML = "";
            sm_insert.innerHTML = "";
            sm_after.innerHTML = "";
            if (!(snDecl == null || pnDecl == null)) {
                GetSubMenus();
            }
            if (!(sm_before.innerHTML == "")) {
                sm_before.innerHTML = "<div style='width:100%' class='md'>'" + MNU_ADD_BEFORE + "'</div>" + sm_before.innerHTML;
                cmhtml = cmhtml + "<div style='width:100%' class='mi' id='add_before'>" + MNU_ADD_BEFORE + "</div>";
            }
            if (!(sm_insert.innerHTML == "" || selectedNode.hasChildNodes())) {
                sm_insert.innerHTML = "<div style='width:100%' class='md'>'" + MNU_ADD_CHILD + "'</div>" + sm_insert.innerHTML;
                cmhtml = cmhtml + "<div style='width:100%' class='mi' id='add_insert'>" + MNU_ADD_CHILD + "</div>";
            }
            if (!(sm_after.innerHTML == "")) {
                sm_after.innerHTML = "<div style='width:100%' class='md'>'" + MNU_ADD_AFTER + "'</div>" + sm_after.innerHTML;
                cmhtml = cmhtml + "<div style='width:100%' class='mi' id='add_after'>" + MNU_ADD_AFTER + "</div>";
            }
            if (snDecl) {
                if (snDecl.type.itemType == SOMITEM_COMPLEXTYPE) {
                    if (snDecl.type.attributes.length > 0) {
                        elc = snDecl.type.attributes.length;
                        smhtml = "";
                        for (i = 0; i < elc; i++) {
                            subelem = snDecl.type.attributes[i];
                            thisinfo = GetElSchemaInfo(subelem);
                            //thisinfo =;
                            //qn(0); item.uri(1); typename(item)(2); typename(item.type)(3);;
                            //item.type.contentType(4); item.type.name(5); item.minOcc(6);;
                            //item.maxOcc(7); kirjeldav(8); item.name(9);
                            tarr = thisinfo.split(";");
                            if (selectedNode.attributes.getNamedItem(tarr[0]) == null) {
                                smhtml = smhtml + "<div style='width:100%' class='mi' " + "id='" + thisinfo + "' " + "title='" + tarr[0] + "'>" + tarr[8] + " (" + tarr[0] + ")</div>";
                            }
                            if (subelem.name == "aK" || subelem.name == "aKL" || subelem.name == "aT" || subelem.name == "aTL") {
                                assembleAndComplete = true;
                            }
                        }
                        sm_attrs.innerHTML = smhtml;
                        if (sm_attrs.innerHTML != "") {
                            sm_attrs.innerHTML = "<div style='width:100%' class='md'>'" + MNU_ADD_ATTRS + "'</div>" + sm_attrs.innerHTML;
                            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='add_attrs'>" + MNU_ADD_ATTRS + "</div>";
                        }
                    }
                }
            }
            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='ren_elem'>" + MNU_RENAME + "</div>";
            if ((dic_desc == "sp_")) {
                if ((clickedNode.baseName == "t")) {
                    if (!(clickedNode.selectSingleNode("preceding-sibling::" + DICPR + ":t") == null)) {
                        cmhtml = cmhtml + "<div style='width:100%' class='mi' id='incr_indent'>" + MNU_INCR_INDENT + "</div>";
                    }
                    if (!(clickedNode.selectSingleNode("ancestor::" + DICPR + ":t") == null)) {
                        cmhtml = cmhtml + "<div style='width:100%' class='mi' id='decr_indent'>" + MNU_DECR_INDENT + "</div>";
                    }
                }
            }
        } // if (clType == "en" && !(oXslEdit === oXsl3)) {

        //Copy/Cut/Paste;
        if (clType == "en" || clType == "et" || clType == "ct") {
            if (cmhtml != "") {
                cmhtml = cmhtml + "<div style='width:100%' class='dl' id='delim1'>" + delimline + "</div>";
            }
            //Cut;
            if ((delNodeAllowed() || window.event.shiftLeft)) {
                if ((clType == "en")) {
                    if ((window.event.ctrlLeft)) {
                        cmhtml = cmhtml + "<div style='width:100%' class='mi' id='cut_node_add'>" + MNU_CUT_ADD + "</div>";
                    } else {
                        cmhtml = cmhtml + "<div style='width:100%' class='mi' id='cut_node'>" + MNU_CUT + "</div>";
                    }
                } else if ((clType == "et" || clType == "ct")) {
                    if ((clEditable)) {
                        if ((window.event.ctrlLeft)) {
                            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='cut_node_add'>" + MNU_CUT_ADD + "</div>";
                        } else {
                            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='cut_node'>" + MNU_CUT + "</div>";
                        }
                    }
                }
            }
            //Copy;
            if ((window.event.ctrlLeft)) {
                cmhtml = cmhtml + "<div style='width:100%' class='mi' id='copy_node_add'>" + MNU_COPY_ADD + "</div>";
            } else {
                cmhtml = cmhtml + "<div style='width:100%' class='mi' id='copy_node'>" + MNU_COPY + "</div>";
            }
            //Paste;
            if ((cpfragment.hasChildNodes)) {
                smhtml = "";
                if ((clType == "en")) {
                    smhtml = smhtml + "<div style='width:100%' class='mi' id='paste_node_before'>" + MNU_PASTE_BEFORE + "</div>";
                    smhtml = smhtml + "<div style='width:100%' class='mi' id='paste_node_insert'>" + MNU_PASTE_CHILD + "</div>";
                    smhtml = smhtml + "<div style='width:100%' class='mi' id='paste_node_insertContent'>Lisa sisse ainult sisu</div>";
                    smhtml = smhtml + "<div style='width:100%' class='mi' id='paste_node_after'>" + MNU_PASTE_AFTER + "</div>";
                    smhtml = smhtml + "<div style='width:100%' class='mi' id='paste_node_over'>" + MNU_PASTE_REPLACE + "</div>";
                } else if ((clType == "et" || clType == "ct")) {
                    smhtml = smhtml + "<div style='width:100%' class='mi' id='paste_node_before'>" + MNU_PASTE_BEFORE + "</div>";
                    smhtml = smhtml + "<div style='width:100%' class='mi' id='paste_node_after'>" + MNU_PASTE_AFTER + "</div>";
                    smhtml = smhtml + "<div style='width:100%' class='mi' id='paste_node_over'>" + MNU_PASTE_REPLACE + "</div>";
                }
                if ((smhtml != "")) {
                    paste_node_options.innerHTML = "<div style='width:100%' class='md'>'" + MNU_PASTE + "'</div>" + smhtml;
                    cmhtml = cmhtml + "<div style='width:100%' class='mi' id='paste_node'>" + MNU_PASTE + "</div>";
                }
            }
        }
        //Delete;
        if (clType == "en" || clType == "et" || clType == "ct" || clType == "at") {
            if (delNodeAllowed() || window.event.shiftLeft) {
                if (cmhtml != "") {
                    cmhtml = cmhtml + "<div style='width:100%' class='dl' id='delim3'>" + delimline + "</div>";
                }
                cmhtml = cmhtml + "<div style='width:100%' class='mi' id='del_self'>" + MNU_DELETE + "</div>";
            }
        }
        //ava kopeerimiseks, lisa XML kommentaar, morf analüüs ja süntees, hulgiparandused, morfofon;
        if (clType == "en") {
            cmhtml = cmhtml + "<div style='width:100%' class='dl' id='delim4'>" + delimline + "</div>";
            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='open_for_copy'>" + MNU_OPEN_FORCOPY + "</div>";
            //     cmhtml = cmhtml + "<div style='width:100%' class='mi' id='comment_this'>" + MNU_ADD_XMLCOMMENT + "</div>"
            if (useMorfo) {
                cmhtml = cmhtml + "<div style='width:100%' class='mi' id='morf_ana'>" + NAME_MORF_ANA + "</div>";
                if (selectedNode.baseName == "m" || selectedNode.baseName == "mf") {
                    cmhtml = cmhtml + "<div style='width:100%' class='mi' id='morf_syn'>" + NAME_MORF_SYN + "</div>";
                }
                if (selectedNode.baseName == "mv" || selectedNode.baseName == "vormid") {
                    cmhtml = cmhtml + "<div style='width:100%' class='mi' id='morf_syn_asenda'>" + NAME_MORF_SYN_ASENDA + "</div>";
                }
            }
            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='openFindReplace'>" + MNU_OPEN_FIND_REPLACE + "</div>";
            if (assembleAndComplete) { // kui klõpsatul on olemas atribuudid aK, aKL, aT, aTL
                //assemble && complete;
                if (document.body.all("aacContMenu") == null) {
                    var aacContMenu = document.body.appendChild(document.createElement("<DIV id='aacContMenu' style='display:none;position:absolute;width:300px;background-color:menu;border:outset 3px gray;onmouseover=\"SwitchCMenu()\" onmouseout=\"SwitchCMenu()\" onclick=\"ClickCMenu()\" oncontextmenu=\"DisableContextMenu()\" onlosecapture=\"HideDivMenu()\"'></DIV>"));
                    aacContMenu.innerHTML = "<div style='width:100%' class='md'>'Koostamise/toimetamise märked'</div>" + "<div style='width:100%' class='mi' id='addAssembleComplete'>Lisa grupile koostamise lõpu märge</div>" + "<div style='width:100%' class='mi' id='remAssembleComplete'>Eemalda grupilt koostamise lõpu märge</div>";
                }
                cmhtml = cmhtml + "<div style='width:100%' class='mi' id='assembleAndComplete'>Koostamise/toimetamise märked</div>";
            }
            // morfofonoloogiline info
            if (selectedNode.baseName == "mg") {
                cmhtml = cmhtml + "<div style='width:100%' class='mi' id='morfofonInfo'>Morfofonoloogiline info</div>";
            }
            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='guuglisse'>Guuglisse</div>";
            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='extLinks'>Välised lingid</div>";
        }
        // pealkiri
        if (cmhtml != "") {
            cmhtml = "<div style='width:100%' class='md' title='" + snQName + "'>" + cmHeading + "</div>" + cmhtml;
        }
        cmenu.innerHTML = cmhtml;
        if (cmenu.innerHTML != "") {
            srcx = tbl_XML.offsetLeft + oEditAll("ifrdiv").offsetLeft + window.event.clientX;
            mdivs = cmenu.all.tags("DIV").length;
            mheight = (mdivs * 16) + 6;
            if ((window.event.clientY + mheight + mvv > document.body.clientHeight)) {
                srcy = window.event.screenY - window.screenTop - (mheight + mvv);
            } else {
                srcy = window.event.screenY - window.screenTop + mvv;
            }
            DisplayCMenu(srcx, srcy);
        }
    } else if (oSrc.id == "oClickedTextArea") {
        contextClicked = oSrc;
        cmhtml = "";
        tn_cmenu.innerHTML = cmhtml

        rng = document.selection.createRange();
        if ((rng.text.length == 0)) {
            if (!(snDecl == null)) {
                if ((snDecl.type.itemType == SOMITEM_COMPLEXTYPE)) {
                    if ((snDecl.type.contentType == SCHEMACONTENTTYPE_MIXED)) {
                        GetTNSubMenus();
                        if ((tn_sm_before.innerHTML != "")) {
                            tn_sm_before.innerHTML = "<div style='width:100%' class='md'>'" + MNU_ADD_BEFORE + "'</div>" + tn_sm_before.innerHTML;
                            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='tn_add_before'>" + MNU_ADD_BEFORE + "</div>";
                        }
                        if ((tn_sm_insert.innerHTML != "")) {
                            tn_sm_insert.innerHTML = "<div style='width:100%' class='md'>'" + MNU_ADD_CHILD + "'</div>" + tn_sm_insert.innerHTML;
                            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='tn_add_insert'>" + MNU_ADD_CHILD + "</div>";
                        }
                        if ((tn_sm_after.innerHTML != "")) {
                            tn_sm_after.innerHTML = "<div style='width:100%' class='md'>'" + MNU_ADD_AFTER + "'</div>" + tn_sm_after.innerHTML;
                            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='tn_add_after'>" + MNU_ADD_AFTER + "</div>";
                        }
                        if ((cmhtml != "")) {
                            cmhtml = cmhtml + "<div style='width:100%' class='dl' id='delim5'>" + delimline + "</div>";
                        }
                        cmhtml = cmhtml + "<div style='width:100%' class='mi' id='del_tn'>" + MNU_DELETE + "</div>";
                    }
                }
            }
        }
        if ((cmhtml != "")) {
            cmhtml = cmhtml + "<div style='width:100%' class='dl' id='delim6'>" + delimline + "</div>";
        }
        cmhtml = cmhtml + insert_symbols.innerHTML;
        if (!(oViewAll("_copyDiv") == null)) {
            cmhtml = cmhtml + "<div style='width:100%' class='mi' id='add_copied'>" + MNU_ADD + " '" + sTextToCopy + "'</div>";
        }
        if ((rng.text.length > 0)) {
            if ((cmhtml != "")) {
                cmhtml = cmhtml + "<div style='width:100%' class='dl' id='delim7'>" + delimline + "</div>";
            }
            cmhtml = cmhtml + "<div style='width:100%' id='editCmds'>" + "<b><span class='mi_span' id='switch_Bold' title='Poolpaks' value='&ba;'>B</span></b>" + "<b><i><span class='mi_span' id='switch_Emph' title='Esiletõstetud' value='&ema;'>I</span></i></b>" + "<b><u><span class='mi_span' id='switch_Underl' title='Allajoonitud' value='&la;'>U</span></u></b>" + "<span class='mi_span' id='switch_SubScr' title='Alaindeks' value='&suba;'>X<sub>n</sub></span>" + "<span class='mi_span' id='switch_SupScr' title='Ülaindeks' value='&supa;'>X<sup>n</sup></span>" + "</div>";
        }
        if ((cmhtml != "")) {
            cmhtml = "<div style='width:100%' class='md'>#text</div>" + cmhtml;
        }
        tn_cmenu.innerHTML = cmhtml;
        if ((tn_cmenu.innerHTML != "")) {
            srcx = tbl_XML.offsetLeft + oEditAll("ifrdiv").offsetLeft + window.event.clientX;
            mdivs = tn_cmenu.all.tags("DIV").length;
            mheight = (mdivs * 16) + 6;
            if ((window.event.screenY - window.screenTop < mheight + mvv)) {
                srcy = window.event.screenY - window.screenTop + mvv;
            } else {
                srcy = window.event.screenY - window.screenTop - (mheight + mvv);
            }
            DisplayTNCMenu(srcx, srcy) //läheb pixelLeft-i ja pixelTop-i;
        }
    }
} //HandleContextClick


//-----------------------------------------------------------------------------------
function GetSubMenus() {
    var prevqn, nextqn

    prevqn = "";
    nextqn = ""

    var tnode
    tnode = selectedNode.selectSingleNode("preceding-sibling::*[1]");
    if (!(tnode == null)) {
        prevqn = tnode.nodeName;
    }
    tnode = selectedNode.selectSingleNode("following-sibling::*[1]");
    if (!(tnode == null)) {
        nextqn = tnode.nodeName;
    }

    var pnqn;
    pnqn = fatherNode.nodeName

    var fparticle
    fparticle = pnDecl.type.contentModel.particles[0]

    var frdoc, anynames, chcount, chmax, smhtml, subelems, subelem, i, tarr

    //GetElSchemaInfo =
    //qn(0); item.uri(1); typename(item)(2); typename(item.type)(3);
    //item.type.contentType(4); item.type.name(5); item.minOcc(6);
    //item.maxOcc(7); kirjeldav(8); item.name(9)

    if ((fparticle.itemType == SOMITEM_ANY)) {
        frdoc = IDD("file", "xml/" + dic_desc + "/aa_" + unName(pnqn) + ".xml", false, false, null);
        if ((frdoc.parseError.errorCode != 0)) {
            return;
        }
        anynames = frdoc.documentElement.text.split("|");
        chcount = XMLChildTagsCount(fatherNode, "*");
        chmax = parseInt(fparticle.maxOccurs);
        smhtml = "";
        if ((chmax == -1 || chcount < chmax)) {
            subelems = new Array(anynames.length);
            for (i = 0; i < anynames.length; i++) {
                subelem = oSchRootElems.itemByQName(jsMid(anynames[i], anynames[i].indexOf(":") + 1), oXmlNsm.getURI(jsMid(anynames[i], 0, anynames[i].indexOf(":"))));
                subelems[i] = GetElSchemaInfo(subelem);
                tarr = subelems[i].split(";");
                smhtml = smhtml + "<div style='width:100%' class='mi' " + "id='" + subelems[i] + "' " + "title='" + tarr[0] + "'>" + tarr[8] + " (" + tarr[0] + ")</div>";
            }
            sm_before.innerHTML = smhtml;
            sm_after.innerHTML = smhtml;
        }
    } else {
        var pncount;
        pncount = pnDecl.type.contentModel.particles.length;
        subelems = new Array(pncount);

        var subqn, elbefind, elselfind, elaftind

        elbefind = 0;
        elselfind = -1;
        elaftind = pncount - 1;
        for (i = 0; i < pncount; i++) {
            subelem = pnDecl.type.contentModel.particles[i];
            subelems[i] = GetElSchemaInfo(subelem);
            subqn = oXmlNsm.getPrefixes(subelem.namespaceURI).item(0) + ":" + subelem.name;
            if ((subqn == prevqn)) {
                elbefind = i;
            }
            if ((subqn == nextqn)) {
                elaftind = i;
            }
            if ((subqn == selectedNode.nodeName)) {
                elselfind = i;
            }
        }
        smhtml = "";
        for (i = elbefind; i <= elselfind; i++) {
            tarr = subelems[i].split(";");
            chcount = XMLChildTagsCount(fatherNode, tarr[0]);
            chmax = parseInt(tarr[7]);
            if ((chmax == -1 || chcount < chmax)) {
                smhtml = smhtml + "<div style='width:100%' class='mi' " + "id='" + subelems[i] + "' " + "title='" + tarr[0] + "'>" + tarr[8] + " (" + tarr[0] + ")</div>";
            }
        }
        sm_before.innerHTML = smhtml;
        smhtml = "";
        //kui element on vales kohas (nt impordi tõttu);
        if ((elselfind > -1)) {
            for (i = elselfind; i <= elaftind; i++) {
                tarr = subelems[i].split(";");
                chcount = XMLChildTagsCount(fatherNode, tarr[0]);
                chmax = parseInt(tarr[7]);
                if ((chmax == -1 || chcount < chmax)) {
                    smhtml = smhtml + "<div style='width:100%' class='mi' " + "id='" + subelems[i] + "' " + "title='" + tarr[0] + "'>" + tarr[8] + " (" + tarr[0] + ")</div>";
                }
            }
        }
        sm_after.innerHTML = smhtml;
    }

    prevqn = ""
    tnode = selectedNode.previousSibling;
    if (!(tnode == null)) {
        prevqn = tnode.nodeName;
    }
    nextqn = ""
    tnode = selectedNode.nextSibling;
    if (!(tnode == null)) {
        nextqn = tnode.nodeName;
    }

    var dokpath, doku, kirjeldav

    if ((pnDecl.type.contentType == SCHEMACONTENTTYPE_MIXED)) {
        dokpath = ".//" + NS_XS_PR + ":element[@name='" + pnDecl.name + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + sAppLang + "']";
        doku = oXsdDOM.documentElement.selectSingleNode(dokpath);
        if (!(doku == null)) {
            kirjeldav = jsReplace(jsTrim(doku.text), ";", "");
        } else {
            kirjeldav = pnqn;
        }
        if (!(prevqn == "#text")) {
            smhtml = "<div style='width:100%' class='mi' " + "id='#text' " + "title='#text'>'" + kirjeldav + "' (" + pnqn + ") #tekst</div>";
            sm_before.innerHTML = sm_before.innerHTML + smhtml;
        }
        if (!(nextqn == "#text")) {
            smhtml = "<div style='width:100%' class='mi' " + "id='#text' " + "title='#text'>'" + kirjeldav + "' (" + pnqn + ") #tekst</div>";
            sm_after.innerHTML = sm_after.innerHTML + smhtml;
        }
    }

    var thisinfo;
    if ((snDecl.type.itemType == SOMITEM_COMPLEXTYPE)) {
        if ((snDecl.type.contentModel.particles.length > 0)) {
            smhtml = "";
            fparticle = snDecl.type.contentModel.particles[0];
            pnqn = snQName;
            if ((fparticle.itemType == SOMITEM_ANY)) {
                frdoc = IDD("file", "xml/" + dic_desc + "/aa_" + unName(pnqn) + ".xml", false, false, null);
                if ((frdoc.parseError.errorCode != 0)) {
                    return;
                }
                anynames = frdoc.documentElement.text.split("|");
                for (i = 0; i < anynames.length; i++) {
                    subelem = oSchRootElems.itemByQName(jsMid(anynames[i], anynames[i].indexOf(":") + 1), oXmlNsm.getURI(jsMid(anynames[i], 0, anynames[i].indexOf(":"))));
                    thisinfo = GetElSchemaInfo(subelem);
                    tarr = thisinfo.split(";");
                    smhtml = smhtml + "<div style='width:100%' class='mi' " + "id='" + thisinfo + "' " + "title='" + tarr[0] + "'>" + tarr[8] + " (" + tarr[0] + ")</div>";
                }
            } else {
                pncount = snDecl.type.contentModel.particles.length;
                for (i = 0; i < pncount; i++) {
                    subelem = snDecl.type.contentModel.particles[i];
                    thisinfo = GetElSchemaInfo(subelem);
                    tarr = thisinfo.split(";");
                    smhtml = smhtml + "<div style='width:100%' class='mi' " + "id='" + thisinfo + "' " + "title='" + tarr[0] + "'>" + tarr[8] + " (" + tarr[0] + ")</div>";
                }
            }
            if ((snDecl.type.contentType == SCHEMACONTENTTYPE_MIXED)) {
                smhtml = smhtml + "<div style='width:100%' class='mi' " + "id='#text' " + "title='#text'>'" + snKirjeldavQName + "' #tekst</div>";
            }
            sm_insert.innerHTML = smhtml;
        }
    }
} //GetSubMenus


//-----------------------------------------------------------------------------------
function GetElSchemaInfo(thisitem) {
    var thisinfo, qn, dokpath, doku, kirjeldav;

    thisinfo = "";
    dokpath = "";

    if ((thisitem.itemType == SOMITEM_ELEMENT)) {
        qn = oXmlNsm.getPrefixes(thisitem.namespaceURI).item(0) + ":" + thisitem.name;
        if ((thisitem.type.itemType == SOMITEM_COMPLEXTYPE)) {
            thisinfo = qn + ";" + thisitem.namespaceURI + ";" + thisitem.itemType + ";" + thisitem.type.itemType + ";" + thisitem.type.contentType + ";" + thisitem.type.name + ";" + thisitem.minOccurs + ";" + thisitem.maxOccurs;
        } else {
            // if ((thisitem.type.itemType == SOMITEM_SIMPLETYPE))
            thisinfo = qn + ";" + thisitem.namespaceURI + ";" + thisitem.itemType + ";" + thisitem.type.itemType + ";" + ";" + thisitem.type.name + ";" + thisitem.minOccurs + ";" + thisitem.maxOccurs;
        }
        dokpath = ".//" + NS_XS_PR + ":element[@name='" + thisitem.name + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + sAppLang + "']";
    } else if ((thisitem.itemType == SOMITEM_ATTRIBUTE)) {
        qn = oXmlNsm.getPrefixes(thisitem.namespaceURI).item(0) + ":" + thisitem.name;
        thisinfo = qn + ";" + thisitem.namespaceURI + ";" + thisitem.itemType + ";" + thisitem.type.itemType + ";" + thisitem.type.derivedBy + ";" + thisitem.type.baseTypes.length + ";" + thisitem.type.enumeration.length + ";" + thisitem.use;
        dokpath = ".//" + NS_XS_PR + ":attribute[@name='" + thisitem.name + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + sAppLang + "']";
    }
    doku = oXsdDOM.documentElement.selectSingleNode(dokpath);
    if (!(doku == null)) {
        kirjeldav = jsReplace(jsTrim(doku.firstChild.nodeValue), ";", "");
    } else {
        kirjeldav = qn;
    }
    thisinfo = thisinfo + ";" + kirjeldav + ";" + thisitem.name;
    return thisinfo;
} //GetElSchemaInfo


//-----------------------------------------------------------------------------------
function delNodeAllowed() {
    var delNodeAllowed;
    if (snDecl == null || pnDecl == null) {
        return true;
    }
    if (clType == "en") {
        var fparticle;
        fparticle = pnDecl.type.contentModel.particles[0]

        var chcount, chmin;
        if (fparticle.itemType == SOMITEM_ANY) {
            chcount = XMLChildTagsCount(fatherNode, "*");
            chmin = parseInt(fparticle.minOccurs);
        } else {
            chcount = XMLChildTagsCount(fatherNode, selectedNode.nodeName);
            //     'Järgnev on MSXML6 korral alati = 1, MSXML4-s veel töötas
            //     chmin = parseInt(snDecl.minOccurs)
            try {
                chmin = parseInt(pnDecl.type.contentModel.particles.itemByName(snDecl.name).minOccurs);
            }
            catch (e) {
                //nt kui pnDecl sees pole snDecl-it ette nähtud;
                chmin = 0;
            }
        }
        if (chcount > chmin) {
            delNodeAllowed = true;
        } else {
            delNodeAllowed = false;
        }
    } else if (clType == "et") {
        if (selectedNode.childNodes.length > 1) {
            delNodeAllowed = true;
        } else {
            delNodeAllowed = false;
        }
    } else if (clType == "at") {
        if (snDecl.use == SCHEMAUSE_REQUIRED) {
            delNodeAllowed = false;
        } else {
            var attrNoEditOtsitav;
            if (neAttribs.indexOf("/") > -1) {
                attrNoEditOtsitav = fatherNode.nodeName + "/@" + selectedNode.nodeName;
            } else {
                attrNoEditOtsitav = selectedNode.nodeName;
            }
            if (neAttribs.indexOf(";" + attrNoEditOtsitav + ";") > -1) {
                delNodeAllowed = false;
            } else {
                delNodeAllowed = true;
            }
        }
    } else if (clType == "ct") {
        delNodeAllowed = true;
    } else {
        delNodeAllowed = false;
    }
    return delNodeAllowed;
} //delNodeAllowed


//-----------------------------------------------------------------------------------
function DisplayCMenu(posx, posy) {
    cmenu.style.pixelLeft = posx;
    cmenu.style.pixelTop = posy;
    cmenu.style.display = "";
    cmenu.style.cursor = "default";
    cmenu.setCapture();
} //DisplayCMenu


//-----------------------------------------------------------------------------------
function ClickCMenu() {
    var cmel;

    cmel = window.event.srcElement;
    //peamenüü (cmenu sees div-id)
    //"<div style='width:100%' class='mi' id='add_before'>Lisa ette</div>"
    //"<div style='width:100%' class='mi' id='add_insert'>Lisa sisse</div>"
    //"<div style='width:100%' class='mi' id='add_after'>Lisa järele</div>"
    //"<div style='width:100%' class='mi' id='add_attrs'>Lisa tunnus</div>"
    //"<div style='width:100%' class='mi' id='cut_node'>Lõika üksus</div>"
    //"<div style='width:100%' class='mi' id='copy_node'>Kopeeri üksus</div>"
    //"<div style='width:100%' class='mi' id='paste_node'>Kleebi üksus</div>"
    //"<div style='width:100%' class='mi' id='del_self'>Kustuta</div>"
    //"<div style='width:100%' class='mi' id='comment_this'>Lisa kommentaar</div>"

    if ((cmel.className == "dl" || cmel.className == "md")) {
        return;
    }

    //klõps põhimenüüs
    if (cmel.parentElement.id == "cmenu") {
        if (openmenuid == "") {
            if (cmel.className == "hi") {
                cmel.className = "mi";
            } else if (cmel.className == "hi_span") {
                cmel.className = "mi_span";
            }
            document.releaseCapture();
        }
        //klõps alammenüüdes või üldse suvalises kohas
    } else {
        if (cmel.className == "hi") {
            cmel.className = "mi";
        } else if (cmel.className == "hi_span") {
            cmel.className = "mi_span";
        }
        document.releaseCapture();
    }

    var norm_elem, newnode, backupnode, refNode, tval, dfr, pasteFragment, pasteCheck;

    norm_elem = null;
    refNode = null;

    var tarr, i;
    var sqna, tulemus;
    var smdArgs, retVal;

    var domCopy, asuKoht;

    //kontrolli morfo uuendusi ...
    if (cmel.id == "morf_ana" || cmel.id == "morf_syn" || cmel.id == "morf_syn_asenda") {
        if (!checkRpmUpdates()) {
            return;
        }
    }

    var sisuTekstid, sisuTekst, yldStruNode;

    //kommenteerimine ning ette, sisse, järele, atribuudid alammenüüd:
    //sm_before, sm_after, sm_insert, sm_attrs
    if (cmel.id == "comment_this" || jsLeft(cmel.parentElement.id, 3) == "sm_") { //'elemendi nimi: clType = "en"
        norm_elem = fatherNode;
        if (cmel.id == "comment_this") {
            tval = prompt("Sisesta kommentaar!");
            if (tval == "") {
                return;
            }
            newnode = oEditDOM.createNode(NODE_COMMENT, "", "");
            newnode.text = tval;
            norm_elem.insertBefore(newnode, selectedNode);
        } else if (jsLeft(cmel.parentElement.id, 3) == "sm_") { //'ette, sisse, järele, atribuudid;
            //sm_*: cmel.id:;
            //= qn(0); item.uri(1); typename(item)(2); typename(item.type)(3);;
            //item.type.contentType(4); item.type.name(5); item.minOcc(6);;
            //item.maxOcc(7); kirjeldav(8); item.name(9);
            //= #text;
            tarr = cmel.id.split(";");
            if (cmel.parentElement.id == "sm_attrs") { //'atribuudid;
                if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                    yldStruNode = yldStruDom.selectSingleNode(".//" + selectedNode.nodeName);
                    var lisatavAttr = yldStruNode.attributes.getNamedItem(tarr[0]);
                    selectedNode.attributes.setNamedItem(oEditDOM.importNode(lisatavAttr, true));
                }
                else {
                    selectedNode.attributes.setNamedItem(oEditDOM.createNode(NODE_ATTRIBUTE, tarr[0], tarr[1]));
                }
            } else { //ette, sisse, järele;
                if (tarr[0] == "#text") {
                    newnode = oEditDOM.createNode(NODE_TEXT, "", "");
                    //MIDAGI PEAB PANEMA, muidu fataalne viga MSXML4 - s;
                    newnode.text = "";
                } else { //elemendid;
                    if (yldStruDom.documentElement.getAttribute("pr_sd:ver") == "2.0") {
                        newnode = oEditDOM.createNode(NODE_ELEMENT, tarr[0], tarr[1]);
                        yldStruNode = yldStruDom.selectSingleNode(".//" + tarr[0]);
                        getMajors(yldStruNode, newnode);
                    }
                    else {
                        newnode = GetAddElementFromFile(tarr[0], tarr[1]);
                    }
                }
                if (cmel.parentElement.id == "sm_before") {
                    newnode = fatherNode.insertBefore(newnode, selectedNode);
                } else if (cmel.parentElement.id == "sm_insert") {
                    newnode = selectedNode.insertBefore(newnode, null);
                } else if (cmel.parentElement.id == "sm_after") {
                    newnode = fatherNode.insertBefore(newnode, selectedNode.nextSibling);
                }
                AddGruppChecks(newnode);  // n/@nrl, tähendusnumbrite ümberarvutused;
            }
        }
        norm_elem.normalize();
        setATTAPlokid(norm_elem);
        vaatedRefresh(2);
    } else if (cmel.id == "ren_elem") { //'elemendi nimi: clType = "en";
        //prompt(: prompt, default)
        tval = prompt(snKirjeldavQName + '\r\n\r\n' + DLG_GET_ELEM_NAME, selectedNode.nodeName);
        if (tval == "" || tval == selectedNode.nodeName) {
            return;
        }
        norm_elem = fatherNode;
        //        backupnode = norm_elem.cloneNode(true);
        dfr = oEditDOM.createDocumentFragment();
        var newNoded = selectedNode.childNodes;
        for (i = 0; i < newNoded.length; i++) {
            var newNode = newNoded[i];
            dfr.appendChild(newNode.cloneNode(true));
        }
        newnode = oEditDOM.createNode(NODE_ELEMENT, tval, DICURI);
        if (window.event.ctrlLeft) {
            var oAttrs = selectedNode.Attributes;
            for (i = 0; i < oAttrs.length; i++) {
                var oAttr = oAttrs[i];
                newnode.Attributes.setNamedItem(oAttr.cloneNode(true));
            }
        }
        newnode.appendChild(dfr);
        norm_elem.replaceChild(newnode, selectedNode)

        //        if (!(ValidateXML(norm_elem, oXsdSc))) {
        //            norm_elem.parentNode.replaceChild(backupnode, norm_elem);
        //            norm_elem = null;
        //            return;
        //        }

        norm_elem.normalize();
        setATTAPlokid(norm_elem);
        vaatedRefresh(2);

    } else if (cmel.id == "incr_indent") { //'elemendi nimi: clType = "en";
        norm_elem = fatherNode;
        refNode = selectedNode.selectSingleNode("preceding-sibling::" + DICPR + ":t[1]");
        refNode.appendChild(selectedNode);
        norm_elem.normalize();
        setATTAPlokid(norm_elem);
        vaatedRefresh(2);
    } else if (cmel.id == "decr_indent") { //'elemendi nimi: clType = "en";
        norm_elem = fatherNode.parentNode;
        refNode = fatherNode.nextSibling;
        fatherNode.parentNode.insertBefore(selectedNode, refNode);
        norm_elem.normalize();
        setATTAPlokid(norm_elem);
        vaatedRefresh(2);
    } else if (cmel.id == "morf_ana") {
        // sqna = jsTrim(jsLeft(selectedNode.text, 30))
        sqna = jsMid(sMarkSona, sMarkSona.lastIndexOf(" ") + 1);
        sqna = RemoveSymbols(sqna, " ") //'2. parm VÕIB OLLA;
        //sqna, tuletusega, liitsqnaga, sqnastikuga, vkkuju (sisekood, vorminimi, klaarkood, FS-kood; 0, 1, 2, 3);
        tulemus = eelexSWCtl.analyysi(sqna, ma_tul, ma_ls, ma_sqn, ma_vkkuju);
        var intVal, codeStr;
        codeStr = "";
        for (i = 0; i < tulemus.length; i++) {
            intVal = tulemus.charCodeAt(i);
            codeStr = codeStr + "[<b>" + tulemus.charAt(i) + "</b> U+" + jsStrRepeat(4 - hex(intVal, true).length, "0") + hex(intVal, true) + ", " + intVal + "]";
        }
        showDbgVar("tulemus: codeStr", tulemus, "ClickCMenu", "Morf analüüsi tulemus", codeStr, new Date());
        alert("'" + sqna + "':" + '\r\n\r\n' + "'" + tulemus + "'", vbInformation, NAME_MORF_ANA);
    } else if (cmel.id == "morf_syn") {
        // sqna = jsTrim(jsLeft(selectedNode.text, 30))
        sqna = jsMid(sMarkSona, sMarkSona.lastIndexOf(" ") + 1);
        sqna = RemoveSymbols(sqna, ""); //'2. parm VÕIB OLLA;
        tulemus = getLemmasForSyn(sqna);
        if (tulemus.length > 0) {
            smdArgs = dic_desc + JR + sAppLang + JR + tulemus + JR + "Paradigma" + JR + ms_valtega + JR + ms_vkkuju;
            window.showModalDialog("html/morf_syntees_vormid.htm", smdArgs, "dialogHeight:768px;dialogWidth:1024px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
        }
    } else if (cmel.id == "morf_syn_asenda") {
        //siia jõuab ainult siis kui klõpsad muutevormide väljal;
        // sqna = jsTrim(jsLeft(sMarkSona, 30))
        sqna = jsMid(sMarkSona, sMarkSona.lastIndexOf(" ") + 1);
        sqna = RemoveSymbols(sqna, ""); //'2. parm VÕIB OLLA;
        //üle ChrW(+HE001) märksõnad;
        //algavad '+' v '?+' kui on liitsõna tagaosa v küsivav v mõlemad v kumbagi. Veel võib ees olla "¡" pl märkimiseks;
        tulemus = getLemmasForSyn(sqna);
        if (tulemus.length > 0) {
            smdArgs = dic_desc + JR + sAppLang + JR + tulemus + JR + "Muutevormid" + JR + ms_valtega + JR + ms_vkkuju;
            retVal = window.showModalDialog("html/morf_syntees_vormid.htm", smdArgs, "dialogHeight:384px;dialogWidth:1024px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
            if (retVal) {
                var komplektid, komplekt, morfAndmed;
                komplektid = retVal.split(String.fromCharCode(0xE002));
                komplekt = komplektid[0];
                //mv - mt - vk - sl - lsOsa;
                morfAndmed = komplekt.split(JR);
                selectedNode.text = morfAndmed[4] + morfAndmed[0] //kas tuleb '+' ette;

                var gspq, lisatav, onMt, onSl, onVk;
                onMt = false;
                onSl = false;
                onVk = false;
                //tüübinumber;
                lisatav = fatherNode.selectSingleNode(DICPR + ":mt");
                if (!lisatav) {
                    //GetSchemaPosQuery: teeb oStruDom - ist päringu following-sibling nimede kohta;
                    gspq = GetSchemaPosQuery(fatherNode, DICPR + ":mt");
                    if (!(gspq == "Ei saa")) {
                        refNode = fatherNode.selectSingleNode(gspq);
                        lisatav = fatherNode.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":mt", DICURI), refNode);
                        lisatav.text = morfAndmed[1];
                        onMt = true;
                    }
                } else {
                    lisatav.text = morfAndmed[1];
                    onMt = true;
                }
                //sõnaliik;
                if ((morfAndmed[3] == "S")) {
                    morfAndmed[3] = "s";
                } else if ((morfAndmed[3] == "V")) {
                    morfAndmed[3] = "v";
                } else if ((morfAndmed[3] == "A")) {
                    morfAndmed[3] = "adj";
                }
                lisatav = fatherNode.selectSingleNode(DICPR + ":sly"); //'Eesti-X - == on <grg> sõnaliigiks <sly>;
                if (!lisatav) {
                    //GetSchemaPosQuery: teeb oStruDom - ist päringu following-sibling nimede kohta;
                    gspq = GetSchemaPosQuery(fatherNode, DICPR + ":sly");
                    if (!(gspq == "Ei saa")) {
                        refNode = fatherNode.selectSingleNode(gspq);
                        lisatav = fatherNode.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":sly", DICURI), refNode);
                        lisatav.text = morfAndmed[3];  //Eesti-X - == on nt 's', tuleb 'S';
                        onSl = true;
                    }
                } else {
                    lisatav.text = morfAndmed[3]; //Eesti-X - == on nt 's', tuleb 'S';
                    onSl = true;
                }
                //vormikood;
                if (morfAndmed[2].length > 0) {

                    //                var oConfigDOM, cfgElem
                    //               oConfigDOM = IDD("File", "shsconfig_" + dic_desc + ".xml", false, false, null)
                    //               cfgElem = oConfigDOM.documentElement.selectSingleNode("koht_vk")

                    var koht_vk, vkParent;
                    koht_vk = "x:P/x:mg";
                    if (!(koht_vk == "")) {
                        vkParent = selectedNode.selectSingleNode("ancestor::" + DICPR + ":A/" + koht_vk);
                        lisatav = vkParent.selectSingleNode(DICPR + ":vk");
                        if (!lisatav) {
                            //GetSchemaPosQuery: teeb oStruDom - ist päringu following-sibling nimede kohta;
                            gspq = GetSchemaPosQuery(vkParent, DICPR + ":vk");
                            if (!(gspq == "Ei saa")) {
                                refNode = vkParent.selectSingleNode(gspq);
                                lisatav = vkParent.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":vk", DICURI), refNode);
                                lisatav.text = morfAndmed[2];
                                onVk = true;
                            }
                        } else {
                            lisatav.text = morfAndmed[2];
                            onVk = true;
                        }
                    } else {
                        lisatav = fatherNode.selectSingleNode(DICPR + ":vk");
                        if (!lisatav) {
                            //GetSchemaPosQuery: teeb oStruDom - ist päringu following-sibling nimede kohta;
                            gspq = GetSchemaPosQuery(fatherNode, DICPR + ":vk");
                            if (!(gspq == "Ei saa")) {
                                refNode = fatherNode.selectSingleNode(gspq);
                                lisatav = fatherNode.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":vk", DICURI), refNode);
                                lisatav.text = morfAndmed[2];
                                onVk = true;
                            }
                        } else {
                            lisatav.text = morfAndmed[2];
                            onVk = true;
                        }
                    }
                    onVk = false //et "vk" saaks lisatud ainult 1 kord ...;
                }
                if (komplektid.length > 1) {
                    var uusGrg;
                    refNode = fatherNode.nextSibling;
                    for (i = 1; i < komplektid.length; i++) {
                        komplekt = komplektid[i];
                        //mv - mt - vk - sl - lsOsa;
                        morfAndmed = komplekt.split(JR);
                        uusGrg = fatherNode.parentNode.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":grg", DICURI), refNode);
                        if ((morfAndmed[2].length > 0 && onVk)) { //vormikood;
                            lisatav = uusGrg.appendChild(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":vk", DICURI));
                            lisatav.text = morfAndmed[2];
                        }
                        lisatav = uusGrg.appendChild(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":mv", DICURI));
                        lisatav.text = morfAndmed[4] + morfAndmed[0] //kas tuleb '+' ette;
                        if ((onSl)) {
                            lisatav = uusGrg.appendChild(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":sly", DICURI));
                            lisatav.text = morfAndmed[3];
                        }
                        if ((onMt)) {
                            lisatav = uusGrg.appendChild(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":mt", DICURI));
                            lisatav.text = morfAndmed[1];
                        }
                    }
                }
                setATTAPlokid(selectedNode);
                vaatedRefresh(2);
            }
        }
    } else if (cmel.id == "open_for_copy") {
        if (!oCopyView) {
            oCopyView = IDD("File", "xsl/copyview.xsl", false, false, null);
        }
        oViewAll("ifrviewdiv").innerHTML = selectedNode.transformNode(oCopyView);
    } else if (cmel.id == "openFindReplace") {
        var hulgiNimi;
        if (dic_desc == "sp_") {
            hulgiNimi = "openFindReplace";
        } else {
            hulgiNimi = "hulgiParandused";
        }
        window.open("html/" + hulgiNimi + ".htm?valitud=1", "_blank", "width=1024,height=700,channelmode=no,directories=no,fullscreen=no,location=no,menubar=no,resizable=yes,scrollbars=yes,status=yes,titlebar=yes,toolbar=no");
    } else if (cmel.id == "del_self") {
        var sTekst, nn; //nodeName;
        sTekst = clickedNode.text;
        updMuudatused("K", sTekst);
        if (clType == "en") {
            norm_elem = fatherNode;  //selectedNode.parentNode;
            nn = selectedNode.nodeName;
            norm_elem.removeChild(selectedNode);
            arvutaTxhendusNumbrid(norm_elem, nn);
        } else if (clType == "et" || clType == "ct") {
            norm_elem = selectedNode;
            norm_elem.removeChild(clickedNode);
        } else if (clType == "at") {
            norm_elem = fatherNode; //element, millele atribuut kuulub;
            norm_elem.removeAttributeNode(selectedNode);
        }
        norm_elem.normalize();
        setATTAPlokid(norm_elem);
        vaatedRefresh(2);
    } else if (cmel.id == "cut_node") {
        norm_elem = fatherNode;
        cpfragment.selectNodes("*").removeAll();
        cpfragment.appendChild(clickedNode);
        norm_elem.normalize();
        setATTAPlokid(norm_elem);
        vaatedRefresh(2);
    } else if (cmel.id == "cut_node_add") {
        norm_elem = fatherNode;
        cpfragment.appendChild(clickedNode);
        norm_elem.normalize();
        setATTAPlokid(norm_elem);
        vaatedRefresh(2);
    } else if (cmel.id == "copy_node") {
        cpfragment.selectNodes("*").removeAll();
        cpfragment.appendChild(clickedNode.cloneNode(true));
    } else if (cmel.id == "copy_node_add") {
        cpfragment.appendChild(clickedNode.cloneNode(true));
    } else if (cmel.parentElement.id == "paste_node_options") {
        backupnode = fatherNode.cloneNode(true)

        if (clType == "en") {
            norm_elem = fatherNode;
            refNode = selectedNode;
        } else if (clType == "et" || clType == "ct") {
            norm_elem = selectedNode;
            refNode = clickedNode;
        }

        if (window.event.ctrlLeft && cpfragment.childNodes.length == 1) {
            //prompt(: prompt, default)
            tval = prompt(cpfragment.childNodes[0].nodeName + '\r\n\r\n' + DLG_GET_ELEM_NAME, DLG_REN_ELEMENT, cpfragment.childNodes[0].nodeName);
            if ((tval == "")) {
                return;
            }
            dfr = oEditDOM.createDocumentFragment();
            dfr.appendChild(oEditDOM.createNode(NODE_ELEMENT, tval, DICURI));
            newNoded = cpfragment.childNodes[0].childnodes;
            for (i = 0; i < newNoded.length; i++) {
                newNode = newNoded[i];
                dfr.childNodes[0].appendChild(newNode.cloneNode(true));
            }
            pasteFragment = dfr;
        } else {
            pasteFragment = cpfragment.cloneNode(true);
        }

        var fPasted, myNode;
        fPasted = null;

        var myNoded = pasteFragment.childNodes;
        if (cmel.id == "paste_node_before") {
            for (i = 0; i < myNoded.length; i++) {
                myNode = myNoded[i];
                if (fPasted == null) {
                    fPasted = norm_elem.insertBefore(myNode.cloneNode(true), refNode);
                } else {
                    norm_elem.insertBefore(myNode.cloneNode(true), refNode);
                }
            }
        } else if (cmel.id == "paste_node_insert") {
            for (i = 0; i < myNoded.length; i++) {
                myNode = myNoded[i];
                if (fPasted == null) {
                    fPasted = refNode.appendChild(myNode.cloneNode(true));
                } else {
                    refNode.appendChild(myNode.cloneNode(true));
                }
            }
        } else if (cmel.id == "paste_node_insertContent") {
            myNoded = pasteFragment.childNodes[0].childNodes;
            for (i = 0; i < myNoded.length; i++) {
                myNode = myNoded[i];
                if (fPasted == null) {
                    fPasted = refNode.appendChild(myNode.cloneNode(true));
                } else {
                    refNode.appendChild(myNode.cloneNode(true));
                }
                refNode.appendChild(myNode.cloneNode(true));
            }
        } else if (cmel.id == "paste_node_after") {
            refNode = refNode.nextSibling;
            for (i = 0; i < myNoded.length; i++) {
                myNode = myNoded[i];
                if (fPasted == null) {
                    fPasted = norm_elem.insertBefore(myNode.cloneNode(true), refNode);
                } else {
                    norm_elem.insertBefore(myNode.cloneNode(true), refNode);
                }
            }
        } else if (cmel.id == "paste_node_over") {
            for (i = 0; i < myNoded.length; i++) {
                myNode = myNoded[i];
                if (fPasted == null) {
                    fPasted = norm_elem.insertBefore(myNode.cloneNode(true), refNode);
                } else {
                    norm_elem.insertBefore(myNode.cloneNode(true), refNode);
                }
            }
            norm_elem.removeChild(refNode);
        }
        AddGruppChecks(fPasted);  // @nrl, tähendusnumbrite ümberarvutused;

        pasteCheck = fatherNode.cloneNode(true);
        DeleteEmptys(pasteCheck);

        if (!(ValidateXML(pasteCheck, oXsdSc))) {
            fatherNode.parentNode.replaceChild(backupnode, fatherNode);
            norm_elem = null;
            return;
        }

        norm_elem.normalize();
        setATTAPlokid(norm_elem);
        vaatedRefresh(2);

    } else if (cmel.parentElement.id == "aacContMenu") {
        norm_elem = fatherNode;
        if (cmel.id == "addAssembleComplete") {
            var newAttr;
            newAttr = oEditDOM.createNode(NODE_ATTRIBUTE, DICPR + ":aK", DICURI);
            newAttr.value = sUsrName;
            selectedNode.attributes.setNamedItem(newAttr);
            newAttr = oEditDOM.createNode(NODE_ATTRIBUTE, DICPR + ":aKL", DICURI);
            newAttr.value = GetXSDDateTime(new Date());
            selectedNode.attributes.setNamedItem(newAttr);
        } else if (cmel.id == "remAssembleComplete") {
            selectedNode.removeAttribute(DICPR + ":aK");
            selectedNode.removeAttribute(DICPR + ":aKL");
        }
        norm_elem.normalize();
        setATTAPlokid(norm_elem);
        vaatedRefresh(2);
    } else if (cmel.id == "morfofonInfo") {
        var mfDom = exCGISync("create_mfp.cgi", dic_desc + PD + selectedNode.xml);
        var mf = jsTrim(mfDom.responseText);
        if (mf) {
            var mfpNode = selectedNode.selectSingleNode(DICPR + ":mfp");
            if (mfpNode) {
                norm_elem = selectedNode;
                var mfNode = mfpNode.selectSingleNode(DICPR + ":mf");
                if (!mfNode) {
                    mfNode = mfpNode.insertBefore(oEditDOM.createNode(NODE_ELEMENT, DICPR + ":mf", DICURI), mfpNode.firstChild);
                }
                mfNode.text = mf;
            }
            else {
                alert("Puudub morfoloogiaplokk!");
                return;
            }
        }
        else {
            alert("Morfofonoloogiline vastus tühi!");
            return;
        }
        norm_elem.normalize();
        setATTAPlokid(norm_elem);
        vaatedRefresh(2);
    } else if (cmel.id == "guuglisse" || cmel.id == "extLinks") {
        sisuTekst = "";
        sisuTekstid = selectedNode.selectNodes(".//text()[not(local-name(..) = 'G' or local-name(..) = 'K' or local-name(..) = 'KA' or local-name(..) = 'KL' or local-name(..) = 'T' or local-name(..) = 'TA' or local-name(..) = 'TL' or local-name(..) = 'PT' or local-name(..) = 'PTA' or local-name(..) = 'X' or local-name(..) = 'XA')]");
        for (ix = 0; ix < sisuTekstid.length; ix++) {
            if (sisuTekst) {
                sisuTekst += " ";
            }
            sisuTekst += sisuTekstid[ix].text;
        }
        sisuTekst = sisuTekst.replace(/(&amp;)/g, '&');
        sisuTekst = sisuTekst.replace(/(&\w+;)/g, "");
        sisuTekst = sisuTekst.replace(/[!"#$%&'\(\)\*\+,\-\.\/:;<=>\?\[\\\]`\{\|\}¤]/g, "");
        sisuTekst = encodeURIComponent(sisuTekst);
        if (cmel.id == "guuglisse") {
            window.open("http://www.google.com/search?q=" + sisuTekst, "guugler");
        }
        else {
            window.open("extLinks.cgi?dictid=" + dic_desc + "&sone=" + sisuTekst, "extLinks");
        }
    }
} //ClickCMenu


//-----------------------------------------------------------------------------------
function GetAddElementFromFile(qname, uri) {
    var frdoc, aenode
    frdoc = IDD("file", "xml/" + dic_desc + "/ag_" + unName(qname) + ".xml", false, false, null);
    if (frdoc.parseError.errorCode == 0) {
        aenode = oEditDOM.importNode(frdoc.documentElement, true);
    } else {
        aenode = oEditDOM.createNode(NODE_ELEMENT, qname, uri);
    }
    AddEmptyTexts(aenode);
    return aenode;
} //GetAddElementFromFile


//-----------------------------------------------------------------------------------
function GetAddElement(qname, uri) {
    var xh, oRespDom, sta, frDoc, aenode, elXml;
    //set aenode = null
    xh = exCGISync("tools.cgi", "getAddElements" + JR + dic_desc + JR + sUsrName + JR + "xml/" + dic_desc + "/" + JR + "ag_" + unName(qname) + ".xml" + JR + "");
    if ((xh.statusText == "OK")) {
        oRespDom = xh.responseXML //responseXML: TypeName = DomDocument;
        sta = oRespDom.selectSingleNode("rsp/sta").text;
        if ((sta == "Success")) {
            elXml = oRespDom.selectSingleNode("rsp/answer").firstChild.xml;
            frDoc = IDD("", "", false, false, null);
            frDoc.loadXML(elXml);
            aenode = frDoc.documentElement;
        }
    }
    AddEmptyTexts(aenode)
    return aenode;
} //GetAddElement


//-----------------------------------------------------------------------------------
function AddEmptyTexts(nodeToCheck) {
    var emptynodes, emptynode, oParticle
    emptynodes = nodeToCheck.selectNodes("descendant-or-self::*[not(text() or *)]");
    for (i = 0; i < emptynodes.length; i++) {
        emptynode = emptynodes[i];
        try {
            oParticle = oSchRootElems.itemByQName(emptynode.baseName, emptynode.namespaceURI);
            if ((oParticle.type.itemType == SOMITEM_COMPLEXTYPE)) {
                if (!(oParticle.type.contentType == SCHEMACONTENTTYPE_ELEMENTONLY)) {
                    emptynode.text = "";
                }
            } else {
                emptynode.text = "";
            }
        }
        catch (e) {
            alert(e.name + " 0x" + hex(e.number, true) + ": '" + e.description);
        }
    }
} //AddEmptyTexts


//-----------------------------------------------------------------------------------
//----------------------------- TN (teksti sees) menüü  -----------------------------
//-----------------------------------------------------------------------------------
function GetTNSubMenus() {
    var prevqn;
    var nextqn

    prevqn = "";
    nextqn = ""

    var tnode
    tnode = clickedNode.selectSingleNode("preceding-sibling::*[1]");
    if (!(tnode == null)) {
        prevqn = tnode.nodeName;
    }
    tnode = clickedNode.selectSingleNode("following-sibling::*[1]");
    if (!(tnode == null)) {
        nextqn = tnode.nodeName;
    }

    var pnqn;
    pnqn = selectedNode.nodeName

    var frdoc;
    var anynames;
    var chcount;
    var chmax;
    var smhtml = '';
    var subelems

    var i;
    var subelem;
    var tarr

    //GetElSchemaInfo =
    //qn(0); item.uri(1); typename(item)(2); typename(item.type)(3);
    //item.type.contentType(4); item.type.name(5); item.minOcc(6);
    //item.maxOcc(7); kirjeldav(8); item.name(9)

    if (snDecl.type.contentModel.particles.length > 0) {
        var fparticle = snDecl.type.contentModel.particles[0];

        if ((fparticle.itemType == SOMITEM_ANY)) {
            frdoc = IDD("file", "xml/" + dic_desc + "/aa_" + unName(pnqn) + ".xml", false, false, null);
            if ((frdoc.parseError.errorCode != 0)) {
                return;
            }
            anynames = frdoc.documentElement.text.split("|");
            chcount = XMLChildTagsCount(selectedNode, "*");
            chmax = parseInt(fparticle.maxOccurs);
            if ((chmax == -1 || chcount < chmax)) {
                subelems = new Array(anynames.length);
                for (i = 0; i < anynames.length; i++) {
                    subelem = oSchRootElems.itemByQName(jsMid(anynames[i], anynames[i].indexOf(":") + 1), oXmlNsm.getURI(jsMid(anynames[i], 0, anynames[i].indexOf(":"))));
                    subelems[i] = GetElSchemaInfo(subelem);
                    tarr = subelems[i].split(";");
                    smhtml = smhtml + "<div style='width:100%' class='mi' " + "id='" + subelems[i] + "' " + "title='" + tarr[0] + "'>" + tarr[8] + " (" + tarr[0] + ")</div>";
                }
            }
        } else {
            var pncount;
            pncount = snDecl.type.contentModel.particles.length;
            subelems = new Array(pncount);
            var subqn;
            var elbefind;
            var elaftind;
            elbefind = 0;
            elaftind = pncount - 1;
            for (i = 0; i < pncount; i++) {
                subelem = snDecl.type.contentModel.particles[i];
                subelems[i] = GetElSchemaInfo(subelem);
                subqn = oXmlNsm.getPrefixes(subelem.namespaceURI).item(0) + ":" + subelem.name;
                if ((subqn == prevqn)) {
                    elbefind = i;
                }
                if ((subqn == nextqn)) {
                    elaftind = i;
                }
            }
            for (i = elbefind; i <= elaftind; i++) {
                tarr = subelems[i].split(";");
                chcount = XMLChildTagsCount(selectedNode, tarr[0]);
                chmax = parseInt(tarr[7]);
                if ((chmax == -1 || chcount < chmax)) {
                    smhtml = smhtml + "<div style='width:100%' class='mi' " + "id='" + subelems[i] + "' " + "title='" + tarr[0] + "'>" + tarr[8] + " (" + tarr[0] + ")</div>";
                }
            }
        }
    }
    tn_sm_before.innerHTML = smhtml;
    tn_sm_after.innerHTML = smhtml;
    tn_sm_insert.innerHTML = smhtml;
} //GetTNSubMenus

//-----------------------------------------------------------------------------------
function sqnastikuTooriistad() {
    var sSrToolsMenu, delimline;
    sSrToolsMenu = "";
    delimline = jsStrRepeat((div_SrToolsMenu.style.pixelWidth / 8), "\u2013");  //400 / 8, mõttekriips

    //EELex, kes saab mida:
    //
    // toimetamise logi                  kõik
    // sarnased märksõnad                (EELex, kui ka MySql-is)
    // vigased viited                    (EELex, kui ka MySql-is)
    // EELex sätted                      peatoimetajad
    // koopia                            EELex adminnid + 'koopia'
    // vaate genereerimine               EELex adminnid + 'vaateGen'
    // hulgiparandused                   EELex adminnid + 'hulgi'
    //--------------------
    // loendid                           "loendid"
    //--------------------
    // peatoimetajate haldus             (EXSA)
    // toimetajate haldus                (EXSA)
    // sõnastiku kustutamine             (EXSA)


    var oConfigDOM, cfgElem;
    var koopia, vaateGen, hulgi, skeemiGen, loendid, importimine;
    koopia = false;
    vaateGen = false;
    hulgi = false;
    skeemiGen = false;
    loendid = false;
    importimine = false;
    oConfigDOM = IDD("File", "shsconfig_" + dic_desc + ".xml", false, false, null);

    if (appDesc == "EXSA") { //'EXSA
        if (srTegija && ptd.indexOf(";" + sUsrName + ";") > -1) {
            koopia = true;
            vaateGen = true;
            hulgi = true;
            skeemiGen = true;
            loendid = true;
            importimine = true;
        }
    } else { //EELex;
        if (eeLexAdmin.indexOf(";" + sUsrName + ";") > -1) {
            koopia = true;
            vaateGen = true;
            hulgi = true;
            skeemiGen = true;
            loendid = true;
            importimine = true;
        } else {
            cfgElem = oConfigDOM.documentElement.selectSingleNode("koopia");
            if (!(cfgElem == null)) {
                if ((cfgElem.text.indexOf(";" + sUsrName + ";") > -1)) {
                    koopia = true;
                }
            }
            cfgElem = oConfigDOM.documentElement.selectSingleNode("import");
            if (!(cfgElem == null)) {
                if ((cfgElem.text.indexOf(";" + sUsrName + ";") > -1)) {
                    importimine = true;
                }
            }
            cfgElem = oConfigDOM.documentElement.selectSingleNode("vaateGen");
            if (!(cfgElem == null)) {
                if ((cfgElem.text.indexOf(";" + sUsrName + ";") > -1)) {
                    vaateGen = true;
                }
            }
            cfgElem = oConfigDOM.documentElement.selectSingleNode("hulgi");
            if (!(cfgElem == null)) {
                if ((cfgElem.text.indexOf(";" + sUsrName + ";") > -1)) {
                    hulgi = true;
                }
            }
            cfgElem = oConfigDOM.documentElement.selectSingleNode("skeemiGen");
            if (!(cfgElem == null)) {
                if ((cfgElem.text.indexOf(";" + sUsrName + ";") > -1)) {
                    skeemiGen = true;
                }
            }
            cfgElem = oConfigDOM.documentElement.selectSingleNode("loendid");
            if (cfgElem) {
                if (cfgElem.text.indexOf(";" + sUsrName + ";") > -1) {
                    loendid = true;
                }
            }
        }
    }

    //5) - importimine
    if (importimine) {
        sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idGetXMLImport' value='idGetXMLImport'>" + "<td>Import</td>" + "</tr>";
    }

    //5) - koopia, eksport
    if (koopia) {
        sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idGetXMLCopy' value='idGetXMLCopy'>" + "<td>" + NAME_XMLCOPY + "</td>" + "</tr>";
    }

    //6) - skeemi genereerimine
    if (skeemiGen) {
        if (dic_desc != "sp_") { // sõnaperede skeem on ainuomaselt hierarhiline + plokid sisse/välja
            sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idSkeemiGen' value='idSkeemiGen'>" + "<td>Skeemi genereerimine</td>" + "</tr>";
        }
    }

    //7) - vaate genereerimine
    if (vaateGen) {
        sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idVaateGen' value='idVaateGen'>" + "<td>Vaate genereerimine</td>" + "</tr>";
    }

    //8) - hulgiparandused
    if (hulgi) {
        sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idBulkUpdate' value='idBulkUpdate'>" + "<td>" + NAME_BULK + "</td>" + "</tr>";
    }

    //8)b - XML valideerimine serveris
    if (hulgi) {
        sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idSrvXmlValidate' value='idSrvXmlValidate'>" + "<td>Köite valideerimine</td>" + "</tr>";
    }

    if (qryMethodOrg == "MySql") {
        //2) - sarnased märksõnad
        sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idMsSarnased' value='idMsSarnased'>" + "<td>" + NAME_ALIKE_HW + "</td>" + "</tr>";
        //3) - vigased viited
        sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idTyhjadViited' value='idTyhjadViited'>" + "<td>" + NAME_ERR_REFERENCES + "</td>" + "</tr>";
    }

    //1) - toimetamise logi
    sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idViewLogs' value='idViewLogs'>" + "<td>" + NAME_LOG + "</td>" + "</tr>"

    //kehtib nii EXSA-s kui EELex-is
    if (srTegija && (ptd.indexOf(";" + sUsrName + ";") > -1 || eeLexAdmin.indexOf(";" + sUsrName + ";") > -1)) {
        //4) - EELex sätted
        sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idEELexSetup' value='idEELexSetup'>" + "<td>" + NAME_EELEX_CONFIG + "</td>" + "</tr>";
    }


    //9) - loendid
    var loendidHTML;
    loendidHTML = "";
    if (loendid) {

        var itm, jrkd, ixItm

        jrkd = new ActiveXObject("Scripting.Dictionary")

        var locnKeys = (new VBArray(impSchemaLocations.Keys())).toArray();
        for (itm in locnKeys) {
            if ((jsLeft(impSchemaLocations.Item(locnKeys[itm]), 4) == dic_desc + "/")) { //'asub tüüpide DOM-is;
                var tyybidDom, koikTyybid, tNimi, eaNimi, eaNode, eaKirjeldav, nimed;
                var kirjeldav, kasutatud, jubaTehtud, ixType, tyybiNode, allItems, prType, qnType, yksik

                tyybidDom = IDD("File", "xsd/" + impSchemaLocations.Item(locnKeys[itm]), false, false, null);
                tyybidDom.setProperty("SelectionLanguage", "XPath");
                tyybidDom.setProperty("SelectionNamespaces", jsTrim(sXsdNsList));
                koikTyybid = tyybidDom.documentElement.selectNodes("xs:simpleType");
                for (ixType = 0; ixType < koikTyybid.length; ixType++) {
                    tyybiNode = koikTyybid[ixType].selectSingleNode("xs:annotation/xs:documentation[@xml:lang='" + sAppLang + "']");
                    tNimi = koikTyybid[ixType].getAttribute("name");
                    kirjeldav = "";
                    if (!(tyybiNode == null)) {
                        if ((tyybiNode.text.length > 0)) {
                            kirjeldav = tyybiNode.text;
                        }
                    }
                    prType = oXsdNsm.getPrefixes(locnKeys[itm]).item(0);
                    qnType = prType + ":" + tNimi

                    allItems = oXsdDOM.documentElement.selectNodes("xs:element[@type = '" + qnType + "' or .//*/@base = '" + qnType + "'] | xs:attribute[@type = '" + qnType + "']");
                    jubaTehtud = "; ";
                    nimed = "; ";
                    kasutatud = "";
                    for (ixItm = 0; ixItm < allItems.length; ixItm++) {
                        eaNimi = allItems[ixItm].getAttribute("name");
                        eaNode = allItems[ixItm].selectSingleNode("xs:annotation/xs:documentation[@xml:lang='" + sAppLang + "']");
                        eaKirjeldav = "";
                        if (!(eaNode == null)) {
                            if ((eaNode.text.length > 0)) {
                                eaKirjeldav = eaNode.text;
                            }
                        }
                        if ((eaKirjeldav == "")) {
                            eaKirjeldav = eaNimi;
                        }
                        if ((allItems(ixItm).baseName == "element")) {
                            eaNimi = "&lt;" + eaNimi + "&gt;";
                            eaKirjeldav = "&lt;" + eaKirjeldav + "&gt;";
                        } else {
                            eaNimi = "@" + eaNimi;
                            eaKirjeldav = "@" + eaKirjeldav;
                        }
                        if ((jubaTehtud.indexOf("; " + eaNimi + "; ") < 0)) {
                            jubaTehtud = jubaTehtud + eaNimi + "; ";
                        }
                        if ((nimed.indexOf("; " + eaKirjeldav + "; ") < 0)) {
                            nimed = nimed + eaKirjeldav + "; ";
                        }
                    }
                    jubaTehtud = jsMid(jubaTehtud, 2);
                    nimed = jsMid(nimed, 2);
                    if ((jubaTehtud.length > 0)) {
                        jubaTehtud = jsLeft(jubaTehtud, jubaTehtud.length - 2);
                        nimed = jsLeft(nimed, nimed.length - 2);
                        kasutatud = nimed + " (" + jubaTehtud + ")";
                    }

                    if ((kirjeldav == "")) {
                        if ((kasutatud == "")) {
                            kirjeldav = tNimi + " ---";
                        } else {
                            kirjeldav = kasutatud;
                        }
                    } else {
                        if ((kasutatud == "")) {
                            if (!(tNimi == "xmllang_tyyp")) { //'seda ei ole otseselt skeemis, ainult skriptis;
                                kirjeldav = tNimi + " - " + kirjeldav + " ---";
                            }
                        } else {
                            kirjeldav = kasutatud + " - " + kirjeldav;
                        }
                    }
                    yksik = "<tr class='mi' id='" + tNimi + "' value='xsd/" + impSchemaLocations.Item(locnKeys[itm]) + "'>" + "<td>" + NAME_LIST + ": " + kirjeldav + "</td>" + "</tr>";
                    jrkd.Add(kirjeldav + " - " + tNimi, yksik);
                }
            }
        }
        var k = (new VBArray(jrkd.Keys())).toArray();
        k = k.sort(ciSort);
        for (ixItm = 0; ixItm < jrkd.Count; ixItm++) {
            loendidHTML = loendidHTML + jrkd.Item(k[ixItm]);
        }
    }

    //9+) jne
    if (loendidHTML.length > 0) {
        sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='delim1' value='delim1'>" + "<td disabled>" + delimline + "</td>" + "</tr>";
        sSrToolsMenu = sSrToolsMenu + loendidHTML;
    }

    if (appDesc == "EXSA") {
        if (srTegija && ptd.indexOf(";" + sUsrName + ";") > -1) {
            sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='delim3' value='delim3'>" + "<td disabled>" + delimline + "</td>" + "</tr>";
            sSrToolsMenu = sSrToolsMenu + "<tr class='mi' confFile='../exsas/sqnastikud.xml' id='ptd' value='idExsaManPtd'>" + "<td>Peatoimetajate haldus</td>" + "</tr>";
            sSrToolsMenu = sSrToolsMenu + "<tr class='mi' confFile='../exsas/sqnastikud.xml' id='td' value='idExsaManUsr'>" + "<td>Toimetajate haldus</td>" + "</tr>";
            sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idRemoveDict' value='idExsaRemoveDict'>" + "<td>Kustuta sõnastik</td>" + "</tr>";
        }
    } else {
        if (dic_desc == "ex_") {
            if (srTegija && (ptd.indexOf(";" + sUsrName + ";") > -1 || eeLexAdmin.indexOf(";" + sUsrName + ";") > -1)) {
                sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='delim2' value='delim2'>" + "<td disabled>" + delimline + "</td>" + "</tr>";
                sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idArtImport' value='idArtImport'>" + "<td>" + NAME_IMPORT_ENTRY + "</td>" + "</tr>";
            }
        } else if (dic_desc == "od_") {
            sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='delim2' value='delim2'>" + "<td disabled>" + delimline + "</td>" + "</tr>";
            sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idOxfordDudenSisukord' value='idOxfordDudenSisukord'>" + "<td>Sisukord</td>" + "</tr>";
            sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idOxfordDudenIndeksEng' value='idOxfordDudenIndeksEng'>" + "<td>Register: inglise</td>" + "</tr>";
            sSrToolsMenu = sSrToolsMenu + "<tr class='mi' id='idOxfordDudenIndeksEst' value='idOxfordDudenIndeksEst'>" + "<td>Register: eesti</td>" + "</tr>";
        }
    }

    //sSrToolsMenu = sSrToolsMenu +  //    "<tr class='mi' id='delimN' value='delimN'>" +  //            "<td disabled>" + delimline + "</td>" +  //    "</tr>"
    //sSrToolsMenu = sSrToolsMenu +  //    "<tr class='mi' id='idAbout' value='idAbout'>" +  //            "<td>" + NAME_ABOUT + "</td>" +  //    "</tr>"

    if (sSrToolsMenu.length > 0) {
        div_SrToolsMenu.innerHTML = "<table id='tbl_SrToolsMenu' width='100%' border='0' cellSpacing='0'>" + sSrToolsMenu + "</table>";
        if (div_SrToolsMenu.all.tags("TR").length > (maxEnumRows + 1)) {
            div_SrToolsMenu.style.height = "480px";
        } else {
            div_SrToolsMenu.style.height = "";
        }
    }
} //sqnastikuTooriistad


//-----------------------------------------------------------------------------------
function assignMainEntry() {
    var esiOsa, tagaOsa, oM1Node, art, liik;
    oM1Node = oEditDOMRoot.selectSingleNode(first_default);
    liik = oM1Node.getAttribute(DICPR + ":liik");
    art = oEditDOMRoot.selectSingleNode(DICPR + ":A");
    if ((liik == "f" || liik == "y")) {
        art.removeAttribute(DICPR + ":Al");
    } else {
        if ((sMarkSona.indexOf("|") > -1)) {
            esiOsa = jsMid(sMarkSona, 0, sMarkSona.indexOf("|"));
            tagaOsa = jsMid(sMarkSona, sMarkSona.indexOf("|") + 1);
        } else if ((jsLeft(sMarkSona, 1) == "\\")) {
            esiOsa = sMarkSona.split("\\")[1];
            tagaOsa = jsMid(sMarkSona, sMarkSona.lastIndexOf("\\") + 1);
        } else {
            return;
        }
        oM1Node.text = esiOsa + "|" + tagaOsa;
        art.removeAttribute(DICPR + ":Al");
    }
    oEditAll("ifrdiv").setAttribute("xmlChanged", 2); //'2 korral värskendatakse kogu iframe ...;
} //assignMainEntry


//-----------------------------------------------------------------------------------
function assignSubEntry() {
    var onLS, esiOsa, tagaOsa, oM1Node, art, liik;
    oM1Node = oEditDOMRoot.selectSingleNode(first_default);
    liik = oM1Node.getAttribute(DICPR + ":liik");
    art = oEditDOMRoot.selectSingleNode(DICPR + ":A");
    if ((liik == "f" || liik == "y")) {
        art.setAttribute(DICPR + ":Al", "all");
    } else {
        if ((sMarkSona.indexOf("|") > -1)) {
            esiOsa = jsMid(sMarkSona, 0, sMarkSona.indexOf("|"));
            tagaOsa = jsMid(sMarkSona, sMarkSona.indexOf("|") + 1);
        } else if ((jsLeft(sMarkSona, 1) == "\\")) {
            esiOsa = sMarkSona.split("\\")[1];
            tagaOsa = jsMid(sMarkSona, sMarkSona.lastIndexOf("\\") + 1);
        } else {
            return;
        }
        oM1Node.text = "\\" + esiOsa + "\\" + tagaOsa;
        art.setAttribute(DICPR + ":Al", "all");
    }
    oEditAll("ifrdiv").setAttribute("xmlChanged", 2); //'2 korral värskendatakse kogu iframe ...;
} //assignSubEntry


//--------------------------------------------------------------------------------
function artikliStaatus(st) {
    var MyVar, artNode
    artNode = oEditDOMRoot.selectSingleNode(DICPR + ":A");
    artNode.setAttribute(DICPR + ":AS", st)

    vaatedRefresh(2);
    //MyVar=alert("Muudatus edukalt tehtud. Ärge unustage artiklit salvestada!!!", 0, "Teade")
} //artikliStaatus


//--------------------------------------------------------------------------------
function AllartikkelYesNo() {
    var MyVar, artNode, homNr, st
    artNode = oEditDOMRoot.selectSingleNode(DICPR + ":A");
    //artNode.CreateAttribute(DICPR, "all", "http://www.eki.ee/dict/ex")
    homNr = artNode.getAttribute(DICPR + ":all");
    if (homNr == null) {
        artNode.setAttribute(DICPR + ":all", "all");
    } else {
        artNode.removeAttribute(DICPR + ":all");
    }
    vaatedRefresh(2);
    //MyVar=alert("Muudatus edukalt tehtud. Ärge unustage artiklit salvestada!!!", 0, "Teade")
} //artikliStaatus


//--------------------------------------------------------------------------------
function ABartikkelYesNo() {
    var MyVar, artNode, homNr, st
    artNode = oEditDOMRoot.selectSingleNode(DICPR + ":A");
    //artNode.CreateAttribute(DICPR, "all", "http://www.eki.ee/dict/ex")
    homNr = artNode.getAttribute(DICPR + ":AS");
    if (homNr == null) {
        artNode.setAttribute(DICPR + ":AS", "AB");
    } else {
        artNode.removeAttribute(DICPR + ":AS");
    }


    vaatedRefresh(2);
    //MyVar=alert("Muudatus edukalt tehtud. Ärge unustage artiklit salvestada!!!", 0, "Teade")
} //artikliStaatus


//--------------------------------------------------------------------------------
function showMsSarnased() {
    if ((salvestaJaKatkesta())) {
        return;
    }

    sCmdId = "msSarnased";
    sQryInfo = "Sarnased märksõnad"

    var sPrmDomXml, oPrmDom, qM;
    qM = "MySql";
    sPrmDomXml = "<prm>" + "<cmd>" + sCmdId + "</cmd>" + "<vol>" + sel_Vol.options(sel_Vol.selectedIndex).id + "</vol>" + "<nfo>" + sQryInfo + "</nfo>" + "<qn>" + qn_ms + "</qn>" + "<qM>" + qM + "</qM>" + "</prm>";

    oPrmDom = IDD("String", sPrmDomXml, false, false, null);
    if ((oPrmDom.parseError.errorCode != 0)) {
        ShowXMLParseError(oPrmDom);
        return;
    }
    StartOperation(oPrmDom);
} //showMsSarnased


//--------------------------------------------------------------------------------
function showTyhjadViited() {
    if ((salvestaJaKatkesta())) {
        return;
    }

    var viiteLn, smdArgs;
    //prompt(: prompt, default)
    //"<qn>" + DICPR + ":" + viiteLn + "</qn>" + "<qn2>" + DICPR + ":" + viiteLn2 + "</qn2>"

    smdArgs = dic_desc + PD + sUsrName + PD + sAppLang + PD + DICPR + PD + default_query;
    viiteLn = window.showModalDialog("html/viganeViit.htm", smdArgs, "dialogHeight:320px;dialogWidth:600px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:yes;unadorned:no");



    if ((viiteLn == "")) {
        return;
    }

    sCmdId = "tyhjadViited";
    sQryInfo = "Olematud viited &lt;" + viiteLn + "&gt;"

    var sPrmDomXml, oPrmDom, qM;
    qM = "MySql";
    sPrmDomXml = "<prm>" + "<cmd>" + sCmdId + "</cmd>" + "<vol>" + sel_Vol.options(sel_Vol.selectedIndex).id + "</vol>" + "<nfo>" + sQryInfo + "</nfo>" + viiteLn + "<qM>" + qM + "</qM>" + "</prm>";

    oPrmDom = IDD("String", sPrmDomXml, false, false, null);
    if ((oPrmDom.parseError.errorCode != 0)) {
        ShowXMLParseError(oPrmDom);
        return;
    }
    StartOperation(oPrmDom);
} //showTyhjadViited


//-----------------------------------------------------------------------------------
function XMLChanged() {
    var oSrc, sPropName;

    oSrc = window.event.srcElement;
    sPropName = window.event.propertyName

    //peale iga muutust salvestatakse puhvrisse artikli hetkeseis, 1. koopia tehakse juba artikli ettetoomisel
    if ((sPropName == "xmlChanged")) {
        if ((urindex == urfragment.childNodes.length - 1)) { //lõpus;
            if ((urindex > -1)) {
                //ainult salvestamise korral on võimalik, et artikkel võib sama olla ...;
                if ((oEditDOMRoot.firstChild.xml != urfragment.childNodes(urindex).xml)) {
                    urfragment.appendChild(oEditDOMRoot.firstChild.cloneNode(true));
                    urindex = urindex + 1;
                }
            } else {
                urfragment.appendChild(oEditDOMRoot.firstChild.cloneNode(true));
                urindex = urindex + 1;
            }
        } else {
            //ainult salvestamise korral on võimalik, et artikkel võib sama olla ...;
            if ((oEditDOMRoot.firstChild.xml != urfragment.childNodes(urindex).xml)) {
                urindex = urindex + 1;
                urfragment.replaceChild(oEditDOMRoot.firstChild.cloneNode(true), urfragment.childNodes(urindex));
            }
        }
        if ((urindex == urmax)) {
            urfragment.removeChild(urfragment.childNodes[0]);
            urindex = urindex - 1;
        }
        urlast = urindex;
        if ((oSrc.getAttribute(sPropName) == 2)) {
            oSrc.innerHTML = oEditDOM.transformNode(oXslEdit);
        }
    }

    var oM1Node, i, intVal, msCodeStr;

    msCodeStr = "";

    //siia jõutakse kas 'xmlChanged' või 'innerHTML' - iga
    if ((oEditDOMRoot.hasChildNodes())) {

        oM1Node = oEditDOMRoot.selectSingleNode(first_default);
        sMarkSona = oM1Node.text;
        sMSortVal = oM1Node.getAttribute(qn_sort_attr);
        msAsendus = "";
        for (i = 0; i < sMarkSona.length; i++) {
            if ((CAP_LETT_LA.indexOf(sMarkSona.charAt(i).toUpperCase()) > -1)) {
                msAsendus = msAsendus + sMarkSona.charAt(i);
            }
        }
        spn_MsVal.innerText = sMSortVal;

        for (i = 0; i < sMarkSona.length; i++) {
            intVal = sMarkSona.charCodeAt(i);
            msCodeStr = msCodeStr + "[<b>" + sMarkSona.charAt(i) + "</b> U+" + jsStrRepeat(4 - hex(intVal, true).length, "0") + hex(intVal, true) + ", " + intVal + "]";
        }
        showDbgVar("sMarkSona: msCodeStr", sMarkSona, "XMLChanged", " ", msCodeStr, new Date())

        if ((oEditDOMRoot.firstChild.xml != oOrgArtNode.xml)) {
            spn_ArtModified.innerText = "*";
            bArtModified = true;
        } else {
            spn_ArtModified.innerText = "";
            bArtModified = false;
        }

        spn_UndoRedoIndex.innerText = urindex;
        spn_UndoRedoLast.innerText = urlast + 1;
        if ((urindex == 0)) {
            img_Undo.src = "graphics/back_grey 16-16.ico";
        } else {
            img_Undo.src = "graphics/back 16-16.ico";
        }
        if ((urindex == urlast)) {
            img_Redo.src = "graphics/forward_grey 16-16.ico";
        } else {
            img_Redo.src = "graphics/forward 16-16.ico";
        }

    } else {

        //algus või deleted;
        sMarkSona = "";
        msAsendus = "";
        sMSortVal = "";
        showDbgVar("sMarkSona: msCodeStr", sMarkSona + ": " + msCodeStr, "XMLChanged", " ", " ", new Date());
        spn_MsVal.innerText = sMSortVal;
        spn_ArtModified.innerText = "";
        spn_NodeInfo.innerText = "";
        bArtSaveAllowed = false;
        bArtDelAllowed = false;
        bArtModified = false;
        artMuudatused = ""

    }
} //XMLChanged


//-----------------------------------------------------------------------------------
function showDbgVar(varName, varVal, procName, idNr, idDesc, praegu) {

    var nrName = 0;
    var nrValue = 1;
    var nrProcName = 2;
    var nrIdNr = 3;
    var nrIdDesc = 4;
    var nrTime = 5

    var rowId;
    rowId = varName + "_" + procName;
    if ((idNr != " ")) {
        rowId = rowId + "_" + idNr;
    }

    var varRow, varCell
    varRow = oDbgTable.all(rowId)

    if ((varRow == null)) {

        varRow = oDbgTable.insertRow();
        varRow.id = rowId

        varCell = varRow.insertCell() //nimi;
        varCell.className = "hd";
        varCell = varRow.insertCell() //väärtus;
        varCell = varRow.insertCell() //protseduuri nimi;
        varCell = varRow.insertCell() //number;
        varCell = varRow.insertCell() //kirjeldus;
        varCell = varRow.insertCell() //aeg

    }

    varRow.cells(nrName).innerText = varName;
    varRow.cells(nrValue).innerText = varVal;
    varRow.cells(nrProcName).innerText = procName;
    varRow.cells(nrIdNr).innerText = idNr;
    varRow.cells(nrIdDesc).innerHTML = idDesc;
    varRow.cells(nrTime).innerText = praegu.toString();

} //showDbgVar


//-----------------------------------------------------------------------------------
function getLemmasForSyn(sqna) {
    var leitud;
    var lsd, sl;
    var tulemus, lemmaRead, lemmaRida, lemma, i, j, k

    //Sätete lehel ei saa väljundkuju osas muud valida kui "vorminimi"
    //nt:
    //
    //jõul =jõu  (SgAd  >jõud !22_S
    //jõul =jõul  (ID  >jõul !41_K
    //jõul =jõul  (SgN  >jõul !22_S
    //'
    //jõulud =jõulu  (PlN  >jõul !22_S
    //
    //aastane =aastane  (SgN  >aastane !10_A
    //aastane =aastane  (SgN  >aastane !12_A
    //
    //elama =ela  (Sup  >elama !27_V
    //
    //# ----------
    //taaskohtama =kohta  (Sup  >taas+kohtama !29_V
    //
    //?taaskohtatama =taaskohta  (SupIps  >taaskohtama !27_V
    //?taaskohtatama =taaskohtata  (Sup  >taaskohtatama !27_V
    //?taaskohtatama =taaskohtatama  (SgG  >taaskohtatam !02_A
    //# ----------
    //?taaskohtatama =atama  (SgG  >taas+koht+atam !02_A
    //?taaskohtatama =kohtata  (Sup  >taas+kohtatama !27_V
    //
    //### exama

    tulemus = eelexSWCtl.analyysi(sqna, ma_tul, ma_ls, ma_sqn, ma_vkkuju);
    if ((jsLeft(tulemus, 4) == "### ")) {
        alert("Lemma ei ole reeglitega lubatud!", jsvbCritical, sqna);
        return '';
    }
    leitud = new Array();
    lsd = 0; //liitsõnad;
    lemmaRead = tulemus.split('\r\n');
    for (i = 0; i < lemmaRead.length; i++) {
        lemmaRida = jsTrim(lemmaRead[i]);
        sl = ""; //'sõnaliik;
        j = lemmaRida.lastIndexOf("_");
        if ((j > 0)) {
            sl = jsTrim(jsMid(lemmaRida, j + 1));
        }
        if ((jsLeft(lemmaRida, 3) == "# -")) {
            lsd = 1;
        }
        j = lemmaRida.indexOf("(SgN  >");
        if ((j > 0)) {
            lemma = jsMid(lemmaRida, j + 7);
            lemma = jsTrim(jsMid(lemma, 0, lemma.indexOf("!")));
            if ((lsd == 1)) {
                if ((sqna == jsReplace(lemma, "+", ""))) {
                    k = lemma.lastIndexOf("+");
                    lemma = jsMid(lemma, k) //koos plussiga;
                }
            }
            if ((jsLeft(lemmaRida, 1) == "?")) {
                lemma = "?" + lemma;
            }
            leitud.push(lemma);
        }
        j = lemmaRida.indexOf("(PlN  >");
        if ((j > 0)) {
            lemma = jsMid(lemmaRida, j + 7);
            lemma = jsTrim(jsMid(lemma, 0, lemma.indexOf("!")));
            if ((lsd == 1)) {
                k = lemma.lastIndexOf("+");
                lemma = jsMid(lemma, k) //koos plussiga;
            }
            if ((jsLeft(lemmaRida, 1) == "?")) {
                lemma = "?" + lemma;
            }
            lemma = "¡" + lemma; //'pl märkimiseks <vk> - s;
            leitud.push(lemma);
        }
        j = lemmaRida.indexOf("(Sup  >"); //'V - tegusõnad;
        if ((j > 0)) {
            lemma = jsMid(lemmaRida, j + 7);
            lemma = jsTrim(jsMid(lemma, 0, lemma.indexOf("!")));
            if ((lsd == 1)) {
                k = lemma.lastIndexOf("+");
                lemma = jsMid(lemma, k) //koos plussiga;
            }
            if ((jsLeft(lemmaRida, 1) == "?")) {
                lemma = "?" + lemma;
            }
            leitud.push(lemma);
        }
    }
    tulemus = JR;  //JR = ChrW(&HE001);
    for (i = 0; i < leitud.length; i++) {
        if ((tulemus.indexOf(JR + leitud[i] + JR) < 0)) {
            tulemus = tulemus + leitud[i] + JR;
        }
    }
    tulemus = jsMid(tulemus, 1);
    if ((tulemus.length > 0)) {
        tulemus = jsMid(tulemus, 0, tulemus.length - 1);
    } else {
        tulemus = sqna;
    }
    return tulemus;
} //getLemmasForSyn


//-----------------------------------------------------------------------------------
function lisa_KL_TL_PT() {
    //see kutsutakse välja 'FillArtFrames' - st peale bArtSaveAllowed, bArtDelAllowed määramist
    var i, delimwidth, delimline;
    delimwidth = div_ArtToolsMenu.style.pixelWidth / 16;
    delimline = "";
    for (i = 0; i < delimwidth; i++) {
        delimline = delimline + EN_DASH;
    }

    var sArtToolsMenu = "";
    //FillArtFrames - == pannakse salvestamise õigused paika
    //teine toimetaja EI SAA TL märget maha võtta (ei ole 'bArtSaveAllowed')
    //peatoimetaja SAAB teise toimetaja TL märke maha võtta (on 'bArtSignAllowed')
    if (bArtSaveAllowed || bArtSignAllowed) {
        //koostamise lõpp;
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idKoostamiseLopp' value='idKoostamiseLopp'>" + "<td>Lisa koostamise lõpu märge</td>" + "</tr>";
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idRemKoostamiseLopp' value='idRemKoostamiseLopp'>" + "<td>Eemalda koostamise lõpu märge</td>" + "</tr>";
        //toimetamise lõpp;
        if (dic_desc == 'elt') {
            sArtToolsMenu = sArtToolsMenu + "<tr class='dl'><td>" + delimline + "</td></tr>";
            sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idCompleteEntryLatvian' value='idCompleteEntryLatvian'><td>Lisa LÄTI osa toimetamise lõpu märge</td></tr>";
            sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idRemCompleteEntryLatvian' value='idRemCompleteEntryLatvian'><td>Eemalda LÄTI osa toimetamise lõpu märge</td></tr>";
            sArtToolsMenu = sArtToolsMenu + "<tr class='dl'><td>" + delimline + "</td></tr>";
            sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idCompleteEntryEstonian' value='idCompleteEntryEstonian'><td>Lisa EESTI osa toimetamise lõpu märge</td></tr>";
            sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idRemCompleteEntryEstonian' value='idRemCompleteEntryEstonian'><td>Eemalda EESTI osa toimetamise lõpu märge</td></tr>";
        } else {
            sArtToolsMenu = sArtToolsMenu + "<tr class='dl'><td>" + delimline + "</td></tr>";
            sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idCompleteEntry' value='idCompleteEntry'>" + "<td>" + MARK_AS_COMPLETE + "</td>" + "</tr>";
            sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idRemCompleteEntry' value='idRemCompleteEntry'>" + "<td>" + REM_MARK_AS_COMPLETE + "</td>" + "</tr>";
        }
    }
    //bArtSignAllowed: srtegija ja ptd hulgas
    //teine peatoimetaja SAAB PT märke maha võtta (on 'bArtSignAllowed')
    if (bArtSignAllowed) {
        if (sArtToolsMenu) {
            sArtToolsMenu = sArtToolsMenu + "<tr class='dl'><td>" + delimline + "</td></tr>";
        }
        //peatoimetaja märge;
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idSignEntry' value='idSignEntry'>" + "<td>" + SIGN_ENTRY + "</td>" + "</tr>";
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idRemSignEntry' value='idRemSignEntry'>" + "<td>" + REM_SIGN_ENTRY + "</td>" + "</tr>";
    }

    if (sArtToolsMenu) {
        div_ArtToolsMenu.innerHTML = div_ArtToolsMenu.innerHTML + "<table id='tbl_ArtToolsMenu_KL_TL_PT' width='100%' border='0' cellSpacing='0'>" + sArtToolsMenu + "</table>";
    }
} //lisa_KL_TL_PT


//-----------------------------------------------------------------------------------
function lisaVeelArtToolse() {
    //see kutsutakse välja 'FillArtFrames' - st peale bArtSaveAllowed, bArtDelAllowed määramist

    var i, delimwidth, delimline;
    delimwidth = div_ArtToolsMenu.style.pixelWidth / 16;
    delimline = "";
    for (i = 0; i < delimwidth; i++) {
        delimline = delimline + EN_DASH;
    }

    var sArtToolsMenu = "";

    if (dic_desc == "har" || dic_desc == "geo") {
        //--------------------------------------------------------------------------------
        // Eesmärk : ToolsMenusse valikute loomine
        // Loodud  : 10.04.2009 10:50 ATeesalu
        // Muutis  : 13.04.2009 10:20 ATeesalu
        //--------------------------------------------------------------------------------
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDictionaryEntry' value='idDictionaryEntry'>" + "<td>" + ENTRY_DICTIONARY + "</td>" + "</tr>";
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDatabaseEntry' value='idDatabaseEntry'>" + "<td>" + ENTRY_DATABASE + "</td>" + "</tr>";
    } else if (dic_desc == "ukr") {
        //--------------------------------------------------------------------------------
        // Eesmärk : ToolsMenusse valikute loomine
        // Loodud  : 01.12.2009 10:50 ATeesalu
        // Muutis  : 01.12.2009 10:20 ATeesalu
        //--------------------------------------------------------------------------------
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDictionaryEntryUkr' value='idDictionaryEntryUkr'>" + "<td>" + ENTRY_DICTIONARY_UKR + "</td>" + "</tr>";
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDatabaseEntryUkr' value='idDatabaseEntryUkr'>" + "<td>" + ENTRY_DATABASE_UKR + "</td>" + "</tr>";
    } else if (dic_desc == "vsl") {
        //--------------------------------------------------------------------------------
        // Eesmärk : ToolsMenusse valikute loomine
        // Loodud  : 19.01.2010 10:50 ATeesalu
        // Muutis  : 19.01.2010 10:20 ATeesalu
        //--------------------------------------------------------------------------------
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDictionaryEntryVsl' value='idDictionaryEntryVsl'>" + "<td>" + ENTRY_DICTIONARY_VSL + "</td>" + "</tr>";
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDatabaseEntryVsl' value='idDatabaseEntryVsl'>" + "<td>" + ENTRY_DATABASE_VSL + "</td>" + "</tr>";
    } else if (dic_desc == "fin") {
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDictionaryEntryVsl' value='idDictionaryEntryFin'>" + "<td>" + ENTRY_DICTIONARY_FIN + "</td>" + "</tr>";
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDatabaseEntryVsl' value='idDatabaseEntryFin'>" + "<td>" + ENTRY_DATABASE_FIN + "</td>" + "</tr>";
    } else if (dic_desc == "ss1") {
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDictionaryEntryVsl' value='idDictionaryEntrySS1'>" + "<td>" + ENTRY_DICTIONARY_SS1 + "</td>" + "</tr>";
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDatabaseEntryVsl' value='idDatabaseEntrySS1'>" + "<td>" + ENTRY_DATABASE_SS1 + "</td>" + "</tr>";
    } else if (dic_desc == "knr") {
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDictionaryEntryVsl' value='idDictionaryEntryKNR'>" + "<td>" + ENTRY_DICTIONARY_KNR + "</td>" + "</tr>";
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDatabaseEntryVsl' value='idDatabaseEntryKNR'>" + "<td>" + ENTRY_DATABASE_KNR + "</td>" + "</tr>";
    } else if (dic_desc == "ss_") {
        //määra põhiartikliks;
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idMainEntry' value='idMainEntry'>" + "<td>Määra 'põhiartikliks'</td>" + "</tr>";
        //määra allartikliks;
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idSubEntry' value='idSubEntry'>" + "<td>Määra 'allartikliks'</td>" + "</tr>";
    } else if (dic_desc == "od_") {
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idAddEmptyEquiv' value='idAddEmptyEquiv'>" + "<td>" + ADD_EMPTY_EQUIV + "</td>" + "</tr>";
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idImportFromWord' value='idImportFromWord'>" + "<td>" + IMP_FROM_WORD + "</td>" + "</tr>";
    } else if (dic_desc == "mar") {
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDictionaryEntryVsl' value='idDictionaryEntryEX'>" + "<td>" + ENTRY_DICTIONARY_EX + "</td>" + "</tr>";
    } else if (dic_desc == "ex_") {
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDictionaryEntryVsl' value='idDictionaryEntryEX'>" + "<td>" + ENTRY_DICTIONARY_EX + "</td>" + "</tr>";
    } else if (dic_desc == "eos") {
        sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idDictionaryEntryVsl' value='idDictionaryEntryEX'>" + "<td>" + ENTRY_DICTIONARY_EX + "</td>" + "</tr>";
    }

    if (sArtToolsMenu) {
        sArtToolsMenu = sArtToolsMenu + "<tr class='dl'><td>" + delimline + "</td></tr>";
    }
    // vii teise köitesse (sihtköite kontrolliga)
    sArtToolsMenu = sArtToolsMenu + "<tr class='mi' id='idMoveToVolume' value='idMoveToVolume'><td>Vii teise köitesse</td></tr>";

    if (sArtToolsMenu) {
        if (div_ArtToolsMenu.innerHTML) {
            sArtToolsMenu = "<tr class='dl'><td>" + delimline + "</td></tr>" + sArtToolsMenu;
        }
        div_ArtToolsMenu.innerHTML = div_ArtToolsMenu.innerHTML + "<table id='tbl_ArtToolsMenu_veelArtToolse' width='100%' border='0' cellSpacing='0'>" + sArtToolsMenu + "</table>";
    }
} //lisaVeelArtToolse


//--------------------------------------------------------------------------------
function showArtHistory() {
    var oSrc, nX, nY, nVerGap
    oSrc = window.event.srcElement;
    nVerGap = 4 //oSrc border "thin" (2?) ja parent TD padding (2?);
    nX = window.event.clientX + 2 * oSrc.offsetWidth;
    nY = window.event.screenY - window.screenTop - window.event.offsetY - oSrc.offsetTop - nVerGap;
    div_ArtHistoryMenu.style.pixelLeft = nX;
    div_ArtHistoryMenu.style.pixelTop = nY;
    div_ArtHistoryMenu.style.display = "";
    div_ArtHistoryMenu.style.cursor = "default";
    div_ArtHistoryMenu.setCapture();
} //showArtHistory


//--------------------------------------------------------------------------------
function ClickArtHistoryMenu() {
    var sCFP, rida, artGuid, volId, veerg, sPrmDomXml, oPrmDom, oSrc;
    sCFP = div_ArtHistoryMenu.componentFromPoint(window.event.clientX, window.event.clientY);
    if ((jsLeft(sCFP, 6) == "scroll")) {
        div_ArtHistoryMenu.doScroll(sCFP);
    } else if ((sCFP == "")) {
        document.releaseCapture();
        oSrc = window.event.srcElement;
        if ((oSrc.tagName == "TD")) {
            if ((salvestaJaKatkesta())) {
                return;
            }
            rida = oSrc.parentElement;
            artGuid = rida.id;
            volId = rida.getAttribute("v");
            sCmdId = "BrowseRead"; //'sCmdId - globaalne;
            veerg = rida.all.tags("TD")[0];
            sQryInfo = veerg.innerText //sQryInfo - globaalne;

            sPrmDomXml = "<prm>" + "<cmd>" + sCmdId + "</cmd>" + "<vol>" + volId + "</vol>" + "<nfo>" + sQryInfo + "</nfo>" + "<G>" + artGuid + "</G>" + "<qM>MySql</qM>" + "</prm>";
            oPrmDom = IDD("String", sPrmDomXml, false, false, null);
            StartOperation(oPrmDom);
        }
    } else if ((sCFP == "outside")) {
        document.releaseCapture();
    }
} //ClickArtHistoryMenu


//--------------------------------------------------------------------------------
function salvestaJaKatkesta() {
    var salvestaJaKatkesta = false;
    if ((bArtModified && bArtSaveAllowed)) {

        var oArtBackup, avatavad;
        oArtBackup = oEditDOMRoot.firstChild.cloneNode(true);
        avatavad = oArtBackup.selectNodes(".//*/@" + DICPR + ":edO");
        avatavad.removeAll();
        //mõlemad on nüüd "@edO" -st puhtad;
        if ((oOrgArtNode.xml == oArtBackup.xml)) {
            return false;
        }

        var bRet = confirm(SAVE_CHANGES_Q);
        if ((bRet)) {
            imgArtSaveClick();
            salvestaJaKatkesta = true;
        } else {
            var midagi;
            //*/*/ korral jäävad G, K, KA jt välja;
            midagi = oEditDOMRoot.firstChild.selectSingleNode("*//*[name() != '" + qn_ms + "'][normalize-space(text()) != '']");
            if ((midagi == null)) {
                nRetBtn = confirm("Artiklist on olemas ainult märksõna, kuid artikkel EI OLE SALVESTATUD." + '\r\n\r\n' + "Kas soovid artikli kustutada?");
                if ((nRetBtn == 6)) {
                    kustutaArtikkel();
                    salvestaJaKatkesta = true;
                }
            }
        }
    }
    return salvestaJaKatkesta;
} //salvestaJaKatkesta


//-----------------------------------------------------------------------------------
function SetSelectedInfo(sNewId, sNewAttrValue) {
    var tarr, tarr2;
    var oParticle, sEnu;
    var sXsdXPath, oXsdNode, sKirjeldav;
    var sSpnElemsMenuText, sSpnElemsMenuTitle;
    var importDOM, oType

    if (sSeldItemId) {
        if (sSeldAttrValue) {
            div_ElemsMenu.all(sSeldItemId.substr(0, sSeldItemId.lastIndexOf("/"))).className = "mi";
        } else {
            div_ElemsMenu.all(sSeldItemId).className = "mi";
        }
    }

    sSeldItemId = sNewId;

    if (sNewAttrValue) {
        div_ElemsMenu.all(sSeldItemId.substr(0, sSeldItemId.lastIndexOf("/"))).className = "si";
        sSeldElemValue = div_ElemsMenu.all(sSeldItemId.substr(0, sSeldItemId.lastIndexOf("/"))).value;
    } else {
        div_ElemsMenu.all(sSeldItemId).className = "si";
        sSeldElemValue = div_ElemsMenu.all(sSeldItemId).value;
    }
    sSeldAttrValue = sNewAttrValue


    mnuElemLang = "";
    div_ElemEnumsMenu.innerHTML = "";

    //sSeldElemValue: qname|name|URI|IsElement|sKirjeldav
    tarr = sSeldElemValue.split("|");
    if (tarr[1]) { // 'name'
        if (!(yldStruDom == null)) {
            var yldStruElem;
            yldStruElem = yldStruDom.documentElement.selectSingleNode(sSeldItemId);
            if (!(yldStruElem == null)) {
                mnuElemLang = yldStruElem.transformNode(strLangXsl);
            }
        }
        oParticle = oSchRootElems.itemByQName(tarr[1], tarr[2]);
        if ((oParticle.type.enumeration.length > 0)) {
            updElemEnumsMenu();
        }
        if ((oParticle.type.itemType == SOMITEM_COMPLEXTYPE)) {
            if ((oParticle.type.contentType == SCHEMACONTENTTYPE_TEXTONLY)) {
                sel_queryType.selectedIndex = 2 //id = text(), MySql tekstides on ainult elemendi enda tekstid;
            } else if ((oParticle.type.contentType == SCHEMACONTENTTYPE_ELEMENTONLY)) {
                sel_queryType.selectedIndex = 1 //id = self::node(): ".";
            } else if ((oParticle.type.contentType == SCHEMACONTENTTYPE_MIXED)) {
                sel_queryType.selectedIndex = 2 //id = text(), MySql tekstides on ainult elemendi enda tekstid;
            } else {
                sel_queryType.selectedIndex = 1 //id = self::node(): ".";
            }
        } else {
            // if ((oParticle.type.itemType == SOMITEM_SIMPLETYPE))
            sel_queryType.selectedIndex = 1 //id = self::node();
        }
    } else {
        sel_queryType.selectedIndex = 1; //id = self::node();
    }
    if (div_ElemEnumsMenu.innerHTML != "") {
        img_ElemEnumsMenu.src = "graphics/downarrow 16-16.ico";
        img_ElemEnumsMenu.disabled = false;
    } else {
        img_ElemEnumsMenu.src = "graphics/downarrow_grey 16-16.ico";
        img_ElemEnumsMenu.disabled = true;
    }
    sSpnElemsMenuText = tarr[4]; // 'sKirjeldav'
    if (tarr[3] == "1") { // 'IsElement'
        sSpnElemsMenuTitle = sSeldItemId;
    } else {
        sSpnElemsMenuTitle = tarr[0]; // 'qname'
    }

    //atribuutide enum-id
    div_AttrEnumsMenu.innerHTML = "";

    if (sSeldAttrValue) {
        //sSeldAttrValue: qname|name|URI|IsElement|sKirjeldav;
        tarr2 = sSeldAttrValue.split("|");
        if (tarr2[1]) { // 'name'
            updAttrEnumsMenu();
        }
        sSpnElemsMenuText = sSpnElemsMenuText + " " + AND_WORD.toUpperCase() + " " + tarr2[4]; // 'sKirjeldav'
        if (tarr[3] == "0") { // 'IsElement'
            sSpnElemsMenuTitle = sSpnElemsMenuTitle + " /" + tarr2[0]; // 'qname'
        }
        //atribuudi väärtuse textbox;
        inp_AttrText.style.backgroundColor = "";
        inp_AttrText.disabled = false;
        inp_AttrText.setActive();
        inp_AttrText.focus();
        inp_AttrText.select();
    } else {
        inp_AttrText.style.backgroundColor = "silver";
        inp_AttrText.disabled = true;
        inp_ElemText.setActive();
        inp_ElemText.focus();
        inp_ElemText.select();
    }
    if (div_AttrEnumsMenu.innerHTML != "") {
        img_AttrEnumsMenu.src = "graphics/downarrow 16-16.ico";
        img_AttrEnumsMenu.disabled = false;
    } else {
        img_AttrEnumsMenu.src = "graphics/downarrow_grey 16-16.ico";
        img_AttrEnumsMenu.disabled = true;
    }
    spn_ElemsMenu.innerText = sSpnElemsMenuText;
    spn_ElemsMenu.title = sSpnElemsMenuTitle + " [" + mnuElemLang + "]";

    if (sSeldItemId.substr(0, "mySqlYhisedMs".length) == "mySqlYhisedMs") {
        if (sSeldAttrValue) {
            var mTekst = jsTrim(inp_ElemText.value);
            if (!mTekst) {
                mTekst = "*";
            }
            var selectedDics = ';' + dic_desc + ';' + tarr2[0] + ';';
            var search = "cmd=yhised&ms=" + encodeURIComponent(RemoveSymbols(mTekst, ' *?')) + "&dics=" + selectedDics;
            // eelex.eki.ee või eelex.dyn.eki.ee
            window.open("http://" + location.hostname + "/run/SL/Koond/Koond.html?" + search, "_koondParingYhised", "", false);
        }
    }

} //SetSelectedInfo


//-----------------------------------------------------------------------------------
function getEnumsHTML(osake) {
    var tyyp, xPath, dlXPath, tyybiDom, sEnu, enumDocnNode, kirjeldav, enumRows;
    if ((osake.type.name == "")) { //'complexType
        tyyp = osake.type.baseTypes[0];
    } else {
        tyyp = osake.type;
    }
    xPath = ".//xs:simpleType[@name = '" + tyyp.name + "']//xs:enumeration[@value = '[%s]']/xs:annotation/xs:documentation[@xml:lang = '" + sAppLang + "']";
    dlXPath = ".//xs:simpleType[@name = '" + tyyp.name + "']//xs:enumeration[@value = '[%s]']/xs:annotation/xs:documentation[@xml:lang = '" + dest_language + "']";
    if ((tyyp.namespaceURI != DICURI)) {
        tyybiDom = IDD("File", "xsd/" + impSchemaLocations.Item(tyyp.namespaceURI), false, false, null);
        tyybiDom.setProperty("SelectionLanguage", "XPath");
        tyybiDom.setProperty("SelectionNamespaces", jsTrim(sXsdNsList));
    } else {
        tyybiDom = oXsdDOM;
    }
    enumRows = "";
    for (i = 0; i < osake.type.enumeration.length; i++) {
        sEnu = osake.type.enumeration[i];
        enumDocnNode = tyybiDom.documentElement.selectSingleNode(jsReplace(xPath, "[%s]", sEnu));
        if (!(enumDocnNode == null)) {
            kirjeldav = enumDocnNode.text;
            if (!(dest_language == "")) {
                enumDocnNode = tyybiDom.documentElement.selectSingleNode(jsReplace(dlXPath, "[%s]", sEnu));
                if (!(enumDocnNode == null)) {
                    kirjeldav = kirjeldav + " / " + enumDocnNode.text;
                }
            }
        } else {
            kirjeldav = sEnu;
        }
        enumRows = enumRows + "<tr class='mi' " + "id='" + sEnu + "' " + "value='" + sEnu + "'" + "title=''>" + "<td>" + sEnu + "</td>" + "<td>" + kirjeldav + "</td>" + "</tr>";
    }
    return enumRows;
} //getEnumsHTML


//-----------------------------------------------------------------------------------
function updElemEnumsMenu() {
    var sEnumItems, oParticle, tarr;
    sEnumItems = ""

    //sSeldElemValue: qname|name|URI|IsElement|sKirjeldav
    tarr = sSeldElemValue.split("|")
    oParticle = oSchRootElems.itemByQName(tarr[1], tarr[2]);
    sEnumItems = getEnumsHTML(oParticle);
    div_ElemEnumsMenu.innerHTML = "<table id='tbl_ElemEnumsMenu' width='100%' border='0' cellSpacing='0'>" + sEnumItems + "</table>";
    //    if ((div_ElemEnumsMenu.all.tags("TR").length > maxEnumRows)) {
    div_ElemEnumsMenu.style.height = "480px";
    //    } else {
    //        div_ElemEnumsMenu.style.height = "";
    //    }
} //updElemEnumsMenu


//-----------------------------------------------------------------------------------
function updAttrEnumsMenu() {
    var sEnumItems, oParticle, tarr;
    sEnumItems = ""

    //sSeldAttrValue: qname|name|URI|IsElement|sKirjeldav
    tarr = sSeldAttrValue.split("|");
    if ((tarr[1] == "lang" && tarr[2] == NS_XML)) { //'xml:lang
        sEnumItems = getEnumRows();
    } else {
        oParticle = oSchRootAttrs.itemByQName(tarr[1], tarr[2]);
        if ((oParticle.type.enumeration.length > 0)) {
            sEnumItems = getEnumsHTML(oParticle);
        }
    }

    if ((sEnumItems.length > 0)) {
        div_AttrEnumsMenu.innerHTML = "<table id='tbl_AttrEnumsMenu' width='100%' border='0' cellSpacing='0'>" + sEnumItems + "</table>";
        if ((div_AttrEnumsMenu.all.tags("TR").length > maxEnumRows)) {
            div_AttrEnumsMenu.style.height = "480px";
        } else {
            div_AttrEnumsMenu.style.height = "";
        }
    }
} //updAttrEnumsMenu


//-----------------------------------------------------------------------------------
function ShowAdminView() {
    var smdArgs, retVal, artGuid, sLinkVols, volId, opt;
    artGuid = "";
    if ((oEditDOMRoot.hasChildNodes()))
        artGuid = oEditDOMRoot.selectSingleNode(DICPR + ":A/" + qn_guid).text;
    sLinkVols = "";
    volId = "";
    for (i = 0; i < sel_Vol.options.length; i++) {
        opt = sel_Vol.options[i];
        if ((opt.id == dic_desc + "All")) {
            break;
        }
        sLinkVols = sLinkVols + "<option id='" + opt.id + "'";
        if ((opt.selected == true)) {
            sLinkVols = sLinkVols + " selected";
            volId = opt.id;
        }
        sLinkVols = sLinkVols + ">" + opt.text + "</option>";
    }

    // sDicName - 'lexlist.xml' failist pannakse 'art.cgi' kaudu serverist kaasa 'spn_SrvParms' kaudu
    smdArgs = dic_desc + JR + sUsrName + JR + sAppLang + JR +
            sDicName + JR +
            sMarkSona + JR +
            artGuid + JR +
            sLinkVols + JR +
            volId + JR +
            gendXslNimi;
    retVal = window.showModalDialog("html/gen_view.htm", smdArgs, "dialogHeight:768;dialogWidth:1024;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");

    if (retVal) {

        initViewTransform(1);

        if (oEditDOMRoot.hasChildNodes())
            vaatedRefresh(1);

        window.status = "Vaate uuendamine OK (" + retVal + ")!";
    }
} //ShowAdminView


//-----------------------------------------------------------------------------------
function ShowSkeemiGen() {
    var smdArgs, retVal;
    smdArgs = new Array(dic_desc, sUsrName, sAppLang);
    retVal = window.showModalDialog("html/gen_skeem.htm", smdArgs, "dialogHeight:640px;dialogWidth:1100px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:yes;unadorned:no");
    if (retVal) {
        var sXSDFile;
        sXSDFile = "xsd/schema_" + dic_desc + ".xsd";
        oXsdDOM = IDD("File", sXSDFile, false, false, null);
        oXsdDOM.setProperty("SelectionLanguage", "XPath");
        oXsdDOM.setProperty("SelectionNamespaces", jsTrim(sXsdNsList))

        oXsdSc = new ActiveXObject("Msxml2.XMLSchemaCache.6.0");
        oXsdSc.validateOnLoad = true;
        oXsdSc.add(DICURI, sXSDFile)

        oEditDOM = IDD("String", oEditDOM.xml, false, false, oXsdSc);
        oEditDOM.setProperty("SelectionLanguage", "XPath");
        oEditDOM.setProperty("SelectionNamespaces", sXmlNsList);
        oEditDOMRoot = oEditDOM.documentElement

        oXmlSc = oEditDOM.namespaces

        oSchRootElems = oXmlSc.getSchema(DICURI).elements;
        oSchRootAttrs = oXmlSc.getSchema(DICURI).attributes

        //üldstruktuur
        yldStruDom = IDD("File", "xml/" + dic_desc + "/stru_" + dic_desc + ".xml", false, false, oXsdSc);
        if (yldStruDom.parseError.errorCode != 0) {
            yldStruDom = null;
        } else {
            yldStruDom.setProperty("SelectionLanguage", "XPath");
            yldStruDom.setProperty("SelectionNamespaces", jsTrim(sXsdNsList) + " xmlns:" + SDPR + "='" + SDURI + "'");
        }

        FillElementsMenu();
        SetSelectedInfo(default_query, "");
        sqnastikuTooriistad();

        initEditTransform();

        var xh, rspDOM, sta, status, myCSS;
        var editCssHREF = "css/gendEdit_" + dic_desc + ".css";
        xh = exCGISync("tools.cgi", "getTextFileContent" + PD + dic_desc + PD + sUsrName + PD +
                    editCssHREF);
        if (xh.statusText == "OK") {
            rspDOM = IDD("", "", false, false, null);
            sta = rspDOM.load(xh.responseXML); //'responseXML: TypeName = DomDocument

            if (sta) {
                status = rspDOM.selectSingleNode("rsp/sta").text;
                if (status == "Success") {
                    myCSS = rspDOM.selectSingleNode("rsp/answer").text;
                    editCSS.cssText = myCSS;
                }
                else
                    alert(status);
            }
        }
        else {
            alert(xh.status + ": " + xh.statusText + xh.responseText);
        }

        if (oEditDOMRoot.hasChildNodes())
            vaatedRefresh(2);

        window.status = "Skeemi uuendamine OK (" + retVal + ")!";
    }
} //ShowSkeemiGen


//-----------------------------------------------------------------------------------
function FillElementsMenu() {
    var oParticle, sItemURI, sItemQN;
    var sMaxSymbol, sSubMenu;
    var sXsdXPath, oXsdNode, sKirjeldav, sFullPath, sPr;

    oParticle = oXmlSc.getDeclaration(oEditDOMRoot)

    if (!(oParticle.namespaceURI == "")) {
        sItemURI = oParticle.namespaceURI;
        sPr = oXmlNsm.getPrefixes(sItemURI).item(0);
        if ((sPr == "")) {
            sItemQN = oParticle.name;
        } else {
            sItemQN = sPr + ":" + oParticle.name;
        }
    } else {
        sItemURI = "";
        sItemQN = oParticle.name;
    }

    var nContentType, nGroupType, sDispType;
    if ((oParticle.type.itemType == SOMITEM_COMPLEXTYPE)) {
        nContentType = oParticle.type.contentType;
        if ((nContentType == SCHEMACONTENTTYPE_MIXED)) {
            sDispType = "Ct,Mx";
        } else if ((nContentType == SCHEMACONTENTTYPE_ELEMENTONLY)) {
            sDispType = "Ct,Eo";
        } else if ((nContentType == SCHEMACONTENTTYPE_TEXTONLY)) {
            sDispType = "Ct,To";
        } else if ((nContentType == SCHEMACONTENTTYPE_EMPTY)) {
            sDispType = "Ct, ";
        }
        //"ISchemaComplexType" korral peaks alati olema TypeName(oParticle.type.contentModel) = "ISchemaModelGroup" ?;
        nGroupType = oParticle.type.contentModel.itemType;
        if ((nGroupType == SOMITEM_EMPTYPARTICLE)) {
            sDispType = sDispType + ", ";
        } else if ((nGroupType == SOMITEM_SEQUENCE)) {
            sDispType = sDispType + ",Sq";
        } else if ((nGroupType == SOMITEM_CHOICE)) {
            sDispType = sDispType + ",Ch";
        } else if ((nGroupType == SOMITEM_ALL)) {
            sDispType = sDispType + ",All";
        }
        if ((oParticle.type.attributes.length > 0)) {
            sSubMenu = String.fromCharCode("0x" + jsMid(BLACK_RIGHT_POINTING_POINTER, 3, 4));
        } else {
            sSubMenu = "";
        }
    } else {
        // if ((oParticle.type.itemType == SOMITEM_SIMPLETYPE))
        nContentType = -1;
        nGroupType = -1;
        sDispType = "St";
    }

    if ((oParticle.maxOccurs == "-1")) {
        sMaxSymbol = String.fromCharCode("0x" + jsMid(eeLex_INFINITY, 3, 4));
    } else {
        sMaxSymbol = oParticle.maxOccurs;
    }
    sXsdXPath = ".//" + NS_XS_PR + ":element[@name='" + oParticle.name + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + sAppLang + "']"
    oXsdNode = oXsdDOM.documentElement.selectSingleNode(sXsdXPath);
    if (!(oXsdNode == null)) {
        sKirjeldav = oXsdNode.text;
    } else {
        sKirjeldav = sItemQN;
    }
    sFullPath = sItemQN;

    div_ElemsMenu.innerHTML = "<table id='tbl_ElementsMenu' width='100%' border='0' cellSpacing='0'></table>";
    oElMenuTable = div_ElemsMenu.all("tbl_ElementsMenu");

    valmisParingud();

    aTTAPlokid = ';';
    if (oParticle.type.itemType == SOMITEM_COMPLEXTYPE) {
        GetMenuElements(oParticle, "", 0);
    }

} //FillElementsMenu


//-----------------------------------------------------------------------------------
function GetMenuElements(oISchItem, sFullPath, nDepth) {
    var sItemURI, sItemQN;
    var nContentType, nGroupType, sDispType;
    var sMinSymbol, sMaxSymbol, sSubMenu, sXsdXPath, oXsdNode, sKirjeldav, sElemPath;
    var oXmlFrDom, sPr, sLName, aAnyNames;
    var sParentQN;
    var i;
    var oNewTableRow, oNewRowCell;
    var sRowVal

    if (!(oISchItem.namespaceURI == "")) {
        sPr = oXmlNsm.getPrefixes(oISchItem.namespaceURI).item(0);
        if ((sPr == "")) {
            sParentQN = oISchItem.name;
        } else {
            sParentQN = sPr + ":" + oISchItem.name;
        }
    } else {
        sParentQN = oISchItem.name;
    }

    var oFirstParticle
    oFirstParticle = oISchItem.type.contentModel.particles[0]

    var oParticle, nParticleCount, xh, oRespDom, sta;
    if ((oFirstParticle.itemType == SOMITEM_ANY)) {
        //aa: "add any";
        xh = exCGISync("tools.cgi", "getAddElements" + JR + dic_desc + JR + sUsrName + JR + "xml/" + dic_desc + "/" + JR + "aa_" + unName(sParentQN) + ".xml" + JR + "");
        if ((xh.statusText == "OK")) {
            oRespDom = xh.responseXML //responseXML: TypeName = DomDocument;
            sta = oRespDom.selectSingleNode("rsp/sta").text;
            if ((sta == "Success")) {
                aAnyNames = oRespDom.selectSingleNode("rsp/answer").text.split("|");
                nParticleCount = aAnyNames.length;
            }
        }
        //   oXmlFrDom = IDD("file", "xml/" + dic_desc + "/aa_" + unName(sParentQN) + ".xml",  false, false, null)
        if (!(sta == "Success")) {
            sItemURI = NS_XS;
            sItemQN = NS_XS_PR + ":any";
            sDispType = "Any,-,-";
            sKirjeldav = sItemQN;
            oParticle = oFirstParticle;
            if ((oParticle.maxOccurs == "-1")) {
                sMaxSymbol = String.fromCharCode("0x" + jsMid(eeLex_INFINITY, 3, 4));
            } else {
                sMaxSymbol = oParticle.maxOccurs;
            }
            if ((sFullPath == "")) {
                sElemPath = sItemQN;
            } else {
                sElemPath = sFullPath + "/" + sItemQN;
            }
            oNewTableRow = oElMenuTable.insertRow();
            oNewTableRow.className = "mi";
            oNewTableRow.id = sElemPath;
            oNewTableRow.setAttribute("value", sItemQN + "|" + oParticle.name + "|" + sItemURI + "|1|" + sKirjeldav);
            oNewTableRow.title = sElemPath

            oNewRowCell = oNewTableRow.insertCell();
            oNewRowCell.innerText = jsStrRepeat(4 * nDepth, "\u00A0") + sKirjeldav;
            oNewRowCell = oNewTableRow.insertCell();
            oNewRowCell.innerText = sItemQN;
            oNewRowCell = oNewTableRow.insertCell();
            oNewRowCell.innerText = sDispType;
            oNewRowCell = oNewTableRow.insertCell();
            oNewRowCell.innerText = "(" + oParticle.minOccurs + ", " + sMaxSymbol + ")";
            oNewRowCell = oNewTableRow.insertCell() //sSubMenu;
            return;
        }
    } else {
        nParticleCount = oISchItem.type.contentModel.particles.length;
    }

    for (i = 0; i < nParticleCount; i++) {
        if ((oFirstParticle.itemType == SOMITEM_ANY)) {
            sItemQN = aAnyNames[i];
            if ((sItemQN.indexOf(":") > -1)) {
                sPr = jsMid(sItemQN, 0, sItemQN.indexOf(":"));
                sLName = jsMid(sItemQN, sItemQN.indexOf(":") + 1);
                sItemURI = oXmlNsm.getURI(sPr);
            } else {
                sPr = "";
                sLName = sItemQN;
                sItemURI = oXmlNsm.getURI("");
            }
            oParticle = oSchRootElems.itemByQName(sLName, sItemURI);
        } else if ((oFirstParticle.itemType == SOMITEM_ELEMENT)) {
            oParticle = oISchItem.type.contentModel.particles[i];
            if (!(oParticle.namespaceURI == "")) {
                sItemURI = oParticle.namespaceURI;
                sPr = oXmlNsm.getPrefixes(sItemURI).item(0);
                if ((sPr == "")) {
                    sItemQN = oParticle.name;
                } else {
                    sItemQN = sPr + ":" + oParticle.name;
                }
            } else {
                sItemURI = "";
                sItemQN = oParticle.name;
            }
        }

        nContentType = -1;
        nGroupType = -1;
        sSubMenu = ""

        if ((oParticle.type.itemType == SOMITEM_COMPLEXTYPE)) {
            nContentType = oParticle.type.contentType;
            if ((nContentType == SCHEMACONTENTTYPE_MIXED)) {
                sDispType = "Ct,Mx";
            } else if ((nContentType == SCHEMACONTENTTYPE_ELEMENTONLY)) {
                sDispType = "Ct,Eo";
            } else if ((nContentType == SCHEMACONTENTTYPE_TEXTONLY)) {
                sDispType = "Ct,To";
            } else if ((nContentType == SCHEMACONTENTTYPE_EMPTY)) {
                sDispType = "Ct, ";
            }
            //"ISchemaComplexType" korral peaks alati olema TypeName(oParticle.type.contentModel) = "ISchemaModelGroup" ?;
            nGroupType = oParticle.type.contentModel.itemType;
            if ((nGroupType == SOMITEM_EMPTYPARTICLE)) {
                sDispType = sDispType + ", ";
            } else if ((nGroupType == SOMITEM_SEQUENCE)) {
                sDispType = sDispType + ",Sq";
            } else if ((nGroupType == SOMITEM_CHOICE)) {
                sDispType = sDispType + ",Ch";
            } else if ((nGroupType == SOMITEM_ALL)) {
                sDispType = sDispType + ",All";
            }
            if (oParticle.type.attributes.length > 0) {
                sSubMenu = String.fromCharCode("0x" + jsMid(BLACK_RIGHT_POINTING_POINTER, 3, 4));
                var ea = new Enumerator(oParticle.type.attributes);
                var tunnused = { "aT": 0, "aTA": 0 };
                ea.moveFirst();
                while (ea.atEnd() == false) {
                    var attr = ea.item();
                    if (attr.name == "aT" || attr.name == "aTA") {
                        tunnused[attr.name] = 1;
                    }
                    ea.moveNext();
                } // while
                if (tunnused["aT"] == 1 && tunnused["aTA"] == 1) {
                    aTTAPlokid += sItemQN + ';';
                }
            }
        } else {
            // if ((oParticle.type.itemType == SOMITEM_SIMPLETYPE))
            sDispType = "St";
        }
        sXsdXPath = ".//" + NS_XS_PR + ":element[@name='" + oParticle.name + "']/" + NS_XS_PR + ":annotation/" + NS_XS_PR + ":documentation[@xml:lang='" + sAppLang + "']";
        oXsdNode = oXsdDOM.documentElement.selectSingleNode(sXsdXPath);
        if (!(oXsdNode == null)) {
            sKirjeldav = oXsdNode.text;
        } else {
            sKirjeldav = sItemQN;
        }

        if ((oFirstParticle.itemType == SOMITEM_ANY)) {
            sMinSymbol = oFirstParticle.minOccurs;
            if ((oFirstParticle.maxOccurs == "-1")) {
                sMaxSymbol = String.fromCharCode("0x" + jsMid(eeLex_INFINITY, 3, 4));
            } else {
                sMaxSymbol = oFirstParticle.maxOccurs;
            }
        } else if ((oFirstParticle.itemType == SOMITEM_ELEMENT)) {
            sMinSymbol = oParticle.minOccurs;
            if ((oParticle.maxOccurs == "-1")) {
                sMaxSymbol = String.fromCharCode("0x" + jsMid(eeLex_INFINITY, 3, 4));
            } else {
                sMaxSymbol = oParticle.maxOccurs;
            }
        }

        if ((sFullPath == "")) {
            sElemPath = sItemQN;
        } else {
            sElemPath = sFullPath + "/" + sItemQN;
        }

        oNewTableRow = oElMenuTable.insertRow();
        oNewTableRow.className = "mi";
        oNewTableRow.id = sElemPath

        sRowVal = sItemQN + "|" + oParticle.name + "|" + sItemURI + "|1|" + sKirjeldav

        oNewTableRow.setAttribute("value", sRowVal);
        oNewTableRow.title = sElemPath;

        oNewRowCell = oNewTableRow.insertCell();
        oNewRowCell.innerText = jsStrRepeat(4 * nDepth, "\u00A0") + sKirjeldav;
        oNewRowCell = oNewTableRow.insertCell();
        oNewRowCell.innerText = sItemQN;
        oNewRowCell = oNewTableRow.insertCell();
        oNewRowCell.innerText = sDispType;
        oNewRowCell = oNewTableRow.insertCell();
        oNewRowCell.innerText = "(" + sMinSymbol + ", " + sMaxSymbol + ")";
        oNewRowCell = oNewTableRow.insertCell();
        oNewRowCell.innerText = sSubMenu

        if ((oParticle.type.itemType == SOMITEM_COMPLEXTYPE)) {
            if ((oParticle.type.contentModel.particles.length > 0)) {
                //nt q:no (ÕS) pärast läheb tsüklisse;
                if (!(sParentQN == sItemQN)) {
                    GetMenuElements(oParticle, sElemPath, nDepth + 1);
                }
            }
        }
    }
} //GetMenuElements


//-----------------------------------------------------------------------------------
function artExpandCollapse() {
    var oSrc, pilt, avatud, kinniLahtid, kinniLahti
    oSrc = window.event.srcElement;
    pilt = "graphics/112_Minus_Orange_16x16_72.png";
    //dün "src": kirjas on täielik tee
    if ((jsRight(oSrc.src, pilt.length) == pilt)) {
        avatud = "0";
    } else {
        avatud = "1";
    }
    kinniLahtid = oEditDOMRoot.selectNodes(".//@" + DICPR + ":edO");
    for (i = 0; i < kinniLahtid.length; i++) {
        kinniLahtid[i].value = avatud;
    }
    vaatedRefresh(2);
} //artExpandCollapse


//-----------------------------------------------------------------------------------
function useSymbolsOnClick() {
    var oSrc, pilt, avatud, kinniLahtid, kinniLahti
    oSrc = window.event.srcElement;
    if ((oSrc.checked)) {
        inp_UseFakult.checked = false;
        inp_UseFakult.disabled = true;
    } else {
        inp_UseFakult.disabled = false;
    }
} //useSymbolsOnClick


//-----------------------------------------------------------------------------------
function imgArtExportClick() {

    var qM = "MySql";
    if (window.event.ctrlLeft) {
        qM = "XML";
    }

    var oPrmDom = GetQueryParams(qM);
    if (!oPrmDom) {
        alert(QUERY_ERROR, jsvbCritical, QUERY_WORD);
        return;
    }

    var art_xpath, pQrySql, volId, volCond;
    qM = oPrmDom.documentElement.selectSingleNode("qM").text;
    art_xpath = oPrmDom.documentElement.selectSingleNode("axp").text;
    pQrySql = oPrmDom.documentElement.selectSingleNode("pQrySql").text;

    var smdArgs = sQryInfo + JR + "c:/EELex/Väljatrükid/artiklid.doc" + JR + dic_desc + JR + sAppLang + JR + 'blahh';
    var sParms = window.showModalDialog("html/artsprint.htm", smdArgs, "dialogHeight:400px;dialogWidth:800px;center:yes;edge:sunken;help:no;resizable:yes;scroll:yes;status:no;unadorned:no");
    if (!sParms) {
        return;
    }

    volId = sel_Vol.options(sel_Vol.selectedIndex).id;
    volCond = dic_desc + ".vol_nr = " + jsMid(volId, 3, 1);
    if (volId == dic_desc + "All") {
        volCond = dic_desc + ".vol_nr > 0";
    }

    //1                    2          3          4              5                  6
    //useQuery|useM + JR + sM1 + JR + sM2 + JR + nPageNr + JR + useFullText + JR + sFile
    var tarr = sParms.split(JR);

    //Märksõna lõppu võib vajadusel lisada hom nr - i,
    //seda maha ei teisendata, pealegi od_ korral koosneb kogu märksõna numbritest.
    if (tarr[0] == "useQuery") {
        var ix, ordBy;
        ix = pQrySql.indexOf(" ORDER BY ");
        ordBy = jsMid(pQrySql, ix);
        pQrySql = jsMid(pQrySql, 0, ix) + " GROUP BY " + dic_desc + ".G" + ordBy;
    } else {
        sQryInfo = "[1. " + HEADWORD_WORD + " (" + first_default + ") [ >= '" + tarr[1] + "' " + AND_WORD.toUpperCase() + " <= '" + tarr[2] + "' ]], " + CASE_INSENSITIVE + ", " + SYMS_EXCLUDED;
        //so siis märkideta, tõstutundetu, lokaalne;
        var ms1, ms2, msPred, msTekstTing;
        ms1 = RemoveSymbols(tarr[1].toLowerCase(), " ");
        ms2 = RemoveSymbols(tarr[2].toLowerCase(), " ");
        // "compMs" kasutas kunagi Perl 'ge', 'le', need ei tööta eesti järjestuse puhul
        msPred = "[al_p:compMs(., '" + ms1 + "', '" + ms2 + "') > 0]";
        art_xpath = first_default.substr(0, first_default.indexOf("/")) + "[" + first_default.substr(first_default.indexOf("/") + 1) + msPred + "]";

        // "STRCMP" peaks töötama normaalselt, välja arvatud et võrreldakse kõiki ms-gruppe, mitte ainult esimest
        // seega tulevad väljatrükile kaasa igasugused, mis vahemikku klapivad
        // prigantiin, brigantiin
        msTekstTing = "STRCMP(msid.ms_nos, '" + ms1 + "') >= 0 AND STRCMP(msid.ms_nos, '" + ms2 + "') <= 0";
        msTekstTing = " AND (" + msTekstTing + ")";

        pQrySql = "SELECT " + dic_desc + ".md AS md, " + "msid.ms AS l, " + "msid.ms_att_i AS ms_att_i, msid.ms_att_liik AS ms_att_liik, " + "msid.ms_att_ps AS ms_att_ps, msid.ms_att_tyyp AS ms_att_tyyp, msid.ms_att_mliik AS ms_att_mliik, " + "msid.ms_att_k AS ms_att_k, msid.ms_att_mm AS ms_att_mm, msid.ms_att_st AS ms_att_st, " + "msid.ms_att_vm AS ms_att_vm, msid.ms_att_all AS ms_att_all, msid.ms_att_uus AS ms_att_uus, " + "msid.ms_att_zs AS ms_att_zs, msid.ms_att_u AS ms_att_u, msid.ms_att_em AS ms_att_em, " + dic_desc + ".G AS G, " + dic_desc + ".art AS art, " + dic_desc + ".K AS K, " + dic_desc + ".T AS T, " + dic_desc + ".TA AS TA, " + dic_desc + ".PT AS PT, " + dic_desc + ".vol_nr AS vol_nr " + "FROM msid, " + dic_desc + " WHERE (" + dic_desc + ".G = msid.G" + " AND msid.dic_code = '" + dic_desc + "'" + msTekstTing + " AND " + volCond + ")" + " GROUP BY " + dic_desc + ".G" + " ORDER BY " + dic_desc + ".ms_att_OO";

        // olgu "XML", et vältida sql korral tulevaid artikleid, mis rahuldavad tingimust teise jne ms tõttu
        qM = "XML";
    }

    showDbgVar("sQryInfo", sQryInfo, "imgArtExportClick", "", " ", new Date());
    showDbgVar("art_xpath", art_xpath, "imgArtExportClick", "", " ", new Date());
    showDbgVar("pQrySql", pQrySql, "imgArtExportClick", "", " ", new Date());
    showDbgVar("qM", qM, "imgArtExportClick", "", " ", new Date());

    nStartPageNumber = parseInt(tarr[3]);
    bRemoveShaded = !jsStringToBoolean(tarr[4]);
    sWordFileName = tarr[5];

    sCmdId = "ClientPrint";

    oPrmDom.documentElement.selectSingleNode("cmd").text = sCmdId;
    oPrmDom.documentElement.selectSingleNode("vol").text = volId;
    oPrmDom.documentElement.selectSingleNode("nfo").text = sQryInfo;
    oPrmDom.documentElement.selectSingleNode("axp").text = art_xpath;
    oPrmDom.documentElement.selectSingleNode("qM").text = qM;
    oPrmDom.documentElement.selectSingleNode("pQrySql").text = pQrySql;

    StartOperation(oPrmDom);
} //imgArtExportClick
