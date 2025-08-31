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

<cfif url.detected eq url.account>

<img src="#session.root#/images/checkmark.png" alt="" border="0" height="24">

<cfelse>

	<cfquery name="Check" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM   UserNames
			WHERE  Account = '#url.account#' 			
	</cfquery>
		
	<cfif check.recordcount eq "0" and len(url.account) gte 5>
	
		<img src="#session.root#/images/checkmark.png" alt="" border="0" height="24">
		
	<cfelse>
	
		<img src="#session.root#/images/stop.png" alt="" border="0" height="24">
		
	</cfif>
		
</cfif>

</cfoutput>		 