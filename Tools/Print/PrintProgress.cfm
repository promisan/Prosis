    

	
    <cfoutput>
	<cf_divscroll id="printingprogress" float="yes" width="400" height="100" overflowy="hidden" zindex="11" padding="3px" close="no">
		<cf_tableround mode="modal" totalheight="100%">
			<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" bgcolor="e9f5ff" align="center">
				<tr>
					<td valign="middle" align="center">

						<font face="calibri" size="3">Preparing Print</font><br>

						<img src="#SESSION.root#/Images/busy3.gif">
						<span id="printclosedialog" style="display:none; cursor:pointer; color:blue" onclick="document.getElementById('printingprogress').style.display = 'none'">Close</span>
						<script>
							setTimeout("document.getElementById('printclosedialog').style.display = 'block'", 5000);
						</script>
					</td>
				</tr>
			</table>
        </cf_tableround>
    </cf_divscroll>
    </cfoutput>
