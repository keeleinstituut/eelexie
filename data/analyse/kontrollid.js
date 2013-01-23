
//Copyright© 2006 - 2012. Andres Loopmann, EKI, andres.loopmann@eki.ee. All rights reserved.


//-----------------------------------------------------------------------------------
function tekstiTeisendused(tekst) {
    var uusTekst = tekst, tarr, i;

    uusTekst = uusTekst.replace(/</g, "\u2039");
    uusTekst = uusTekst.replace(/>/g, "\u203A");
    uusTekst = uusTekst.replace(/\r|\n/g, "");
    uusTekst = uusTekst.replace(/\t/g, " ");

    if (dic_desc == "ukr") {
        if (elemlang == "uk") {
            tarr = uusTekst.split("\"");
            for (i = 1; i < tarr.length; i++) {
                tarr[i] = tarr[i].substr(0, 1) + "\u0301" + tarr[i].substr(1);
            }
            uusTekst = tarr.join("");
        }
    }
    if (dic_desc == "ems") {
        uusTekst = uusTekst.replace(/•/g, "·"); // 2022 -> B7
    }
    return uusTekst
} // tekstiTeisendused


//-----------------------------------------------------------------------------------
function ValueChecks(newTxtVal, oldTxtVal) {

    var boundNode, tekst = newTxtVal;

    // märksõna
    if (selectedNode.nodeName == qn_ms && selectedNode.nodeType == NODE_ELEMENT) { // Node.ELEMENT_NODE
        setMyNSAttribute(selectedNode, DICURI, qn_sort_attr, getSortVal(selectedNode, true, true));
    }
    // hom nr
    if (selectedNode.nodeName == qn_homnr && selectedNode.nodeType == NODE_ATTRIBUTE && fatherNode.nodeName == qn_ms) { // Node.ATTRIBUTE_NODE
        setMyNSAttribute(fatherNode, DICURI, qn_sort_attr, getSortVal(fatherNode, true, true));
    }

    // kommentaar
    if (selectedNode.nodeName == DICPR + ":kom") {
        if (dic_desc != "od_") {
            boundNode = getXmlSingleNode(fatherNode, DICPR + ":kaut");
            if (!boundNode) {
                boundNode = fatherNode.appendChild(createMyNSElement(oEditDOM, DICPR + ":kaut", DICURI));
            }
            setXmlNodeValue(boundNode, sUsrName);
            boundNode = getXmlSingleNode(fatherNode, DICPR + ":kaeg");
            if (!boundNode) {
                boundNode = fatherNode.appendChild(createMyNSElement(oEditDOM, DICPR + ":kaeg", DICURI));
            }
            setXmlNodeValue(boundNode, GetXSDDateTime(new Date()));
        }
    }

    // märkus
    if (selectedNode.nodeName == DICPR + ":mrk") {
        setMyNSAttribute(selectedNode, DICURI, DICPR + ":maut", sUsrName);
        setMyNSAttribute(selectedNode, DICURI, DICPR + ":maeg", GetXSDDateTime(new Date()));
    }

    // tüübinumber
    if (selectedNode.nodeName == DICPR + ":mt") {
        if (dic_desc == "mab" || dic_desc == "ex_") {
            if (tekst.length < 2) {
                tekst = "0" + tekst;
                setXmlNodeValue(selectedNode, tekst);
            }
        }
    }

    ValueDicChecks(tekst);

    setATTAPlokid(selectedNode);

} //ValueChecks


////-----------------------------------------------------------------------------------
//function setATTAPlokid(kontrollitav) {
//    if (aTTAPlokid.length > 1) {
//        var currNode = kontrollitav;
//        while (currNode) {
//            if (aTTAPlokid.indexOf(";" + currNode.nodeName + ";") > -1) {
//                currNode.setAttributeNS(DICURI, DICPR + ":aT", sUsrName);
//                currNode.setAttributeNS(DICURI, DICPR + ":aTA", GetXSDDateTime(new Date()));
//                break;
//            }
//            currNode = currNode.parentNode;
//        }
//    }
//} // setATTAPlokid


//-----------------------------------------------------------------------------------
function setATTAPlokid(kontrollitav) {
    if (aTTAPlokid.length > 1) {
        var muudetav = getXmlSingleNode(kontrollitav, "ancestor-or-self::*[contains('" + aTTAPlokid + "', concat(';', name(), ';'))][1]");
        if (muudetav) {
            setMyNSAttribute(muudetav, DICURI, DICPR + ":aT", sUsrName);
            setMyNSAttribute(muudetav, DICURI, DICPR + ":aTA", GetXSDDateTime(new Date()));
        }
    }
} // setATTAPlokid


