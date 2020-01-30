
<cf_submenutop>

<cf_submenuLogo module="Roster" selection="Application">

<cfset heading   = "Candidates">
<cfset module    = "'Roster'">
<cfset selection = "'Application'">
<cfset class     = "'Main'">

<cfinclude template  = "../../Tools/Submenu.cfm">

<cfset heading       = "Extended Search (Collection)">
<cfset selection     = "'Search','Listing'">
<cfset class         = "'Collection'">
<cfinclude template  = "../../Tools/Submenu.cfm">

<cfquery name="getOwner" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT *
	FROM (
	SELECT DISTINCT ClassParameter as Owner
	FROM   Organization.dbo.OrganizationAuthorization A
	WHERE  A.UserAccount = '#SESSION.acc#' 
	AND    A.Role IN (SELECT Role 
	                  FROM   Organization.dbo.Ref_AuthorizationRole 
	   			      WHERE  SystemModule = 'Roster')
										
    UNION
					 
	SELECT DISTINCT S.Owner
	FROM   RosterAccessAuthorization A INNER JOIN
	       FunctionOrganization FO ON A.FunctionId = FO.FunctionId INNER JOIN
	       Ref_SubmissionEdition S ON FO.SubmissionEdition = S.SubmissionEdition
	WHERE  A.UserAccount = '#SESSION.acc#'
	) as T 
	WHERE Owner > '' 	
		
</cfquery>	


<cfquery name="OwnerList" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT * 
    FROM   Ref_ParameterOwner R
	WHERE  Operational = 1
		
	<cfif SESSION.isAdministrator eq "Yes">
	
	<!--- no filter --->
	
	<cfelseif SESSION.isOwnerAdministrator neq "No" and SESSION.isOwnerAdministrator neq "">
	
	AND  Owner IN (#preserveSingleQuotes(SESSION.isOwnerAdministrator)#) 
		
	<cfelseif getOwner.recordcount gte "1">
	
	AND  Owner IN (#quotedValueList(getOwner.Owner)#)
	
	<cfelse>
	
	AND 1=0
				
	</cfif>								  				  
				
</cfquery>

<cfloop query="OwnerList">

	<cfset heading   = "#Owner#">
 	<cfset module    = "'Roster'">
	<cfset selection = "'Roster'">
	<cfset class     = "'Main'">
	<cfset passtru   = "status=1&mode=complete&owner=#Owner#">
			
	<cfinclude template="../../Tools/Submenu.cfm">
	
</cfloop>
