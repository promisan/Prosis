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

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.FieldName" default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE  Ref_EntityUsage
		  SET     Operational = '#Form.Operational#',
 		          ObjectUsageName = '#Form.ObjectUsageName#',
				  <cfif form.owner eq "">
				      Owner = NULL
				  <cfelse>
				      Owner = '#form.Owner#'				  
				  </cfif>
		  WHERE   ObjectUsage = '#URL.ID2#'
			 AND  EntityCode = '#URL.EntityCode#'
   	</cfquery>
			
	<cfset url.id2 = "new">
    <cfinclude template="ActionUsage.cfm">		
		

<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_EntityUsage
		WHERE EntityCode = '#URL.EntityCode#' 
		AND ObjectUsage = '#Form.ObjectUsage#'
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityUsage
			         (EntityCode,
					 ObjectUsage,
					  <cfif Form.Owner neq "">
						 Owner,
					  </cfif>
					 ObjectUsageName,
					 Operational)
			     VALUES ('#URL.EntityCode#',
				         '#Form.ObjectUsage#',
					     <cfif Form.Owner neq "">
						 '#Form.Owner#',
					     </cfif>
					     '#Form.ObjectUsageName#',
				         '#Form.Operational#')
			</cfquery>
	</cfif>	
	
	<cfset url.id2 = "new">
    <cfinclude template="ActionUsage.cfm">		
	   	
</cfif>
 	

  
