
<cfparam name="Form.Operational" default="0">
<cfparam name="Form.FieldName" default="">

<cfif #URL.ID2# neq "new">

	  <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE  Ref_EntityStatus
		  SET Operational = '#Form.Operational#',
 		      StatusDescription = '#Form.StatusDescription#'
			 WHERE EntityStatus = '#URL.ID2#'
			 AND  EntityCode = '#URL.EntityCode#'
	    	</cfquery>
					
		
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_EntityStatus
		WHERE EntityCode = '#URL.EntityCode#' 
		AND EntityStatus = '#Form.EntityStatus#'
	</cfquery>
	
	<cfif #Exist.recordCount# eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityStatus
			         (EntityCode,
					 EntityStatus,
					 StatusDescription,
					 Operational,
					 Created)
			      VALUES ('#URL.EntityCode#',
				      '#Form.EntityStatus#',
					  '#Form.StatusDescription#',
				      '#Form.Operational#',
					  getDate())
			</cfquery>
	</cfif>		
		   	
</cfif>
 	
<cfset url.id2 = "new">
<cfinclude template="ObjectStatus.cfm">	

  
