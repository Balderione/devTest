<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUER01_UserBUText</fullName>
        <field>ER_BUText__c</field>
        <formula>TEXT( ER_Business_Unit__c)</formula>
        <name>FUER01_User_BUText</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WFER04_UserBU</fullName>
        <actions>
            <name>FUER01_UserBUText</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ER_Business_Unit__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates Business Unit Picklist, 
so as it can prefill BU picklist field (master picklist on all objects) on all objects, 
so as dependant picklists can contain BU specific picklist values using dependant picklists</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
