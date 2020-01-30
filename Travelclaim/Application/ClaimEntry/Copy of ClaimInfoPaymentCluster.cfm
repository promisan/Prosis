
<cfoutput query="Cluster" group="ModeOrder">

      <table width="100%" cellspacing="0" cellpadding="0">
	  <tr><td height="18">#ModeDescription#</td></tr>
	  <tr><td bgcolor="D1D7D0"></td></tr>
	  
	  </table>

     <cfoutput>
    
    <table class="#cl#" id="#paycde#" width="100%" border="0" bgcolor="fbfbfb" cellspacing="0" cellpadding="1" bordercolor="E4E4E4" rules="rows">
			
	<tr><td>
	
	<cfquery name="Check" 
	  datasource="appsTravelClaim" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_Cluster INNER JOIN
	            Ref_ClusterField ON Ref_Cluster.ClusterCode = Ref_ClusterField.ClusterCode
		WHERE   Ref_ClusterField.FieldLookup = 'PersonAccount'
		  AND   Ref_Cluster.ClusterCode = '#ClusterCode#'
	</cfquery>	
											
	<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="E4E4E4" rules="rows">
		<tr>
		   <td valign="top">
		  	   <table width="100%" cellspacing="0" cellpadding="0">
			   <tr bgcolor="DCF1EF">
			      <td height="17">&nbsp;#Description#</td>
				  <td align="right">
				  <cfif #HelpId# gt "1">
				 			 			  
					   <cf_helpfile 
					   	code = "#helpfile#" 
						id   = "#helpid#">
						&nbsp;
				  
				  </cfif>
				  </td>
			   </tr>
			  
			   </table>
		   </td>
		 </tr>
		 
		 <tr>  
		    <td>							 
				<table width="100%" cellspacing="0" cellpadding="0">

				  	<tr><td colspan="2" height="1" bgcolor="e1e1e1"></td></tr>   			
					  <tr><td colspan="2" height="2" ></td></tr>   			
					
				    <cfif #c# neq "#paycde#">
											
						<cfif #Check.recordcount# eq "0">
						
						    <tr>
							    <td width="30%" height="20">Currency</td>
							    <td width="70%">
								
								<cfif #Claim.ActionStatus# neq "3">
								
						    		<cfif #curr# eq "0">
									 &nbsp;#Request.PaymentCurrency#
									 <input type="hidden" name="PaymentCurrency_#paycde#" value="#Request.PaymentCurrency#">
									<cfelse> 
									
									<cfquery name="Currency" 
							 		  datasource="appsTravelClaim" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
										 SELECT DISTINCT Currency
										 FROM ClaimRequestLine
									 </cfquery>
									
									 <select name="PaymentCurrency_#paycde#">
									    <cfloop query="Currency">
										<option value="#currency#" <cfif Currency eq Request.PaymentCurrency>selected</cfif>>#Currency#</option>
										</cfloop>
								     </select>
									</cfif>
									
								<cfelse>
								
									&nbsp;#Request.PaymentCurrency#
								
								</cfif>	
									
					 		    </td>
							</tr>
						 
						<cfelse>
						 
							 <input type="hidden" name="PaymentCurrency_#paycde#" value="#Request.PaymentCurrency#">
						 
						 </cfif>
					 
					</cfif> 
					
					<cfset c = "#paycde#">
								
					<cfquery name="Fields" 
					datasource="appsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
					    FROM Ref_ClusterField
						WHERE ClusterCode ='#ClusterCode#'
						ORDER BY ListingOrder
				   	</cfquery>
																			
					<cfloop query="Fields">
					
						<cfif Claim.ClaimId neq "">
						
							<cfquery name="Value" 
							datasource="appsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
							    FROM ClaimReimbursement
								WHERE ClaimId    = '#Claim.ClaimId#'
								AND  ClusterCode = '#clustercode#'
								AND  FieldName   = '#FieldName#'
						   	</cfquery>
							
							<cfset val = "#Value.FieldValue#">
									
						<cfelse>
						
							<cfset val = "">
						
						</cfif>
						
																	  
						<cfswitch expression="#FieldLookup#">
						  
						      <cfcase value="PersonAccount">
							  
							  <tr>
							      <td width="20%">&nbsp;Account:</td>
								  <td height="20" colspan="1">
								  							  
							      <cfif #Claim.ActionStatus# neq "3">
							  						
									<select name="f#paycde#_#clustercode#_#fieldname#" tyle="background-color: f4f4f4;">
										<cfloop query="Account">
										<cfif #len(BankName)# gt 30>
										  <cfset nm = #left(BankName, 30)#>
										<cfelse>
										  <cfset nm = #BankName#>
										</cfif>
										<option value="#AccountId#" <cfif #val# eq "#AccountId#">selected</cfif>>#nm# #AccountCurrency# ...#right(AccountNo,4)#</option>
										</cfloop>
									</select>
																		
									<cfelse>
									
										<cfif val neq "">
									
										<cfquery name="Lookup" 
										datasource="appsTravelClaim" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT *
										    FROM PersonAccount
											WHERE AccountId = '#val#'
											ORDER BY DateEffective DESC
									   	</cfquery>
										
										<b>#Lookup.BankName# #Lookup.AccountCurrency# ...#right(Lookup.AccountNo,4)#
										
										</cfif>
																	
									</cfif>
										  
							  </cfcase>
							  
							  <!--- not relevant for now 
							  							  
							  <cfcase value="PersonAddress">
														  
							  <tr>
								  <td width="100%" height="20" colspan="1">
							  							  
								  <cfquery name="Address" 
								    datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT P.*, R.Description as TypeDescription
										FROM PersonAddress P, Ref_AddressType R
										WHERE PersonNo = '#Claim.PersonNo#'
										AND   P.AddressType = R.AddressType
										<!--- AND   P.AddressType IN ('1','8') --->
								  </cfquery>
								  							  
							      <cfif #Claim.ActionStatus# neq "3">
							  				
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr><td width="20%">&nbsp;Address type:</td>			
										<td>
										<select name="f#paycde#_#clustercode#_#fieldname#" style="background-color: ffffff;" onChange="address(this.value)">
											<cfloop query="Address">
											   <option value="#AddressId#" <cfif #val# eq "#AddressId#">selected</cfif>>#TypeDescription#</option>
											</cfloop>
										</select>
										</td>
										
										<script language="JavaScript">
										
										function address(id)
										{
										ad0 = document.getElementById("Address_"+id)
										ad  = document.getElementById("Address")
										ad.value  = ad0.value
										ad0 = document.getElementById("Address2_"+id)
										ad  = document.getElementById("Address2")
										ad.value  = ad0.value
										ad0 = document.getElementById("AddressCity_"+id)
										ad  = document.getElementById("AddressCity")
										ad.value = ad0.value
										ad0 = document.getElementById("AddressPostalCode_"+id)
										ad  = document.getElementById("AddressPostalCode")
										ad.value = ad0.value
										ad0 = document.getElementById("Country_"+id)
										ad  = document.getElementById("Country")
										ad.value = ad0.value
										ad0 = document.getElementById("TelephoneNo_"+id)
										ad  = document.getElementById("TelephoneNo")
										ad.value = ad0.value
										}
										
										</script>
																										
										<cfloop query="Address">
											<input type="hidden" id="Address_#Addressid#"     value="#Address#">
											<input type="hidden" id="Address2_#Addressid#"    value="#Address2#">
											<input type="hidden" id="AddressCity_#Addressid#" value="#AddressCity#">																		
											<input type="hidden" id="AddressPostalCode_#Addressid#" value="#AddressPostalCode#">
											<input type="hidden" id="Country_#Addressid#"     value="#Country#">	
											<input type="hidden" id="TelephoneNo_#Addressid#" value="#TelephoneNo#">	
										</cfloop>
																				
										<cfquery name="Address" 
										 datasource="AppsEmployee" 
										 username="#SESSION.login#" 
										 password="#SESSION.dbpw#">
											SELECT *
											FROM  PersonAddress
											WHERE PersonNo = '#Claim.PersonNo#'
											<cfif #Val# neq "">
												AND AddressId = '#val#' 
											</cfif>
										</cfquery>
																				
										<tr><td>&nbsp;Address 1:</td>
										     <td>
											<input type="text" name="Address" value="#Address.Address#" size="50" class="regular" disabled>
										</td></tr>
										<tr><td>&nbsp;Address 2:</td><td>
											<input type="text" name="Address2" value="#Address.Address2#" size="50" class="regular" disabled>
										</td></tr>
										<tr><td>&nbsp;City:</td><td>
											<input type="text" name="AddressCity" value="#Address.AddressCity#" size="50" class="regular" disabled>
										</td></tr>
										<tr><td>&nbsp;Postal code:</td><td>
											<input type="text" name="AddressPostalCode" value="#Address.AddressPostalCode#" size="4" class="regular" disabled>
											<input type="text" name="Country" value="#Address.Country#" size="10" class="regular" disabled>
										</td></tr>
										<tr><td>&nbsp;Telephone:</td><td>
											<input type="text" name="TelephoneNo" value="#Address.TelephoneNo#" size="20" class="regular" disabled>
										</td></tr>
										</table>
																																					
									<cfelse>
									
										<cfif #val# neq "">
									
											<cfquery name="Address" 
											datasource="AppsEmployee" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT *
											    FROM PersonAddress
												WHERE AddressId = '#val#' 
										   	</cfquery>
											
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr><td>
												<input type="text" name="Address" value="#Address.Address#" size="50" class="regular1" disabled>
											</td></tr>
											<tr><td>
												<input type="text" name="Address2" value="#Address.Address2#" size="50" class="regular1" disabled>
											</td></tr>
											<tr><td>
												<input type="text" name="AddressCity" value="#Address.AddressCity#" size="50" class="regular1" disabled>
											</td></tr>
											<tr><td>
												<input type="text" name="AddressPostalCode" value="#Address.AddressPostalCode#" size="10" class="regular1" disabled>
												<input type="text" name="Country" value="#Address.Country#" size="10" class="regular1" disabled>
												
											</td></tr>
											<tr><td>
												<input type="text" name="TelephoneNo" value="#Address.TelephoneNo#" size="20" class="regular1" disabled>
											</td></tr>
											</table>
																				
										</cfif>
																	
									</cfif>
																			  
							  </cfcase>
							  
							  --->
							
							  <cfdefaultcase>
							  
							  <tr>
								  <td width="18%" height="20"><b>&nbsp;#Fields.Description#&nbsp;</b>:
								  <cfif #FieldRequired# eq "1"><font color="FF0000">*</font></cfif>
								  </td>
								  <td width="70%">
							  
								  <cfif #Claim.ActionStatus# neq "3">
								  
									  <cfinput 
								         type="text" 
										 name="f#paycde#_#clustercode#_#fieldname#" 
										 value="#Val#"
										 size="#FieldLength#" 
										 validation="#FieldValidation#"
								         maxlength="#FieldLength#">
								  						  
								  <cfelse><b>#Val#</b>
								 						 					  
								  </cfif>
								
							  </cfdefaultcase>
							 							 						  
						  </cfswitch>
						 						  
						  </td></tr>
																	
				</cfloop>
				
				</table>	
												
			</td>
			</tr>
				
		</table>	
												
	</td>
	</tr>
			
	</table>
	
	<table><tr><td height="1"></td></tr></table>
	
	</cfoutput>
							
</cfoutput>