
<!--- content of the funding --->

<cfquery name="get" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT *, 	   
	       F.Percentage * RequestAmountBase as AmountRequired
	FROM   RequisitionLineFunding F, RequisitionLine R
	WHERE  F.FundingId     = '#URL.fundingid#'
	AND    R.RequisitionNo = F.RequisitionNo    
</cfquery>	

<cfquery name="Accounts" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  
    SELECT *, (SELECT SUM(Amount)
	           FROM   RequisitionLineFundingDetail D
			   WHERE  
			   <!--- Prosis pending requisitions to be further tuned --->
			   
			          RequisitionNo IN (SELECT RequisitionNo
			                            FROM   RequisitionLine R
										WHERE  R.RequisitionNo != '#url.requisitionno#' <!--- exclude this rwquisition --->
										AND    R.Mission = '#get.Mission#'
										AND    R.Period  = '#get.Period#'
										<!--- Hanno : to be clarified, I could image we take here the condition that 2q + job is also excluded --->
										AND    R.ActionStatus IN ('2','2a','2b','2f','2i','2k')
										)
												
			   AND    AccountInfo   = S.AccountInfo) as RequestedAmount,
			   
			  (SELECT SUM(Amount)
	           FROM   RequisitionLineFundingDetail
			   WHERE  RequisitionNo = '#url.requisitionno#'
			   AND    FundingId     = '#URL.fundingid#'
			   AND    AccountInfo   = S.AccountInfo) as Amount		   
			   
	FROM   stAccountInfo S
	WHERE  Mission      = '#get.Mission#'
	AND    Period       = '#get.Period#'
	AND    AccountFund  = '#get.Fund#'	
	ORDER BY AccountOrganization, AccountProgram, AccountObject
	
</cfquery>		

<cfoutput>

<script>

function validate() {

	document.fundform.onsubmit() 
			
	if( _CF_error_messages.length == 0 ) {	
        ColdFusion.navigate('FundingDetailSelectSubmit.cfm?requisitionno=#url.requisitionno#&fundingid=#URL.FundingId#','process','','','POST','fundform')
	 }   
}

</script>

</cfoutput>

<cf_screentop height="100%" label="Funding details" jQuery="Yes" scroll="Yes" layout="webapp" banner="red" line="no">

<cf_divscroll style="height:100%">

<cfform onsubmit="return false" method="POST" name="fundform">

<cfif accounts.recordcount eq "0">

	<table><tr><td class="labelit">No detailed funding records found</td></tr></table>

