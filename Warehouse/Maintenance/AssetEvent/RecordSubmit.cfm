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
<cf_tl id = "This code has been registered already!" var = "vAlready"> 
<cfset Form.ListingOrder = replace(Form.ListingOrder,",","","ALL")>

<cfif url.id1 eq ""> 

	<cfquery name="Verify" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_AssetEvent
			WHERE 	Code  = '#Form.Code#' 
	</cfquery>
	
	   <cfif Verify.recordCount gt 0>
	   
 			<cfoutput>
		    	<script language="JavaScript">
		    		alert("#vAlready#");
					parent.window.close();
		   		</script>  
			</cfoutput>
	  
	   <cfelse>
	   
			<cfquery name="Insert" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_AssetEvent
						(
							Code,
							Description,
							ListingOrder,
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#Form.Code#',
							'#Form.Description#',
							#Form.ListingOrder#,
							#Form.Operational#,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
			</cfquery>
			
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		     action="Insert"
			 content="#form#">
			
			<script>
   				opener.location.reload();
			    parent.window.close();
			</script> 
			  
	    </cfif>		  
           
<cfelse>

	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_AssetEvent
		SET 
			Description			= '#Form.Description#',
			ListingOrder		= #Form.ListingOrder#,
			Operational			= #Form.Operational#
		WHERE Code         		= '#Form.Code#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
     action="Update"
	 content="#form#">
	
	<cfoutput>
		<script>
			ColdFusion.navigate('RecordEditHeader.cfm?id1=#url.id1#&idmenu=#url.idmenu#','divHeader');
			opener.location.reload();
		</script>
	</cfoutput>

</cfif>




