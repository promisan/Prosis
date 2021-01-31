
<cf_tl id="Advanced Inquiry #Url.mission# #url.period#" var="tInquiry">

<cf_screentop height="100%" scroll="no" layout="webapp" label="#tInquiry#" jquery="Yes" html="Yes" MenuAccess="Yes" SystemFunctionId="#url.systemfunctionid#">

<cf_listingscript mode="Regular">
<cf_dialogstaffing> 
	
<cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.systemfunctionid#"				
		Label           = "Yes">		
		
<table width="100%" height="100%">
	
	<!--- control list data content --->
	
	<cfquery name="Param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#url.Mission#'	
	</cfquery>

   <tr>

   <td colspan="1" height="100%" valign="top" style="padding:0px">
		<cf_securediv id="divListingContainer" style="height:100%" bind="url:#session.root#/Procurement/Application/Funding/Listing/ExecutionViewContent.cfm?SystemFunctionId=#url.systemfunctionid#&mission=#url.mission#&planningperiod=#url.planningperiod#&period=#url.period#">        	
	</td>	
	
   </tr>

</table>		
		