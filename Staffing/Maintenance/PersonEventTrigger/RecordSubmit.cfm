
<cfif url.id1 eq ""> 

	<cfquery name="Verify" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EventTrigger
	WHERE Code  = '#Form.Code#' 
	</cfquery>
	
	<cfif Verify.recordCount is 1>
	   
	   <script language="JavaScript">
	   
	     alert("a record with this code has been registered already!")
	     
	   </script>  
	  
	<cfelse>
	   
		<cfquery name="Insert" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_EventTrigger
		         (Code,
				 Description,				
				 ListingOrder,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.code#',
		          '#Form.Description#',		          
		          '#Form.ListingOrder#', 
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
			  
	</cfif>		  
           
</cfif>

<cfif url.id1 neq "">

	<cfquery name="Update" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Ref_EventTrigger
			SET 	Description = '#Form.Description#',
					EntityCode  = '#Form.Entity#',
					ListingOrder = '#Form.ListingOrder#'
			WHERE 	Code  = '#Form.Codeold#'
	</cfquery>

</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
