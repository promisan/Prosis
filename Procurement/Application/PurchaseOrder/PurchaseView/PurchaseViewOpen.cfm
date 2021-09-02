
<!--- passtru template --->

<cfparam name="url.systemfunctionid" default="">
<cfparam name="url.orderclass" default="">

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/> 

<cfif URL.ID1 eq "Locate">

		<script language="JavaScript">
		
				
		   window.location="PurchaseViewView.cfm?Period=" + parent.document.getElementById("PeriodSelect").value + 
		                       "&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&systemfunctionid=#url.systemfunctionid#&orderclass=#url.orderclass#&mid=#mid#"
		</script>

<cfelse>

	<script language="JavaScript">
	 
	   window.location="PurchaseViewView.cfm?Mission=#URL.Mission#&Period="+parent.document.getElementById("PeriodSelect").value+
	   "&ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid=#url.systemfunctionid#&orderclass=#url.orderclass#&mid=#mid#"
						 
	</script>

</cfif>

</cfoutput>

