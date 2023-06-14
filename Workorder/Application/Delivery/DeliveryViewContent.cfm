
<cfparam name="url.date" 	 default="#dateformat(now(),client.dateformatshow)#">
<cfparam name="url.loadmode" default="full">
<cfparam name="url.step" 	 default="">
<cfparam name="url.init" default="0">

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>		
	
	<cfquery name="Branch"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT F.OrgUnit,
			       F.OrgUnitName,
			       F.OrganizationCategory,
					   (SELECT MarkerColor 
						FROM   Organization.dbo.vwOrganizationAddress 
						WHERE  OrgUnit     = F.OrgUnit 
						AND    AddressType = 'Office') as MarkerColor,
				   SUM(Requested) as Requested,				  
				   SUM(Planned) as Planned
					  
			FROM (  	   
				  
				<!--- requested and scheduled actions --->   
			
				SELECT   O.OrgUnit,
				         O.OrgUnitName, 
					  	 1 as Requested,
					  	 OC.OrganizationCategory,				 						 
						 
					 	 <!--- check if the action has been scheduled for today --->
						 (
						 SELECT    COUNT(*) 
						 FROM      WorkPlan AS W INNER JOIN
	                               WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId
						 WHERE     W.Mission        = '#url.mission#'
						 AND       W.DateEffective  <= #dts# 
						 AND       W.DateExpiration >= #dts#
						 AND       D.WorkActionId = A.WorkActionId ) as Planned						
						 
			    FROM     WorkOrder AS W INNER JOIN						
		                 WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
		                 WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine LEFT OUTER JOIN 
					     Organization.dbo.Organization AS O ON W.OrgUnitOwner = O.OrgUnit LEFT OUTER JOIN
					     Organization.dbo.OrganizationCategory OC ON O.OrgUnit = OC.Orgunit LEFT OUTER JOIN 
					     Organization.dbo.Ref_OrganizationCategory ROC ON ROC.Code = OC.OrganizationCategory AND ROC.Area='Location'
						 
			    WHERE    W.Mission          = '#url.mission#'
				AND      A.ActionClass      = 'Delivery' 
				AND      A.DateTimePlanning = #dts#  			    	
				AND      WL.Operational     = '1'
				AND      W.ActionStatus != '9'
			
			) F
			
		    GROUP BY F.OrgUnit, F.OrgUnitName, F.OrganizationCategory
		    ORDER BY F.OrganizationCategory,F.OrgUnitName			
			 
	</cfquery>	
		

