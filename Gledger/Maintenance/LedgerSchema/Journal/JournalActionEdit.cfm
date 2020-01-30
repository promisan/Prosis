
<cfquery name="Action" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
<!---
select	A.Code as ActionCode,
		A.Description as ActionDescription,
		ISNULL((SELECT Journal from JournalAction J where	J.Journal = '#URL.ID1#'  AND J.ActionCode =A.Code and J.Operational=1),'') as Journal
from	Ref_Action A
order by A.ListingOrder
--->

SELECT  R.Code as ActionCode, 
		R.Description as ActionDescription,
		A.Operational,
		ISNULL((SELECT Journal from JournalAction J WHERE	J.Journal = '#URL.ID1#'  AND J.ActionCode =R.Code and J.Operational=1),'') as Journal
		,(select count(1) FROM TransactionHeader HA WHERE HA.Journal = A.Journal) as TransactionCount
		
		<!--- No of transactions that were actioned for THIS action --->
			
		,(select count(1) FROM TransactionHeaderAction HA WHERE HA.Journal = A.Journal and HA.ActionCode = A.ActionCode) as Performed
				
		<!--- transactions that were never actioned for THIS action 
		    AND that are still pending if the action requires this --->
		
		,(	SELECT count(1) 
			FROM   TransactionHeader HE 
			WHERE  HE.Journal = A.Journal 
			AND    abs(HE.AmountOutstanding) > 0.05) as Eligibles1
			
		<!--- transactions that were actioned before for THIS action 
		    AND that are still pending (if the action requires this) 
			AND are passed the due date for the next repated action --->	
			
		,(SELECT count(1) 
			FROM  TransactionHeader HE, TransactionHeaderAction HA
			WHERE HE.Journal = A.Journal 			
			AND   abs(HE.AmountOutstanding) > 0.05	
			AND   HA.Journal = HE.Journal
			AND   HA.JournalSerialNo = HE.JournalSerialNo
			AND   DateDiff(day,HA.ActionDate,getdate()) >= R.LeadDays) as Eligibles2
			
FROM        Ref_Action R LEFT OUTER JOIN JournalAction A ON R.Code = A.ActionCode AND A.journal = '#URL.ID1#'

</cfquery>

<cfform action="##" method="POST" name="f_journal_action">

<table width="100%" cellspacing="0" cellpadding="0">
	
	<cfoutput>
		<tr>
			<td height="7"><input type="hidden" name="journal" id="journal" value="#URL.ID1#"></td>			
		</tr> 
	</cfoutput>
	
		<tr>
			<td width="5%" align="center"></td>
			<td width="35%" align="center" class="labelit">Action</td>
			<td align="right" width="20%" class="labelit">Total Transactions</b></td>
			<td align="right" width="20%" class="labelit">Processed <br>for this action</b></td>
			<td align="right" width="20%" class="labelit">Pending next Batch</td>		
		</tr>
		<tr><td colspan="5" class="linedotted"></td></tr>
		
	<cfoutput query="Action">	
	
		<tr>
			<td height="26">
				<input	type="Checkbox" 
				   name="chk#ActionCode#"  
				   id="chk#ActionCode#" 
				   value="chk#ActionCode#" <cfif Journal neq "">checked</cfif> >
			</td>
			<td class="labelit">#ActionDescription#</input></td>
			<td align="right" class="labelit">#TransactionCount#</td>
			<td align="right" class="labelit">#Performed#</td>
			<td align="right" class="labelit">#Eligibles1 + Eligibles2#</td>
		</tr>
		<tr><td colspan="5" class="linedotted"></td></tr>
	
	</cfoutput>
	
	<tr><td colspan="5" align="center" style="padding-top:4px">
	
	<cfquery name="CountRec" 
	      datasource="AppsLedger" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT *
	      FROM TransactionHeader
	      WHERE Journal  = '#URL.ID1#' 
	</cfquery>
	
	<cfif countrec.recordcount eq "0">
		<input class="button10g" style="height:26px" type="button" name="Delete" value=" Delete " onclick="return askjournal()">
	</cfif>
	<input class="button10g" style="height:26px" type="button" name="Update" value=" Update " onclick = "javascript:do_submit()">
	</td></tr>
	
</table>

</cfform>


	