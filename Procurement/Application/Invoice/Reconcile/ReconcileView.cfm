
<cfinclude template="InitParam.cfm">

<table width="100%" border="0" height="100%" align="center" border="0">
	
	<tr><td height="20" colspan="2" class="labellarge" style="font-size:22px;height:40px;padding-left:24px">
		<cfoutput>
		#url.Mission# ERP disbursement - #SESSION.welcome# Reconciliation
		</cfoutput>
	</td></tr>
		
	<tr><td id="reconcile" style="height:80" colspan="2"><cfinclude template="ReconcileResult.cfm"></td></tr>
		
	<tr>
		<td colspan="2" height="100%">
				
			<table class="formpadding" border="0" width="100%" height="100%">
				<tr>
			 		<td valign="top" id="invoicebox" width="50%" height="100%" style="border-top:1px solid silver;padding:8px">
						<cfinclude template="ReconcileViewInvoice.cfm">
					</td>					
			 		<td valign="top" width="50%" height="100%" style="border-top:1px solid silver;border-left:1px solid gray;padding:8px">
						<cfinclude template="ReconcileViewLedger.cfm">
					</td>
				</tr>
			</table>
		
		</td>
	</tr>
	
</table>

