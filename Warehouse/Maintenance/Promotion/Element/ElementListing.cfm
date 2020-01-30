<cfquery name="Prom" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT  E.*,
				(SELECT Description FROM Ref_DiscountType WHERE Code = E.DiscountType) AS DiscountTypeDescription
        FROM    PromotionElement E
		WHERE	E.PromotionId = '#url.id1#'
		ORDER BY E.DiscountType ASC, E.ElementOrder ASC
</cfquery>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr>
    <TD align="center" class="labelit" width="10%">
		<cfoutput>
		<a href="javascript:elementEdit('#url.id1#','')">
			<font color="0080FF">[<cf_tl id="add">]</font>
		</a>
		</cfoutput>
	</TD>
	<TD class="labelit" align="left" width="35%"><cf_tl id="Name"></TD>
	<TD class="labelit" align="center" width="5%"><cf_tl id="Apply<br>Sequence"></TD>
	<TD class="labelit" align="right" width="15%" title="Quantity Required for Discount"><cf_tl id="Qty. Req.<br>For Discount"></TD>
	<TD class="labelit" align="right" width="10%"><cf_tl id="Discount"></TD>
	<TD class="labelit" align="right"><cf_tl id="Created"></TD>
</TR>

<cfset vCols = 6>

<tr><td colspan="<cfoutput>#vCols#</cfoutput>" class="line"></td></tr>
<tr><td height="5"></td></tr>

<cfif Prom.recordCount eq 0>
	<tr><td height="25" colspan="<cfoutput>#vCols#</cfoutput>" align="center" class="labelit"><cf_tl id="No elements recorded"></td></tr>
	<tr><td colspan="<cfoutput>#vCols#</cfoutput>" class="line"></td></tr>
</cfif>

<cfoutput query="Prom" group="DiscountType">
    
	<tr><td class="labelmedium" colspan="#vCols#">#DiscountTypeDescription#</td></tr>
	<tr><td height="1" colspan="#vCols#" class="line"></td></tr>
	
	<cfoutput>
    <tr class="line">
		<td colspan="#vCols#">
			<table width="100%" align="center">
				<tr class="labelmedium">
					<td align="center" style="padding-top:3px" width="10%">
						<table>
							<tr>
								<td><cf_img icon="delete" onclick="elementPurge('#PromotionId#','#ElementSerialNo#');"></td>
								<td>&nbsp;</td>
								<td><cf_img icon="edit" onclick="elementEdit('#PromotionId#','#ElementSerialNo#');"></td>
							</tr>
						</table>
					</td>
					<td width="35%">#ElementName#</td>
					<td align="center" width="5%">#ElementOrder#</td>
					<td align="right" width="15%">#NumberFormat(Quantity, ",")#</td>
					<cfset vSuffix = "">
					<cfset vDiscount = Discount>
					<cfif DiscountType eq "Percentage">
						<cfset vSuffix = "%">
						<cfset vDiscount = Discount * 100>
					</cfif>
					<td align="right" width="10%">
						#NumberFormat(vDiscount, ",.__")# #vSuffix#
					</td>
					<td align="right">#OfficerFirstName# #OfficerLastName# @ #Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
				</tr>
				<tr>
					<td></td>
					<td colspan="#vCols-1#">
						<cfdiv id="divElementListingDetail_#elementSerialNo#" bind="url:Element/ElementListingDetail.cfm?idmenu=#url.idmenu#&id1=#url.id1#&serial=#elementSerialNo#">
					</td>
				</tr>
			</table>
		</td>
    </tr>
	</cfoutput>
	
</cfoutput>

</table>