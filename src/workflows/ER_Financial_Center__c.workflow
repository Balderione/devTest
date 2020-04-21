<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUIT21_Sales_Code</fullName>
        <field>IT_Sales_Manager_txt__c</field>
        <formula>CASE( IT_Contact_Code__c,
&quot;003&quot;,&quot;ALESSANDRO MIGLIORETTI&quot;,
&quot;004&quot;,&quot;MAURIZIO CAVIGLIA&quot;,
&quot;005&quot;,&quot;ROBERTO ZIN&quot;,
&quot;006&quot;,&quot;GIAN MARIO BOSCAINI&quot;,
&quot;007&quot;,&quot;MARCO LUONGO&quot;,
&quot;008&quot;,&quot;ANDREA GELAO&quot;,
&quot;009&quot;,&quot;RITA FRANCONI&quot;,
&quot;010&quot;,&quot;FRANCESCO FLORA&quot;,
&quot;011&quot;,&quot;CRISTINA SACCHI&quot;,
&quot;012&quot;,&quot;ALESSANDRO RINALDI&quot;,
&quot;013&quot;,&quot;DANIELE REMIDA&quot;,
&quot;014&quot;,&quot;MANUELA FIORE&quot;,
&quot;016&quot;,&quot;ALESSANDRO CASTIGLIONE&quot;,
&quot;017&quot;,&quot;JACOPO GONZALEZ&quot;,
&quot;018&quot;,&quot;COMMERCIALE DIREZIONE&quot;,
&quot;019&quot;,&quot;ANDREA BARUFFI&quot;,
&quot;021&quot;,&quot;RICCARDO ROCCHI&quot;,
&quot;022&quot;,&quot;MASSIMO PATANE&quot;,
&quot;024&quot;,&quot;PAOLO PASSANNANTI&quot;,
&quot;025&quot;,&quot;ANTONIO BONOLLO&quot;,
&quot;026&quot;,&quot;STEFANO FODALE&quot;,
&quot;027&quot;,&quot;PIER PAOLO VENTURI&quot;,
&quot;028&quot;,&quot;ALESSANDRO RENZI&quot;,
&quot;029&quot;,&quot;ELISA GHIOTTI&quot;,
&quot;030&quot;,&quot;MARCO ODDONE&quot;,
&quot;031&quot;,&quot;LUDOVICO PREMOLI&quot;,
&quot;032&quot;,&quot;CATHERINE KEITH CLEMENTE&quot;,
&quot;033&quot;,&quot;GIOVANNA CAFAZZO&quot;,
&quot;034&quot;,&quot;MARCELLO PAPALEO&quot;,
&quot;035&quot;,&quot;STEFANIA TROTTA&quot;,
&quot;036&quot;,&quot;PIETRO GIROLAMI&quot;,
&quot;037&quot;,&quot;ERIKA CAMPISANO&quot;,
&quot;038&quot;,&quot;LORENZO SILVESTRI&quot;,
&quot;040&quot;,&quot;44 FILIALE MILANO&quot;,
&quot;041&quot;,&quot;44 FILIALE BRESCIA&quot;,
&quot;042&quot;,&quot;76 FILIALE VENETO&quot;,
&quot;043&quot;,&quot;20 FILIALE BOLOGNA&quot;,
&quot;044&quot;,&quot;TELEVENDITA TELEVENDITA&quot;,
&quot;045&quot;,&quot;RAFFAELLA OPPEDISANO&quot;,
&quot;046&quot;,&quot;UGO CILIBERTI&quot;,
&quot;047&quot;,&quot;MARIO PANELLI&quot;,
&quot;048&quot;,&quot;ROBERTO MANCUSO&quot;,
&quot;049&quot;,&quot;CLIENTI PICCOLI ROMA CLIENTI PICCOLI ROMA&quot;,
&quot;050&quot;,&quot;FIORELLA MAZZONI&quot;,
&quot;051&quot;,&quot;GIAN LUCA DARDI&quot;,
&quot;052&quot;,&quot;GINO BARBIERI&quot;,
&quot;053&quot;,&quot;PAOLA ROSSI&quot;,
&quot;054&quot;,&quot;FEDERICO MANCA&quot;,
&quot;055&quot;,&quot;GIUSEPPE MAGGI&quot;,
&quot;056&quot;,&quot;MAURIZIO MASCIA&quot;,
&quot;057&quot;,&quot;ELISABETTA CASTELLANA&quot;,
&quot;058&quot;,&quot;MANLIO GIUNTA&quot;,
&quot;059&quot;,&quot;PAOLA SCRIGNA&quot;,
&quot;060&quot;,&quot;GIANLUCA PEZZOTTI&quot;,
&quot;061&quot;,&quot;CRISTINA FERRUZZI&quot;,
&quot;062&quot;,&quot;GIANMARCO NUVOLONI&quot;,
&quot;063&quot;,&quot;ELEONORA ANIDORI&quot;,
&quot;064&quot;,&quot;MARCELLO SAVOIA&quot;,
&quot;065&quot;,&quot;FRANCESCA ZECCHINI&quot;,
&quot;066&quot;,&quot;MONIA VICI&quot;,
&quot;067&quot;,&quot;GIULIA RATTAZZI&quot;,
&quot;068&quot;,&quot;ANDREA SERINO&quot;,
&quot;069&quot;,&quot;ANNA MARIA DEL VESCOVO&quot;,
&quot;070&quot;,&quot;CLIENTI NUOVI SERVIZIO CLIENTI&quot;,
&quot;071&quot;,&quot;GIUSEPPE PIAZZESE&quot;,
&quot;072&quot;,&quot;ALESSANDRO PELUSIO&quot;,
&quot;073&quot;,&quot;OSCAR SANGALLI&quot;,
&quot;074&quot;,&quot;ISABELLA DI MARCO&quot;,
&quot;075&quot;,&quot;RAFFAELLA PETROCELLI&quot;,
&quot;076&quot;,&quot;OMBRETTA MORMILE&quot;,
&quot;077&quot;,&quot;MILENA ATZENI&quot;,
&quot;078&quot;,&quot;ROBERTO PERDOMI&quot;,
&quot;079&quot;,&quot;ADRIANA COSENTINO&quot;,
&quot;080&quot;,&quot;SAUL CREMONA&quot;,
&quot;081&quot;,&quot;WALTER SULZER&quot;,
&quot;082&quot;,&quot;GIUSEPPE SIRECI&quot;,
&quot;083&quot;,&quot;ALESSANDRO BUZZONI&quot;,
&quot;084&quot;,&quot;CLIENTI PICCOLI TORINO&quot;,
&quot;085&quot;,&quot;DARIO PICCOLI&quot;,
&quot;086&quot;,&quot;ALESSANDRO TOPPI&quot;,
&quot;087&quot;,&quot;MONICA BONI&quot;,
&quot;088&quot;,&quot;CRISTINA MELA&quot;,
&quot;099&quot;,&quot;MASSIMO ANGELUCCI&quot;,
&quot;100&quot;,&quot;SIMONA GORGONE&quot;,
IT_Contact_Code__c
)</formula>
        <name>FUIT21_Sales_Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUIT23_Sales_Code2</fullName>
        <field>IT_Sales_Manager_txt__c</field>
        <formula>CASE( IT_Contact_Code__c,
&quot;101&quot;,&quot;MERI LOGUERCIO&quot;,
&quot;102&quot;,&quot;LORENZO LOPEZ&quot;,
&quot;103&quot;,&quot;GIANLUCA PERRONE&quot;,
&quot;104&quot;,&quot;SALVATORE ORFEO&quot;,
&quot;105&quot;,&quot;STEFANO GALLONI&quot;,
&quot;106&quot;,&quot;MARCO BERTONERI&quot;,
&quot;107&quot;,&quot;MATTEO PASSARO&quot;,
&quot;108&quot;,&quot;MARCO SARNE&quot;,
&quot;109&quot;,&quot;ROBERTO PARODI&quot;,
&quot;110&quot;,&quot;FILIPPO GATTI&quot;,
&quot;111&quot;,&quot;MIRELA SCULSCHI&quot;,
&quot;112&quot;,&quot;ALESSIA PUTZOLU&quot;,
&quot;113&quot;,&quot;MAX PETOVELLO&quot;,
&quot;114&quot;,&quot;ANTONIO DRI&quot;,
&quot;115&quot;,&quot;CLIENTI NUOVI SEGRETERIA COMMERCIALE&quot;,
&quot;116&quot;,&quot;CRISTINA BUTTOLO&quot;,
&quot;117&quot;,&quot;ADRIANA MAZZA&quot;,
&quot;118&quot;,&quot;FRANCESCO CASTELVECCHI&quot;,
&quot;119&quot;,&quot;FRANCESCA CASALINI&quot;,
&quot;120&quot;,&quot;LAURA BRIGNONE &quot;,
&quot;121&quot;,&quot;SIMONA FERRARI&quot;,
&quot;122&quot;,&quot;ALESSANDRA GIORGIA MORETTI&quot;,
&quot;123&quot;,&quot;MARTINA DE GESUE&quot;,
&quot;124&quot;,&quot;ALESSANDRO ARDANESE&quot;,
&quot;125&quot;,&quot;ACCOUNT PHONETICA&quot;,
&quot;126&quot;,&quot;SALVATORE IACONO&quot;,
&quot;127&quot;,&quot;LUCA BORILE&quot;,
&quot;128&quot;,&quot;LUCA PASSADORE&quot;,
&quot;129&quot;,&quot;STEFANO LUPI&quot;,
&quot;130&quot;,&quot;MARCO NARI&quot;,
&quot;131&quot;,&quot;MARIANNA FALCONE&quot;,
&quot;132&quot;,&quot;RICARDO DAMIANI&quot;,
&quot;133&quot;,&quot;DAYLA VILLANI&quot;,
&quot;134&quot;,&quot;STEFANO  MONFERMOSO&quot;,
&quot;200&quot;,&quot;RAFFAELLA OPPEDISANO&quot;,
IT_Contact_Code__c
)</formula>
        <name>FUIT23_Sales_Code2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUIT24_Sales_Code3</fullName>
        <field>IT_Sales_Manager_txt__c</field>
        <formula>CASE( IT_Contact_Code__c,
&quot;201&quot;,&quot;ANNA CRUSCO&quot;,
&quot;202&quot;,&quot;LAURA ZACCHETTI&quot;,
&quot;203&quot;,&quot;LORENZO CIVARDI&quot;,
&quot;204&quot;,&quot; CLIENTI PICCOLI PADOVA&quot;,
&quot;205&quot;,&quot;MATTEO ODASSO&quot;,
&quot;206&quot;,&quot;LORENZO TESTI&quot;,
&quot;207&quot;,&quot;SALVATORE PILO&quot;,
&quot;208&quot;,&quot;ALAN ROMEO SIDELLA&quot;,
&quot;209&quot;,&quot;HELEN PETRI&quot;,
&quot;210&quot;,&quot;ANNALISA AMIRANTE&quot;,
&quot;211&quot;,&quot;FEDERICO GISMANI&quot;,
&quot;212&quot;,&quot;FRANCESCO SPINI&quot;,
&quot;213&quot;,&quot;LAURA TASSI&quot;,
&quot;214&quot;,&quot;DANIELE PETRAZZINI&quot;,
&quot;215&quot;,&quot;GIOVANNA FERRADINI&quot;,
&quot;216&quot;,&quot;ACHILLE MEROLA&quot;,
&quot;217&quot;,&quot;GIOVANNI FORLANO&quot;,
&quot;218&quot;,&quot;ROBERTA PIVA&quot;,
&quot;219&quot;,&quot;ANDREA LIVORSI&quot;,
&quot;220&quot;,&quot;MANUELA TILLI&quot;,
&quot;221&quot;,&quot;NOEMI BARCELLUZZI&quot;,
&quot;222&quot;,&quot;RENZO MINEN&quot;,
&quot;223&quot;,&quot;LILIANA ASTROLOGO&quot;,
&quot;230&quot;,&quot;MATTEO ALTOBELLI&quot;,
&quot;231&quot;,&quot;GIULIANO GHEZZI&quot;,
&quot;232&quot;,&quot;VALERIA SARACO&quot;,
&quot;233&quot;,&quot;ALESSANDRO STRANO&quot;,
&quot;234&quot;,&quot;DAVIDE CORRADI&quot;,
&quot;235&quot;,&quot;VALENTINA DAVERIO&quot;,
&quot;236&quot;,&quot;DANIELA TRINCAS&quot;,
&quot;237&quot;,&quot;PAMELA ROMANELLI&quot;,
&quot;238&quot;,&quot;FLAVIO MOLINARI&quot;,
&quot;239&quot;,&quot;ALESSIO PINAMONTI&quot;,
&quot;240&quot;,&quot;PATRIZIA ROMANO&quot;,
&quot;241&quot;,&quot;ALICE SBARUFATTI&quot;,
&quot;242&quot;,&quot;ROSSANA D ALONZO&quot;,
&quot;243&quot;,&quot;FRANCESCA BERTINOTTI&quot;,
&quot;244&quot;,&quot;LUCA RAGADINI&quot;,
&quot;245&quot;,&quot;SILVIA MACCHINI&quot;,
&quot;246&quot;,&quot;ENZA DI GREGORIO&quot;,
&quot;247&quot;,&quot;FABIANA DE GIORGI&quot;,
&quot;248&quot;,&quot;ANDREA GIRELLI&quot;,
&quot;249&quot;,&quot;DAVIDE LONGHI&quot;,
&quot;250&quot;,&quot;MARIO ORLANDO&quot;,
&quot;251&quot;,&quot;FRANCESCO PANARIELLO&quot;,
&quot;252&quot;,&quot;ILARIA SCIASCIA&quot;,
&quot;253&quot;,&quot;LUCA BONECCHER&quot;,
&quot;254&quot;,&quot;MARIO DI DATO&quot;,
&quot;255&quot;,&quot;MICHELA FORNABAIO&quot;,
&quot;256&quot;,&quot;LUCA PERFETTO&quot;,
&quot;257&quot;,&quot;ALDO PAOLO IACONO&quot;,
&quot;258&quot;,&quot;MARCO SORRENTINO&quot;,
&quot;259&quot;,&quot;ELISABETTA VALENTE&quot;,
&quot;260&quot;,&quot;PAOLO PERSICO&quot;,
&quot;261&quot;,&quot;EMANUELE CIPRIANI&quot;,
&quot;262&quot;,&quot;GIOVANNI SCANSANI&quot;,
&quot;263&quot;,&quot;MARCO DELOGU&quot;,
&quot;264&quot;,&quot;GIADA RAMPINI&quot;,
&quot;265&quot;,&quot;FEDERICO HORNBOSTEL&quot;,
&quot;266&quot;,&quot;SERENA GRILLO&quot;,
&quot;267&quot;,&quot;GIADA ARESU NARDELLI&quot;,
&quot;268&quot;,&quot;ROSARIO GALLELLI&quot;,
&quot;269&quot;,&quot;ALESSANDRO BOTTA&quot;,
&quot;270&quot;,&quot;MARZIA MERLINO&quot;,
&quot;271&quot;,&quot;GIAN LUCA BALZANI&quot;,
&quot;272&quot;,&quot;FRANCESCO PISSARD&quot;,
&quot;273&quot;,&quot;PAOLO BARZI&quot;,
&quot;274&quot;,&quot;SIMONE TAUCCI&quot;,
&quot;275&quot;,&quot;ELISA CAPORASO&quot;,
&quot;276&quot;,&quot;CARMELO SESSA&quot;,
&quot;277&quot;,&quot;SIMONE GALBIATI&quot;,
&quot;278&quot;,&quot;PLAS MAGALI&quot;,
&quot;279&quot;,&quot;SARA PALMIGIANI&quot;,
&quot;280&quot;,&quot;DANIELE RANUCCI&quot;,
&quot;281&quot;,&quot;ALBERTO LONGO&quot;,
&quot;282&quot;,&quot;ALESSANDRO DE SENSI&quot;,
&quot;283&quot;,&quot;GIULIA AGOSTINO&quot;,
&quot;284&quot;,&quot;ELENA LEONE&quot;,
&quot;285&quot;,&quot;DIMITRI ONGARO&quot;,
&quot;286&quot;,&quot;LEONARDO CARMANNINI&quot;,
&quot;287&quot;,&quot;SIMONE BERNI&quot;,
&quot;288&quot;,&quot;ROSANNA BALBERINI &quot;,
&quot;289&quot;,&quot;MONICA BASKAKIS&quot;,
&quot;290&quot;,&quot;FRANCESCA DAMELIO&quot;,
&quot;291&quot;,&quot;CLAUDIA CIPOLLA&quot;,
&quot;292&quot;,&quot;GIOVANNA BRUNO&quot;,
&quot;293&quot;,&quot;DAVIDE GIOVANARDI&quot;,
&quot;294&quot;,&quot;SIMONE TOSO&quot;,
&quot;295&quot;,&quot;ANDREA CANONICO&quot;,
&quot;296&quot;,&quot;ANDREA PALANCA&quot;,
&quot;297&quot;,&quot;MASSIMO PATANE&quot;,
&quot;298&quot;,&quot;SIMONA ZANACCHI&quot;,
&quot;299&quot;,&quot;ANGELA MANCARI&quot;,
&quot;300&quot;,&quot;GIORGIO GIANNI&quot;,					
IT_Contact_Code__c
)</formula>
        <name>FUIT24_Sales_Code3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUIT25_Sales_Code4</fullName>
        <field>IT_Sales_Manager_txt__c</field>
        <formula>CASE( IT_Contact_Code__c,
	&quot;301&quot;,&quot;ROBERTA DE MARCHI&quot;,
&quot;302&quot;,&quot;VANESSA LANDI&quot;,
&quot;303&quot;,&quot;BARBARA ACCARDI&quot;,
&quot;304&quot;,&quot;ILARIA PIU&quot;,
&quot;305&quot;,&quot;DANIEL GASPARETTI&quot;,
&quot;306&quot;,&quot;RICCARDO CAPUCCI&quot;,
&quot;307&quot;,&quot;ELISA GHERA&quot;,
&quot;308&quot;,&quot;GIORGIA MANFRIN&quot;,
&quot;309&quot;,&quot;PAOLO SCOTTI&quot;,
&quot;310&quot;,&quot;ALESSANDRO BALTIERI&quot;,
&quot;311&quot;,&quot;PAOLO CATELLI&quot;,
&quot;312&quot;,&quot;MARCELLO MOLCO&quot;,
&quot;313&quot;,&quot;GIUSY GERVASI&quot;,
&quot;314&quot;,&quot;WILLIAM SCORTI&quot;,
&quot;315&quot;,&quot;SAVERIO LATTE&quot;,
&quot;316&quot;,&quot;MASSIMO MASUZZO&quot;,
&quot;317&quot;,&quot;VALENTINA PONCHIO&quot;,
&quot;318&quot;,&quot;MANUEL BERTOLDI&quot;,
&quot;319&quot;,&quot;ILEANA MAROTTA&quot;,
&quot;320&quot;,&quot;ALESSIA CERETTA&quot;,
&quot;321&quot;,&quot;LUCIA CAZZATO&quot;,
&quot;322&quot;,&quot;ENRICO DI MAMBRO&quot;,
&quot;323&quot;,&quot;MATTEO TOMBARI&quot;,
&quot;324&quot;,&quot;DANIELA ANDRETTA&quot;,
&quot;325&quot;,&quot;ENRICO SCALON&quot;,
&quot;326&quot;,&quot;ELISA DAL PANE&quot;,
&quot;327&quot;,&quot;ALESSANDRA CANTINAZZI&quot;,
&quot;328&quot;,&quot;ANTONIO MARINI DIOMEDI&quot;,
&quot;329&quot;,&quot;MICHELA DE MICHELI&quot;,
&quot;330&quot;,&quot;DANIELE BRAMBILLA&quot;,
&quot;331&quot;,&quot;MILA VALSECCHI&quot;,
&quot;332&quot;,&quot;MARIA ELENA CALANNI&quot;,
&quot;333&quot;,&quot;MARCO DEIDDA&quot;,
&quot;334&quot;,&quot;FEDERICO DURANTE&quot;,
&quot;335&quot;,&quot;FULVIO ROSSI&quot;,
&quot;336&quot;,&quot;FLAVIO MARIANI&quot;,
&quot;337&quot;,&quot;FEDERICA SARULLO&quot;,
&quot;338&quot;,&quot;STEPHANE EARD&quot;,
&quot;339&quot;,&quot;LUCA NUNNERI&quot;,
&quot;340&quot;,&quot;LUCA ZAGO&quot;,
&quot;341&quot;,&quot;MARZIA MARTINA&quot;,
&quot;342&quot;,&quot;LAURA SCHIAVETTO&quot;,
&quot;343&quot;,&quot;MARCO DEL ROSSO&quot;,
&quot;344&quot;,&quot;MARINA CALLE&quot;,
&quot;345&quot;,&quot;VALENTINA MEAZZA&quot;,
&quot;346&quot;,&quot;VALENTINA SALERNO&quot;,
&quot;347&quot;,&quot;LOREDANA BELLIZZI&quot;,
&quot;348&quot;,&quot;MARIA VALERIA POZZI&quot;,
&quot;349&quot;,&quot;MARCO SBRIZZI&quot;,
&quot;350&quot;,&quot;MAURILIO FINA&quot;,
&quot;351&quot;,&quot;ALESSIA TODESCO&quot;,
&quot;352&quot;,&quot;DIEGO PAOLO FERLAN&quot;,
&quot;353&quot;,&quot;EMANUELE MOLTENI&quot;,
&quot;354&quot;,&quot;GIORGIA GRIFONI&quot;,
&quot;355&quot;,&quot;MARCO GALIZIOLI&quot;,
&quot;356&quot;,&quot;ELENA SOBACCHI&quot;,
&quot;357&quot;,&quot;VALENTINA MAGGIORE&quot;,
&quot;358&quot;,&quot;MARCELLA CONTE&quot;,
&quot;359&quot;,&quot;FRANCESCA  ROSSIGNOLI&quot;,
&quot;360&quot;,&quot;MANUEL MORAZZINI&quot;,
&quot;361&quot;,&quot;DAMIEN JOANNES&quot;,
&quot;362&quot;,&quot;VANESSA ZAPPACOSTA&quot;,
&quot;363&quot;,&quot;TATIANA CHIGNOLA&quot;,
&quot;364&quot;,&quot;LINDA CAMPIONI&quot;,
&quot;365&quot;,&quot;GIULIO SINISCALCO&quot;,
&quot;366&quot;,&quot;MARTINA CAPONE&quot;,
&quot;367&quot;,&quot;ANNABELLA BODINI&quot;,
&quot;368&quot;,&quot;CHIARA TALIA&quot;,
&quot;369&quot;,&quot;ELISA TAGLIARENI&quot;,
&quot;370&quot;,&quot;DONATELLA STRIPPARO&quot;,
&quot;371&quot;,&quot;FRANCESCO GIORDANO&quot;,
&quot;372&quot;,&quot;ELENA MANFE&quot;,
&quot;373&quot;,&quot;FEDERICA MISURACA&quot;,
&quot;374&quot;,&quot;STEFANO COLOMBINI&quot;,
&quot;375&quot;,&quot;MARCO MARINO&quot;,
&quot;376&quot;,&quot;MILENA PANZERI&quot;,
&quot;377&quot;,&quot;DAVIDE LIOIA&quot;,
&quot;378&quot;,&quot;ISABELLA DI CAROLO&quot;,
&quot;379&quot;,&quot;SILVIA PASSERO&quot;,
&quot;380&quot;,&quot;MAURIZIO FIORI&quot;,
&quot;381&quot;,&quot;ELMIRA HABAZAJ&quot;,
&quot;382&quot;,&quot;ANNA CHIARA FANULI&quot;,
&quot;383&quot;,&quot;ANDREA MAZZINI&quot;,
&quot;384&quot;,&quot;DANIELA  SUTERA&quot;,
&quot;385&quot;,&quot;DONATO PALFERRO&quot;,
&quot;386&quot;,&quot;REBECCA MARCHETTI&quot;,
&quot;387&quot;,&quot;ADOLFO RANIERI&quot;,
&quot;388&quot;,&quot;FRANCESCO MINUTI&quot;,
&quot;389&quot;,&quot;ANDREA FRANKLIN&quot;,
&quot;390&quot;,&quot;MARCO VIANI&quot;,
&quot;391&quot;,&quot;GIULIA CERIANI&quot;,
&quot;392&quot;,&quot;MAURIZIO DILEO&quot;,
&quot;393&quot;,&quot;LUCA VERAZZO&quot;,
&quot;394&quot;,&quot;ANGELO REMUZZI&quot;,
&quot;395&quot;,&quot;EMILIANO GALIA&quot;,
&quot;396&quot;,&quot;EMANUELA BONGIORNI&quot;,
&quot;397&quot;,&quot;ANGELA AMORUSO&quot;,
&quot;398&quot;,&quot;UTA 1 OUTSOURCING&quot;,
&quot;399&quot;,&quot;VALENTINA CARDINALE&quot;,
&quot;400&quot;,&quot;MASSIMILIANO PUGNETTI&quot;,
IT_Contact_Code__c
)</formula>
        <name>FUIT25_Sales_Code4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUIT26_Sales_Code5</fullName>
        <field>IT_Sales_Manager_txt__c</field>
        <formula>CASE( IT_Contact_Code__c,
&quot;401&quot;,&quot;VALERIA VIGORITA&quot;,
&quot;402&quot;,&quot;ELSANNA  ROTONDO&quot;,
&quot;410&quot;,&quot;CLIENTI NUOVI TICKET EXPRESS&quot;,
&quot;411&quot;,&quot; CLIENTI TLS&quot;,
&quot;417&quot;,&quot; CLIENTI PICCOLI NAPOLI&quot;,
&quot;418&quot;,&quot; CLIENTI PICCOLI FIRENZE&quot;,
&quot;419&quot;,&quot; CLIENTI PICCOLI BARI&quot;,
&quot;420&quot;,&quot;CLIENTI PICCOLI GENOVA&quot;,
&quot;421&quot;,&quot;ALESSANDRO STRAMAGLIA&quot;,
&quot;422&quot;,&quot;MARIANGELA MARCHIO&quot;,
&quot;423&quot;,&quot;MANUELA VERDERIO&quot;,
&quot;424&quot;,&quot;ILARIA GARZOLI&quot;,
&quot;425&quot;,&quot;SAVERIO CHIODO&quot;,
&quot;426&quot;,&quot;LUIGI MANOGRASSO&quot;,
&quot;427&quot;,&quot;ANTONIETTA CALABRESE&quot;,
&quot;428&quot;,&quot;DOMENICO RUSSO&quot;,
&quot;429&quot;,&quot;GENNARO SCARPATO&quot;,
&quot;430&quot;,&quot;FRANCESCO ALIGHIERI&quot;,
&quot;431&quot;,&quot;GENNARO DEL DUCA&quot;,
&quot;432&quot;,&quot;JOLANDA MUCCITELLI&quot;,
&quot;433&quot;,&quot;ANTONINO RUOCCO&quot;,
&quot;434&quot;,&quot;LUCIANA TERRIBILE&quot;,
&quot;435&quot;,&quot;PAOLO COMISI&quot;,
&quot;436&quot;,&quot;GIOVANNI BOREA&quot;,
&quot;437&quot;,&quot;MONICA CIRELLI&quot;,
&quot;438&quot;,&quot;MASSIMO IAVARONE&quot;,
&quot;439&quot;,&quot;TIZIANA MORETTO&quot;,
&quot;440&quot;,&quot;SAUL PERTICA&quot;,
&quot;441&quot;,&quot;ANTONIO PINNA&quot;,
&quot;442&quot;,&quot;GIOVANNI GARGALLO&quot;,
&quot;443&quot;,&quot;GASPARE INCORVAIA&quot;,
&quot;444&quot;,&quot;SILVIA FUGAZZARO&quot;,
&quot;445&quot;,&quot;AFRODITE MANNA&quot;,
&quot;446&quot;,&quot;NADIA CARBONE&quot;,
&quot;447&quot;,&quot;ELIO CONTI&quot;,
&quot;448&quot;,&quot;AURELIO REGGIANI&quot;,
&quot;449&quot;,&quot;ROBERTA DEL CORNO&quot;,
&quot;450&quot;,&quot;MASSIMILIANO DE FILIPPI&quot;,
&quot;451&quot;,&quot;PASQUALE TARANTINO&quot;,
&quot;452&quot;,&quot;RICCARDO BELLINZONA&quot;,
&quot;453&quot;,&quot;VINCENZO PEPE&quot;,
&quot;454&quot;,&quot;CLAUDIO AVAGLIANO&quot;,
&quot;455&quot;,&quot;GIANLUCA MICELI&quot;,
&quot;456&quot;,&quot;MARCO SGOBBO&quot;,
&quot;457&quot;,&quot;ANDREA PESANTE&quot;,
&quot;458&quot;,&quot;EMANUELA MUSSO&quot;,
&quot;459&quot;,&quot;MAURIZIO TOSCANO&quot;,
&quot;460&quot;,&quot;SARA NERI&quot;,
&quot;461&quot;,&quot;FRANCESCO IOVINO&quot;,
&quot;462&quot;,&quot;FRANCESCO CRESPI&quot;,
&quot;463&quot;,&quot;EMANUELA PIGNATARO&quot;,
&quot;464&quot;,&quot;MARCO DI FRONZO&quot;,
&quot;465&quot;,&quot;SIMONA MAZZARETTO&quot;,
&quot;466&quot;,&quot;SARA GIUDICE&quot;,
&quot;467&quot;,&quot;ALESSANDRA VULTAGGIO&quot;,
&quot;468&quot;,&quot;ALESSANDRO FARAONE&quot;,
&quot;469&quot;,&quot;FEDERICA FABBRIZIOLI&quot;,
&quot;470&quot;,&quot;FRANCESCA TUNESI&quot;,
&quot;471&quot;,&quot;BEATRICE BOSELLI&quot;,
&quot;472&quot;,&quot;MARIA LUISA MARIOTTI&quot;,
&quot;473&quot;,&quot;GIAN LUCA MAGISTRONI&quot;,
&quot;474&quot;,&quot;ALBERTO RESCIGNO&quot;,
&quot;475&quot;,&quot;LORENZO  TITARO&quot;,
&quot;476&quot;,&quot;GIULIA MARCHI&quot;,
&quot;477&quot;,&quot;MARIA CONCETTA LOPARCO&quot;,
&quot;478&quot;,&quot;ALESSIA CARRADORE&quot;,
&quot;479&quot;,&quot;CLIENTI NUOVI SEGRETERIA EXPENDIA&quot;,
&quot;480&quot;,&quot;MATTEO BARBIERO&quot;,
&quot;481&quot;,&quot;SIMONE MONTORFANO&quot;,
&quot;482&quot;,&quot;MIRKO IACONA&quot;,
&quot;483&quot;,&quot;DANIELA COLOMBARA&quot;,
&quot;484&quot;,&quot;FELICE CINIGLIO&quot;,
&quot;485&quot;,&quot;ALESSIO PIROVANO&quot;,
&quot;486&quot;,&quot;GIUSEPPINA LISA MISSERE&quot;,
&quot;487&quot;,&quot;VALENTINA CARLINI&quot;,
&quot;488&quot;,&quot; CLIENTI PICCOLI TRENTO&quot;,
&quot;489&quot;,&quot;STEFANO BOI&quot;,
&quot;490&quot;,&quot;ALESSIA BLANCO&quot;,
&quot;491&quot;,&quot;SILVIA LA COGNATA&quot;,
&quot;492&quot;,&quot;FRANCESCA CERCIELLO&quot;,
&quot;493&quot;,&quot;FLAVIA ROSONE&quot;,
&quot;494&quot;,&quot;STEFANIA MODICA&quot;,
&quot;495&quot;,&quot;MARIELLA PELLEGRINO&quot;,
&quot;496&quot;,&quot;CLAUDIA CORTI&quot;,
&quot;497&quot;,&quot;FEDERICA RUSSO&quot;,
&quot;498&quot;,&quot;FEDERICO VACCA&quot;,
&quot;499&quot;,&quot;BLASCO SALAMONE&quot;,
&quot;500&quot;,&quot;GRAZIELLA GAVEZOTTI&quot;,
&quot;600&quot;,&quot;MARIA GRAZIA FILIPPINI&quot;,
&quot;700&quot;,&quot;ANDREA KELLER&quot;,
&quot;800&quot;,&quot;LUCA PALERMO&quot;,
&quot;999&quot;,&quot; In attesa di variazione&quot;,
IT_Contact_Code__c
)</formula>
        <name>FUIT26_Sales_Code5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WFIT23_Sales_Account_Code</fullName>
        <actions>
            <name>FUIT21_Sales_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>value( IT_Contact_Code__c ) &lt;= 100</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WFIT24_Sales_Account_Code2</fullName>
        <actions>
            <name>FUIT23_Sales_Code2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  value( IT_Contact_Code__c ) &lt;= 200,  value( IT_Contact_Code__c ) &gt; 100 )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WFIT25_Sales_Account_Code3</fullName>
        <actions>
            <name>FUIT24_Sales_Code3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  value( IT_Contact_Code__c ) &lt;= 300,  value( IT_Contact_Code__c ) &gt; 200 )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WFIT26_Sales_Account_Code4</fullName>
        <actions>
            <name>FUIT25_Sales_Code4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  value( IT_Contact_Code__c ) &lt;= 400,  value( IT_Contact_Code__c ) &gt; 300 )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WFIT27_Sales_Account_Code5</fullName>
        <actions>
            <name>FUIT26_Sales_Code5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>value( IT_Contact_Code__c ) &gt; 400</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
