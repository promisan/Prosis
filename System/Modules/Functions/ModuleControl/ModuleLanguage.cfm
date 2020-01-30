

<cfoutput>

<cfsavecontent variable="combination">

	SELECT     M.SystemFunctionId, L.Code, M.FunctionName, M.FunctionMemo	
	FROM       Ref_ModuleControl M CROSS JOIN
	           Ref_SystemLanguage L

</cfsavecontent>

</cfoutput>

<cfquery name="Insert" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO Ref_ModuleControl_Language
	(SystemFunctionId, LanguageCode, FunctionName, FunctionMemo)
	SELECT   I.SystemFunctionId, I.Code, I.FunctionName, I.FunctionMemo
	FROM     (#preserveSingleQuotes(combination)#) as I LEFT OUTER JOIN Ref_ModuleControl_Language M 
	   ON    I.SystemFunctionId = M.SystemFunctionId
	  AND    I.Code = M.LanguageCode
	GROUP BY I.SystemFunctionId, I.Code, I.FunctionName, I.FunctionMemo, M.LanguageCode
	HAVING   M.LanguageCode is NULL 
</cfquery>		     
	