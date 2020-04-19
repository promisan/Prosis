
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
			id="LastName"
			required="true"
			maxlength="40"			
			class="form-control enterastab">
	</div>

	<!---
	<div class="form-group">
		<label for="MaidenName"><cf_tl id="Maiden name">:</label>
		<cf_tl id="Please enter a valid maiden name" var="1">
		<cfinput type="Text"
			name="MaidenName"
			id="MaidenName"
			message="#lt_text#"
			maxlength="40"
			class="form-control enterastab">
	</div>
	--->

	<div class="form-group">
		<label for="FirstName"><cf_tl id="First name"> <span style="color:##EF4D50; font-weight:bold;">*</span> :</label>
		<cf_tl id="Please enter a valid first name" var="1">
		<cfinput type="Text"
			name="FirstName"
			id="FirstName"
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
			message="#lt_text#"
			maxlength="20"
			class="form-control enterastab">
	</div>
	
	<div class="form-group">
		<label for="Reference"><cf_tl id="Reference"> <span style="color:##EF4D50; font-weight:bold;">*</span>:</label>
		<cf_tl id="Please enter a valid reference" var="1">
		<cfinput type="text"
			name="reference"
			id="reference"
			required="true"
			message="#lt_text#"
			maxlength="20"			
			class="form-control enterastab">
	</div>

	<div class="form-group">
	<!---
		<label><cf_tl id="Gender"> <span style="color:##EF4D50; font-weight:bold;">*</span> :</label>
		--->
		<table> <tr>
				<td><input type="radio" name="Gender" style="height:19px;width:19px" class="enterastab" value="M" checked></td>
				<td style="padding-left:5px;padding-top:3px;font-size:14px"><cf_tl id="Male"></td>							
				<td style="padding-left:10px"><input type="radio" name="Gender" style="height:19px;width:19px" class="enterastab" value="F"></td>
				<td style="padding-left:5px;padding-top:3px;font-size:14px"><cf_tl id="Female"></td>			
				</tr>
		</table>
		
	</div>

	<div class="form-group">
		<label><cf_tl id="Date of birth"> <span style="color:##EF4D50; font-weight:bold;">*</span> :</label>
		<cf_tl id="Please enter a valid date of birth" var="1">
		<cf_intelliCalendarDate9
			FieldName="DOB" 
			Default=""
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
					<option value="#Code#"><cf_tl id="#Description#"></option>
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
			message="#lt_text#"	       
			required="true"
			maxlength="50"			
			class="form-control enterastab">
	</div>

</cfoutput>