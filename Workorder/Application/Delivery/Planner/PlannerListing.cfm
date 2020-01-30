<cfparam name = "url.print" default ="no">

<!--- obtain selection data on the left --->
<cfinclude template="../getTreeData.cfm">
<cfset url.dts = url.date>
<cfinclude template="getPlannerData.cfm">


<cfif Deliveries.recordcount eq "0">

	<table align="center"><tr><td style="height:60" align="center" class="labelmedium">No records found to show in this view.</td></tr></table>
	
<cfelse>
		
	<!--- scheduler / planner --->
	
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">	
	<tr><td valign="top"><cfinclude template="PlannerListingContent.cfm"></td></tr>					
	</table>	

</cfif>

<script>
	Prosis.busy('no')
</script>
	