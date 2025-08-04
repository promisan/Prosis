<!--
    Copyright © 2025 Promisan

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

<!--- 
1.	restore template content from prior
2.	disabled entry using action status = 9
3.	reload dialog screen
--->

<cfquery name="Find" 
datasource="AppsControl">
	SELECT *
	FROM   Ref_TemplateContent	
	WHERE TemplateId = '#URL.ID#'
</cfquery>	

<cfquery name="Prior" 
	datasource="AppsControl">
	<!--- right --->
	SELECT TOP 1 *
	FROM     Ref_TemplateContent	
	WHERE    FileName   = '#find.Filename#'
	AND      PathName   = '#find.PathName#'
	AND      ApplicationServer = '#find.ApplicationServer#'
	AND      TemplateStatus = '1'
	AND      VersionDate < '#dateformat(Find.VersionDate, client.dateSQL)#'
	ORDER BY TemplateModified DESC
</cfquery>	

<cfquery name="Deactivate" 
		datasource="AppsControl">
		UPDATE Ref_TemplateContent	
		SET    TemplateStatus = '9'
		WHERE  TemplateId = '#URL.ID#'
</cfquery>

<cfif find.PathName neq "[root]">
	 <cfset path = find.pathName>
<cfelse>
	 <cfset path = "">
</cfif>

<cffile action="WRITE" 
    file="#SESSION.rootPath#\#path#\#find.Filename#" 
	output="#Prior.TemplateContent#" 
	addnewline="Yes" 
	fixnewline="No">
	
<font color="FF0000">Restored</font>	



