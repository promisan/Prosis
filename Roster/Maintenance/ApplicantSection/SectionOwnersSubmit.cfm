<cfquery name="CleanOwners" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	Ref_ApplicantSectionOwner
		WHERE	Code = '#url.currentCode#'
</cfquery>

<cfquery name="GetOwners" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ParameterOwner
		WHERE	Operational = 1
</cfquery>

<cfoutput query="GetOwners">

	<cfset ownerId = replace(owner," ","","ALL")>
	<cfset ownerId = replace(ownerId,"-","","ALL")>

	<cfif isDefined("Form.cb_#ownerId#")>
	
		<cfset vALRead = evaluate("Form.alr_#ownerId#")>
		<cfset vALEdit = evaluate("Form.ale_#ownerId#")>
	
		<cfquery name="insertOwner" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ApplicantSectionOwner
					(
						Code,
						Owner,
						Operational,
						AccessLevelRead,
						AccessLevelEdit,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.currentCode#',
						'#Owner#',
						1,
						'#vALRead#',
						'#vALEdit#',
						'#session.acc#',
						'#session.last#',
						'#session.first#'
					)
		</cfquery>
	
	</cfif>

</cfoutput>