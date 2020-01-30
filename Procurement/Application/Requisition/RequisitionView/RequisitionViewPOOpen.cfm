

<!--- passtru template --->

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>  

<script language="JavaScript">
  
  window.location="../../PurchaseOrder/Purchase/POViewGeneral.cfm?Header=No&Period=&ID=#URL.ID#&ID1=#URL.ID1#&mid=#mid#&Role="
					 
</script>

</cfoutput>

