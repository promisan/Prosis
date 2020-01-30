
<cfparam name="URL.ID4" default="default">
<cfset Mission = "#Attributes.Mission#">

<cfquery name="CurrentMandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT TOP 1 *
      FROM   Ref_Mandate
   	  WHERE  Mission = '#Mission#' 
	  ORDER BY MandateDefault DESC
</cfquery>

<!--- General correct by Hanno on 23/07/2012 as warehouse granted access is not mandate sensitive
and is driven by the role we adjust the entries in OrganizationAuthorization to reflect the OrgUnit of the current mandate 
which is derrived through the missionorgunitid --->

<cfinvoke component="Service.Access.AccessLog"  
		  method       = "SyncWarehouseAccess"
		  Mission      = "#Mission#"
		  Role         = "#URL.ID4#">	 
		      
<cftree name="root"
   font="Calibri"
   fontsize="12"		
   bold="No"   
   format="html"    
   required="No">   	
		
		<cfoutput>
		
		  <cftreeitem value="#Mission#"
		      display="<span class='labelmedium'><b>#Mission# #CurrentMandate.Description#</span>"
			  parent="Root"		
			  target="right"
			  href="OrganizationListing.cfm?Mission=#Mission#&ID4=#URL.ID4#"					
		      expand="Yes">
			  				
			<cfquery name="City" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT DISTINCT City
				  FROM  Materials.dbo.Warehouse W
				  WHERE Mission = '#Mission#'      
			</cfquery>
			
			<cfloop query="City">
				
				<cftreeitem value="#mission#_#currentrow#"
			        display="<div class='labelmedium'>#City#"
					parent="#Mission#"				
					expand="No">	
		
				  <cfquery name="Warehouse" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT DISTINCT O.TreeOrder, O.OrgUnitName, O.OrgUnit, O.OrgUnitCode, W.WarehouseName 
				      FROM  #Client.LanPrefix#Organization O, Materials.dbo.Warehouse W
				   	  WHERE O.MissionOrgUnitId = W.MissionOrgUnitId
					  AND   W.Mission          = '#Mission#'
					  AND   O.MandateNo        = '#CurrentMandate.MandateNo#'
					  AND   W.City             = '#City#'
					  ORDER BY TreeOrder, OrgUnitName 
				  </cfquery>
				  
				  <cfset parent = "#mission#_#currentrow#">
				  
				  <cfloop query="Warehouse">
				  
				  	<cftreeitem value="#mission#_#WarehouseName#"
				        display="#WarehouseName#"
						parent="#parent#"		
						href="OrganizationListing.cfm?ID0=#OrgUnit#&ID1=#OrgUnit#&Mission=#Mission#&ID3=#CurrentMandate.MandateNo#&ID4=#URL.ID4#"	
						target="right"
						expand="No">		  
					    
				  </cfloop>
				  
				  <cftreeitem value="dummay"
			        display=""
					parent="#parent#"				
					expand="No">					  
			  
			  </cfloop>
			      
		</cfoutput>
		
</cftree>