//-----------------------------------------------------------------------------------
function ValueDicChecks(uusTekst) {
    if (dic_desc == "eos") {
        //        var boundNode, paariliseMuutus;
        //        paariliseMuutus = false;

        //        var otsitav = "|" + DICPR + ":soov|" + DICPR + ":anto|" + DICPR + ":type|";
        //        if ((otsitav.indexOf("|" + selectedNode.nodeName + "|") > -1)) {
        //            if ((selectedNode.nodeName == DICPR + ":soov" && cVal == "ep")) {
        //                paariliseMuutus = SetAttrEsiTekstid(DICPR + ":m|" + DICPR + ":a", "ancestor::" + DICPR + ":hdr|ancestor::" + DICPR + ":tahendus", DICPR + ":k1", "parem:");
        //                if (!(paariliseMuutus)) {
        //                    paariliseMuutus = SetAttrEsiTekstid(DICPR + ":m|" + DICPR + ":a", "ancestor::" + DICPR + ":naited", DICPR + ":k", "parem:");
        //                }
        //            } else if ((selectedNode.nodeName == DICPR + ":soov" && cVal == "np")) {
        //                paariliseMuutus = SetAttrEsiTekstid(DICPR + ":n|" + DICPR + ":no|" + DICPR + ":a", "ancestor::" + DICPR + ":hdr|ancestor::" + DICPR + ":tahendus", DICPR + ":k1", "parem kui");
        //                if (!(paariliseMuutus)) {
        //                    paariliseMuutus = SetAttrEsiTekstid(DICPR + ":n|" + DICPR + ":no|" + DICPR + ":a", "ancestor::" + DICPR + ":naited", DICPR + ":k", "parem kui");
        //                }
        //            } else if ((selectedNode.nodeName == DICPR + ":anto" && cVal == "ap")) {
        //                paariliseMuutus = SetAttrEsiTekstid(DICPR + ":a", "ancestor::" + DICPR + ":tahendus", DICPR + ":k1", "Vastand");
        //                if (!(paariliseMuutus)) {
        //                    paariliseMuutus = SetAttrEsiTekstid(DICPR + ":a", "ancestor::" + DICPR + ":naited", DICPR + ":k", "vastand");
        //                }
        //            } else if ((selectedNode.nodeName == DICPR + ":type" && cVal == "ei")) {
        //                paariliseMuutus = SetAttrEsiTekstid(DICPR + ":t", "ancestor::" + DICPR + ":tahendus", DICPR + ":k1", "ei soovita tähenduses:");
        //                if (!(paariliseMuutus)) {
        //                    paariliseMuutus = SetAttrEsiTekstid(DICPR + ":t", "ancestor::" + DICPR + ":naited", DICPR + ":k", "ei soovita tähenduses:");
        //                }
        //            }
        //        }

        //        if ((paariliseMuutus)) {
        //            otsitav = "|" + DICPR + ":soov|" + DICPR + ":anto|";
        //            if ((otsitav.indexOf("|" + selectedNode.nodeName + "|") > -1)) {
        //                alert(PARTNER_CHANGED_TITLE + '\n\n' + PARTNER_CHANGED_TEXT);
        //            }
        //            needsRefresh = true;
        //        }
    } else if (dic_desc == "qs_") {
        //        var boundNode, paariliseMuutus;
        //        paariliseMuutus = false;

        //        if ((selectedNode.nodeName == DICPR + ":mvt")) {
        //            boundNode = selectedNode.attributes.getNamedItem(DICPR + ":kuhu");
        //            if ((boundNode == null)) {
        //                boundNode = oEditDOM.createNode(NODE_ATTRIBUTE, DICPR + ":kuhu", DICURI);
        //                selectedNode.attributes.setNamedItem(boundNode);
        //            }
        //            boundNode.value = cVal;
        //            needsRefresh = true;
        //        }

        //        var otsitav = "|" + DICPR + ":soov|" + DICPR + ":anto|" + DICPR + ":type|";
        //        if (otsitav.indexOf("|" + selectedNode.nodeName + "|") > -1) {
        //            if ((selectedNode.nodeName == DICPR + ":soov" && cVal == "ep")) {
        //                paariliseMuutus = SetAttrEsiTekstid(DICPR + ":m|" + DICPR + ":a", "ancestor::" + DICPR + ":hdr|ancestor::" + DICPR + ":tahendus", DICPR + ":k1", "parem:");
        //                if (!(paariliseMuutus)) {
        //                    paariliseMuutus = SetAttrEsiTekstid(DICPR + ":m|" + DICPR + ":a", "ancestor::" + DICPR + ":naited", DICPR + ":k", "parem:");
        //                }
        //            } else if ((selectedNode.nodeName == DICPR + ":soov" && cVal == "np")) {
        //                paariliseMuutus = SetAttrEsiTekstid(DICPR + ":n|" + DICPR + ":no|" + DICPR + ":a", "ancestor::" + DICPR + ":hdr|ancestor::" + DICPR + ":tahendus", DICPR + ":k1", "parem kui");
        //                if (!(paariliseMuutus)) {
        //                    paariliseMuutus = SetAttrEsiTekstid(DICPR + ":n|" + DICPR + ":no|" + DICPR + ":a", "ancestor::" + DICPR + ":naited", DICPR + ":k", "parem kui");
        //                }
        //            } else if ((selectedNode.nodeName == DICPR + ":anto" && cVal == "ap")) {
        //                paariliseMuutus = SetAttrEsiTekstid(DICPR + ":a", "ancestor::" + DICPR + ":tahendus", DICPR + ":k1", "Vastand");
        //                if (!(paariliseMuutus)) {
        //                    paariliseMuutus = SetAttrEsiTekstid(DICPR + ":a", "ancestor::" + DICPR + ":naited", DICPR + ":k", "vastand");
        //                }
        //            } else if ((selectedNode.nodeName == DICPR + ":type" && cVal == "ei")) {
        //                paariliseMuutus = SetAttrEsiTekstid(DICPR + ":t", "ancestor::" + DICPR + ":tahendus", DICPR + ":k1", "ei soovita tähenduses:");
        //                if (!(paariliseMuutus)) {
        //                    paariliseMuutus = SetAttrEsiTekstid(DICPR + ":t", "ancestor::" + DICPR + ":naited", DICPR + ":k", "ei soovita tähenduses:");
        //                }
        //            }
        //        }
        //        otsitav = "|" + DICPR + ":soov|" + DICPR + ":anto|";
        //        if ((paariliseMuutus)) {
        //            if (otsitav.indexOf("|" + selectedNode.nodeName + "|") > -1) {
        //                alert(PARTNER_CHANGED_TITLE + '\n\n' + PARTNER_CHANGED_TEXT);
        //            }
        //            needsRefresh = true;
        //        }
    } else if (dic_desc == "sp_" || dic_desc == "spi" || dic_desc == "spp") {
        if ((selectedNode.nodeName == DICPR + ":ml") && selectedNode.nodeType == NODE_ELEMENT) {
            setMyNSAttribute(selectedNode, DICURI, DICPR + ":mm", SetMsMall(selectedNode));
        }
    } else if (dic_desc == "mab") {
        if (selectedNode.nodeName == DICPR + ":mt") {
            //teha valmis tüvede grupid <tvg> koos koodidega<tvk>
            var tyveKoodid = {
                "00": "a0 b0",
                "01": "a0 a0r",
                "02": "a0 b0 b0r c0",
                "03": "an (at) bt btr",
                "04": "a0 b0",
                "05": "an (at) bt btr",
                "06": "an at",
                "07": "an (at) bt btr",
                "08": "an (at) bt",
                "09": "a0 b0",
                "10": "a0 b0 c0",
                "11": "a0 b0 b0v",
                "12": "a0 b0 c0 b0v",
                "13": "at (bt) an bn bnv",
                "14": "at (bt) an bn cn ct",
                "15": "at (bt) bn ct cn",
                "16": "a0 a0g",
                "17": "a0 a0g a0v",
                "18": "at an atv atg anv",
                "19": "a0 b0 b0v",
                "20": "a0 b0 b0g",
                "21": "at bt bn btg",
                "22": "at bt bn btv bnv",
                "23": "at bt an bn btv bnv",
                "24": "an bn bt bnv btv",
                "25": "at bt bn btv bnv",
                "26": "a0 a0r",
                "27": "a0",
                "28": "at an",
                "29": "at an",
                "30": "at (bt) bn",
                "31": "a0 b0",
                "32": "at (bt) bn",
                "33": "at (bt) bn",
                "34": "at (bt) bn cn",
                "35": "at (bt) bn ct cn",
                "36": "an bn bt cn ct",
                "37": "at an",
                "38": "at an bt bn ct cn"
            };
            var tyved = tyveKoodid[uusTekst];
            var maha = getXmlSingleNode(selectedNode, "following-sibling::" + DICPR + ":tvg[not(contains(' " + tyved + " ', concat(' ', " + DICPR + ":tvk, ' ')))]");
            while (maha) {
                maha.parentNode.removeChild(maha);
                maha = getXmlSingleNode(selectedNode, "following-sibling::" + DICPR + ":tvg[not(contains(' " + tyved + " ', concat(' ', " + DICPR + ":tvk, ' ')))]");
            }
            var tyvedArr = tyved.split(/\s+/);
            for (var ix = 0; ix < tyvedArr.length; ix++) {
                var tyvi = tyvedArr[ix];
                var tyviNood = getXmlSingleNode(selectedNode, "following-sibling::" + DICPR + ":tvg[" + DICPR + ":tvk = '" + tyvi + "']");
                if (!tyviNood) {
                    var uusTvg = createMyNSElement(oEditDOM, DICPR + ":tvg", DICURI);
                    var uusTvk = uusTvg.appendChild(createMyNSElement(oEditDOM, DICPR + ":tvk", DICURI));
                    setXmlNodeValue(uusTvk, tyvi);
                    var uusTyvi = uusTvg.appendChild(createMyNSElement(oEditDOM, DICPR + ":tyvi", DICURI));
                    setXmlNodeValue(uusTyvi, "");
                    var refStr = '', refNode = null;
                    for (var k = ix + 1; k < tyvedArr.length; k++) {
                        if (refStr) {
                            refStr += "|";
                        }
                        refStr += "following-sibling::" + DICPR + ":tvg[" + DICPR + ":tvk = '" + tyvedArr[k] + "']";
                    }
                    if (refStr) {
                        refNode = getXmlSingleNode(selectedNode, refStr);
                    }
                    fatherNode.insertBefore(uusTvg, refNode);
                }
            }
        }

    }
} //ValueDicChecks


