
<cf_screenTop height="100%" html="No" scroll="yes" jquery="Yes">

<cfajaximport tags="cfchart">

<cfquery name="get" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM   Program
	WHERE  ProgramCode = '#url.programcode#'			 
</cfquery>


<cfquery name="Param" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#get.Mission#'			 
</cfquery>


<table width="95%" border="0" align="center" class="formpadding clsPrintContentSummary">

	<tr><td>
		<cfset url.attach = "0">
		<cfinclude template="../Header/ViewHeader.cfm">
	</tr>	
	
	<tr><td>
		<cfdiv id="graphcontent" bind="url:#param.ProgressTemplate#?programcode=#url.programcode#&period=#url.period#">
		</td>
	</tr>
			
</table>	   