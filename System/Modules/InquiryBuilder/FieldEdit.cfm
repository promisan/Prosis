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

<cfquery name="get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		 
	SELECT *
	FROM   Ref_ModuleControlDetail
	WHERE  SystemFunctionId = '#url.SystemFunctionId#'
	AND    FunctionSerialNo = '#url.FunctionSerialNo#'		
</cfquery>

<cfquery name="Field" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		 
	SELECT *
	FROM   Ref_ModuleControlDetailField
	WHERE  SystemFunctionId = '#url.SystemFunctionId#'
	AND    FunctionSerialNo = '#url.FunctionSerialNo#'	
	AND    FieldId = '#URL.FieldId#'	
</cfquery>

<cfquery name="Fields" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		 
	SELECT *
	FROM   Ref_ModuleControlDetailField
	WHERE  SystemFunctionId = '#url.SystemFunctionId#'
	AND    FunctionSerialNo = '#url.FunctionSerialNo#'		
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

<table class="hide"><tr><td><iframe id="iframeSubmit" name="iframeSubmit"></iframe></td></tr></table>

<cfform name="fieldForm" id="fieldForm" 
     action="FieldEditSubmit.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#" method="POST" target="iframeSubmit">

<cfoutput query="Field">

<table width="95%" align="center" class="formpadding formspacing">

	<tr> <td colspan="2" height="10px"></td> </tr>
	
	<tr>
		<td class="labellarge" colspan="2" style="font-size:30px">
			<font size="1">Field:</font> #FieldName#
		</td>
	</tr>

	<tr><td class="linedotted" colspan="2"></td></tr>
		
	<tr>
		<td colspan="2">
		
		<input type = "hidden" name = "FieldId"    id = "FieldId"    value = "#FieldId#">
		<input type = "hidden" name = "FunctionId" id = "FunctionId" value = "#SystemFunctionId#">
		<input type = "hidden" name = "SerialNo"   id = "SerialNo"   value = "#FunctionSerialNo#">
		
			<table width="95%" align="center">
				
				<tr class="line">
					<td colspan="2" class="labelmedium2" style="font-size:20px">
						Presentation of field
					</td>
				</tr>
								
				<tr>
					<td colspan="2">
						<table width="100%" class="formpadding">
						
							<tr class="fixlengthlist">
								<td class="labelmedium2">
									Display :
								</td>
								<td class="labelmedium2">
								    <table>
									<tr class="labelmedium2 fixlengthlist">
										<td><input style="width:18px;height:18px" type="radio" name="FieldDisplay" id="FieldDisplay" <cfif FieldInGrid eq "1">checked</cfif> onclick="form.ListingOrder.disabled=false" value="1"></td>
										<td style="padding-left:3px">In Grid</td>
										<td style="padding-left:6px"><input style="width:18px;height:18px" type="radio" name="FieldDisplay" id="FieldDisplay" <cfif FieldTree eq "1">checked</cfif> onclick="form.ListingOrder.disabled=true;" value="2"></td>
										<td style="padding-left:3px">In Tree</td>
										<td style="padding-left:6px"><input style="width:18px;height:18px" type="radio" name="FieldDisplay" id="FieldDisplay" <cfif FieldInGrid eq "0" and FieldTree eq "0">checked</cfif> onclick="form.ListingOrder.disabled=true;" value="3"></td>
										<td style="padding-left:3px">Do not show</td>									
									</tr>
									</table>
								</td>
							
								<td class="labelmedium2">
									Row | Column | Colspan :
								</td>
								<td>
								
									<table>
									<tr class="fixlengthlist">
									<td>
									<select id="FieldRow" style="width:48px" name="FieldRow" class="regularxxl">
									 	<option value="1"  <cfif fieldrow eq "1">selected</cfif>>1</option> 
									 	<option value="2"  <cfif fieldrow eq "2">selected</cfif>>2</option> 
									 	<option value="3"  <cfif fieldrow eq "3">selected</cfif>>3</option>
									</select>
									</td>
									<td style="padding-left:5px;padding-right:5px">|</td>
									<td>									
									<cfif FieldTree eq 1>
										<cfinput type="text" name="ListingOrder" id="ListingOrder" value="#ListingOrder#" size="2" style="text-align:center" class="regularxxl" range="0,999" disabled>
									<cfelse>
										<cfinput type="text" name="ListingOrder" id="ListingOrder" value="#ListingOrder#" size="2" style="text-align:center" class="regularxxl" range="0,999">
									</cfif>
									</td>
									<td style="padding-left:5px;padding-right:5px">|</td>
									<td>									
										<cfinput type="text" name="FieldColSpan" id="FieldColSpan" value="#FieldColSpan#" size="2" style="text-align:center" class="regularxxl" range="0,15">								
									</td>
									
									</tr>
									</table>
									
								</td>
							</tr>
							
							<tr class="fixlengthlist">
								<td class="labelmedium2">Header label:</td>
								<td>
									<input type="text" name="FieldHeaderLabel" id="FieldHeaderLabel" maxlength="30" value="#FieldHeaderLabel#" class="regularxxl">
								</td>
			
								<td class="labelmedium2">Grid Alignment:</td>
								<td>
									<select id="FieldAlignment" name="FieldAlignment" class="regularxxl">
									 	<option value="Left"   <cfif fieldalignment eq "Left">selected</cfif>>Left</option> 
									 	<option value="Center" <cfif fieldalignment eq "Center">selected</cfif>>Center</option> 
									 	<option value="Right"  <cfif fieldalignment eq "Right">selected</cfif>>Right</option>
									</select>
								</td>
							</tr>
							
							<tr class="fixlengthlist">
								<td class="labelmedium2">Field sort by:</td>
								<td colspan="1">
								
								<cfset sc = replace(get.QueryScript, "SELECT",  "SELECT TOP 1")> 
		
								<cfoutput>
								<cfsavecontent variable="sc">	
									SELECT *
									FROM (#preservesinglequotes(sc)#) as D
									WHERE 1=0		
								</cfsavecontent>		
								</cfoutput>
						
								<!--- -------------------------- --->
								<!--- preparation of the listing --->
								<!--- -------------------------- --->
								
								<cfsilent>
									
								<cfset fileNo = "#get.DetailSerialNo#">					
								<cfinclude template="QueryPreparation.cfm">				
								<cfinclude template="QueryValidateReserved.cfm">
								
								</cfsilent>
																										
								<cfquery name="SelectQuery" 
								datasource="#get.QueryDatasource#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">				
								   #preservesinglequotes(sc)# 
								</cfquery>									
																	
								<cfset col = SelectQuery.columnList>								
								<cfset colfields = "">																
								
								<cfloop index="fld" list="#col#">
								
									<cfif not findNoCase(fld,valueList(Fields.fieldName))>
									
									     <cfif colfields eq "">
										    <cfset colfields = "#fld#">
										 <cfelse>
										    <cfif findNoCase(fld,colfields)>											
											  <!--- nada --->
											<cfelse>											
										    <cfset colfields = "#colfields#,#fld#">	
											</cfif>
										 </cfif> 
									
									</cfif> 
								
								</cfloop>
																
								 <select name="fieldnamesort" id="fieldnamesort" class="regularxxl">		
								     <option value=""><cf_tl id="same"></option>						 
								     <cfloop index="col" list="#colfields#" delimiters=",">							      
								  	     <option value="#col#" <cfif fieldnamesort eq col>selected</cfif>>#col#</option> 
								     </cfloop>								
								  </select>
								
								</td>
								
								<cfset col = SelectQuery.columnList>								
								<cfset colfields = "">																
								
								<cfloop index="fld" list="#col#">								
									
								     <cfif colfields eq "">
									    <cfset colfields = "#fld#">
									 <cfelse>
									    <cfif findNoCase(fld,colfields)>											
										  <!--- nada --->
										<cfelse>											
									    <cfset colfields = "#colfields#,#fld#">	
										</cfif>
									 </cfif> 
																	
								</cfloop>
								
								
								<td title="function available in the context of the listing">								
									f:<input type="text" name="FieldFunction" id="FieldFunction" style="width:120px" maxlength="20" value="#FieldFunction#" class="regularxxl">								
								</td>
																
								<td colspan="1">
								
								<table cellspacing="0" cellpadding="0">
								
								<tr>
								 <td style="padding-left:2px" title="field content to be passed into function">
								 <select name="fieldfunctionfield" id="fieldfunctionfield" class="regularxxl" style="width:150px">		
								     <option value=""><cf_tl id="same"></option>						 
								     <cfloop index="col" list="#colfields#" delimiters=",">							      
								  	     <option value="#col#" <cfif fieldfunctionfield eq col>selected</cfif>>#col#</option> 
								     </cfloop>								
								  </select>
								  </td>
								
								  <td style="padding-left:2px" title="condition field to be passed">								
									<input type="text" name="FieldFunctionCondition" id="FieldFunctionCondition" style="width:120px" maxlength="10" value="#FieldFunctionCondition#" class="regularxxl">								
								</td>
								
								</tr>								
								</table>				
								
								</td>
											
							</tr>
							
							<tr class="fixlengthlist">

								<td class="labelmedium2">Content Format:</td>
								<td>
									<select name="FieldOutputFormat" id="FieldOutputFormat" class="regularxxl">						 
									 	  <option value=""           <cfif fieldoutputformat eq "">selected</cfif>>As in table</option> 
									 	  <option value="Date"       <cfif fieldoutputformat eq "Date">selected</cfif>>D: #CLIENT.DateFormatShow#</option> 
										  <option value="DateTime"   <cfif fieldoutputformat eq "Date">selected</cfif>>D: #CLIENT.DateFormatShow# hh:mm</option> 
									   	  <option value="Time"       <cfif fieldoutputformat eq "Time">selected</cfif>>T: hh:mm</option> 
										  <option value="Number"     <cfif fieldoutputformat eq "Number">selected</cfif>>F:Number</option> 
									   	  <option value="Amount"     <cfif fieldoutputformat eq "Amount">selected</cfif>>F:Amount [,000.00]</option> 
										  <option value="Amount0"    <cfif fieldoutputformat eq "Amount0">selected</cfif>>F:Amount [,000]</option> 
										  <option value="eMail"      <cfif fieldoutputformat eq "eMail">selected</cfif>>Mail [nn@dd.cc]</option> 		
										  <option value="Attachment" <cfif fieldoutputformat eq "Attachment">selected</cfif>>Attachment</option> 									
									 </select>
								</td>
								
								<td class="labelmedium2">Y-ax / Sorting modality:</td>
								<td>
									  <select name="FieldSort" id="FieldSort" class="regularxxl" style="width:200px">													
										  	 <option value="1" <cfif fieldsort eq "1">selected</cfif>>Initial Listing SORT</option> 
											 <option value="2" <cfif fieldsort eq "2">selected</cfif>>Initial Listing GROUP</option> 
											 <option value="3" <cfif fieldsort eq "3">selected</cfif>>Aggregation CELL field</option> 
											 <option value="0" <cfif fieldsort eq "0">selected</cfif>>None</option> 																			
								      </select>
								</td>				
								
							</tr>
						
							<tr class="fixlengthlist">
								
								<td class="labelmedium2">
									Column width:
								</td>
								<td style="height:25px" class="labelmedium2">
								    <table>
									<tr>
									<td><input style="width:18px;height:18px" type="radio" name="FieldWidth" id="FieldWidth" value="0" onclick="hideId('divFieldWidth')" <cfif FieldWidth eq 0>checked</cfif>></td>
									<td style="padding-left:3px">Auto</td>
									<td style="padding-left:3px">
									<input style="width:18px;height:18px" type="radio" name="FieldWidth" id="FieldWidth" value="1" onclick="showId('divFieldWidth')" <cfif FieldWidth gt 0>checked</cfif>>
									</td>
									<td style="padding-left:3px">Preset</td>
									<span id="divFieldWidth" style="<cfif FieldWidth eq 0>display:none;</cfif>">
										&nbsp;<input type="text"  name="FieldWidthPixel" id="FieldWidthPixel" value="#FieldWidth#" size="2" style="text-align:center" class="regularxxl">
										<span style="color:gray">pixels</span>
									</span>
									</tr>
									</table>
								</td>
								
								<td class="labelmedium2">X-ax / Dimension:</td>
								<td>
									  <select name="FieldColumn" id="FieldColumn" class="regularxxl" style="width:100px">	
									         <option value="" <cfif fieldcolumn eq "">selected</cfif>>None</option>												
										  	 <option value="month" <cfif fieldcolumn eq "month">selected</cfif>>Month</option> 		
											 <option value="common" <cfif fieldcolumn eq "common">selected</cfif>>Common</option> 																												
								      </select>
								</td>
								
							</tr>
						
						</table>
					</td>
				</tr>

				<tr><td colspan="2" height="10px"></td></tr>
				
				<tr class="line">
					<td colspan="2" class="labelmedium2" style="font-size:20px">
						Filter on field
					</td>
				</tr>
								
				<tr>
					<td colspan="2">
					
						<table class="formapadding formspacing">
						
							<tr class="fixlengthlist">													
							
								<td class="labelmedium2">Label:</td>
								<td>
									<input type="text" name="FieldFilterLabel" id="FieldFilterLabel" value="#FieldFilterLabel#" width="60" maxlength="30" class="regularxxl">
								</td>							
								
								<td class="labelmedium2" style="padding-left:6px">Modality:</td>
								<td style="padding-left:3px">
									 <select name="FieldFilterClass" id="FieldFilterClass"  class="regularxxl" onChange="if (this.value == 'Text') { form.FieldFilterClassMode.disabled=false; if (form.FieldFilterClassMode.value==2){ showId('lookupId') } } else { form.FieldFilterClassMode.disabled=true; hideId('lookupId');}">
										  <option value=""       <cfif FieldFilterClass eq "">selected</cfif>>No, no filtering</option>					 
									 	  <option value="Text"   <cfif FieldFilterClass eq "Text">selected</cfif>>Common</option> 
										  <option value="Amount" <cfif FieldFilterClass eq "Amount">selected</cfif>>Amount</option> 
									 	  <option value="Date"   <cfif FieldFilterClass eq "Date">selected</cfif>>Date</option>   											
									 </select>
								</td>											
								<td style="padding-left:6px">
									<select name="FieldFilterClassMode" 
									        id="FieldFilterClassMode" 
											class="regularxxl" 
											<cfif fieldfilterclass eq "">disabled</cfif>
											onChange="if (this.value=='2') { showId('lookupId') }else{ hideId('lookupId') }">	
											
									  	<option value="0"  <cfif FieldFilterClassMode eq "0">selected</cfif>>Free filter</option> 
										<option value="4"  <cfif FieldFilterClassMode eq "4">selected</cfif>>Like</option> 	
										<option value="1"  <cfif FieldFilterClassMode eq "1">selected</cfif>>Combo</option> 
										<option value="2"  <cfif FieldFilterClassMode eq "2">selected</cfif>>Select [single]</option> 										
										<option value="3"  <cfif FieldFilterClassMode eq "3">selected</cfif>>Multiple [Checkbox|Select]</option> 	
														  
									</select>
								</td>
								
								<td class="labelmedium2" style="padding-left:6px">Enforce Filter:</td>
								<td style="padding-left:3px">
									  <select name="FieldFilterForce" id="FieldFilterForce" class="regularxxl">
													
										  	 <option value="0" <cfif FieldFilterForce eq "0">selected</cfif>>No</option> 
											 <option value="1" <cfif FieldFilterForce eq "1">selected</cfif>>Yes</option> 
																														
								      </select>
								</td>	
							</tr>
						         
							<tr valign="top" id="lookupId" style="<cfif FieldFilterClassMode neq "2">display:none</cfif>">
								<td class="labelmedium2" style="padding-top:3px">
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
					<td class="labelmedium2" colspan="2" style="font-size:20px">
						Editing of field
						<input type="checkbox" class="radiol" name="FieldEditMode" id="FieldEditMode" value="1" <cfif FieldEditMode eq 1>checked</cfif> style="padding-left:30px;" onclick="if(this.checked) { showId('divEditable')}else{ hideId('divEditable') }">
					</td>
				</tr>
				
				<tr> <td colspan="2" class="line"></td> </tr>
					 
				<tr>
					<td colspan="2">
						<table width="100%">
							
							<tr>
								<td colspan="2" id="divEditable" <cfif FieldEditMode eq 0>style="display:none;"</cfif>>
									<table width="100%" align="center">
									
										<tr class="fixlengthlist">
											<td class="labelmedium2">
												Input type :
											</td>
											<td>
												<select name="FieldEditInputType" id="FieldEditInputType" class="regularxxl" onchange="if (this.value == 2 || this.value==4){ showId('editInput') } else{ hideId('editInput') }">	
													<option value="1"  <cfif FieldEditInputType eq "1">selected</cfif>>Text</option> 
													<option value="2"  <cfif FieldEditInputType eq "2">selected</cfif>>Radio</option> 										
													<option value="3"  <cfif FieldEditInputType eq "3">selected</cfif>>Checkbox</option> 	
													<option value="4"  <cfif FieldEditInputType eq "4">selected</cfif>>Select</option> 					  
												</select>
											</td>
									      
											<td class="labelmedium2">
												Submission template :
											</td>
											<td>
												<table>
													<tr>
														<td>
															<input type="text" name="FieldEditTemplate" id="FieldEditTemplate" value="#FieldEditTemplate#" class="regularxxl" size="43" onblur="ptoken.navigate('FieldEditTemplate.cfm?template='+this.value+'&resultField=editTemplate','validateTemplate');">
														</td>
														<td id="validateTemplate"></td>
													</tr>
												</table>
											</td>
										</tr> 
										  
										<tr id="editInput" valign="top" <cfif FieldEditInputType eq "1" or FieldEditInputType eq "3" or FieldEditInputType eq ""> style="display:none;"</cfif> >
											<td class="labelmedium2" style="padding-top:10px">
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
					<td colspan="2" class="labelmedium2" style="font-size:20px">
						Application scope
					</td>
				</tr>
				
				<tr> <td colspan="2" class="line"></td> </tr>
								
				<tr>
					<td colspan="2">
						<table width="95%" class="formpadding formspacing" align="center">
						
							<tr class="fixlengthlist">
								<td class="labelmedium2">
									is <b>Key</b> field :
								</td>
								<td class="labelmedium2">
									<input type="checkbox" class="radiol" name="FieldIsKey" id="FieldIsKey"  value="1" <cfif FieldIsKey eq 1>checked</cfif>>
								</td>
							</tr>
							 
							<tr class="fixlengthlist">
								<td class="labelmedium2">
									is <b>Access</b> field :
								</td>
								<td class="labelmedium2">
									<input type="checkbox" class="radiol" name="FieldIsAccess" id="FieldIsAccess" value="1" <cfif FieldIsAccess eq 1>checked</cfif>>
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