<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="Attributes.DataSource"            default="appsLedger">
<cfparam name="Attributes.Mission"               default="">
<cfparam name="Attributes.Journal"               default="">
<cfparam name="Attributes.JournalTransactionNo"  default="">
<cfparam name="Attributes.GLTransactionNo"       default="">
<cfparam name="Attributes.SalesCurrency"         default="#APPLICATION.BaseCurrency#">
<cfparam name="Attributes.GLAccountCredit"       default="">
<cfparam name="Attributes.GLAccountDebit"        default="">
<cfparam name="Attributes.TaxCode"               default="">
<cfparam name="Attributes.ReferenceId"           default="">
<cfparam name="Attributes.ItemNo"                default="">
<cfparam name="Attributes.TransactionDate"       default="">
<cfparam name="Attributes.TransactionQuantity"   default="">
<cfparam name="Attributes.TransactionValue"      default="">
<cfparam name="Attributes.TransactionType"       default="">
<cfparam name="Attributes.Period"                default="">
<cfparam name="Attributes.OfficerUserId"         default="">
<cfparam name="Attributes.OfficerFirstName"      default="">
<cfparam name="Attributes.OfficerLastName"       default="">

<cfset taxCOGS   = Attributes.TransactionValue*0.12>
<cfset totGL     = Attributes.TransactionValue+taxCOGS>
<cfset totCredit = Attributes.TransactionValue>

<cfquery name="Tax"
    datasource="#Attributes.DataSource#"
    username="#SESSION.login#"
    password="#SESSION.dbpw#">
    SELECT    *
    FROM      Accounting.dbo.Ref_Tax
    WHERE     TaxCode = '#attributes.TaxCode#'
</cfquery>

<cfif attributes.TransactionQuantity lte "0">

    <cfset tax = Tax.GLAccountReceived>
    <cfset acc2 = "#Attributes.GLAccountDebit#">
    <cfset acc1 = "#Attributes.GLAccountCredit#">
    <cfset act1 = "Credit">
    <cfset act2 = "Debit">
    <cfset ref1 = "IO IN">
    <cfset ref2 = "Stock">
	
<cfelse>

    <cfset tax = Tax.GLAccountPaid>
    <cfset acc1 = "#Attributes.GLAccountDebit#">
    <cfset acc2 = "#Attributes.GLAccountCredit#">
	<cfset act1 = "Debit">
    <cfset act2 = "Credit">   
    <cfset ref1 = "IO OUT">
    <cfset ref2 = "Stock">
	
</cfif>

<cfset costcenter = "0">

<cfquery name="Type"
    datasource = "#Attributes.DataSource#"
    username   = "#SESSION.login#"
    password   = "#SESSION.dbpw#">
     SELECT    *
     FROM      Materials.dbo.Ref_TransactionType
     WHERE     TransactionType = '#Attributes.TransactionType#'
</cfquery>

<cfquery name="Item"
        datasource="#Attributes.DataSource#"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Materials.dbo.Item
	    WHERE  ItemNo = '#Attributes.ItemNo#'
</cfquery>

<cf_GledgerEntryLine
        DataSource            = "#Attributes.DataSource#"
        Lines                 = "3"
        TransactionDate       = "#Attributes.TransactionDate#"
        Journal               = "#Attributes.Journal#"
        JournalNo             = "#Attributes.JournalTransactionNo#"
        JournalTransactionNo  = "#Attributes.JournalTransactionNo#"
        AccountPeriod         = "#Attributes.Period#"
        Currency              = "#Attributes.SalesCurrency#"
        LogTransaction		  = "Yes"

        TransactionSerialNo1  = "1"
        Class1                = "#act1#"
        Reference1            = "#ref1#"
        ReferenceName1        = "#left(Item.Itemdescription,100)#"
        Description1          = "#Type.Description#"
        GLAccount1            = "#acc1#"
        Costcenter1           = "#costcenter#"
        TransactionTaxCode1   = "#attributes.TaxCode#"
        WorkOrderLineId1      = ""
        ReferenceId1          = "#Attributes.ReferenceId#"
        ReferenceNo1          = "#Attributes.ItemNo#"
        TransactionType1      = "Standard"
        Amount1               = "#totGl#"

        TransactionSerialNo2  = "2"
        Class2                = "#act2#"
        Reference2            = "#ref2#"
        ReferenceName2        = "#left(Item.Itemdescription,100)#"
        Description2          = "#Type.Description#"
        GLAccount2            = "#acc2#"
        Costcenter2           = "#costcenter#"
        TransactionTaxCode2   = "#attributes.TaxCode#"
        WorkOrderLineId2      = ""
        ReferenceNo2          = "#Attributes.ItemNo#"
        ReferenceId2          = "#Attributes.ReferenceId#"
        TransactionType2      = "Standard"
        Amount2               = "#totCredit#"

        TransactionSerialNo3  = "3"
        Class3                = "#act2#"
        Reference3            = "Sales Tax"
        ReferenceName3        = "#left(Item.Itemdescription,100)#"
        Description3          = "#Type.Description#"
        GLAccount3            = "#tax#"
        Costcenter3           = "#costcenter#"
        TransactionTaxCode3   = "#attributes.TaxCode#"
        WorkOrderLineId3      = ""
        ReferenceNo3          = "#Attributes.ItemNo#"
        ReferenceId3          = "#Attributes.ReferenceId#"
        TransactionType3      = "Standard"
        Amount3               = "#taxCOGS#">


<cfquery name="qUpdate"
        datasource="#Attributes.DataSource#"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
    UPDATE Accounting.dbo.TransactionLine
        SET OfficerUserId = '#Attributes.OfficerUserId#',
        OfficerFirstName ='#Attributes.OfficerFirstName#',
        OfficerLastName ='#Attributes.OfficerLastName#'
    WHERE  Journal ='#Attributes.Journal#'
    AND JournalSerialNo = '#Attributes.JournalTransactionNo#'
</cfquery>

