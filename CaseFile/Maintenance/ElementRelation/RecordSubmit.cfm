

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ElementRelation
		WHERE Code = '#Form.Code#' 
<!---	
	Remove by Nery's request on 3/8/2011	
	    AND ElementClassFrom = '#Form.ElementFrom#'
		AND ElementClassTo = '#Form.ElementTo#' 
--->
	</cfquery>

  <cfif Verify.recordCount gt 0>
  		<cfoutput>
		<cf_tl id = "This relation has been registered already!" class="Message" var = "1">
	   <script language="JavaScript">
	   
	     alert("#lt_text#")
	     
	   </script>  
	   </cfoutput>
  
   <cfelse>		
   
		<cfquery name="Insert" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO Ref_ElementRelation
           (Code
           ,ElementClassFrom
           ,ElementClassTo
           ,Description
           ,ListingOrder
           ,OfficerUserId
           ,OfficerLastName
           ,OfficerFirstName
           ,Created)     			
			  VALUES ('#Form.Code#', 
					  '#Form.ElementFrom#',  
			          '#Form.ElementTo#',
  	  				  '#Form.Description#',
					  '#Form.ListingOrder#',
			   	      '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				      '#SESSION.first#',
				       getDate())
		  </cfquery>
		  
	</cfif>	  

	
<cfelse>	 

	<cfif ParameterExists(Form.Update)>
	
		
			<cfquery name="Update" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_ElementRelation
				SET 
				ElementClassFrom = '#Form.ElementFrom#',
				ElementClassTo = '#Form.ElementTo#',
				ListingOrder = '#Form.ListingOrder#',
				Description  = '#Form.Description#'
				WHERE Code = '#Form.Code#'
			</cfquery>
		

	
	</cfif>
	
	
	<cfif ParameterExists(Form.Delete)> 
	
		<cfquery name="Related" 
	     datasource="AppsCaseFile" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT    *
			 FROM ElementRelation
			 where RelationCode = '#Form.Code#'
		 </cfquery>	
	      	
	    <cfif #Related.recordCount# gt 0>
			 <cfoutput>
	 		<cf_tl id = "Relation is in use. Operation aborted." class="Message" var = "1">
		     <script language="JavaScript">
		    
			   alert(" #lt_text#")
		     
		     </script> 
			 </cfoutput> 
			 	 
	    <cfelse>
		
			<cfquery name="Delete" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM Ref_ElementRelation
					WHERE Code = '#Form.Code#'
			    </cfquery>		
		
	    </cfif>	
		
	</cfif>	
	
</cfif>

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  