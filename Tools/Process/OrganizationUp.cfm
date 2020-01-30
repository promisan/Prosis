
<cfparam name="Attributes.Mission" default="">
<cfparam name="Attributes.Role" default="">
<cfparam name="Attributes.UserAccount" default="">

 <CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OrgUnit">	

<cfquery name="Select" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
     SELECT   A.OrgUnit, '1' as Enabled, O.ParentOrgUnit, O.Mission, O.MandateNo 
     INTO     userQuery.dbo.#SESSION.acc#OrgUnit
     FROM     OrganizationAuthorization A, Organization O
     WHERE    A.Role        = '#Attributes.Role#' 
        AND   A.Mission     = '#Attributes.Mission#' 
      	AND   A.UserAccount = '#Attributes.UserAccount#'
	    AND   A.OrgUnit     = O.OrgUnit
</cfquery>

<cfquery name="List" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT     *
 FROM      userQuery.dbo.#SESSION.acc#OrgUnit
</cfquery>

<cfloop query = "List">
	
	<cfset par = List.ParentOrgUnit>
	
	<cfloop condition="par neq ''">
	
		<cfquery name="Parent" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Organization
			 WHERE    OrgUnitCode = '#Par#'
			 AND      Mission = '#List.Mission#'
			 AND      MandateNo = '#List.MandateNo#'
		</cfquery>
		
		<cfif Parent.recordcount eq "1">
		
			<cfquery name="Check" 
			 datasource="AppsOrganization" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 	SELECT  *
				FROM    userQuery.dbo.#SESSION.acc#OrgUnit
				WHERE   OrgUnit = '#Parent.OrgUnit#'
			</cfquery>
			
			<cfif Check.recordcount eq "0">
				
				<cfquery name="Insert" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 INSERT INTO userQuery.dbo.#SESSION.acc#OrgUnit
				 			(OrgUnit,Enabled,Mission,MandateNo)
				 VALUES 	('#Parent.OrgUnit#',
				             '0',
							 '#List.Mission#',
							 '#List.MandateNo#')
				</cfquery>
					
			</cfif>
		
		</cfif>
		
		<cfset par = #Parent.ParentOrgUnit#>
	
	</cfloop> 

</cfloop>
