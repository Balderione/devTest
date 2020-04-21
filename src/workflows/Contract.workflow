<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUIT28_No_Reason</fullName>
        <field>IT_No_Cost_Reason__c</field>
        <name>FUIT28_No_Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUIT29_Transport</fullName>
        <field>IT_Transport_Cost__c</field>
        <name>FUIT29_Transport</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WFIT28_Contract_Cost</fullName>
        <actions>
            <name>FUIT28_No_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISPICKVAL (IT_Transport_Cost__c, &quot;&quot;)),
NOT(ISNEW()) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFIT29_Contract_Transport</fullName>
        <actions>
            <name>FUIT29_Transport</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISPICKVAL ( IT_No_Cost_Reason__c , &quot;&quot;) ),
NOT(ISNEW()) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
