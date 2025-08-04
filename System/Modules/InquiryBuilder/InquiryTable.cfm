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

<cfparam name="URL.SystemFunctionId" default="">
<cfparam name="URL.ser"              default="1">
<cfparam name="URL.Datasource"       default="">
<cfparam name="URL.Script"           default="0">
<cfparam name="URL.ID2"              default="">

<cfset s = Find("FROM", url.script)>

<cfif Find("WHERE", url.script)>
   <cfset e = FindNoCase("WHERE", url.script)>
<cfelse>
   <cfset e = len(url.script)>
</cfif>

<cfoutput>#s#</cfoutput>
<cfoutput>#e#</cfoutput>

<cftry>

	<cfset fr = mid(url.script,  s+4,  e-(s+4)>

	<cfoutput>#fr#</cfoutput>

<cfcatch>---</cfcatch>

</cftry>

<!---

<cftry>

    <cfset sc = replace(sc, "SELECT",  "SELECT TOP 1")> 

	<cfquery name="SelectQuery" 
	datasource="#URL.Datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   #preservesinglequotes(sc)#
	</cfquery>

	<cfcatch><cfabort>
	</cfcatch>

</cftry>

<cfquery name="Header" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ModuleControlDetail
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'
	AND  FunctionSerialNo = #url.ser#	
</cfquery>

	 <select name="DrillFieldKey" style="width:200px">
		<cfoutput>						 
			 <cfloop index="col" list="#SelectQuery.columnList#" delimiters=",">
			  	  <option value="#col#" <cfif col eq header.drillfieldkey>selected</cfif>>#col#</option> 
			  </cfloop>
		</cfoutput>									
	 </select>
	
	--->