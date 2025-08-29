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
<cfif url.scope eq "Edit">
	
	<!---
	<cfquery name="Action" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_Action
		WHERE ActionCode IN (SELECT OrderType 
		                     FROM   WorkOrder 
					         WHERE  WorkOrderId = '#url.actionid#')	
	</cfquery>
	--->

<cfelse>
	
	<cfquery name="Action" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_Action
		WHERE ActionCode = '#url.actioncode#'	
	</cfquery>

</cfif>

<cfset l = len(action.customform)>		
<cfset path = left(action.customform,l-4)>	

<cfparam name="url.actionid"   default="00000000-0000-0000-0000-000000000000">
			 
<cfoutput> 

<input type="hidden" 
       name="formsave" 
       value="#SESSION.root#/Staffing/Application/Employee/PersonAction/#path#Submit.cfm?actionid=#url.actionid#">
	   
</cfoutput>		   
	
<!---
<cftry>
--->

	<cfinclude template="#Action.customform#">
	<!---
	<cfcatch>
	<font color="FF0000">Problem, custom form not found</font>
	</cfcatch>
</cftry>	

--->
