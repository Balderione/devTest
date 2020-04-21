<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ER_Opportunity_Reject_Approval_Alert</fullName>
        <description>Opportunity Reject Approval Alert</description>
        <protected>false</protected>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote_Approval_Templates/Quote_Rejected</template>
    </alerts>
    <alerts>
        <fullName>ER_Opportunity_Success_Approval_Alert</fullName>
        <description>Opportunity Success Approval Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote_Approval_Templates/Quote_Approved</template>
    </alerts>
    <fieldUpdates>
        <fullName>ER_Opportunity_Approval_Success</fullName>
        <field>ER_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Opportunity Approval Success</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUER03_Opp_Name_Date_Company_Solution</fullName>
        <description>Opportunity Name equals Creation Date &amp; Company Name &amp; Solution</description>
        <field>Name</field>
        <formula>TEXT(Today()) &amp; &quot;-&quot; &amp;  Account.Name &amp; &quot;-&quot; &amp;  Text(ER_Product_Family__c)</formula>
        <name>Date_Company_Solution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUER04_Opp_RT_Affiliate</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ER_Merchant_Opportunity</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FUER04_Opp_RT_Affiliate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUER05_Opp_RT_Client</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ER_Client_Opportunity_RT</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>FUER05_Opp_RT_Client</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUER09_Account_Status_Client</fullName>
        <field>ER_Status__c</field>
        <literalValue>Active</literalValue>
        <name>FUER09_Account_Status_Client</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUER10_Account_Status_Merchant</fullName>
        <field>ER_Status__c</field>
        <literalValue>Active</literalValue>
        <name>FUER10_Account_Status_Merchant</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>WFER02_Opp_Name_Lead_Conversion</fullName>
        <actions>
            <name>FUER03_Opp_Name_Date_Company_Solution</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Opportunity name consists of Date - Company Name - Solution family interests</description>
        <formula>IF          (          CONTAINS(Name,&apos;-&apos;),true,false          )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WFER03_Opp_RT_Merchant</fullName>
        <actions>
            <name>FUER04_Opp_RT_Affiliate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.ER_Lead_Source_Type__c</field>
            <operation>equals</operation>
            <value>Merchant</value>
        </criteriaItems>
        <description>This workflow will set automatically the Opportunity&apos;s record type to Merchant, when a Lead is converted</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WFER04_Opp_RT_Client</fullName>
        <actions>
            <name>FUER05_Opp_RT_Client</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.ER_Lead_Source_Type__c</field>
            <operation>equals</operation>
            <value>Client</value>
        </criteriaItems>
        <description>This workflow will set automatically the Opportunity&apos;s record type to Client, when a Lead is converted</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>