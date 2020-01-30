
<cfparam name="Form.Operational" default="0">
<cfparam name="Form.FieldName" default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE  Ref_EntityGroup
		  SET     Operational = '#Form.Operational#',
 		          EntityGroupName = '#Form.EntityGroupName#',
				  <cfif form.owner eq "">
				      Owner = NULL
				  <cfelse>
				      Owner = '#form.Owner#'				  
				  </cfif>
		  WHERE   EntityGroup = '#URL.ID2#'
			 AND  EntityCode = '#URL.EntityCode#'
   	</cfquery>
			
	<cfset url.id2 = "new">
    <cfinclude template="ActionGroup.cfm">		
		

<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_EntityGroup
		WHERE EntityCode = '#URL.EntityCode#' 
		AND EntityGroup = '#Form.EntityGroup#'
	</cfquery>
	
	<cfif #Exist.recordCount# eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityGroup
			         (EntityCode,
					 EntityGroup,
					  <cfif Form.Owner neq "">
						 Owner,
					  </cfif>
					 EntityGroupName,
					 Operational,
					 Created)
			      VALUES ('#URL.EntityCode#',
				      '#Form.EntityGroup#',
					  <cfif Form.Owner neq "">
						  '#Form.Owner#',
					   </cfif>
					  '#Form.EntityGroupName#',
				      '#Form.Operational#',
					  getDate())
			</cfquery>
	</cfif>	
	
	<cfset url.id2 = "new">
    <cfinclude template="ActionGroup.cfm">		
	   	
</cfif>
 	

  
