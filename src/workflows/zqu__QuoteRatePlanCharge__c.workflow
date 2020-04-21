<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUIT00_Cod_Cli_Dett_Default</fullName>
        <field>IT_Cod_Cli_Dett__c</field>
        <formula>zqu__QuoteRatePlan__r.zqu__Quote__r.IT_Cod_Cli_Padre__c</formula>
        <name>Cod_Cli_Dett_Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WFIT00_QuoteRatePlanCharge_Set_Cod_Cli_Dett</fullName>
        <actions>
            <name>FUIT00_Cod_Cli_Dett_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>zqu__QuoteRatePlanCharge__c.IT_Cod_Cli_Dett__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
