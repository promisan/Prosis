
<cfparam name="url.mode" default="regular">

<cfset vyear = mid(url.effective, 1, 4)>
<cfset vmonth = mid(url.effective, 6, 2)>
<cfset vday = mid(url.effective, 9, 2)>
<cfset vEffectiveDate = createDate(vyear, vmonth, vday)>

<cfquery name="delete" 
datasource="appsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE
	FROM 	Ref_PayrollLocationDesignation
	WHERE 	LocationCode = '#URL.ID1#'
	AND		Designation  = '#URL.designation#'
	AND		DateEffective = #vEffectiveDate#
</cfquery>

<cfif url.mode eq "inline">

	<cfoutput>
		<script>
			ColdFusion.navigate('DesignationListing.cfm?id1=#url.id1#','divDesignationsList');
		</script>
	</cfoutput>

<cfelse>

	<script>
		window.close();
	</script>
	
</cfif>