//-----------------------------------------------------------------------------------
function ArtSaveChecks() {
    if (dic_desc == "sp_") {
        SetMallid();
    } else if (dic_desc == "geo" || dic_desc == "har" || dic_desc == "med") {
        var sisuFrag = oEditDOM.createDocumentFragment();
        var sisuNode = getXmlSingleNode(oEditDOMRoot.firstChild, DICPR + ":S");
        if (sisuNode) {
            var mitu, sisuElem, ix, j, k, uued, mitu2, uus;
            var sisuElems = getXmlNodesSnapshot(sisuNode, "*");
            if ('snapshotLength' in sisuElems) {
                mitu = sisuElems.snapshotLength;
            } else if ('length' in sisuElems) {
                mitu = sisuElems.length;
            }
            for (ix = 0; ix < mitu; ix++) {
                if ('snapshotLength' in sisuElems) {
                    sisuElem = sisuElems.snapshotItem(ix);
                } else if ('length' in sisuElems) {
                    sisuElem = sisuElems[ix];
                }
                if (sisuElem.nodeName == DICPR + ":xp") {
                    for (j = 0; j < keelteValik.length; j++) { // keelteValik - Array
                        uued = getXmlNodesSnapshot(sisuNode, DICPR + ":xp[@xml:lang = '" + keelteValik[j].split(JR)[0] + "']");
                        if ('snapshotLength' in uued) {
                            mitu2 = uued.snapshotLength;
                        } else if ('length' in uued) {
                            mitu2 = uued.length;
                        }
                        for (k = 0; k < mitu2; k++) {
                            if ('snapshotLength' in uued) {
                                uus = uued.snapshotItem(k);
                            } else if ('length' in uued) {
                                uus = uued[k];
                            }
                            sisuFrag.appendChild(uus);
                        }
                    }
                } else {
                    sisuFrag.appendChild(sisuElem);
                }
            }

            sisuNode.appendChild(sisuFrag);
        }
    }
} //ArtSaveChecks


