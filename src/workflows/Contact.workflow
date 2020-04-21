<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUIT18_Set_Code_Contact</fullName>
        <field>IT_Code__c</field>
        <formula>IT_Autonumber_Code__c</formula>
        <name>FUIT18_Set_Code_Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WFIT20_Set_Code_Contact</fullName>
        <actions>
            <name>FUIT18_Set_Code_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Profile.Name != &apos;IT System Integration&apos;,  NOT(ISPICKVAL(IT_Type__c, &apos;Soc&apos;)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
