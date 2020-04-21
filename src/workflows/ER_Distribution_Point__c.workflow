<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FUIT20_Set_Code_Distribution_Point</fullName>
        <field>IT_SF_Activity__c</field>
        <formula>IT_Autonumber_Code__c</formula>
        <name>FUIT20_Set_Code_Distribution_Point</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUIT36_Suspension_Update</fullName>
        <field>IT_Suspension__c</field>
        <literalValue>1</literalValue>
        <name>FUIT36_Suspension_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUIT37_Reactivation_Update</fullName>
        <field>IT_Suspension__c</field>
        <literalValue>0</literalValue>
        <name>FUIT37_Reactivation_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FUIT38_Suspension_Reason</fullName>
        <field>IT_Suspension_Reason__c</field>
        <literalValue>002</literalValue>
        <name>FUIT38_Suspension_Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WFIT22_Set_Code_Distribution_Point</fullName>
        <actions>
            <name>FUIT20_Set_Code_Distribution_Point</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>$Profile.Name != &apos;IT System Integration&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WFIT38_Suspension_Activity</fullName>
        <active>false</active>
        <formula>AND(NOT(ISBLANK(IT_Suspension_Start_Date__c)) ,
IT_Suspension_Start_Date__c&gt;TODAY(),
IT_Suspension__c = false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FUIT36_Suspension_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>ER_Distribution_Point__c.IT_Suspension_Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WFIT39_Reactivation_Activity</fullName>
        <active>false</active>
        <formula>AND( NOT(ISBLANK(IT_Suspension_End_Date__c)),
IT_Suspension_End_Date__c&gt;TODAY(),
IT_Suspension__c = true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FUIT37_Reactivation_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>ER_Distribution_Point__c.IT_Suspension_End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WFIT40_Suspension_Activity_Today</fullName>
        <actions>
            <name>FUIT36_Suspension_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FUIT38_Suspension_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( 
				IT_Suspension_Start_Date__c&lt;=TODAY(),
				IT_Suspension__c = false,
				OR(
								ISBLANK(PRIORVALUE(IT_Suspension_Start_Date__c)),
								AND(
												ISCHANGED(IT_Suspension_Start_Date__c),
												NOT(ISBLANK(IT_Suspension_End_Date__c))
								)
				)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFIT41_Reactivation_Activity_Today</fullName>
        <actions>
            <name>FUIT37_Reactivation_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(
IT_Suspension_End_Date__c&lt;=TODAY(),
IT_Suspension__c = true,
OR(
ISBLANK(PRIORVALUE(IT_Suspension_End_Date__c)),
AND(
ISCHANGED(IT_Suspension_End_Date__c),
NOT(ISBLANK(IT_Suspension_Start_Date__c))
)
)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WFIT42_Suspension_Reason</fullName>
        <actions>
            <name>FUIT38_Suspension_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>NOT( ISNULL( IT_Suspension_Start_Date__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>