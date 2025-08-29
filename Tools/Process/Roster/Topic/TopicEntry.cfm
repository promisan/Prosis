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
 <cfparam name="URL.SearchId"    default="">
 <cfparam name="URL.ApplicantNo" default="">
 <cfparam name="URL.Topic"       default="">
 <cfparam name="URL.Mode"        default="regularxl">
  
 <cfparam name="Attributes.SearchId"     default="#URL.Searchid#"> 
 <cfparam name="Attributes.ApplicantNo"  default="#URL.ApplicantNo#">
 <cfparam name="Attributes.Topic"        default="#URL.Topic#">
 <cfparam name="Attributes.Mode"         default="#URL.Mode#">
 <cfparam name="Attributes.Script"       default="">
 <cfparam name="Attributes.Style"        default="">
 <cfparam name="Attributes.onChange"     default="">
 <cfparam name="Attributes.Attachment"   default="no">
 <cfparam name="Attributes.Tooltip"      default="0">
 <cfparam name="Attributes.TextAreaType" default="CK">
 
   
 <cfquery name="Topic" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_Topic
	  WHERE  Topic = '#Attributes.Topic#'   
 </cfquery>
  
 <cfoutput query="Topic">
 
  <cfif Attributes.searchId neq "">
  
	  <cfquery name="Checked" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT '' as ListCode, SelectParameter as TopicValue
		FROM   RosterSearchline
		WHERE  SearchId     = '#Attributes.Searchid#'
		AND    SearchClass  = 'SelfAssessment' 
		AND    Selectid     = '#Attributes.Topic#'		
	 </cfquery>	 
	   
  <cfelse>
  
  <!---
  <cfparam name="checked.listcode" default="">
  <cfparam name="checked.topicvalue" default="">
  --->      
 
	  <cfquery name="Checked" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   ApplicantSubmissionTopic
		WHERE  ApplicantNo = '#Attributes.ApplicantNo#'
		AND    Topic       = '#Attributes.Topic#' 
	 </cfquery>	

	  
 </cfif>
 
 <input type="hidden" name="Topic_#Attributes.Topic#" value="#Topic#">
  
 <cfif Attributes.Mode eq "view" and trim(Checked.TopicValue) eq "">
  
 	<!--- show nothing --->
	<span style="color:##808080;">[ <cf_tl id="no entry"> ]</span>
 
 <cfelse>
 
	 <table border="0" style="<cfif valueclass eq 'radio'>border:1px solid gray</cfif>" width="100%" height="100%" cellspacing="0" cellpadding="0"><tr>	

		          										      
			  <cfswitch expression="#ValueClass#">
																						 			 			  
				  <cfcase value="List">
				 
				 	<!--- obtain the list of values to be shown for a topic, 
					Hanno : we can make it 	faster if this remains the same ---> 
				   
					    <cfsavecontent variable="qry">
						 
							 <cfif ListTable eq "">
							 
							 	  SELECT   L.ListCode    as PK, 
								           L.ListValue   as Display,
										   L.ListDefault as DEF,
										   T.ValueMask,
										   L.Operational,
										   L.ListStyle,
										   L.TopicEntry
								  FROM     #CLIENT.LanPrefix#Ref_TopicList L INNER JOIN Ref_Topic T ON L.Code = T.Topic
								  WHERE    Code = '#Topic#'
								  <!---
								  AND      Operational = 1
								  --->
								  ORDER BY L.ListOrder 
								  
							 <cfelse>
							 
								  SELECT   DISTINCT 
								           #ListPK# as PK, 
								           #ListDisplay# as Display,
										   0 as DEF,
										   '' as ValueMask,
										   1 as Operational,
										   '' as TopicEntry,
										   '' as ListStyle,
										   #ListOrder# as ListOrder
								  FROM     #ListTable#
								  #ListCondition#
								  ORDER BY ListOrder 
							  					
							 </cfif>
						 
						</cfsavecontent>
						
					  <td class="labelmedium" style="border-top:0px solid silver;border-bottom:0px solid silver;#Attributes.Style# ">  
					 					  
					  	<cfif Attributes.Mode neq "view">
						
							<cfif Checked.listCode neq "">
								<cfset sel = checked.listCode>
							<cfelse>
								<cfset sel = checked.topicValue>
							</cfif>		
							
																																																																																									 
					 	  	<cf_ListInput
						       form        = "topic"
						       parent      = "#Topic#"
							   type        = "#ValueClass#"							   							   
							   name        = "Value_#Attributes.Topic#"
							   onchange    = "#Attributes.onChange#" 
						       value       = "#sel#"
						       required    = "#ValueObligatory#"
							   visible     = "Yes"
						       enabled     = "Yes"
							   class       = "regularxl enterastab #Attributes.Mode#"
						       size        = "#ValueLength#"
						       maxlength   = "#ValueLength#"
							   datasource  = "#ListDataSource#"
							   query       = "#qry#"
							   Tooltip     = "#attributes.tooltip#"							   
							   Multiple    = "#Topic.ValueMultiple#"
							   style	   = "#Attributes.Style#">						   
						  						   
						<cfelse>
																		
							<cfif trim(Checked.TopicValue) eq "">
								[<cf_tl id="Not submitted">]
							<cfelse>
								#Checked.TopicValue#
							</cfif>
						
						</cfif>
												   					   					
					   </td>	
					   
					         
					  						  
					   <!--- show space for sub-topic entry --->
															  
					   <td id="#Attributes.Topic#" class="hide">
					   						  				  					  
						        <!--- 25/1/2015 unclear what this refers to 
								make sure the default is shown initially --->
														  
							  	<cfif ListTable eq "">
																								
								   <cfquery name="list" 
									  datasource="#ListDataSource#" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
										  #preserveSingleQuotes(qry)# 
								   </cfquery>
							    
								   <cfloop query="List">
								   								   																								
										<cfif (Checked.TopicValue eq PK) or (Checked.TopicValue eq "" and DEF eq "1")>
																																
											<cf_TopicEntry 
			       							ApplicantNo ="#Attributes.ApplicantNo#" 
											SearchId="#attributes.Searchid#"
								            Topic="#TopicEntry#"
											mode="#Attributes.Mode#">
																														
										</cfif>
												
									</cfloop>	
									
								</cfif>	
																
					   </td>						   
									  				  	  	  
				  </cfcase>		
				  
				  
				  <cfcase value="Date">
				  
				  	<td class="labelmedium">
					
					  	<cfif Attributes.Mode neq "view">
					  		<CF_DateConvert Value="#Checked.TopicValue#">
							<cf_intelliCalendarDate9
								FieldName="Value_#Attributes.Topic#" 
								Default="#DateFormat(dateValue, CLIENT.DateFormatShow)#"
								AllowBlank="#not ValueObligatory#"					
								class="regularxl enterastab">
						<cfelse>
								#DateFormat(Checked.TopicValue, CLIENT.DateFormatShow)#
						</cfif>			
					  	
					  	  <cf_space spaces="40">
						  
					 </td>				  	  	
				  </cfcase>	
				  
				  <cfcase value="Memo">
				  
				  	<td class="labelmedium" style="border:0px solid silver">
										
					  	<cfif Attributes.Mode neq "view">
							<cf_textarea name="Value_#Attributes.Topic#" 
							width="98%" height="90" 
							init="yes" 
							color="ffffff" 
							toolbar="basic" 
							type="#attributes.textAreaType#"
							onchange="updateTextArea();">#Checked.TopicValue#</cf_textarea>
						<cfelse>
								#Checked.TopicValue#
						</cfif>			
						  
					 </td>				  	  	
				  </cfcase>				  
				  
				  <cfdefaultcase>
				  
				    <td class="labelmedium">
				  
				  		<!--- text, memo, zip inputtype --->
						<cfif Attributes.Mode neq "view">
						
						
							<cf_textInput
							   form      = "topic"
							   type      = "#ValueClass#"
							   mode      = "#Attributes.Mode#"
							   name      = "Value_#Attributes.Topic#"
							   onchange  = "#Attributes.onChange#" 
						       value     = "#Checked.TopicValue#"
							   mask      = "#ValueMask#"
						       required  = "#ValueObligatory#"
							   validate  = "#ValueValidation#"
						       visible   = "Yes"
						       enabled   = "Yes"
							   class     = "regularxl"
						       size      = "#ValueLength#"
						       maxlength = "#ValueLength#"
							   style	 = "#Attributes.Style#">
						   
						   <cf_space spaces="40">
						   
						<cfelse>
						
							#Checked.TopicValue#
							<cfif trim(Checked.TopicValue) neq "">
								<cf_space spaces="40">
							</cfif> 
						
						</cfif>								
						   
					</td>	   
				
				  </cfdefaultcase>
				  				
			  </cfswitch>
			  		
			  			  		  
			</tr>
			
		<cfif Attributes.Attachment eq "yes">
		
			<tr><td height="5"></td></tr>
			<tr>
				<td>
					<table width="98%">
						<tr>
							<td style="padding-bottom:4px">
							
								<cfset vEdit = "yes">
								<cfif Attributes.Mode eq "view">
									<cfset vEdit = "no">
								</cfif>
								
								<cf_filelibraryN
									DocumentPath="Submission"
									SubDirectory="#Attributes.ApplicantNo#_#Attributes.Topic#" 	
									Filter=""		
									Insert="#vEdit#"									
									loadscript="no"
									AttachMultiple="Yes"													
									
									Box="mysubmission_#Attributes.Topic#"
									Remove="#vEdit#"
									ShowSize="no">
									
							</td>
						</tr>
					</table>
				</td>
			</tr>
			
		</cfif>
			
	</table>	

</cfif>  
			  
</cfoutput>		