
<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Item
	WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<table width="95%" cellspacing="0" cellpadding="0" align="center">

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
	
	<TR>
    <td height="20" class="labelit" width="140"><cf_tl id="Class">:</b></td>
    <TD width="80%"><font face="Calibri" size="3">#Cls.Description#
    </td>
    </tr>
	
    <TR>
    <TD height="20" class="labelit"><cf_tl id="Code">:</TD>
    <TD><font face="Calibri" size="3">#item.Classification#</TD>
	</TR>
	
	<TR>
    <TD height="20" class="labelit"><cf_tl id="Description">:</TD>
    <TD><font face="Calibri" size="3">#item.ItemDescription#</TD>
	</TR>	
		
	<tr><td class="line" colspan="2"></td></tr>
	
	<tr><td colspan="2" style="height:30px" class="labelit">
	
		<cf_tl id="The UoM defined for supply item represent the the actual level of the item as it kept in stock" class="message">.
		<cf_tl id="The standard cost of an item is defined for each entity" class="message">.
	
	</td></tr>
		
	<tr><td height="1" colspan="2" class="line"></td></tr>	
	<tr><td colspan="2" align="center">	
	
	    <cf_getMID>
		<cfdiv bind="url:UoM/ItemUoMList.cfm?id=#url.id#&uomselected=&mid=#mid#" id="uomlist"/>		
				
	</td></tr>
		
	<tr><td colspan="2">
	<cfdiv id="uomedit"/>
	</td></tr>
	
	</cfoutput>	

</TABLE>
