
<cfoutput>

<cf_screenTop height="100%" banner="gray" layout="webapp" label="Maintain Indicators (Batch Entry)" band="No" scroll="no">
<table width="100%" height="100%" background="1">
	<tr>
		<td valign="top" width="220" style="padding-top:14px">
		
			<iframe src="IndicatorAuditDatesTree.cfm?TargetId=#URL.TargetId#" 
			    name="left" id="left" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>
		
		</td>
		<td style="padding:5px;border-left: 1px solid Silver;">
			<iframe src="IndicatorAuditDatesInput.cfm?TargetId=#URL.TargetId#&Period=#URL.Period#"
	        name="right"
	        id="right"
	        width="100%"
	        height="99%"
			scrolling="no"
	        frameborder="0"></iframe>
		</td>
	</tr>
</table>
<cf_screenbottom layout="webapp">
</cfoutput>