// procs_dic_sp_
//-----------------------------------------------------------------------------------
function SetMallid() {

    var mlNodes = getXmlNodesSnapshot(oEditDOMRoot, ".//" + DICPR + ":ml");
    var mlNode, ix;
    if ('snapshotLength' in mlNodes) {
        for (ix = 0; ix < mlNodes.snapshotLength; ix++) {
            mlNode = mlNodes.snapshotItem(ix);
            setMyNSAttribute(mlNode, DICURI, DICPR + ":mm", SetMsMall(mlNode));
        }
    } else if ('length' in mlNodes) { // nodeList, MSXML
        for (ix = 0; ix < mlNodes.length; ix++) {
            mlNode = mlNodes[ix];
            setMyNSAttribute(mlNode, DICURI, DICPR + ":mm", SetMsMall(mlNode));
        }
    }
} //SetMallid


//-----------------------------------------------------------------------------------
function SetMsMall(oNode) {
    var sText, sMall, i, isLetterLaRuOrDigit, mitteMall;

    isLetterLaRuOrDigit = "0123456789" + REG_LETT_LA + REG_LETT_RU;
    mitteMall = ".'(){}";

    sText = jsTrim(getXmlNodeValue(oNode));

    sText = sText.replace(/(&\w+;)/g, "");
    sText = sText.replace(/\s/g, "_");

    sMall = "";

    for (i = 0; i < sText.length; i++) {
        if (isLetterLaRuOrDigit.indexOf(sText.charAt(i).toLowerCase()) < 0) {
            if (mitteMall.indexOf(sText.charAt(i)) < 0) {
                sMall += sText.charAt(i);
            }
        }
    }
    return sMall;
} //SetMsMall




// procs_dic_qs_
// 
////-----------------------------------------------------------------------------------
//function SetAttrEsiTekstid(attrElement, elemAsukoht, esiElement, esiTekst) {
//    var esiLisatud, ptNode, boundNode, gsp, gspq, refNode;
//    var tarr, i

//    esiLisatud = false;
//    ptNode = selectedNode.selectSingleNode("..");

//    if (attrElement.indexOf(ptNode.nodeName) > -1) {
//        if (!(ptNode.selectSingleNode(elemAsukoht) == null)) {
//            boundNode = ptNode.selectSingleNode("preceding-sibling::" + esiElement);
//            if ((boundNode == null)) {
//                //GetSchemaPath: korjab xpath - ist predikaadid ära;
//                //GetSchemaPosQuery: teeb schema_dom - ist päringu following-sibling nimede kohta;
//                tarr = GetSchemaPath(oClicked.id).split("/");
//                gsp = "";
//                for (i = 0; i < tarr.length - 3; i++) {
//                    gsp = gsp + "/" + tarr(i);
//                }
//                gspq = GetSchemaPosQuery(jsMid(gsp, 1), esiElement);
//                if (!(gspq == "Ei saa")) {
//                    if ((gspq == "Suvaline")) {
//                        refNode = ptNode;
//                    } else {
//                        refNode = ptNode.parentNode.selectSingleNode(gspq);
//                    }
//                    boundNode = oEditDOM.createNode(NODE_ELEMENT, esiElement, tns);
//                    boundNode.text = esiTekst;
//                    ptNode.parentNode.insertBefore(boundNode, refNode);
//                    esiLisatud = true;
//                }
//            }
//        }
//    }
//    return esiLisatud;
//} //SetAttrEsiTekstid


