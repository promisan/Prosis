
<div id="divVendorListing">

	<cfquery name="uomlist" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
			 SELECT    *
			 FROM      	ItemUoM
			 WHERE     	ItemNo = '#url.id#'
	</cfquery>
	
	<cfif uomlist.recordcount eq "0">
	
	<table align="center" class="formpadding navigation_table">
	
	<tr class="labelmedium">
	<td style="font-size:20px;padding-top:20px">
	<cf_tl id="No UoM were recorded for this item"></td></tr>
	</td>
	</tr>
	</table>
	
	<cfelse>
	
	<cfquery name="get" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
			 SELECT    	V.*,
			 			(
							SELECT 	OrgUnitName 
							FROM 	Organization.dbo.Organization
							WHERE	Mission = (SELECT TreeVendor FROM Purchase.dbo.Ref_ParameterMission WHERE Mission = '#url.mission#' AND OrgUnit = V.OrgUnitVendor)
						) as VendorName,
						(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#url.id#' AND UoM = V.UoM) as UoMDescription
			 FROM      	ItemVendor V
			 WHERE     	V.ItemNo = '#url.id#'
			 ORDER BY VendorName, UoM, VendorItemNo
	</cfquery>
	
	<cfset columns = 8>
	
	<table width="99%" align="center" class="formpadding navigation_table">
		
		<tr>
			<td align="right" colspan="<cfoutput>#columns#</cfoutput>">
				<cfoutput>
							
				<input 
					class       = "button10g"
					type        = "button"
					style       = "width:300px"
					value       = "Add Vendor/UoM" 	
					onClick     = "editvendor('#url.mission#','#url.id#','','');"					
					id          = "addl">   
				
				</cfoutput>
			</td>
		</tr>	
		<tr><td class="line" colspan="<cfoutput>#columns#</cfoutput>"></td></tr>
		<tr class="line labelmedium">	
			<td height="23" width="25"></td>	
			<td><cf_tl id="UoM"></td>
			<td><cf_tl id="Item No."></td>
			<td><cf_tl id="Description"></td>
			<td><cf_tl id="Pricing"></td>
			<td align="center"><cf_tl id="Total Offers"></td>
			<td align="center"><cf_tl id="Preferred"></td>
			<td width="8%"></td>
		</tr>
		
		<cfif get.recordCount gt 0>
		<cfoutput query="get" group="VendorName">
			<tr class="line">			
				<td colspan="#columns#" class="labellarge">
					<a href="javascript: showVendorInfo('#orgUnitVendor#');">#VendorName#</a>
				</td>
			</tr>
			<cfoutput>
				
				<tr class="navigation_row labelmedium line">	
				
					<td></td>			
					<td>#UoMDescription#</td>
					<td>#vendorItemNo#</td>
					<td>#vendorItemDescription#</td>				
					
					<cfquery name="getTotalOffers" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						SELECT DISTINCT DateEffective 
						FROM 	ItemVendorOffer
						WHERE	ItemNo = '#ItemNo#'
						AND		UoM = '#UoM#'
						AND		OrgUnitVendor = #orgUnitVendor#
						ORDER BY DateEffective DESC
					</cfquery>								
					
					<td>
					
						<cfif getTotalOffers.recordCount gt 0>
						
							<cfquery name="getOffers" 
							    datasource="AppsMaterials" 
							    username="#SESSION.login#" 
							    password="#SESSION.dbpw#">
								SELECT 	*,
										(SELECT LocationName FROM Location WHERE Location = O.LocationId) as LocationName,
										(SELECT TreeOrder FROM Location WHERE Location = O.LocationId)    as LocationOrder
								FROM 	ItemVendorOffer O
								WHERE	O.ItemNo = '#ItemNo#'
								AND		O.UoM = '#UoM#'
								AND		O.OrgUnitVendor = #orgUnitVendor#
								AND		O.DateEffective = '#getTotalOffers.DateEffective#'
								ORDER BY LocationOrder
							</cfquery>
							
							<cfif getOffers.recordCount gt 0>
								<font color="808080">
									#dateformat(getOffers.dateEffective, CLIENT.DateFormatShow)# - #lsNumberFormat(getOffers.OfferMinimumQuantity, ",._")# #get.UoMDescription#s minimum | #getOffers.OfferMinimumVolume# m3<br>
									<table width="100%" align="center" style="color:808080;">
									<cfloop query="getOffers">									
										<tr>
											<td class="labelmedium">#getOffers.LocationName#</td>	
											<td class="labelmedium">#getOffers.Currency# #lsNumberFormat(getOffers.ItemPrice, ",.__")# per #get.UoMDescription#</td>
										</tr>									
									</cfloop>
									</table>
								</font>						
							</cfif>
						<cfelse>
								No offers recorded
						</cfif>
					</td>
					<td align="center">#getTotalOffers.recordCount#</td>
					<td align="center"><cfif preferred eq "1">Yes<cfelse>No</cfif></td>
					<td align="left" style="padding-top:1px">
						
						<table class="formspacing">
							<tr>
								<td>
									<cf_img icon="edit" navigation="Yes" onclick="editvendor('#url.mission#','#url.id#','#UoM#','#orgUnitVendor#');">
								</td>
								<td style="padding-left:4px">
									<cf_img icon="delete" onclick="if (confirm('Do you want to remove this vendor/uom ?')) {ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/vendors/vendorPurge.cfm?mission=#url.mission#&id=#url.id#&uom=#uom#&orgunitvendor=#orgunitvendor#','divVendorListing');}">
								</td>
							</tr>
						</table>
						
					</td>			
				</tr>			
			</cfoutput>
			
		</cfoutput>
		<cfelse>
			<tr><td align="center" colspan="<cfoutput>#columns#</cfoutput>" class="labelmedium"><cf_tl id="No Vendors recorded for this item"></td></tr>
			<tr><td height="10"></td></tr>
		</cfif>
		<tr><td class="line" colspan="<cfoutput>#columns#</cfoutput>"></td></tr>
	</table>
	
	</cfif>
	
</div>

<cfset ajaxonload("doHighlight")>