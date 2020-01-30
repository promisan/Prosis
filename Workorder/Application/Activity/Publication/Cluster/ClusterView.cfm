<table height="100%" width="100%">
	<tr>
		<td height="100%" width="100%" align="center">
			<cfif url.publicationId neq "" and url.code neq "">
				<cfoutput>
					<iframe height="99%" width="100%" frameborder="0" scrolling="No" src="Cluster/ClusterViewForm.cfm?publicationId=#url.publicationId#&code=#url.code#&preselOrgUnit="></iframe>
				</cfoutput>
			<cfelse>
				<table><tr><td style="color:red;" class="labelmedium"><cf_tl id="Please select a valid cluster"></td></tr></table>
			</cfif>
		</td>
	</tr>
</table>

