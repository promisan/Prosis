
<cfquery name="language" datasource="AppsSystem">

	SELECT *
	FROM   Ref_SystemLanguage
	WHERE  Operational = '2'
	AND    SystemFunctionId
	
	
</cfquery>


<cfquery name="update" datasource="AppsSystem">
UPDATE Ref_ModuleControlContent
SET Text#Language.Code# = '#Evaluate("Form.Text#Language.Code#")#'
WHERE ContentId = '#Form.ContentId#' AND SystemFunctionId = '#Form.SystemFunctionId#'
</cfquery>