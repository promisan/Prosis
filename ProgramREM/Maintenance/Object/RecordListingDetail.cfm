<cfoutput>

  <TR bgcolor="white" id="box#Use#" name="box#Use#" class="#cl#">
		<td width="2%" align="center" style="height:18;padding-top:1px;"><cf_img icon="select" navigation="Yes" onclick="recordedit('#Code#')"></td>
		<TD class="labelit"><cfif ParentCode neq "">&nbsp;&nbsp;..</cfif><a href="javascript:recordedit('#Code#')">#Code#</a></TD>
		<TD class="labelit"><a href="javascript:recordedit('#Code#')">#CodeDisplay#</a></TD>
		<TD class="labelit">#Description#</TD>
		<TD class="labelit">#ListingOrder#</TD>
		<TD class="labelit">#ParentCode#</TD>
		<cfif operational eq "1">
			<td class="labelit" id="#code#sum" style="padding-right:10px" align="right" ><a href="javascript:item('#code#')"><font color="6688aa">#ItemMaster#</font></a></td>
		<cfelse>
			<td></td>
		</cfif>
		<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
		<TD class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
  </TR>
			
  <!--- item master box --->
  <tr id="box#ObjectUsage#" name="box#ObjectUsage#" class="#cl#">
		<td></td>
		<td id="#code#box" name="#code#box" class="hide" colspan="8">
			<table width="100%" align="center" cellspacing="0" cellpadding="0">
				<tr><td id="#code#detail" name="#code#detail"></td></tr>
			</table>
		</td>	
  </tr>
			
 <!--- line --->
 <tr bgcolor="E9E9E9" id="box#ObjectUsage#" name="box#ObjectUsage#" class="#cl#">
	<td height="1" colspan="9"></td>
 </tr>
			
</cfoutput>			