// procs_dic_eos
// 
////-----------------------------------------------------------------------------------
//function SetAttrEsiTekstid(attrElement, elemAsukoht, esiElement, esiTekst) {
//    var esiLisatud, ptNode, boundNode, gsp, gspq, refNode;
//    var tarr, i

//    esiLisatud = false;
//    ptNode = selectedNode.selectSingleNode("..");

//    if ((attrElement.indexOf(ptNode.nodeName) > -1)) {
//        if (!(ptNode.selectSingleNode(elemAsukoht) == null)) {
//            boundNode = ptNode.selectSingleNode("preceding-sibling::" + esiElement);
//            if ((boundNode == null)) {
//                //GetSchemaPath: korjab xpath - ist predikaadid ära;
//                //GetSchemaPosQuery: teeb schema_dom - ist päringu following-sibling nimede kohta;
//                tarr = GetSchemaPath(oClicked.id).split("/");
//                gsp = "";
//                for (i = 0; i < tarr.length - 3; i++) {
//                    gsp = gsp + "/" + tarr[i];
//                }
//                gspq = GetSchemaPosQuery(jsMid(gsp, 1), esiElement);
//                if (!(gspq == "Ei saa")) {
//                    if ((gspq == "Suvaline")) {
//                        refNode = ptNode;
//                    } else {
//                        refNode = ptNode.parentNode.selectSingleNode(gspq);
//                    }
//                    boundNode = oEditDOM.createNode(NODE_ELEMENT, esiElement, tns);
//                    boundNode.text = esiTekst;
//                    ptNode.parentNode.insertBefore(boundNode, refNode);
//                    esiLisatud = true;
//                }
//            }
//        }
//    }
//    return esiLisatud;
//} //SetAttrEsiTekstid



// procs_dic_lit
// 
////-----------------------------------------------------------------------------------
//function setExtLatin(vanaTekst) {
//    var uusTekst;
//    uusTekst = vanaTekst

//    //uusTekst = Replace(uusTekst, ";ae", "æ") 'lv;
//    //uusTekst = Replace(uusTekst, ":;ae", "ǣ") 'lv

//    //uusTekst = Replace(uusTekst, ":a", "ā") 'lv;
//    //uusTekst = Replace(uusTekst, ":A", "Ā") 'lv;
//    //uusTekst = Replace(uusTekst, ",a", "ą") 'lt;
//    //uusTekst = Replace(uusTekst, ",A", "Ą") 'lt;
//    //uusTekst = Replace(uusTekst, ",c", "č") 'lv, lt;
//    //uusTekst = Replace(uusTekst, ",C", "Č") 'lv, lt;
//    //uusTekst = Replace(uusTekst, ":e", "ē") 'lv;
//    //uusTekst = Replace(uusTekst, ":E", "Ē") 'lv;
//    //uusTekst = Replace(uusTekst, ",e", "ę") 'lt;
//    //uusTekst = Replace(uusTekst, ",E", "Ę") 'lt;
//    //uusTekst = Replace(uusTekst, ".e", "ė") 'lt;
//    //uusTekst = Replace(uusTekst, ".E", "Ė") 'lt;
//    //uusTekst = Replace(uusTekst, ",g", "ģ") 'lv;
//    //uusTekst = Replace(uusTekst, ",G", "Ģ") 'lv;
//    //uusTekst = Replace(uusTekst, ":i", "ī") 'lv;
//    //uusTekst = Replace(uusTekst, ":I", "Ī") 'lv;
//    //uusTekst = Replace(uusTekst, ",i", "į") 'lt;
//    //uusTekst = Replace(uusTekst, ",I", "Į") 'lt;
//    //uusTekst = Replace(uusTekst, ",k", "ķ") 'lv;
//    //uusTekst = Replace(uusTekst, ",K", "Ķ") 'lv;
//    //uusTekst = Replace(uusTekst, ",l", "ļ") 'lv;
//    //uusTekst = Replace(uusTekst, ",L", "Ļ") 'lv;
//    //uusTekst = Replace(uusTekst, ",n", "ņ") 'lv;
//    //uusTekst = Replace(uusTekst, ",N", "Ņ") 'lv;
//    //uusTekst = Replace(uusTekst, ":o", "ō") 'lv;
//    //uusTekst = Replace(uusTekst, ":u", "ū") 'lv, lt;
//    //uusTekst = Replace(uusTekst, ":U", "Ū") 'lv, lt;
//    //uusTekst = Replace(uusTekst, ",u", "ų") 'lt;
//    //uusTekst = Replace(uusTekst, ",U", "Ų") 'lt

//    return uusTekst;
//} //setExtLatin


