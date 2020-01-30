<!--- Create Criteria string for query from data entered thru search form --->

<link href="../../pkdb.css" rel="stylesheet" type="text/css">

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
	
<cfparam name="Form.WorkCategory" default="">
<cfparam name="Form.LocationCode" default="">
<cfparam name="Form.Contractor"   default="">
<cfparam name="Form.Status"       default="">

<cfoutput>

<cfparam name="Form.Start" default="01/01/1900">
<cfset dateValue = "">
<CF_DateConvert Value="#Form.Start#">
<cfset dtes = #dateValue#>

<cfparam name="Form.End" default="01/01/2099">
<cfset dateValue = "">
<CF_DateConvert Value="#Form.End#">
<cfset dtee = #dateValue#>

<CFSET #Criteria# = #Criteria#&" AND (P.WorkOrderDate <= "&#dtee#&")"> 
<CFSET #Criteria# = #Criteria#&" AND (P.WorkOrderDate >= "&#dtes#&")"> 

<cfif #Form.WorkCategory# IS NOT 'zz'>
     <CFSET #Criteria# = #Criteria#&" AND P.WorkCategory IN ( #PreserveSingleQuotes(Form.WorkCategory)# )">
</cfif> 

<cfif #Form.LocationCode# IS NOT 'zz'>
     <CFSET #Criteria# = #Criteria#&" AND P.LocationCode IN ( #PreserveSingleQuotes(Form.LocationCode)# )">
</cfif> 

<cfif #Form.Contractor# IS NOT 'zz'>
     <CFSET #Criteria# = #Criteria#&" AND P.Contractor IN ( #PreserveSingleQuotes(Form.Contractor)# )">
</cfif> 

<cfif #Form.Status# IS NOT 'zz'>
     <CFSET #Criteria# = #Criteria#&" AND P.Status IN ( #PreserveSingleQuotes(Form.Status)# )">
</cfif>  

<cfset #CLIENT.Search# = #Criteria#>

</cfoutput>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Workorder">
<CF_DropTable dbName="AppsWorkorder" tblName="#SESSION.acc#Temp">

<!--- Query returning search results --->
<cfquery name="SearchResult"
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT WorkorderNo, SUM(CostTotal) as Amount
	INTO #SESSION.acc#Temp
	FROM  WorkCost
	GROUP BY WorkorderNo
	ORDER BY WorkorderNo
</cfquery>

<cfif Form.Crit2_Value is "-1">
 <cfset link = "P.WorkOrderNo *= C.WorkorderNo">
<cfelse>
 <cfset link = "P.WorkOrderNo = C.WorkorderNo">
</cfif>

<!--- Query returning search results --->
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 SELECT DISTINCT P.WorkOrderNo, P.Contractor, P.ContractorName, P.AssetNo, 
 P.WorkCategory, P.WorkBriefs, P.WorkOrderDate, P.WorkOrderDueDate, 
 P.WorkOrderFinished, P.Status, P.OfficerLastName, P.OfficerFirstName, 
 P.InspectorLastName, P.InspectorFirstName, P.InspectionDate, 
 P.InspectionRemarks, P.WorkOrderClass, P.LocationCode, 
 P.LocationDescription, C.Amount
 	INTO UserQuery.dbo.#SESSION.acc#Workorder
	FROM WorkOrd P, #SESSION.acc#temp C
    WHERE #link#
	AND #PreserveSingleQuotes(Criteria)#
</cfquery>
	
<CF_DropTable dbName="AppsWorkOrder" tblName="#SESSION.acc#temp">	
<cflocation url="InquiryResult.cfm" addtoken="No">

</BODY></HTML>