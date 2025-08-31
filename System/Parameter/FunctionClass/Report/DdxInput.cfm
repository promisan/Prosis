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
<cfquery name="QClass" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM Class
		order by ClassId
</cfquery>
<cfoutput>

<cfloop query="QClass">

	<cfset fname=#QClass.ClassName#>
	<cfset fname=replace(fname," ","_","ALL")>
	<cfset theClass=QClass.ClassId>
	<cfinclude template="MergeAttachments.cfm">
	
	<CFScript>
		StructInsert(input, "#fname#", "#SESSION.rootPath#\cfrstage\mergepdf\intro_#theClass#.pdf");
	</CFScript>
	
	
	
	
	
	
</cfloop>


<cfquery name="QfType" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT Class.ClassName, ClassFunction.ClassFunctionType
		FROM         ClassFunction INNER JOIN
	                 Class ON ClassFunction.ClassId = Class.ClassId
		ORDER BY Class.ClassName
</cfquery>



<cfloop query="QfType">
	<cfset fname=#Qftype.ClassName#>
	<cfset fname=replace(fname," ","_","ALL")>
	<CFScript>
		StructInsert(input, "#fname#_Details_#QfType.ClassFunctionType#", "pdfs/#fname#_Details_#QfType.ClassFunctionType#.pdf");
	</CFScript>
</cfloop>
		
		


</cfoutput>
