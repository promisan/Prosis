<cfif url.orgUnitImplementer neq "">
	
	<cftry>
		
		<cfquery name="insert" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO WorkOrderImplementer (
						WorkOrderId,
						OrgUnit,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName )
				VALUES ('#url.WorkOrderId#',
						'#url.orgUnitImplementer#',
						'#session.acc#',
						'#session.last#',
						'#session.first#' )
		</cfquery>
		
		<cfcatch></cfcatch>
		
	</cftry>
	
	<cfif url.rollover eq "true">
	
		<cfquery name="get" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT 	*
				FROM 	Organization.dbo.Organization
				WHERE	OrgUnit   = '#url.orgUnitImplementer#'			
		</cfquery>	
		
		<cfparam name="url.mission"   default="#get.mission#">
		<cfparam name="url.mandateno" default="#get.mandateno#">
		
		<cfquery name="getHierarcy" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT 	*
				FROM 	Organization.dbo.Organization
				WHERE	OrgUnit   = '#url.orgUnitImplementer#'
				AND		Mission   = '#get.mission#'
				AND		MandateNo = '#get.mandateNo#' 
				
		</cfquery>
		
		<cfquery name="getChildren" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT 	*
				FROM 	Organization.dbo.Organization
				WHERE	HierarchyCode LIKE '#getHierarcy.HierarchyCode#%'
				AND		OrgUnit     != '#url.orgUnitImplementer#'
				AND		Mission      = '#get.mission#'
				AND		MandateNo    = '#get.mandateNo#' 
				
		</cfquery>
		
		<cfloop query="getChildren">
		
			<cftry>
			
				<cfquery name="insertChildren" 
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO WorkOrderImplementer (
								WorkOrderId,
								OrgUnit,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName )
						VALUES ('#url.WorkOrderId#',
								'#getChildren.orgUnit#',
								'#session.acc#',
								'#session.last#',
								'#session.first#' )
				</cfquery>
				
				<cfcatch></cfcatch>
			</cftry>
			
		</cfloop>
				
	</cfif>
	
</cfif>

<cfquery name="lines" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	O.*,
				(REPLICATE ('&nbsp;',2*(LEN(O.HierarchyCode)-2))) as OrgUnitNameSpaces
		FROM 	WorkOrderImplementer I INNER JOIN Organization.dbo.Organization O ON I.OrgUnit = O.OrgUnit
		WHERE 	O.Mission     = '#url.mission#'
		AND		O.MandateNo   = '#url.mandateNo#'	
		AND		I.WorkOrderId = '#url.workOrderId#'
		ORDER BY O.HierarchyCode, O.TreeOrder
</cfquery>

<table width="98%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<cfif lines.recordCount eq 0>
	
		<tr><td colspan="3" class="labelmedium" style="color:808080;" align="center">[<cf_tl id="No OrgUnits Associated">]</td></tr>
		
	</cfif>
		
	<cfoutput query="lines">
	
		<tr class="navigation_row">
			<td>
				<table cellspacing="0" cellpadding="0">
				
					<tr>
						<td class="labelit">#OrgUnitNameSpaces#</td>
						
						<td style="width:40px" align="center">
							
							<cfquery name="validate" 
								datasource="appsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT	*
									FROM	WorkOrderLine
									WHERE	WorkOrderId = '#url.workOrderId#'
									AND		OrgUnitImplementer = '#orgUnit#'
							</cfquery>
							
							<cfif validate.recordCount eq 0>
								<cf_img icon="delete" onclick="deleteImplementerOrgUnit('#url.mission#','#url.mandateNo#','#url.workOrderId#','#orgUnit#');">
							</cfif>
							
						</td>
						
						<td class="labelit" style="padding-left:5px;">#OrgUnitCode#</td>
						<td class="labelit" style="padding-left:5px;">#OrgUnitName#</td>
						
					</tr>
					
				</table>
			</td>
		</tr>
	</cfoutput>

</table>

<cfset ajaxonload="doHighlight">

<!--- refresh the trigger --->
<cfoutput>
	<script>
	    _cf_loadingtexthtml='';	
		ptoken.navigate('#SESSION.root#/Workorder/Application/WorkOrder/Implementer/Implementer.cfm?workOrderId=#url.workOrderId#','divImplementers');
	</script>
</cfoutput>	
