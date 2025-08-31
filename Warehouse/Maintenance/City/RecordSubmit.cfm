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
<cfif url.mission eq ""> 

	<cfquery name="Verify" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_WarehouseCity
			WHERE  	Mission = '#form.mission#'
			AND		City = '#form.city#'
	</cfquery>

   <cfif Verify.recordCount gt 0>
   
	   <script>
			alert("A record with this mission, city has been registered already!")
			history.back();
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_WarehouseCity
		         (Mission,
				 City,
				 ListingOrder,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		    VALUES ('#Form.Mission#',
		  		  '#Form.City#',
				  #Form.listingOrder#,
		          '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		  
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
			action="Insert" 
			content="#Form#">
		  
    </cfif>		  
           
<cfelse>

	<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE 	Ref_WarehouseCity
		SET		ListingOrder   = #Form.listingOrder#
		WHERE  	Mission = '#url.mission#'
		AND		City = '#url.city#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		action="Update" 
		content="#Form#">

</cfif>	

<script language="JavaScript">
     parent.window.close();
	 opener.location.reload();
</script>  
