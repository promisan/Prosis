<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!--- claim generated amount information --->
<!--- Prosis template framework --->
<cfsilent>
 	<proOwn>Huda Seid</proOwn>
	<proDes>Claim Generate Amount Info </proDes>
	<proCom>Changed Line 188 - Changed table heading of "Curr." to Claim Currency</proCom>
</cfsilent>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">
	
<table width="98%" border="1" frame="hsides" cellspacing="0" cellpadding="2" align="center" bordercolor="E4E4E4" bgcolor="DFEFFF" rules="rows">

<cfset cnt = 0>  

<cfparam name="URL.Iframe" default="0">

<cfset dsa = 0>

<cfloop index="src" list="Line,LineExternal" delimiters=",">
		
	<cfquery name="Lines" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   L.*, 
	         R.Description as ClaimCategoryDescription, 
		     R.ShowInvoices,
			 P.LastName,
			 P.FirstName
	   FROM  Claim#src# L, 
	         Ref_ClaimCategory R,
			 stPerson P
	   WHERE ClaimId = '#IdClaim#'
	   AND   L.ClaimCategory = R.Code 
	   AND   L.PersonNo *= P.PersonNo
	   ORDER BY R.ListingOrder,L.Created
	</cfquery>
	
	<cfif #src# eq "Line">
	  <cfset text = "TCP claim line amounts">
	<cfelse>
	  <cfset text = "TVCV lines">
	</cfif>
		
	<cfif Lines.recordcount gt "0">
		
		<cfoutput>
		<cfset color2 = "f8f8f8">
		<tr><td colspan="8" bgcolor="ECF5FF">&nbsp;<b>#text#</b></td></tr>
		<cfset cnt = cnt + 17>
		
		<cfif #src# eq "Line">
		
		<tr bgcolor="#color2#">
		    <td width="40"><cfif #src# neq "Line">Document</cfif></td>
			<td>Type</td>
			<td><!--- Traveller ---></td>
			<td>Claim Date</td>
			<td>Payment Currency</td>
			<td align="right"><!---Converted<br>--->Payment Amount</td>
			<!---
			<td width="12%" align="right">Exchange rate</td>
			<td width="12%" align="right">USD Equivalent</td>
			--->
			  <cfset cnt = cnt + 20>
		</tr>
		
		</cfif>
		
		</cfoutput>
	
	</cfif>
	
	<cfset amt = 0>
	
	<cfoutput query="Lines">
		
	<cfif src eq "LineExternal" and ReferenceStatus eq "ca">
		  <cfset col = "ffffcf">
		  <cfset ita = "font-style: italic;">	  
	<cfelse>
		  <cfset col = "white"> 
		  <cfset ita = "">  
	</cfif>
			   
	<cfif src eq "Line">
		<tr bgcolor="#col#">	
		<td width="22" align="center">	
		
			<img src="#SESSION.root#/Images/zoomin.jpg" 
				alt="Show #ClaimCategoryDescription# details"  
				id="#ClaimCategory#_#PersonNo#Exp" border="0" class="regular" 
				align="middle" style="cursor: hand;" 
				onClick="maximizereq('#ClaimCategory#_#PersonNo#')">
				
			<img src="#SESSION.root#/Images/zoomout.jpg" 
				id="#ClaimCategory#_#PersonNo#Min" 
				alt="Hide #ClaimCategoryDescription# details"  border="0" 
				align="middle" class="hide" style="cursor: hand;" 
				onClick="maximizereq('#ClaimCategory#_#PersonNo#')">
				
		</td>	
		<td>
		   <a href="javascript:maximizereq('#ClaimCategory#_#PersonNo#')">#ClaimCategoryDescription#</a>
		</td>
		<td>		
			<cfif PersonNo neq "#Claim.PersonNo#">
				<a href="javascript:maximizereq('#ClaimCategory#_#PersonNo#')">#FirstName# #LastName#</a>
			</cfif>
		</td>		
		<td>
			<a href="javascript:maximizereq('#ClaimCategory#_#PersonNo#')">#DateFormat(Claim.ClaimDate, CLIENT.DateFormatShow)#</a>
		</td>
		
		<cfelse>
		
		    <!--- external lines --->
		
			<cfif src eq "LineExternal" and ReferenceStatus eq "ca">
			<tr><td colspan="6" bgcolor="#col#">
			&nbsp;&nbsp;#Reference# - #ReferenceNo# (#ReferenceStatus#)
			</td></tr>
			</cfif>
		
			<tr bgcolor="#col#">
			<td style="#ita#" align="center"></td>
			<td style="#ita#">#ClaimCategoryDescription#</td>
			<td></td>
			<td style="#ita#">#DateFormat(ExpenditureDate, CLIENT.DateFormatShow)#</td>
			
		</cfif>
					
		<td style="#ita#">#Currency#</td>
		<td style="#ita#" align="right">#numberFormat(AmountClaim,"__,__.__")#</td>
		<!---
		<td align="right">#ExchangeRate#</td>
		<td align="right">#numberFormat(AmountClaimBase,"__,__.__")#</td>
		--->
		
		<cfset amt = amt+AmountClaim>
				
	    </tr>	
		
		<cfif processWf eq "1"> 
		
			<cfquery name="FundingLines" 
		 	datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   L.ClaimRequestId, 
			         L.ClaimRequestLineNo, 
					 L.ClaimCategory, 
					 L.PersonNo, 
					 L.Currency, 
					 L.RequestAmount, 
					 L.Remarks
			FROM     ClaimRequestLine L INNER JOIN
	                 ClaimRequest ON L.ClaimRequestId = dbo.ClaimRequest.ClaimRequestId
	        WHERE    (L.ClaimCategory = '#ClaimCategory#') 
			AND      ClaimRequest.ClaimRequestId = '#Claim.ClaimRequestid#'
			</cfquery>
	
			<cfset ln = "">
			
			<cfif fundingLines.recordcount gte "2">
	
				<cfloop query="FundingLines">
				  <cfif ln eq "">
				      <cfset ln = "'#claimrequestlineno#'">
				  <cfelse>	
					  <cfset ln = "#ln#,'#claimrequestlineno#'">
				  </cfif>	  
				</cfloop>
						
				<tr class="hide" id="#ClaimCategory#_#PersonNo#" bgcolor="ECF5FF"><td></td><td colspan="5">
									
					<cfquery name="Funding" 
					datasource="appsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   stClaimFunding
						WHERE  ClaimRequestId     = '#URL.ClaimRequestId#'
						AND    ClaimRequestLineNo IN (#preserveSingleQuotes(ln)#)					
					</cfquery>	
							
					<table cellspacing="0" cellpadding="1">
					<cfloop query="Funding">						
						<tr>
							<td width="50">Line: #ClaimRequestLineNo#:</td>
						    <td width="37">BAC:</td>							
							<td width="40">#f_fnlp_fscl_yr#</td>
							<td width="40">#f_fund_id_code#</td>
							<td width="40">#f_orgu_id_code#</td>
							<td width="40"><cfif f_proj_id_code eq "">----<cfelse>#f_proj_id_code#</cfif></td>
							<td width="40"><cfif f_pgmm_id_code eq "">----<cfelse>#f_pgmm_id_code#</cfif></td>
							<td width="40">#f_objc_id_code#</td>
							<td width="40">#f_objt_id_code#</td>
							<td width="40"><cfif iov_ind eq "1">IOV</cfif></td>
							<td align="right" width="100">#numberformat(amount,"__,__.__")#</td>
						</tr>	
								
					</cfloop>
							
					</table>				
						
				</td></tr>
	
			</cfif>		
			
		</cfif>		
				
		<cfif ClaimCategory eq "DSA" and src eq "Line">
		
		<tr class="hide" id="#ClaimCategory#_#PersonNo#">
			    <td bgcolor="white"></td>
			   	<td colspan="5" bgcolor="white">
				
				<cfif processWF eq "0">
									
					<cfinclude template="ClaimInfoLineDSA_view.cfm">
				
				<cfelse>
				
					<cfinclude template="ClaimInfoLineDSA_edit.cfm">
				
				</cfif>				
				
				</td>
		</tr>
			
		<cfelseif ShowInvoices eq "1" and src eq "Line">
		
		    <cfquery name="Details" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   C.*, I.Description as IndicatorDescription, I.ClaimCategory
			FROM     ClaimEventIndicatorCost C, Ref_Indicator I
			WHERE    ClaimEventId IN (SELECT ClaimEventId 
			                          FROM ClaimEvent 
									  WHERE ClaimId = '#IdClaim#')
			AND      C.IndicatorCode = I.Code
			AND      PersonNo = '#PersonNo#'  
			AND      I.ClaimCategory = '#ClaimCategory#'
			ORDER BY InvoiceDate
			</cfquery>
						
				<tr class="hide" id="#ClaimCategory#_#PersonNo#">
				<td bgcolor="white"></td>
				<td colspan="5" bgcolor="white">
					<table width="100%" cellspacing="1" cellpadding="2" >
					<tr>
						<td></td>
						<td width="20%"><b>Category</td>
						<td><b>Date</td>
						<td><b>Description</td>
						<td><b>Reference</td>
						<td><b>Claim Curr</td>
						<td align="right" width="15%"><b>Claim Amount</td>
						<td align="right" width="15%"><b>Payment</td>						
					</tr>
					<tr><td height="1" colspan="8" bgcolor="C0C0C0"></td></tr>
					<cfloop query="Details">
					<tr bgcolor="ffffdf">
						<td>#currentRow#.</td>
						<td width="20%">#IndicatorDescription#</td>
						<td>#DateFormat(InvoiceDate, CLIENT.DateFormatShow)#</td>
						<td>#Description#</td>
						<td>#Reference#</td>
						<td>#InvoiceCurrency#</td>
						<td align="right" width="15%">#numberFormat(InvoiceAmount,"__,__.__")#</td>
						<td align="right" width="15%">#numberFormat(AmountPayment,"__.__")#</td>
						
					</tr>
					
					<cfif processWF eq "0">

						    <!--- nada --->
							
					<cfelse>
						
						<!--- check for double funding of that class --->
																		
						<cfif claimcategory neq "TRM">
						
							<cfquery name="Funding" 
								 	datasource="appsTravelClaim" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT   L.ClaimRequestId, 
									         L.ClaimRequestLineNo, 
											 L.ClaimCategory, 
											 L.PersonNo, 
											 L.Currency, 
											 L.RequestAmount, 
											 L.Remarks
									FROM     ClaimRequestLine L INNER JOIN
							                 ClaimRequest ON L.ClaimRequestId = dbo.ClaimRequest.ClaimRequestId
							        WHERE    (L.ClaimCategory = '#ClaimCategory#') 
									AND      ClaimRequest.ClaimRequestId = '#Claim.ClaimRequestid#' 
							</cfquery>
													
							<cfif funding.recordcount gte "2">
							
								<cfif currentrow eq "1">
								<script>
									maximizereq('#ClaimCategory#_#PersonNo#')
								</script>							
								</cfif>									
								
								<tr bgcolor="ffffff"><td></td>
								    <td colspan="7" id="ln_#transactionno#">
							    	<cfset url.transactionNo  = "#transactionNo#">
									<cfset url.claimrequestid = "#claim.claimrequestid#">								
									<cfset url.claimcategory  = "#ClaimCategory#">
									<cfinclude template       = "ClaimInfoLineOTH_editsave.cfm">																		
								    </td>
								</tr>
								
								<cfif currentrow is recordcount>
								
								 <tr><td colspan="2">
								  Confirm Claim - Request Line Association :
								   <input type="checkbox"
							       name="Confirm_#url.ClaimCategory#"
								   <cfif details.matchingaction is '1'>checked</cfif>
							       value="1"
							       onClick="ColdFusion.Ajax.submitForm('processaction','#SESSION.root#/TravelClaim/Application/ClaimEntry/ClaimInfoLineOTH_submit.cfm?val='+this.checked+'&claimid=#url.claimid#&claimcategory=#claimcategory#')">
							     </td></tr>								
								
								</cfif>
							
							</cfif>		
						
						</cfif>				
						
					</cfif>
										
					<cfif CurrentRow neq Recordcount>
						<tr><td height="1" colspan="8" bgcolor="e4e4e4"></td></tr>
					</cfif>
					
					</cfloop>
										
					</table>
				</td>		
				</tr>
		
		</cfif>
				
	</cfoutput>
	
	<cfoutput>
	
	<cfif src eq "Line" and amt gt "0">
	
		<tr bgcolor="f5f5f5">
		        <td></td>
				<td colspan="3"><b>Claim Total:</b></td>
				<td>#Claim.PaymentCurrency#</td>
				<td align="right"><font color="gray"><b>#numberFormat(amt,"__,__.__")#</b></td>
				
		</tr>
		
		<!--- hide claim advance off-set once uploaded into IMIS --->
		
		<cfif Claim.ReferenceNo eq "">
		
			<cfif adv neq "">
			
				<tr bgcolor="ffffdf">
				        <td></td>
				        <td colspan="3"><b>Less:</b> Travel Advance(s):</td>
						<td>#Claim.PaymentCurrency#</td>
						<td align="right"><font color="red"><b>(#numberFormat(adv,"__,__.__")#)</b></td>
					
				</tr>	
			
			</cfif>
		
			<cfif advances.recordcount gt "0">
			
					<tr bgcolor="ffffef">	
					    <td></td>		        
				        <td colspan="5">
						<img src="<cfoutput>#SESSION.root#</cfoutput>/images/warning.gif" align="absmiddle" alt="" border="0">
						The claim will be reviewed to take into account the Other Advances noted</td>
									
				</tr>	
			
			</cfif>
		
			<tr bgcolor="f9f9f9">
			        <td></td>
			        <td colspan="3"><b>
					<cfif (amt-adv) gt "0">
					Estimated Payable:
					<cfelse>
					<font color="FF0000">Estimated Recovery</font>
					</cfif>
					
					</b></td>
					<td>#Claim.PaymentCurrency#</td>
					<td align="right" bgcolor="f2f2f2">
					<cfif amt-adv gte "0">
					  <cfset color = "black"> 
					<cfelse>
					  <cfset color = "804040"> 
					</cfif>
					<b><font size="2" color="#color#">#numberFormat(amt-adv,"__,__.__")#</b></td>					
			 </tr>		
			 
			 
		</cfif>	
		
		
		
	</cfif>
	
	<cfif src eq "LineExternal" and Claim.Reference neq "">		
		
			<cfquery name="Offset" 
		 	datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     IMP_CLAIMOFFSET
			WHERE    f_dorf_id_code_pybh = '#Claim.Reference#' 
			AND      f_pybh_doc_id = '#Claim.ReferenceNo#'
			</cfquery>
			
			
			<tr bgcolor="white">
		        <td></td>
				<td colspan="3"><b><font color="gray">Claim Total:</b></td>
				<td>#Claim.PaymentCurrency#</td>
				<td align="right"><font color="gray"><b>#numberFormat(amt,"__,__.__")#</b></td>
				
			</tr>
			
			<cfloop query="Offset">

			<tr bgcolor="ffffdf">
		        <td></td>
		        <td colspan="3"><b>Less:</b> Offset #f_dorf_id_code_rcvh# #f_rcvh_doc_id#</td>
				<td>#Claim.PaymentCurrency#</td>						
				<td align="right"><font color="red"><b>(#numberFormat(offset_amt,"__,__.__")#)</b></td>					
			</tr>	
							
			</cfloop>
			
			<cfif offset.recordcount gte "1">
			
				<cfquery name="Offset" 
			 	datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   sum(offset_amt) as Offset
				FROM     IMP_CLAIMOFFSET
				WHERE    f_dorf_id_code_pybh = '#Claim.Reference#' 
				AND      f_pybh_doc_id = '#Claim.ReferenceNo#'
				</cfquery>
				
				<tr bgcolor="f5f5f5">
			        <td></td>
					<td colspan="3"><b>Amount Paid:</b></td>
					<td>#Claim.PaymentCurrency#</td>
					
					<cfif amt gte Offset.Offset>
					<td align="right"><font color="gray"><b>#numberFormat(amt-Offset.Offset,"__,__.__")#</b></td>
					<cfelse>
					<td align="right"><font color="red"><b>#numberFormat(amt-Offset.Offset,"__,__.__")#</b></td>
					</cfif>
									
				</tr>
			
			</cfif>
		
		</cfif>
	
	</cfoutput>
			
</cfloop>	

<cfquery name="NoMatchCityDSA" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	
SELECT DISTINCT A.ClaimId, A.PersonNo, A.ClaimCategory, A.CountryCityId, A.LocationCode, 
		A.CalendarDate,B.dateeffective, B.dateExpiration, B.countrycityid as EmptyCityid,
		datediff(dd,A.CalendarDate,isnull(B.dateExpiration,'01/01/2099')) as diffdate
FROM         ClaimLineDSA  A , Ref_countrycitylocation B
WHERE     (A.ClaimId = '#Claim.ClaimId#')
		and A.countrycityid *= B.countrycityid 
		and B.locationdefault =1
		and  datediff(dd,A.CalendarDate,isnull(B.dateExpiration,'01/01/2099')) >=1 
		and  datediff(dd,A.CalendarDate,isnull(B.dateEffective,'01/01/1980')) <=1 
GROUP BY  A.ClaimId, A.PersonNo, A.ClaimCategory, A.CountryCityId, A.LocationCode, 
		A.CalendarDate,B.dateeffective, B.dateExpiration,b.countrycityid
HAVING 
 	B.countrycityid is null
	order by A.countrycityid,A.locationCode
 </cfquery>	
<cfset submissionoff ="1">
<cfif NoMatchCityDSA.recordcount gte "1">
<cfset submissionoff ="0">
</cfif>
<cfparam name="submission" default="1">

  <cfif submission eq "1">

	  <cfif claim.actionStatus gte "1" and claim.actionStatus lt "3">	
	  
	  	<tr bgcolor="ffffff">
						
			<td colspan="6" align="center">
			<cfquery name="Validate" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     TOP 1 *
		    FROM       ClaimValidation 
			WHERE      ClaimId = '#ClaimId#'
			</cfquery>	
			<cfoutput>
				<cfif Validate.recordcount eq "1">
				   <img src="#SESSION.root#/Images/status_critical.gif" alt="This claim will require additional review" border="0" align="absmiddle">
					 &nbsp;Claim will be sent to your EO/Travel Claim Unit.&nbsp;
				<cfelseif submissionoff eq "0">
				   <img src="#SESSION.root#/Images/status_critical.gif" alt="This claim does not have a Valid DSA Association contact EO " border="0" align="absmiddle">
					 &nbsp;Please Contact EO.&nbsp;
								
				<cfelse>
				  <img src="#SESSION.root#/Images/status_perfect.gif" alt="This claim will not require additional review" border="0" align="absmiddle">
					 &nbsp;<b>Excellent</b>, your Travel Claim has been screened by the Portal.&nbsp;
				 
				</cfif>
				
			</cfoutput>
			
			</td>
			
			</tr>		 
				 
	  </cfif> 
  
  </cfif>

</table>

</body>


