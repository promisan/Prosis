
<!--- 1. removing access specific --->
<!--- 2. removing access global   --->
<!--- 3. sync group access --->

<cfcomponent>

<!--- ------------------------- --->

<cffunction name        = "getstatus" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "getProgress Bar Status" 
		    output      = "false">	 	 
		 
			 <cfset str = structNew()>			 		 
			
			 <cfparam name      = "Session.Status"    default="0">		
			 <cfparam name      = "Session.Message"   default="Please Wait">	
			 
			  <!--- Hanno ensure the session progresses if no explicit 
	 						action is taken for some reason --->
				
			 <cfif session.status lt 1>
	 		 	<cfset session.status = session.status + 0.001>
			 </cfif>
			 
			 <cfset str.status  = "#Session.Status#">	
			 <cfset str.message = "#Session.Message#">	
									 
			 <cfif session.status gte 1>				 		 
			 	<cfset session.status = "1">							 								
			 </cfif>
			 		 
			 <cfreturn str>
		 		 
</cffunction> 

<cffunction access      = "public" 
            name        = "OrgAuthorizationSet"
			returntype  = "string">
			
	<cfargument name="Mission"      type="string" Default="ET" required="no">
	<cfargument name="Role"         type="string" Default="('ProgramOfficer','ProgressOfficer')" required="no">
	<cfargument name="Action"       type="string" default="REVOKE" required="no">
	<cfargument name="Process"      type="string" default="QRM-SET" required="no">
	<cfargument name="AccessLevel"  type="string" default="0" required="no">
	<cfargument name="User"         type="string" Default="" required="no">
	<cfargument name="Block"		type="string" Default="NO" required="no">
	<cfargument name="Class"		type="string" Default="Default" required="no">
	
<Cfif Action eq "REVOKE">

	<cfquery name="AuthorizationDeny" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			INSERT INTO OrganizationAuthorizationDeny
			(AccessID, OrgUnit, UserAccount, Mission, Role, AccessLevel, Source, ClassParameter)
			SELECT  AccessID, 
			        OrgUnit, 
					UserAccount, 
					Mission, 
					Role, 
					AccessLevel, 
					'#Process#', 
					ClassParameter 
			FROM  OrganizationAuthorization
			WHERE 	Mission 		= '#Mission#'
			AND 	UserAccount 	= '#User#'
			AND		Role IN #PreserveSingleQuotes(Role)# 
			AND		ClassParameter 	= '#Class#'
			AND		(RecordStatus 	!= 5 or RecordStatus IS NULL)							<!--- batch update disabled --->
		</cfquery>	
		
	<cfquery name="AuthorizationRevoke" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		UPDATE OrganizationAuthorization 
		SET AccessLevel = '#AccessLevel#',
			RecordStatus 	= <cfif Block eq "YES"> 5 <cfelse> 0 </cfif> 				
		WHERE 	Mission 	= '#Mission#'
		AND 	UserAccount = '#User#'
		AND		Role IN #PreserveSingleQuotes(Role)# 
		AND		ClassParameter 	= '#Class#'
		AND		(RecordStatus != 5 or RecordStatus IS NULL)							
		</cfquery>				
		
<cfelse>	
	
	<cfquery name="AuthorizationReset" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		UPDATE O
		SET O.AccessLevel = D.AccessLevel, 
			O.RecordStatus 	= <cfif Block eq "YES"> 5 <cfelse> 0 </cfif>
		FROM OrganizationAuthorization O Inner join OrganizationAuthorizationDeny D
					ON		D.UserAccount 		= O.UserAccount
					AND		D.Mission 			= O.Mission
					AND		D.Role 				= O.Role
					AND		D.ClassParameter 	= O.ClassParameter
					AND		D.OrgUnit			= O.OrgUnit
		WHERE 	D.Mission 			= '#Mission#'
		AND 	D.UserAccount 		= '#User#'
		AND		D.Role 				IN #PreserveSingleQuotes(Role)# 
		AND		D.ClassParameter 	= '#Class#'
		AND		(O.RecordStatus 	!= 5 OR O.RecordStatus IS NULL)					<!--- Can not restore blocked access --->
		</cfquery>				
			
	<cfquery name="AuthorizationDenyReset" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		DELETE OrganizationAuthorizationDeny
		FROM OrganizationAuthorizationDeny D Inner join OrganizationAuthorization O
					ON		D.UserAccount 		= O.UserAccount
					AND		D.Mission 			= O.Mission
					AND		D.Role 				= O.Role
					AND		D.ClassParameter 	= O.ClassParameter
					AND		D.OrgUnit			= O.OrgUnit
		WHERE 	D.Mission 			= '#Mission#'
		AND 	D.UserAccount 		= '#User#'
		AND		D.Role 				IN #PreserveSingleQuotes(Role)#
		AND		D.ClassParameter 	= '#Class#'
		AND		D.Source			= '#Process#'	
	</cfquery>	

</cfif>
	
</cffunction>	 	
		
</cfcomponent>		