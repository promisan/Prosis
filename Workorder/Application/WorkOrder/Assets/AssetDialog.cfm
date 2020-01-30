
<cfquery name="Parameter" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Parameter 
</cfquery>

<cfoutput>

<cfset vir = parameter.virtualdirectory>

<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr><td height="4"></td></tr>
	<tr>
	
	<td class="labellarge"><cf_tl id="Assigned Equipment or Devices"></td>
	<td align="right">
	
		<table>
		<tr class="labelmedium">
		
			<cfset lk = "/#vir#/WorkOrder/Application/WorkOrder/Assets/Line.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#">
		
			<td style="padding-left:3px">
			<input type="radio" onclick="ColdFusion.navigate('#lk#&mode=1','assetbox')" name="assetmode" checked value="1"></td><td style="padding-left:3px" class="labelit"><cf_tl id="Active"></td>
			<td style="padding-left:6px">
			<input type="radio" onclick="ColdFusion.navigate('#lk#&mode=0','assetbox')" name="assetmode" value="0"></td><td style="padding-right:3px;padding-left:3px" class="labelit"><font color="red"><cf_tl id="Revoked"></td>
		
	    </tr>
		</table>
		
	</td>	
	</tr>
	
	<tr><td id="assetbox" colspan="2">
		<cfinclude template="/#vir#/WorkOrder/Application/WorkOrder/Assets/Line.cfm">		
	</td></tr>
	
</table>

</cfoutput>