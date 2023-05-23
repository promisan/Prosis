
<!--- Hanno improve performance we can move this to apply at the moment the tree is opened --->

<cfoutput>

<cf_screentop jquery="Yes" html="No">

<script>

	Prosis.busy('yes')
    ptoken.location('ControlListingPositionView.cfm?id=#url.id#&Mission=#url.mission#&OrgUnitName=#url.orgunitname#&HierarchyCode=#url.hierarchycode#&systemfunctionid=#systemfunctionid#&selectiondate='+parent.document.getElementById('postselection').value)

</script>
</cfoutput>
