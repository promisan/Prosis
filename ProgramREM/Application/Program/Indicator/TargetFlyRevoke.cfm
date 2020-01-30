
<!--- Hanno 21/10/2015 
 ideally we need to log this access in the structure we have for old access logging --->

<cfquery name="FLY" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
   DELETE FROM OrganizationAuthorization
   WHERE OrgUnit        = '#URL.OrgUnit#'
   AND   ClassParameter = '#URL.IndicatorCode#'
   AND   Role           = '#URL.Role#'
   AND   UserAccount    = '#URL.UserAccount#'
</cfquery>

<cfinclude template="TargetViewDetailAccess.cfm">