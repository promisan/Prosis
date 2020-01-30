
<cfparam name="editclaim" default="1">

    <cfquery name="Request" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM  ClaimRequest R, 
		      Ref_DutyStation M
		WHERE R.Mission = M.Mission
		AND   R.ClaimRequestid = '#Claim.ClaimRequestId#'
   	</cfquery>
	
    <cfquery name="AddressMode" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM Ref_PaymentMode
		WHERE TriggerGroup = 'TravelClaim'
		AND Operational = 1
		ORDER BY ListingOrder  
   	</cfquery>
		
	<script language="JavaScript">
	
	function payment(mode) {
	
		<cfoutput query="AddressMode">
		
			se = document.getElementsByName("#code#")
			count = 0
		    while (se[count]) {
			se[count].className = "hide"
			count++
			}
			
   		</cfoutput>
	
		se = document.getElementsByName(mode)
		count = 0
		while (se[count]) {
		se[count].className = "regular"
		count++
		}
		
	}
		
	</script>
		
	<cfquery name="Account" 
   	  datasource="appsTravelClaim" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT *
		FROM   PersonAccount
		WHERE  PersonNo = '#Claim.PersonNo#'
		AND    Operational = 1
		ORDER BY DateEffective DESC
	</cfquery>
	
	<cfquery name="Payroll" 
   	  datasource="appsTravelClaim" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT *
		FROM   stPerson
		WHERE  PersonNo = '#Claim.PersonNo#'
		AND    OnPayroll = 1		
	</cfquery>
	
	<cfset disb = 0>
	<cfset cnt  = 0>
	
		
	<cfoutput query="AddressMode">	
				   		
		<cfif PointerAccount eq "1" and Account.Recordcount eq "0">
			
		<!--- hide option if person does not have an account --->
		
		<cfelseif PointerPayroll eq "1" and Payroll.Recordcount eq "0">
		
		<!--- hide option if person is not on the payroll --->
		
		<cfelseif Claim.ActionStatus gt "1" and Claim.PaymentMode neq Code>
	
		<!--- hide option if claim has been processed --->
		
		<cfelseif editclaim eq "0" and Claim.PaymentMode neq Code>
						
		<cfelse>
		
			<cfif Operational eq "1">
									
				<cfset disb = 1>
					
				<tr bgcolor="FFFFFF">
					<td width="80" valign="top">
						<table width="100%" cellspacing="0" cellpadding="0">
						<tr>
						     <td width="30"  align="center">
							 
						        <input type="radio" 
								       onclick="payment('#code#')" <cfif Operational eq "0">disabled</cfif> 
								       name="PaymentMode" 
									   value="#Code#" <cfif Claim.PaymentMode eq "#code#" or cnt eq "0"> checked</cfif>>
									   
									   
							 </td>
						</tr>
						</table>
					</td>
					
					<cfset cnt = 1>	
					
					<td width="96%">
					<cfif Claim.PaymentMode eq code>
						 <cfset cl = "regular">
					<cfelse>
					 	<cfset cl = "hide">
					</cfif>
					
					<cfquery name="Cluster" 
					 datasource="appsTravelClaim" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT C.*, 
					        R.Description as ModeDescription, 
							R.ListingOrder as ModeOrder					
					 FROM Ref_PaymentModeCluster C, Ref_PaymentMode R
					 WHERE PaymentCode ='#Code#'
					 AND  PaymentCode = R.Code
					 ORDER By R.ModeOrder, C.ListingOrder
					</cfquery>
							
					<cfset paycde = "#code#">
					<cfset curr = "#PointerCurrency#">
					<cfset c = "">
														
						<cfinclude template="ClaimInfoPaymentCluster.cfm">
						
				</cfif>
		
		</cfif>
				
	</cfoutput>
	
	<cfif disb eq "0">
	<tr>
	<td colspan="2" align="center"><b><font color="#FF0000">Problem, reimbursement options can not be found for you. Please contact your administrator</font></td>
	</tr>
	
	<cfelse>
	
		<cfif Claim.ActionStatus lte "1" and Mode eq "Info">
		<tr>
		 <td height="22" colspan="2" align="center">
		     		
		   <input type="submit" 
		   class="button10g" 
		   name="Save" 
		   value="Save">
		  </td>
		</tr>
		</cfif>
	
	</cfif>
	
