<cf_screentop jquery="yes" html="no">


 <cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.idmenu#"				
		Label           = "Yes">			
		
<table width="100%" height="100%">

	
	<cfoutput>
		<tr><td style="padding:5px" class="labellarge">#url.mission# <font color="FF0000"><cf_tl id="Not yet scheduled actions"></td></tr>
	</cfoutput>
	
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

   <td colspan="1" style="padding:5px" height="100%" valign="top">
  
		<cfdiv id="divListingContainer" style="height:100%" 
		    bind="url:#session.root#/Workorder/Application/Medical/ServiceDetails/WorkPlan/ScheduleAction/ActionListingContent.cfm?mission=#url.mission#&SystemFunctionId=#url.systemfunctionid#">        	
	</td>	
	
   </tr>

</table>		
		