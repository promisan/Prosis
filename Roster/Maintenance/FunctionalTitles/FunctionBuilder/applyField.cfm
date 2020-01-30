
<cfif url.line neq "">
	
	<cfquery name="Check"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE  FROM FunctionRequirementLine
		WHERE   RequirementId     = '#url.id#'
		AND     RequirementLineNo = '#url.line#'  
	</cfquery>

</cfif>

<cfif URL.val neq "" and URL.val neq "Blank">
	
	<cfif url.line eq "">
		
		<cfquery name="No"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 * 
			FROM     FunctionRequirementLine
			WHERE    RequirementId = '#url.id#'
			ORDER BY RequirementLineNo DESC
		</cfquery>
		
		<cfif No.RequirementLineNo eq "">
		   <cfset ln = "1">
		<cfelse>
		   <cfset ln = no.RequirementLineNo+1>  
		</cfif>
		
	<cfelse>	
	
		<cfset ln = url.line>
	
	</cfif>

	<cfquery name="Check"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO FunctionRequirementLine
			(RequirementId, 
			 RequirementLineNo, 
			 Parent,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	VALUES
		    ('#url.id#',
			 '#ln#',
			 '#url.parentcode#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
	</cfquery>	
		
	<cfloop index="itm" list="#URL.val#" delimiters=",">
	
	    <cftry>
	
			<cfquery name="Insert"
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO FunctionRequirementLineField
				(RequirementId, 
				 RequirementLineNo, 
				 ExperienceFieldId,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
				VALUES
			    ('#url.id#',
				 '#ln#',
				 '#itm#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
			</cfquery>
		
		<cfcatch></cfcatch>
		
		</cftry>

	</cfloop>

</cfif>

<cfset parentcode = url.parentcode>
<cfset url.requirementId = url.id>
<cfinclude template="FunctionRequirementLine.cfm">
