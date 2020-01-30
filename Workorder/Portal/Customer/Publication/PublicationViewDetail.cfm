<table height="100%" width="100%">
	<tr>
		<td height="100%" width="100%" align="center">
			<cfif url.publicationId neq "">
				<cfoutput>
					<iframe height="99%" width="100%" frameborder="0" scrolling="No" src="Publication/WorkActionView.cfm?publicationId=#url.publicationId#"></iframe>
				</cfoutput>
			<cfelse>
				<table><tr><td style="color:red;" class="labellarge">[<cf_tl id="Please select a valid publication">]</td></tr></table>
			</cfif>
		</td>
	</tr>
</table>