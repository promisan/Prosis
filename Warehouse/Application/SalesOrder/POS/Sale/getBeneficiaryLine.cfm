<cfoutput>
						<table width = "100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="2%">
									#i#									
								</td>	
								<td width="10%">
									
									<cfif qBeneficiaries.FirstName eq "" or checkBeneficiary.recordcount eq 0>
										<cf_tl id="First Name" var="1">						
										<input type="text" 
								 			style = "background-color:ffffaf;width:240;text-align:right;padding-right:3px" 
								 			id    = "Beneficiary_FirstName_#url.crow#_#i#"
								 			name  = "Beneficiary_FirstName_#url.crow#_#i#"
								 			class = "regularxl enterastab"
								 			placeholder="#lt_text#"
								 			value = "#qBeneficiaries.FirstName#"
								 			onchange="applyBeneficiaryData('#URL.warehouse#','#qBeneficiaries.BeneficiaryId#','#qBeneficiaries.CustomerId#','#transactionid#','FirstName',this.value,'#URL.crow#')">
										</input>
									<cfelse>
										#qBeneficiaries.FirstName#		 
									</cfif>	
								</td>		 
								<td width="10%">
									
									<cfif qBeneficiaries.LastName eq "" or checkBeneficiary.recordcount eq 0>
										<cf_tl id="Last Name" var="1">
										<input type="text" 
							 				style = "background-color:ffffaf;width:320;text-align:right;padding-right:3px" 
							 				id    = "Beneficiary_LastName_#url.crow#_#i#"
							 				name  = "Beneficiary_LastName_#url.crow#"
							 				class = "regularxl enterastab"
							 				placeholder="#lt_text#"
							 				value = "#qBeneficiaries.LastName#"
							 				onchange="applyBeneficiaryData('#URL.warehouse#','#qBeneficiaries.BeneficiaryId#','#qBeneficiaries.CustomerId#','#transactionid#','LastName',this.value,'#URL.crow#')">
										</input>
									<cfelse>
										#qBeneficiaries.LastName#		 
									</cfif>		 
								</td>
								<td width="10%">
									<cfif qBeneficiaries.Gender eq "" or checkBeneficiary.recordcount eq 0>
										<select name="Beneficiary_Gender_#url.crow#_#i#" 
										id	="Beneficiary_Gender_#url.crow#_#i#" 
										style="font-size:16px" class="regularxl enterastab"
										onchange="applyBeneficiaryData('#URL.warehouse#','#qBeneficiaries.BeneficiaryId#','#qBeneficiaries.CustomerId#','#transactionid#','Gender',this.value,'#URL.crow#')">
								
											<option value=""  <cfif qBeneficiaries.Gender eq "">selected</cfif>></option>
											<option value="M" <cfif qBeneficiaries.Gender eq "M">selected</cfif>><cf_tl id="Male"></option>
											<option value="F" <cfif qBeneficiaries.Gender eq "F">selected</cfif>><cf_tl id="Female"></option>
										</select>
									<cfelse>
										#qBeneficiaries.Gender#		 
									</cfif>	
								</td>
								<td width="30%">
						
									<cfif qBeneficiaries.BirthDate eq "" or checkBeneficiary.recordcount eq 0>
										<cf_intelliCalendarDate9
											FieldName="BeneficiaryDOB" 
											id="BeneficiaryDOB_#url.crow#_#i#" 
											Manual="True"		
											class="regularxl"		
											DateValidEnd="#dateformat(now(),'YYYYMMDD')#"
											Default="#dateformat(qBeneficiaries.Birthdate,client.dateformatshow)#"
											onchange="applyBeneficiaryData('#URL.warehouse#','#qBeneficiaries.BeneficiaryId#','#qBeneficiaries.CustomerId#','#transactionid#','Birthdate',this.value,'#URL.crow#')"
											AllowBlank="True">
									<cfelse>
										#dateformat(qBeneficiaries.Birthdate,client.dateformatshow)#
									</cfif>			

								</td>
								<td width="20%">
									<cfif qBeneficiaries.Relationship eq "" or checkBeneficiary.recordcount eq 0>
										<select name="Beneficiary_Relationship_#url.crow#_#i#" 
											id	="Beneficiary_Relationship_#url.crow#_#i#" 
											style="font-size:16px" class="regularxl enterastab"
											onchange="applyBeneficiaryData('#URL.warehouse#','#qBeneficiaries.BeneficiaryId#','#qBeneficiaries.CustomerId#','#transactionid#','Relationship',this.value,'#URL.crow#')"> 
											<option value="" <cfif qBeneficiaries.Relationship eq "">selected</cfif>></option>
											<cfloop query="qRelationship">
												<option value="#qRelationship.Relationship#" <cfif qBeneficiaries.Relationship eq qRelationship.Relationship>selected</cfif>><cf_tl id="#qRelationship.Description#"></option>
											</cfloop>
										</select>
									<cfelse>
										#qBeneficiaries.Relationship#		 
									</cfif>	
								</td>
						 </tr>
						</table>
</cfoutput>