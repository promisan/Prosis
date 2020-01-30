
<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM Ref_ReportControl L
	WHERE ControlId = '#URL.ajaxid#'
</cfquery>

<cfquery name="Group" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_SystemModule
	WHERE SystemModule  = '#Line.SystemModule#'
</cfquery>

<cfset link = "System/Modules/Reports/RecordEdit.cfm?id=#URL.ajaxid#">
						
<cf_ActionListing 
		EntityCode       = "SysReport"
		EntityClass      = "#Line.SystemModule#"
		EntityGroup      = "#Group.RoleOwner#"
		EntityStatus     = ""
		OrgUnit          = ""
		TableWidth       = "98%"
		AjaxId           = "#URL.AjaxId#" 
		ObjectReference  = "Report: #Line.FunctionName#"
		ObjectReference2 = "#Group.Description#"
		ObjectKey4       = "#line.controlid#"
		ObjectURL        = "#link#"
		Show             = "Yes"
		CompleteFirst    = "Yes">
		
<cf_compression>