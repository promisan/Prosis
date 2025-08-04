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


<cfif url.op eq "True">
	  <cfset op = 1>
<cfelse>
      <cfset op = 0>	  
</cfif>


<cfif url.del eq "True">
	  <cfset del = 1>
<cfelse>
      <cfset del = 0>	  
</cfif>

<cftransaction action="BEGIN">

<cfif URL.ID1 eq "">

	<cfquery name="Insert" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO Ref_ReportControlUserGroup
	         (ControlId,
			 Account,
			 Delegation,
			 Operational,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	      VALUES ('#URL.ID#',
	      	  '#url.Group#',
			  '#del#',
			  '#Op#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
	</cfquery>
	
<cfelse>
	
	   <cfquery name="Update" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE Ref_ReportControlUserGroup
		  SET Operational = '#Op#', Delegation = '#del#'
		 WHERE ControlId = '#URL.ID#'
		 AND Account = '#URL.ID1#'
    	</cfquery>
	
</cfif>

</cftransaction>


<cfset url.id1 = "">

<cfinclude template="Group.cfm">  	
   
