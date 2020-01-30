

<!--- Status --->
<cfquery name="cleanStatus" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM	Ref_ProgramCategoryStatus
		WHERE	Code = '#vThisCategory#'
</cfquery>

<cfquery name="getStatus" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ProgramStatus
</cfquery>

<cfloop query="getStatus">

	<cfset vStatusId = replace(code," ","","ALL")>	
	<cfif isDefined("Form.status_#vStatusId#")>
	
		<cfquery name="insertStatus" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ProgramCategoryStatus
					(
						Code,
						ProgramStatus,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#vThisCategory#',
						'#code#',
						'#session.acc#',
						'#session.last#',
						'#session.first#'
					)
		</cfquery>
	
	</cfif>
</cfloop>

<!--- Profile --->

<cfquery name="cleanProfile" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM	Ref_ProgramCategoryProfile
		WHERE	Code = '#vThisCategory#'
</cfquery>

<cfquery name="getArea" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_TextArea
		WHERE	TextAreaDomain = 'Category' 
</cfquery>

<cfloop query="getArea">
	<cfset vProfileId = replace(code," ","","ALL")>
	<cfif isDefined("Form.profile_#vProfileId#")>
	
		<cfquery name="insertProfile" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ProgramCategoryProfile
					(
						Code,
						TextAreaCode,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#vThisCategory#',
						'#vProfileId#',
						'#session.acc#',
						'#session.last#',
						'#session.first#'
					)
		</cfquery>
	
	</cfif>
</cfloop>