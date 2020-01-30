
<cfif url.mode eq "save">

<cfquery name="update" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   ProgramAllotmentAllocationDetail
		SET      Remarks = '#url.memo#'
		WHERE    AllocationId = '#url.id#'														
</cfquery>		

</cfif>
<cfquery name="get" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ProgramAllotmentAllocationDetail
		WHERE    AllocationId = '#url.id#'														
</cfquery>		

<cfoutput>
	
	<cfif url.mode eq "edit">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="100%">
     			<input type="text" id="memo_#url.id#" name="memo_#url.id#" value="#get.Remarks#" class="regularxl"  style="width:100%" maxlength="80">
			</td>
			<td align="center" style="padding-left:2px">
						
			    <input type="button" name="Save" value="Save" class="button10s" style="height:25;width:40"
				       onclick="ColdFusion.navigate('AllocationEntryDetailLogMemo.cfm?mode=save&id=#url.id#&memo='+document.getElementById('memo_#url.id#').value,'edit_#url.id#')">
				
				</td>
			</tr>
		</table>
		
	<cfelse>
	
	#get.Remarks#
	
	</cfif>	

</cfoutput>