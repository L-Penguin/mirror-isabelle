/*
 * translation table for the low-8-bit ascii codes
 * translation takes place only if destCode is TO_LaTeX
 *
 * the row number + START_LOW_TABLE -1 is the ascii code !!
 */

/* do not edit the lines between BEGIN_OF_LOW_TABLE and END_OF_LOW_TABLE  */
/* these lines are automatically generated by gen-isa2latex               */

/* BEGIN_OF_LOW_TABLE */
char *translationTableLow[END_LOW_TABLE - START_LOW_TABLE + 1] = {
   "\\ ",
   "!",
   "\x22{}",
   "\\#",
   "\\$",
   "\\%",
   "\\&",
   "'",
   "(",
   ")",
   "{*}",
   "+",
   ",",
   "-",
   ".",
   "/",
   "0",
   "1",
   "2",
   "3",
   "4",
   "5",
   "6",
   "7",
   "8",
   "9",
   ":",
   ";",
   "<",
   "=",
   ">",
   "?",
   "@",
   "A",
   "B",
   "C",
   "D",
   "E",
   "F",
   "G",
   "H",
   "I",
   "J",
   "K",
   "L",
   "M",
   "N",
   "O",
   "P",
   "Q",
   "R",
   "S",
   "T",
   "U",
   "V",
   "W",
   "X",
   "Y",
   "Z",
   "[",
   "\\ttbackslash{}",
   "]",
   "\\^{}",
   "{\\_\\hspace{.344ex}}",
   "`",
   "a",
   "b",
   "c",
   "d",
   "e",
   "f",
   "g",
   "h",
   "i",
   "j",
   "k",
   "l",
   "m",
   "n",
   "o",
   "p",
   "q",
   "r",
   "s",
   "t",
   "u",
   "v",
   "w",
   "x",
   "y",
   "z",
   "\\{",
   "|",
   "\\}",
   "\\tttilde{}"
};
/* END_OF_LOW_TABLE */


/*
 * conversion table for Hi-8-bit table
 *
 * the row number + START_HIGH_TABLE -1 is the ascii code !!
 * 
 * first  column is used if destCode is TO_7bit
 * second column is used if destCode is TO_LaTeX
 */

/* do not edit the lines between BEGIN_OF_HI_TABLE and END_OF_HI_TABLE  */
/* these lines are automatically generated by gen-isa2latex             */

