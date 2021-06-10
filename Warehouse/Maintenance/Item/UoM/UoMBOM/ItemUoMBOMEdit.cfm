
<cfparam name="url.bomid" default="">
<cfparam name="url.mission" default="">

<cfif URL.bomid eq "">

	<!--- mission --->

	<cfquery name="Get"
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 BOMId, Mission, DateEffective
			FROM   ItemBOM
			WHERE  ItemNo   = '#URL.ItemNo#'
        	AND    UoM      = '#URL.UoM#'
			AND    Mission  = '#url.mission#'
			ORDER  BY DateEffective Desc
	</cfquery>

	
<cfelse>

	<cfquery name="Get"
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT BomId, Mission, DateEffective
			FROM   ItemBOM
			WHERE  BomId = '#URL.BomId#'
	</cfquery>
	
	<cfset url.mission = get.Mission>
		
</cfif>

<form onsubmit="return false" id="frmMaterial" name="frmMaterial" style="height:95%">

<table width="100%" height="100%">

<tr><td height="100%" width="100%" bgcolor="white" style="padding:4px">	
	
	<TABLE width="99%" height="100%" align="center">
	
		<cfset i = 0>
		
		<tr class="hide"><td id="process"></td></tr>  
						
	    <TR valign="top">
		
		    <td height="100%" width="30%" valign="top" style="padding-right:7px;border-right:1px solid silver">
				<table height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				<tr>
					<td height="100%" style="padding:2px;">
						<table width="100%" height="100%" cellspacing="0" cellpadding="0" style="border:0px dotted silver">
						    <tr><td style="width:500px;padding-top:5px">
								<cfoutput>
									<input type="text" 
										onkeyup="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/Warehouse/Maintenance/Item/UoM/UoMBOM/ItemUoMBOMEditSelect.cfm?itemno=#url.itemno#&mission=#url.mission#&find='+this.value+'&class=supply','items')"
										style = "width:98%;border:1px outset d1d1d1" 
										class = "regularxl" 
										id    = "findvalue" 
										name  = "findvalue">
								</cfoutput>
								</td>
							</tr>
							<tr><td height="5"></td></tr>
							<tr>
									<td style="padding-right:0px;height:100%">		
																	
										<cf_divscroll id="items" style="padding-right:0px;height:100%">
									    	<cfset url.find    = "">	
											<cfset url.prefix    = "">
											<cfset url.class    = "Supply">
											<cfinclude template="ItemUoMBOMEditSelect.cfm">
										</cf_divscroll>																	
										
									</td>
							</tr>
						</table>							
					</td>
				</tr>	
				</table>
			</td>   
									
			<td height="100%" width="70%" style="padding-left:6px">
				<table width="100%" height="100%" class="formpadding">
					<TR>
						<TD class="labelmedium">
							<cf_tl id="Entity">:	
						</TD>	
						<TD class="labelmedium">
							<cfoutput>
								#URL.Mission#
								<input type="hidden" name="mission" id="mission" value="#URL.Mission#">
								<input type="hidden" id="boxnumbers" name="boxnumbers" value="0">
							</cfoutput>
						</TD>
					</TR>	
					<TR>	
						<TD class="labelmedium">
							<cf_tl id="Effective">:
						</TD>	
						<TD>
							
							<cfif Get.recordcount eq 0>
								<cfset vDefault = now()>
							<cfelse>
								<cfset vDefault = Get.DateEffective>		
							</cfif>
							
							<cf_intelliCalendarDate9
									FieldName  = "DateEffective" 
									Manual     = "false"					
									Default    = "#Dateformat(vDefault, '#CLIENT.DateFormatShow#')#"
									AllowBlank = "False"
									Class      = "regularxl"
									Inline     ="false">	
						</TD>
					</TR>	
										
					
					<tr><td colspan="2" class="line"></td></tr>
										
					<TR>
						<TD height="100%" colspan="2" style="padding-top:5px">	
						
						    <cf_divscroll id="itembox" style="padding-right:0px;height:100%">					
							<cfif Get.recordcount neq 0>																			
								<cfinclude template="ItemUoMBOMDetails.cfm">
							</cfif>	
							</cf_divscroll>									
							
						</TD>
					</TR>
					
				</table>				
								
			</td>					
		</TR>
		
				
		<tr><td colspan="2" class="line"></td></tr>
		
		<TR height="35">
		
			<td colspan="2" align="center">
			<cfoutput>
			
			   				 
				<table cellspacing="0" cellpadding="0" class="formpadding">
					<tr>
						<td>
						
						<cfif Get.recordcount neq 0>
							
							<cfif GetBOM.recordcount eq 0>
														
								<cf_tl id="Add" var="1">
								<cf_button2 type="button" 
										name="btnAdd" 
										id="btnAdd" 
										width="200"
										height="30"										
										textcolor="000000"
										text="#lt_text#" 
										onclick="editBOMSubmit('frmMaterial','itemUoMBOM','UoMBOM/ItemUoMBOMSubmit.cfm?children='+document.getElementById('children').checked+'&ID=#URL.ItemNo#&UoM=#URL.UoM#&mode=add')">											
							
							<cfelse>
							
								<cf_tl id="Save" var="1">
								<cf_button2 type="button"
										id="btnEdit"
										name="btnEdit" 
										width="200"
										height="30"
										textcolor="000000"
										text="#lt_text#" 
										onclick="editBOMSubmit('frmMaterial','itemUoMBOM','UoMBOM/ItemUoMBOMSubmit.cfm?children='+document.getElementById('children').checked+'&ID=#URL.ItemNo#&UoM=#URL.UoM#&mode=edit&bomId=#GetBom.BomId#')">											
							</cfif>
							
						<cfelse>
												
								<cf_tl id="Add" var="1">
								<cf_button2 type="button" 
										name="btnAdd" 
										width="200"
										height="30"
										textcolor="000000"
										id="btnAdd" 
										text="#lt_text#" 
										onclick="editBOMSubmit('frmMaterial','itemUoMBOM','UoMBOM/ItemUoMBOMSubmit.cfm?children='+document.getElementById('children').checked+'&ID=#URL.ItemNo#&UoM=#URL.UoM#&mode=add')">								
						</cfif>		
								
						</td>
						
												
						<cfquery name="Related" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
								SELECT   *
								FROM     ItemUoMMission
								WHERE    ItemNo IN (SELECT ItemNo 
								                    FROM Item WHERE ParentItemNo = '#URL.ItemNo#')
								AND      UoM     = '#URL.UoM#'
								AND      Mission = '#url.mission#' 
						</cfquery>	
						
						<cfif Related.recordcount gte "1">				
													
						<td style="padding-left:4px"><input type="checkbox" id="children" checked value="1"></td>
						<td style="padding-left:4px" class="labelit">Update also children's bom</td>
						
						<cfelse>
																		
							<input type="hidden" id="children" value="0">
						
						</cfif>		
								
						
					</tr>
				</table>
				
			</cfoutput>										
			</td>
		</TR>		
		
	</TABLE>			
		
	</td>
	</tr>
</table>

</form>	



<cfset ajaxonload("doCalendar")>

