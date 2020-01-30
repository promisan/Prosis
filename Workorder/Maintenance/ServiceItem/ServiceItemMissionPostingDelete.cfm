
<cfset vyear = mid(url.id3, 1, 4)>
<cfset vmonth = mid(url.id3, 6, 2)>
<cfset vday = mid(url.id3, 9, 2)>

<cfset vSelectionDate = createDate(vyear, vmonth, vday)>

<cfquery name="getMissionPosting" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   ServiceItemMissionPosting
		WHERE  ServiceItem = '#url.id1#'		
		AND    Mission = '#url.id2#'
		AND	   SelectionDateExpiration = #vSelectionDate#
</cfquery>

<cfoutput>
	<script>
		window.location.reload();
	</script>
</cfoutput>