
<!--- edit all relevant field settings --->

<cf_screentop jquery="Yes" close="parent.ColdFusion.Window.destroy('myfield',true)" label="Listing field properties" html="No" scroll="Yes" layout="webapp" banner="yellow">

<script>

	function showId(id){
		$('#'+id).fadeIn();
	}
	
	function hideId(id){
		$('#'+id).fadeOut();
	}
	
</script>

<cfquery name="Field" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		 
	SELECT *
	FROM   Ref_ModuleControlDetailField
	WHERE  FieldId = '#URL.FieldId#'	
</cfquery>

<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		 
	SELECT *
	FROM   Ref_ModuleControlDetail
	WHERE  SystemFunctionId = '#Field.SystemFunctionId#'
	AND    FunctionSerialNo = '#Field.FunctionSerialNo#'	
</cfquery>

<!---
<cfset script = List.QueryScript>

<cfset script = replaceNoCase(script, "FROM"," FROM","ALL")>
<cfset script = replaceNoCase(script, "WHERE"," WHERE","ALL")>
<cfset script = replace(script, "ON"," ON","ALL")>   <!--- otherwise AddressZone would be incorrectly split --->
<cfset script = replaceNoCase(script, "INNER JOIN"," INNER JOIN","ALL")>
<cfset script = replaceNoCase(script, "LEFT OUTER JOIN"," LEFT OUTER JOIN","ALL")>

<cfset s = FindNoCase("FROM", script)>
 
<cfif Find("WHERE", script)>
   <cfset e = FindNoCase("WHERE", script)>
<cfelse>
   <cfset e = len(script)>
</cfif>

<cfset fr = mid(script,s+4,e-(s+3))>
--->

<table class="hide"><tr><td><iframe id="iframeSubmit" name="iframeSubmit"></iframe></td></tr></table>

<cfform name="fieldForm" id="fieldForm" action="FieldEditSubmit.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#" method="POST" target="iframeSubmit">

<cfoutput query="Field">

