#!/usr/bin/perl

use strict;

# Only one case remains where an explicit use utf8 is needed:
# if your Perl script itself is encoded in UTF-8,
# you can use UTF-8 in your identifier names,
# and in string and regular expression literals, by saying use utf8.

use utf8;


use Encode;


# To output UTF-8, use the :utf8 output layer. Prepending
# binmode(STDOUT, ":utf8");
# to this program ensures that the output is completely UTF-8.

binmode(STDOUT, ":utf8");

#
# Tekkinud sümbolid lähevad:
#
# 1) 'la.txt'
# 1. rida - res_var.vbs: CAP_LETT_LA
# 3. rida - res_var.vbs: REG_LETT_LA
# 1. ja 3. rida järjest - 'schema.xsd' mssv_tyyp pattern - i, peale lubatud sümboleid 'MSSV_SYMBOLS'
# 2. ja 4. rida järjest - res_var.vbs: BASIC_LA
# 6. rida - paring.xsl ja print.xsl: <xsl:variable name="la_from"> sisu
# 7. rida - paring.xsl ja print.xsl: <xsl:variable name="la_to"> sisu
# 9. ja 10. rida - lihtsalt teadmiseks
# 12. rida - srvfuncs.cgi: kogu transliteration sisu 'msvSortVal' funktsioonis (EVS korral võib '\ ' lihtsalt kustutada)
#
# 2) 'la_menu_*.txt' ja 'ru_menu.txt'
# procs_edt.vbs vastavatesse menüüdesse
#

la_from__la_to();

