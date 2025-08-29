<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	