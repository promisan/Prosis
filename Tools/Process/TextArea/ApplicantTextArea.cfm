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

	<cfparam name="Attributes.table"            default="ApplicantInterviewNotes">
	<cfparam name="Attributes.domain"           default="Preliminary">
	<cfparam name="Attributes.mode"             default="view">
	<cfparam name="Attributes.fieldoutput"      default="InterviewNotes">
	<cfparam name="Attributes.format"           default="Text">
	<cfparam name="Attributes.ajax"             default="No">
	<cfparam name="Attributes.languageCode"     default="0">
	<cfparam name="Attributes.log"              default="No">
		
	<cfparam name="Attributes.Code"             default="">
	<cfparam name="Attributes.Toggle"			default="No">
	
	<cfparam name="Attributes.Key01"            default="">
	<cfparam name="Attributes.Key02"            default="">
	<cfparam name="Attributes.Key03"            default="">
	<cfparam name="Attributes.Key01Value"       default="">
	<cfparam name="Attributes.Key02Value"       default="">
	<cfparam name="Attributes.Key03Value"       default="">
	
	<cfparam name="Attributes.Attribute01"      default="">
	<cfparam name="Attributes.Attribute02"      default="">
	<cfparam name="Attributes.Attribute01Value" default="">
	<cfparam name="Attributes.Attribute02Value" default="">
	<cfparam name="Attributes.Officer"          default="Y">

	<cfparam name="Attributes.Height"           default="40">
	<cfparam name="Attributes.ActionCode"       default="">
	<cfparam name="Attributes.PathDefault"		default="">					

	<cfquery name="qLanguage" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_SystemLanguage
		WHERE   LanguageCode = '#Attributes.languagecode#'
		
	</cfquery>
	
	<cfif qLanguage.SystemDefault eq 1>
		<cfset prefix="">
	<cfelse>
		<cfset prefix="xl#qLanguage.Code#_">
	</cfif>

	
	<cfquery name="Notes" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     #Attributes.table# T RIGHT OUTER JOIN #prefix#Ref_TextArea R ON R.Code = T.TextAreaCode
		  AND    #attributes.Key01# = '#Attributes.Key01Value#'
		  <cfif Attributes.Key02 neq "">
		  AND    #attributes.Key02# = '#Attributes.Key02Value#'
		  </cfif>
		  <cfif Attributes.Key03 neq "">
		  AND    #attributes.Key03# = '#Attributes.Key03Value#'
		  </cfif>	
		  AND    T.LanguageCode = '#Attributes.languagecode#'			 
		WHERE    R.TextAreaDomain = '#Attributes.domain#' 	
		<cfif    attributes.code neq "">
			AND  R.Code = '#attributes.code#'
		</cfif>	
		ORDER BY R.ListingOrder
	</cfquery>	
	
	<cfif attributes.Toggle eq "Yes">

		<script>
			function toggleTextArea(id){
				ta = document.getElementById(id);
				if (ta){
					if (ta.style.display == 'none'){
						ta.style.display = '';
					}else{
						ta.style.display = 'none';
					}
				}
			}
		</script>
	
	</cfif>
	
	<cfif Attributes.mode neq "save">
	
			<table width="100%">
			
			<cfoutput query="Notes">
			
			    <cfif attributes.mode eq "View" and evaluate(attributes.fieldoutput) eq "">
				
				<cfelse>
									
				<cfif norows neq "">
					<cfset ht =  NoRows*15>				
				<cfelse>
					<cfset ht =  attributes.height>
				</cfif>	
			
				<tr><td style="height:4px"></td></tr>		
				
				<tr>
				   
					<td colspan="2">
	
					    <table width="100%">
						
							<tr>					
								<td align="left" style="<cfif attributes.mode eq 'edit'>border:1px solid silver;border-bottom:0px solid silver;background-color:f1f1f1<cfelse>font-weight:bold</cfif>;height:36px;padding-left:4px">  
									<table>
										<tr>
											<cfif attributes.mode eq "View" and attributes.toggle eq "Yes">
												<td> <cf_img icon="expand" toggle="yes" onclick="toggleTextArea('div_#Code#')"> </td>
											</cfif>
											<td style="font-size:17px;<cfif attributes.mode neq 'edit'>font-weight:bold</cfif>" class="labelmedium">#Description#</td>
										</tr>
									</table>
								</td>
							</tr>	
											
							<cfif explanation neq "">
								<tr><td align="left" style="padding-left:6px" class="labelit">#Explanation#</td></tr>
							</cfif>
							
							<cfif attributes.mode eq "View">
													
								<tr>
								<td align="left" class="labelmedium2" colspan="2" style="padding-left:5px;padding-top:2px; <cfif attributes.toggle eq 'Yes'>display:none;</cfif>" id="div_#Code#">
								     <!---
									 <cf_paragraph>
									 --->
										<cfif evaluate(attributes.fieldoutput) eq "">
										   -N/A-
										<cfelse>
											#ParagraphFormat(evaluate(attributes.fieldoutput))#
										</cfif>	
									<!---	
									</cf_paragraph>
									--->
								</td>
								</tr>
							</cfif>
						
						</table>
					</td>
					
					<cfif attributes.mode eq "edit">
					
						</tr>
					
						<tr>					
									   				
						<cfif Attributes.Format eq "Text">
						
						 <td colspan="3" syule="padding-top:5px" align="center" id="div_#Code#">	
						 																					
							<textarea style="height:#ht#;width:100%;font-size:13px;padding:3px;border:1px solid silver" name="#Code#_#Attributes.languageCode#"  id="#Code#_#Attributes.languageCode#"
							 class="regular">#evaluate(attributes.fieldoutput)#</textarea>		
							 			   
						<cfelse>
						
						   <td colspan="3" align="center" style="border: 0px solid Silver;padding-right:2px"> 
						   
						   		  <cfif Evaluate(attributes.fieldoutput) eq "" and attributes.PathDefault neq "">							  			  
								  	<cfset url.languagecode = Attributes.languagecode>
									<cfinclude template="../../../Custom#attributes.PathDefault##CODE#.cfm">
								  <cfelse>
								 	<cfset vText = evaluate(attributes.fieldoutput)>
								  </cfif>	
								  
								 <cfif attributes.Format eq "RichTextFull">
									  <cfset rt = "Full">	
								 <cfelseif attributes.Format eq "Mini">
									  <cfset rt = "Mini">			  							
								 <cfelse>
								  	  <cfset rt = "Basic">	  
								 </cfif>		
								  
								 <cfif attributes.height neq "100%">							  
									  <cfset ht = attributes.height>							  
								 <cfelse>							  
									  <cfset ht = "290">							  
								 </cfif>																		
								  
								 <cfif findNoCase("cf_nocache",cgi.query_string) or attributes.ajax eq "Yes"> 
								  					    							  
									  <cf_textarea name="#Code#_#Attributes.languageCode#" 
									     toolbar="#rt#" 									 
										 color="ffffff" 
										 height="#ht#" 
										 resize="false"><cf_paragraph>#vText#</cf_paragraph></cf_textarea>																
									 
								 <cfelse>
								 							 							 
									  <cf_textarea name="#Code#_#Attributes.languageCode#" 
									     toolbar="#rt#" 
										 init="Yes" 
										 color="ffffff" 
										 height="#ht#" 
										 resize="false"><cf_paragraph>#vText#</cf_paragraph></cf_textarea>		
								 							 
								 </cfif>	 
													
							</cfif>
												
					   </td>
				
				  </cfif>
				
			</tr>		
			
			</cfif>	
					
			</cfoutput>
			
			</table>	
				
	<cfelse>
	
		<cfoutput query="Notes">
		
		<cfset update = 1>
		
		<cfif not isDefined("Form.#Code#_#Attributes.languageCode#")>
			<cfset update = 0>
		</cfif>
		
		<cfparam name="Form.#Code#" default="">
		<cfparam name="Form.#Code#_#Attributes.languageCode#" default="">

		<cfset text  =   Evaluate("Form.#Code#_#Attributes.languageCode#")>
					
		<cfquery name="Check" 
		   datasource="appsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			SELECT *
			FROM   #Attributes.table#
			WHERE  #attributes.Key01# = '#Attributes.Key01Value#'
			<cfif Attributes.Key02 neq "">
			AND    #attributes.Key02# = '#Attributes.Key02Value#'
			</cfif>
			<cfif Attributes.Key03 neq "">
			AND    #attributes.Key03# = '#Attributes.Key03Value#'
			</cfif>
			AND    TextAreaCode = '#Code#'
			AND    LanguageCode = '#Attributes.languagecode#'
		</cfquery>
		
		
		<cfif Check.recordcount eq "0">
			
		 <cfquery name="InsertNotes" 
			datasource="appsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO #Attributes.table#
				 (
				  #Attributes.Key01#,	
				  <cfif Attributes.Key02 neq "">#Attributes.Key02#,</cfif>  
				  <cfif Attributes.Key03 neq "">#Attributes.Key03#,</cfif>  
				  <cfif Attributes.Attribute01 neq "">#Attributes.Attribute01#,</cfif>
				  <cfif Attributes.Attribute02 neq "">#Attributes.Attribute02#,</cfif>
				  TextAreaCode,
				  LanguageCode,
				  #attributes.fieldoutput#, 
				  OfficerUserId, 
				  OfficerLastName,  
				  OfficerFirstName				  
				  )
			  VALUES (
			    	  '#Attributes.Key01Value#',	
					  <cfif Attributes.Key02 neq "">'#Attributes.Key02Value#',</cfif>
					  <cfif Attributes.Key03 neq "">'#Attributes.Key03Value#',</cfif>
			          <cfif Attributes.Attribute01 neq "">'#Attributes.Attribute01Value#',</cfif>
					  <cfif Attributes.Attribute02 neq "">'#Attributes.Attribute02Value#',</cfif>	  
					  '#Code#',
					  '#Attributes.languagecode#',
					  '#Text#',					  
					  '#SESSION.acc#', 
					  '#SESSION.last#', 
					  '#SESSION.first#'					 
					   )
			</cfquery>
	
	    <cfelse>
		
			<cfif update eq 1>
		
			   <cfquery name="Update" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE #Attributes.table#
					SET    #attributes.fieldoutput# = '#text#'
					WHERE #attributes.Key01# = '#Attributes.Key01Value#'
					<cfif Attributes.Key02 neq "">
					AND   #attributes.Key02# = '#Attributes.Key02Value#'
					</cfif>
					<cfif Attributes.Key03 neq "">
					AND   #attributes.Key03# = '#Attributes.Key03Value#'
					</cfif>
					AND    TextAreaCode = '#Code#' 
					AND    LanguageCode = '#Attributes.languagecode#'
				</cfquery>
		
				<cfif attributes.log eq "Yes">
					<cfinclude template="ApplicantTextAreaLog.cfm">
				</cfif>
			
			</cfif>
			
	    </cfif>
							
		</cfoutput>
		
   </cfif>		