<table width="95%" align="center" class="formpadding formspacing">

	<tr> <td colspan="2" height="10px"></td> </tr>
	
	<tr>
		<td class="labellarge" colspan="2">
			<b>Field: #FieldName#</b>
		</td>
	</tr>

	<tr><td class="linedotted" colspan="2"></td></tr>

	<tr> <td colspan="2" height="10px"></td> </tr>
	
	<tr>
		<td colspan="2">
		
		<input type = "hidden" name = "FieldId"    id = "FieldId"    value = "#FieldId#">
		<input type = "hidden" name = "FunctionId" id = "FunctionId" value = "#SystemFunctionId#">
		<input type = "hidden" name = "SerialNo"   id = "SerialNo"   value = "#FunctionSerialNo#">
		
			<table width="95%" align="center">
				
				<tr class="line">
					<td colspan="2" class="labelmedium">
						<img src="#SESSION.root#/images/sqltable.gif" style="vertical-align:middle">&nbsp;&nbsp;Presentation of field
					</td>
				</tr>
								
				<tr>
					<td colspan="2">
						<table width="100%" class="formpadding formspacing">
						
							<tr>
								<td style="width:200px" class="labelmedium">
									Display :
								</td>
								<td class="labelmedium">
								    <table>
									<tr>
										<td><input style="width:18px;height:18px" type="radio" name="FieldDisplay" id="FieldDisplay" <cfif FieldInGrid eq "1">checked</cfif> onclick="form.ListingOrder.disabled=false" value="1"></td>
										<td style="padding-left:3px" class="labelmedium">In Grid</td>
										<td style="padding-left:6px" class="labelmedium"><input style="width:18px;height:18px" type="radio" name="FieldDisplay" id="FieldDisplay" <cfif FieldTree eq "1">checked</cfif> onclick="form.ListingOrder.disabled=true;" value="2"></td>
										<td style="padding-left:3px" class="labelmedium">In Tree</td>
										<td style="padding-left:6px" class="labelmedium"><input style="width:18px;height:18px" type="radio" name="FieldDisplay" id="FieldDisplay" <cfif FieldInGrid eq "0" and FieldTree eq "0">checked</cfif> onclick="form.ListingOrder.disabled=true;" value="3"></td>
										<td style="padding-left:3px" class="labelmedium">Do not show</td>									
									</tr>
									</table>
								</td>
							
								<td class="labelmedium">
									Row | Column | Colspan :
								</td>
								<td>
								
									<table>
									<tr>
									<td>
									<select id="FieldRow" style="width:48px" name="FieldRow" class="regularxl">
									 	<option value="1"  <cfif fieldrow eq "1">selected</cfif>>1</option> 
									 	<option value="2"  <cfif fieldrow eq "2">selected</cfif>>2</option> 
									 	<option value="3"  <cfif fieldrow eq "3">selected</cfif>>3</option>
									</select>
									</td>
									<td style="padding-left:5px;padding-right:5px">|</td>
									<td>									
									<cfif FieldTree eq 1>
										<cfinput type="text" name="ListingOrder" id="ListingOrder" value="#ListingOrder#" size="2" style="text-align:center" class="regularxl" range="0,999" disabled>
									<cfelse>
										<cfinput type="text" name="ListingOrder" id="ListingOrder" value="#ListingOrder#" size="2" style="text-align:center" class="regularxl" range="0,999">
									</cfif>
									</td>
									<td style="padding-left:5px;padding-right:5px">|</td>
									<td>									
										<cfinput type="text" name="FieldColSpan" id="FieldColSpan" value="#FieldColSpan#" size="2" style="text-align:center" class="regularxl" range="0,15">								
									</td>
									
									</tr>
									</table>
									
								</td>
							</tr>
							
							<tr>
								<td class="labelmedium">
									Column label :
								</td>
								<td>
									<input type="text" name="FieldHeaderLabel" id="FieldHeaderLabel" maxlength="30" value="#FieldHeaderLabel#" class="regularxl">
								</td>
			
								<td class="labelmedium">
									Alignment :
								</td>
								<td>
									<select id="FieldAlignment" name="FieldAlignment" class="regularxl">
									 	<option value="Left"   <cfif fieldalignment eq "Left">selected</cfif>>Left</option> 
									 	<option value="Center" <cfif fieldalignment eq "Center">selected</cfif>>Center</option> 
									 	<option value="Right"  <cfif fieldalignment eq "Right">selected</cfif>>Right</option>
									</select>
								</td>
							</tr>
							
							<tr>

								<td class="labelmedium">
									Content Format :
								</td>
								<td>
									<select name="FieldOutputFormat" id="FieldOutputFormat" class="regularxl">						 
									 	  <option value=""  <cfif fieldoutputformat eq "">selected</cfif>>Default</option> 
									 	  <option value="Date"  <cfif fieldoutputformat eq "Date">selected</cfif>>Date</option> 
									   	  <option value="Time"  <cfif fieldoutputformat eq "Time">selected</cfif>>Time</option> 
									   	  <option value="Amount" <cfif fieldoutputformat eq "Amount">selected</cfif>>Amount</option> 
										  <option value="eMail" <cfif fieldoutputformat eq "eMail">selected</cfif>>eMail</option> 											
									 </select>
								</td>
								
								<td class="labelmedium">
									Grouping / Sorting modality:
								</td>
								<td>
									  <select name="FieldSort" id="FieldSort" class="regularxl">													
										  	 <option value="1" <cfif fieldsort eq "1">selected</cfif>>Sort</option> 
											 <option value="2" <cfif fieldsort eq "2">selected</cfif>>Group</option> 
											 <option value="3" <cfif fieldsort eq "3">selected</cfif>>Sum</option> 
											 <option value="0" <cfif fieldsort eq "0">selected</cfif>>No</option> 																			
								      </select>
								</td>
								
							</tr>
						
							<tr>
								
								<td class="labelmedium">
									Column width :
								</td>
								<td style="height:25px" class="labelmedium">
									<input style="width:18px;height:18px" type="radio" name="FieldWidth" id="FieldWidth" value="0" onclick="hideId('divFieldWidth')" <cfif FieldWidth eq 0>checked</cfif>>Auto
									<input style="width:18px;height:18px" type="radio" name="FieldWidth" id="FieldWidth" value="1" onclick="showId('divFieldWidth')" <cfif FieldWidth gt 0>checked</cfif>>Fixed
									<span id="divFieldWidth" style="<cfif FieldWidth eq 0>display:none;</cfif>">
										&nbsp;<input type="text"  name="FieldWidthPixel" id="FieldWidthPixel" value="#FieldWidth#" size="2" style="text-align:center" class="regularxl">
										<span style="color:gray">pixels</span>
									</span>
								</td>
								
								<td colspan="2">
								</td>
							</tr>
						
						</table>
					</td>
				</tr>

				<tr><td colspan="2" height="10px"></td></tr>
				
				<tr class="line">
					<td colspan="2" class="labelmedium">
						<img src="#SESSION.root#/images/filter2.gif" style="vertical-align:middle">&nbsp;&nbsp;Filter on field
					</td>
				</tr>
								
				<tr>
					<td colspan="2">
					
						<table width="100%" class="formapadding formspacing">
						
							<tr>
							
								<td class="labelmedium" style="width:200px">Filter modality:</td>
								<td>
									 <select name="FieldFilterClass" id="FieldFilterClass"  class="regularxl" onChange="if (this.value == 'Text') { form.FieldFilterClassMode.disabled=false; if (form.FieldFilterClassMode.value==2){ showId('lookupId') } } else { form.FieldFilterClassMode.disabled=true; hideId('lookupId');}">
										  <option value=""       <cfif FieldFilterClass eq "">selected</cfif>>No, no filtering</option>					 
									 	  <option value="Text"   <cfif FieldFilterClass eq "Text">selected</cfif>>Text</option> 
										  <option value="Amount" <cfif FieldFilterClass eq "Amount">selected</cfif>>Amount</option> 
									 	  <option value="Date"   <cfif FieldFilterClass eq "Date">selected</cfif>>Date</option>   											
									 </select>
								</td>
							
								<td class="labelmedium">Filter label:</td>
								<td>
									<input type="text" name="FieldFilterLabel" id="FieldFilterLabel" value="#FieldFilterLabel#" width="60" maxlength="30" class="regularxl">
								</td>
								
								<td class="labelmedium">Enforce Filter selection:</td>
								<td>
									  <select name="FieldFilterForce" id="FieldFilterForce" class="regularxl">
													
										  	 <option value="0" <cfif FieldFilterForce eq "0">selected</cfif>>No</option> 
											 <option value="1" <cfif FieldFilterForce eq "1">selected</cfif>>Yes</option> 
																														
								      </select>
								</td>				
								
																
								<td class="labelmedium">Selection Interface [Text]:</td>
								<td>
									<select name="FieldFilterClassMode" 
									        id="FieldFilterClassMode" 
											class="regularxl" 
											<cfif fieldfilterclass eq "">disabled</cfif>
											onChange="if (this.value=='2') { showId('lookupId') }else{ hideId('lookupId') }">	
											
									  	<option value="0"  <cfif FieldFilterClassMode eq "0">selected</cfif>>Default</option> 
										<option value="4"  <cfif FieldFilterClassMode eq "4">selected</cfif>>Like</option> 	
										<option value="1"  <cfif FieldFilterClassMode eq "1">selected</cfif>>Combo</option> 
										<option value="2"  <cfif FieldFilterClassMode eq "2">selected</cfif>>Dropdown</option> 										
										<option value="3"  <cfif FieldFilterClassMode eq "3">selected</cfif>>Checkbox</option> 	
														  
									</select>
								</td>
							</tr>
						         
							<tr valign="top" id="lookupId" style="<cfif FieldFilterClassMode neq "2">display:none</cfif>">
								<td class="labelmedium" style="padding-top:3px">
									Lookup values:
								</td>
								<td colspan="7">										     
								    <iframe src="FieldEditLookup.cfm?FunctionId=#SystemFunctionId#&SerialNo=#FunctionSerialNo#&FieldId=#FieldId#&Type=Filter" name="lookupFilter" id="lookupFilter" width="100%" height="50" marginwidth="0" marginheight="0" hspace="0" vspace="0" align="left" scrolling="no" frameborder="0"></iframe>
								</td>
							</tr>
						
						</table>
					
					</td>
				</tr>
			         
				<tr><td colspan="2" height="10px"></td></tr>
					 
				<tr>
					<td class="labelmedium" colspan="2">
						<img src="#SESSION.root#/images/edit.gif">&nbsp;&nbsp;Editing of field
						<input type="checkbox" name="FieldEditMode" id="FieldEditMode" value="1" <cfif FieldEditMode eq 1>checked</cfif> style="padding-left:30px;" onclick="if(this.checked) { showId('divEditable')}else{ hideId('divEditable') }">
					</td>
				</tr>
				
				<tr> <td colspan="2" class="line"></td> </tr>
					 
				<tr>
					<td colspan="2">
						<table width="100%">
							
							<tr>
								<td colspan="2" id="divEditable" <cfif FieldEditMode eq 0>style="display:none;"</cfif>>
									<table width="100%" align="center">
									
										<tr>
											<td class="labelmedium" width="120px">
												Input type :
											</td>
											<td>
												<select name="FieldEditInputType" id="FieldEditInputType" class="regularxl" onchange="if (this.value == 2 || this.value==4){ showId('editInput') } else{ hideId('editInput') }">	
													<option value="1"  <cfif FieldEditInputType eq "1">selected</cfif>>Text</option> 
													<option value="2"  <cfif FieldEditInputType eq "2">selected</cfif>>Radio</option> 										
													<option value="3"  <cfif FieldEditInputType eq "3">selected</cfif>>Checkbox</option> 	
													<option value="4"  <cfif FieldEditInputType eq "4">selected</cfif>>Select</option> 					  
												</select>
											</td>
									      
											<td class="labelmedium">
												Submission template :
											</td>
											<td>
												<table>
													<tr>
														<td>
															<input type="text" name="FieldEditTemplate" id="FieldEditTemplate" value="#FieldEditTemplate#" class="regularxl" size="43" onblur="ptoken.navigate('FieldEditTemplate.cfm?template='+this.value+'&resultField=editTemplate','validateTemplate');">
														</td>
														<td id="validateTemplate"></td>
													</tr>
												</table>
											</td>
										</tr> 
										  
										<tr id="editInput" valign="top" <cfif FieldEditInputType eq "1" or FieldEditInputType eq "3" or FieldEditInputType eq ""> style="display:none;"</cfif> >
											<td class="labelmedium" style="padding-top:10px">
												Input values :
											</td>
											<td colspan="3" style="padding-top:10px">
												<iframe src="FieldEditLookup.cfm?FunctionId=#SystemFunctionId#&SerialNo=#FunctionSerialNo#&FieldId=#FieldId#&Type=Edit" name="lookupEdit" id="lookupEdit" width="100%" height="50" marginwidth="0" marginheight="0" hspace="0" vspace="0" align="left" scrolling="no" frameborder="0"></iframe>
											</td>
										</tr>    
									
									</table>
								</td>
							</tr>
						
						</table>
					</td>
				</tr>
				
				<tr><td colspan="2" height="10px"></td></tr>
				
				<tr>
					<td colspan="2" class="labelmedium">
						<img src="#SESSION.root#/images/logos/configuration.png" width="20px" style="vertical-align:middle">&nbsp;&nbsp;Application scope
					</td>
				</tr>
				
				<tr> <td colspan="2" class="line"></td> </tr>
								
				<tr>
					<td colspan="2">
						<table width="95%" align="center">
						
							<tr>
								<td class="labelmedium" width="120px">
									is <b>Key</b> field :
								</td>
								<td class="labelmedium">
									<input type="checkbox" name="FieldIsKey" id="FieldIsKey"  value="1" <cfif FieldIsKey eq 1>checked</cfif>>
								</td>
							</tr>
							 
							<tr>
								<td class="labelmedium">
									is <b>Access</b> field :
								</td>
								<td class="labelmedium">
									<input type="checkbox" name="FieldIsAccess" id="FieldIsAccess" value="1" <cfif FieldIsAccess eq 1>checked</cfif>>
								    <span style="color:gray">Mark if this field will be used to determine user access that will allow for editing</span>
								</td>
							</tr>
							
						</table>
					</td>
				</tr>
				
				<tr> <td colspan="2" height="10px"></td> </tr>
				
				<tr>
					<td colspan="2" class="line"></td>
				</tr>
				
				<tr>
					<td colspan="2" align="center" style="height:35px">
						<table class="formspacing"><tr><td>
						<input type="button" value="Close" style="font-size:13px;width:140px;height:27px" id="Close" name="Close" onclick="parent.ProsisUI.closeWindow('myfield',true)" class="button10g">
						</td>
						<td>
						<input type="submit" value="Submit" style="font-size:13px;width:140px;height:27px" id="Submit" name="Submit" class="button10g">
						</td></tr></table>
						
					</td>
				</tr>
				
			</table>
		</td>
	</tr>
	
</table>

</cfoutput>

</cfform>