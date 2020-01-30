<cfset url.selected = "">
<cfparam name="url.mission" default="">

<cf_screentop label="BOM" scroll="Yes" layout="webapp" user="No">

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr><td height="100%" width="100%" bgcolor="white">

	<cfform onsubmit="return false" id="frmInheritance" name="frmInheritance" style="height:100%">
								
			<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">
							
			<tr>
			
				<td height="100%" style="padding-left:6px;">
					<table width="100%" height="100%" cellspacing="0" cellpadding="0" style="border-right:1px solid silver">
					    <tr><td style="width:500px;padding-top:4px">
						
							<cfoutput>
							
								<input type="text" 
									onkeyup="_cf_loadingtexthtml='';ColdFusion.navigate('#session.root#/Warehouse/Maintenance/Item/UoM/UoMBOM/ItemUoMBOMEditSelect.cfm?itemno=#url.itemno#&mission=#URL.Mission#&class=service&find='+this.value+'&prefix=_inherit','items_inherit');"
									style = "width:98%;border:1px solid silver" 
									class = "regularxl" 
									id    = "findvalue" 
									name  = "findvalue">
									
							</cfoutput>
							
							</td>
						</tr>
						<tr><td height="5"></td></tr>
						<tr>
								<td style="padding:6px;height:100%">
								
									<cf_divscroll id="items_inherit" style="border:1px dotted silver">
								    	<cfset url.find      = "">	
										<cfset url.prefix    = "_inherit">
										<cfset url.class     = "Service">
										<cfinclude template  = "ItemUoMBOMEditSelect.cfm">
									</cf_divscroll>																	
									
								</td>
						</tr>
					</table>							
				</td>
				<td width="1%"></td>
												
				<cfquery name="UoMMission" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	ItemUoMMission
					WHERE	ItemNo = '#URL.ItemNo#'
					AND		UoM    = '#URL.UoM#'
				</cfquery>
				
				<td width="59%" valign="top" style="padding-top:5px;padding-left:4px">
				
					<table width="100%" cellspacing="0" cellpadding="0" align="center">				
					
						<TR>
								
							<td class="labelmedium" width="30%"><cf_tl id="Entity">:</td>	
							<td width="70%" class="labelmedium">	
								<cfoutput>
									#URL.Mission#
									<input type="hidden" name="mission" id="mission" value="#URL.Mission#">
								</cfoutput>
							</select>
							</td>		
														
						</TR>	
						
						<tr>
							<td class="labelmedium" width="30%"><cf_tl id="Effective">:</td>
							<td width="70%" class="labelmedium">
							
							<cf_intelliCalendarDate9
								FieldName="DateEffective" 
								Manual="True"		
								class="regularxl"												
								DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"
								Default="#dateformat(now(),client.dateformatshow)#"
								AllowBlank="False">	
							
							</td>
						</tr>					
					
						<tr>
							<td class="labelmedium" width="30%"><b><cf_tl id="Inherit from">:</b></td>							
						</tr>
					
						<tr>
							<td style="padding-left:10px" class="labelmedium" width="30%"><cf_tl id="Item">:</td>
							<td id="itembox_inherit" width="70%" class="labelmedium"><font color="#0080C0">--<cf_tl id="Select item">--</font>
							</td>
						</tr>
				
						<tr>
							<td style="padding-left:10px" class="labelmedium" width="30%"><cf_tl id="UoM">:</td>	
							<td id="uombox_inherit" class="labelmedium" width="70%"><font color="#0080C0">--<cf_tl id="Select item">--</font></td>
						</tr>
						
						<tr><td height="4"></td></tr>
						
						<tr><td colspan="2" class="line"></td></tr>
						
						<tr height="30">
							<td colspan="4" style="padding:8px" id="bom_box"></td>
						</tr>
						
						<tr><td colspan="2" class="line"></td></tr>
							
						<tr height="40">
							<td colspan="2">
							
								<cfoutput>
								
									<table>
									<tr>									
																				
										<td style="padding-left:20x">
	
											<cf_tl id="Inherit" var="1">
	
											<cf_button2 type  = "button" 
													name  = "btnInherit" 
													id    = "btnInherit" 
													textcolor = "black"
													height="30"
													width="150"
													text  = "#lt_text#" 
													onclick="BOMInheritSubmit('frmInheritance','itemUoMBOM','UoMBOM/ItemUoMBOMInheritSubmit.cfm?children='+document.getElementById('children').checked+'&ItemNo=#URL.ItemNo#&UoM=#URL.UoM#&mode=add')">																														
															
										</td>
										
										<td style="padding-left:4px"><input type="checkbox" id="children" value="1"></td>
										
										<td style="padding-left:4px" class="labelmedium">Apply also to associated BOMs</td>
										
									</tr>
								    </table>
								
								</cfoutput>										
								
							</td>
						</tr>	
						
						<tr><td colspan="2" class="line"></td></tr>					
								 			
					</table>	
						 
				</td>			
								
			</tr>	
			
			</table>
					
	</cfform>
			
	</td>
	</tr>
				
</table>	

<cfset ajaxonload("doCalendar")>
