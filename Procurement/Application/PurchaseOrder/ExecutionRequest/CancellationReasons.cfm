
<cfquery name="Reason" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  R.Description, A.ReasonCode, A.Remarks
	FROM   PurchaseExecutionRequestReason A INNER JOIN
            Ref_StatusReason R ON A.ReasonCode = R.Code
	WHERE  RequestId = '#URL.Id#' 
</cfquery>	

<table width="100%" cellspacing="0" cellpadding="0" height="100%" bgcolor="white">
<tr><td valign="top">

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

	<cfif Reason.recordcount eq "0">
	
		
		<tr><td colspan="2" align="center">No additional reason for this cancellation</td></tr>
	
	
	<cfelse>
	
	<tr><td colspan="2" align="center"><b>Reasons for cancellation</td></tr>
	
	<tr><td colspan="2" height="1" class="line"></td></tr>
	
	<tr><td colspan="2" align="center">
	 
	<table width="96%" align="center" bgcolor="F4FBFD">
		
		<cfoutput query="Reason">
			<tr>
				<td width="20">#CurrentRow#</td>
				<td width="200">#Description#</td>
				<td>#Remarks#</td>
			</tr>
			<tr><td colspan="3" height="10"></td></tr>						
			<tr><td colspan="3" height="1" class="line"></td></tr>			
		</cfoutput>				  
	
	</table>
	
	</cfif>

	</td></tr>

</table>

</td></tr></table>