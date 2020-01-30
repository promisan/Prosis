
<cfparam name="children" default="">

<cfoutput>
<td style="display:none;" class="ccontent">#City#</td>
<TD class="labelit ccontent" style="padding-left:10px"><cfif operational eq "0"><font color="808080"><i></cfif><cfif level eq "1">&nbsp;&nbsp;&nbsp;&nbsp;</cfif>#WarehouseName#</TD>	
<TD class="labelit navigation_action" onclick="edit('#warehouse#')" style="padding-left:10px;padding-right:6px">				    		
	<cf_img icon="edit">		   
</TD>	
<TD class="labelit ccontent" height="18"><cfif operational eq "0"><font color="808080"><i></cfif>#Warehouse#</TD>	
<TD class="labelit ccontent"><cfif operational eq "0"><font color="808080"><i></cfif>#classDescription#</TD>
<td class="labelit" align="right" style="padding-right:30px"><cfif operational eq "0"><font color="808080"><i></cfif>#locations#</td>
<TD class="labelit" align="center" style="padding-right:20px">#children#</TD>										
<TD class="labelit ccontent"><cfif operational eq "0"><font color="808080"><i></cfif>#OrgUnitName#</TD>
<TD class="labelit"><cfif operational eq "0"><font color="808080"><i></cfif>#DateFormat(Created, CLIENT.DateFormatShow)#</td>
</cfoutput>
