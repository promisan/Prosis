<cfquery name="getItem" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT  	*
		 FROM      	Item
		 WHERE		ItemNo = '#url.itemNo#'
</cfquery>

<cf_precision number="getItem.ItemPrecision">

<cfquery name="getreq" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT  	R.*,
		 			IU.UoMDescription,
					S.Description as ShipToModeDescription,
					(SELECT Description FROM Ref_Request WHERE Code = R.RequestType) as RequestTypeDescription,
					(SELECT RequestActionName FROM Ref_RequestWorkflow WHERE RequestType = R.RequestType AND RequestAction = R.RequestAction) as RequestActionDescription,
					(SELECT WarehouseName FROM Warehouse WHERE Warehouse = R.SourceWarehouse) as SourceWarehouseName
		 FROM      	ItemWarehouseLocationRequest R
		 			INNER JOIN ItemUoM IU
						ON R.ItemNo = IU.ItemNo
						AND R.UoM = IU.UoM
					INNER JOIN Ref_ShipToMode S
						ON R.ShipToMode = S.Code
		 WHERE		R.Warehouse = '#url.warehouse#'
		 AND       	R.Location = '#url.location#'		
		 AND		R.ItemNo = '#url.itemNo#'
		 AND		R.UoM = '#url.UoM#'
		 ORDER BY R.ScheduleEffective DESC
</cfquery>

<table width="100%">
	<tr><td height="10"></td></tr>
	
	<tr><td class="labelmedium" style="padding:10px"><font color="808080">Allows you to set an action which by default would generate a stock replenishment REQUEST [Supply Request and Stock TaskOrder] (effectively a transfer) for an associated warehouse.</td></tr>
	<tr>	
	
	<tr>	
		<td>
			
			<table width="99%" align="center">
				<tr class="labelmedium line">
					<td height="23" width="10%" align="center" class="labelit">
						<cfoutput>
						<a href="javascript: editRequestUoM('#url.warehouse#','#url.location#','#url.itemNo#','#url.UoM#','');">
							<font color="0080FF">
								[<cf_tl id="Add new">]
							</font>
						</a>
						</cfoutput>
					</td>
					<td><cf_tl id="Effective"></td>
					<td align="center"><cf_tl id="Mode"></td>
					<td align="center"><cf_tl id="Day/Interval"></td>
					<td align="center"><cf_tl id="Ship Mode"></td>
					<td align="center"><cf_tl id="Enabled"></td>
					<td align="right" style="padding-right:20px;"><cf_tl id="Quantity"></td>
					<td><cf_tl id="Officer"></td>
					<td><cf_tl id="Created"></td>
				</tr>
									
				<cfoutput query="getreq">
					<cfset vScheduleEffective = dateFormat(ScheduleEffective,'yyyymmdd')>
					<tr>
						<td align="center">
							<table>
								<tr>
									<td>
										<cfif currentrow eq 1>
											<cf_img icon="edit" onclick="editRequestUoM('#url.warehouse#','#url.location#','#url.itemNo#','#url.UoM#','#vScheduleEffective#');"></td>
										<cfelse>
											&nbsp;&nbsp;&nbsp;&nbsp;
										</cfif>
									<td width="8"></td>
									<td>
										<cf_img icon="delete" onclick="purgeRequestUoM('#url.warehouse#','#url.location#','#url.itemNo#','#url.UoM#','#vScheduleEffective#');">
									</td>
								</tr>
							</table>
						</td>		
						<td height="20" class="labelmedium">#dateFormat(ScheduleEffective,'#CLIENT.DateFormatShow#')#</td>
						<td align="center" class="labelmedium">#ScheduleMode#</td>
						<td align="center" class="labelmedium"><cfif lcase(scheduleMode) eq "interval">#ScheduleInterval#</cfif><cfif lcase(scheduleMode) eq "month">#ScheduleDayMonth#</cfif></td>
						<td align="center" class="labelmedium">#ShipToModeDescription#</td>
						<td align="center" class="labelmedium"><cfif operational eq 1>Yes<cfelse><b>No</b></cfif></td>
						<td align="right" class="labelmedium" style="padding-right:20px;">#lsNumberFormat(ScheduleQuantity,pformat)# #UoMDescription#</td>
						<td class="labelmedium">#officerfirstName# #officerLastname#</td>
						<td class="labelmedium">#dateformat(created,'#CLIENT.DateFormatShow#')#</td>
					</tr>
					<tr>
						<td></td>
						<td width="1%" style="padding-left:10px;" align="right"><img src="#SESSION.root#/images/join.gif"></td>
						<td colspan="7">
							<table style="border:1px dotted ##C0C0C0;">
								<tr class="labelmedium">
									<td height="18" style="padding-left:5px; font-size:12px;"><cf_tl id="Source Facility">:</td>
									<td style="padding-left:2px;">#SourceWarehouseName#</td>
									<td style="padding-left:15px;; font-size:12px;"><cf_tl id="Request Type">:</td>
									<td style="padding-left:2px;">#RequestTypeDescription#</td>
									<td style="padding-left:15px;; font-size:12px;"><cf_tl id="Priority">:</td>
									<td style="padding-left:2px;">#RequestActionDescription#</td>									
									<td style="padding-left:10px;"></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td height="5"></td></tr>
				</cfoutput>
			</table>
			
		</td>				
	</tr>			
</table>		

