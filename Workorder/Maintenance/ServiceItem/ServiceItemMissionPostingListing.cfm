<cf_screentop height="100%" label="Service Item Mission Posting" jquery="Yes" option="Maintain #url.id1# - #url.id2#" scroll="Yes" layout="webapp" banner="yellow">

<cfoutput>
<script>
	function editmissionposting(serviceitem, mission, selectiondate) {
		var vWidth = 600;
		var vHeight = 500;    
				   
		try { ColdFusion.Window.destroy('mydialog'); } catch(er) {}
		ColdFusion.Window.create('mydialog', 'Mission Posting', '',{x:30,y:30,height:vHeight,width:vWidth,modal:true,center:true});    				
		ColdFusion.navigate("ServiceItemMissionPostingEdit.cfm?ID1="+serviceitem+"&ID2="+mission+"&ID3="+selectiondate+"&ts="+new Date().getTime(),'mydialog');
	}
</script>
</cfoutput>

<cfajaximport tags="cfform, cfdiv, cfwindow, CFINPUT-DATEFIELD">

<cfquery name="getMissionPosting" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    ServiceItemMissionPosting
		WHERE   ServiceItem = '#url.id1#'		
		AND     Mission = '#url.id2#'
		AND Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission)
		ORDER BY SelectionDateExpiration DESC
	</cfquery>
	
<cf_divscroll>	
	
<table width="95%" align="center" class="navigation_table">
	<tr><td height="10"></td></tr>
	
	<tr>
		<td colspan="8" align="center">
			<cfoutput>
				<input type="Button" class="button10g" name="Add" id="Add" value=" Add Posting " onclick="javascript: editmissionposting('#url.id1#', '#url.id2#', '')">
			</cfoutput>
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td colspan="8" height="1" class="line"></td></tr>	
	<tr>
		<td width="50"></td>
		<td class="labelmedium">Date Effective</td>		
		<td class="labelmedium">Date Expiration</td>
		<td class="labelmedium">Action Status</td>
		<td class="labelmedium">Batch Processing</td>
		<td class="labelmedium">Portal Processing</td>
		<td class="labelmedium">Cut-off Date</td>
		<td class="labelmedium">Batch Process Date</td>
	</tr>
	<tr><td colspan="8" height="1" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<cfif getMissionPosting.recordcount eq 0>
		<tr><td colspan="8" class="labellarge" align="center"><font color="808080"><b>No Periods Defined</b></font></td></tr>
	<cfelse>
		<cfoutput query="getMissionPosting">		
			<tr class="navigation_row">
			
				<td align="right">
				   
				   <cfset vSelectionDate = Dateformat(SelectionDateExpiration, "yyyy-mm-dd")>
				   
				   <table>
				   	<tr>
						<td>
						   <cfif currentrow eq 1 and ActionStatus neq 1>					
								<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) {ColdFusion.navigate('ServiceItemMissionPostingDelete.cfm?id1=#url.id1#&id2=#url.id2#&id3=#vSelectionDate#', 'process');}">
							</cfif>
						</td>
						<td>
							<cfif currentrow eq 1>
 								<cf_img icon="edit" onclick="editmissionposting('#url.id1#', '#url.id2#', '#vSelectionDate#');">
							</cfif>
						</td>
					</tr>
				   </table>		   
							
				</td>
				
				<td class="labelmedium">#Dateformat(SelectionDateEffective, "#CLIENT.DateFormatShow#")#</td>
				<td class="labelmedium">#Dateformat(SelectionDateExpiration, "#CLIENT.DateFormatShow#")#</td>
				<td class="labelmedium"><cfif ActionStatus eq 0>Open<cfelseif ActionStatus eq 1><b>Closed</b></cfif></td>
				<td class="labelmedium"><cfif EnableBatchProcessing eq 0><b>Disabled</b><cfelseif EnableBatchProcessing eq 1>Enabled</cfif></td>
				<td class="labelmedium"><cfif EnablePortalProcessing eq 0><b>Disabled</b><cfelseif EnablePortalProcessing eq 1>Enabled</cfif></td>
				<td class="labelmedium">#Dateformat(CutoffDate, "#CLIENT.DateFormatShow#")#</td>
				<td class="labelmedium">#Dateformat(BatchProcessDate, "#CLIENT.DateFormatShow#")#</td>
			</tr>
		</cfoutput>	
	</cfif>
	
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="8" height="1" class="line" id="process"></td></tr>
	
</table>

</cf_divscroll>	