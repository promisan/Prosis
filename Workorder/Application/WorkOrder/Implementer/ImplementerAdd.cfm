<cf_tl id="Edit Implementers" var="1">

<cf_screentop height="100%" 
              scroll="Yes" 
			  user="No"
			  layout="webapp" 
			  label="#lt_text#" 
			  banner="gray"
			  jQuery="yes">
	
<table width="95%" align="center">
	<tr><td height="10"></td></tr>
	<tr>
		<td colspan="2">
			<cfdiv id="divImplementerList" bind="url:#session.root#/WorkOrder/Application/WorkOrder/Implementer/ImplementerList.cfm?workOrderId=#url.workOrderId#&mission=#url.mission#&mandateno=#url.mandateno#">
		</td>
	</tr>
</table>