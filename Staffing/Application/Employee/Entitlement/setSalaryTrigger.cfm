
<cfquery name="Trigger" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_PayrollTrigger T
	WHERE   SalaryTrigger = '#url.id#'	
</cfquery>

<cfif trigger.triggerInstruction neq "">
	<table width="90%" align="center">
	<tr class="line">
		<td colspan="2" class="labelit" style="border-top:1px solid silver;height:1px;padding-left:10px; padding-right:10px">
		<font color="0080C0">
		<cfoutput>#trigger.triggerInstruction#</cfoutput>
		</td>
	</tr>
	</table>
</cfif>

<cfif Trigger.enableAmount eq "1">

	<script>
		document.getElementById('enableamount').className = "regular labelmedium"	 
	</script>
	
<cfelse>

	<script>
	 	document.getElementById('enableamount').className = "hide"	 
	</script>
	
</cfif>

	