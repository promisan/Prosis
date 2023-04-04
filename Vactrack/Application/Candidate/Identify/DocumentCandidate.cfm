
<!--- passthru screen to open the candidate --->

<cfparam name="url.mid" default="">

<cfoutput>

<table style="width:100%;height:100%"><tr><td>
<iframe src="#SESSION.root#/Roster/RosterGeneric/RosterSearch/Search1ShortList.cfm?wparam=#url.wparam#&scope=embed&mode=vacancy&wActionId=#url.wactionid#&docno=#url.docno#&functionno=#url.functionno#&mid=#url.mid#" 
frameborder="0" style="width:100%;height:100%"></iframe>
</td></tr></table>

</cfoutput>