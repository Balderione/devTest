<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Lettera Enti</label>
    <protected>false</protected>
    <values>
        <field>IT_Active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>IT_HtmlForPdf__c</field>
        <value xsi:type="xsd:string">&lt;html&gt; &lt;head&gt; &lt;meta content=&quot;text/html; charset=UTF-8&quot; http-equiv=&quot;content-type&quot;&gt; &lt;style&gt; html, body{ height: 100%; } body{ position: relative; font-family: sans-serif; font-size: 8pt; width: 100%; margin: 0 auto; } .f12{font-size: 11pt;} p{margin: 0} table{ width: 100%; border-collapse: collapse; font: inherit; } td{vertical-align: top;} .header{ margin-top: 20pt; width=&quot;100%&quot;; } .intro{ margin-top: 20pt; font-size: 10pt; } .list{ border: 1px solid #000000; margin-top: 5pt; margin-bottom: 10pt; } th{ text-align: center; font-weight: bold; border: 1px solid #000000; font-size: 10pt; vertical-align: top; } .list td{ border: 1px solid #000000; padding: 2pt 5pt; } .firma{ margin-top: 10pt; text-align: center; font-size: 12pt; margin-bottom: 20pt; } .firma p{ position: relative; z-index: 1; } .firma img{ margin-top: -20pt; } .page-1{ padding: 20pt 40pt; page-break-after: always; } .page-2{ text-align: center; padding: 20pt 40pt; page-break-after: always; } @media print{ .firma{margin-bottom: 0} .footer-img{ position: absolute; left: 0; bottom: 0; } } &lt;/style&gt; &lt;/head&gt;  &lt;body&gt;  &lt;div class=&quot;page-1&quot;&gt; &lt;img src=&quot;/resource/Styles/ImageDoc/image1.jpg&quot; width=&quot;100px&quot; style=&quot;display: block;&quot;&gt;  &lt;div class=&quot;main-page&quot;&gt; &lt;div class=&quot;header&quot;&gt; &lt;table&gt; &lt;tr&gt; &lt;td width=&quot;60%&quot; style=&quot;font-family: sans-serif;&quot;&gt; &lt;br /&gt; FAX: {!FAX}&lt;br /&gt; PROT. {!CONTRACT_PROTOCOL}&lt;br /&gt;&lt;br /&gt; c/c {!CLIENT_CODE}&lt;br /&gt;&lt;br /&gt;&lt;br /&gt; CIG: {!CIG}&lt;/td&gt; &lt;td class=&quot;f12&quot; style=&quot;font-family: sans-serif;&quot;&gt; Milano, {!CURRENT_DATE}&lt;br /&gt;&lt;br /&gt; Spettabile&lt;br /&gt; &lt;b&gt;{!COMPANY_NAME_1} {!COMPANY_NAME_2} {!COMPANY_NAME_3} &lt;/b&gt;&lt;br /&gt;&lt;br /&gt;&lt;br /&gt; {!STREET}&lt;br /&gt;{!ZIP_CODE} {!CITY} ({!PROVINCE}) &lt;/td&gt; &lt;/tr&gt; &lt;/table&gt; &lt;div class=&quot;intro&quot;&gt; &lt;p style=&quot;font-family: sans-serif;&quot;&gt;&lt;b&gt;Oggetto&lt;/b&gt;:  Appalto  relativo al servizio TICKET RESTAURANT MAX ELETTRONICO – comunicazione ai sensi della L. 13 agosto 2010 n.136.&lt;br /&gt;&lt;br /&gt; Con riferimento alle disposizioni di legge n. 136/2010 comunichiamo in calce gli estremi identificativi del conto corrente bancario dedicato in via non esclusiva all’appalto in oggetto con Voi in corso, nonché le generalità ed i codici fiscali delle persone delegate ad operare sul conto stesso.&lt;br /&gt; Estremi del conto corrente:&lt;br /&gt;{!BANK_ACCOUNT}&lt;br /&gt;&lt;br /&gt; Generalità e codice fiscale delle persone delegate ad operare sul sopra citato conto corrente&lt;/p&gt; &lt;/div&gt; &lt;table class=&quot;list&quot;&gt; &lt;tr&gt; &lt;th style=&quot;font-family: sans-serif;&quot;&gt;NOME E COGNOME&lt;/th&gt; &lt;th style=&quot;font-family: sans-serif;&quot;&gt;DATA DI&lt;br&gt;NASCITA&lt;/th&gt; &lt;th style=&quot;font-family: sans-serif;&quot;&gt;LUOGO DI NASCITA&lt;/th&gt; &lt;th style=&quot;font-family: sans-serif;&quot;&gt;CODICE FISCALE&lt;/th&gt; &lt;/tr&gt; &lt;tr&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;STANISLAS ANDRE JACQUES DE BOURGUES&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;29/12/1979&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot; align=&quot;center&quot;&gt;PARIGI&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;DBRSNS79T29Z110G&lt;/td&gt; &lt;/tr&gt; &lt;tr&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;MARCO BIGLIETTO&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;25/01/1973&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot; align=&quot;center&quot;&gt;MILANO&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;BGLMRC73A25F205N&lt;/td&gt; &lt;/tr&gt; &lt;tr&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;GRAZIELLA DANILA GAVEZOTTI&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;10/09/1951&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot; align=&quot;center&quot;&gt;MILANO&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;GVZGZL51P50F205P&lt;/td&gt; &lt;/tr&gt; &lt;tr&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;PAOLO MUSAZZI&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;03/05/1967&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot; align=&quot;center&quot;&gt;LEGNANO (MI)&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;MSZPLA67E03E514N&lt;/td&gt; &lt;/tr&gt; &lt;tr&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;LUCA ALBINO PALERMO&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;29/10/1970&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot; align=&quot;center&quot;&gt;IVREA (TO)&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;PLRLLB70R29E379V&lt;/td&gt; &lt;/tr&gt; &lt;tr&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;MICHELE RICCARDI&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;16/02/1968&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot; align=&quot;center&quot;&gt;BUSTO ARSIZIO (VA)&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;RCCMHL68B16B300Z&lt;/td&gt; &lt;/tr&gt; &lt;tr&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;ANGELA TINELLA&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;27/09/1980&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot; align=&quot;center&quot;&gt;MOTTOLA (TA)&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;TNLNGL80P67F784Y&lt;/td&gt; &lt;/tr&gt; &lt;tr&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;ALESSANDRO GIOVANNI VIRDE&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;17/04/1965&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot; align=&quot;center&quot;&gt;SESTO SAN GIOVANNI (MI)&lt;/td&gt; &lt;td style=&quot;font-family: sans-serif;&quot;&gt;VRDLSN65D17I690S&lt;/td&gt; &lt;/tr&gt; &lt;/table&gt; &lt;div class=&quot;intro&quot;&gt; &lt;p style=&quot;font-family: sans-serif;&quot;&gt;Confermiamo che la nostra Società, con riferimento all’appalto in oggetto, si atterrà, per quanto applicabili, alle prescrizioni dell’art. 3 della legge n. 136/2010.&lt;br /&gt;&lt;br /&gt; Facciamo conto sul rispetto da parte Vostra dei termini di pagamento delle nostre fatture, che per nessun motivo (e segnatamente per l’entrata in vigore della citata legge) potranno essere  sospesi o ritardati.&lt;br /&gt;&lt;br /&gt; Distinti saluti&lt;/p&gt; &lt;/div&gt; &lt;/div&gt; &lt;div class=&quot;firma&quot;&gt; &lt;p style=&quot;font-family: sans-serif;&quot;&gt;&lt;b&gt;Edenred Italia S.r.l.&lt;/b&gt;&lt;br /&gt;Un Procuratore&lt;/p&gt; &lt;img src=&quot;/resource/Styles/ImageDoc/image3.png&quot; width=&quot;170pt&quot;&gt; &lt;/div&gt; &lt;/div&gt;  &lt;img src=&quot;/resource/Styles/ImageDoc/image2.jpg&quot; width=&quot;100%&quot; class=&quot;footer-img&quot;&gt; &lt;/div&gt;  &lt;div class=&quot;page-2&quot;&gt; &lt;img src=&quot;/resource/Styles/ImageDoc/image4.jpg&quot; width=&quot;100%&quot;&gt; &lt;/div&gt;  &lt;/body&gt;  &lt;/html&gt;</value>
    </values>
    <values>
        <field>IT_Object_Name__c</field>
        <value xsi:type="xsd:string">ER_Financial_Center__c</value>
    </values>
</CustomMetadata>