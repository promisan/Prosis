
<!--- passthru --->

<cfoutput>

<table style="height:100%;width:100%">
	<tr>
		<td valign="top" id="processlist"><cfinclude template="UserAccessListingPendingLines.cfm"></td>
	</tr>
</table>

<!---
<iframe src="#SESSION.root#/System/Organization/Access/UserAccessListingPendingLines.cfm?search=#url.search#&id=#url.id#" 
    width="100%" 
	height="100%" 
	frameborder="">
</iframe>
--->

</cfoutput>
