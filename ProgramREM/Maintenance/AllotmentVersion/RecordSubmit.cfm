

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 

		<cfquery name="Verify" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_AllotmentVersion
		WHERE Code  = '#Form.Code#'	
		</cfquery>
	
	   <cfif Verify.recordCount gte 1>

		   <cf_message message="A version with this code has been recorded already. This is not allowed" return="back">
		   <cfabort>
      
	   <cfelse>
      
			<cfquery name="Insert" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_AllotmentVersion
			         (<cfif form.mission neq "">Mission,</cfif>
					  Code,
				      Description,
				      ObjectUsage,
					  <cfif form.ProgramClass neq "">
					  ProgramClass,
					  </cfif>
				      ListingOrder,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,	
					  Created)
			  VALUES (<cfif form.mission neq "">'#Form.Mission#',</cfif>
			          '#Form.Code#', 
				      '#Form.Description#',
				      '#Form.ObjectUsage#',
					  <cfif form.ProgramClass neq "">
					  '#Form.ProgramClass#',
					  </cfif>
				      '#Form.ListingOrder#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  getDate())
			  </cfquery>
			 	  
		 </cfif>
		           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_AllotmentVersion
		SET   Mission = <cfif form.mission neq "">'#Form.Mission#'<cfelse>NULL</cfif>,
		      Description    = '#Form.Description#',
			  ObjectUsage    = '#Form.ObjectUsage#',
			  <cfif form.ProgramClass eq "">
			  ProgramClass   = NULL,
			  <cfelse>
			  ProgramClass   = '#Form.ProgramClass#',
			  </cfif>
			  ListingOrder   = '#Form.ListingOrder#'	
		WHERE Code         = '#Form.Code#' 	
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Ref_AllotmentEdition
	      WHERE  Version = '#Form.Code#' 	 
	  </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">
	    
		   alert("Version is in use. Operation aborted.")
		        
	     </script>  
	 
    <cfelse>
	
			<cfquery name="Delete" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Ref_AllotmentVersion
			WHERE Code         = '#Form.Code#'
		    </cfquery>
		
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
