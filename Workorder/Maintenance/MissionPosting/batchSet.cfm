
<cfset vyear  = mid(url.id3, 1, 4)>
<cfset vmonth = mid(url.id3, 6, 2)>
<cfset vday   = mid(url.id3, 9, 2)>
<cfset vSelectionDate = createDate(vyear, vmonth, vday)>

<cfset ebp = 0>
<cfif url.batch eq 0>
	<cfset ebp = 1>
</cfif>

<cfquery name="EnableBatchProcessing" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE	ServiceItemMissionPosting
	SET		EnableBatchProcessing = #ebp#
	WHERE 	ServiceItem	= '#url.id1#'
	AND		Mission = '#url.id2#'
	AND		SelectionDateExpiration = #vSelectionDate#
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('batchEnable.cfm?id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&batch=#ebp#', 'iconContainer_#url.id1#_#url.id2#');
	</script>
</cfoutput>