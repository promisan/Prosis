
<!--- passtru template --->

<cfparam name="url.systemfunctionid" default="">
<cfparam name="url.orderclass" default="">

<cfoutput>

<cfif URL.ID1 eq "Locate">

		<script language="JavaScript">
		
				
		   window.location="PurchaseViewView.cfm?ts="+new Date().getTime()+"&Period=" + parent.document.getElementById("PeriodSelect").value + 
		                       "&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&systemfunctionid=#url.systemfunctionid#&orderclass=#url.orderclass#"
		</script>

<cfelse>

	<script language="JavaScript">
	 
	   window.location="PurchaseViewView.cfm?ts="+new Date().getTime()+"&Mission=#URL.Mission#&Period="+parent.document.getElementById("PeriodSelect").value+
	   "&ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid=#url.systemfunctionid#&orderclass=#url.orderclass#"
						 
	</script>

</cfif>

</cfoutput>

