#!/usr/bin/perl

use strict;
use HTTPD::GroupAdmin ();
 

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use CGI;
my $q = new CGI;
my $scriptName = $ENV{SCRIPT_NAME};
my $ua = $ENV{HTTP_USER_AGENT};
my $DIC_DESC = $q->param('app_id');
my $APP_NIMETUS = decode_utf8($q->param('app_nimetus'));
my $APP_LANG = $q->param('app_lang');
my $usrName = decode_utf8($q->param('app_usr'));

my $exsaAdminLoginName = 'EKI_EELex_EXSA';
my $exsaAdminDisplayName = 'exsaAdmin';

my $nEditAllowed = 0;

my ($agf, $i);


if ($usrName eq "") { # EXSA puhul on juba initsialiseeritud
    $usrName = "$ENV{REMOTE_USER}";
    if ($usrName eq "") {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<h1>Authorization Required (1)</h1>";
        exit;
    }
    # siin nüüd EELex värk ...
    # võta .htaccess'ist failinimed
    open (HTACCESS, "<", '.htaccess') || die "can't open '.htaccess': $!";
    while (<HTACCESS>) {
        s/\s+$//; # chomp näib reavahetuse tühikuga asendavat ...
        next unless /^AuthGroupFile /;
        $agf = $';
    }
    close(HTACCESS) || die "can't close '.htaccess': $!";

    #kui õnnestus siis kontrolli kasutajat
    my $group;

    if (-e $agf) { #grupifail

        $group = new HTTPD::GroupAdmin (DBType => 'Text',
                                        DB     => $agf,
                                        Server => 'apache');

        if($group->exists("grp_${DIC_DESC}", $usrName)) {
            $nEditAllowed =  1;
        }
        
        elsif($group->exists("grp_DEV", $usrName)) {
            $nEditAllowed =  1;
        }
        
        elsif($group->exists("quest_${DIC_DESC}", $usrName) ){
            $usrName = 'vaataja';
        }

    } 
    else {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<h1>Authorization Required(2)</h1>";
        exit;
    }

    #Kui ei ole grupi õiguseid siis välja
    unless (($nEditAllowed == 1) || ($usrName eq 'vaataja')) {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<h1>${usrName} has no access for ${DIC_DESC}</h1>";
        exit;
    }

}

use XML::LibXML;
my $dicparser = XML::LibXML->new();

my $APP_DESC;
unless ($APP_NIMETUS) { # EELex
    # $APP_DESC = $lcDom->documentElement()->findvalue("itm[\@n = 'APP_DESC'][\@dd = '${DIC_DESC}'][\@l = '${APP_LANG}']");
    $APP_DESC =$dicparser->parse_file('../lexlist.xml')->documentElement()->findvalue("lex[\@id = '${DIC_DESC}']/name[\@l = '${APP_LANG}']");

}
else { # EXSA
    $APP_DESC = $APP_NIMETUS;
}


my $eeLexConfDom = $dicparser->parse_file('shsConfig.xml');
my $eeLexQM = $eeLexConfDom->documentElement()->findvalue('qmMySql');
my $qryMethod = 'XML';
if (index($eeLexQM, ";${DIC_DESC};") > -1) {
    $qryMethod = 'MySql';
}

# my $shsconfig = $dicparser->parse_file("shsconfig_${DIC_DESC}.xml");
# my $VERS_DB = $shsconfig->documentElement()->findvalue('VERS_DB');

my $sWTitle = '[' . uc($DIC_DESC) . ']';
if (index($scriptName, '/__shs_test/') > -1) {
    $sWTitle .= " [T E S T B A A S]";
}
$sWTitle .= " ${APP_DESC}: '${usrName}'";