/* BEGIN_OF_HI_TABLE */
char *translationTableHi[END_HI_TABLE - START_HI_TABLE + 1][2] = {
   {"  "           ,"\\ \\ "},
   {"\\Gamma"      ,"\\mbox{$\\Gamma$}"},
   {"\\Delta"      ,"\\mbox{$\\Delta$}"},
   {"\\Theta"      ,"\\mbox{$\\Theta$}"},
   {"LAM "         ,"\\mbox{$\\Lambda$}"},
   {"\\Pi"         ,"\\mbox{$\\Pi$}"},
   {"\\Sigma"      ,"\\mbox{$\\Sigma$}"},
   {"\\Phi"        ,"\\mbox{$\\Phi$}"},
   {"\\Psi"        ,"\\mbox{$\\Psi$}"},
   {"\\Omega"      ,"\\mbox{$\\Omega$}"},
   {"'a"           ,"\\mbox{$\\alpha$}"},
   {"'b"           ,"\\mbox{$\\beta$}"},
   {"'c"           ,"\\mbox{$\\gamma$}"},
   {"\\delta"      ,"\\mbox{$\\delta$}"},
   {"@"            ,"\\mbox{$\\varepsilon$}"},
   {"\\zeta"       ,"\\mbox{$\\zeta$}"},
   {"\\eta"        ,"\\mbox{$\\eta$}"},
   {"\\vartheta"   ,"\\mbox{$\\vartheta$}"},
   {"\\kappa"      ,"\\mbox{$\\kappa$}"},
   {"%"            ,"\\mbox{$\\lambda$}"},
   {"\\mu"         ,"\\mbox{$\\mu$}"},
   {"\\nu"         ,"\\mbox{$\\nu$}"},
   {"\\xi"         ,"\\mbox{$\\xi$}"},
   {"\\p"          ,"\\mbox{$\\pi$}"},
   {"'r"           ,"\\mbox{$\\rho$}"},
   {"'s"           ,"\\mbox{$\\sigma$}"},
   {"'t"           ,"\\mbox{$\\tau$}"},
   {"\\varphi"     ,"\\mbox{$\\varphi$}"},
   {"\\chi"        ,"\\mbox{$\\chi$}"},
   {"\\psi"        ,"\\mbox{$\\psi$}"},
   {"\\omega"      ,"\\mbox{$\\omega$}"},
   {"~ "           ,"\\mbox{$\\neg$}"},
   {"& "           ,"\\mbox{$\\hspace{-.185ex}\\wedge\\hspace{-.185ex}$}\\ "},
   {"| "           ,"\\mbox{$\\hspace{-.185ex}\\vee\\hspace{-.185ex}$}\\ "},
   {"!"            ,"\\mbox{$\\hspace{-.07ex}\\forall$}"},
   {"? "           ,"\\mbox{$\\hspace{-.07ex}\\exists$}"},
   {"!!"           ,"\\mbox{$\\bigwedge$}"},
   {"\\lceil"      ,"\\mbox{$\\lceil$}"},
   {"\\rceil"      ,"\\mbox{$\\rceil$}"},
   {"\\lfloor"     ,"\\mbox{$\\lfloor$}"},
   {"\\rfloor"     ,"\\mbox{$\\rfloor$}"},
   {"|-"           ,"\\mbox{$\\hspace{.49ex}\\vdash\\hspace{.49ex}$}"},
   {"|="           ,"\\mbox{$\\models$}"},
   {"[|"           ,"\\mbox{$[\\![\\hspace{.32ex}$}"},
   {"|]"           ,"\\mbox{$\\hspace{.32ex}]\\!]$}"},
   {"."            ,"\\mbox{$\\hspace{.28ex}\\cdot\\hspace{.28ex}$}"},
   {":"            ,"\\hspace{.1ex}\\mbox{$\\in$}\\hspace{.1ex}"},
   {" \\subseteq " ,"\\mbox{$\\subseteq$}"},
   {" Int "        ,"\\mbox{$\\cap$}"},
   {" Un "         ,"\\mbox{$\\cup$}"},
   {"INT "         ,"\\mbox{$\\bigcap$}"},
   {"UN "          ,"\\mbox{$\\bigcup$}"},
   {"\\sqcap"      ,"\\mbox{$\\hspace{.29ex}\\sqcap\\hspace{.29ex}$}"},
   {"\\sqcup"      ,"\\mbox{$\\hspace{.29ex}\\sqcup\\hspace{.29ex}$}"},
   {"glb "         ,"\\mbox{$\\overline{|\\,\\,|}$}"},
   {"LUB "         ,"\\mbox{$\\bigsqcup$}"},
   {"UU"           ,"\\mbox{$\\bot$}"},
   {".="           ,"\\mbox{$\\doteq$}"},
   {"=="           ,"\\mbox{$\\hspace{.29ex}\\equiv\\hspace{.29ex}$}"},
   {"~="           ,"\\mbox{$\\not=$}"},
   {"\\sqsubset"   ,"\\mbox{$\\hspace{.29ex}\\sqsubset\\hspace{.29ex}$}"},
   {"<<"           ,"\\mbox{$\\hspace{.29ex}\\sqsubseteq\\hspace{.29ex}$}"},
   {"<:"           ,"\\mbox{$\\hspace{.29ex}\\prec\\hspace{.29ex}$}\\ "},
   {"<=:"          ,"\\mbox{$\\hspace{.29ex}\\preceq\\hspace{.29ex}$}"},
   {":>"           ,"\\mbox{$\\hspace{.29ex}\\succ\\hspace{.29ex}$}\\ "},
   {"~~"           ,"\\mbox{$\\hspace{.29ex}\\approx\\hspace{.29ex}$}"},
   {"\\sim "       ,"\\mbox{$\\hspace{.29ex}\\sim\\hspace{.29ex}$}\\ "},
   {"\\simeq"      ,"\\mbox{$\\hspace{.29ex}\\simeq\\hspace{.29ex}$}"},
   {"<="           ,"\\mbox{$\\hspace{.29ex}\\le\\hspace{.29ex}$}"},
   {"::"           ,"\\mbox{$:\\hspace{-.07ex}:$}"},
   {"<-"           ,"\\mbox{$\\leftarrow$}"},
   {"-"            ,"\\mbox{$-$}"},
   {"->"           ,"\\mbox{$\\rightarrow$}"},
   {"<="           ,"\\mbox{$\\Leftarrow$}"},
   {"="            ,"\\mbox{$=$}"},
   {"=>"           ,"\\mbox{$\\hspace{.12ex}\\Rightarrow$}"},
   {"\\frown"      ,"\\mbox{$\\frown$}"},
   {"|->"          ,"\\mbox{$\\mapsto$}"},
   {"~>"           ,"\\mbox{$\\hspace{.05ex}\\leadsto$}"},
   {"\\uparrow"    ,"\\mbox{$\\uparrow$}"},
   {"\\downarrow"  ,"\\mbox{$\\downarrow$}"},
   {"~:"           ,"\\mbox{$\\notin$}"},
   {"*"            ,"\\mbox{$\\hspace{-.29ex}\\times\\hspace{-.29ex}$}"},
   {"++"           ,"\\mbox{$\\hspace{.29ex}\\oplus\\hspace{.29ex}$}"},
   {"--"           ,"\\mbox{$\\hspace{.29ex}\\ominus\\hspace{.29ex}$}"},
   {"**"           ,"\\mbox{$\\hspace{.29ex}\\otimes\\hspace{.29ex}$}"},
   {"//"           ,"\\mbox{$\\hspace{.29ex}\\oslash\\hspace{.29ex}$}"},
   {"\\subset"     ,"\\mbox{$\\subset$}"},
   {"\\infty"      ,"\\mbox{$\\infty$}"},
   {"\\Box"        ,"\\mbox{$\\Box$}"},
   {"<>"           ,"\\mbox{$\\hspace{.29ex}\\Diamond\\hspace{.29ex}$}"},
   {" o "          ,"\\mbox{$\\circ$}"},
   {"\\bullet"     ,"\\mbox{$\\bullet$}"},
   {"||"           ,"\\mbox{$\\parallel$}"},
   {"\\tick"       ,"\\mbox{$\\surd$}"},
   {"\\filter"     ,"\\mbox{\\copyright}"}
};
/* END_OF_HI_TABLE */


