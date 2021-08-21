
<cfoutput>

<cfparam name="url.mid" default="">

<cfif url.mid eq "">

	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/> 
	
<cfelse>

	<cfset mid = url.mid>	

</cfif>

<cfif URL.ID1 eq "Locate">

	<script language="JavaScript">
	
	   window.location =  'ReceiptViewView.cfm?systemfunctionid=#url.systemfunctionid#&period=' + parent.window.receipt.PeriodSelect.value + '&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&mid=#url.mid#'
	   
	</script>

<cfelse>

	<script language="JavaScript">	
	   
	   window.location = 'ReceiptViewView.cfm?systemfunctionid=#url.systemfunctionid#&Period=' + parent.window.receipt.PeriodSelect.value + '&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&mid=#url.mid#'
	   
	</script>

</cfif>

</cfoutput>

