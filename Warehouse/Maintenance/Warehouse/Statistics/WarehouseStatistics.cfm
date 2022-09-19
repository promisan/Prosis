

<cfparam name="url.showPrint" default="1">

<cfquery name="warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM   	Warehouse
	WHERE  	Warehouse = '#url.warehouse#'
</cfquery>

<cfif url.showPrint eq 1>
	<div id="divPrintButton" align="right" style="padding-right:20px;">
						
		<cfoutput>
			<img src="#SESSION.root#/images/print.png" 
					height="20" 
					style="cursor:pointer;" 
					title="printable version" 
					onclick="printStatistics('#url.warehouse#', '', 'divStatisticsWarehouse');">
		</cfoutput>
		
	</div>
</cfif>

<div id="divStatisticsWarehouse" style="padding:10px">

	<table width="98%" align="center">
	
		<tr><td width="100%" style="padding:20px">
			
			<table width="100%" align="center">
			
				<tr>
					<td style="padding:10px">
						
								<table width="100%" cellspacing="0" align="center" class="clsPrintable formspacing">
									
									<cfoutput>
				
										<!--- --------------------------- --->
										<!--- ------Storage locations---- --->
										<!--- --------------------------- --->
										
										<tr>
											<td width="200" class="labelit" style="border-bottom:1px dotted ##C0C0C0;"><cf_tl id="Number of storage locations">:</td>
											<td class="label" style="border-bottom:1px dotted ##C0C0C0; border-left:1px dotted ##C0C0C0;">	
												
											<cfquery name="get" 
												datasource="AppsMaterials" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												SELECT 	*
												FROM   	WarehouseLocation L
												WHERE  	Warehouse = '#url.warehouse#'
												AND		Operational = 1
											</cfquery>
											
											<table>
												<tr><td class="labelit" style="padding-left:4px">#get.recordcount#</td></tr>
											</table>
											
											</td>
										</tr>
																		
										<!--- --------------------------- --->
										<!--- ------Items --------------- --->
										<!--- --------------------------- --->
										
										
																		
										<tr>
											<td class="labelit" style="border-bottom:1px dotted ##C0C0C0;"><cf_tl id="Top 3 items">:</td>
											<td class="labelit" style="border-bottom:1px dotted ##C0C0C0; border-left:1px dotted ##C0C0C0;">
																						
											<cfquery name="get" 
												datasource="AppsMaterials" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT   	TOP 5 ItemNo, 
													            ItemDescription, 
																count(*)
													FROM   	    ItemTransaction L 
													WHERE  	    Warehouse = '#url.warehouse#'			
													AND         TransactionType = '2' 
													GROUP BY    ItemNo, ItemDescription
													ORDER BY    Count(*) DESC	
											</cfquery>
											
											<table width="100%">
											<cfloop query="get">
											<tr><td class="labelit" style="padding-left:4px">#ItemDescription#</td></tr>
											</cfloop>	
											</table>
											
											</td>
										</tr>
										
										<cfquery name="getStock" 
											datasource="AppsMaterials" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											SELECT 	  SUM(TransactionQuantity), 
													  SUM(TransactionValue) as TransactionValue
											FROM   	  ItemTransaction L 
											WHERE  	  Warehouse = '#url.warehouse#'												
											HAVING    SUM(TransactionQuantity) > 0			
																
										</cfquery>
																				
										<tr>
											<td class="labelit" style="border-bottom:1px dotted ##C0C0C0;"><cf_tl id="Total value of stock">:</td>
											<td class="labelit" style="border-bottom:1px dotted ##C0C0C0; border-left:1px dotted ##C0C0C0;">
												<table>
													<tr><td style="padding-left:4px" class="labelit">#numberFormat(getStock.TransactionValue,',.__')#</td></tr>
												</table>
											</td>
										</tr>
																			
										<tr>
											<td class="labelit" style="border-bottom:1px dotted ##C0C0C0;"><cf_tl id="Assigned stock officers">:</td>
											<td class="labelit" style="border-bottom:1px dotted ##C0C0C0; border-left:1px dotted ##C0C0C0;">
											
											<cfquery name="getUser" 
												datasource="AppsOrganization" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												SELECT DISTINCT OA.OfficerUserId, U.FirstName, U.LastName
												FROM      OrganizationAuthorization OA INNER JOIN
										                  System.dbo.UserNames U ON OA.UserAccount = U.Account
												WHERE     OA.Role = 'WhsPick'
												AND       OA.OrgUnit IN
										                          (SELECT    OrgUnit
										                            FROM     Organization
										                            WHERE    MissionOrgUnitId = '#warehouse.MissionOrgUnitId#')		
												
											</cfquery>
											
											<table>
											<cfloop query="getUser">
												<tr><td class="labelit" style="padding-left:4px">#FirstName# #LastName# (#OfficerUserId#)</td></tr>
											</cfloop>	
											</table>										
											
											</td>
										</tr>
										
										<tr>
											<td class="labelit"><cf_tl id="Assigned stock request managers">:</td>
											<td class="labelit" style="border-left:1px dotted ##C0C0C0;">
											
											<cfquery name="getUser" 
												datasource="AppsOrganization" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												SELECT DISTINCT OA.OfficerUserId, U.FirstName, U.LastName
												FROM      OrganizationAuthorization OA INNER JOIN
										                  System.dbo.UserNames U ON OA.UserAccount = U.Account
												WHERE     OA.Role = 'WhsShip'
												AND       OA.OrgUnit IN
										                          (SELECT     OrgUnit
										                            FROM          Organization
										                            WHERE      MissionOrgUnitId = '#warehouse.MissionOrgUnitId#')		
												
											</cfquery>
											
											<table>
											<cfloop query="getUser">
												<tr><td class="labelit" style="padding-left:4px">#FirstName# #LastName# (#OfficerUserId#)</td></tr>
											</cfloop>	
											</table>
												
											</td>
										
										</tr>
										
									</cfoutput>
																		
								</table>
						
					</td>
				</tr>
					
			</table>
				
			</td>
	
	</tr>
	
	<tr><td height="10"></td></tr>
	
	<!---
	
	<tr>
	
		<td colspan="2">
		
			<table width="98%" align="center" style="padding:10px">
				<tr>
					<td width="100%">
						<cfset url.viewPort 				= "225">
						<cfset url.graphColumns				= 2>
						<cfset url.showTooltip				= 1>
						<cfset url.showTotalGraphs			= 0>
						<cfset url.fontSize					= 10>
						<cfinclude template="ShowTotalStock.cfm">
					</td>
				</tr>
			</table>
			
		</td>

	</tr>
	
	
	
	<tr><td height="10"></td></tr>
	
	<tr>
	
		<td  colspan="2">
	
		<table width="98%" align="center" style="padding:10px">
		
			<tr>
				<td width="100%">
				
					<cfset url.location 				= "">
					<cfset url.viewPort 				= "225">
					<cfset url.graphColumns				= 2>
					<cfset url.showLocationDescription	= 1>
					<cfset url.showTooltip				= 1>
					<cfset url.showPrint				= 0>
					<cfset url.fontSize					= 10>
					<cfinclude template="../../WarehouseLocation/LocationStatistics/LocationStatistics.cfm">
				</td>
			</tr>
			
		</table>
	
		</td>
		
	</tr>
	
	--->
	
	</table>
	
</div>