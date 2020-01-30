
<cfquery name="Claim" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT C.*, D.DocumentNo as RequestNo
    FROM Claim C, ClaimRequest D
    WHERE ClaimId = '#URL.ClaimId#' 
	AND C.ClaimRequestId = D.ClaimRequestId
</cfquery>

<cfoutput>
<tr>
	   <td>
	   <table width="100%" border="0" bordercolor="silver" height="22" border="0" cellspacing="0" cellpadding="0">
		   <tr>
		   <td class="top3n" width="1%">&nbsp;</td>
		   <td class="top3n" width="110"><b>Request doc:</b></td>
		   <td class="top3n" width="15%">TVRQ - #Claim.RequestNo#</td>
		   <td class="top3n" width="70"><b>Voucher:</b></td>
		   <td class="top3n" width="25%"><cfif #Claim.Reference# neq "">#Claim.Reference# #Claim.ReferenceNo#<cfelse>Not assigned</cfif></td>
		   <td class="top3n" width="80"><b>Date:</b></td>
		   <td class="top3n" width="20%">#DateFormat(Claim.ClaimDate, CLIENT.DateFormatShow)#
		   <td class="top3n" width="30" align="center">
		   <img src="#SESSION.root#/Images/up2.gif" alt="Back to claim" border="0" style="cursor: hand;" onClick="goback()">
		   </td>
		   		   
		   <script language="JavaScript">
		   function goback() {
			window.location = "#SESSION.root#/Payroll/Application/Claim/ClaimEntry/ClaimEntry.cfm?ClaimId=#URL.ClaimId#&RequestId=#Claim.ClaimRequestId#&PersonNo=#Claim.PersonNo#"
		   }	
          </script>
		  		  
		   </tr>
	   </table>
	   </td>
	</tr>
</cfoutput>	