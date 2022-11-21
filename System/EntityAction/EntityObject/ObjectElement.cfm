	
<cfquery name="Entity" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Entity
	WHERE EntityCode = '#URL.EntityCode#'
</cfquery>

<cfquery name="Clear" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE 
	FROM  Ref_EntityDocument
	WHERE EntityCode = '#URL.EntityCode#'
	AND   DocumentCode = '#SESSION.acc#'
	AND   DocumentType = 'mail'
</cfquery>

<cfquery name="Detail" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT E.*, 
	       'Yes' as Used
    FROM   Ref_EntityDocument E
	WHERE  E.EntityCode = '#URL.EntityCode#'
	AND    (
	       E.DocumentId IN (SELECT DocumentId FROM Ref_EntityActionDocument) 
		   )
	AND    E.DocumentType = '#URL.Type#'
	UNION ALL
	SELECT  E.*, 'No' as Used
    FROM   #CLIENT.lanPrefix#Ref_EntityDocument E
	WHERE  E.EntityCode = '#URL.EntityCode#'
	AND    E.DocumentType = '#URL.Type#'
	AND    E.DocumentId NOT IN (SELECT DocumentId FROM Ref_EntityActionDocument)
	ORDER BY DocumentOrder	, DocumentCode
</cfquery>

<cfparam name="URL.ID2" default="new">   
<cfset ret = "return false">
<cfset act = "">
<cf_assignid>
<cfset documentid = rowguid>
	
