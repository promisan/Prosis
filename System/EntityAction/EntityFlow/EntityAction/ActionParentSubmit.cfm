
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.FieldName" default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE  Ref_EntityActionParent
		  SET     Operational  = '#Form.Operational#',
 		          Description  = '#Form.Description#',
			      ListingOrder = '#Form.ListingOrder#'
		  WHERE   Code = '#URL.ID2#'
		    AND   EntityCode = '#URL.EntityCode#'
			AND   Owner = '#Form.Owner#'
	    	</cfquery>
			
	<script>
	 <cfoutput>
		 window.location = "ActionParent.cfm?EntityCode=#URL.EntityCode#"
	 </cfoutput> 
	</script>			

<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_EntityActionParent
		WHERE EntityCode = '#URL.EntityCode#' 
		AND Code = '#Form.Code#'
		AND   Owner = '#Form.Owner#'
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityActionParent
			         (EntityCode,
					 Code,
					 Owner,
					 Description,
					 ListingOrder,
					 Operational,
					 Created)
			      VALUES ('#URL.EntityCode#',
				      '#Form.Code#',
					  '#Form.Owner#',
					  '#Form.Description#',
					  '#Form.ListingOrder#',
				      '#Form.Operational#',
					  getDate())
			</cfquery>
	</cfif>	
		
	<cfoutput>
	 	<script>
		 window.location = "ActionParent.cfm?EntityCode=#URL.EntityCode#&id2=new"
		</script>	
	</cfoutput> 
	   	
</cfif>
 	

  
