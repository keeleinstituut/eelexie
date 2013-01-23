
var ARTICLE_WORD = "Entry";
var HEADWORD_WORD = "headword";
var AND_WORD = "and"

//browse.xsl
var QUERY_TEXT = "Query";
var MATCHES_TEXT = "matches";
var ENTRIES_TEXT = "entries";
var NR_TEXT = "Entry #";
var VOLUME_TEXT = "Vol";
var HEADWORDS_TEXT = "Headword(s)";
var MATCH_TEXT = "Match";
var CREATOR_TEXT = "Creator";
var CREATED_TEXT = "Created";
var EDITOR_TEXT = "Editor";
var EDITED_TEXT = "Last edited";
var TITLE_FLT_TEXT = "select distinct only";
var TITLE_SORT_TEXT = "sort";
var TITLE_SAVE_LIST_TEXT = "save list";
var TITLE_SAVE_XML_TEXT = "save entries as XML"

//FillBrowseFrame
var WORD_All = "all"

//ShowXMLParseError
var FILE_WORD = "File";
var ERROR_WORD = "Error";
var LINE_WORD = "Line";
var SRC_TEXT = "Source line";
var ERR_OPEN_XML = "Error loading XML"

//ValidateXML
var VAL_ERR = "Error validating XML!"

//CheckVolumeNr
var CHK_VOL = "Volume check";
var CHK_VOL_ERR = "Correct volume must be selected!"

//Parse_sSrvInfo
var ART_NOT_FOUND = "no entries";
var ART_ONE_FOUND = "found 1 entry";
var ART_MANY_FOUND = "found [%s] entries";
var TH_TRANSLATED = "translated [%s] themes";
var ART_TOO_MANY = "found too many entries";
var UNKNOWN_CODE = "Unknown response";
var WARNING_WORD = "Warning";
var OP_ERROR = "Error in operation!";
var SRVFUNC_ERROR = "Error in server function!";
var SAVE_OK = "Save OK";
var ADD_OK = "Add OK";
var ART_EXISTS = "Entry already exists";
var DEL_OK = "Delete (restore) OK";
var EXPORT_OK = "[%s] entries printed"

//btnRunQuery
var QUERY_ERROR = "Error starting query!";
var QUERY_WORD = "Query"

//GetQueryParams
var CASE_INSENSITIVE = "case ins.";
var CASE_SENSITIVE = "case sens.";
var SYMS_EXCLUDED = "sym. excl.";
var SYMS_INCLUDED = "sym. incl.";
var GLOBAL_WORD = "glob.";
var LOCAL_WORD = "loc.";
var CONT_QUERY_Q = "Search text contains non-character symbols. Please check the symbols checkbox!"

//imgArtAddClick
var SAVE_CHANGES_Q = "Save changes?"

//imgArtDeleteClick
var DEL_WORD = "Delete (restore)";
var DEL_ART_Q = "Do you want to delete (restore) entry '[%s]'"

//ShowXPathError
var XPATH_ERR = "XPath error!"

//Export_To_Word
var CANT_CREATE_WORD = "'eki.ee' must be in Trusted Sites list && MS Word must be installed!";
var SPELL_CHECK = "Spell check";
var PREPARING_LAYOUT = "preparing layout ..."

//HandleCeeBlur
var CHECK_SPELLING = "Please check the spelling: ";
var LANGUAGE_WORD = "language: ";
var REQUIRED_POS_INT = "Positive integer required!";
var REQUIRED_DATE_TIME = "DateTime required ('yyyy-mm-ddThh:mm:ss')!"

//SetVars
var ERR_GET_DECL = "Error getting item's schema declaration!";
var VALUE_WORD = "value"

//HandleContextClick
var MNU_ADD = "Add";
var MNU_ADD_BEFORE = "Add before";
var MNU_ADD_CHILD = "Add child";
var MNU_ADD_AFTER = "Add after";
var MNU_ADD_ATTRS = "Add attribute";
var MNU_RENAME = "Rename";
var MNU_INCR_INDENT = "Increase indent";
var MNU_DECR_INDENT = "Decrease indent";
var MNU_CUT = "Cut";
var MNU_CUT_ADD = "Cut to add";
var MNU_COPY = "Copy";
var MNU_COPY_ADD = "Copy to add";
var MNU_PASTE = "Paste";
var MNU_PASTE_BEFORE = "Before";
var MNU_PASTE_CHILD = "Append as child";
var MNU_PASTE_AFTER = "After";
var MNU_PASTE_REPLACE = "Replace";
var MNU_DELETE = "Delete";
var MNU_OPEN_FORCOPY = "Open for copying";
var MNU_ADD_XMLCOMMENT = "Add XML comment";
var MNU_OPEN_FIND_REPLACE = "Open for find/replace over volumes";
//
var MNU_INS_SYM_ENTS_STYLES = "Entities && styles";
var MNU_INS_SYM_ENTITIES = "Entities";
var MNU_INS_SYM_STYLES = "Styles";
var MNU_INS_SYM_LATIN_1 = "Latin A - L";
var MNU_INS_SYM_LATIN_2 = "Latin M - Z";
var MNU_INS_SYM_SYM_LIGATURES = "Ligatures && symbols";
var MNU_INS_SYM_COMB_SYM = "Comb. diacr. marks";
var MNU_INS_SYM_GREEK = "Greek";
var MNU_INS_SYM_CYRILLIC = "Cyrillic";
var MNU_INS_SYM_UDMURTIAN = "Udmurtian letters";
var MNU_INS_SYM_MARI = "Mari letters";
var MNU_INS_SYM_ETHYMOLOGY = "Ethym. symbols";
var MNU_INS_SYM_PRONUNCIATION = "Pronunciation symbols"

