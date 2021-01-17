
<cfquery name="Exist" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    	*
	FROM     	Ref_TaskTypeMission
	WHERE    	Code = '#Form.Code#'
    AND    		Mission  = '#Form.Mission#'
</cfquery>

<!--- <cfif ParameterExists(Form.Save)> 
	
	<cfif Exist.recordCount eq "0">
		
		<cfquery name="Insert" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     INSERT INTO Ref_TaskTypeMission
			         	(Code,
						Mission,
						<cfif trim(Form.TaskOrderTemplate) neq "">TaskOrderTemplate,</cfif>
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName)
			      VALUES ('#Form.Code#',
				  		'#Form.Mission#',
						<cfif trim(Form.TaskOrderTemplate) neq "">'#Form.TaskOrderTemplate#',</cfif>
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Insert" 
						 content="#Form#">
		
		<cfoutput>
			<script language="JavaScript">   
	     		ColdFusion.navigate('MissionListing.cfm?idmenu=#url.idmenu#&ID1=#Form.Code#', 'divMissions');
				ColdFusion.Window.hide('mydialog');
			</script>
		</cfoutput>
			
	<cfelse>
			
		<script>
			<cfoutput>
				alert("Sorry, but this entity already exists.")
			</cfoutput>
		</script>
				
	</cfif>	

</cfif> --->

<cfif ParameterExists(Form.Update)>	
	
	<cfif Exist.recordCount gt 0 and Form.Mission neq Form.MissionOld>
		
		<script>
			<cfoutput>
				alert("Sorry, this entity already exists.")
			</cfoutput>
		</script>				
			
	<cfelse>
					
		<cfquery name="Update" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		   	  	 UPDATE Ref_TaskTypeMission
				 SET	Mission           = '#Form.Mission#',
			 		TaskOrderTemplate = <cfif trim(Form.TaskOrderTemplate) neq "">'#Form.TaskOrderTemplate#'<cfelse>null</cfif>
			 	 WHERE 	Code   		      = '#Form.Code#'
			 	 AND	Mission           = '#Form.MissionOld#'
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#Form#">
		
		<cfoutput>
			<script language="JavaScript">   
	     		ptoken.navigate('MissionListing.cfm?idmenu=#url.idmenu#&ID1=#Form.Code#', 'divMissions');
				ProsisUI.closeWindow('mydialog');
			</script>
		</cfoutput>
				
	</cfif>	

</cfif>

<!--- <cfif ParameterExists(Form.Delete)> 

    <cfquery name="Delete" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_TaskTypeMission
		 WHERE 	Code       = '#Form.Code#'
		 AND	Mission    = '#Form.MissionOld#'
	</cfquery>	
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Delete" 
						 content="#Form#">
	
	<cfoutput>
		<script language="JavaScript">   
     		ColdFusion.navigate('MissionListing.cfm?idmenu=#url.idmenu#&ID1=#Form.Code#', 'divMissions');
			ColdFusion.Window.hide('mydialog');
		</script>
	</cfoutput>
	
</cfif> --->	
	  
	
