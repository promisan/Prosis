
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "WorkflowObject Function">
		
	<cffunction name="AuthorisedUsers"
             access="remote"
             returntype="array"
             displayname="AuthorisedUsers">
		
			<cfargument name="ObjectId"   type="string" required="true">
		    <cfargument name="ActionCode" type="string" required="true">
		
			 <!--- Get data --->
		      <cfquery name="User" datasource="AppsSystem">
			      SELECT *
			      FROM UserNames
				  WHERE Account IN (SELECT UserAccount
				                    FROM   Organization.dbo.OrganizationAuthorization
									WHERE  ClassIsAction = 1
									AND    ClassParameter = '#ActionCode#')
				  UNION
				  SELECT *
				  FROM UserNames
				  WHERE Account IN (SELECT UserAccount
				                    FROM Organization.dbo.OrganizationObjectActionAccess
									WHERE ObjectId = '#ObjectId#'
									AND   ActionCode = '#ActionCode#')
			  </cfquery>
		
			<cfset list = arraynew(2)>
		
			<!--- Convert results to array --->
	      	<cfloop index="i" from="1" to="#User.RecordCount#">
    	    	 <cfset list[i][1]=User.Account[i]>
	        	 <cfset list[i][2]="#User.FirstName[i]# #User.LastName[i]#">
	      	</cfloop>
		
		<cfreturn list>
		
	</cffunction>
	
	
</cfcomponent>	