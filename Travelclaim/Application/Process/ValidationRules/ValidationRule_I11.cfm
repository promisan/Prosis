
<cfoutput>
<!--- 
Validation Rule :  I11
Name			:  Prevent claim for unapproved and closed requests
Steps			:  Determine if request may be processed using the Ref_Status table
Date			:  05 April 2006
Last date		:  15 June 2006
--->

	<!--- unapproved and closed requests may not be submitted --->

	<cfquery name = "Check" 
	datasource    = "appsTravelClaim" 
	username      = "#SESSION.login#" 
	password      = "#SESSION.dbpw#">
		SELECT    PointerStatus, Ref_Status.Description
		FROM      ClaimRequest INNER JOIN
		          Ref_Status ON ClaimRequest.ActionStatus = Ref_Status.Status
		WHERE     Ref_Status.StatusClass = 'ClaimRequest'
		AND       ClaimRequestId = '#Claim.ClaimRequestid#'	 
	</cfquery>		
	
	<cfif Check.pointerStatus eq "0">
	
	    <cfset submission = "0">
	
	  	<tr><td valign="top" bgcolor="C0C0C0"></td></tr>
		 <tr>
		  <td valign="top" bgcolor="FDDFDB">
		  <table width="94%" cellspacing="2" cellpadding="2" align="center">
		  	<tr>
			<td valign="top" height="30">
		      <font color="FF0000"><b>Problem</b></font> : You may NOT submit this claim.
		      <br>
			  <cfoutput>#MessagePerson#</cfoutput>
			  <br>
			</td>
			</tr>
		  </table>
		  </td>	  
	     </tr>   
		 
	</cfif>	 

	</cfoutput>



