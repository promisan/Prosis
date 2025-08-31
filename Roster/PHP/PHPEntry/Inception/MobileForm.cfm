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
<cfif get.recordcount eq "0">

    <cftry>	  
	
		<cfset frm = session.myForm>
							
		<cfif url.entrymode eq "extended">				
			<cfif IsDefined("frm.lastname2")> 		   				
		     	<cfset get = session.myform>
		    </cfif>
		<cfelse>
			 <cfif IsDefined("frm.lastname")> 	
		     	<cfset get = session.myform>
		    </cfif>		
		</cfif>		
					  
	    <cfset mydob = get.dob>	
	     	
	<cfcatch>
		
	    <cfset mydob = get.dob>	
		
	</cfcatch>
	
	</cftry>
	
<cfelse>

	<cfset mydob = dateformat(get.dob,client.dateformatshow)>
	
</cfif>

<cfoutput>
	<input type="hidden" name="PersonNo"          value="">
	<input type="hidden" name="SubmissionEdition" value="Generic" class="hidden">
	<input type="hidden" name="Remarks"           value="">
	<input type="hidden" name="MaidenName"        value="">
	
	<div class="form-group">
		<label for="LastName"><cf_tl id="Last name"> <span style="color:##EF4D50; font-weight:bold;">*</span> :</label>
		<cf_tl id="Please enter a valid last name" var="1">
		<cfinput type="Text"
			name="LastName"
			message="#lt_text#"
			value="#Get.LastName#"
			id="LastName"
			required="true"
			maxlength="40"			
			class="form-control enterastab">
	</div>

	<div class="form-group">
		<label for="FirstName"><cf_tl id="First name"> <span style="color:##EF4D50; font-weight:bold;">*</span> :</label>
		<cf_tl id="Please enter a valid first name" var="1">
		<cfinput type="Text"
			name="FirstName"
			id="FirstName"
			value="#Get.FirstName#"
			message="#lt_text#"
			required="true"
			maxlength="30"			
			class="form-control enterastab">
	</div>

	<div class="form-group">
		<label for="Indexno"><cf_tl id="Indexno">:</label>
		<cf_tl id="Please enter a valid indexno" var="1">
		<cfinput type="text"
			name="indexno"
			id="indexno"
			value="#get.IndexNo#"
			message="#lt_text#"
			maxlength="20"
			class="form-control enterastab">
	</div>
	
	<div class="form-group">
		<label for="Reference"><cf_tl id="ReferenceTax"> <span style="color:##EF4D50; font-weight:bold;">*</span>:</label>
		<cf_tl id="Please enter a valid reference" var="1">
		<cfinput type="text"
			name="reference"
			id="reference"
			value="#get.Reference#"
			required="true"
			message="#lt_text#"
			maxlength="10"			
			class="form-control enterastab">
	</div>

	<div class="form-group">
	<!---
		<label><cf_tl id="Gender"> <span style="color:##EF4D50; font-weight:bold;">*</span> :</label>
		--->
		<table> <tr>
				<td><input type="radio" name="Gender" style="height:19px;width:19px" class="enterastab" value="M" <cfif Get.Gender IS "M" or Get.Gender is "">checked</cfif>></td>
				<td style="padding-left:5px;padding-top:3px;font-size:14px"><cf_tl id="Male"></td>							
				<td style="padding-left:10px"><input type="radio" name="Gender" style="height:19px;width:19px" class="enterastab" value="F" <cfif Get.Gender IS "F">checked</cfif>></td>
				<td style="padding-left:5px;padding-top:3px;font-size:14px"><cf_tl id="Female"></td>			
				</tr>
		</table>
		
	</div>

	<div class="form-group">
		<label><cf_tl id="Date of birth"> <span style="color:##EF4D50; font-weight:bold;">*</span> :</label>
		<cf_tl id="Please enter a valid date of birth" var="1">
		<cf_intelliCalendarDate9
			FieldName="DOB" 
			Default="#mydob#"
			message="#lt_text#"
			AllowBlank="False"			
			DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"				
			class="regularxl enterastab">
	</div>
	
	<cfquery name="qMarital" datasource="AppsSelection">
		SELECT    * 
		FROM      Ref_MaritalStatus
		ORDER BY  ListingOrder ASC
	</cfquery>

	<div class="form-group">
		<label for="MaritalStatus"><cf_tl id="Marital Status"> <span style="color:##EF4D50; font-weight:bold;">*</span> :</label>
		<cf_tl id="Please select a valid marital status" var="1">
		<cfselect 
			name="MaritalStatus" 
			id="maritalstatus" 
			required="true" 
			message="#lt_text#" 			
			class="form-control enterastab">
				<option value=""><cf_tl id="Select"></option>
				<cfloop query="qMarital">
					<option value="#Code#" <cfif Code IS get.MaritalStatus>selected</cfif>><cf_tl id="#Description#"></option>
				</cfloop> 
		</cfselect>
	</div>

	<div class="form-group">
		<label for="Nationality"><cf_tl id="Nationality"> <span style="color:##EF4D50; font-weight:bold;">*</span> :</label>
		<cf_tl id="Please select a valid nationality" var="1">
		<cfselect 
			name="Nationality" 
			id="Nationality" 
			message="#lt_text#" 
			onError="show_error"
			class="form-control enterastab">
			
			<cfset nat = Get.Nationality>
				<cfif nat eq "">
					<cfset nat= PHPParameter.PHPNationality>
				</cfif>
			
			<cfloop query="Nation">
				<option value="#Code#" <cfif URL.DefaultCountry eq code>selected</cfif>>#Name#</option>
			</cfloop> 
		</cfselect>
	</div>

	<div class="form-group">
		<label for="emailaddress"><cf_tl id="Email"> <span style="color:##EF4D50; font-weight:bold;">*</span> :</label>
		<cf_tl id="Please enter a valid email address" var="1">
		<cfinput type="Text"
			name="emailaddress"
			id="emailaddress"
			value="#Get.EmailAddress#"
			message="#lt_text#"
			required="true"
			validate="email"
			maxlength="50"			
			class="form-control enterastab">
	</div>

	<div class="form-group">
		<label for="MobileNumber"><cf_tl id="Mobile Number"> <span style="color:##EF4D50; font-weight:bold;">*</span> :</label>
		<cf_tl id="Please enter a valid mobile number" var="1">
		<cfinput type="Text"
			name="MobileNumber"
			id="MobileNumber"	
			value="#Get.MobileNumber#"
			message="#lt_text#"	       
			required="true"
			maxlength="50"			
			class="form-control enterastab">
	</div>
	
	<div class="form-group">
		<label for="PhoneNumber"><cf_tl id="Fixed Land line Number">:</label>
		<cf_tl id="Please enter a valid mobile number" var="1">
		<cfinput type="Text"
			name="PhoneNumber"
			id="PhoneNumber"	
			value="#Get.PhoneNumber#"
			message="#lt_text#"	       
			required="false"
			maxlength="50"			
			class="form-control enterastab">
	</div>

</cfoutput>