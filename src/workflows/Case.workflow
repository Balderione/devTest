<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IT_Compliments_Easy</fullName>
        <description>IT_Compliments Easy</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IT_Compliments/IT_Compliments_Easy</template>
    </alerts>
    <alerts>
        <fullName>IT_Compliments_Selection</fullName>
        <description>IT Compliments Selection</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IT_Compliments/IT_Compliments_Selection</template>
    </alerts>
    <alerts>
        <fullName>IT_Compliments_Spesa</fullName>
        <description>IT Compliments Spesa</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IT_Compliments/IT_Compliments_Spesa</template>
    </alerts>
    <alerts>
        <fullName>IT_Compliments_Top_Premium</fullName>
        <description>IT Compliments Top Premium</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IT_Compliments/IT_Compliments_Top_Premium</template>
    </alerts>
</Workflow>
