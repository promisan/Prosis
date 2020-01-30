
<cfif Len(Form.Memo) gt 100>
  <cfset remarks = left(Form.Memo,100)>
<cfelse>
  <cfset remarks = Form.Memo>
</cfif> 

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = #dateValue#>

<!---
<cfset dateValue = "">

<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	
--->

<!--- verify if record exist --->

<cfquery name="Threshold" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT A.*
	FROM   OrganizationThreshold A
	WHERE  ThresholdId  = '#Form.ThresholdId#'
</cfquery>

<cfif Threshold.recordCount eq 1> 
	
	 <cfquery name="InsertContract" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   UPDATE OrganizationThreshold 
	   SET   DateEffective       = #STR#,	    	
			 Currency            = '#Form.Currency#', 
			 AmountThreshold     = '#Form.AmountThreshold#',			
			 Memo                = '#Remarks#'
	   WHERE ThresholdId  = '#Form.ThresholdId#'	 
	   </cfquery>
  
</cfif>	

<cfset url.id = Form.OrgUnit>	  
<cfinclude template="ThresholdListing.cfm">	  

	