// procs_dic_evs
// 
//-----------------------------------------------------------------------------------
function TeisendaDOM(thisdomdoc) {

    // 05. nov 11
    return;

    //var rxpath, rnodes, rnode, venenodename, prs, rkrxpath, vanemnode;
    //var rkriips, tagaosa, post, rohk, i, uustekst, tarr, sona, mark, ixRNode;

    //prs = DICPR + ":";

    //rxpath = "//v:vgvormid/text()|//v:vgervorm/text()|//v:agvormid/text()";
    //rnodes = thisdomdoc.selectNodes(rxpath);
    //for(ixRNode=0; ixRNode< rnodes.length;ixRNode++){
    //rnode=rnodes[ixRNode];
    // venenodename = rnode.parentNode.nodeName;
    // if((venenodename == prs + "vgvormid" || venenodename == prs + "vgervorm")){
    //  rkrxpath = "ancestor::" + prs + "xg/" + prs + "x";
    // }else if((venenodename == prs + "agvormid")){
    //  rkrxpath = "ancestor::" + prs + "xg/" + prs + "aspvst";
    // }
    //vanemnode = rnode.selectSingleNode(rkrxpath);
    // if(! (vanemnode == null)){
    //  rkriips = vanemnode.text;
    //  tagaosa = "";
    //  post = 0;
    //  rohk = "ees";
    //  i = rkriips.indexOf("|");
    //  if((i > -1)){
    //   post = 1;
    //   rkriips = jsMid(vanemnode.text, 0, i);
    //   tagaosa = jsMid(vanemnode.text, i+1);
    //   if((tagaosa.indexOf("\"") > -1 || tagaosa.indexOf("ё") > -1)){
    //    rohk = "taga";
    //   }
    //  }
    //  if((rkriips.length > 1)){
    //   uustekst = "";
    //   tarr = rnode.nodeValue.split(" ");
    //   for (i = 0; i< tarr.length;i++){
    //    sona = tarr(i);
    //    if((sona != "")){
    //     mark = "";
    //     if((",;".indexOf(jsRight(sona, 1)) > -1)){
    //      mark = jsRight(sona, 1);
    //      sona = jsLeft(sona, sona.length-1);
    //     }
    //     //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''';
    //     //ühesilbilised: "aju II", "laud" 2.täh, "stepp I", "surm" 1.täh;
    //     //palju vorme: "rebenemiskindel" - пр"оч|ный;
    //     //palju rõhu liikumisi: "sündima";
    //     //vorm langeb kokku rkriips-uga: "karjatama_1" - пас|т"и;
    //     //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''';
    //     if(((sona.length > rkriips.length) && (jsLeft(sona, rkriips.length) == rkriips))){
    //      if(( (jsMid(sona, rkriips.length).indexOf("\"") > -1 || jsMid(sona, rkriips.length).indexOf("ё") > -1) && rohk == "ees")){
    //       uustekst = uustekst + " " + sona + mark;
    //      }else{
    //       uustekst = uustekst + " -" + jsMid(sona, rkriips.length) + mark;
    //      }
    //     }else{
    //      uustekst = uustekst + " " + sona + mark;
    //     }
    //    }
    //   }
    //   rnode.nodeValue = jsTrim(uustekst);
    //  }
    // }
    //}
    //rxpath = "//*[lang('ru')]/text()";
    //rnodes = thisdomdoc.selectNodes(rxpath);
    //for(ixRNode=0; ixRNode< rnodes.length;ixRNode++){
    //rnode=rnodes[ixRNode];
    // rnode.nodeValue = VeneRohk(rnode.nodeValue);
    // rnode.nodeValue = jsReplace(rnode.nodeValue, "[*]", "<sup>[</sup>*<sup>]</sup>");
    //}


    //var fmtbegin, fmtend, fmtnode, msnode, ms, homnr, rtilde, plussid, r2nodes, r2node, jnr;

    //rxpath = prs + "sr/" + prs + "A";
    //rnodes = thisdomdoc.selectNodes(rxpath);
    //for(ixRNode=0; ixRNode< rnodes.length;ixRNode++){
    //rnode=rnodes[ixRNode];
    // fmtbegin = "";
    // fmtend = "";
    //fmtnode = rnode.selectSingleNode(".//" + prs + "m[@" + prs + "liik='z']");
    // if(! (fmtnode == null)){
    //  fmtbegin = "<span style='font-style:italic;'>";
    //  fmtend = "</span><span style='font-style:normal;'></span>";
    // }
    //msnode = rnode.selectSingleNode(".//" + prs + "m/text()");
    // ms = msnode.nodeValue;
    // homnr = "";
    // //viitems;
    // if((jsLeft(ms, 1) = "%")){
    //  ms = jsMid(ms, 1);
    //  if((ms.lastIndexOf("_") > -1)){
    //   ms = jsMid(ms, 0, ms.indexOf("_")) + "<span style='font-weight:normal;'>" + jsReplace(jsMid(ms, ms.indexOf("_")), "_", "") + "</span>";
    //  }
    //  msnode.nodeValue = ms;
    // }else{
    //  if((ms.lastIndexOf("_") > 0)){
    //   homnr = jsMid(ms, ms.lastIndexOf("_")+1);
    //   ms = jsMid(ms, 0, ms.indexOf("_"));
    //  }
    //  rtilde = ms;
    //  if((ms.length > 4)){
    //   plussid = jsMid(ms, 2, ms.length-4);
    //   ms = jsLeft(ms, 2) + jsReplace(plussid, "+", "") + jsRight(ms, 2);
    //  }
    //  if((homnr != "")){
    //   homnr = RoomaNr(homnr);
    //   ms = ms + " " + homnr;
    //  }
    //  msnode.nodeValue = ms;
    //  if((jsLeft(rtilde, 2) == "--")){
    //   rtilde = Mid(rtilde, 3);
    //  }
    //  post = 0;
    //  if((rtilde.indexOf("|") > 0)){
    //   rtilde = jsMid(rtilde, 0, rtilde.indexOf("|"));
    //   post = 1;
    //  }
    //  rtilde = jsReplace(rtilde, "[+]", "");
    //  rtilde = jsReplace(rtilde, "+", "");
    //  if((rtilde.length > 1)){
    //  r2nodes = rnode.selectNodes(".//" + prs + "n/text()|.//" + prs + "f/text()");
    //for(ixR2Node=0; ixR2Node< r2nodes.length;ixR2Node++){
    //r2node=r2nodes[ixR2Node];
    //    tarr = r2node.nodeValue.split(rtilde);
    //    uustekst = tarr(0);
    //    for (i = 0; i< tarr.length - 1;i++){
    //     if((post == 0)){
    //      if((jsRight(tarr(i),1)==" ")){
    //       if((jsLeft(tarr(i+1), 1) == "-" || jsLeft(tarr(i+1), 1) == "/")){
    //        uustekst = uustekst + fmtbegin + rtilde + fmtend + tarr(i+1);
    //       }else{
    //        uustekst = uustekst + "~" + tarr(i+1);
    //       }
    ////'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    //      }else if((InStr(1, " ", Left(tarr(i+1), 1)) > 0)){
    //       if((Right(tarr(i), 1) = "-" || Right(tarr(i), 1) = "/")){
    //        uustekst = uustekst + fmtbegin + rtilde + fmtend + tarr(i+1);
    //       }else{
    //        uustekst = uustekst + "~" + tarr(i+1);
    //       }
    //      }else{
    //       uustekst = uustekst + fmtbegin + rtilde + fmtend + tarr(i+1);
    //      }
    //     }else{
    //      if((InStr(1, " ", Right(tarr(i), 1)) > 0)){
    //       if(! (InStr(1, "-/ ", Left(tarr(i+1), 1)) > 0)){
    //        uustekst = uustekst + "~" + tarr(i+1);
    //       }else{
    //        uustekst = uustekst + fmtbegin + rtilde + fmtend + tarr(i+1);
    //       }
    //      }else{
    //       if((InStr(1, " ", Left(tarr(i+1), 1)) > 0)){
    //        if(! (InStr(1, "-/ ", Right(tarr(i), 1)) > 0)){
    //         uustekst = uustekst + "~" + tarr(i+1);
    //        }else{
    //         uustekst = uustekst + fmtbegin + rtilde + fmtend + tarr(i+1);
    //        }
    //       }else{
    //        uustekst = uustekst + fmtbegin + rtilde + fmtend + tarr(i+1);
    //       }
    //      }
    //     }
    //    }
    //    r2node.nodeValue = Replace(uustekst, "/", "");
    //   }
    //  }
    // }

    //r2nodes = rnode.selectNodes(".//" + prs + "mvt/text()");
    // jnr = 0;
    // for each r2node in r2nodes;
    //  ms = r2node.nodeValue;
    //  homnr = "";
    //  if((InStrRev(ms, "_") > 0)){
    //   homnr = Mid(ms, InStrRev(ms, "_")+1);
    //   ms = Mid(ms, 1, InStr(1, ms, "_")-1);
    //  }
    //  if((Len(ms) > 4)){
    //   plussid = Mid(ms, 3, Len(ms)-4);
    //   ms = Left(ms, 2) + Replace(plussid, "+", "") + Right(ms, 2);
    //  }
    //  if((homnr != "")){
    //   homnr = RoomaNr(homnr);
    //   if((jnr > 0)){
    //    ms = homnr;
    //   }else{
    //    ms = ms + " " + homnr;
    //   }
    //  }
    //  r2node.nodeValue = ms;
    //  jnr = jnr + 1;
    // next;
    //r2nodes = rnode.selectNodes(".//" + prs + "tvt/text()");
    // jnr = 0;
    // for each r2node in r2nodes;
    //  ms = r2node.nodeValue;
    //  homnr = "";
    //  if((InStrRev(ms, "_") > 0)){
    //   homnr = Mid(ms, InStrRev(ms, "_")+1);
    //   ms = Mid(ms, 1, InStr(1, ms, "_")-1);
    //  }
    //  if((Len(ms) > 4)){
    //   plussid = Mid(ms, 3, Len(ms)-4);
    //   ms = Left(ms, 2) + Replace(plussid, "+", "") + Right(ms, 2);
    //  }
    //  if((homnr != "")){
    //   homnr = RoomaNr(homnr);
    //   ms = ms + " " + homnr;
    //  }
    //  r2node.nodeValue = ms;
    //  jnr = jnr + 1;
    // next;
    //next;
    //rxpath = "//" + prs + "d/text()[contains(.,'[')]";
    //rxpath = rxpath + "|//" + prs + "xr/text()[contains(.,'[')]";
    //rxpath = rxpath + "|//" + prs + "vrek/text()[contains(.,'[')]";
    //rxpath = rxpath + "|//" + prs + "r/text()[contains(.,'[')]"
    //rnodes = thisdomdoc.selectNodes(rxpath);
    //for each rnode in rnodes;
    // rnode.nodeValue = Replace(rnode.nodeValue, "[", "<span style='font-style:normal;'>[</span>");
    // rnode.nodeValue = Replace(rnode.nodeValue, "]", "<span style='font-style:normal;'>]</span>");
    //next;
    //rxpath = "//*/text()[contains(.,'%v')]|//*/text()[contains(.,'_')]|//*/text()[contains(.,'#')]|//*/text()[contains(.,'--')]"
    //rnodes = thisdomdoc.selectNodes(rxpath);
    //for each rnode in rnodes;
    // rnode.nodeValue = Replace(rnode.nodeValue, "%v", "<i style='font-weight:normal'>v</i>");
    // rnode.nodeValue = Replace(rnode.nodeValue, "_", " ");
    // rnode.nodeValue = Replace(rnode.nodeValue, "#", """");
    // rnode.nodeValue = Replace(rnode.nodeValue, "--", ChrW(+H2013)) 'En Dash;
    //next;
    //rxpath = "//" + prs + "mvl/text()[contains(., '.')]"
    //rnodes = thisdomdoc.selectNodes(rxpath);
    //for each rnode in rnodes;
    // rnode.nodeValue = Replace(rnode.nodeValue, ".", ChrW(+H00b7)) 'Middle Dot;
    //next;

} //TeisendaDOM