<table width="98%" align="center">

	    <tr><td height="4"></td></tr>
				
		<tr>
	
	    <td width="100%">
		
		<!---
		<cfform method="POST" name="myfield" onsubmit="#ret#" action="#act#">
		--->
		
		<cfform method="POST" name="myfield" onsubmit="#ret#">
									
	    <table width="100%" class="navigation_table formpadding">
			
	    <TR class="labelmedium line fixrow" style="height:15px">
		
		   <td class="fixlength" style="background-color:white;padding-left:4px"><cf_tl id="Code"></td>
		   <cfif url.type neq "Attach" and url.type neq "Field"> 
		   <td class="fixlength" style="background-color:white" width="60%"><cf_tl id="Description"></td>
		   <cfelse>
		   <td class="fixlength" style="background-color:white" width="60%"><cf_tl id="Name"></td>
		   </cfif>
		   <td style="cursor:pointer;background-color:white" title="Refer to Prosis Developer reference for instructions on how to define the mode based on the developed embedded form">
		  	<cf_tl id="Usage">
		   </td>		   
		   <cfif url.type neq "Attach" and url.type neq "Field"> 
		   <td style="background-color:white" width="4%"></td>
		   <cfelseif url.type eq "Field">
		   <td style="padding-left:4px;background-color:white;min-width:130px">
		   	<table>
		   		<tr class="labelmedium">
					<td style="background-color:white" width="40"><cf_tl id="Obl"></td>
					<td style="background-color:white">&nbsp;</td>
					<td style="background-color:white"><cf_tl id="Type"></td>
				</tr>				
		  	</table>
		   </td>
		   <cfelseif url.type eq "Attach">
		   <td style="padding-left:4px;background-color:white;min-width:30px"><cf_tl id="Obl"></td>
		   </cfif>
		   <td style="background-color:white;min-width:30px">
			   <cf_UIToolTip tooltip="Listing order"><font color="000000"><cf_tl id="Sort"></cf_UIToolTip>
		   </td>
		   <td style="background-color:white;padding-left:6px;cursor:pointer;min-width:30px">
			   <cf_UIToolTip tooltip="Activated / deactivated"><font color="000000">Op</cf_UIToolTip>
		   </td>
		   <td colspan="2" align="right" style="background-color:white;padding-right:6px;min-width:40px">
	       <cfoutput>
			 <cfif URL.ID2 neq "new">
			     <A href="#ajaxLink('../../EntityObject/ObjectElement.cfm?EntityCode=#URL.EntityCode#&type=#URL.type#&ID2=new')#"><cf_tl id="Add"></a>
			 </cfif>
			 </cfoutput>
		   </td>		  
	    </TR>	
					
		<cfif url.type eq "Attach" or url.type eq "Field" or url.type eq "Activity"> 
			<cfset dew = 60>
		<cfelse>
			<cfset dew = 25> 
		</cfif>	
		
		<!--- NEW --->

		<cfif URL.ID2 eq "new">
											
			<TR style="background-color:ffffff" class="line">
			
			<td style="height:100%;padding-right:4px;padding-left:4px;border-right:1px solid silver;border-left:1px solid silver;">		
			
				<table height="100%" width="98%">
				
				<tr><td height="100%" style="padding-right:4px">
			
			    <cfinput type="Text" 
			         value="" 
					 name="DocumentCode" 
					 style="border:1px solid silver;background-color:f1f1f1;width:100%;height:100%;min-width:55px;text-align:center"
					 message="You must enter a code" 
					 required="Yes" 
					 size="10" 
					 maxlength="20" 
					 onkeyUp="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/System/EntityAction/EntityObject/getCodeCheck.cfm?entitycode=#url.entitycode#&value='+this.value,'codecheck')"
					 class="regularxl">	
					 				 
					</td>
					
					<td id="codecheck" align="center" style="border:1px solid silver;min-width:20px;border-radius:10px;">
				
				</tr>
					
				</table>	 
					
	        </td>	
								   
			<td style="padding-left:4px;border-right:1px solid silver">	
						
				<cf_LanguageInput
					TableCode       = "Ref_EntityDocument" 
					Mode            = "Edit"
					Name            = "DocumentDescription"
					Value           = ""
					Key1Value       = "{00000000-0000-0000-0000-000000000000}"
					Type            = "Input"
					Required        = "Yes"
					Message         = "Please enter a description"
					MaxLength       = "80"
					style           = "width:98%;border:1px dotted silver;background-color:transparent"					
					Class           = "regularxl">		
											
			</td>
			<td style="min-width:100px;padding-left:4px;border-right:1px solid silver">

			    <cfif URL.type eq "dialog">
			      <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%;background-color:transparent">
				   <option value="Embed" selected>Embed</option>
				   <option value="Ajax">Saves using Ajax</option>
				   <option value="Popup">Popup</option>
				  </select>
			     <cfelseif URL.type eq "session">
			      <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%;background-color:transparent">
				   <option value="Submit" selected>Submit</option>
				   <option value="Ajax">Saves using Ajax</option>				   
				  </select>  
				<cfelseif URL.type eq "mail"> 
				 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%;background-color:transparent">
				   <option value="AsIs" selected>AsIs</option>
				   <option value="Edit">Edit</option>
				  </select> 
				<cfelseif URL.type eq "question"> 
				 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%;background-color:transparent">
				   <option value="Rating" selected>Rating</option>
				   <option value="Comments">Edit</option>				 
				  </select>     
				<cfelseif URL.type eq "document"> 
				 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%;background-color:transparent">
				   <option value="AsIs" selected>AsIs</option>				 
				 </select>     
				<cfelseif URL.type eq "rule"> 
				 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%;background-color:transparent">
				   <option value="Notify" selected>Notification</option>	
				   <option value="Stopper">Stopper</option>				 
				 </select>          
				<cfelseif URL.type eq "report"> 
				 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%;background-color:transparent">
				   <option value="AsIs" selected>AsIs (Generated)</option>
				   <option value="Edit">Edit (Amend content)</option>
				   <option value="Blank">Reset/Edit</option>
				  </select>       
				<cfelseif URL.type eq "attach"> 				
				 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%;background-color:transparent">
				   <option value="Header" selected>Entity Object Header</option>
				   <option value="Step">Workflow step</option>
				 </select>   
				<cfelseif URL.type eq "script"> 				
				 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%">
				   <option value="Process" selected>Process</option>
				   <option value="Condition">Condition</option>
				 </select>    
				<cfelseif URL.type eq "activity"> 				
				 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%">
				   <option value="Activity" selected>Sub Activity</option>
				   <option value="Notify">Information</option>
				 </select>    
				<cfelseif URL.type eq "field"> 
				
					<cfquery name="CheckNote" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM  Ref_EntityDocument 
						WHERE DocumentMode = 'Notes'
						AND   EntityCode = '#URL.EntityCode#' 
					</cfquery>
					
					<cfquery name="CheckCost" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM  Ref_EntityDocument 
						WHERE DocumentMode = 'Cost'
						AND   EntityCode = '#URL.EntityCode#' 
					</cfquery>
					
					<cfquery name="CheckWork" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM  Ref_EntityDocument 
						WHERE DocumentMode = 'Work'
						AND   EntityCode = '#URL.EntityCode#' 
					</cfquery>
					
					 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%;background-color:transparent">
					    <option value="Step" selected>Step</option>
						<option value="Header">Header</option>
						<cfif checkNote.recordcount eq "0">
							<option value="Notes">Notes</option>
						</cfif>
						<cfif checkCost.recordcount eq "0">
							<option value="Cost">Cost</option>
						</cfif>
						<cfif checkWork.recordcount eq "0">
							<option value="Work">Work</option>
						</cfif>
					  </select>   
					     
				<cfelse>

					<input type="hidden" name="DocumentMode" id="DocumentMode" value="Embed">Embed
					
				</cfif>

		       </td>
			   
			<cfif url.type neq "Attach" and url.type neq "Field"> 			 
							
				<td style="border-right:1px solid silver"></td>
				
			<cfelseif url.type eq "Field">
			
			   <td style="border-right:1px solid silver;height:100%">
			   
			   	<table style="height:100%;width:95%" align="center" border="1">
		   		<tr><td style="padding-right:4px;padding-left:4px;border-right:1px solid silver">
			      <input type="Checkbox" name="FieldRequired" class="radiol" id="FieldRequired" value="0">
				  </td>
				  
				  <td style="background-color:transparent">
				  <select name="fieldtype" id="fieldtype" class="regularxl" ONCHANGE="toggle(this.value)" style="border:0px;width:98%">
				 	  <option value="list" selected>List</option>
					  <option value="date">Date</option>
					  <option value="amount">Amount</option>
					  <option value="text">Text</option>	
					  <option value="area">Text Area</option>			
					  <option value="email">Email</option>		
					  <option value="map">Google Map</option>				 
				  </select>
				  </td>
				</tr>
 			  	</table>
	           </td>	
			   
			<cfelseif url.type eq "Attach">
			
			   <td align="center" style="padding-right:4px;padding-left:4px;border-right:1px solid silver">
			      <input type="Checkbox" name="FieldRequired" class="radiol" id="FieldRequired" value="0">
				</td>
			   
			</cfif>

			<td align="center" style="border-right:1px solid silver">
			
			   	<cfinput type="Text" 
			         name="DocumentOrder" 
					 message="You must enter a ordinal number" 
					 required="Yes" 
					 size="1" 						 
					 value="1"
					 validate="integer"
					 style="width:100%;text-align:center;border:0px;background-color:transparent"
					 maxlength="2" 
					 class="regularxl">
					
			</td>
				
			<td align="center" style="border-right:1px solid silver">
				<input type="checkbox" 
				       name="Operational"
					   class="radiol"
					   id="Operational" 
					   value="1" checked>
			</td>
			
			<td colspan="2" align="center" style="border-right:1px solid silver">
			<cfoutput>
			
			<cfif url.type neq "mail">
			
				<input type="button" 
					value="Save" 
					onclick="savemyfield('#URL.entitycode#','new','#url.type#','#documentid#')"
					class="button10g" 
					style="width:45;height:25px">
			
			<cfelse>

				<cfset ptn = "new">
				<input type="button" 
					value="Save" 
					onclick="savemyfield('#URL.entitycode#','new','#url.type#','#documentid#')"
					class="button10g" 
					style="width:45;height:25px">
					
			</cfif>
			
			</cfoutput>
			
			</td>			    
			</TR>

			<cfif url.type neq "Attach" and url.type neq "Field" and url.type neq "Question"> 		
				 
				
				<tr>
					<td class="labelmedium" style="padding-left:23px;padding-right:5px" 
					  title="The relative path and file name under the root directory. Click on template name top view content.">										  
					   <cfif url.type eq "Mail">Script&nbsp;file<cfelse>Path / File:</cfif>		   			 					
					</td>
					
				    <td colspan="7" width="100%">
					
				    <table style="width:100%">
										
					<tr class="labelmedium">
					
					<td width="90%">
					
					   <cfif url.type eq "Mail">
					  
					   <cfinput type    = "Text" 
					      name          = "DocumentTemplate" 
						  required      = "No" 
						  autosuggest   = "cfc:service.reporting.presentation.gettemplate({cfautosuggestvalue})"
		       			  maxresultsdisplayed="30"
				          showautosuggestloadingicon="no"
					      typeahead     = "no"
						  style         = "width:100%"						 
						  maxlength     = "100" 
						  class         = "regularxxl">
						  					 					  
					   <cfelse>					   		
										  
					     <cfinput type = "Text" 
					      name         = "DocumentTemplate" 
						  message      = "You must enter a valid template absolute path and filename starting from the root" 
						  autosuggest  = "cfc:service.reporting.presentation.gettemplate({cfautosuggestvalue})"
		       			  maxresultsdisplayed="30"
				          showautosuggestloadingicon="no"
					      typeahead    = "no"
						  required     = "Yes" 						
						  style        = "width:100%"
						  maxlength    = "100" 
						  class        = "regularxxl">	
						  
						  </td>
						  <td width="20" align="center">						  
						  <font color="FF0000">*</font>						 			   						  
					   
					   </cfif>	
					     
					   </td>
					   
					   <cfif URL.type eq "dialog">
							
						    <td style="cursor:pointer;padding-left:4px" class="labelmeium" title="Logs the content of the HTML generated in the dialog screen upon saving">
															
								Log&nbsp;Content:								

							</td>
	
							<td style="cursor:pointer;padding-left:4px">

						    <input type="checkbox" 
							       name="LogActionContent" 
								   id="LogActionContent" class="radiol"
								   value="1" checked>
								   
							</td>
								
					</cfif>
					 
					   </tr>
					   </table>
					</td>
				</tr>
			</cfif>

						
			<cfif url.type eq "Field">			
									
				<tr id="text" class="hide">
				  <td></td>
				  <td colspan="8">
				  	  <cfinclude template="ObjectElementText.cfm">
				   </td>
				</tr>
				
				<tr id="amount" class="hide">
				  <td></td>
				  <td colspan="8">
				  	  <cfinclude template="ObjectElementAmount.cfm">
				   </td>
				</tr>
				
				<tr id="area" class="hide">
				  <td></td>
				  <td colspan="8">
				  	  <cfinclude template="ObjectElementTextArea.cfm">
				   </td>
				</tr>

				<tr id="list" bgcolor="ffffff" class="#cl#">
				  <td></td>
				  <td colspan="8" style="height:35px">
				  	  <cfinclude template="ObjectElementList.cfm">
				   </td>
				</tr>

				<tr id="date" bgcolor="ffffff" class="hide">
				  <td></td>
				  <td colspan="8" style="height:35px">
				  	  <cfinclude template="ObjectElementDate.cfm">
				   </td>
				</tr>
			
			</cfif>	
			
			<!---
						
			<cfif url.type eq "Mail">	
												
				<tr id="mail" bgcolor="f1f1f1" class="hide">
				  <td colspan="8">	
				  	<table width="100%" bgcolor="fafafa" cellspacing="0" cellpadding="0"><tr><td>
				  	  <cfinclude template="ObjectElementMail.cfm">
					</td></tr></table>
				   </td>					
				</tr>
									
			</cfif>
			
			--->

			<cfif url.type neq "Attach" and url.type neq "Field" and url.type neq "Mail">  								
													
							<cfif url.type eq "field">
							
							<!---
							<td align="right" width="200" style="cursor:pointer">
							Group (stringlist):
							</td>
							--->
							
							<cfelseif url.type eq "rule">
											
								<tr class="fixlengthlist">
								<td class="labelmedium2" style="padding-left:20px">Message:</td>
								<td colspan="5"><cfinput type  = "Text" 
									class          = "regularxxl" 
									value          = "" 
									name           = "MessageProcessor" 
									required       = "No" 
									size           = "100" 
									maxlength      = "200">
								</td>
								</tr>
								
								<tr class="fixlengthlist">
								<td class="labelmedium2" style="padding-left:20px">Message color:</td>
								<td colspan="5"><cfinput type  = "Text" 
									class          = "regularxxl" 
									value          = "Red" 
									name           = "DocumentColor" 
									required       = "No" 
									size           = "20" 
									maxlength      = "20">
								</td>
								</tr>
								
								<tr class="fixlengthlist">
								<td class="labelmedium2" style="padding-left:20px">Instruction auditor:</td>
								<td colspan="5"><cfinput type  = "Text" 
									class          = "regularxxl" 
									value          = "" 
									name           = "MessageAudit" 
									required       = "No" 
									size           = "100" 
									maxlength      = "200">
								</td>
								</tr>							
							
							<cfelseif url.type eq "dialog" or url.type eq "session">
							
								<td class="labelmedium fixlength" style="padding-top:6px;padding-right:5px;padding-left:23px;cursor:pointer">
								
									<cf_UIToolTip
										tooltip="Define a stringlist (comma separated) and/or lookup table <br> in order select a value as part of a step in the workflow step config which will be passed <br> to the dialog at runtime under [url.wparam] to trigger customised behavior of the dialog form.">
										String&nbsp
									</cf_UIToolTip>:
								
								</td>
								 <td>
								 
									<input type="Text" 
								         name="DocumentStringList" 
										 id="DocumentStringList"
										 size="50" 
										 maxlength="80" 
										 class="regularxl">
									 
									 </td>
									 
									 </tr>
									 
									 <tr><td valign="top" class="labelmedium fixlength" style="padding-top:6px;padding-right:5px;padding-left:23px;cursor:pointer">Table List:</td><td>
									 <cfinclude template="ObjectElementDialog.cfm">
									 </td>															
							
							<cfelseif url.type eq "script">														
								
								 <tr>
								 <td class="labelmedium" style="min-width:100px;padding-top:6px;padding-right:15px;padding-left:23px;cursor:pointer">Runtime&nbsp;Parameter:</td>
								 <td>
								 
								<input type="Text" 
							         name="DocumentStringList" 
									 id="DocumentStringList"
									 size="30" 
									 maxlength="80" 
									 class="regularxl">
									 
									 </td></tr>
																	 
							</cfif>		  
							
							<cfif URL.type eq "report">
															
								<tr>
								<td class="labelmedium" style="min-width:200px;padding-right:5px;padding-left:23px;cursor:pointer">
								<cf_UIToolTip tooltip="Select the format of document to be generated">Layout:</cf_UIToolTip>
								</td>
								<td style="padding:3px">
								  <select name="fieldlayout" id="fieldlayout" class="regularxl">
								 	  <option value="HTM" selected>HTML (recommended)</option>
									  <option value="PDF">PDF</option>
								  </select>
								</td>
								</tr>

								<tr>
								<td class="labelmedium" style="min-width:200px;padding-right:5px;padding-left:23px;cursor:pointer">
								<cf_UIToolTip tooltip="Select the type of layout the document will have">Orientation:</cf_UIToolTip>
								</td>
								<td  style="padding:3px">
								  <select name="DocumentOrientation" id="DocumentOrientation" class="regularxl">
								 	  <option value="Vertical" selected>Vertical</option>
									  <option value="Horizontal">Horizontal</option>
								  </select>
								</td>
								</tr>	
								
								<tr>							
								<td class="labelmedium" style="padding-right:5px;padding-left:23px;cursor:pointer">
									<cf_UIToolTip tooltip="Select the type of layout the document will have">Editor:</cf_UIToolTip>
								</td>							
								<td  style="padding:3px">
								  <select name="DocumentEditor" id="DocumentEditor" class="regularxl">
								 	  <option value="CK" selected>CK editor</option>
									  <option value="FCK">FCK Editor [deprecated]</option>
								  </select>
								</td>								
								</tr>													
								
								<tr>
									<td class="labelmedium" style="padding-right:5px;padding-left:23px;cursor:pointer">
									<cf_UIToolTip tooltip="Pointer to define if the template uses the standard framework for document generation which requires the user to select a language and formatting (nn_letter, nn_memo, nn_fax)">
									Framework:</cf_UIToolTip>
									</td>
									<td  style="padding:3px"><input type="checkbox" class="radiol" name="DocumentFramework" id="DocumentFramework" value="1" checked>
									</td>
								</tr>
								
								<tr>
									<td class="labelmedium" style="padding-right:5px;padding-left:23px;cursor:pointer">
										<cf_UIToolTip tooltip="Pointer to define if this report will be presented under a custom portal">Portal:</cf_UIToolTip>
									</td>
									<td style="padding:3px"><input type="checkbox" class="radiol" name="PortalShow" id="PortalShow" value="1" checked>
									</td>
								</tr>
								
								<tr>
									 <td class="labelmedium" style="padding-right:15px;padding-left:23px;cursor:pointer">
									 <cf_UIToolTip tooltip="A stringlist used to define on the step the context under which the report should be created.">
									 Usage Criteria:</cf_UIToolTip>
									 </td>
									 <td style="padding:3px">								 
										<input type="Text" 
									         name="DocumentStringList" 
											 id="DocumentStringList"
											 size="30" 
											 maxlength="50" 
											 class="regularxl">									 
									 </td>
								</tr>								
								
								<tr>
									<td class="labelmedium" style="padding-right:5px;padding-left:23px;cursor:pointer">
									<cf_UIToolTip tooltip="Add this password to the generated PDF of this report">PDF Password:</cf_UIToolTip>
									</td>
									<td style="padding:3px">								
										<input type="Text" 
											name="DocumentPassword" 
											id="DocumentPassword"									
											size="30" 
											maxlength="20" 
											class="regularxl">
									</td>
								</tr>
																
							<cfelseif URL.type eq "document">
								
								<tr>							
								<td class="labelmedium" title="Add this password to the generate PDF of this document" style="padding-right:5px;padding-left:23px;cursor:pointer">
								
								Password:&nbsp;
								
								</td>
								<td style="padding;3px">								
									<input type="Text" 
										name="DocumentPassword" 	
										id="DocumentPassword"								
										size="10" 										
										maxlength="20" 
										class="regularxl">
								</td>	
								
								</tr>
								
								<tr>							
								<td class="labelmedium" title="Margin" style="padding-right:5px;padding-left:23px">								
								Formatting:&nbsp;						
								</td>
								<td colspan="7" style="padding;3px">	
								
								<table style="width:100%">
								<tr>
								<td style="padding-left:4px" class="labelmedium">Margin-top:</td>
								<td style="padding-left:4px">	
								<input type="Text" 
										name="MarginTop" 	
										id="MarginTop"	
										style="text-align:center"							
										size="5" 
										maxlength="5" 
										class="regularxl">			
								</td>
								<td style="padding-left:4px" class="labelmedium">Margin-bottom:</td>
								<td style="padding-left:4px">	
								<input type="Text" 
										name="MarginBottom" 	
										id="MarginBottom"	
										style="text-align:center"								
										size="5" 
										maxlength="5" 
										class="regularxl">			
								</td>
								<td style="padding-left:4px" class="labelmedium">Scale:</td>
								<td style="padding-left:4px">	
								<input type="Text" 
										name="Scale" 	
										id="Scale"		
										style="text-align:center"							
										size="3" 
										maxlength="3" 
										class="regularxl">			
								</td>
								<td style="padding-left:4px" class="labelmedium">Renderer:</td>
								<td style="padding-left:4px">	
								<input type="radio" name="DocumentEditor" checked value="CFDOC" class="radiol">			
								</td>
								<td>cfdocument</td>
								<td style="padding-left:4px">	
								<input type="radio" name="DocumentEditor" value="HTMPDF" class="radiol">			
								</td>
								<td>htm_pdf</td>
								</tr>
								</table>							
									
								</td>	
								
								</tr>
							
							</cfif>															
			
			</cfif>
			
			<tr><td colspan="8" height="1" class="line"></td></tr>
														
		</cfif>						
			
		<cfoutput>

		<cfloop query="Detail">		
			
			<cfset nm = DocumentCode>
			<cfset de = DocumentDescription>
			<cfset ps = DocumentPassword>
			<cfset op = Operational>
			<cfset md = DocumentMode>
			<cfset mtop = MarginTop>
			<cfset mbot = MarginBottom>
			<cfset scal = Scale>
			<cfset dedt = DocumentEditor>
																				
			<cfif URL.ID2 eq nm>	
																			
			    <input type="hidden" name="DocumentCode" id="DocumentCode" value="<cfoutput>#nm#</cfoutput>">
																	
				<TR bgcolor="ffffff" class="line">
				   <td height="30" style="background-color:f4f4f4;padding-left:10px;border-right:1px solid silver">#nm#</td>
				   <td style="border-right:1px solid silver">
				   
				   	<cf_LanguageInput
						TableCode       = "Ref_EntityDocument" 
						Mode            = "Edit"
						Name            = "DocumentDescription"
						Value           = "#de#"
						Key1Value       = "#documentid#"
						Type            = "Input"
						Required        = "Yes"
						Message         = "Please enter a description"
						MaxLength       = "70"
						Style           = "width:95%;border:0px;background-color:transparent"
						Class           = "regularxl">
				   	 				  
		           </td>
				   <td style="min-width:100px;border-right:1px solid silver;padding-right:6px">
				   				   
				   <cfif URL.type eq "dialog">
				      <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:96%;background-color:transparent">
					   <option value="Embed" <cfif md eq "Embed">selected</cfif>>Embed</option>
					   <option value="Ajax" <cfif md eq "Ajax">selected</cfif>>Saves using Ajax</option>
					   <option value="Popup" <cfif md eq "Popup">selected</cfif>>Popup</option>
					  </select>
					   <cfelseif URL.type eq "session">
				      <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:96%;background-color:transparent">
					   <option value="Submit" <cfif md eq "Submit">selected</cfif>>Submit</option>
					   <option value="Ajax" <cfif md eq "Ajax">selected</cfif>>Saves using Ajax</option>				   
					  </select>    
					<cfelseif URL.type eq "report"> 
					 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:96%;background-color:transparent">
					   <option value="AsIs" <cfif md eq "AsIs">selected</cfif>>AsIs (Changes are NOT allowed)</option>
					   <option value="Edit" <cfif md eq "Edit" or md eq "Embed">selected</cfif>>Edit (Changes are allowed)</option>
					   <option value="Blank" <cfif md eq "Blank">selected</cfif>>Reset/Edit</option>
					  </select>   
					<cfelseif URL.type eq "document"> 
					 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:96%;background-color:transparent">
					    <option value="AsIs" <cfif md eq "AsIs">selected</cfif>>AsIs</option>	 
					 </select>       
					<cfelseif URL.type eq "question"> 
					 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:96%;background-color:transparent">
					   <option value="Rating" <cfif md eq "Rating">selected</cfif>>Rating</option>
					   <option value="Comments" <cfif md eq "Edit">selected</cfif>>Edit</option>				 
					  </select>      
					 <cfelseif URL.type eq "rule"> 
					 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:96%;background-color:transparent">
					   <option value="Notify" <cfif md eq "Stopper">selected</cfif>>Notification</option>	
					   <option value="Stopper" <cfif md eq "Stopper">selected</cfif>>Stopper</option>				 
					 </select>      
					<cfelseif URL.type eq "mail"> 
					 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:96%;background-color:transparent">
					   <option value="AsIs" <cfif md eq "AsIs">selected</cfif>>AsIs</option>
					   <option value="Edit" <cfif md eq "Edit">selected</cfif>>Edit</option>
					  </select> 
					<cfelseif URL.type eq "script"> 
					 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:96%;background-color:transparent">
					   <option value="Process" <cfif md eq "Process">selected</cfif>>Process</option>
					   <option value="Condition" <cfif md eq "Condition">selected</cfif>>Condition</option>
					  </select>   
					<cfelseif URL.type eq "attach"> 					
					 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:96%;background-color:transparent">
					   <option value="Header" <cfif md eq "Header">selected</cfif>>Header</option>
					   <option value="Step" <cfif md eq "Step">selected</cfif>>Step</option>
					  </select>  
					<cfelseif URL.type eq "activity"> 				
					 <select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:98%">
					   <option value="Activity" <cfif md eq "Activity">selected</cfif>>Sub Activity</option>
					   <option value="Notify" <cfif md eq "Notify">selected</cfif>>Information</option>
					 </select>       
					<cfelseif URL.type eq "field"> 
					
						<cfquery name="CheckNote" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM  Ref_EntityDocument 
							WHERE DocumentMode = 'Notes'
							AND   EntityCode = '#URL.EntityCode#'
							AND   DocumentCode = '#URL.ID2#'
						</cfquery>	
						
						<cfquery name="CheckCost" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM  Ref_EntityDocument 
							WHERE DocumentMode = 'Cost'  
							AND    EntityCode = '#URL.EntityCode#'
							AND   DocumentCode = '#URL.ID2#'
						</cfquery>
					
						<cfquery name="CheckWork" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM  Ref_EntityDocument 
							WHERE DocumentMode = 'Work'
							AND    EntityCode = '#URL.EntityCode#'
							AND   DocumentCode = '#URL.ID2#'
						</cfquery>							
					
						<select name="DocumentMode" id="DocumentMode" class="regularxl" style="border:0px;width:96%">
						   <cfif checkNote.recordcount eq "1">
							   <option value="Notes" <cfif md eq "Notes">selected</cfif>>Notes</option>
						   </cfif>
						   <cfif checkCost.recordcount eq "1">
							   <option value="Cost" <cfif md eq "Cost">selected</cfif>>Cost</option>
						   </cfif>
						   <cfif checkWork.recordcount eq "1">
							   <option value="Work" <cfif md eq "Work">selected</cfif>>Work</option>
						   </cfif>
						   <option value="Step" <cfif md eq "Step">selected</cfif>>Step</option>
						   <option value="Header" <cfif md eq "Header">selected</cfif>>Header</option>
						</select>     
						
				    <cfelse>
						<input type="hidden" name="DocumentMode" id="DocumentMode" value="Embed">
						Embed
					</cfif>  
				   </td>
				   
				   <cfif url.type neq "Attach" and url.type neq "Field">   
				   <td></td>
				   
				    <cfelseif url.type eq "Field">
				   
				   		<td style="padding-left:4px;border-left:1px solid silver;border-right:1px solid silver">
						    <table cellspacing="0" cellpadding="0">
					   		<tr><td style="border-left:1px solid silver">
							
						     <input type="Checkbox"
							       name="FieldRequired"
								   class="radiol"
								   id="FieldRequired"
							       value="#fieldrequired#"
								   <cfif fieldrequired eq "1">checked</cfif>>
							  </td>
							 
							  <td style="padding-left:4px;border-left:1px solid silver">
							  
							  <select name="fieldtype" id="fieldtype" class="regularxl" onchange="toggle(this.value)" style="border:0px;width:98%;background-color:transparent">
							 	  <option value="list"     <cfif fieldtype eq "list">selected</cfif>>List</option>
								  <option value="checkbox" <cfif fieldtype eq "checkbox">selected</cfif>>Checkbox (Yes/No)</option>
								  <option value="date"     <cfif fieldtype eq "date">selected</cfif>>Date</option>
								  <option value="amount"   <cfif fieldtype eq "amount">selected</cfif>>Amount</option>
								  <option value="text"     <cfif fieldtype eq "text">selected</cfif>>Text</option>	
								  <option value="area"     <cfif fieldtype eq "area">selected</cfif>>Text Area</option>			
								  <option value="email"    <cfif fieldtype eq "email">selected</cfif>>Email</option>		
								  <option value="map"      <cfif fieldtype eq "map">selected</cfif>>Google Map</option>												 
							  </select>					  
							 
							 </td>
							</tr>
			 			  	</table>			   
			           </td>
					   
					 <cfelseif url.type eq "Attach">
			
					   <td align=:"center" style="padding-right:4px;padding-left:4px;border-right:1px solid silver">
					      <input type="Checkbox" name="FieldRequired" class="radiol" id="FieldRequired" value="#fieldrequired#" <cfif fieldrequired eq "1">checked</cfif>>
					   </td> 
						 
				   </cfif>
				   
				   <td style="border-right:1px solid silver">
				      	<cfinput type="Text" 
					         name="DocumentOrder" 
							 message="You must assign a listing order to your object" 
							 required="Yes" 
							 size="1" 
							 value="#DocumentOrder#"
							 validate="integer"
							 style="width:25;text-align:center;border:0px;background-color:transparent"
							 maxlength="2" 
							 class="regularxl">
				   </td>
				   <td align="center" style="border-right:1px solid silver">
				      <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>>
				   </td>
				   <td colspan="2" align="center" style="border-right:1px solid silver">
				   
				   <cfif url.type eq "mail">
				   
					   <input type="button" 
					        value="Save" 
							onclick="savemyfield('#URL.entitycode#','#nm#','#url.type#','#documentid#')"
							class="button10g" 
							style="width:50px;height:25px">
							
					<cfelse>
					
						<cfset ptn = "#nm#">
						<input type="button" 
					        value="Save" 
							onclick="savemyfield('#URL.entitycode#','#nm#','#url.type#','#documentid#')"
							class="button10g" 
							style="width:50px;height:25px">
							
					</cfif>	
					</td>
			    </TR>	
				
				<cfif url.type neq "Attach" and url.type neq "Field" and url.type neq "Question"> 		
								 
				<tr bgcolor="ffffff">
				   
				    <td class="labelmedium" style="min-width:100px;cursor:pointer;padding-left:20px;padding-right:4px" title="The relative path and file name under the root directory. Click on template name top view content.">
					
					   <cfif url.type eq "Mail">Script&nbsp;file<cfelse>Path/File:</cfif>
		   			
					</td>
				    <td colspan="7">
					
				    <table style="width:100%" cellspacing="0" cellpadding="0">
															
					<tr class="labelmedium">
					<td>
					   
					   <cfif url.type eq "Mail">
					  
					   <cfinput type="Text" 
					      name="DocumentTemplate" 
						  value="#DocumentTemplate#"
						  required="No" 
						  autosuggest="cfc:service.reporting.presentation.gettemplate({cfautosuggestvalue})"
		       			  maxresultsdisplayed="30"
				          showautosuggestloadingicon="no"
					      typeahead = "no"						  
						  style="width:100%"
						  maxlength = "80" 
						  class="regularxl">
						  					 					  
					   <cfelse>
					  
					     <cfinput type="Text" 
					      name="DocumentTemplate" 
						  value="#DocumentTemplate#"
						  message="You must enter a valid template absolute path and filename starting from the root" 
						  autosuggest="cfc:service.reporting.presentation.gettemplate({cfautosuggestvalue})"
		       			  maxresultsdisplayed="30"
				          showautosuggestloadingicon="no"
					      typeahead = "no"
						  style     = "width:100%"
						  required  = "Yes" 						 
						  maxlength = "80" 
						  class     = "regularxl">	
						  
						  </td>
						  <td width="20">
						  <font color="FF0000">&nbsp;*)</font> 
						  </td>
						 								   
					   </cfif>	 					   
					   
					   <cfif URL.type eq "dialog">
							
						<td align="right" style="padding-left:5px">Log&nbsp;Content:</td>
						<td style="padding-left:5px">
						    <input type="checkbox" 
							       name="LogActionContent" 
								   id="LogActionContent"
								   class="radiol"
								   value="1" 
								   <cfif "1" eq LogActionContent>checked</cfif>>
						</td>
								
					   </cfif>
					   
					   </tr></table>
					</td>
				</tr>
			   </cfif>
				
				<cfif url.type eq "Field">
				
					<cfif fieldtype eq "text">
					 <cfset cl = "regular">
					<cfelse>
					 <cfset cl = "hide"> 
					</cfif>
								
					<tr id="text" bgcolor="ffffff" class="#cl#">
					  <td></td>
					  <td colspan="7">
					  	  <cfinclude template="ObjectElementText.cfm">
					   </td>					
					</tr>
					
					<cfif fieldtype eq "amount">
					 <cfset cl = "regular">
					<cfelse>
					 <cfset cl = "hide"> 
					</cfif>
								
					<tr id="text" bgcolor="ffffff" class="#cl#">
					  <td></td>
					  <td colspan="7">
					  	  <cfinclude template="ObjectElementAmount.cfm">
					   </td>					
					</tr>
					
					<tr id="area" bgcolor="ffffff" class="#cl#">
					  <td></td>
					  <td colspan="7">
					  	  <cfinclude template="ObjectElementTextArea.cfm">
					   </td>					
					</tr>
									
					<cfif fieldtype eq "list">
					 <cfset cl = "regular">
					<cfelse>
					 <cfset cl = "hide"> 
					</cfif>
								
					<tr id="list" bgcolor="ffffef" class="#cl#">
					  <td></td>
					  <td colspan="8" style="height:35px">					  
					  	  <cfinclude template="ObjectElementList.cfm">
					   </td>					
					</tr>
					
					<cfif fieldtype eq "date">
					 <cfset cl = "regular">
					<cfelse>
					 <cfset cl = "hide"> 
					</cfif>								
					
					<tr id="date" bgcolor="ffffff" class="#cl#">
					  <td></td>
					  <td colspan="8" style="height:35px">
					  	  <cfinclude template="ObjectElementDate.cfm">
					   </td>					
					</tr>					
				
				</cfif>
								
				<cfif url.type neq "Field" and url.type neq "Activity" and url.type neq "question">
				
														
				<cfif url.type eq "field">
							
							<!---
							<td align="right" width="200" style="cursor:pointer">
							Group (stringlist):
							</td>
							--->
							
				<cfelseif url.type eq "rule">
											
							<tr>
							<td style="padding-left:23px" class="labelit">Message:</td>
							<td><cfinput type  = "Text" 
								class          = "regularxl" 
								value          = "#MessageProcessor#" 
								name           = "MessageProcessor" 
								required       = "No" 
								size           = "60" 
								maxlength      = "80">
							</td>
							</tr>
							
							<tr>
							<td style="padding-left:23px" class="labelit">Message color:</td>
							<td><cfinput type  = "Text" 
								class          = "regularxl" 
								value          = "#DocumentColor#" 
								name           = "DocumentColor" 
								required       = "No" 
								size           = "20" 
								maxlength      = "20">
							</td>
							</tr>
							
							<tr>
							<td style="padding-left:23px" class="labelit">Auditor:</td>
							<td><cfinput type  = "Text" 
								class          = "regularxl" 
								value          = "#MessageAudit#" 
								name           = "MessageAudit" 
								required       = "No" 
								size           = "20" 
								maxlength      = "20">
							</td>
							</tr>
							
							
				<cfelseif url.type eq "dialog" or url.type eq "session">
											
							<tr class="fixlengthlist">
							<td style="padding-left:23px" class="labelit">String List:</td>
							<td class="labelit"><cfinput type  = "Text" 
								class          = "regularxl" 
								value          = "#documentstringList#" 
								name           = "DocumentStringList" 
								required       = "No" 
								size           = "60" 
								maxlength      = "80">
							</td>
							</tr>
							
							<tr>
							<td class="labelit" valign="top" style="padding-top:6px;cursor:pointer">Table List:</td>
							<td class="labelit"><cfinclude template="ObjectElementDialog.cfm"></td>
							</tr>
							
				<cfelseif url.type eq "script">
											
							<tr>
							<td style="padding-left:23px;min-width:100px" class="labelit">Runtime&nbsp;Parameter:</td>
							<td><cfinput type  = "Text" 
								class          = "regularxl" 
								value          = "#documentstringList#" 
								name           = "DocumentStringList" 
								required       = "No" 
								size           = "40" 
								maxlength      = "80">
							</td>
							</tr>							
														
				<cfelseif URL.type eq "report">
				
							<tr>
								<td style="padding-left:23px" class="labelit" style="cursor:pointer">
									<cf_UIToolTip tooltip="Select the type of layout the document will have">Layout:</cf_UIToolTip>
								</td>
								<td>
								  <select name="fieldlayout" id="fieldlayout" class="regularxl">
								 	  <option value="HTM" <cfif DocumentLayout eq "HTM">selected</cfif>>HTML</option>
									  <option value="PDF" <cfif DocumentLayout eq "PDF">selected</cfif>>PDF</option>
								  </select>
								</td>
							</tr>

							<tr>
							
							<td style="padding-left:23px" class="labelit" style="cursor:pointer">
								<cf_UIToolTip tooltip="Select the type of layout the document will have">Orientation:</cf_UIToolTip>
							</td>							
							<td>
							  <select name="DocumentOrientation" id="DocumentOrientation" class="regularxl">
							 	  <option value="Vertical" <cfif DocumentOrientation eq "Vertical">selected</cfif>>Vertical</option>
								  <option value="Horizontal" <cfif DocumentOrientation eq "Horizontal">selected</cfif>>Horizontal</option>
							  </select>
							</td>
							
							</tr>		
							
							<tr>
							
							<td style="padding-left:23px" class="labelit" style="cursor:pointer">
								<cf_UIToolTip tooltip="Select the type of layout the document will have">Editor:</cf_UIToolTip>
							</td>							
							<td>
							  <select name="DocumentEditor" id="DocumentEditor" class="regularxl">
							 	  <option value="CK" <cfif DocumentEditor eq "CK">selected</cfif>>CK editor</option>
								  <option value="FCK" <cfif DocumentEditor eq "FCK">selected</cfif>>FCK Editor (deprecated)</option>
							  </select>
							</td>
							
							</tr>						

							<tr>
							<td style="padding-left:23px" class="labelit" style="cursor:pointer">
							<cf_UIToolTip tooltip="Pointer to define if this report will be presented under a custom portal">Portal:</cf_UIToolTip></td>
								<td>								
								  <input type = "checkbox" 
								      name    = "PortalShow" 
									  class   = "radiol"
									  id      = "PortalShow"
								      value   = "1" <cfif PortalShow eq "1">checked</cfif>>
								</td>
							</tr>	
							
							<tr>
								<td class="labelit" style="padding-left:23px;cursor:pointer;height:25px">
								<cf_UIToolTip
								tooltip="Pointer to define if the template uses the standard framework for document generation which requires the user to select a language and formatting (letter, memo, fax)">
								Framework:</cf_UIToolTip>
								</td>
								<td><input type="checkbox" class="radiol" name="DocumentFramework" id="DocumentFramework" value="1" <cfif DocumentFramework eq "1">checked</cfif>>
								</td>
							</tr>
							
							<tr>
								 <td style="padding-left:23px;cursor:pointer;height:25px">
								 <cf_UIToolTip	tooltip="A stringlist used to define on the step the context under which the report should be created">Usage Criteria:</cf_UIToolTip>
								 </td>
								 
								 <td>
								 
								   <input type="Text" 
							         name="DocumentStringList" 
									 id="DocumentStringList"
									 size="40" 
									 value="#documentstringList#"
									 maxlength="50" 
									 class="regularxl">
									 
								 </td>
							 </tr>
							
							
							<tr>
							<td style="padding-left:23px;cursor:pointer;height:25px">Password:</td>
							<td>
								<cfinput type="Text" 
								      name="DocumentPassword" 
									  value="#ps#" 
									  required="No" 
									  size="10" 
									  maxlength="20" 
									  class="regularxl">
									  
							</td>
							</tr>
							
				<cfelseif URL.type eq "document">
							
							<tr>							
							<td style="padding-left:23px;cursor:pointer;height:25px" title="Add this password to the generate PDF of this document">
							Password:
							</td>
							<td colspan="7">								
								<input type="Text" 
								name="DocumentPassword" 
								id="DocumentPassword"									
								size="10" 
								value="#ps#" 
								maxlength="20" 
								class="regularxl">
							</td>	
							</tr>
								
							<tr>							
							<td class="labelmedium" title="Margin" style="padding-right:5px;padding-left:23px;cursor:pointer">								
							Formatting:							
							</td>
							<td style="padding:3px" colspan="7">	
							
							<table style="width:100%">
							<tr>
							<td style="padding-left:4px" class="labelmedium">Margin-top:</td>
							<td style="padding-left:4px">	
							<input type="Text" 
									name="MarginTop" 	
									id="MarginTop"								
									size="5" 
									maxlength="5" 
									style="text-align:center"	
									value="#mtop#" 
									class="regularxl">			
							</td>
							<td style="padding-left:4px" class="labelmedium">Margin-bottom:</td>
							<td style="padding-left:4px">	
							<input type="Text" 
									name="MarginBottom" 	
									id="MarginBottom"								
									size="5" 
									maxlength="5" 
									style="text-align:center"	
									value="#mbot#" 
									class="regularxl">			
							</td>
							<td style="padding-left:4px" class="labelmedium">Scale:</td>
							<td style="padding-left:4px">	
							<input type="Text" 
									name="Scale" 	
									id="Scale"	
									style="text-align:center"									
									size="3" 
									maxlength="3" 
									value="#scal#" 
									class="regularxl">			
							</td>
							<td style="padding-left:4px" class="labelmedium">Renderer:</td>
							<td style="padding-left:4px">	
							<input type="radio" name="DocumentEditor" <cfif dedt neq "HTMPDF">checked</cfif> value="CFDOC" class="radiol">			
							</td>
							<td>cfdocument</td>
							<td style="padding-left:4px">	
							<input type="radio" name="DocumentEditor" value="HTMPDF" <cfif dedt eq "HTMPDF">checked</cfif> class="radiol">			
							</td>
							<td>htm_pdf</td>
							</tr>
							</table>							
								
							</td>	
							
							</tr>
							
				</cfif>
					
				
				</cfif>
																											
			<cfelse>
			
				<TR bgcolor="<cfif op eq '0'>E4E4E4</cfif>" class="labelmedium2 navigation_row line fixlengthlist" style="height:15px">
								
				   <td style="padding-left:4px">#nm#</td>
				   <td>#de#</td>
				   <td>
					   <cfif md eq "Notes"><img src="#SESSION.root#/Images/postit.png" alt="" border="0" client.=""><cfelse>
					   <cfif md eq "Ajax">Embed+WF<cfelse>#md#</cfif>
					   </cfif>
				   </td>
				   <cfif url.type neq "Attach" and url.type neq "Field">  
					   <td style="padding-left:3px" class="fixlength">
					   <cfif not FileExists("#SESSION.rootpath#/#DocumentTemplate#") and left("#DocumentTemplate#","11") neq "javascript:">
					     	 <font color="FF0000">#documenttemplate# 
					   <cfelse> 	
					       <cfset ln = replace(documenttemplate,"\","\\","ALL")>		 
					         <a href="javascript:template('#ln#')" title="#documenttemplate#">#documenttemplate#</a>					     
						</cfif>	 
					   </td>
					<cfelseif url.type eq "Field">
					
					    <td style="min-width:230px">
					    <table cellspacing="0" cellpadding="0" class="formpadding">
					   		<tr class="labelmedium" style="height:15px">
							  <td width="40" class="labelmedium">
						      <cfif fieldrequired eq "0">No<cfelse>Yes</cfif>
							  </td>
							  <td style="padding-left:4px"></td>
							  <td class="labelmedium" style="min-width:200px">
								  <cfif fieldtype eq "List">
								    <a href="javascript:more('#documentid#')">#fieldtype#</a>
								  <cfelse>	
								   #fieldtype#
								  </cfif> 								   
								  <cfif fieldtype eq "Text">(#fieldlength#)</cfif> 
								  <cfif lookuptable neq "" and fieldtype eq "Text">: #lookuptable#</cfif>
							  </td>
							  <td class="labelmedium" style="padding-left:4px">
							  
							  <cfif fieldtype eq "List">
							  	 <img src="#SESSION.root#/Images/icon_expand.gif"
									id="#documentid#Exp" border="0" class="show" 
									align="absmiddle" style="cursor: pointer;" 
									onClick="more('#documentid#')">
									
									<img src="#SESSION.root#/Images/icon_collapse.gif" 
									id="#documentid#Min" alt="" border="0" 
									align="absmiddle" class="hide" style="cursor: pointer;" 
									onClick="more('#documentid#')">	
							  </td>
							  </cfif>
							  
							</tr>
			 			  	</table>					   
			           </td> 
					   
					<cfelse>
					
					  <td align="center"><cfif fieldrequired eq "0"><b>No</b><cfelse>Yes</cfif></td> 
				   
				  </cfif>
				  
				  <td align="center">#DocumentOrder#</td>
				  <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
				  <td align="right" colspan="2">
					
						<table cellspacing="0" cellpadding="0">
						  <tr class="labelmedium" style="height:15px">
						  <cfif DocumentType eq "mail">
						  <td width="20" style="padding:2px">
						    <img src="#SESSION.root#/Images/email-icon.gif" 
							   height="15" 
							   width="15" 
							   alt="mail content"
							   style="cursor:pointer" 
							   onclick="javascript:showMailContentEdit('#documentId#')" 
							   border="0" 
							   align="absmiddle">
						  </td>
						  </cfif>
						  
						  <td width="20" style="padding-top:3px;padding-left:2px">
						  <cfif url.type eq "mail">
						    <cf_img icon="open" navigation="Yes" onclick="javascript:ptoken.navigate('../../EntityObject/ObjectElement.cfm?EntityCode=#URL.EntityCode#&Type=#URL.Type#&ID2=#nm#','imail')">						
						  <cfelse>
						    <cf_img icon="open" navigation="Yes" onclick="javascript:ptoken.navigate('../../EntityObject/ObjectElement.cfm?EntityCode=#URL.EntityCode#&Type=#URL.Type#&ID2=#nm#','i#url.type#')">
						  </cfif> 
						   
						  </td>						  
						  
						  <cfif DocumentType eq "question">
						  <td width="20" style="padding-left:2px">
						  
						    <img src="#SESSION.root#/Images/form.gif" 
							   height="15" 
							   width="15" 
							   alt="questions"
							   style="cursor:pointer" 
							   onclick="javascript:objectdialog('#URL.EntityCode#','#nm#','#URL.Type#')" 
							   border="0" 
							   align="absmiddle">
							   
						  </td>
						  </cfif>	
						  					  
					   	  <td align="center" style="min-width:30px;padding-top:3px">					
						  
						   <cfset show = 1>
						   
					       <cfif Used eq "No">	
						   
							   <cfif url.type eq "dialog">
							   
							   		<cfquery name="Check" 
									datasource="AppsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT ActionDialog 
										FROM   Ref_EntityClassAction
										WHERE EntityCode = '#URL.EntityCode#'
										AND   ActionDialog = '#DocumentCode#'
										UNION
										SELECT ActionDialog 
										FROM   Ref_EntityActionPublish
										WHERE ActionPublishNo IN (SELECT ActionPublishNo FROM Ref_EntityClassPublish WHERE EntityCode = '#URL.EntityCode#')
										AND   ActionDialog = '#DocumentCode#'
								    </cfquery>	
									
									<cfif check.recordcount gte "1">
									 
									 <cfset show = "0">
									
									</cfif>
									
								 <cfelseif url.type eq "script">
							   
							   		<cfquery name="Check" 
									datasource="AppsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT ActionDialog 
										FROM   Ref_EntityClassAction
										WHERE EntityCode = '#URL.EntityCode#'
										AND   ActionDialog = '#DocumentCode#'
										UNION
										SELECT ActionDialog 
										FROM   Ref_EntityActionPublish
										WHERE ActionPublishNo IN (SELECT ActionPublishNo FROM Ref_EntityClassPublish WHERE EntityCode = '#URL.EntityCode#')
										AND   ActionDialog = '#DocumentCode#'
								    </cfquery>	
									
									<cfif check.recordcount gte "1">
									 
									 <cfset show = "0">
									
									</cfif>	
																		
								<cfelse>						   
						   
								   	<cfquery name="Check" 
									datasource="AppsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT * 
										FROM   OrganizationObjectDocument
										WHERE  DocumentId = '#DocumentId#'		
								    </cfquery>
									
									<cfif check.recordcount gte "1">
									 
									 <cfset show = "0">
									
									</cfif> 	
									
								</cfif>	
							   
							   <cfif show eq "1">
							   
							   	 <cf_img icon="delete" onclick="#ajaxLink('../../EntityObject/ObjectElementPurge.cfm?EntityCode=#URL.EntityCode#&ID2=#DocumentId#&Type=#URL.Type#')#">
							   								   
							   </cfif>
						   	   
						   </cfif>
						   
					    </td>
						</table>
					</td>
				 </TR>	
				 
				 <cfif fieldtype eq "list">
				 
					<tr id="#documentid#" class="hide">
					<td colspan="8">
						<table width="80%" align="center" class="formpadding">
						<tr><td>
							<table width="100%" align="center" class="formpadding">
								<tr><td>			
								<iframe src="#SESSION.root#/system/entityaction/EntityObject/ElementList/ObjectList.cfm?documentid=#documentid#" name="frm_#documentid#" id="frm_#documentid#" width="100%" height="50" marginwidth="0" marginheight="0" hspace="0" vspace="0" align="left" scrolling="no" frameborder="0"></iframe>	
								</td></tr>
							</table>	
						</td></tr>
						</table>										
					</td>
					</tr>												
					
				 </cfif>
			
			</cfif>
						
		</cfloop>
		
		</cfoutput>													
				
		</table>	
		
		</CFFORM>
			
		</td>
		</tr>	
							
</table>	

<cfset AjaxOnLoad("doHighlight")>	
<cfset AjaxOnLoad("doCalendar")>	

