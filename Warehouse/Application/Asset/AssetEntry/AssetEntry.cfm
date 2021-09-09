
<!--- asset entry container --->

<cf_screentop html="no" title="Select Item">

<cfparam name="url.mode" default="manual">
<cfparam name="url.mid" default="">

<table width="100%" height="100%">
	<tr>
		<td height="100%">
		<cfoutput>
			<iframe src="../Item/ItemSearchMaster.cfm?mission=#url.mission#&mode=#url.mode#&mid=#url.mid#" name="result" id="result" width="100%" height="100%" frameborder="0" marginheight="0px" marginwidth="0px" hspace="0px" vspace="0px" ></iframe>
		</cfoutput>
		</td>
	</tr>
</table>