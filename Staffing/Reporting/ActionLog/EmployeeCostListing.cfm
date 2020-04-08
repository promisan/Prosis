<cfparam name="url.header" default="0">

<cfif url.header eq "0">
	<cf_screentop jquery="yes" html="no" label="Personnel Cost Inquiry">
<cfelse>
	<cf_screentop jquery="yes" html="yes" layout="webapp" label="Personnel Cost Inquiry">
</cfif>	

<cf_listingscript mode="Regular">
<cf_dialogstaffing>

 <cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.idmenu#"				
		Label           = "Yes">		

<!--- moved to 2nd page for refresh
<cf_wfpending entityCode="PersonEvent"  
      table="#SESSION.acc#wfEvent" mailfields="No" IncludeCompleted="No">					
	  --->
			
<cfparam name="lt_content" default="Personnel Costs">

<table width="100%" height="100%">
	
	<!--- control list data content --->
	
	<cfquery name="Param" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#url.Mission#'	
	</cfquery>

   <tr>

   <td colspan="1" height="100%" valign="top" style="padding:10px">
		<cfdiv id="divListingContainer" style="height:100%" bind="url:#session.root#/Staffing/Reporting/ActionLog/EmployeeCostListingContent.cfm?mission=#url.mission#&SystemFunctionId=#url.systemfunctionid#">        	
	</td>	
	
   </tr>

</table>		
		