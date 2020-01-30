<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<CFSET Criteria = ''>
<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">	
	
<cfparam name="Form.ReferenceName" default="zz">
<cfparam name="Form.Journal" default="zz">
<cfparam name="Form.Period" default="zz">
<cfparam name="Form.Status" default="zz">

<cfoutput>

<cfparam name="Form.Start" default="01/01/1900">
<cfset dateValue = "">
<CF_DateConvert Value="#Form.Start#">
<cfset dtes = #dateValue#>

<cfparam name="Form.End" default="01/01/2099">
<cfset dateValue = "">
<CF_DateConvert Value="#Form.End#">
<cfset dtee = #dateValue#+1>

<CFSET #Criteria# = #Criteria#&" AND (TransactionDate <= "&#dtee#&")"> 
<CFSET #Criteria# = #Criteria#&" AND (TransactionDate >= "&#dtes#&")"> 

<cfif #Form.ReferenceName# IS NOT 'zz'>
     <CFSET #Criteria# = #Criteria#&" AND P.ReferenceName IN ( #PreserveSingleQuotes(Form.ReferenceName)# )">
</cfif> 

<cfif #Form.Journal# IS NOT 'zz'>
     <CFSET #Criteria# = #Criteria#&" AND P.Journal IN ( #PreserveSingleQuotes(Form.Journal)# )">
</cfif> 

<cfif #Form.Period# IS NOT 'zz'>
     <CFSET #Criteria# = #Criteria#&" AND P.AccountPeriod IN ( #PreserveSingleQuotes(Form.Period)# )">
</cfif> 

<cfif #Form.Status# IS NOT 'zz'>
     <CFSET #Criteria# = #Criteria#&" AND #PreserveSingleQuotes(Form.Status)#">
</cfif>  

<cfset #CLIENT.Search# = #Criteria#>

#Criteria#

</cfoutput>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Payment">

<!--- Query returning search results --->
<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 SELECT P.*, B.BatchCategory, B.BatchTransactionDate, B.Printed as BatchPrinted, B.OfficerLastName as LastName, B.OfficerFirstName as FirstName
 	INTO UserQuery.dbo.#SESSION.acc#Payment
	FROM TransactionHeader P, Jour_bat B
    WHERE #PreserveSingleQuotes(Criteria)#
	AND P.Journal = B.Journal
	AND P.JournalBatchNo = B.JournalBatchNo
	
</cfquery>
	
<cfoutput>#criteria#</cfoutput>
	
<cflocation url="InquiryResult.cfm" addtoken="No">   

</BODY></HTML>