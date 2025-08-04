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
<cfoutput>
						<table style="width:100%" class="formspacing">
							<tr class="labelmedium">
								<td width="2%">#i#</td>	
								
								<td>
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
								<td>
									
									<cfif qBeneficiaries.FirstName eq "" or checkBeneficiary.recordcount eq 0>
										<cf_tl id="First Name" var="1">						
										<input type="text" 
								 			style = "background-color:ffffaf;width:240px;text-align:left;padding-right:3px" 
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
								<td>
									
									<cfif qBeneficiaries.LastName eq "" or checkBeneficiary.recordcount eq 0>
										<cf_tl id="Last Name" var="1">
										<input type="text" 
							 				style = "background-color:ffffaf;width:320px;text-align:left;padding-right:3px" 
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
								<td>
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
								<td style="min-width:180px">
														
									<cfif qBeneficiaries.BirthDate eq "" or checkBeneficiary.recordcount eq 0>
									
										<cf_intelliCalendarDate9
											FieldName="BeneficiaryDOB" 
											id="BeneficiaryDOB_#url.crow#_#i#" 
											Manual="True"		
											class="regularxl"	
											style="width:120px"	
											DateValidEnd="#dateformat(now(),'YYYYMMDD')#"
											Default="#dateformat(qBeneficiaries.Birthdate,client.dateformatshow)#"
											onchange="applyBeneficiaryData('#URL.warehouse#','#qBeneficiaries.BeneficiaryId#','#qBeneficiaries.CustomerId#','#transactionid#','Birthdate',this.value,'#URL.crow#')"
											AllowBlank="True">
											
									<cfelse>
										#dateformat(qBeneficiaries.Birthdate,client.dateformatshow)#
									</cfif>			

								</td>
								
						 </tr>
						</table>
</cfoutput>