/*
 * conversion table for long ascii and 8bit sequences scanned by lexer
 * 
 * first  column is used if destCode is TO_7bit
 * second column is used if destCode is TO_LaTeX
 *
 * Row - 1 is the code (longCode) used by the lexer
 */      

/* do not edit the lines between BEGIN_OF_SEQ_TABLE and END_OF_SEQ_TABLE  */
/* these lines are automatically generated by gen-isa2latex               */

/* BEGIN_OF_SEQ_TABLE */
char *translationTableSeq[SEQ_TABLE][2] = {
   {"==>"                                         ,"\\mbox{$\\hspace{-.083ex}\\Longrightarrow$}"},
   {"-->"                                         ,"\\mbox{$\\longrightarrow$}"},
   {"?!"                                          ,"\\mbox{$\\exists_1$}"},
   {"ALL "                                        ,"\\mbox{$\\forall$}"},
   {"EX "                                         ,"\\mbox{$\\exists$}"},
   {"<<|"                                         ,"\\mbox{$\\ll\\!\\mid$}"},
   {"<|"                                          ,"\\mbox{$<\\!\\mid$}"},
   {"<=="                                         ,"\\mbox{$\\Longleftarrow$}"},
   {"<=>"                                         ,"\\mbox{$\\Leftrightarrow$}"},
   {"<--"                                         ,"\\mbox{$\\longleftarrow$}"},
   {"<->"                                         ,"\\mbox{$\\leftrightarrow$}"},
   {"arities"                                     ,"\\mbox{\\bf arities}"},
   {"axclass"                                     ,"\\mbox{\\bf axclass}"},
   {"constdefs"                                   ,"\\mbox{\\bf constdefs}"},
   {"consts"                                      ,"\\mbox{\\bf consts}"},
   {"datatype"                                    ,"\\mbox{\\bf datatype}"},
   {"defs"                                        ,"\\mbox{\\bf defs}"},
   {"domain"                                      ,"\\mbox{\\bf domain}"},
   {"end"                                         ,"\\mbox{\\bf end}"},
   {"inductive"                                   ,"\\mbox{\\bf inductive}"},
   {"instance"                                    ,"\\mbox{\\bf instance}"},
   {"primrec"                                     ,"\\mbox{\\bf primrec}"},
   {"recdef"                                      ,"\\mbox{\\bf recdef}"},
   {"rules"                                       ,"\\mbox{\\bf rules}"},
   {"syntax"                                      ,"\\mbox{\\bf syntax}"},
   {"translations"                                ,"\\mbox{\\bf translations}"},
   {"typedef"                                     ,"\\mbox{\\bf typedef}"},
   {"types"                                       ,"\\mbox{\\bf types}"}
};
/* END_OF_SEQ_TABLE */