<cfelse>

	<table class="navigation_table" width="96%" align="center" cellspacing="0" cellpadding="0">
	
	<tr class="hide"><td id="process"></td></tr>
	
	<cfoutput>
	<tr><td style="height:30" colspan="10" class="labelmedium">Required funding :</td>
	    <td style="height:30" class="labelmedium" align="right">#numberformat(get.Amountrequired,",__.__")#</td>
	</tr>
	</cfoutput>
	
	<tr><td colspan="11" class="linedotted"></td></tr>
	
	<tr>
	  <td class="labelit" colspan="2">Organization</td>	 
	  <td class="labelit">Prog</td>
	  <td class="labelit">Objt</td>
	  <td class="labelsmall" align="right">Allotment</td>
	  <td class="labelsmall" align="right">Cost recovery</td>
	  <td class="labelit" align="right">Income</td>
	  <td class="labelit" align="right">Requested</td>
	  <td class="labelit" align="right">Obligation</td>
	  <td class="labelit" align="right">Disbursed</td>
	  <td class="labelit" align="right">Balance</td>
	  <td class="labelit" align="right">Selected</td>
	</tr>
	
	<tr><td colspan="12" class="linedotted"></td></tr>
	
	<cfset tbud1 = 0>
	<cfset tbud2 = 0>
	<cfset tobl  = 0>
	<cfset texp  = 0>
	<cfset tbal  = 0>
	
	<cfset prior = "">
			
	<cfoutput query="accounts" group="AccountOrganization">
	
		<cfoutput group="AccountProgram">
		
			<cfoutput>
					
			 <cfif AmountBudget1 eq "">
			     <cfset bud1 = "0">
			 <cfelse>
			     <cfset bud1 = AmountBudget1>	 
		     </cfif>
			 <cfset tbud1 = tbud1+bud1>
			   
			 <cfif AmountBudget2 eq "">
			     <cfset bud2 = "0">
			 <cfelse>
			     <cfset bud2 = AmountBudget2>	 
		     </cfif>
			 <cfset tbud2 = tbud2+bud2>
			
			<tr class="navigation_row">
			
			  <td class="labelit linedotted"><cfif prior neq accountorganization>#AccountOrganization#</cfif></td>
			  <td class="labelit linedotted" style="width:25%"><cfif prior neq accountorganization>#left(Memo,50)#</cfif></td>
			  <td style="width:6%" class="labelit linedotted">#AccountProgram#</td>
			  <td style="width:6%" class="labelit linedotted">#AccountObject#</td>
			  <td style="width:8%" class="labelsmall linedotted" align="right"><font color="gray">#numberformat(bud1,'__,')#</td>
			  <td style="width:8%" class="labelsmall linedotted" align="right"><font color="gray">#numberformat(bud2,'__,')#</td>
			  <td style="width:8%" class="labelit linedotted" align="right"><font color="008000">#numberformat(bud1+bud2,'__,')#</td>	
			  <td align="right" bgcolor="FFFF80" class="labelit linedotted" style="width:8%"><font color="6688aa">#numberformat(RequestedAmount,',__.__')#</td>	 
			  <td style="width:8%" class="labelit linedotted" align="right"><font color="6688aa">#numberformat(AmountObligation,',__.__')#</td>
			  <td style="width:8%" class="labelit linedotted" align="right"><font color="6688aa">#numberformat(AmountExpenditure,',__.__')#</td>
			  
			   <cfif RequestedAmount eq "">
			     <cfset req = "0">
			  <cfelse>
			     <cfset req = RequestedAmount>	 
		      </cfif>
			 	 	  
			  <cfif AmountObligation eq "">
			     <cfset obl = "0">
			  <cfelse>
			     <cfset obl = AmountObligation>	 
		      </cfif>
			  <cfset tobl = tobl+obl>
			  
			  <cfif AmountExpenditure eq "">
			     <cfset exp = "0">
			  <cfelse>
			     <cfset exp = AmountExpenditure>	 
		      </cfif>
			  <cfset texp = texp+exp>
			  
			  <cfset bal = bud1 + bud2 - obl - exp - req>
			  <cfset tbal = tbal+bal>
			  
			  <td style="width:10%;padding-right:3px" class="labelit linedotted" align="right">#numberformat(bal,',__.__')#</td>
			  
			  <td style="width:12%" class="linedotted" align="right" style="padding-left:4px">
			  
			  	<input type="hidden" size="6" style="text-align:right;padding-top:2px" 
				 class="regular enterastab" 
				 id="Info_#currentrow#" 
				 name="Info_#currentrow#" 
				 value="#accountinfo#">	  
				 
			  	<cfinput type="Text" size="6" style="text-align:right;padding-top:2px" 
				 class    = "regular enterastab" 
				 id       = "Amount_#currentrow#" 
				 value    = "#numberformat(amount,',__.__')#"
				 name     = "Amount_#currentrow#" 
				 validate = "float" 
				 required = "No">	  
				 
			  </td>
			  
			</tr>
			
						
			<cfset prior = AccountOrganization>
			
			</cfoutput>
		
		</cfoutput>
	
	</cfoutput>
	
	<cfoutput>
	
	<tr>
	  <td style="height:20" class="labelit" align="right"><b>Total</td>
	  <td class="labelit"></td>
	  <td class="labelit"></td>
	  <td class="labelit"></td>
	  <td class="labelsmall" align="right"><font color="gray"><b>#numberformat(tbud1,'__,')#</td>
	  <td class="labelsmall" align="right"><font color="gray"><b>#numberformat(tbud2,'__,')#</td>
	  <td class="labelit"    align="right"><font color="008000"><b>#numberformat(tbud1+tbud2,',__')#</td>
	  <td class="labelit"    align="right"><!--- <font color="6688aa"><b>#numberformat(tobl,'__,')# ---></td>
	  <td class="labelit"    align="right"><font color="6688aa"><b>#numberformat(tobl,',__.__')#</td>
	  <td class="labelit"    align="right"><font color="6688aa"><b>#numberformat(texp,',__.__')#</td>
	  <td class="labelit"    style="padding-right:3px" align="right"><b>#numberformat(tbal,',__.__')#</td>
	  <td class="labelit"    align="right" id="total"></td>
	</tr>
	
	</cfoutput>
	
	<tr><td colspan="12" class="linedotted"></td></tr>
	
	<tr><td colspan="12" style="height:35" align="center">
		<input type="button" style="width:200" name="Submit" value="Submit" class="button10s" onclick="validate()">
	</td></tr>
	
	</table>
		
	</cfif>
	
	</cfform>

</cf_divscroll>

<cf_screenbottom layout="webapp">