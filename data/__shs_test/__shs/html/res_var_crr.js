var specCh = "\\|(){}[]-+.?*^$";
var PD = "\uE001";

//<!-- Tähed on saadud perli 'la_from__la_to' funktsiooni abil, mis kirjutab temp/la.txt - sse -->
var CAP_LETT_LA = "AÀÁÂÃÅĀĂĄǍǠǺȀȂḀẠẢẤẦẨẪẬẮẰẲẴẶBƂƄḂḄḆCÇĆĈĊČƇḈDÐĎĐƋḊḌḎḐḒEÈÉÊËĒĔĖĘĚȄȆḔḖḘḚḜẸẺẼẾỀỂỄỆFƑḞGĜĞĠĢǤǦǴḠHĤĦḢḤḦḨḪIÌÍÎÏĨĪĬĮİǏȈȊḬḮỈỊJĴKĶƘǨḰḲḴLĹĻĽĿŁḶḸḺḼMḾṀṂNÑŃŅŇŊṄṆṈṊOÒÓÔØŌŎŐƠǑǪǬǾȌȎṐṒỌỎỐỒỔỖỘỚỜỞỠỢPƤṔṖQRŔŖŘȐȒṘṚṜṞSŚŜŞṠṢṤṨŠṦZŹŻƵẐẒẔŽTŢŤŦƬṪṬṮṰUÙÚÛŨŪŬŮŰŲƯǓȔȖṲṴṶṸṺỤỦỨỪỬỮỰVṼṾWŴẀẂẄẆẈÕṌṎÄǞÖÜǕǗǙǛXẊẌYÝŶŸƳẎỲỴỶỸ";
var REG_LETT_LA = "aàáâãåāăąǎǡǻȁȃḁạảấầẩẫậắằẳẵặbƃƅḃḅḇcçćĉċčƈḉdðďđƌḋḍḏḑḓeèéêëēĕėęěȅȇḕḗḙḛḝẹẻẽếềểễệfƒḟgĝğġģǥǧǵḡhĥħḣḥḧḩḫiìíîïĩīĭįıǐȉȋḭḯỉịjĵkķƙǩḱḳḵlĺļľŀłḷḹḻḽmḿṁṃnñńņňŋṅṇṉṋoòóôøōŏőơǒǫǭǿȍȏṑṓọỏốồổỗộớờởỡợpƥṕṗqrŕŗřȑȓṙṛṝṟsśŝşṡṣṥṩšṧzźżƶẑẓẕžtţťŧƭṫṭṯṱuùúûũūŭůűųưǔȕȗṳṵṷṹṻụủứừửữựvṽṿwŵẁẃẅẇẉõṍṏäǟöüǖǘǚǜxẋẍyýŷÿƴẏỳỵỷỹ";
var BASIC_LA = "AAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBCCCCCCCCDDDDDDDDDDEEEEEEEEEEEEEEEEEEEEEEEEEFFFGGGGGGGGGHHHHHHHHIIIIIIIIIIIIIIIIIJJKKKKKKKLLLLLLLLLLMMMMNNNNNNNNNNOOOOOOOOOOOOOOOOOOOOOOOOOOOOOPPPPQRRRRRRRRRRSSSSSSSSŠŠZZZZZZZŽTTTTTTTTTUUUUUUUUUUUUUUUUUUUUUUUUUUVVVWWWWWWWÕÕÕÄÄÖÜÜÜÜÜXXXYYYYYYYYYYaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbccccccccddddddddddeeeeeeeeeeeeeeeeeeeeeeeeefffggggggggghhhhhhhhiiiiiiiiiiiiiiiiijjkkkkkkkllllllllllmmmmnnnnnnnnnnoooooooooooooooooooooooooooooppppqrrrrrrrrrrssssssssššzzzzzzzžtttttttttuuuuuuuuuuuuuuuuuuuuuuuuuuvvvwwwwwwwõõõääöüüüüüxxxyyyyyyyyyy";

var CHK_VOL_ERR = "Artikli lisamisel, parandamisel, kustutamisel peab olema valitud õige köide!";