//ClickCMenu
var DLG_REN_ELEMENT = "Rename XML element";
var DLG_GET_ELEM_NAME = "enter new XML name (QName):"

//ValueDicChecks
var PARTNER_CHANGED_TEXT = "Partner changed. Check another!";
var PARTNER_CHANGED_TITLE = "Partner attribute change"

//xmlChanged
var ENTRY_SIGNED = "Entry is signed by '[%s]'.";
var ENTRY_COMPLETED = "Entry is marked as complete by '[%s]'.";
var ENTRY_STARTED = "Entry is composed by '[%s]'."

//fillArtToolsMenu
var SIGN_ENTRY = "Sign entry";
var REM_SIGN_ENTRY = "Remove entry signing";
var ADD_EMPTY_EQUIV = "Add empty equivalencies";
var IMP_FROM_WORD = "Import translation equivalents";
var MARK_AS_COMPLETE = "Mark entry as complete";
var REM_MARK_AS_COMPLETE = "Mark entry as uncomplete";
//--------------------------------------------------------------------------------
// Eesmärk : ToolsMenusse valikute nimetused
// Loodud  : 10.04.2009 10:45 ATeesalu
// Muutis  : 13.04.2009 10:32 ATeesalu
//--------------------------------------------------------------------------------
var ENTRY_DICTIONARY = "HS-sõnastiku artikkel";
var ENTRY_DATABASE = "AB-andmebaasi artikkel";
//--------------------------------------------------------------------------------
// Eesmärk : ToolsMenusse valikute nimetused
// Loodud  : 01.12.2009 10:45 ATeesalu
// Muutis  : 01.12.2009 10:32 ATeesalu
//--------------------------------------------------------------------------------
var ENTRY_DICTIONARY_UKR = "UKR-sõnastiku artikkel";
var ENTRY_DATABASE_UKR = "AB-andmebaasi artikkel"

//--------------------------------------------------------------------------------
// Eesmärk : ToolsMenusse valikute nimetused
// Loodud  : 19.01.2010 10:45 ATeesalu
// Muutis  : 19.01.2010 10:32 ATeesalu
//--------------------------------------------------------------------------------
var ENTRY_DICTIONARY_VSL = "VL-sõnastiku artikkel";
var ENTRY_DATABASE_VSL = "AB-andmebaasi artikkel"

//--------------------------------------------------------------------------------
var ENTRY_DICTIONARY_FIN = "FIN-sõnastiku artikkel";
var ENTRY_DATABASE_FIN = "AB-andmebaasi artikkel"

//--------------------------------------------------------------------------------
var ENTRY_DICTIONARY_SS1 = "SS1-sõnastiku artikkel";
var ENTRY_DATABASE_SS1 = "AB-andmebaasi artikkel";
//--------------------------------------------------------------------------------
var ENTRY_DICTIONARY_KNR = "EKNR sõnastiku artikkel";
var ENTRY_DATABASE_KNR = "AB-(varu)andmebaasi artikkel";
//--------------------------------------------------------------------------------
var ENTRY_DICTIONARY_MAR = "MAR - sõnastiku artikkel";
var ENTRY_DATABASE_MAR = "AB - andmebaasi artikkel";
//--------------------------------------------------------------------------------

var NAME_PREVIOUS = "Previous";
var NAME_NEXT = "Next";
var NAME_FIRST = "First";
var NAME_LAST = "Last"

var NAME_MORF_ANA = "Morph analysis";
var NAME_MORF_SYN = "Show paradigma";
var NAME_MORF_SYN_ASENDA = "Show synthesized forms"

var NAME_LOG = "Dictionary log";
var NAME_BULK = "Bulk operations";
var NAME_EELEX_CONFIG = "EELex setup";
var NAME_XMLCOPY = "XML copy";
var NAME_ALIKE_HW = "Alike headwords";
var NAME_ERR_REFERENCES = "Broken links";
var NAME_LIST = "List";
var NAME_IMPORT_ENTRY = "Import entry";
var NAME_ABOUT = "About dictionary"

var MORF_ANA_SUCCESS = "Morph analysis setup successfully saved!";
var MORF_SYN_SUCCESS = "Morph synthesis setup successfully saved!";
var EELEX_SETUP_SUCCESS = "EELex setup successfully saved!";
