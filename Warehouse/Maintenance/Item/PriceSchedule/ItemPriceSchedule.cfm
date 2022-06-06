
<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*,
			(SELECT Description FROM Ref_Category WHERE Category = I.Category) as CategoryDescription
	FROM 	Item I
	WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<table width="95%" align="center">

	<tr><td height="7"></td></tr>

    <cfoutput>
	
	<cfquery name="Cls" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ItemClass
		WHERE 	Code = '#Item.ItemClass#'
	</cfquery>
	
	<TR class="labelmedium2" style="height:15px">
    <td width="140"><cf_tl id="Class">:</td>
    <TD width="80%">#Cls.Description#</td>
    </tr>
	
    <TR class="labelmedium2" style="height:15px">
    <TD><cf_tl id="Code">:</TD>
    <TD>#item.Classification#</TD>
	</TR>
	
	<TR class="labelmedium2" style="height:15px">
    <TD><cf_tl id="Description">:</TD>
    <TD>#item.ItemDescription#</TD>
	</TR>
	
	<TR class="labelmedium2" style="height:15px">
    <TD><cf_tl id="Category">:</TD>
    <TD>#item.CategoryDescription#</TD>
	</TR>
		
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" align="center">
	
		<cf_securediv bind="url:PriceSchedule/ItemPriceScheduleDetail.cfm?id=#url.id#" id="priceScheduleDetail">
				
	</td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	</cfoutput>	

</TABLE>
