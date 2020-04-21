<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUIT19_Set_Code_Delivery_Site</fullName>
        <field>IT_Delivery_SF__c</field>
        <formula>TEXT(VALUE(IT_Autonumber_Code__c))</formula>
        <name>FUIT19_Set_Code_Delivery_Site</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WFIT21_Set_Code_Delivery_Site</fullName>
        <actions>
            <name>FUIT19_Set_Code_Delivery_Site</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>$Profile.Name != &apos;IT System Integration&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
