
<!--- passtru template --->

<cfparam name="URL.ID1" default="">
<cfparam name="URL.ID2" default="">

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<script language="JavaScript">

   ptoken.location("RequisitionViewView.cfm?Mission=#URL.Mission#&Period="+parent.window.treeview.PeriodSelect.value+
   "&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&Role="+parent.window.role.value)
					 
</script>

</cfoutput>


