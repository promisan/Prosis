<!--- retrieve the item --->

<cfparam name="url.orgunit"   default="">
<cfparam name="url.warehouse" default="">

<cfif url.orgunit eq "">

	<!--- retrieve unit from assignment --->

	 <cfquery name="check" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
        password="#SESSION.dbpw#">
    	    SELECT 	O.OrgUnit, O.OrgUnitName
        	FROM 	PersonAssignment P, Organization.dbo.Organization O
    		WHERE	P.DateEffective  <= getDate() 
			  AND   P.DateExpiration >= getDate()
			  AND   P.Incumbency > '0'
			  AND   P.AssignmentStatus < '8' <!--- planned and approved --->
              AND   P.AssignmentClass = 'Regular'
              AND   P.AssignmentType  = 'Actual'
         	  AND   P.OrgUnit = O.OrgUnit
    		  AND   P.PersonNo = '#CLIENT.PersonNo#'
			  AND   O.Mission = '#url.mission#'
     </cfquery>		
	 
	 <cfif check.recordcount gte "1">
	 
	    <cfset url.orgunit = check.orgunit>
		
	<cfelse>	
						
			<!--- check if this is consistently used --->
										
			<cfquery name="checklast" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	    	    SELECT 	 TOP 1 OrgUnit
	        	FROM 	 Request
	    		WHERE	 OfficerUserId    = '#SESSION.acc#' 
				AND      Mission          = '#url.mission#'		
				AND      Created > getDate() - 30		
				ORDER BY Created DESC									
		    </cfquery>	
			
			<cfif checklast.recordcount eq "1">	
									
				<cfset url.orgunit = checklast.orgunit>	
			
			<cfelse>					
					
				<cfquery name="getWarehouse" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		    	    SELECT 	 TOP 1 O.OrgUnit
		        	FROM 	 Warehouse W, Organization.dbo.Organization O, WarehouseCart C
		    		WHERE	 C.Warehouse = '#url.warehouse#' 
					AND      C.ShipToWarehouse = W.Warehouse
					AND      C.UserAccount = '#SESSION.acc#'					
					AND      W.MissionOrgUnitId = O.MissionOrgUnitId								
					ORDER BY O.Created DESC								
			    </cfquery>		  
													    			
				<cfset url.orgunit = "#getWarehouse.OrgUnit#">
			
			</cfif>
				 	 
	 </cfif>
	 	 
</cfif>		

<cfquery name="Get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Organization
		WHERE    OrgUnit = '#url.orgunit#'		
</cfquery>

<cfoutput>
			
	<script language="JavaScript">				   
		try { document.getElementById('orgunit').value = "#url.orgunit#" } catch(e) {}
	</script>		
		
	<table width="100%" cellspacing="0" cellpadding="0">	
		<tr><td width="90%" class="labelmedium" style="height:20;padding-left:3px">#get.orgunitcode# #get.OrgUnitName#</td></tr>	
	</table>	

</cfoutput>

