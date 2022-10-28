<cf_textareascript>
<cfajaximport tags="cfform,cfdiv">

<cfquery name="GetFunction" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT	*
	FROM	Ref_ModuleControl
	WHERE	SystemFunctionId = '#URL.ID#'
</cfquery>

<cfquery name="GetRole" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_AuthorizationRole  
	WHERE  Role = '#URL.Role#'
</cfquery>

<!---
<cf_screentop label="Grant Function/Role to Mission" option="[#GetFunction.SystemModule#  [#GetRole.Role# - #GetRole.Description#]" jquery="yes" height="100%" banner="yellow" scroll="Yes" layout="webapp" user="no">
--->

<cf_securediv id="irolen" bind="url:RecordMissionListingDetail.cfm?functionId=#URL.ID#&role=#url.Role#&allType=#url.allType#">