
<!--- passtru template --->

<cf_systemscript>

<cfoutput>

<script language="JavaScript">
 
   ptoken.location("../../Quote/QuotationView/JobViewGeneral.cfm?header=no&Period="+parent.window.treeview.PeriodSelect.value+
   "&ID=#URL.ID#&ID1=#URL.ID1#&Role="+parent.window.role.value)
					 
</script>

</cfoutput>



