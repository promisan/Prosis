
<!--- view --->

<cfparam name="url.id1" default="">

<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%;overflow:hidden">
<cfif url.id1 eq "">
	<iframe src="#SESSION.root#/Staffing/Application/Employee/Dependents/DependentEntry.cfm?contractid=#url.contractid#&action=#url.action#&id=#url.id#" width="100%" height="100%" frameborder="0"></iframe>
<cfelse>
	<iframe src="#SESSION.root#/Staffing/Application/Employee/Dependents/DependentEdit.cfm?contractid=#url.contractid#&action=#url.action#&id=#url.id#&id1=#url.id1#" width="100%" height="100%" frameborder="0"></iframe>
</cfif>
</td></tr>
</table>
</cfoutput>
