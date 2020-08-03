

<!--- set action --->

<cftransaction>

<cfquery name="get" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT * FROM OrganizationObject
		  WHERE  ObjectId = '#url.objectId#'			  			 
</cfquery>

<cfif get.Operational eq "1">
	
	<cfquery name="set" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE OrganizationObject
			 SET    Operational = 0
			 WHERE  ObjectId = '#url.objectId#'					 
	</cfquery>
	
	<cfquery name="log" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	INSERT INTO OrganizationObjectLog
			( ObjectId, ActionMemo, OfficerUserId, OfficerLastName, OfficerFirstName )
		    VALUES 
			 ('#url.objectId#', 'Deactivate', '#Session.acc#', '#session.last#','#session.first#')			 
	</cfquery>
	
	<cfoutput>
	<cf_tl id="Reinstate" var="1">	
    <input type="button" name="Reinstate" value="#lt_text#" class="button10g" onclick="_cf_loadingtexthtml='';ptoken.navigate('setObjectOperational.cfm?objectid=#objectid#','process_#objectid#')" style="height:20px;width:76px">
	</cfoutput>
							

<cfelse>

	<cfquery name="set" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE OrganizationObject
			 SET    Operational = 1
			 WHERE  ObjectId = '#url.objectId#'					 
	</cfquery>
	
	<cfquery name="log" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	INSERT INTO OrganizationObjectLog
			( ObjectId, ActionMemo, OfficerUserId, OfficerLastName, OfficerFirstName )
		    VALUES 
			 ('#url.objectId#', 'Reinstate', '#Session.acc#', '#session.last#','#session.first#')			 
	</cfquery>

</cfif>

</cftransaction>