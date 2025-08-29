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
<!--- 


set position field 
store the value in the log fiels

--->

<cfif url.field eq "disableloan">

	<!--- init the position log or pass the serialno --->		  
	<cf_setPositionLog PositionNo="#url.PositionNo#" mode="prepare">
	
	<cfquery name="setPosition" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 UPDATE Position			 
			 SET    disableLoan =  <cfif url.value eq "true">0<cfelse>1</cfif>
			 WHERE  PositionNo = '#URL.PositionNo#'	 
	</cfquery>
		
	<!--- init the position log or pass the serialno --->		  
	<cf_setPositionLog PositionNo="#url.PositionNo#" mode="log" serialno="#serialno#">
		
		
</cfif>	