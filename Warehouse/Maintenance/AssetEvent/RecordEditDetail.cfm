<cfquery name="SearchResultDetail"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	E.*,
				(SELECT Description FROM Ref_Category WHERE Category = E.Category) as CategoryDescription
	    FROM  	Ref_AssetEventCategory E
		WHERE	E.EventCode = '#url.id1#'
</cfquery>

<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td>
	
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">
				<tr class="labelmedium line">   
					<td align="center" class="labelmedium">
						<cfoutput>
							<a href="javascript:eventCatEdit('#URL.ID1#','')" style="color:##0080FF;">
								[<cf_tl id="Add">]
							</a>
						</cfoutput>
					</td>
					<td><cf_tl id="Category"></td>
					<td align="center" class="labelmedium"><cf_tl id="Issuance"></td>
					<td class="labelmedium"><cf_tl id="Officer"></td>	
					<td align="right" class="labelmedium"><cf_tl id="Entered"></td>	
				</tr>
				
				<cfoutput query="SearchResultDetail">
					
					<tr class="navigation_row labelmedium line">
						<td align="center" height="22">				
							<table align="center">
								<tr>
									<td>
										<cf_img  icon="open" onclick="eventCatEdit('#EventCode#','#Category#');">
									</td>
									<td width="3"></td>
									<td>
										<cf_img  icon="delete" onclick="purgeEventCat('#EventCode#','#Category#');">
									</td>
								</tr>
							</table>
						</td>
						<td class="labelmedium">#CategoryDescription#</td>
						<td align="center" class="labelmedium"><cfif ModeIssuance eq 1><b>Yes</b><cfelse>No</cfif></td>
						<td class="labelmedium">#OfficerFirstName# #OfficerLastName#</td>
						<td align="right" class="labelmedium">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
				    </tr>
				</cfoutput>
			
			</table>
	
		</td>
	
	</tr>

</table>

<cfset ajaxonload("doHighlight")>

