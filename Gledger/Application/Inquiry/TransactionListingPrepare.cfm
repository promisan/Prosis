<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset Criteria = "H.Mission = '#URL.Mission#'">
	
<cfoutput>

<cfparam name="form.DateStart" default="01/01/1900">
<cfset dateValue  = "">
<CF_DateConvert Value="#form.DateStart#">
<cfset dtes       = dateValue>

<cfparam name="url.DateEnd" default="01/01/2099">
<cfset dateValue  = "">
<CF_DateConvert Value="#form.DateEnd#">
<cfset dtee       = dateValue>

<CFSET Criteria = #Criteria#&" AND (P.TransactionDate <= "&#dtee#&")"> 
<CFSET Criteria = #Criteria#&" AND (P.TransactionDate >= "&#dtes#&")"> 

<cfparam name="form.PostStart" default="01/01/1900">
<cfset dateValue   = "">
<CF_DateConvert Value="#form.PostStart#">
<cfset dtes        = dateValue>

<cfparam name="form.PostEnd" default="01/01/2099">
<cfset dateValue = "">
<CF_DateConvert Value="#form.PostEnd#">
<cfset dtee = dateValue>
<cfset dtee = dtee+1>

<CFSET Criteria = #Criteria#&" AND (P.Created <= "&#dtee#&")"> 
<CFSET Criteria = #Criteria#&" AND (P.Created >= "&#dtes#&")"> 

<cfif form.AccountPeriod IS NOT "">
     <CFSET Criteria = #Criteria#&" AND H.AccountPeriod IN ( #PreserveSingleQuotes(form.AccountPeriod)# )">
</cfif> 

<cfif form.Parent IS NOT "">
     <CFSET Criteria = #Criteria#&" AND S.AccountParent IN ( #PreserveSingleQuotes(form.Parent)# )">
</cfif> 

<cfif form.Party eq "Vendor">
     <cfif Form.referenceorgunit neq "">
	     <CFSET Criteria = #Criteria#&" AND H.ReferenceOrgUnit  = '#Form.referenceorgunit#' ">
	 </cfif>
<cfelse>
	<cfif Form.referencePersonNo neq "">
	 <CFSET Criteria = #Criteria#&" AND H.ReferencePersonNo = '#Form.referencePersonNo#' ">	 
	</cfif> 
</cfif> 

<cfif form.OrgUnit IS NOT "">
     <CFSET Criteria = #Criteria#&" AND P.OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE MissionOrgUnitId IN (#PreserveSingleQuotes(form.OrgUnit)# ))">
</cfif> 

<!--- for 
Header Description
Line Memo
Header JournalTransactionNo
Header ReferenceNo
Header ReferenceName
JournalSerialNo (Header/Line
Line Reference
Line ReferanceName)
--->

<cfif form.Description IS NOT "">
     <CFSET Criteria = #Criteria#&" AND (H.Description LIKE '%#form.Description#%' and P.Memo LIKE '%#form.Description#%' OR H.ReferenceName LIKE '%#form.Description#%' OR H.ReferenceNo LIKE '%#form.Description#%' OR H.JournalSerialNo LIKE '%#form.Description#%' OR H.JournalTransactionNo LIKE '%#form.Description#%' OR P.Reference LIKE '%#form.Description#%' OR P.ReferenceName LIKE '%#form.Description#%')">
</cfif> 

<cfif form.Journal IS NOT "">
     <CFSET Criteria = #Criteria#&" AND P.Journal IN ( '#PreserveSingleQuotes(form.Journal)#' )">
</cfif> 

<cfif form.currency IS NOT "">
     <CFSET Criteria = #Criteria#&" AND H.Currency IN ( #PreserveSingleQuotes(form.Currency)# )">
</cfif> 

<cfif form.Amount neq "0" and form.amount neq "" and form.Amountto neq "0" and form.amountto neq "">
  <cfset Criteria = "#Criteria# AND ((P.AmountDebit #form.amountoperator# '#form.Amount#' and P.AmountDebit #form.amountoperatorto# '#form.Amountto#') or (P.AmountCredit #form.amountoperator# '#form.Amount#' and P.AmountCredit #form.amountoperatorto# '#form.Amountto#'))">
<cfelseif form.Amount neq "0" and form.amount neq "">
  <cfset Criteria = "#Criteria# AND (P.AmountDebit #form.amountoperator# '#form.Amount#' or P.AmountCredit #form.amountoperator# '#form.Amount#')">
<cfelseif form.Amountto neq "0" and form.amountto neq "">
  <cfset Criteria = "#Criteria# AND (P.AmountDebit #form.amountoperatorto# '#form.Amountto#' or P.AmountCredit #form.amountoperatorto# '#form.Amountto#')">
</cfif>

<cfset CLIENT.Search = Criteria>

</cfoutput>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Gledger">


<cftry>

<!--- Query returning search results --->

<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 SELECT  TOP 500 H.Mission,
         H.JournalTransactionNo as HeaderNo,
         P.*, 
		 (CAST(
					FLOOR(
						CAST(
							h.created
							AS FLOAT
							)
						)
						AS DATETIME
						)
						) AS Posted,
		 G.Description as GLAccountName, 
		 G.AccountGroup, 
		 S.Description as AccountGroupName, 
		 J.Description as JournalName
		
 	INTO  UserQuery.dbo.#SESSION.acc#Gledger
	FROM  TransactionHeader H, 
	      TransactionLine P, 
		  Ref_Account G, 
		  Ref_AccountGroup S, 
		  Journal J
	WHERE J.Journal = P.Journal
	AND   H.Journal = P.Journal
	AND   H.RecordStatus = '1'
	AND   H.JournalSerialNo = P.JournalSerialNo
	AND   P.GLAccount = G.GLAccount
	AND   S.AccountGroup = G.AccountGroup
    AND   #PreserveSingleQuotes(Criteria)# 	
</cfquery>

<cfset url.description=form.description>

<cfinclude template="TransactionListing.cfm">  


<cfcatch>
	<table width="100%"><tr><td valign="top" align="center"><font face="Calibri" size="3" color="FF0000"><b><cf_tl id="Please check your selection criteria"></td></tr></table>	
</cfcatch>

</cftry>
