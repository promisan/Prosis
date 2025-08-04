<!--
    Copyright © 2025 Promisan

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


<cf_screentop height="100%" jQuery="yes" html="no" bannerheight="4" title="Data set declaration form" layout="webapp" banner="gray">

<cfif Form.VariableName is "">
	
	<cf_alert message = "You must enter a variable name. Operation not allowed."
	  return = "back">
    <cfabort>
		
</cfif>

<cfif Form.OutputName is "">
		
	<cf_alert message = "You must enter a output description. Operation not allowed."
	  return = "back">
    <cfabort>
		
</cfif>

<cfif FindNoCase(".", "#Form.VariableName#")>
		
	<cf_alert message = "You can not enter [.] as part of the variable name. Operation not allowed."
	  return = "back">
    <cfabort>
		
</cfif>


<cfif FindNoCase("/", "#Form.OutputName#") 
    or FindNoCase("\", "#Form.OutputName#") 
	or FindNoCase(".", "#Form.OutputName#")>
		
	<cf_alert message = "You can not enter [/] or [\] in the description. Operation not allowed."
	  return = "back">
    <cfabort>
		
</cfif>

<cfif not IsNumeric("#Form.ListingOrder#")>
		
	<cf_alert message = "You entered an invalid listing order. Operation not allowed."
	  return = "back">
	  <cfabort>
		
</cfif>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ReportControlOutput
WHERE ControlId   = '#URL.ID#' 
AND VariableName = '#Form.VariableName#'
AND Datasource = '#Form.DataSource#'
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
	   <cf_alert message = "You entered an existing datasource tablename. Operation not allowed."
		  return = "back">
		  <cfabort>
  
   <cfelse>
   
	   <cfquery name="Insert" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	   INSERT INTO Ref_ReportControlOutput
	         (ControlId,
			 Datasource, 
			 VariableName,
			 OutputClass,
			 OutputName,
			 OutputMemo,
			 FieldGrouping1,
			 FieldGrouping2,
			 FieldDetail,
			 FieldSummary,
			 ListingOrder,
			 DetailKey,
			 DetailTemplate,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	  VALUES ('#URL.Id#', 
	          '#Form.DataSource#',
			  '#Form.VariableName#',
			  '#Form.OutputClass#',
			  '#Form.OutputName#',
			  '#Form.OutputMemo#',
			  '#Form.FieldGrouping1#',
			  '#Form.FieldGrouping2#',
			  '#Form.FieldDetail#',
			  '#Form.FieldSummary#',
			  '#Form.ListingOrder#',
			  '#Form.DetailKey#',
			  '#Form.DetailTemplate#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())</cfquery>
		  
		  </cfif>
	         
</cfif>

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_ReportControlOutput
SET DataSource     = '#Form.DataSource#',
    VariableName   = '#Form.VariableName#',
	OutputClass    = '#Form.OutputClass#',
	OutputName     = '#Form.OutputName#',
	OutputMemo     = '#Form.OutputMemo#',
	FieldGrouping1 = '#Form.FieldGrouping1#',
	FieldGrouping2 = '#Form.FieldGrouping2#',
	FieldSummary   = '#Form.FieldSummary#',
	DetailKey      = '#Form.DetailKey#',
	DetailTemplate = '#Form.DetailTemplate#',
	ListingOrder   = '#Form.ListingOrder#',
	Created        = #now()#
WHERE OutputId = '#Form.OutputId#'
</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)>

	<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_ReportControlOutput
	WHERE OutputId = '#Form.OutputId#'
	</cfquery>

</cfif>	

<script language="JavaScript">
	 parent.parent.ProsisUI.closeWindow('myexcel',true)
	 parent.parent.outputrefresh()
</script>  

