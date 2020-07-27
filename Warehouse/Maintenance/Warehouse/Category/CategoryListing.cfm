
<cfquery name="List" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*,
			(SELECT Description FROM Ref_Category WHERE Category = C.Category) AS CategoryDescription,
			(
				SELECT 	ISNULL(COUNT(*),0)
				FROM 	ItemWarehouseLocation
				WHERE 	Warehouse = C.Warehouse
				AND		ItemNo IN (SELECT ItemNo FROM Item WHERE Category  = C.Category)
			) as Validate
    FROM  	WarehouseCategory C
	WHERE 	Warehouse = '#URL.ID1#'
</cfquery>

<cf_tl id = "Yes" var = "vYes">

<table width="75%" border="0" cellspacing="0" cellpadding="0" align="left">
<tr>

<td colspan="2" style="padding-left:4px">

<table width="100%" class="navigation_table">

<tr class="line labelmedium">
    
    <td width="50%" style="padding-left:2px"><cf_tl id="Category"></td>
    <td align="center"><label title="Operational"><cf_tl id="Op"></label></td>
	<td align="center"><label title="Discount"><cf_tl id="Disc"></label></td>
	<td align="center"><label title="Oversale"><cf_tl id="Over"></label></td>
	<td align="center"><label title="Selfservice"><cf_tl id="Self"></label></td>
	<td align="center"><label title="Request Mode"><cf_tl id="Req"></label></td>
	<td height="23" align="right" style="padding-left:20px">
		<cfoutput>
		<A href="javascript:editCategory('#url.id1#','')"><cf_tl id="add"></a>
		</cfoutput>
	</td>
</tr>

<cfif List.recordCount eq 0>
	<tr><td align="center" class="labelit line" height="25" colspan="7" style="color:red;">[<cf_tl id="No categories recorded">]</td></tr>	
</cfif>

<cfoutput query="List">

	<tr class="navigation_row line labelmedium" style="height:20px">
		
		<td style="padding-left:3px">#CategoryDescription#</td>
		<td align="center"><cfif Operational eq 1>#vYes#<cfelse><b>No</b></cfif></td>		
		<td align="center">#ThresholdDiscount#</td>	
		<td align="center"><cfif OverSale eq 1>#vYes#<cfelse><b>No</b></cfif></td>
		<td align="center"><cfif SelfService eq 1>#vYes#<cfelse><b>No</b></cfif></td>
		<td align="center"><cfif RequestMode eq 1><label title="Consolidated">C</label><cfelse><label title="Not Consolidated">NC</label></cfif></td>
		<td style="padding-top:1px; padding-left:22px;">
			<table>
				<tr>
					<td><cf_img icon="edit" onclick="editCategory('#url.id1#','#category#');"></td>
					<cfif validate eq 0>					
					<td style="padding-left:3px">
						<cf_img icon="delete" onclick="purgeCategory('#url.id1#','#category#');">
					</td>
					</cfif>
				</tr>
			</table>
		</td>
	</tr>
	
</cfoutput>
</TABLE>

</td>

</TABLE>


<cfset AjaxOnLoad("doHighlight")>	
