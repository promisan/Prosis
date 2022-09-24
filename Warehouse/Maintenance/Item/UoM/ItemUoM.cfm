
<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Item
	WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<table width="99%" align="center">

	 <cfoutput>

    <cfif url.mode eq "workflow">
	
		<cfquery name="Cls" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_ItemClass
			WHERE 	Code = '#Item.ItemClass#'
		</cfquery>
		
		<TR class="labelmedium2">
	    <td height="20" width="140"><cf_tl id="Class">:</b></td>
	    <TD style="font-size:17px" width="80%">#Cls.Description#
	    </td>
	    </tr>
		
	    <TR class="labelmedium2">
	    <TD height="20"><cf_tl id="Code">:</TD>
	    <TD style="font-size:17px">#item.ItemNoExternal#</TD>
		</TR>
		
		<TR class="labelmedium2">
	    <TD height="20"><cf_tl id="Description">:</TD>
	    <TD style="font-size:17px">#item.ItemDescription#</TD>
		</TR>	
			
		<tr><td class="line" colspan="2"></td></tr>
	
	</cfif>
		
	<tr><td colspan="2" style="height:30px" class="labelit">
	
		<cf_tl id="The UoM defined for supply item represent the the actual level of the item as it kept in stock" class="message">.
		<cf_tl id="The standard cost of an item is defined for each entity" class="message">.
	
	</td></tr>
		
	<tr><td height="1" colspan="2" class="line"></td></tr>	
	<tr><td colspan="2" align="center">	
	
		<cf_securediv bind="url:#session.root#/Warehouse/Maintenance/Item/UoM/ItemUoMList.cfm?id=#url.id#&uomselected=" id="uomlist">		
				
	</td></tr>
		
	<tr><td colspan="2" id="uomedit"></td></tr>
	
	</cfoutput>	

</TABLE>
