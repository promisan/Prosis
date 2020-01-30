
<cfif url.id1 eq ""> 
	
	<cfquery name="Verify" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_WorkAction
		WHERE  ActionClass  = '#Form.ActionClass#' 
	</cfquery>

   <cfif Verify.recordCount eq "1">
   
	   <script language="JavaScript">   
		     alert("A record with this code has been registered already!");
	   </script>  
  
   <cfelse>
	   
		<cfquery name="Insert" 
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  INSERT INTO Ref_WorkAction
			       	(
						ActionClass,
					   	ActionDescription,
						ActionParent,
					   	ListingOrder,
					   	ViewColor,
					   	ProgramLookup,
						Operational,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
			  VALUES  
			  		(	'#Form.ActionClass#',
			           	'#Form.ActionDescription#', 
					   	'#Form.ActionParent#', 
					   	#form.ListingOrder#,
			    	   	'#form.ViewColor#',		  
				  	   	#form.ProgramLookup#,
						#form.Operational#,
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
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Ref_WorkAction
			SET   	ActionDescription = '#Form.ActionDescription#',
					ActionParent      = '#form.ActionParent#',
					ListingOrder      = #form.ListingOrder#,
					ViewColor         = '#form.ViewColor#',
					ProgramLookup     = #form.ProgramLookup#,
					Operational       = #form.Operational#
			WHERE 	ActionClass       = '#url.id1#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">		 

</cfif>	

<script>
	window.close();
	opener.location.reload();
</script>
