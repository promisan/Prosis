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
<cfloop index="itm" list="#Form.FunctionNew#" delimiters=":">

    <cfquery name="Check" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM FunctionTitle
	 WHERE FunctionNo = '#itm#'
    </cfquery>
 
    <cfif check.recordCount eq "1">
		<cfquery name="FunctionNew" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE FunctionOrganization
		 SET    FunctionNo = '#itm#'
		 WHERE  FunctionId = '#Form.FunctionId#'
		</cfquery>
	</cfif>
  
</cfloop>

<cflocation url="FunctionViewLoop.cfm?IDFunction=#Form.FunctionId#" addtoken="No">
