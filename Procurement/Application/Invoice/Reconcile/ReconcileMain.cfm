
<cfinclude template="InitParam.cfm">

<cfset dr = "">

<cf_dialogProcurement>

<table width="100%" border="1" frame="void" bordercolor="silver" height="100%" align="center" border="0">

<td id="reconcile" style="border: 1px dotted Gray;" colspan="2" height="40"><cfinclude template="ReconcileResult.cfm"></td></tr>

<form name="formreconcile" id="formreconcile">
	<tr>
	  <td valign="top">
  		<cfinclude template="ReconcileViewInvoice.cfm">
      </td>
	  <td id="ledger" valign="top">
  		<cfinclude template="ReconcileViewLedger.cfm">
	  </td>
	</tr>
</form>

<tr>

</table>

