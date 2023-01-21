
<cfparam name="url.personno" default="">

 <cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.systemfunctionid#"				
		Label           = "Yes">		
	
<cfquery name="Param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission WITH (NOLOCK)
	WHERE  Mission = '#url.Mission#'	
</cfquery>


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
	
	<cfoutput>
		<tr><td style="padding:5px;font-size:20px" class="labellarge">#url.mission# <cf_tl id="Agenda"></td></tr>
	</cfoutput>

   <tr>

   <td colspan="1" height="100%" valign="top" style="padding:5px">
		<cf_securediv id="divListingContainer" style="height:100%"
		  bind="url:#session.root#/Workorder/Application/Medical/ServiceDetails/WorkPlan/Action/ActionListingContent.cfm?mission=#url.mission#&SystemFunctionId=#url.systemfunctionid#&personno=#url.personno#">        	
	</td>	
	
   </tr>

</table>		
		