print "Content-type: text/html; charset=utf-8\n\n";
print <<"eelexSisu";
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="UTF-8" />
    <title>${sWTitle}</title>
    <!--cache maha-->
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="pragma" content="no-cache">
    <!--<meta http-equiv="refresh" content="10">-->
    <!--andmed-->
    <meta name="description" content="Sõnastike haldussüsteem EELex; Dictionary management system EELex; DMS" />
    <meta name="copyright" content="Eesti Keele Instituut, Andres Loopmann">
    <meta name="author" content="Andres Loopmann">
    <meta name="keywords" content="EELex, sõnastik, dictionary">
    <!--ühine-->
    <script type="text/javascript" src="html/dhtmlx/dhtmlxLayout/codebase/dhtmlxcommon.js"></script>
    <!--layout-->
    <link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.css">
    <link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxLayout/codebase/skins/dhtmlxlayout_dhx_skyblue.css">
    <script type="text/javascript" src="html/dhtmlx/dhtmlxLayout/codebase/dhtmlxcontainer.js"></script>
    <script type="text/javascript" src="html/dhtmlx/dhtmlxLayout/codebase/dhtmlxlayout.js"></script>
    <!--accordion-->
    <script type="text/javascript" src="html/dhtmlx/dhtmlxAccordion/codebase/dhtmlxaccordion.js"></script>
    <link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxAccordion/codebase/skins/dhtmlxaccordion_dhx_skyblue.css">
    <!--toolbar-->
    <script type="text/javascript" src="html/dhtmlx/dhtmlxToolbar/codebase/dhtmlxtoolbar.js"></script>
    <link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_skyblue.css">
    <!--<link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_web.css">-->
    <!--<link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_blue.css">-->
    <!--<link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxToolbar/codebase/skins/dhtmlxtoolbar_dhx_black.css">-->
    <!--grid-->
    <link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxGrid/codebase/dhtmlxgrid.css">
    <script type="text/javascript" src="html/dhtmlx/dhtmlxGrid/codebase/dhtmlxgrid.js"></script>
    <script type="text/javascript" src="html/dhtmlx/dhtmlxGrid/codebase/dhtmlxgridcell.js"></script>
    <script type="text/javascript" src="html/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_filter.js"></script>
    <script type="text/javascript" src="html/dhtmlx/dhtmlxGrid/codebase/ext/dhtmlxgrid_srnd.js"></script>
    <!--combo-->
    <link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxCombo/codebase/dhtmlxcombo.css">
    <script type="text/javascript" src="html/dhtmlx/dhtmlxCombo/codebase/dhtmlxcombo.js"></script>
    <!--menu-->
    <!--<link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxMenu/codebase/skins/dhtmlxmenu_dhx_blue.css">-->
    <link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxMenu/codebase/skins/dhtmlxmenu_dhx_skyblue.css">
    <!--<link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxMenu/codebase/skins/dhtmlxmenu_dhx_black.css">-->
    <!--<link rel="stylesheet" type="text/css" href="html/dhtmlx/dhtmlxMenu/codebase/skins/dhtmlxmenu_dhx_web.css">-->
    <script type="text/javascript" src="html/dhtmlx/dhtmlxMenu/codebase/dhtmlxmenu.js"></script>
    <!--<script type="text/javascript" src="html/dhtmlx/dhtmlxMenu/codebase/ext/dhtmlxmenu_ext.js"></script>-->
    <!--klient-->
    <!--<script type="text/javascript" src="html/jwplayer/jwplayer.js"></script>-->
    <script type="text/javascript" src="html/res_lang_${APP_LANG}.js"></script>
    <script type="text/javascript" src="html/res_xml.js"></script>
    <script type="text/javascript" src="html/dxf.js"></script>
    <script type="text/javascript" src="html/kontrollid.js"></script>
    <script type="text/javascript" src="html/tools_dx.js"></script>
    <script type="text/javascript" src="html/komponendid.js"></script>
    <script type="text/javascript" src="html/lisad.js"></script>
    <!--css-->
    <style>
        html, body
        {
            width: 100%;
            height: 100%;
            margin: 0px;
            padding: 0px;
            overflow: hidden;
        }
    </style>
</head>
<body onload="bodyOnLoad()" oncontextmenu="handleContext(event)" onresize="bodyOnResize()">
    <div id="parentId" style="width:100%;height:100%;">
    </div>
    <span id="spn_SrvParms" style="display:none">$usrName\|$nEditAllowed\|$DIC_DESC\|$APP_LANG\|$APP_DESC\|$qryMethod</span>
</body>
</html>
eelexSisu
