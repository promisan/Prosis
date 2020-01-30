<cfquery name="SearchResult"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM 	Ref_AssetEvent	
		ORDER BY listingOrder ASC
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		

<cfoutput>
	<script>
		function recordadd(id1) {
		      window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "AddAssetEvent1", "left=80, top=80, width=500, height=250, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		function recordedit(id1) {
		      window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditAssetEvent1", "left=80, top=80, width=800, height=500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
	</script>	
</cfoutput>

<cf_divscroll>

	<table width="97%" align="center" border="0"  bordercolor="silver" cellspacing="0" cellpadding="0" >
		
		<tr>
			<td>
		
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">
					<tr><td class="line" height="1" colspan="8" ></td></tr>
					<tr class="labelmedium line">   
						<td></td>
					    <td width="100"><cf_tl id="Code"></td>
						<td><cf_tl id="Description"></td>
						<td align="center"><cf_tl id="Sort"></td>
						<td align="center"><cf_tl id="Enabled"></td>
						<td width="20%"><cf_tl id="Enabled Categories"></td>   
						<td width="10%"><cf_tl id="Officer"></td>	
						<td align="right"><cf_tl id="Entered"></td>	
					</tr>
					
					<cfoutput query="SearchResult">
											
						<tr class="labelmedium line navigation_row">
							<td align="center" height="22" style="padding-top:3px;">				
							       <cf_img  icon="open" onclick="recordedit('#Code#');">
							</td>
							<td>#Code#</td>
							<td>#Description#</td>
							<td align="center">#listingOrder#</td>
							<td align="center"><cfif operational eq "1">Yes<cfelse><b>No</b></cfif></td>
							<td>
								<cfquery name="categories"
									datasource="appsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT 	C.Description
									    FROM  	Ref_AssetEventCategory E
												INNER JOIN Ref_Category C 
													ON E.Category = C.Category
										WHERE	EventCode = '#Code#'
								</cfquery>
								<cfset vCat = "">
								<cfloop query="categories">
									<cfset vCat = vCat & ", " & description>
								</cfloop>
								<cfif vCat neq "">
									<cfset vCat = mid(vCat,2,len(vCat))>
								</cfif>
								#vCat#
							</td>
							<td>#OfficerLastName#</td>
							<td align="right">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
					    </tr>
					</cfoutput>
				
				</table>
		
			</td>
		
		</tr>
	
	</table>

</cf_divscroll>