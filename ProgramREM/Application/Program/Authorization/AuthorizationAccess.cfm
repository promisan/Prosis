
<cfparam name="url.action" default="">
<cfparam name="url.role"   default="">
<cfparam name="url.mode"   default="">

<cfif url.action eq "Insert">

	<cfloop index="itm" list="#url.list#" delimiters=":">
	
		<cfquery name="Member" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT * 
		  FROM   ProgramAccessAuthorization
		  WHERE  ProgramCode  =  '#url.ProgramCode#'
		  AND    UserAccount = '#URL.Account#'
		  AND    Role = '#itm#' 
		</cfquery>
							
		<cfif Member.recordcount eq "0">		
		
			<cfquery name="Employee" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ProgramAccessAuthorization
				    (ProgramCode,
					 UserAccount,
					 Role,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			VALUES(	'#url.ProgramCode#',
					'#URL.Account#',
					'#itm#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#') 					
			</cfquery>
			
		</cfif>
		
		<cfoutput>
		
		<script>
			_cf_loadingtexthtml='';		
			ColdFusion.navigate('AuthorizationList.cfm?mode=#url.mode#&programcode=#url.programcode#&role=#itm#','#itm#')		
		</script>
		
		</cfoutput>
			
	</cfloop>
	
<cfelseif url.action eq "delete">	

	<cfquery name="Employee" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM ProgramAccessAuthorization
	  WHERE  ProgramCode  =  '#url.ProgramCode#'
	  AND    UserAccount = '#URL.Account#'
	  AND    Role = '#URL.Role#' 
	</cfquery>
	
	<cfinclude template="AuthorizationList.cfm">
	
<cfelse>

	<cfinclude template="AuthorizationList.cfm">	
	
</cfif>