////-----------------------------------------------------------------------------------
//function VeneRohk(instr) {
//    var tarr, i;
//    tarr = instr.split('"');
//    //for i=1 to UBound(tarr);
//    // tarr(i) = Left(tarr(i), 1) + ChrW(+H0301) + Mid(tarr(i), 2);
//    //next;
//    return tarr.join("");
//} //VeneRohk


////-----------------------------------------------------------------------------------
//function RoomaNr(instr) {
//    var romanstr;
//    if ((instr == "1")) {
//        romanstr = "I";
//    } else if ((instr == "2")) {
//        romanstr = "II";
//    } else if ((instr == "3")) {
//        romanstr = "III";
//    } else if ((instr == "4")) {
//        romanstr = "IV";
//    } else if ((instr == "5")) {
//        romanstr = "V";
//    } else if ((instr == "6")) {
//        romanstr = "VI";
//    } else {
//        romanstr = "MMMMMDLV"; //'5555;
//    }
//    return romanstr;
//} //RoomaNr;



//-----------------------------------------------------------------------------------
function AddGruppChecks(oAddedNode) {
    if (oAddedNode.baseName == "n") {
        var yldStruNode = getXmlSingleNode(yldStruDom, ".//" + oAddedNode.nodeName);
        if (yldStruNode) {
            var attNimi = DICPR + ":nrl";
            var nrlAttr = getXmlSingleNode(yldStruNode, "@" + attNimi);
            if (nrlAttr) {
                var tekst = getXmlNodeValue(nrlAttr);
                if (!tekst) {
                    tekst = "var";
                }
                var eelmNode = getXmlSingleNode(oAddedNode, "preceding-sibling::" + oAddedNode.nodeName);
                if (eelmNode) {
                    setMyNSAttribute(oAddedNode, DICURI, attNimi, tekst);
                }
            }
        }
    }

    arvutaTxhendusNumbrid(oAddedNode.parentNode, oAddedNode.nodeName); // tnr, ntnr, rnr, anr, ftnr

} //AddGruppChecks


