
<cfparam name="url.application" default="">
<cfparam name="url.requestid"   default="00000000-0000-0000-0000-000000000000">

<cfquery name="GetMission" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">

			SELECT DISTINCT Mission 
			FROM   Ref_MissionModule
			WHERE  SystemModule IN	( SELECT SystemModule
									  FROM   System.dbo.Ref_ApplicationModule
									  WHERE  Code = '#url.application#'
									)

</cfquery>

<cfquery name="GetRequest"
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
		 	SELECT *
			FROM   UserRequest
			WHERE  RequestId = '#url.requestid#'
		 
</cfquery>

<select name="Mission" id="Mission" class="regularxl" onChange="updateGroup(this.value,document.getElementById('Workgroup').value);">
    <option value="Global">Global</option>
	<cfoutput query="GetMission">
		<option value="#Mission#" <cfif GetRequest.Mission eq Mission>selected</cfif> >#Mission#</option>
	</cfoutput>
</select>

<cfset AjaxOnLoad("initGroup")>
