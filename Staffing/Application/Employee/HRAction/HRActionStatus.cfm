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
<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       PersonAction
	    WHERE PersonActionId = '#url.id#'
	</cfquery>	

<cfif check.actionStatus eq "9">

	<cf_tl id="Cancelled">
	
<cfelse>
   
    <cfif check.actionstatus eq "1">
	   <cf_tl id="Cleared">
	<cfelse>
	   <font color="FF0000"><cf_tl id="Pending">
   </cfif>
   
</cfif>		