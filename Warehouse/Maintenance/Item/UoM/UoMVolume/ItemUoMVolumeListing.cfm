	<cfquery name="UoMVolume" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemUoMVolume
		WHERE	ItemNo = '#URL.ID#'
		AND		UoM = '#URL.UoM#'
	</cfquery>
	
	<table width="80%" class="navigation_table">	
	<cfoutput>
	<tr class="line labelmedium2">	    		
		<td height="25" align="center"><a title="Add new temperature" href="javascript:uomvolumeedit('#URL.ID#', '#URL.UoM#', '')">New Temperature</font></a></td>		
		<td align="center"><cf_tl id="Temperature"></td>
		<td align="center"><cf_tl id="Volume Ratio"></td>
		<td align="center"><cf_tl id="Officer"></td>
		<td align="center"><cf_tl id="Recorded"></td>
	</tr>
	
	<cfif UoMVolume.recordCount eq 0>
	<tr><td colspan="5" align="center" height="30" valign="middle" class="labelmedium" style="color:808080;">[<cf_tl id="No temperatures recorded">]</td></tr>	
	</cfif>
	
	</cfoutput>	
	
	<cfoutput query="UoMVolume">	
	
	<tr class="navigation_row line labelmedium2">
	  <td align="center" height="20" style="padding-top:1px">
	  
	    <table>
		<tr><td style="padding-top:1px">
	     <cf_img icon="edit" class="navigation_action" onClick="uomvolumeedit('#URL.ID#', '#URL.UoM#', '#Temperature#')">
	    </td>
		<td>
	     <cf_img icon="delete"  onClick="uomvolumedelete('#URL.ID#', '#URL.UoM#', '#Temperature#')">
		</td>
		</tr>
		</table>
		
	  </td>
	  <td align="center">#lsNumberFormat(Temperature,".___")#</td>	  
	  <td align="center">#lsNumberFormat(VolumeRatio,".___")#</td>
	  <td align="center">#OfficerLastName#</td>
	  <td align="center">#dateformat(Created,client.dateformatshow)#</td>
	</tr>  	
	</cfoutput>
	
	
	<tr><td height="7" colspan="3"></td></tr>
	
	</table>
	
	<cfset AjaxOnLoad("doHighlight")>