<table cellspacing="0" height="100%" width="100%" align="center">
			
	<tr>	
	<td height="100%" valign="top" style="padding:10px;height:100%">			

		<cfif Branch.recordcount eq "0">
		
		<table align="center"><tr><td class="labelmedium"><font color="808080"><cf_tl id="There are no deliveries recorded for today"></td></tr></table>
		
		<cfelse>
					
			<table width="99%" cellspacing="0" cellpadding="0" navigationhover="transparent" class="navigation_table">						   
				
				<cfset vCluster = "">
				
				<cfquery name="get" 
				 datasource="AppsSystem"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT   TOP 1 * 
					FROM     Ref_ModuleControl					
				</cfquery>	
				
				<cfoutput query="Branch">
				
						<cfif vCluster neq OrganizationCategory>
							<cfset vCluster = OrganizationCategory>
							<tr><td style="height:6px"></td></tr>
							<tr>
								<td colspan="11" style="border-top:1px solid gray"></td>
							</tr>	
							<tr><td style="height:6px"></td></tr>
							
						</cfif>
																										
						<tr class="labelmedium2 navigation_row line fixlengthlist" 
						    id="rowselection_#OrgUnit#" 
							name="rowselection_#OrgUnit#">
							
							<td class="navigation_pointer" style="min-width:18px;max-width:18px"></td>	
							<td width="100%" title="#orgunitname#" style="height:19px;cursor:pointer">#orgunitname#</td>		
							
							<td><cf_img icon="edit" navigation="Yes"  onclick="viewOrgUnit('#orgunit#')"></td>								
							
							<td align="right" style="padding:3px">
							
								<table cellspacing="0">
									<tr><td  bgcolor="#markercolor#" width="11" height="11" cellpadding="0" style="border-radius:2px;border:1px solid black">&nbsp;&nbsp;&nbsp;</td></tr>
								</table>
							
							</td>		
												
							<cfif requested eq planned>
								<cfset cl = "white">
							<cfelse>
								<cfset cl = "ffffaf">	
							</cfif>
							
							<!--- this is part of an automatic scheduled ajax refresh --->
							<td class="hide" id="content_#get.SystemFunctionId#_#orgunit#_refresh" 
							     onclick="ptoken.navigate('getOrgUnitStatus.cfm?mission=#url.mission#&date=#url.date#&orgunit=#orgunit#','planner_#orgunit#')"></td>		
														
							<td colspan="3" id="planner_#orgunit#">
							
								<table>
									<tr class="labelmedium">	
									<td align="right"  bgcolor="#cl#" style="padding-left:3px">#Requested#</td>	
									<td align="center" bgcolor="#cl#" style="width:3px;padding-left:3px;padding-right:3px">|</td>			
									<td align="left"   bgcolor="#cl#" style="padding-right:3px">#Planned#</td>	
									</tr>
								</table>
							
							</td>
							
							<td colspan="2">
							
								<cfif currentrow eq "1">
									<cf_space spaces="25">
								</cfif>
							
							    <table id="box_#orgunit#" class="hide">
									<tr>
									
									<td style="padding-left:2px">
										<input id="detail_#orgunit#" type="checkbox" style="height:12px;width:12px" value="1" onclick="unitdetail(this.checked,'rowdetail_#OrgUnit#','#orgunit#')">
							
									</td>
									
									<td style="padding-left:7px;height:30px">
									
									<cfset cl = "FFFF00">
									
									<select name="color_#orgunit#" style="font:11px" onchange="reloadcontent()">
										<option value="000000" <cfif cl eq "000000">selected</cfif>>Black</option>
										<option value="FFFF00" <cfif cl eq "FFFF00">selected</cfif>>Yellow</option>							
										<option value="FF0000" <cfif cl eq "FF0000">selected</cfif>>Red</option>
										<option value="008000" <cfif cl eq "008000">selected</cfif>>Green</option>
										<option value="FFFFFF" <cfif cl eq "FFFFFF">selected</cfif>>White</option>
										<option value="0000FF" <cfif cl eq "0000FF">selected</cfif>>Blue</option>
									</select>						
									
									</td>							
									
									</tr>
								
								</table> 	
													
							</td>			
							<td width="20" align="right" style="padding-right:3px">
	
								<cfif url.step neq "final">		
											
									<input  type="checkbox" style="height:15px;width:15px;position: relative;" name="select_#OrgUnit#" id="select_#OrgUnit#" value="1" onclick="toggle(this.checked,'box_#orgunit#','partial','rowdetail_#OrgUnit#','#orgunit#')" class="selector">
								</cfif>					
							
							</td>
						</tr>	
						
						<tr class="hide" id="rowdetail_#OrgUnit#">
						    <td id="rowdetail_#OrgUnit#_content" colspan="9"></td>
						</tr>	
																	
				</cfoutput>												
																	
				<cfinvoke component = "Service.Connection.Connection"  
				   method           = "setconnection"   
				   object           = "deliverycenter"
				   scopeid          = "#get.SystemFunctionId#" 
				   scopefilter      = "#url.date#"  
				   objectcontent    = "#branch#"  
				   delay            = "15">
				   			   	  						
				<!--- select recent drivers --->
			
				<cfif url.loadmode eq "full">
								
					<tr><td colspan="4" class="labelmedium" style="padding-left:25px"><b><cf_tl id="Driver"></td></tr>																
					<tr><td height="100%" colspan="10" id="actor">						
					    <cfinclude template="DeliveryViewActor.cfm">													
					</td></tr>
						
				</cfif>					
								
				</table>	
			
		</cfif>
					
	</td>											
	</tr>			
											
</table>

<cfquery name="Total" dbtype="query">

	SELECT SUM(Requested) as Requested, 
	       SUM(Planned) as Planned
	FROM   Branch
	
</cfquery>	

<cfoutput>		
	
	<cfif url.loadmode eq "full">
		
		<cfquery name="getLock"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				
				SELECT   W.WorkOrderId
							 
			    FROM     WorkOrder AS W INNER JOIN						
		                 WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
		                 WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 
																	 
			    WHERE    W.Mission          = '#url.mission#'
				AND      A.ActionClass      = 'Delivery' 
				AND      A.DateTimePlanning = #dts#  			    	
				AND      WL.Operational     = '1'
				AND      W.ActionStatus = '0'
						   
		</cfquery>	
	
	    <cfset client.totalPlanned = total.Planned>
	
		<script>
		
			 document.getElementById('order').innerHTML     = "#total.Requested#"
			 document.getElementById('scheduled').innerHTML = "#total.Planned#"			
			 <cfif getlock.recordcount gte "1">			
			 document.getElementById('lock').className      = "regular"
			 <cfelse>			
			 document.getElementById('lock').className      = "hide"
			 </cfif>
		</script>
						
		<cfif url.init eq "1">
			<script>			
				 reloadcontent('full')
			</script>
		</cfif>
		
		<cfset AjaxOnload("doHighlight")>	
	<cfelse>
		<cfset ajaxOnLoad("block_selection")>				
	</cfif>	

</cfoutput>

<cfif url.init eq "0">
	<script>	
		Prosis.busy('no')
	</script>
</cfif>




