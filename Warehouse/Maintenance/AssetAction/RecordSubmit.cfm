
<cfif ParameterExists(Form.Save)>
			
	<cfquery name="Exist" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT 	*
		FROM 	Ref_AssetAction
		WHERE  	Code = '#Form.Code#'  
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsMaterials" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_AssetAction
			         (Code,
				     Description,
					 TabIcon,
					 EnableWorkflow,
					 Operational,
					 ActionClass,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#Form.Code#',
					  '#Form.Description#',
					  '#Form.TabIcon#',
					  '#Form.EnableWorkflow#',
			      	  '#Form.Operational#',
					  '#Form.ActionClass#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>
			
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     		 action="Insert" 
						 		 content="#Form#">
			
			<script language="JavaScript">
				parent.opener.location.reload()
  				parent.window.close()
			</script>  
			
	<cfelse>
			
		<cfoutput>
		<script>		
			alert("Sorry, but #Form.Code# already exists")		
		</script>
		</cfoutput>
				
	</cfif>		
		   	
</cfif>

<cfif ParameterExists(Form.Update)>

	 <cfquery name="Update" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  UPDATE Ref_AssetAction
			  SET    Description         = '#Form.Description#',
					 TabIcon             = '#Form.TabIcon#',
					 Operational         = '#Form.Operational#',
					 EnableWorkflow      = '#Form.EnableWorkflow#',
					 ActionClass         = '#Form.ActionClass#' 
			  WHERE  Code = '#Form.CodeOld#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#Form#">
	
	<cfoutput>
	<script language="JavaScript">
		parent.opener.location.reload()
		parent.location = "RecordEditTab.cfm?id1=#url.id1#&idmenu=#url.idmenu#"
  		parent.focus()
	</script>
	</cfoutput>
	
</cfif> 

<cfif url.action eq "Delete">

	<cfquery name="Delete" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  DELETE FROM Ref_AssetAction
		  WHERE Code = '#url.id1#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Delete" 
						 content="#Form#">
	
	<script language="JavaScript">
		parent.opener.location.reload()
  		parent.window.close()
	</script>
	
</cfif>