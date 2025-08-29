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
<cfparam name="URL.SystemFunctionId" default="">

<cfquery name="Header" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ModuleControlDetail
	WHERE  SystemFunctionId = '#URL.SystemFunctionId#'
	AND    FunctionSerialNo = #url.FunctionSerialNo#	
</cfquery>

<cfquery name="CheckForKey" 
   datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ModuleControlDetailField
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'		
	AND   FunctionSerialNo = '#URL.FunctionSerialNo#'
	AND   FieldIsKey = 1
</cfquery>

<cfoutput>
	
	<cfset s = FindNoCase(" FROM", Header.queryScript)>
	
	<cfif FindNoCase("WHERE", Header.queryScript)>	
	   <cfset e = FindNoCase("WHERE ", Header.queryScript)>
	<cfelse>
	   <cfset e = len(Header.queryScript)>
	</cfif>
	
	<!--- show tables that can be part of the delete key --->
		
	<cftry>
	
		<cfset fr = mid(Header.queryScript,  s+4,  e-(s+4))>
		<select name="QueryTable" id="QueryTable" class="regularxl" style="border:0px">
		
			<option value="">Not applicable</option>
		
			<cfif CheckforKey.recordcount eq "1">
					
				<cfloop index="itm" list="#fr#" delimiters=", ">
				<cfif len(itm) gte 5 and not Find("@",itm)>
					<option value="#itm#" <cfif Header.QueryTable eq itm>selected</cfif>>#itm#</option>
				</cfif>
				</cfloop>
		
			</cfif>
			
		</select>
	
	<cfcatch>error</cfcatch>
	
	</cftry>

</cfoutput>
