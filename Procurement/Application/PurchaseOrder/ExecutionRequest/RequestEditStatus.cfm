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
<cfquery name="Get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    PurchaseExecutionRequest
		WHERE   RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Status"
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * FROM Ref_EntityStatus
	 WHERE  EntityCode = 'ProcExecution'
	 AND EntityStatus = '#Get.ActionStatus#'	
</cfquery>	
		
<cfset vtag = 0 >		

<cfif Get.ActionStatus eq "0">
  <cfset c = "6688aa">
<cfelseif Get.ActionStatus eq "9"> 
  <cfset c = "red"> 
  <cfoutput>
  <a href="javascript:showreasons('#url.id#')">
  </cfoutput>
  <cfset vtag = 1>
<cfelse>
  <cfset c = "black"> 
</cfif>

<cfoutput>
<font face="calibri" size="3" color="#c#">
#Status.StatusDescription# (#Status.EntityStatus#)</b>
</font>

</cfoutput>

<cfif vtag eq 1>
	</a>
</cfif>
