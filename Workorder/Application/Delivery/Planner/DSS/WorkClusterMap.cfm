<cfparam name="URL.date" 		default = "06/01/2015">
<cfparam name="URL.starttime" 	default = 7>
<cfparam name="URL.id" 			default = "">
<cfparam name="URL.desc"		default = "">
<cfparam name="URL.loadmode"    default = "">

<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>		

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfinclude template="../../getTreeData.cfm">

<cfif URL.Id eq "">
	<cfset URL.Step="Final">
</cfif>	

<cfquery name="qFlow"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	  SELECT F.Date,
	         F.Node,
	         F.ListingOrder,
	         OP.Icon,
	         F.Distance,
	         F.Duration,
	         N.OrgUnitOwner,
	         N.Latitude,
	         N.Longitude,
	         N.Branch,
	         N.ZipCode,
	         N.CustomerName,
	         O.OrgUnitName,
	         P.Step,
	         N.WorkOrderLineId,
	         F.ActionStatus
	  FROM   stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# F INNER JOIN stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N
		ON   F.Node = N.Node AND F.Date = N.Date INNER JOIN Organization.dbo.Organization O
		ON   N.OrgUnitOwner  = O.OrgUnit INNER JOIN stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# P
		ON   P.RouteId       = F.RouteId LEFT OUTER JOIN WorkOrder.dbo.Ref_PlanOrder OP ON F.PlanOrder = OP.Code  
	  WHERE  
	  <cfif URL.Step eq "Final">
	  		F.Date         = #dts#
	  	AND F.ActionStatus in ('1','1a')
	  <cfelse>
	  	F.RouteId = '#URL.Id#'	
	  </cfif>	 		 
	  AND    F.ActionStatus! = '9'
	  <cfif units neq "">
		UNION
		SELECT  '',
		         N.Node,
		         0,
		         '',
		         0,
		         0,
		         N.OrgUnitOwner,
		         N.Latitude,
		         N.Longitude,
		         N.Branch,
		         N.ZipCode,
		         N.CustomerName,
		         O.OrgUnitName,
		         0,
		         N.WorkOrderLineId,
		         N.ActionStatus
		FROM   stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N INNER JOIN Organization.dbo.Organization O
					ON   N.OrgUnitOwner  = O.OrgUnit 
		WHERE  
    	   N.OrgUnitOwner IN (#units#) 
    	   AND N.Date         = #dts#
    	   AND N.ActionStatus != '1'
    	   AND N.ActionStatus != '9'
	  </cfif>
	  ORDER BY F.ListingOrder ASC
	  
</cfquery>


<cfif url.loadmode eq "">
	<table height="760" border="0" cellspacing="0" cellpadding="0" align="center">
			
	<cfoutput>
	
	<tr>
	
	<td valign="top" style="padding-right:4px" id="dDSteps">
			<cfinclude template="WorkClusterSteps.cfm">		
	</td>
	
	</cfoutput>
			
	<td valign="top" style="padding-top:3px">
		
			
		<cfmap name="gmap"	   
		    centerlatitude   = "52.0319556" 
		    centerlongitude  = "4.369180099999994" 	
		    doubleclickzoom  = "true" 
			collapsible      = "false" 			
		    overview         = "true" 
			continuouszoom   = "true"
			zoomcontrol      = "large3d"
			hideborder       = "true"		
		    scrollwheelzoom  = "true" 		
			showmarkerwindow = "true"
			height           = "760"
			width            = "550"		
		    showscale        = "true"
			tip              = "#SESSION.welcome# DSS" 
		    zoomlevel        = "9"> 		
				
				<cfloop query="qFlow">
	
						<cfswitch Expression="#qFlow.Step#">
							<cfcase value="1">
								<!--- Light Blue --->
								<cfset current_color = "LightBlue">
							</cfcase>	
							<cfcase value="2">
								<!--- Green --->
								<cfset current_color = "Green">
							</cfcase>	
							<cfcase value="3">
								<!--- Red --->
								<cfset current_color = "Red">
							</cfcase>	
							<cfcase value="4">
								<!--- Yellow --->
								<cfset current_color = "Yellow">
							</cfcase>
							<cfcase value="5">
								<!--- Orange --->
								<cfset current_color = "Orange">
							</cfcase>		
							<cfcase value="6">
								<!--- Purple --->
								<cfset current_color = "Purple">
							</cfcase>												
							<cfcase value="7">
								<!--- Black --->
								<cfset current_color = "Black">
							</cfcase>						
							<cfcase value="8">
								<!--- Blue --->
								<cfset current_color = "Blue">
							</cfcase>	
						    <cfdefaultcase>
						       <cfset current_color = "LightBlue">
						    </cfdefaultcase>																						
						</cfswitch>		
	
						
						<cfif qFlow.Branch eq "1">
													
							<cfquery name="getBranchAddress"
								datasource="appsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">			
								 SELECT City,Address1,PostalCode,MarkerColor,MarkerIcon,OrgUnitName
								 FROM   Organization.dbo.Organization O, 
								        Organization.dbo.vwOrganizationAddress A
								 WHERE  O.OrgUnit   = A.OrgUnit
								 AND    O.OrgUnit   = '#qFlow.orgUnitOwner#'
								 AND    AddressType = 'Office'			 
							 </cfquery>					
							
							<cfset vIcon = "#session.root#/images/mapicons/#getbranchaddress.markercolor#_#getbranchaddress.markericon#.png">
							<cfset vTip = "#qFlow.OrgUnitName# (#qFlow.Node#) - Order : #ListingOrder#">

						<cfelse>
	
							<cfset vIcon = "Icons/Composed/#current_color#/#qFlow.icon#.png">						
							<cfset vTip = "#qFlow.CustomerName# (#qFlow.Node#) from #qFlow.OrgUnitName# - Order : #ListingOrder#">

						</cfif>						

						<cfmapitem name="N#qFlow.Node#" 
					      	latitude="#qFlow.latitude#" 
				          	longitude="#qFlow.longitude#"
				          	markericon="#vIcon#"
				          	tip="#vTip#"/>						
							
				</cfloop>
		</cfmap>
		
		</td>	
				
	</tr>	
	</table>

	<cfset AjaxOnLoad("doResetMap")>
		
	
<cfelse>

		<cfloop query="qFlow">

				<cfswitch Expression="#qFlow.Step#">
					<cfcase value="1">
						<!--- Light Blue --->
						<cfset current_color = "LightBlue">
					</cfcase>	
					<cfcase value="2">
						<!--- Green --->
						<cfset current_color = "Green">
					</cfcase>	
					<cfcase value="3">
						<!--- Red --->
						<cfset current_color = "Red">
					</cfcase>	
					<cfcase value="4">
						<!--- Yellow --->
						<cfset current_color = "Yellow">
					</cfcase>
					<cfcase value="5">
						<!--- Orange --->
						<cfset current_color = "Orange">
					</cfcase>		
					<cfcase value="6">
						<!--- Purple --->
						<cfset current_color = "Purple">
					</cfcase>												
					<cfcase value="7">
						<!--- Black --->
						<cfset current_color = "Black">
					</cfcase>						
					<cfcase value="8">
						<!--- Blue --->
						<cfset current_color = "Blue">
					</cfcase>	
				    <cfdefaultcase>
				       <cfset current_color = "LightBlue">
				    </cfdefaultcase>																						
				</cfswitch>		


				<cfquery name="qChildren" dbtype="query">
					SELECT WorkOrderLineId
				    FROM   qFlow
					WHERE  OrgUnitOwner = '#qFlow.OrgUnitOwner#'
					AND    Branch = '0'
				</cfquery>		
				<cfoutput>											
					<cfsavecontent variable="jRelated">[<cfloop query="qChildren">{"name":"#qChildren.WorkOrderLineId#"},</cfloop>{}]</cfsavecontent>
				</cfoutput>					
				<cfif qFlow.Branch eq "1">

					<cfquery name="getBranchAddress"
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
						 SELECT City,Address1,PostalCode,MarkerColor,MarkerIcon,OrgUnitName
						 FROM   Organization.dbo.Organization O, 
						        Organization.dbo.vwOrganizationAddress A
						 WHERE  O.OrgUnit   = A.OrgUnit
						 AND    O.OrgUnit   = '#qFlow.orgUnitOwner#'
						 AND    AddressType = 'Office'			 
					 </cfquery>					
					
					<cfset vIcon = "#session.root#/images/mapicons/#getbranchaddress.markercolor#_#getbranchaddress.markericon#.png">
					
					<cfset vTip = "#qFlow.OrgUnitName# (#qFlow.Node#) - Order : #ListingOrder#">
					<cf_addMarker
					    name="#qFlow.OrgUnitOwner#" 
				      	latitude="#qFlow.latitude#" 
			          	longitude="#qFlow.longitude#"
			          	markericon="#vIcon#"
			          	title="#vTip#"
			          	related="#jRelated#"/>
				<cfelse>
					
					<cfif qFlow.Icon neq "">
						<cfset vIcon = "Icons/Composed/#current_color#/#qFlow.Icon#.png">
					<cfelse>
						<cfset vIcon = "Icons/Red.png">	
					</cfif>	
					
					<cfset vTip = "#qFlow.CustomerName# (#qFlow.Node#) from #qFlow.OrgUnitName# - Order : #ListingOrder#">
					<cf_addMarker
					    name="#qFlow.WorkOrderLineId#" 
				      	latitude="#qFlow.latitude#" 
			          	longitude="#qFlow.longitude#"
			          	markericon="#vIcon#"
			          	title="#vTip#"/>
				</cfif>						
									
		</cfloop>

</cfif>