sub la_from__la_to {
    my $la_from;
    my $la_to;
    my $la_to_str;
    my $perl_transl_from;
    my $perl_transl_to;

    # Eesti tähed ÕÄÖÜ jäävad eesti keeles teisele kohale
    # Ligatuurid (ühendtähed) teisedatakse mssv-s eraldi kaheks täheks
    # Latin-1 Supplement - ist alates 00c0 kuni 00ff
    # Latin Extended-A - st alates 0100 kuni 017f
    # Latin Extended-B - st alates 0180 kuni 01ff, 0200 kuni 0217
    # Latin Extended Additional - ist alates 1e00 kuni 1ef9

    my @la_alpha;
    # 0
    push @la_alpha, "Aa\x{00c0}\x{00e0}\x{00c1}\x{00e1}\x{00c2}\x{00e2}\x{00c3}\x{00e3}\x{00c5}\x{00e5}\x{0100}\x{0101}\x{0102}\x{0103}\x{0104}\x{0105}\x{01cd}\x{01ce}\x{01e0}\x{01e1}\x{01fa}\x{01fb}\x{0200}\x{0201}\x{0202}\x{0203}\x{1e00}\x{1e01}\x{1ea0}\x{1ea1}\x{1ea2}\x{1ea3}\x{1ea4}\x{1ea5}\x{1ea6}\x{1ea7}\x{1ea8}\x{1ea9}\x{1eaa}\x{1eab}\x{1eac}\x{1ead}\x{1eae}\x{1eaf}\x{1eb0}\x{1eb1}\x{1eb2}\x{1eb3}\x{1eb4}\x{1eb5}\x{1eb6}\x{1eb7}";
    # 1
    push @la_alpha, "Bb\x{0182}\x{0183}\x{0184}\x{0185}\x{1e02}\x{1e03}\x{1e04}\x{1e05}\x{1e06}\x{1e07}";
    # 2
    push @la_alpha, "Cc\x{00c7}\x{00e7}\x{0106}\x{0107}\x{0108}\x{0109}\x{010a}\x{010b}\x{010c}\x{010d}\x{0187}\x{0188}\x{1e08}\x{1e09}";
    # 3
    push @la_alpha, "Dd\x{00d0}\x{00f0}\x{010e}\x{010f}\x{0110}\x{0111}\x{018b}\x{018c}\x{1e0a}\x{1e0b}\x{1e0c}\x{1e0d}\x{1e0e}\x{1e0f}\x{1e10}\x{1e11}\x{1e12}\x{1e13}";
    # 4
    push @la_alpha, "Ee\x{00c8}\x{00e8}\x{00c9}\x{00e9}\x{00ca}\x{00ea}\x{00cb}\x{00eb}\x{0112}\x{0113}\x{0114}\x{0115}\x{0116}\x{0117}\x{0118}\x{0119}\x{011a}\x{011b}\x{0204}\x{0205}\x{0206}\x{0207}\x{1e14}\x{1e15}\x{1e16}\x{1e17}\x{1e18}\x{1e19}\x{1e1a}\x{1e1b}\x{1e1c}\x{1e1d}\x{1eb8}\x{1eb9}\x{1eba}\x{1ebb}\x{1ebc}\x{1ebd}\x{1ebe}\x{1ebf}\x{1ec0}\x{1ec1}\x{1ec2}\x{1ec3}\x{1ec4}\x{1ec5}\x{1ec6}\x{1ec7}";
    # 5
    push @la_alpha, "Ff\x{0191}\x{0192}\x{1e1e}\x{1e1f}";
    # 6
    push @la_alpha, "Gg\x{011c}\x{011d}\x{011e}\x{011f}\x{0120}\x{0121}\x{0122}\x{0123}\x{01e4}\x{01e5}\x{01e6}\x{01e7}\x{01f4}\x{01f5}\x{1e20}\x{1e21}";
    # 7
    push @la_alpha, "Hh\x{0124}\x{0125}\x{0126}\x{0127}\x{1e22}\x{1e23}\x{1e24}\x{1e25}\x{1e26}\x{1e27}\x{1e28}\x{1e29}\x{1e2a}\x{1e2b}";
    # 8
    push @la_alpha, "Ii\x{00cc}\x{00ec}\x{00cd}\x{00ed}\x{00ce}\x{00ee}\x{00cf}\x{00ef}\x{0128}\x{0129}\x{012a}\x{012b}\x{012c}\x{012d}\x{012e}\x{012f}\x{0130}\x{0131}\x{01cf}\x{01d0}\x{0208}\x{0209}\x{020a}\x{020b}\x{1e2c}\x{1e2d}\x{1e2e}\x{1e2f}\x{1ec8}\x{1ec9}\x{1eca}\x{1ecb}";
    # 9
    push @la_alpha, "Jj\x{0134}\x{0135}";
    # 10
    push @la_alpha, "Kk\x{0136}\x{0137}\x{0198}\x{0199}\x{01e8}\x{01e9}\x{1e30}\x{1e31}\x{1e32}\x{1e33}\x{1e34}\x{1e35}";
    # 11
    push @la_alpha, "Ll\x{0139}\x{013a}\x{013b}\x{013c}\x{013d}\x{013e}\x{013f}\x{0140}\x{0141}\x{0142}\x{1e36}\x{1e37}\x{1e38}\x{1e39}\x{1e3a}\x{1e3b}\x{1e3c}\x{1e3d}";
    # 12
    push @la_alpha, "Mm\x{1e3e}\x{1e3f}\x{1e40}\x{1e41}\x{1e42}\x{1e43}";
    # 13
    push @la_alpha, "Nn\x{00d1}\x{00f1}\x{0143}\x{0144}\x{0145}\x{0146}\x{0147}\x{0148}\x{014a}\x{014b}\x{1e44}\x{1e45}\x{1e46}\x{1e47}\x{1e48}\x{1e49}\x{1e4a}\x{1e4b}";
    # 14
    push @la_alpha, "Oo\x{00d2}\x{00f2}\x{00d3}\x{00f3}\x{00d4}\x{00f4}\x{00d8}\x{00f8}\x{014c}\x{014d}\x{014e}\x{014f}\x{0150}\x{0151}\x{01a0}\x{01a1}\x{01d1}\x{01d2}\x{01ea}\x{01eb}\x{01ec}\x{01ed}\x{01fe}\x{01ff}\x{020c}\x{020d}\x{020e}\x{020f}\x{1e50}\x{1e51}\x{1e52}\x{1e53}\x{1ecc}\x{1ecd}\x{1ece}\x{1ecf}\x{1ed0}\x{1ed1}\x{1ed2}\x{1ed3}\x{1ed4}\x{1ed5}\x{1ed6}\x{1ed7}\x{1ed8}\x{1ed9}\x{1eda}\x{1edb}\x{1edc}\x{1edd}\x{1ede}\x{1edf}\x{1ee0}\x{1ee1}\x{1ee2}\x{1ee3}";
    # 15
    push @la_alpha, "Pp\x{01a4}\x{01a5}\x{1e54}\x{1e55}\x{1e56}\x{1e57}";
    # 16
    push @la_alpha, "Qq";
    # 17
    push @la_alpha, "Rr\x{0154}\x{0155}\x{0156}\x{0157}\x{0158}\x{0159}\x{0210}\x{0211}\x{0212}\x{0213}\x{1e58}\x{1e59}\x{1e5a}\x{1e5b}\x{1e5c}\x{1e5d}\x{1e5e}\x{1e5f}";
    # 18
    push @la_alpha, "Ss\x{015a}\x{015b}\x{015c}\x{015d}\x{015e}\x{015f}\x{1e60}\x{1e61}\x{1e62}\x{1e63}\x{1e64}\x{1e65}\x{1e68}\x{1e69}";
    # 19
    push @la_alpha, "Šš\x{1e66}\x{1e67}";
    # 20
    push @la_alpha, "Zz\x{0179}\x{017a}\x{017b}\x{017c}\x{01b5}\x{01b6}\x{1e90}\x{1e91}\x{1e92}\x{1e93}\x{1e94}\x{1e95}";
    # 21
    push @la_alpha, "Žž";
    # 22
    push @la_alpha, "Tt\x{0162}\x{0163}\x{0164}\x{0165}\x{0166}\x{0167}\x{01ac}\x{01ad}\x{1e6a}\x{1e6b}\x{1e6c}\x{1e6d}\x{1e6e}\x{1e6f}\x{1e70}\x{1e71}";
    # 23
    push @la_alpha, "Uu\x{00d9}\x{00f9}\x{00da}\x{00fa}\x{00db}\x{00fb}\x{0168}\x{0169}\x{016a}\x{016b}\x{016c}\x{016d}\x{016e}\x{016f}\x{0170}\x{0171}\x{0172}\x{0173}\x{01af}\x{01b0}\x{01d3}\x{01d4}\x{0214}\x{0215}\x{0216}\x{0217}\x{1e72}\x{1e73}\x{1e74}\x{1e75}\x{1e76}\x{1e77}\x{1e78}\x{1e79}\x{1e7a}\x{1e7b}\x{1ee4}\x{1ee5}\x{1ee6}\x{1ee7}\x{1ee8}\x{1ee9}\x{1eea}\x{1eeb}\x{1eec}\x{1eed}\x{1eee}\x{1eef}\x{1ef0}\x{1ef1}";
    # 24
    push @la_alpha, "Vv\x{1e7c}\x{1e7d}\x{1e7e}\x{1e7f}";
    # 25
    push @la_alpha, "Ww\x{0174}\x{0175}\x{1e80}\x{1e81}\x{1e82}\x{1e83}\x{1e84}\x{1e85}\x{1e86}\x{1e87}\x{1e88}\x{1e89}";
    # 26
    push @la_alpha, "Õõ\x{1e4c}\x{1e4d}\x{1e4e}\x{1e4f}";
    # 27
    push @la_alpha, "Ää\x{01de}\x{01df}";
    # 28
    push @la_alpha, "Öö";
    # 29
    push @la_alpha, "Üü\x{01d5}\x{01d6}\x{01d7}\x{01d8}\x{01d9}\x{01da}\x{01db}\x{01dc}";
    # 30
    push @la_alpha, "Xx\x{1e8a}\x{1e8b}\x{1e8c}\x{1e8d}";
    # 31
    push @la_alpha, "Yy\x{00dd}\x{00fd}\x{0176}\x{0177}\x{0178}\x{00ff}\x{01b3}\x{01b4}\x{1e8e}\x{1e8f}\x{1ef2}\x{1ef3}\x{1ef4}\x{1ef5}\x{1ef6}\x{1ef7}\x{1ef8}\x{1ef9}";

	# <xsl:variable name="to_sym">&#xE001;&#xE002;&#xE003;&#xE004;&#xE005;&#xE006;&#xE007;&#xE008;&#xE009;&#xE00A;&#xE00B;&#xE00C;&#xE00D;&#xE00E;&#xE00F;&#xE010;&#xE011;&#xE011;&#xE013;&#xE013;&#xE015;&#xE015;&#xE017;&#xE017;&#xE019;&#xE019;&#xE01B;&#xE01B;&#xE01D;&#xE01D;&#xE01F;&#xE01F;&#xE021;&#xE021;&#xE023;&#xE023;&#xE025;&#xE025;&#xE027;&#xE027;&#xE029;&#xE029;&#xE02B;&#xE02B;&#xE02D;&#xE02D;&#xE02F;&#xE02F;&#xE031;&#xE031;&#xE033;&#xE033;&#xE035;&#xE035;&#xE037;&#xE037;&#xE039;&#xE039;&#xE03B;&#xE03B;&#xE03D;&#xE03D;&#xE03F;&#xE03F;&#xE041;&#xE041;&#xE043;&#xE043;&#xE045;&#xE045;&#xE047;&#xE047;&#xE049;&#xE049;&#xE04B;&#xE04B;&#xE04D;&#xE04D;&#xE04F;&#xE04F;</xsl:variable>
    $la_from = '0123456789_%+/|';
    $perl_transl_from = quotemeta($la_from);
    $la_to = '';
    $la_to_str = '';
    $perl_transl_to = '';
    
	my ($i, $k);
	
    for ($i = 0, $k = 0xE001; $i < length($la_from); $i++) {
        $la_to .= chr($k + $i);
        $la_to_str .= ('&#x' . sprintf("%04X", $k + $i) . ';');
        $perl_transl_to .= ('\x{' . sprintf("%04X", $k + $i) . '}');
    }

    for ($i = 0, $k += length($la_from); $i < scalar(@la_alpha); $i++, $k++) {
        $la_from .= $la_alpha[$i];
        $perl_transl_from .= $la_alpha[$i];
        $la_to .= (chr($k) x length($la_alpha[$i]));
        $la_to_str .= (('&#x' . sprintf("%04X", $k) . ';') x length($la_alpha[$i]));
        $perl_transl_to .= (('\x{' . sprintf("%04X", $k) . '}') x length($la_alpha[$i]));
    }

    # EVS-is toimub järjestus tühikut arvestades, teistes tühikut ei arvestata: EVS-is ei tohi tühikut 'la_from' - i lisada (ära teisendada)
    my $from_ending = '()[] ';
    $la_from .= $from_ending;
    $perl_transl_from .= quotemeta($from_ending);

	if (open(TXTFH, '>:utf8', "out/la.txt")) {
	    my ($caps, $smalls, $basic_caps, $basic_smalls);
        for ($i = 0; $i < scalar(@la_alpha); $i++) {
            for ($k = 0; $k < length($la_alpha[$i]); $k++) {
                if (($k % 2) == 0) {
                    $caps .= substr($la_alpha[$i], $k, 1);
                    $basic_caps .= substr($la_alpha[$i], 0, 1);
                }
                else {
                    $smalls .= substr($la_alpha[$i], $k, 1);
                    $basic_smalls .= substr($la_alpha[$i], 1, 1);
                }
            }
        }
		print(TXTFH "${caps}\n");
		print(TXTFH "${basic_caps}\n");
		print(TXTFH "${smalls}\n");
		print(TXTFH "${basic_smalls}\n\n");
		
		print(TXTFH "${la_from}\n");
		print(TXTFH "${la_to_str}\n\n");
		
		print(TXTFH "${perl_transl_from}\n");
		print(TXTFH "${perl_transl_to}\n\n");

		print(TXTFH "tr\/${perl_transl_from}\/${perl_transl_to}\/d;\n");
		close(TXTFH);
	}

	# 30. jaanuar 2007
	# 06. juuni 2010
	#
	my ($et_from, $et_to, $etk, $str_to, $m);
	$et_from = '^0123456789_%+/|';
	$perl_transl_from = quotemeta($et_from);
	$perl_transl_to = '';
	$et_to = '';
	$str_to = '';
	for ($i = 0, $k = 0xE001, $m = 0xE001; $i < length($et_from); $i++) {
		$et_to .= ('&#x' . sprintf("%04X", $k + $i) . ';');
		$str_to .= chr($m + $i);
		$perl_transl_to .= ('\x{' . sprintf("%04X", $m + $i) . '}');
	}
	
	$etk = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsŠšZzŽžTtUuVvWwÕõÄäÖöÜüXxYy';
	for ($i = 0, $k += length($et_from), $m += length($et_from); $i < length($etk); $i++) {
		if (($i % 2) == 0) {
			$et_to .= ('&#x' . sprintf("%04X", $k + $i) . ';') x 2;
			$perl_transl_to .= ('\x{' . sprintf("%04X", $m + $i) . '}') x 2;
			$str_to .= (chr($m + $i)) x 2;
		}
	}
	
	my $vtk = 'АаБбВвГгДдЕеЁёЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЫыЬьЭэЮюЯя';
	for ($i = 0, $k += length($etk), $m += length($etk); $i < length($vtk); $i++) {
		if (($i % 2) == 0) {
			$et_to .= ('&#x' . sprintf("%04X", $k + $i) . ';') x 2;
			$perl_transl_to .= ('\x{' . sprintf("%04X", $m + $i) . '}') x 2;
			$str_to .= (chr($m + $i)) x 2;
		}
	}
	
	my $ett = $et_from;
	$et_from .= $etk . $vtk . '()[]';
	$perl_transl_from .= $etk . $vtk;
	
	if (open(TXTFH, '>:utf8', "out/mssvOrderVars.txt")) {
		print(TXTFH "<xsl:variable name=\"fr_sym\">${et_from}</xsl:variable>\n");
		print(TXTFH "<xsl:variable name=\"to_sym\">${et_to}</xsl:variable>\n");
		print(TXTFH "\n");
		print(TXTFH "Dim etfr As String = \"${ett}${etk}${vtk}\"\n");
		print(TXTFH "Dim etto As String = \"${str_to}\"\n");
		print(TXTFH "\n");
		print(TXTFH "tr\/${perl_transl_from}\/${perl_transl_to}\/d;\n");
		close(TXTFH);
	}

	if (open(TXTFH, '>:utf8', "out/la_menu_ad.txt")) {
        my ($mi, $cc, $ce);
        for ($k = 0; $k < length($la_alpha[0]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[0], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($k = 0; $k < length($la_alpha[27]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[27], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($i = 1; $i < 4; $i++) {
            for ($k = 0; $k < length($la_alpha[$i]); $k++) {
                $cc = sprintf("%04X", ord(substr($la_alpha[$i], $k, 1)));
                $ce = "\&\#x${cc};";
                $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
                print(TXTFH "$mi\n");
            }
        }
		close(TXTFH);
	}
	if (open(TXTFH, '>:utf8', "out/la_menu_eh.txt")) {
        my ($mi, $cc, $ce);
        for ($i = 4; $i < 8; $i++) {
            for ($k = 0; $k < length($la_alpha[$i]); $k++) {
                $cc = sprintf("%04X", ord(substr($la_alpha[$i], $k, 1)));
                $ce = "\&\#x${cc};";
                $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
                print(TXTFH "$mi\n");
            }
        }
		close(TXTFH);
	}
	if (open(TXTFH, '>:utf8', "out/la_menu_in.txt")) {
        my ($mi, $cc, $ce);
        for ($i = 8; $i < 14; $i++) {
            for ($k = 0; $k < length($la_alpha[$i]); $k++) {
                $cc = sprintf("%04X", ord(substr($la_alpha[$i], $k, 1)));
                $ce = "\&\#x${cc};";
                $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
                print(TXTFH "$mi\n");
            }
        }
		close(TXTFH);
	}
	if (open(TXTFH, '>:utf8', "out/la_menu_os.txt")) {
        my ($mi, $cc, $ce);
        for ($k = 0; $k < length($la_alpha[14]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[14], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($k = 0; $k < length($la_alpha[26]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[26], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($k = 0; $k < length($la_alpha[28]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[28], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($i = 15; $i < 20; $i++) {
            for ($k = 0; $k < length($la_alpha[$i]); $k++) {
                $cc = sprintf("%04X", ord(substr($la_alpha[$i], $k, 1)));
                $ce = "\&\#x${cc};";
                $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
                print(TXTFH "$mi\n");
            }
        }
		close(TXTFH);
	}
	if (open(TXTFH, '>:utf8', "out/la_menu_tu.txt")) {
        my ($mi, $cc, $ce);
        for ($k = 0; $k < length($la_alpha[22]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[22], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($k = 0; $k < length($la_alpha[23]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[23], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($k = 0; $k < length($la_alpha[29]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[29], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
		close(TXTFH);
	}
	if (open(TXTFH, '>:utf8', "out/la_menu_vz.txt")) {
        my ($mi, $cc, $ce);
        for ($k = 0; $k < length($la_alpha[24]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[24], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($k = 0; $k < length($la_alpha[25]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[25], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($k = 0; $k < length($la_alpha[30]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[30], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($k = 0; $k < length($la_alpha[31]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[31], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($k = 0; $k < length($la_alpha[20]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[20], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        for ($k = 0; $k < length($la_alpha[21]); $k++) {
            $cc = sprintf("%04X", ord(substr($la_alpha[21], $k, 1)));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
		close(TXTFH);
	}
	if (open(TXTFH, '>:utf8', "out/ru_menu.txt")) {
        my ($mi, $cc, $ce);
        for ($k = 0x0410; $k < 0x0416; $k++) {
            $cc = sprintf("%04X", $k);
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
            $cc = sprintf("%04X", ($k + 32));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
        $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . '&#x0401;' . '\' title=\'U+0401\'>' . '&#x0401;' . '</span>"';
        print(TXTFH "$mi\n");
        $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . '&#x0451;' . '\' title=\'U+0451\'>' . '&#x0451;' . '</span>"';
        print(TXTFH "$mi\n");
        for ($k = 0x0416; $k < 0x0430; $k++) {
            $cc = sprintf("%04X", $k);
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
            $cc = sprintf("%04X", ($k + 32));
            $ce = "\&\#x${cc};";
            $mi = 'inssym = inssym & "<span class=\'mi_span\' value=\'' . $ce . '\' title=\'U+' . $cc . '\'>' . $ce . '</span>"';
            print(TXTFH "$mi\n");
        }
		close(TXTFH);
	}

    return;
}

print "Content-type: text/html; charset=utf-8\n\n";
print "Done symbols ...";
