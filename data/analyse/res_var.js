
var maxEnumRows = 29;
//"joiner"
var JR = "\uE001";
var PD = JR;

var specCh = "\\|(){}[]-+.?*^$";

//märkideta otsingu jaoks sümbolid, mis otsingu käigus maha võtta vaja
var MITTE_TAHED_PTRN = "(&amp;)|(&lt;)|(&gt;)|(&ema;)|(&eml;)|(&ba;)|(&bl;)|(&suba;)|(&subl;)|(&supa;)|(&supl;)|(&la;)|(&ll;)|[^\p{L}\s]";

//<!-- Tähed on saadud perli 'la_from__la_to' funktsiooni abil, mis kirjutab temp/la.txt - sse -->
var CAP_LETT_LA = "AÀÁÂÃÅĀĂĄǍǠǺȀȂḀẠẢẤẦẨẪẬẮẰẲẴẶBƂƄḂḄḆCÇĆĈĊČƇḈDÐĎĐƋḊḌḎḐḒEÈÉÊËĒĔĖĘĚȄȆḔḖḘḚḜẸẺẼẾỀỂỄỆFƑḞGĜĞĠĢǤǦǴḠHĤĦḢḤḦḨḪIÌÍÎÏĨĪĬĮİǏȈȊḬḮỈỊJĴKĶƘǨḰḲḴLĹĻĽĿŁḶḸḺḼMḾṀṂNÑŃŅŇŊṄṆṈṊOÒÓÔØŌŎŐƠǑǪǬǾȌȎṐṒỌỎỐỒỔỖỘỚỜỞỠỢPƤṔṖQRŔŖŘȐȒṘṚṜṞSŚŜŞṠṢṤṨŠṦZŹŻƵẐẒẔŽTŢŤŦƬṪṬṮṰUÙÚÛŨŪŬŮŰŲƯǓȔȖṲṴṶṸṺỤỦỨỪỬỮỰVṼṾWŴẀẂẄẆẈÕṌṎÄǞÖÜǕǗǙǛXẊẌYÝŶŸƳẎỲỴỶỸ";
var REG_LETT_LA = "aàáâãåāăąǎǡǻȁȃḁạảấầẩẫậắằẳẵặbƃƅḃḅḇcçćĉċčƈḉdðďđƌḋḍḏḑḓeèéêëēĕėęěȅȇḕḗḙḛḝẹẻẽếềểễệfƒḟgĝğġģǥǧǵḡhĥħḣḥḧḩḫiìíîïĩīĭįıǐȉȋḭḯỉịjĵkķƙǩḱḳḵlĺļľŀłḷḹḻḽmḿṁṃnñńņňŋṅṇṉṋoòóôøōŏőơǒǫǭǿȍȏṑṓọỏốồổỗộớờởỡợpƥṕṗqrŕŗřȑȓṙṛṝṟsśŝşṡṣṥṩšṧzźżƶẑẓẕžtţťŧƭṫṭṯṱuùúûũūŭůűųưǔȕȗṳṵṷṹṻụủứừửữựvṽṿwŵẁẃẅẇẉõṍṏäǟöüǖǘǚǜxẋẍyýŷÿƴẏỳỵỷỹ";
var BASIC_LA =    "AAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBCCCCCCCCDDDDDDDDDDEEEEEEEEEEEEEEEEEEEEEEEEEFFFGGGGGGGGGHHHHHHHHIIIIIIIIIIIIIIIIIJJKKKKKKKLLLLLLLLLLMMMMNNNNNNNNNNOOOOOOOOOOOOOOOOOOOOOOOOOOOOOPPPPQRRRRRRRRRRSSSSSSSSŠŠZZZZZZZŽTTTTTTTTTUUUUUUUUUUUUUUUUUUUUUUUUUUVVVWWWWWWWÕÕÕÄÄÖÜÜÜÜÜXXXYYYYYYYYYYaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbccccccccddddddddddeeeeeeeeeeeeeeeeeeeeeeeeefffggggggggghhhhhhhhiiiiiiiiiiiiiiiiijjkkkkkkkllllllllllmmmmnnnnnnnnnnoooooooooooooooooooooooooooooppppqrrrrrrrrrrssssssssššzzzzzzzžtttttttttuuuuuuuuuuuuuuuuuuuuuuuuuuvvvwwwwwwwõõõääöüüüüüxxxyyyyyyyyyy";

var CAP_LETT_RU = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";
var REG_LETT_RU = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя";
var CAP_LETT_ET = "ABCDEFGHIJKLMNOPQRSŠZŽTUVWÕÄÖÜXY";
var REG_LETT_ET = "abcdefghijklmnopqrsšzžtuvwõäöüxy";

//OpenTextFile
var ForWriting = 2;
var TristateTrue = -1;

//Stream constants
var adTypeText = 2;
var adSaveCreateOverWrite = 2;
var adCRLF = -1;
var adWriteLine = 1;
var adModeWrite = 2;
var adOpenStreamUnspecified = -1;

//Word constants
//Languages
var wdEnglishUS = 1033;
var wdRussian = 1049;
var wdEstonian = 1061;

var wdNewBlankDocument = 0;
var wdFormatDocument = 0;
var wdFormatEncodedText = 7;
var wdFormatUnicodeText = 7;
var msoEncodingAutoDetect = 50001;
var msoEncodingUTF8 = 65001;

