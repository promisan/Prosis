
<!--- passtru template --->

<cfoutput>

<cfif URL.ID1 eq "Locate">

		<script language="JavaScript">
		
		   window.location="JobViewView.cfm?time=#now()#&Period=" + parent.window.treeview.PeriodSelect.value + 
		                       "&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#"
		</script>

<cfelse>

	<script language="JavaScript">
	 
	   window.location="../JobView/JobViewListing.cfm?time=#now()#&Mission=#URL.Mission#&Period="+parent.window.treeview.PeriodSelect.value+
	   "&ID=#URL.ID#&ID1=#URL.ID1#"
						 
	</script>

</cfif>

</cfoutput>

