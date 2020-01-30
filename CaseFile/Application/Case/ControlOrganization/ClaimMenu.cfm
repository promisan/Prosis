

 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">

	<cfquery name="GetMission" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 	SELECT *
			FROM   Ref_Mission
			WHERE  Mission = '#URL.Mission#'
		 
</cfquery>
	
<cf_ViewTopMenu background="yellow" label="#lt_content# #GetMission.MissionName#">

