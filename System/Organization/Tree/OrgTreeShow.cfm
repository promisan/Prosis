	
<cfparam name="URL.maxlevel"    default="1">
<cfparam name="URL.PostClass"   default="">
<cfparam name="URL.Fund"        default="">

<cfparam name="URL.Layout"      default="hide">

<cfif getAdministrator("#url.mission#") neq "1">

	<cfquery name="MissionAccess" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT Mission
			FROM   Organization.dbo.OrganizationAuthorization 
			WHERE  UserAccount = '#SESSION.Acc#' AND Mission = '#URL.Mission#'
			AND    Role IN (
				SELECT Role
				FROM   Organization.dbo.Ref_AuthorizationRole
				WHERE  SystemModule = 'Staffing'
			)	
	</cfquery>
	
	<cfif MissionAccess.recordcount eq 0>
		<cf_message message = "Sorry, you do not have access to this view." return = "">
		<cfabort>
	</cfif>

</cfif>

<cfquery name="Mission" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Ref_Mission
		 WHERE  Mission   = '#URL.Mission#'		
</cfquery>

<cfquery name="Mandate" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT  TOP 1 R.*, 
	         M.MissionName
	 FROM    Ref_Mandate R, Ref_Mission M
	 WHERE   R.Mission = M.Mission
	 <cfif URL.Mission neq "">
	 AND     M.Mission = '#URL.Mission#' 
	 <cfelse>
	 AND     M.MissionParentOrgUnit = '#URL.OrgUnitCode#' 
	 </cfif>
	<!---- added by JM ---->
	 <cfif URL.MandateNo neq "">
	 AND    R.MandateNo='#URL.mandateNo#'
	 </cfif>
	 
	 ORDER BY MandateDefault DESC
</cfquery>

<cfparam name="URL.MandateNo" default = "#Mandate.MandateNo#">

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_MissionOrganization"> 

<!--- create temp table for better performance --->


<cfif url.tree neq "Administrative">
	
	<cfquery name="Tree" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	 
		 SELECT O.*,M.MissionName
		 
		 INTO   userquery.dbo.#SESSION.acc#_MissionOrganization
		 
		 FROM   Organization O, Ref_Mission M
		 WHERE  O.Mission   = '#Mandate.Mission#'
		 AND    O.MandateNo = '#Mandate.MandateNo#' 
		 AND 	M.Mission   = O.Mission
		 <cfif Mandate.DateExpiration gte now() and Mandate.DateEffective lte now()>
		 -- AND    O.DateEffective  <= getDate()
		 -- AND    O.DateExpiration >= getDate()		
		 <cfelse>
		 AND    O.DateEffective  <= '#Mandate.DateExpiration#'
		 AND    O.DateExpiration >= '#Mandate.DateExpiration#'		
		 </cfif>
		 <cfif getAdministrator("#url.mission#") neq "1">
		 
			 AND (
			        O.OrgUnit IN (
				 	
						SELECT OrgUnit
						FROM   Organization.dbo.OrganizationAuthorization 
						WHERE  UserAccount = '#SESSION.Acc#' 
						AND    Mission = '#URL.Mission#'
						AND    Role IN (
									SELECT Role
									FROM   Organization.dbo.Ref_AuthorizationRole
									WHERE  SystemModule = 'Staffing' )
				    	AND    OrgUnit is not NULL )	
				
				   OR
				   
				   O.Mission IN (
				   
				        SELECT Mission
						FROM   Organization.dbo.OrganizationAuthorization 
						WHERE  UserAccount = '#SESSION.Acc#' 
						AND    Mission = '#URL.Mission#'
						AND    Role IN (
									SELECT Role
									FROM   Organization.dbo.Ref_AuthorizationRole
									WHERE  SystemModule = 'Staffing' )
				    	AND    OrgUnit is NULL )
				   
				  )  				
			  
		 </cfif>
	</cfquery>
	
	<cfset vMission=Mandate.Mission>
		
<cfelse>

	<cfquery name="Tree" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT O.*,
		        M.MissionName
		 INTO   userquery.dbo.#SESSION.acc#_MissionOrganization
		 FROM   Organization O,Ref_Mission M
		 WHERE  O.Mission   = '#Mission.TreeAdministrative#'	
		 AND    O.MandateNo = '#Mandate.MandateNo#' 	
		 AND    O.Mission   = M.Mission
		 
		 <cfif Mandate.DateExpiration gte now() and Mandate.DateEffective lte now()>
		 -- AND    O.DateEffective  <= getDate()
		 -- AND    O.DateExpiration >= getDate()		
		 <cfelse>
		 AND    O.DateEffective  <= '#Mandate.DateExpiration#'
		 AND    O.DateExpiration >= '#Mandate.DateExpiration#'		
		 </cfif>
		 
		<cfif getAdministrator("#url.mission#") neq "1">
		 
			 AND (
			        O.OrgUnit IN (
				 	
						SELECT OrgUnit
						FROM   Organization.dbo.OrganizationAuthorization 
						WHERE  UserAccount = '#SESSION.Acc#' 
						AND    Mission = '#URL.Mission#'
						AND    Role IN (
									SELECT Role
									FROM   Organization.dbo.Ref_AuthorizationRole
									WHERE  SystemModule = 'Staffing' )
				    	AND    OrgUnit is not NULL )	
				
				   OR
				   
				   O.Mission IN (
				   
				        SELECT Mission
						FROM   Organization.dbo.OrganizationAuthorization 
						WHERE  UserAccount = '#SESSION.Acc#' 
						AND    Mission = '#URL.Mission#'
						AND    Role IN (
									SELECT Role
									FROM   Organization.dbo.Ref_AuthorizationRole
									WHERE  SystemModule = 'Staffing' )
				    	AND    OrgUnit is NULL )
				   
				  )  				
			  
		 </cfif>
		 
	</cfquery>
	
	<cfset vMission=Mission.TreeAdministrative>
	
</cfif>

 <table>
 
    			 		   
    <cf_OrgTreeLevel 
	    level     = "1" 
		maxlevel  = "#url.maxlevel#" 
		direction = "vertical" 
		parent    = ""
		selectiondate = "#dateformat(url.selectiondate,client.dateFormatShow)#"
		panel     = "Left"
		width     = "170"
		nme       = "#url.Mission#"
		orgunit   = "NULL"		
		PostClass = "#URL.PostClass#"
		Fund 	  = "#URL.Fund#"
		Layout	  = "#URL.Layout#"
		Tree	  = "#URL.Tree#">		
						
</table>	


<script>
	Prosis.busy('no')
</script>