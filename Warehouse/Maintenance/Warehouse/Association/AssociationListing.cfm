<cf_screentop html="no" jquery="yes">

<table width="97%" height="100%" align="center">
	<tr><td height="10"></td></tr>
	<tr>
		<td>
			<table>	
				<tr>
					<td class="labelit"><cf_tl id="Type">:</td>
					<td style="padding-left:10px;">
						<select name="associationType" id="associationType" class="regularxl">
							<option value="Transfer"> <cf_tl id="Transfer">
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td class="line"></td></tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td height="100%">
			<cfdiv id="divAssociation" style="height:100%; min-height:100%;" bind="url:Association/AssociationListingDetail.cfm?warehouse=#url.warehouse#&type={associationType}">
		</td>
	</tr>
</table>


