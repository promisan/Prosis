
<!--- shows the tree of the units --->

<cfparam name="url.mode" default="unit">
<cfset client.orgmode = "Tree">

<cfif url.mode eq "unit">
<cfparam name="url.width"    default="140">
<cfelse>
<cfparam name="url.width"    default="150">
</cfif>


<cfquery name="Org" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Organization
	 WHERE  OrgUnit = '#URL.OrgUnit#'	
</cfquery>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_MissionOrganization"> 

   <!--- create temp table for better performance --->

  <cfquery name="Tree" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT O.*,M.MissionName
	 INTO   userquery.dbo.#SESSION.acc#_MissionOrganization
	 FROM   Organization O, Ref_Mission M
	 WHERE  O.Mission   = '#Org.Mission#'
	 AND    O.MandateNo = '#Org.MandateNo#'
	 AND	M.Mission   = O.Mission	  	
	
</cfquery>

    <table>
	     <tr><td height="6"></td></tr>
		 <tr>
		 		 
		 	<cfif url.mode eq "tree">
			
			   <cf_OrgTreeLevel 
			    level     = "1" 				
				direction = "horizontal" 	
				parent    = ""			
				unit      = ""		
				width     = "#url.width#"				
				nme       = "#Org.Mission#">				
			
			<cfelse>
					
			  <cf_OrgTreeLevel 
			    level     = "1" 				
				direction = "horizontal" 
				parent    = "#Org.OrgUnitCode#"		
				unit      = "#url.orgunit#"		
				width     = "#url.width#"				
				nme       = "#Org.OrgUnitName#">
			
			</cfif>
		 		   
		   
		 </tr>
	</table>
	