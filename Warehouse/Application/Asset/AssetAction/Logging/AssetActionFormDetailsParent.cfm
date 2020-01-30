
<cfoutput>

<cfquery name="get" 
   datasource = "AppsMaterials"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT * 
	FROM   AssetItem
	WHERE  AssetId = '#AssetId#'						
</cfquery>

		<tr>
		
		<td colspan="7" height="30" bgcolor="ffffef" style="padding-bottom:1px;border-left:1px dotted silver;border-top:1px dotted gray">
																
			<table width="96%" align="center" cellspacing="0" cellpadding="0">
																														
				<tr>		
				    
				    <td width="20%" valign="top" style="padding-top:3px">
						<cfif access eq "ALL" or Access eq "EDIT">
						<a href="javascript:AssetDialog('#Get.Assetid#')"><font face="Calibri" size="4" color="0080C0"><u>#get.Description#</a>
						<cfelse>
						<font face="Calibri" size="4">
						#get.Description#
						</font>
						</cfif>
					</td>
					
					<td width="25%">
					
						<table cellspacing="0" cellpadding="0">
						<tr>																				
						    <td width="5%" style="padding-right:4px" class="labelsmall">#vMake#:</td>
							<td width="20%"><font face="Calibri" size="3">#MakeDescription# </td>
						</tr>
						<tr>
							<td width="5%" style="padding-right:4px" class="labelsmall">#vModel#:</td>
							<td width="10%"><font face="Calibri" size="3">#get.Model#</td>												
						</tr>										
						</table>									
					
					</td>
					
					<td width="25%">
					
						<table cellspacing="0" cellpadding="0">
							<tr>	
															
						    <cfif get.AssetDecalNo neq "">
							
								<td style="padding-right:8px" class="labelsmall">#vDecal#:</td>
								<td><font face="Calibri" size="3">#get.AssetDecalNo#</td>								
								
							<cfelse>
							
								<td style="padding-right:8px" class="labelsmall">#vSerialNo#:</td>
								<td><font face="Calibri" size="3">#get.SerialNo#</td>		
							
							</cfif>
							</tr>
							
							<tr>											
								<td style="padding-right:4px" class="labelsmall">#vBarCode#:</td>
								<td><font face="Calibri" size="3">#get.AssetBarCode#</td>											
							</tr>
							
						</table>
					
					</td>	
															
				</tr>
													
			</table>
		
		</td>							
		
	</tr>	
	
</cfoutput>	