#!/usr/bin/perl
use strict;

#näitab vormi 

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use CGI;
use XML::LibXML;

use lib qw( ../ );
use SHS_cfg (':dir', ':file');
my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

my $oid = $q->param('oid'); 

print <<"LoginPage";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Uue sõnastiku loomine ${oid}'ist</title>
    <style type="text/css">
        .style1
        {
        }
        .style2
        {
            height: 26px;
        }
        .style3
        {
            height: 27px;
        }
        input
        { 
         width: 95%;
        }
        .punane
        {
        color:red;
        }
        .must
        {
        color:black;
        }
    </style>
    <script language="javascript" type="text/javascript">
// <![CDATA[

//täidab rippmenüü keeltega
        function checkid() {
            tid =document.getElementById('eelexid').value
            var xmlhttp;
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    var longstring = xmlhttp.responseText;
                    if(longstring=="true"){
                       setvhint('vid','punane',"On juba kasutusel");
                       document.getElementById("Submit1").disabled =true;
                       
                    }else{
                       reg=/^[a-z][a-z0-9][a-z0-9_]\$/;
                       if(reg.exec(tid)==null){
                          setvhint('vid','punane',"Peab täpselt 3 märki olema");
                          document.getElementById("Submit1").disabled =true;
                       }else{
                         setvhint('vid','must',"väli: OK");
                         document.getElementById("Submit1").disabled=false;
                       }

                    }
                       if(document.getElementById('eelexnimiet').value.length<3){
                             setvhint('vnimiet','punane',"väli on kohustuslik");
                             document.getElementById("Submit1").disabled =true;
                       }else{
                          setvhint('vnimiet','must',"väli: OK");
                       }

                }
            }
            xmlhttp.open("GET", "../idfree.cgi?id="+tid, true);
            xmlhttp.send();
        }
       
        
        //muuda vihjet
        function setvhint(name, classname, text ){
        
             document.getElementById(name).className = classname;
             document.getElementById(name).innerHTML = text;
             
        }

             //näitest tekstiväljale
        function n2txt(see,kuhu) {
            document.getElementById(kuhu).value = see.innerHTML;
            valideeri();
        }

// ]]>
    </script>
</head>
<body>
<div id="debug" onload="checkid()"></div>
    <div >
        <div style="border: thin solid #000000;" align="center">
        <form id="uuseelex" action="uusclone.cgi" method="post">
            <table class="style1">
                <tr>
                    <td align="left">
                        Uue sõnastiku info:
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        sõnastiku id: 
                    </td>
                    <td align="left">
                        <input id="eelexid" name="app_id" type="text"  />
                        <input id="eelexidv" name="app_idv" type="hidden" value="${oid}" />
                    </td>
                    <td align="left">
                    <span id="vid" class="punane" >Viga: sisestamata</span><br/>
                      
                    </td>
                </tr>
                                <tr>
                    <td align="right" class="style3">
                        sõnastiku nimi:</td>
                    <td align="left" class="style3">
                        <input id="eelexnimiet" type="text" name="eelexnimiet" /></td>
                    <td align="left" class="style3">
                     <span id="vnimiet" class="punane" ></span><br/>
                     <span id="snimiet" onclick="n2txt(this,'eelexnimiet')">Eesti-XXX sõnaraamat</span>
                    </td>
                </tr>
                <tr>
                    <td align="right" class="style2">
                        sõnastiku nimi inglise keeles:</td>
                    <td align="left" class="style2">
                        <input id="eelexnimien" type="text" name="eelexnimien" /></td>
                    <td align="left" class="style2">
                     <span id="vnimien" class="punane" ></span><br/>
                        <span id="snimien" onclick="n2txt(this,'eelexnimien')">Estonian-XXX dictionary</span></td>
                </tr>
                <tr>
                    <td align="right">
                        &nbsp;
                    </td>
                    <td align="left">
                        <input id="ktr" name="ktr" type="button" value="Kontrolli" onclick="return checkid()"/>
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <input id="Reset1" type="reset" value="reset" />
                    </td>
                    <td align="left">
                        <input id="Submit1" type="submit" value="submit" disabled="disabled" />
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        &nbsp;
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        &nbsp;
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                </tr>
            </table>
            </form>
        </div>
    </div>
</body>
</html>
LoginPage