var wdLeftToRight = 0;
//
var wdCollapseEnd = 0;
var wdNormalView = 1;
var wdOutlineView = 2;
var wdPrintView = 3;
var wdPrintPreview = 4;
var wdMasterView = 5;
var wdWebView = 6;
var wdDoNotSaveChanges = 0;
var wdOpenFormatAuto = 0;
var wdOpenFormatWebPages = 7;
//
var wdLineSpaceSingle = 0;
//WdParagraphAlignment
var wdAlignParagraphLeft = 0;
var wdAlignParagraphCenter = 1;
var wdAlignParagraphRight = 2;
var wdAlignParagraphJustify = 3;
//outline
var wdOutlineLevelBodyText = 10;
//Footers
var wdHeaderFooterPrimary = 1;
//NumberStyle
var wdPageNumberStyleArabic = 0;
var wdPageNumberStyleArabicFullWidth = 14;
var wdPageNumberStyleNumberInCircle = 18;
var wdPageNumberStyleNumberInDash = 57;
var wdAlignPageNumberCenter = 1;
//ComputeStatistics
var wdStatisticPages = 2;

//Märgid
var CIRCUMFLEX = "&#x005e;";
var GRAVE = "&#x0060;";
var NO_BREAK_SPACE = "&#x00a0;";
var INVERTED_EXCLAMATION = "&#x00a1;";
var CENT_SIGN = "&#x00a2;";
var YEN_SIGN = "&#x00a5;";
var BROKEN_BAR = "&#x00a6;";
var DIAERESIS = "&#x00a8;";
var COPYRIGHT_SIGN = "&#x00a9;";
var NOT_SIGN = "&#x00ac;";
var REGISTERED_SIGN = "&#x00ae;";
var MACRON = "&#x00af;";
var DEGREE_SIGN = "&#x00b0;";
var PLUS_MINUS_SIGN = "&#x00b1;";
var ACUTE = "&#x00b4;";
var MICRO_SIGN = "&#x00b5;";
var PILCROW_SIGN = "&#x00b6;";
var MIDDLE_DOT = "&#x00b7;";
var CEDILLA = "&#x00b8;";
var INVERTED_QUESTION = "&#x00bf;";
var MULTIPLICATION_SIGN = "&#x00d7;";
var DIVISION_SIGN = "&#x00f7;"

var EN_DASH = "&#x2013;";
var LEFT_SINGLE_QUOTATION_MARK = "&#x2018;";
var RIGHT_SINGLE_QUOTATION_MARK = "&#x2019;";
var RIGHT_DOUBLE_QUOTATION_MARK = "&#x201d;";
var DOUBLE_LOW9_QUOTATION_MARK = "&#x201e;";
var BULLET = "&#x2022;";
var TRIANGULAR_BULLET = "&#x2023;";
var PRIME = "&#x2032;";
var DOUBLE_PRIME = "&#x2033;";
var FRACTION_SLASH = "&#x2044;";
var OHM_SIGN = "&#x2126;";
var ANGSTROM_SIGN = "&#x212b;"; //'Arial Unicode MS;
var LEFTWARDS_ARROW = "&#x2190;";
var UPWARDS_ARROW = "&#x2191;";
var RIGHTWARDS_ARROW = "&#x2192;";
var DOWNWARDS_ARROW = "&#x2193;"

var EMPTY_SET = "&#x2205;";
var DIVISION_SLASH = "&#x2215;";
var eeLex_INFINITY = "&#x221e;";
var LOGICAL_OR = "&#x2228;"; //'Arial Unicode MS;
var INTEGRAL = "&#x222b;"

var BLACK_RIGHT_POINTING_POINTER = "&#x25ba;"

var MUSIC_FLAT_SIGN = "&#x266d;"; //'Arial Unicode MS, bemoll;
var MUSIC_NATURAL_SIGN = "&#x266e;"; //'Arial Unicode MS, bekaar;
var MUSIC_SHARP_SIGN = "&#x266f;"; //'Arial Unicode MS, diees

var COMBINING_GRAVE = "&#x0300;";
var COMBINING_ACUTE = "&#x0301;";
var COMBINING_CIRCUMFLEX = "&#x0302;";
var COMBINING_TILDE = "&#x0303;";
var COMBINING_MACRON = "&#x0304;";
var COMBINING_OVERLINE = "&#x0305;";
var COMBINING_BREVE = "&#x0306;";
var COMBINING_DOT_ABOVE = "&#x0307;";
var COMBINING_DIAERESIS = "&#x0308;"


//1Only 0 Display OK button only.
//1Cancel 1 Display OK && Cancel buttons.
//3RetryIgnore 2 Display Abort, Retry, && Ignore buttons.
//6NoCancel 3 Display Yes, No, && Cancel buttons.
//6No 4 Display Yes && No buttons.
//4Cancel 5 Display Retry && Cancel buttons.
//'\r'itical 16 Display Critical Message icon.
//vbQuestion 32 Display Warning Query icon.
//vbExclamation 48 Display Warning Message icon.
//vbInformation 64 Display Information Message icon.
//vbDefaultButton1 0 First button is the default.
//vbDefaultButton2 256 Second button is the default.
//vbDefaultButton3 512 Third button is the default.
//vbDefaultButton4 768 Fourth button is the default.
//vbApplicationModal 0 Application modal. The user must respond to the message box before continuing work in the current application.
//vbSystemModal 4096 System modal. On Win16 systems, all applications are suspended until the user responds to the message box. On Win32 systems, this constant provides an application modal message box that always remains on top of any other programs you may have running. 

//1 1 OK button was clicked.
//2 2 Cancel button was clicked.
//3 3 Abort button was clicked.
//4 4 Retry button was clicked.
//5 5 Ignore button was clicked.
//6 6 Yes button was clicked.
//7 7 No button was clicked.

//// alert(constants for jscript)
var jsvbCritical = 16;
var jsvbExclamation = 48;
var jsvbInformation = 64;

//6No 4 Display Yes && No buttons.
var jsvbYesNo = 4;
