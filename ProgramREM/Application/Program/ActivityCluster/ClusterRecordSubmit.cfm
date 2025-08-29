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
<cfparam name="url.action" default="">
 
<cfif URL.Action eq "delete">
		 		 	 
		<cfquery name="Delete" 
		     datasource="AppsProgram" 
    		 username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
    		 DELETE FROM ProgramActivityCluster
			  WHERE  ActivityClusterId   = '#URL.ID2#' 
		</cfquery>		
			
		<cfset URL.id2 = "new">	 
	 
<cfelseif URL.desc eq "">

	<cf_tl id="Please enter a description" var="1" class="message">
	<cfset msg1="#lt_text#">	
	<cfoutput>
		<tr><td colspan="4">#msg1#</td></tr>
	</cfoutput>
		
<cfelse>	
			 	
	 <cfif URL.ID2 eq "new">
		  	  	  		      		
			<cfquery name="Insert" 
				datasource="appsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO  ProgramActivityCluster
						      (ProgramCode, 
							   ClusterDescription,
							   ListingOrder,
							   OfficerUserId,
							   OfficerLastName,
							   OfficerFirstName)
				  VALUES ('#URL.ProgramCode#',
				          '#URL.desc#',
						  '#URL.Orde#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
			 </cfquery>	
					 
															 
	 <cfelse>
		 		 
	 	<cfquery name="Update" 
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE ProgramActivityCluster
			SET    ClusterDescription  = '#URL.Desc#',
				   ListingOrder        = '#URL.Orde#'
			WHERE  ActivityClusterId   = '#URL.ID2#' 
		 </cfquery>	
		 
		 <cfset URL.id2 = "new">
		 
		 </cfif>
		 	 	
</cfif>

<cfinclude template="ClusterRecord.cfm">  


