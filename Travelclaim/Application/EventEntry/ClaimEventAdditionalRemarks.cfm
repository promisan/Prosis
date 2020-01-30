
<cfsilent>

	<proUsr>administrator</proUsr>
	<proOwn>Hanno van Pelt</proOwn>
	<proDes></proDes>
	<proCom></proCom>
	<proCM></proCM>
	<proInfo>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	All information is saved at run time, this screen saves the entered remarks and email address upon changing its values
	</td></tr>
	</table>
	</proInfo>

</cfsilent>

<cfif Len(Form.Remarks) lte 300>
	   
	<cfquery name="Remarks" 
			  datasource="appsTravelClaim" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Claim
			  SET Remarks = '#Form.Remarks#', EMailAddress = '#Form.EMailAddress#'
			  WHERE ClaimId = '#URL.ClaimId#'
	</cfquery>

</cfif>
	