<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUIT15_Benefit_Default_End_Date</fullName>
        <field>IT_Benefit_End_Date__c</field>
        <formula>IF( ISPICKVAL( IT_Macro_Benefit__c , &#39;Reimbursement&#39;) ,IT_Plan__r.IT_Plan_End_Date__c - 7 , IT_Plan__r.IT_Plan_End_Date__c)</formula>
        <name>FUIT15_Benefit_Default_End_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUIT15_Benefit_Default_Start_Date</fullName>
        <field>IT_Benefit_Start_Date__c</field>
        <formula>IT_Plan__r.IT_Plan_Start_Date__c</formula>
        <name>FUIT15_Benefit_Default_Start_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>WFIT11_Benefit_Default_Date</fullName>
        <actions>
            <name>FUIT15_Benefit_Default_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FUIT15_Benefit_Default_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(Name)),     
				ISBLANK(IT_Benefit_Start_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
