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
	<cfparam name="Attributes.textareacode"     default="">
	<cfparam name="Attributes.field"            default="">
	<cfparam name="Attributes.onchange"         default="">
	<cfparam name="Attributes.mode"             default="view">
	<cfparam name="Attributes.fieldoutput"      default="ProfileNotes">
	<cfparam name="Attributes.format"           default="Text">
	<cfparam name="Attributes.height"           default="260">
	<cfparam name="Attributes.join"             default="RIGHT OUTER JOIN">
	<cfparam name="Attributes.log"              default="No">
	
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
	<cfparam name="Attributes.ActionCode"       default="">
	
	<cfif client.width gte 1024>
	  <cfset cols = "90">
	<cfelse>
	  <cfset cols = "70">
	</cfif>
	
	<cfquery name="Profile" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     #Attributes.table# T #attributes.join# Ref_TextArea R ON R.Code = T.TextAreaCode
		  AND    #attributes.Key01# = '#Attributes.Key01Value#'
		<cfif Attributes.Key02 neq "">
		  AND    #attributes.Key02# = '#Attributes.Key02Value#'
		</cfif>
		<cfif Attributes.Key03 neq "">
		  AND    #attributes.Key03# = '#Attributes.Key03Value#'
		</cfif>		
		WHERE    R.TextAreaDomain   = '#Attributes.domain#'  

		<!--- selected textareas to be saved --->
		<cfif attributes.textareacode neq "">
		AND      R.Code IN (#preserveSingleQuotes(attributes.textareacode)#)
		</cfif>
		
		ORDER BY R.ListingOrder
	</cfquery>	
	
	<cfif Attributes.mode neq "save">
	
			<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			
			<cfoutput query="Profile">
			
			<cfset attributes.height = NoRows * 22>
			
			<cfif Attributes.Format neq "Text" and attributes.height lte 100>
				<cfset attributes.height = "150">
			</cfif>
								
			<tr>
			    
				<td valign="top" style="padding-left:18px">
				    <table cellspacing="0" cellpadding="0">
						<tr>
						<td style="padding-top:1px">
							<table>
							 <tr><td class="labelmedium"><font color="808080">#Description#</td></tr>						 
							</table>
						</td>
						</tr>
						<cfif Explanation neq "">
						<tr><td class="labelmedium" style="height:20px;padding-left:16px;padding-right:20px"><font color="808080">#Explanation#</td></tr>
						</cfif>
					</table>
				</td>
				
				<cfif attributes.mode eq "edit">
				
				</tr>
				
				<tr>
				    <td colspan="3" align="center">
														
					   <cfif Attributes.Format eq "Text">
					   								 				
							<textarea style="min-height:80px;width:95%;font-size:13px;padding-top:5px;padding-left:8px;padding-right:8px;height:#Attributes.height#;resize:vertical;border:0px solid silver;background-color:ffffdf"
							  rows="#NoRows#" 
							  onchange="#attributes.onchange#"
							  name="f#attributes.field##Code#" 
							  class="regular">#evaluate(attributes.fieldoutput)#</textarea>
									   
					   <cfelse>
					   					   
					   		  <cfif attributes.Format eq "RichTextFull">
									  <cfset rt = "full">
							  <cfelse>
								  	  <cfset rt = "Basic">	  
							  </cfif>							  				
								  
							  <cf_textarea name   = "f#attributes.field##Code#"									  
									  onchange   = "#attributes.onchange#"
									  toolbar    = "#rt#"								 				                     
									  resize     = "yes"
								      color      = "f4f4f4"
									  style		 = "font-size:13px;padding:3px;width:99%;height:#Attributes.height#;"><cf_paragraph>#evaluate(attributes.fieldoutput)#</cf_paragraph></cf_textarea>		
					
						</cfif>
												
					</td>
				
				<cfelse>
					<td width="65%" valign="top" bgcolor="FFFFEC" class="labelit" style="padding-left:8px;padding-right:8px;border:1px dotted silver">#ParagraphFormat(evaluate(attributes.fieldoutput))#</td>
				</cfif>
				
				</tr>
				
				<tr><td></td></tr>
				
				<!---
				<cfif currentRow neq recordcount>
					<tr><td colspan="4" class="linedotted"></td></tr>
				</cfif>
				--->
			
			</cfoutput>
			
			</table>
	
	<cfelse>
	
		<cfoutput query="Profile">
			
			<cfparam name="Form.f#attributes.field##Code#" default="">
			<cfset text  =   Evaluate("Form.f#attributes.field##Code#")>
			
			 <cfset height = "#noRows*22#">   
								
			<cfquery name="Check" 
			   datasource="appsProgram" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				SELECT *
				FROM  #Attributes.table#
				WHERE #attributes.Key01# = '#Attributes.Key01Value#'
				<cfif Attributes.Key02 neq "">
				AND   #attributes.Key02# = '#Attributes.Key02Value#'
				</cfif>
				<cfif Attributes.Key03 neq "">
				AND   #attributes.Key03# = '#Attributes.Key03Value#'
				</cfif>
				AND   TextAreaCode = '#Code#'
			</cfquery>
			
			<cfif Check.recordcount eq "0">
				
				 <cfquery name="InsertProFile" 
					datasource="appsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO #Attributes.table# (
						  #Attributes.Key01#,	
						  <cfif Attributes.Key02 neq "">#Attributes.Key02#,</cfif>  
						  <cfif Attributes.Key03 neq "">#Attributes.Key03#,</cfif>  
						  <cfif Attributes.Attribute01 neq "">#Attributes.Attribute01#,</cfif>
						  <cfif Attributes.Attribute02 neq "">#Attributes.Attribute02#,</cfif>
						  TextAreaCode,
						  #attributes.fieldoutput#
						  <cfif Attributes.Officer eq "Y">
						  ,OfficerUserId, OfficerLastName,  OfficerFirstName
						  </cfif>)
					  VALUES (
					    	  '#Attributes.Key01Value#',	
							  <cfif Attributes.Key02 neq "">'#Attributes.Key02Value#',</cfif>
							  <cfif Attributes.Key03 neq "">'#Attributes.Key03Value#',</cfif>
					          <cfif Attributes.Attribute01 neq "">'#Attributes.Attribute01Value#',</cfif>
							  <cfif Attributes.Attribute02 neq "">'#Attributes.Attribute02Value#',</cfif>	  
							  '#Code#',
							  '#Text#'
							   <cfif Attributes.Officer eq "Y">
							   ,'#SESSION.acc#', 
							   '#SESSION.last#', 
							   '#SESSION.first#'
							   </cfif>)
					</cfquery>
		
		    <cfelse>
							
			   <cfquery name="Update" 
				datasource="appsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE  #Attributes.table#
					SET     #attributes.fieldoutput# = '#text#'
					        <cfif Attributes.Officer eq "Y">,
						        OfficerUserId     = '#SESSION.acc#',
								OfficerLastName   = '#SESSION.last#',
								OfficerFirstName  = '#SESSION.first#'
							</cfif>					
					WHERE   #attributes.Key01# = '#Attributes.Key01Value#'
					<cfif   Attributes.Key02 neq "">
					AND     #attributes.Key02# = '#Attributes.Key02Value#'
					</cfif>
					<cfif   Attributes.Key03 neq "">
					AND     #attributes.Key03# = '#Attributes.Key03Value#'
					</cfif>
					AND     TextAreaCode = '#Code#'				
				</cfquery>
				
				<cfif attributes.log eq "Yes">
					<cfinclude template="ProgramTextAreaLog.cfm">
				</cfif>
				
						
		    </cfif>
	
		</cfoutput>
		
   </cfif>		
   
