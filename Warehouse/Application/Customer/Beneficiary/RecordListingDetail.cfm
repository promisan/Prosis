<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="URL.mode" default="regular"> 

	<cfquery name="qBeneficiary" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM CustomerBeneficiary
		WHERE BeneficiaryId = '#URL.BeneficiaryId#'
	</cfquery>

	<cf_screentop height="100%" 
		  scroll="Yes" 
		  label="Edit Beneficiary: #qBeneficiary.FirstName# #qBeneficiary.LastName#" 
		  layout="webapp" 
		  systemmodule="Warehouse" 
		  functionclass="Window" 
		  functionName="Beneficiary Edit" 
		  jQuery="yes"
		  line="no"
		  banner="gray">
		  
	<cf_calendarscript>	  

<cfquery name="qRelationship"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Relationship
      ,Description
      ,ListingOrder
      ,OfficerUserId
      ,OfficerLastName
      ,OfficerFirstName
      ,Created
  	FROM Employee.dbo.Ref_Relationship
</cfquery>

<cfform 
	name="frmBeneficiary" 
	action="../Beneficiary/RecordSubmit.cfm?CustomerId=#url.customerid#&BeneficiaryId=#url.BeneficiaryId#" 
	method="POST">
<cfoutput>
<table width="100%">
	
	<tr>
		<td width="2%"></td>
		<td colspan="3">
			<table width="100%">
				<tr>
					<td width="20%">
						<cf_tl id="BirthDate">:
					</td>	
					<td>
						<cf_intelliCalendarDate9
							FieldName="BirthDate" 
							id="BirthDate" 
							Manual="True"		
							class="regularxl"		
							DateValidEnd="#dateformat(now(),'YYYYMMDD')#"
							Default="#dateformat(qBeneficiary.Birthdate,client.dateformatshow)#"
							AllowBlank="True">							
					</td>	
				</tr>
				<tr>
					<td width="20%">
						<cf_tl id="FirstName">:
					</td>	
					<td>
							<input type="text" 
					 			style = "background-color:ffffaf;width:240;text-align:leftpadding-right:3px" 
					 			id    = "FirstName"
					 			name  = "FirstName"
					 			class = "regularxl enterastab"
					 			placeholder="First Name"
					 			value = "#qBeneficiary.FirstName#">
							</input>

					</td>	
				</tr>	
				<tr>
					<td width="20%">
						<cf_tl id="LastName">:
					</td>	
					<td>
							<input type="text" 
					 			style = "background-color:ffffaf;width:240;text-align:leftpadding-right:3px" 
					 			id    = "LastName"
					 			name  = "LastName"
					 			class = "regularxl enterastab"
					 			placeholder="Last Name"
					 			value = "#qBeneficiary.LastName#">
							</input>

					</td>	
				</tr>	
				<tr>
					<td width="20%">
						<cf_tl id="Relationship">:
					</td>	
					<td>
						<select name="Relationship" 
								id	="Relationship" 
								style="font-size:16px" class="regularxl enterastab"> 
									<option value="" <cfif qBeneficiary.Relationship eq "">selected</cfif>></option>
									<cfloop query="qRelationship">
										<option value="#qRelationship.Relationship#" <cfif qBeneficiary.Relationship eq qRelationship.Relationship>selected</cfif>>#qRelationship.Description#</option>
									</cfloop>
						</select>
					</td>	
				</tr>						
					

				<tr>
					<td width="20%">
						<cf_tl id="Gender">:
					</td>	
					<td>
						<select name="Gender" 
							id	="Gender" 
							style="font-size:16px" class="regularxl enterastab">
								<option value=""  <cfif qBeneficiary.Gender eq "">selected</cfif>></option>
								<option value="M" <cfif qBeneficiary.Gender eq "M">selected</cfif>><cf_tl id="Male"></option>
								<option value="F" <cfif qBeneficiary.Gender eq "F">selected</cfif>><cf_tl id="Female"></option>
						</select>

					</td>	
				</tr>						

				<tr height="40px">
					<td></td>
					<td align="left">
						<cf_tl id="Save" var="1">
						<input type="Submit" onclick="Prosis.busy('yes')" id="btnSubmit" name="btnSubmit" class="button10g" value="#lt_text#">
					</td>
				</tr>
					
			</table>
		</td>
		<td width="2%"></td>
	</tr>	

	<tr height="40px">
		<td></td>
		<td colspan="3" align="center" style="font-weight:bold" class="labelit">
			Last 3 sales
		</td>
		<td></td>	
	</tr>	
	<cfinclude template="BeneficiaryHistory.cfm">

</table>
</cfoutput>
</cfform>


<cfset ajaxonload("doHighlight")>
<cfset ajaxonload("doCalendar")>