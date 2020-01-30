
<cfif URL.code neq "new">

	 <cfquery name="Update" 
		  datasource="AppsCaseFile" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			UPDATE Ref_ElementSection
			SET Description  = '#Form.Description#',
			ListingLabel = '#Form.ListingLabel#',
			ListingOrder = '#Form.ListingOrder#',
			ListingIcon  = '#Form.ListingIcon#'
			WHERE Code = '#URL.Code#'
	</cfquery>
				

<cfelse>
			
	<cfquery name="Verify" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ElementSection
		WHERE Code = '#Form.Code#' 
	</cfquery>

    <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
		     alert("A record with this code has been registered already!")
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ElementSection
			         (Code,
					 Description,
					 ListingLabel,
					 ListingOrder,
					 ListingIcon, 
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			  VALUES ('#Form.Code#', 
			          '#Form.Description#',
  	  				  '#Form.ListingLabel#',
  	  				  '#Form.ListingOrder#',
					  '#Form.ListingIcon#',
			   	      '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				      '#SESSION.first#',
				       getDate())
		  </cfquery>
		  
	</cfif>	  
		   	
</cfif>

<cfset url.code = "">
<cfinclude template="RecordListingDetail.cfm">
