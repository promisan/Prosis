

<!--- ---------- --->
<!--- Costs----- --->
<!--- ---------- --->

<cfoutput>
	
	<cfif URL.Topic neq "Cost">
	
		 <cfquery name="EventCheck" 
					datasource="appsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
				    FROM ClaimEvent C
				    WHERE ClaimId = '#URL.ClaimId#' 
					ORDER BY EventDateEffective DESC
		</cfquery>
		
		<cfquery name="Heading" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT RC.*
			FROM   Ref_Indicator R,
				   Ref_IndicatorCategory RC,
				   Ref_ClaimCategoryIndicator CI
		  	WHERE  R.Category = RC.Code
			AND   RC.ClaimSection = 'Cost'
			AND CI.IndicatorCode = R.Code
			AND CI.ClaimCategory IN (SELECT ClaimCategory 
			                         FROM ClaimRequestLine 
									 WHERE ClaimRequestId = '#Claim.ClaimRequestId#')
			ORDER BY RC.ListingOrder					
						 
		</cfquery>
		
		<cfloop query="Heading">
		
			<cfif Event eq "0" and cls neq "TRM">
			
				<tr><td height="6"></td></tr>
				<tr><td colspan="9" height="30">
					<cf_summaryheader name="#description#">
				</td></tr>
																				
			</cfif>
							
			<cfquery name="Indicator" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT C.*, R.*
			    FROM   ClaimEventIndicator C, 
				       Ref_Indicator R
			    <cfif Event eq "1">
				WHERE ClaimEventId = '#ClaimEventId#'
				<cfelse>
				WHERE ClaimEventId IN (SELECT ClaimEventid 
				                       FROM ClaimEvent 
									WHERE ClaimId = '#URL.ClaimId#')
				</cfif>
				AND   C.IndicatorCode = R.Code
				AND   R.Category = '#Code#' 
				<cfif cls eq "TRM">
				AND   R.ClaimCategory = 'TRM' 
				AND   C.ClaimEventId IN (SELECT ClaimEventId FROM ClaimEventIndicatorCost)
				<cfelse>
				AND   R.ClaimCategory != 'TRM' 
				</cfif>
			</cfquery>
			
											
			<cfif Indicator.recordcount gt "0">
				
				<cfloop query="Indicator">
				
				<tr><td height="3"></td></tr>
									
					<cfif Description neq Heading.Description>
					<tr>
					   <td height="20" colspan="7" bgcolor="white">&nbsp;&nbsp;&nbsp;<b><font color="0080FF">#Description#</b></td>
					   <td colspan="2" align="center" bgcolor="white"></td>
					</tr>
				    </cfif>
									
					<cfquery name="IndicatorCost" 
						datasource="appsTravelClaim" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT DISTINCT E.*, 
						       P.LastName, 
							   P.FirstName, 
							   P.IndexNo, 
							   P.Gender
					    FROM ClaimEventIndicatorCost E, 
						     stPerson P
						<cfif Event eq "1">
					       WHERE ClaimEventId = '#ClaimEventId#'
						<cfelse>
						   WHERE ClaimEventId IN (SELECT ClaimEventid 
						                        FROM ClaimEvent 
												WHERE ClaimId = '#URL.ClaimId#')
						</cfif>
						AND  E.PersonNo *= P.PersonNo
						AND  IndicatorCode = '#IndicatorCode#'   
						ORDER BY InvoiceDate
					</cfquery>
					
					<cfif IndicatorCost.recordcount gt "0">
					
						<tr>
						    <td colspan="9" bgcolor="white">
								<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" align="center" rules="rows">
								<tr><td valign="top" width="27"><img src="#SESSION.root#/Images/join.gif" alt="" border="0"></td>
								    <td>
										<table width="100%" frame="hsides" border="1" cellspacing="1" cellpadding="0" align="center" 
										  bordercolor="e4e4e4" 
										  bgcolor="ffffef" 
										  rules="rows">
										  
										  <tr><td>
											<table width="100%" cellspacing="0" cellpadding="0" align="center">
												<cfloop query="IndicatorCost">
																								
												    <cfif CurrentRow neq "1">
												    <tr>
													     <td colspan="7" bgcolor="E2E2E2"></td>
													</tr>
													</cfif>
																									
													<tr>
													    <td height="17" width="5%" align="center">
													      #currentRow#
													   </td>
													   <td width="35%" align="left">
													      <cfif PersonNo neq "" and PersonNo neq Claim.PersonNo>
														  #FirstName# #LastName#&nbsp;:
														  </cfif>
													      #Description#
														 
													   </td>
													   <td width="15%">
													      #Reference#
													   </td>
													   <td width="15%">
													      #InvoiceNo#
													   </td>
													   <td width="15%">
													      #DateFormat(InvoiceDate, CLIENT.DateFormatShow)#
													   </td>
													    <td width="10%" align="right">
													      #InvoiceCurrency#
													   </td>
													   <td width="15%" align="right">
													      #NumberFormat(InvoiceAmount,"__,__.__")#&nbsp;
													   </td>
													</tr>
												
												</cfloop>
											</table>
										   </td></tr>
										   
										</table>
									</td>
								</tr>
								</table>
							</td>
						</tr>
						
						<tr><td height="3"></td></tr>
					
					   </cfif>	
																								
				</cfloop>
				
			</cfif>
	
		</cfloop>
						
	</cfif>
		
</cfoutput>	
