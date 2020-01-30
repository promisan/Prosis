
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