//-----------------------------------------------------------------------------------
function arvutaTxhendusNumbrid(parNode, seldNodeName) {
    if (seldNodeName == DICPR + ":tp" || seldNodeName == DICPR + ":qnp" || (dic_desc == "ems" && (seldNodeName == DICPR + ":rp" || seldNodeName == DICPR + ":atp")) || (dic_desc == "usv" && (seldNodeName == DICPR + ":ftp"))) {
        var sAttrName, countnodes, i;
        if (seldNodeName == DICPR + ":tp") {
            sAttrName = DICPR + ":tnr";
        } else if (seldNodeName == DICPR + ":qnp") {
            sAttrName = DICPR + ":ntnr";
        } else if (seldNodeName == DICPR + ":rp") { // ems
            sAttrName = DICPR + ":rnr";
        } else if (seldNodeName == DICPR + ":atp") { // ems
            sAttrName = DICPR + ":anr";
        } else if (seldNodeName == DICPR + ":ftp") { // usv
            sAttrName = DICPR + ":ftnr";
        }

        var countNodes = getXmlNodesSnapshot(parNode, seldNodeName);
        var countNode, ix;
        if ('snapshotLength' in countNodes) {
            for (ix = 0; ix < countNodes.snapshotLength; ix++) {
                countNode = countNodes.snapshotItem(ix);
                if (countNode.getAttribute(sAttrName) || countNodes.snapshotLength > 1) {
                    setMyNSAttribute(countNode, DICURI, sAttrName, ix + 1);
                }
            }
        } else if ('length' in countNodes) { // nodeList, MSXML
            for (ix = 0; ix < countNodes.length; ix++) {
                countNode = countNodes[ix];
                if (countNode.getAttribute(sAttrName) || countNodes.length > 1) {
                    setMyNSAttribute(countNode, DICURI, sAttrName, ix + 1);
                }
            }
        }
    }
} //arvutaTxhendusNumbrid


