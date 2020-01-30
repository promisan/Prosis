
<TITLE>Submit Funding</TITLE>

<cftransaction action="BEGIN">
 

<cfloop index="Rec" from="1" to="#CLIENT.RecordNo#">

  <cfparam name="FORM.selected_#Rec#" default="0">
  <cfset actionid   = Evaluate("FORM.actionid_" & #Rec#)>
  <cfset org        = Evaluate("FORM.organizationcode_" & #Rec#)>
  <cfset selected   = Evaluate("FORM.selection_" & #Rec#)>
  
  <cfquery name="ResetFunction" 
datasource="AppsSelection" 
username="#SESSION.login#" 
    password="#SESSION.dbpw#">
DELETE From FunctionOrganization
WHERE FunctionNo         = '#Form.FunctionNo#'
  AND SubmissionEdition  = '#actionId#'
</cfquery>

<cfif selected eq "1">

<cfquery name="Insert" 
datasource="AppsSelection" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
INSERT INTO FunctionOrganization 
         (SubmissionEdition, FunctionNo, OrganizationCode)
  VALUES ('#actionId#','#Form.FunctionNo#', '#org#')
</cfquery>		
</cfif>

</cfloop>

</cftransaction>
  	
<cflocation url="FunctionRoster.cfm?Id=#URLEncodedFormat(Form.FunctionNo)#" addtoken="No">		

	

