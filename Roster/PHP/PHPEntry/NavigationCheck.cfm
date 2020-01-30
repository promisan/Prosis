<cfparam name="URL.Object" default="Applicant">
<cfparam name="URL.Owner"  default="SysAdmin">

<cfquery name="qCheckOwnerSection" 
datasource="appsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ApplicantSectionOwner
	WHERE    Owner = '#URL.Owner#'
	AND      Code  = '#URL.Section#' 
</cfquery>

<cfif qCheckOwnerSection.recordcount neq 0>
	<cfset ValidateOwner = qCheckOwnerSection.recordcount>	
<cfelse>
	<cfset ValidateOwner = 0>
</cfif>	

<cfquery name="Section" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     #CLIENT.LanPrefix#Ref_ApplicantSection S
			WHERE    Code = '#URL.Section#'
			<cfif ValidateOwner neq 0>
					AND EXISTS
					(
						SELECT 'X'
						FROM Ref_#URL.Object#SectionOwner
						WHERE Code = S.Code
						AND   Owner = '#URL.Owner#'
						AND   Operational = '1' 
					)
			</cfif>								
</cfquery>

<cfquery name="Previous" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     #CLIENT.LanPrefix#Ref_ApplicantSection S
			WHERE    
			EXISTS
			(
				SELECT 'X'
				FROM     #CLIENT.LanPrefix#Ref_ApplicantSection 
				WHERE    S.ListingOrder < ListingOrder
				AND      Code = '#URL.Section#' 
			)
			<cfif ValidateOwner neq 0>
					AND EXISTS
					(
						SELECT 'X'
						FROM   Ref_#URL.Object#SectionOwner
						WHERE  Code = S.Code
						AND    Owner = '#URL.Owner#'
						AND    Operational = '1' 
					)
			</cfif>								
</cfquery>

<cfquery name="Subsequent" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     #CLIENT.LanPrefix#Ref_ApplicantSection S
			WHERE    
			EXISTS
			(
				SELECT 'X'
				FROM     #CLIENT.LanPrefix#Ref_ApplicantSection 
				WHERE    S.ListingOrder > ListingOrder
				AND      Code = '#URL.Section#' 
			)
			<cfif ValidateOwner neq 0>
					AND EXISTS
					(
						SELECT 'X'
						FROM Ref_#URL.Object#SectionOwner
						WHERE Code = S.Code
						AND   Owner = '#URL.Owner#'
						AND Operational = '1' 
					)
			</cfif>								
</cfquery>
