
<!--- 
Validation Rule :  I14
Name			:  Prevent claim for closed funding (stFundStatus
Steps			:  Determine fund type of travel request and determine if fund/period is closed
Date			:  05 April 2006
Last date		:  15 June 2006
--->


	<cfquery name="Check" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    DISTINCT st.FundType, st.Period, st.DateEffective, st.Status
	FROM      stClaimFunding Fd INNER JOIN
              stFundStatus st ON Fd.FundType = st.FundType 
			                 AND Fd.f_fnlp_fscl_yr = st.Period
	WHERE     Fd.ClaimRequestId = '#Claim.ClaimRequestid#' 
	AND       st.Status = '0' 
	AND       st.DateEffective < GETDATE()
	</cfquery>		
	
	<cfif Check.Status eq "0">
	
	    <cfset submission = "0">
	
	  	<tr><td valign="top" bgcolor="C0C0C0"></td></tr>
		 <tr>
			  <td valign="top" bgcolor="FDDFDB">
			  <table width="94%" cellspacing="2" cellpadding="2" align="center">
			  <tr><td valign="top" height="30">
			      <font color="FF0000"><b>Problem</b></font> : You may not submit this claim.
			      <br>
				   <cfoutput>#MessagePerson#</cfoutput>
				  <br>				 
				  </td>
			   </tr>
			  </table>
			  </td>	  
	     </tr>   
		 
	</cfif>	 




