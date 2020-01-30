<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfoutput>

	<cfquery name="Log" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT   * 
		 FROM     PurchaseAction P, Status S
		 WHERE    PurchaseNo = '#URL.ID1#'
		 AND      S.Status = P.ActionStatus
		 AND      S.StatusClass = 'Purchase'
		 ORDER BY ActionDate DESC
	</cfquery>
					
		<table width="98%" cellspacing="0" cellpadding="0" align="right">
		
		<tr>
		  <td width="7" height="20"></td>
		  <td class="labelit"><cf_tl id="Action"></td>
		  <td class="labelit"><cf_tl id="Date"></td>
		  <td class="labelit"><cf_tl id="Officer"></td>
		  <td class="labelit"><cf_tl id="Memo"></td>
		</tr>
		<tr><td height="1" colspan="5" class="line"></td></tr>  
		
		<cfloop query="Log">
		
		<tr>
		  <td></td>
		  <td class="labelit" height="20">#Log.Description#</td>
		  <td class="labelit">#dateformat(Log.ActionDate,CLIENT.DateFormatShow)#</td>
		  <td class="labelit">#Log.OfficerFirstName# #Log.OfficerLastName#</td>
		  <td class="labelit">#Log.ActionReference#</td>
		</tr>
		<cfif currentRow neq recordcount>
		<tr><td colspan="5" class="line"></td></tr>
		</cfif>
		
		</cfloop>
		
		</table>
		
	
</cfoutput>	