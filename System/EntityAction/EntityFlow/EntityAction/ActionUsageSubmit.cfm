
<cfparam name="Form.Operational" default="0">
<cfparam name="Form.FieldName" default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE  Ref_EntityUsage
		  SET     Operational = '#Form.Operational#',
 		          ObjectUsageName = '#Form.ObjectUsageName#',
				  <cfif form.owner eq "">
				      Owner = NULL
				  <cfelse>
				      Owner = '#form.Owner#'				  
				  </cfif>
		  WHERE   ObjectUsage = '#URL.ID2#'
			 AND  EntityCode = '#URL.EntityCode#'
   	</cfquery>
			
	<cfset url.id2 = "new">
    <cfinclude template="ActionUsage.cfm">		
		

<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_EntityUsage
		WHERE EntityCode = '#URL.EntityCode#' 
		AND ObjectUsage = '#Form.ObjectUsage#'
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityUsage
			         (EntityCode,
					 ObjectUsage,
					  <cfif Form.Owner neq "">
						 Owner,
					  </cfif>
					 ObjectUsageName,
					 Operational)
			     VALUES ('#URL.EntityCode#',
				         '#Form.ObjectUsage#',
					     <cfif Form.Owner neq "">
						 '#Form.Owner#',
					     </cfif>
					     '#Form.ObjectUsageName#',
				         '#Form.Operational#')
			</cfquery>
	</cfif>	
	
	<cfset url.id2 = "new">
    <cfinclude template="ActionUsage.cfm">		
	   	
</cfif>
 	

  
