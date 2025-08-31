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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.FieldName" default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE  Ref_EntityActionParent
		  SET     Operational  = '#Form.Operational#',
 		          Description  = '#Form.Description#',
			      ListingOrder = '#Form.ListingOrder#'
		  WHERE   Code = '#URL.ID2#'
		    AND   EntityCode = '#URL.EntityCode#'
			AND   Owner = '#Form.Owner#'
	    	</cfquery>
			
	<script>
	 <cfoutput>
		 window.location = "ActionParent.cfm?EntityCode=#URL.EntityCode#"
	 </cfoutput> 
	</script>			

<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_EntityActionParent
		WHERE EntityCode = '#URL.EntityCode#' 
		AND Code = '#Form.Code#'
		AND   Owner = '#Form.Owner#'
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityActionParent
			         (EntityCode,
					 Code,
					 Owner,
					 Description,
					 ListingOrder,
					 Operational,
					 Created)
			      VALUES ('#URL.EntityCode#',
				      '#Form.Code#',
					  '#Form.Owner#',
					  '#Form.Description#',
					  '#Form.ListingOrder#',
				      '#Form.Operational#',
					  getDate())
			</cfquery>
	</cfif>	
		
	<cfoutput>
	 	<script>
		 window.location = "ActionParent.cfm?EntityCode=#URL.EntityCode#&id2=new"
		</script>	
	</cfoutput> 
	   	
</cfif>
 	

  
