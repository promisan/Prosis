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
 <cfif format eq "HTML">
		 
		    <cfoutput>
			<table width="570" 
			border="0" 
			cellspacing="0" 
			cellpadding="0"
			class="formpadding">
						
			<tr>
				<td colspan="2">
				
				<table width="100%" cellspacing="0" cellpadding="0">
				
				 <tr><td valign="top">
				 
					 <table border="0" cellspacing="0" cellpadding="0" class="formpadding">
					 <tr><td valign="top" onkeyup="addOnEnter(event,'#ControlId#','#CriteriaName#',document.getElementById('#fldid#').value,'','#fldid#');">
										
					 <cfif LookupTable eq "">
																					
						 <cf_textInput
							   form      = "selection"
							   type      = "#tpe#"							  
							   mode      = "regular"
							   name      = "sel#CriteriaName#"
							   id        = "#fldid#"						       
							   label     = "#CriteriaDescription#:"
							   mask      = "#criteriaMask#"  
						       required  = "#ob#"
							   validate  = "#CriteriaValidation#"
							   pattern   = "#criteriapattern#"
						       visible   = "Yes"
						       enabled   = "Yes"
						       size      = "#CriteriaWidth#"
						       maxlength = "800"
							   class     = "regularXXL"							   
							   message   = "#Error#">			 
				 
				    <cfelse>						
				
						 <cf_textInput
							   form            = "selection"
							   type            = "#tpe#"							   
							   mode            = "regular"
							   name            = "sel#CriteriaName#"
							   id              = "#fldid#"						       
							   label           = "#CriteriaDescription#:"
						       required        = "#ob#"
							   validate        = "#CriteriaValidation#"
							   pattern         = "#criteriapattern#"
						       visible         = "Yes"
						       enabled         = "Yes"
						       size            = "#CriteriaWidth#"
						       maxlength       = "800"
							   class           = "regularXXL"
							   autosuggest     = "cfc:service.reporting.presentation.getlookup('#ControlId#','#CriteriaName#',{cfautosuggestvalue})"						       
							   message         = "#Error#">
					   
				    </cfif>	
				 
				 </td>
				 
				 <td valign="top">
								
				  <img src="#SESSION.root#/Images/plus_green.png" 
					 align="absmiddle" id = "add#fldid#" name = "add#fldid#"
					 onclick="verifycont('#ControlId#','#CriteriaName#',document.getElementById('#fldid#').value,'','#fldid#')"
					 style="padding-left:5px; height:23px;"
					 alt="Add Value" 
					 border="0">
					 
				 </td>
				 
				 <td valign="top" style="padding-left:20px;">
				
					<table width="100%" cellspacing="0" cellpadding="0">
					
						<tr>
						
						<td width="16" valign="top">
						
						   <button class="button3"  type="button"
							 onclick="verifycont('#ControlId#','#CriteriaName#','','','#fldid#')" 
							 name="testcontent" id="testcontent">
							   <img src="#SESSION.root#/Images/check.png" height="25" width="25" title="Verify entered data" border="0">
							</button>
							
						</td>
						
						<td id="verify#CriteriaName#" class="labelit" valign="top" style="padding-top:2px;">
						
							<cfoutput>
							
							<cfif CriteriaDefault eq "">
		
								<font color="6688aa">[<cf_tl id="No preselection">]</font>
								
									<textarea rows="3" 
									name="#CriteriaName#" id="#CriteriaName#" 
									class="hide" 
									style="width:99%;font-size:13px;padding:3px">#CriteriaDefault#</textarea> 
							
							<cfelse>
							
							    <cfdiv bind="url:#SESSION.root#/Tools/CFReport/SelectInputVerify.cfm?controlid=#controlid#&criterianame=#criterianame#&val=#CriteriaDefault#"/>
															
							</cfif>											
							
							</cfoutput>
										
						</td>
						
						</tr>
								
					</table>
					
					</td>
			 	</tr>	
					
				</table>
			 
		     </td>
				
			</tr>
				
		   </table>
			</td>
			</tr>
			</table>		
			</cfoutput>	
				
		 <cfelse>
		 
		    <!--- not apllicable --->
			
		 </cfif>	   