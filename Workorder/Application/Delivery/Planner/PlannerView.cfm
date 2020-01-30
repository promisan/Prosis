<cfparam name = "url.print" default ="no">

<cfinclude template="../getTreeData.cfm">

<cfset url.dts = url.date>

<!--- selected deliveries --->
<cfinclude template="getPlannerData.cfm">
<cfinclude template="WorkPlanTopicPreparation.cfm">


<cfif Deliveries.recordcount eq "0">
	
	<table align="center"><tr><td style="height:60" align="center" class="labelmedium">No records found to show in this view.</td></tr></table>
	
	<script>
		Prosis.busy('no')
	</script>
	
	<cfabort>

</cfif>

<!--- scheduler / planner --->

<table width="100%" height="100%" border="0" cellpadding="0">
	
	<tr>
		
		<td valign="top" style="height:100%;border-right:0px solid silver">
		
			<table border="0" width="99%" height="100%">
							
			<tr>
				<td valign="top" style="border-right:0px solid silver">
				
				<cfoutput>
				
				<table width="100%" style="padding:4px;border:0px dotted silver">
				
				<cfif person eq "">
				
				<tr> 
				<td class="labelit" colspan="7">
				
				<table class="formpadding formspacing">
				<tr class="labelmedium">	
				
				    <td>
					
					<cfinvoke component = "Service.Presentation.TableFilter"  
						   method           = "tablefilterfield" 
						   filtermode       = "direct"
						   name             = "filtersearch"
						   label            = "Find"
						   style            = "font:14px;height:25;width:100"
						   rowclass         = "clsDeliveryRow"
						   rowfields        = "ccontent">
					
					</td>
								
					<td>
					<table  class="formpadding formspacing">
						<tr class="labelmedium">
						<td style="padding-left:0px"><input type="radio" onclick="planninglist()" class="radiol" name="activitymode" value="0"></td><td style="padding-left:3px" class="radiol"><cf_tl id="Pending"></td>
						<td style="padding-left:5px"><input type="radio" onclick="planninglist()" class="radiol" name="activitymode" value="1"></td><td style="padding-left:3px" class="radiol"><cf_tl id="Scheduled"></td>
						<td style="padding-left:5px"><input type="radio" onclick="planninglist()" class="radiol" name="activitymode" value="" checked></td><td style="padding-left:3px" class="radiol"><cf_tl id="Any"></td>
						</tr>		
					</table>		
					</td>
				</tr>
				</table>
				</td></tr>
				
				</cfif>
								
				<tr>
													
				    <td style="width:400;padding-left:4px" colspan="1">
					<table style="width:95%;height:23px;padding-left:4px;border:0px solid silver">
						<tr>
						
						<!---
						
						<td bgcolor="E6E6E6" class="labelmedium" style="border:1px solid silver;cursor:pointer;height:40px;padding:6px" onClick="javascript:dssplanning()">
												
						<table align="center">
							<tr><td align="center"><img src="#session.root#/images/Logos/WorkOrder/Planner/Planner.png" alt="" width="32" height="32" border="0"></td></tr>
							<tr><td class="labelmedium" style="height:16px"><font color="0080C0"><u><cf_tl id="Wizard"></font></td></tr>
						</table>
						
						
						</td>			
						
						--->			
						
						<td class="labelmedium" style="width:99%;padding-left:20px">
						
						<table width="100%" align="center">
							<tr>
							<td class="labelmedium"><cf_tl id="Selected driver for manual planning">:</td>
							</tr>
							<tr>
							<td width="100%" align="center">
								<table width="100%"><tr><td align="center" bgcolor="E6E6E6" id="positionbox" style="font-size:35px;height:25px;border:1px solid silver"></td></tr></table>
							</td>
							</tr>
						</table>		
						</td>
						
						<td>
						<input type="hidden" id="personno"  value="">
				  	    <input type="hidden" id="positionno" value="">
						</td>											
						</tr>
					</table>
					</td>
															
				</tr>
								
				</cfoutput>
				</table>
				</td>
			</tr>				
					
			<tr><td style="height:100%;padding-top:3px;padding-right:5px" valign="top" class="labelmedium">
						
					<cf_divscroll  id="plannercontent">								
						<cfinclude template="PlannerListingContent.cfm">		
					</cf_divscroll>		
									
				</td>
					
			</tr>		
					
			</table>
			
		</td>	
				
		<script>
			Prosis.busy('no')
		</script>			
				
		<td width="460" height="100%" valign="top" style="padding-left:4px;padding-right:5px">	
						
			<table height="100%" border="0" width="99%">				
						
			<cfoutput>
			<tr class="line">
				<td valign="top" style="padding-top:3px;padding-left:9px;font-size:16px;height:30px" class="labelmedium">
					<table align="center" border="0" width="100%"> 
						<tr>
							<td class="labelmedium">Workplan #dateformat(dts,client.dateformatshow)#</b></td>
							<td align="right">
								<a href="javascript:ColdFusion.navigate('Planner/PlannerReportPrint.cfm?scope=all&dts=#URL.dts#&mission=#URL.Mission#','process','','','POST','mapform')">
		 							<img src="#SESSION.root#/images/print.png" height="22" width="22" align="absmiddle" alt="Planner" border="0"></a>
		 						
								<!--- <a href="javascript:ColdFusion.navigate('Planner/PlannerReportPrint.cfm?dts=#URL.dts#&mission=#URL.Mission#&planner=0','process','','','POST','mapform')">
		 						<img src="#SESSION.root#/images/print.png" height="25" width="25" align="absmiddle" alt="Deliveries" border="0"></a>
								--->
		 					</td>
						</tr>
					</table>
					
				</td>
			</tr>
			</cfoutput>		
													
			<tr><td valign="top">	
			
				<cf_divscroll>		
			   			
					<cfinclude template="WorkPlanActor.cfm">					 					
					
				</cf_divscroll>	
				
			</td></tr>
			
			</table>
						
		</td>		
		
	</tr>
	
</table>
