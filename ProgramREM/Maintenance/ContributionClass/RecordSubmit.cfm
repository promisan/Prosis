
<cfif url.id1 eq ""> 
	
	<cfquery name="Verify" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ContributionClass
		WHERE  Code  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount eq "1">
   
	   <script language="JavaScript">   
		     alert("A record with this code has been registered already!");
	   </script>  
  
   <cfelse>
	   
		<cfquery name="Insert" 
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  INSERT INTO Ref_ContributionClass
			       	(
						Code,
					   	Description,
						Mission,
						Execution,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
			  VALUES  
			  		(	'#Form.Code#',
			           	'#Form.Description#', 
						'#Form.Mission#',
						'#Form.Execution#',
					   	'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
		 
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                     action="Insert" 
							 content="#form#">
		 
    </cfif>		  
           
<cfelse>
	
	<cfquery name="Update" 
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Ref_ContributionClass
			SET   	Description = '#Form.Description#',
					Mission     = '#Form.Mission#',
					Execution   = '#Form.Execution#'
			WHERE 	Code        = '#url.id1#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">		 

</cfif>	

<script>
	window.close();
	opener.location.reload();
</script>
