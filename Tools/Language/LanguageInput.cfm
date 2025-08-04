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

<!--- saves language input --->

	<cfparam name="Attributes.tablecode"                default="Organization">
	<cfparam name="Attributes.mode"                     default="edit">
			
	<cfparam name="Attributes.Key1Value"                default="">
	<cfparam name="Attributes.Key2Value"                default="">
	<cfparam name="Attributes.Key3Value"                default="">
	<cfparam name="Attributes.Key4Value"                default="">
		
	<cfparam name="Attributes.form"        				default="">	
	<cfparam name="Attributes.name"        				default="">
	<cfparam name="Attributes.namesuffix"  				default="">
	<cfparam name="Attributes.value"       				default="">
		
	<cfparam name="Attributes.type"        				default="Input">
	<cfparam name="Attributes.maxlength"   				default="40">
	<cfparam name="Attributes.size"        				default="10">
	<cfparam name="Attributes.required"    				default="No">
	<cfparam name="Attributes.onchange"    				default="">
	<cfparam name="Attributes.message"     				default="">
	<cfparam name="Attributes.cols"        				default="40">
	<cfparam name="Attributes.height"      				default="150">
	<cfparam name="Attributes.rows"        				default="1">
	<cfparam name="Attributes.class"       				default="regular">
	
	<!--- filtering --->
	<cfparam name="Attributes.LanguageDefault" 			default="0">
	<cfparam name="Attributes.Operational" 				default="2">
	
	<cfparam name="Attributes.Label"       				default="No">
	<cfparam name="Attributes.Lines"       				default="1">
	<cfparam name="Attributes.Style"       				default="">
	<cfparam name="Attributes.Datasource"  				default="AppsSystem">
	<cfparam name="Attributes.ShowLanguageOperational"  default="0">
	<cfparam name="Attributes.EnforceDefault"           default="1">
	
	<cfquery name="Source"
	datasource="#Attributes.Datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM      System.dbo.LanguageSource
		WHERE     TableCode = '#Attributes.TableCode#' 
	</cfquery>
									
	<cfif Source.recordcount neq "1">
			
		<!--- do nothing, this will throw an error --->
		
		<CFSET Caller.lt_content    = "not found">
					
	<cfelse>
				
			<cfset key1   = "#Source.KeyFieldName#">
			<cfset key2   = "#Source.KeyFieldName2#">
			<cfset key3   = "#Source.KeyFieldName3#">
			<cfset key4   = "#Source.KeyFieldName4#">
			<cfset ds     = "#Source.DataSource#">
			<cfset table  = "#Source.TableName#">
						
			<cfif Attributes.mode eq "get">
			
				<cftry>
			
				<cfquery name="TextLanguage" 
					datasource="#ds#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  L.Code, 
						        L.LanguageName, 
								L.SystemDefault, 
								#Attributes.Name# as Value
								<cfif Attributes.ShowLanguageOperational eq 1>,T.Operational as FunctionOperational</cfif>
						
						FROM    #table#_Language T RIGHT OUTER JOIN
                      			System.dbo.Ref_SystemLanguage L ON T.LanguageCode = L.Code
								 AND T.#Key1# = '#Attributes.Key1Value#'
								<cfif Key2 neq "">
									AND   T.#Key2# = '#Attributes.Key2Value#'
								</cfif>
								<cfif Key3 neq "">
									AND   T.#Key3# = '#Attributes.Key3Value#'
								</cfif>
								<cfif Key4 neq "">
									AND   T.#Key4# = '#Attributes.Key4Value#'
								</cfif>
												
						WHERE  L.Operational   >= '#Attributes.Operational#' 
						AND    L.SystemDefault >= '#Attributes.LanguageDefault#'
						AND    T.LanguageCode  = '#client.languageid#'
						
						<!--- ORDER BY SystemDefault DESC, L.Code   --->
					</cfquery>
					
					<cfif table eq "Ref_ModuleControl" and textlanguage.recordcount eq "0">
					
						<cfquery name="TextLanguage" 
						datasource="#ds#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  L.Code, 
							        L.LanguageName, 
									L.SystemDefault, 
									#Attributes.Name# as Value
									<cfif Attributes.ShowLanguageOperational eq 1>,T.Operational as FunctionOperational</cfif>
							
							FROM    #table#_Language T RIGHT OUTER JOIN
	                      			System.dbo.Ref_SystemLanguage L ON T.LanguageCode = L.Code
									 AND T.#Key1# = '#Attributes.Key1Value#'								
													
							WHERE  L.Operational >= '#Attributes.Operational#' 
							AND    L.SystemDefault >= '#Attributes.LanguageDefault#'
							AND    T.LanguageCode = '#client.languageid#'
							
							<!--- ORDER BY SystemDefault DESC, L.Code   --->
						</cfquery>
										
					</cfif>
					
						<CFSET Caller.lt_content    = "#TextLanguage.Value#">
										
					<cfcatch>
					
						<CFSET Caller.lt_content    = "not found">
										
					</cfcatch>
					
					</cftry>
											
			<cfelseif Attributes.mode neq "save">	
															
					<cfquery name="TextLanguage" 
					datasource="#ds#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  L.Code, 
						        L.LanguageName, 
								L.SystemDefault, 
								#Attributes.Name# as Value
								<cfif Attributes.ShowLanguageOperational eq 1>,T.Operational as FunctionOperational</cfif>
						
						FROM    #table#_Language T RIGHT OUTER JOIN
                      			System.dbo.Ref_SystemLanguage L ON T.LanguageCode = L.Code
								 AND T.#Key1# = '#Attributes.Key1Value#'
								<cfif Key2 neq "">
									AND   T.#Key2# = '#Attributes.Key2Value#'
								</cfif>
								<cfif Key3 neq "">
									AND   T.#Key3# = '#Attributes.Key3Value#'
								</cfif>
								<cfif Key4 neq "">
									AND   T.#Key4# = '#Attributes.Key4Value#'
								</cfif>
												
						WHERE  L.Operational   >= '#Attributes.Operational#' 
						AND    L.SystemDefault >= '#Attributes.LanguageDefault#'
						
						ORDER BY SystemDefault DESC, L.Code   
					</cfquery>
					
					<cfif table eq "Ref_ModuleControl" and TextLanguage.Value eq "">
					
						<cfquery name="TextLanguage" 
						datasource="#ds#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  L.Code, 
							        L.LanguageName, 
									L.SystemDefault, 
									#Attributes.Name# as Value
									<cfif Attributes.ShowLanguageOperational eq 1>,T.Operational as FunctionOperational</cfif>
							
							FROM    #table#_Language T RIGHT OUTER JOIN
	                      			System.dbo.Ref_SystemLanguage L ON T.LanguageCode = L.Code
									 AND T.#Key1# = '#Attributes.Key1Value#'
									 AND T.Mission = ''												
							
							WHERE  L.Operational >= '#Attributes.Operational#' 
							AND    L.SystemDefault >= '#Attributes.LanguageDefault#'
														
							ORDER BY SystemDefault DESC, L.Code   
						 </cfquery>
					
					</cfif>
					
					<cfif Attributes.Label eq "No">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">						
					</cfif>
					
					<cfoutput query="TextLanguage">
					
						<cfif SystemDefault eq "1" and Attributes.Operational eq "2">
						     <cfset nm = "#Attributes.Name##Attributes.NameSuffix#">						 
						     <cfset val = "#Attributes.value#">							
						<cfelse>
						     <cfset nm = "#Attributes.Name##Attributes.NameSuffix#_#Code#">						 
						     <cfset val = "#TextLanguage.Value#">						  						 
						</cfif>
						
						<tr>
												 
						   <cfif Attributes.Label eq "Yes">
							 <td style="padding-top:1px;padding-bottom:1px">							    
							 	<label>
									<font face="Verdana" color="0080C0">#LanguageName#:&nbsp;
								</label>
							 </td>
						   </cfif>
												
						   <td style="padding-top:1px;padding-bottom:1px" class="#attributes.class# labelmedium">
						  					
							<cfif attributes.mode eq "edit">
															 
							   <table width="100%" height="100%">
							  
							   <cfif attributes.form neq "">		
							   <tr><td align="right" id="memcount_#nm#"></td></tr>
							   </cfif>
					   
							   <tr><td width="100%" class="labelit" title="Please submit entry in #LanguageName#">		
							
								<cfif Attributes.type eq "Input">
								
									<cfif SystemDefault neq "1">
										<cfset st = "#attributes.style#;background-color: F0FFFF;">
									<cfelse>
									    <cfset st = "#attributes.style#;background-color: FFFFFF;">	
									</cfif>		
																																										
									<cfinput type = "text" 
									    name      = "#nm#" 
										size      = "#Attributes.size#" 
									    maxlength = "#Attributes.maxlength#"
										value     = "#val#" 											
										class     = "#Attributes.Class#"
										required  = "#Attributes.Required#"
										onchange  = "#Attributes.onchange#"
										style     = "#st#"
										message   = "#Attributes.message# #LanguageName#">
										  
								<cfelse>	
								
								    <cfif Attributes.type eq "HTML">
									
									        <cf_textarea name="#nm#" id="#nm#"                                            
											   height         = "#attributes.height#"
											   toolbar        = "basic"
											   resize         = "no"
											   init           = "Yes"
											   color          = "ffffff">#val#</cf_textarea>
									
									<cfelse>
																		
																							
										<cfif attributes.form neq "">
										
											<textarea rows="#Attributes.Rows#"  
												 name="#nm#" 
												 class="#Attributes.Class#"
												 maxlength="#Attributes.maxlength#"
												 onKeyUp="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/input/text/memolength.cfm?field=#nm#&size=#Attributes.maxlength#','memcount_#nm#','','','POST','#attributes.form#')"											 
												 style="max-width:99%;width:99%;resize: vertical;background-color:<cfif SystemDefault neq '1'>F0FFFF<cfelse>F1F1F1</cfif>;border-radius:3px;font-size:14px;padding:8px">#val#</textarea>		
											
										<cfelse>
																								
											<textarea rows="#Attributes.Rows#"  
												 name="#nm#" 
												 class="#Attributes.Class#"
												 maxlength="#Attributes.maxlength#"
												 onkeyup="return ismaxlength(this)"
												 style="font-size:14px;max-width:99%;width:99%;resize: vertical;background-color:<cfif SystemDefault neq '1'>F0FFFF<cfelse>F1F1F1</cfif>;border-radius:3px;padding:8px">#val#</textarea>		
												 
										</cfif>		
									
									</cfif>
																							 
									
								</cfif>
								
								<font style="background: F0FFFF;"></font>
								
								<label>
								<cfif Attributes.ShowLanguageOperational eq 1>
									<input title="Operational" type="Checkbox" name="Operational_#nm#" id="Operational_#nm#" <cfif FunctionOperational eq 1>checked</cfif> <cfif SystemDefault eq 1 and attributes.enforcedefault eq "1">disabled</cfif>>
								</cfif>
								</label>
							
							  </td>
							  </tr>
							  
							  </table>
							
							<cfelse>
							
									<cfif Attributes.type eq "Input">#val#<cfelse>#ParagraphFormat(val)#</cfif>
									
									<input type = "hidden" name = "#nm#" value = "#val#">
																		
							</cfif>							
									
							</td>
		
						</tr>						
								
					</cfoutput>
					
					<cfif Attributes.Label eq "No">
						</table>
					</cfif>
					
			<cfelse>
			
			    <!--- SAVE --->
				
				
				<cfloop index="ln" from="1" to="#Attributes.Lines#">
						
					<cfquery name="Language" 
					datasource="#ds#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT L.Code, L.LanguageName, L.SystemDefault, L.LanguageCode
					    FROM   System.dbo.Ref_SystemLanguage L   
						WHERE  L.Operational   >= '#Attributes.Operational#' 	
						AND    L.SystemDefault >= '#Attributes.LanguageDefault#'					
						
							<cfif Attributes.Operational eq "2">
							AND   L.SystemDefault != 1  <!--- the system default is in the master table --->
							</cfif>						
							
						ORDER BY SystemDefault DESC, L.Code  
					</cfquery>					
										
					<!--- only non default languages --->
										
					<cfoutput query="Language">
					
					<cfparam name ="Attributes.Value#ln#" default="">
																			
					<cfset field   =  Evaluate("Attributes.Name#ln#")>
					<cfset value   =  Evaluate("Attributes.Value#ln#")>
								
					<cfparam name ="Form.#field##Attributes.NameSuffix#_#Code#" default="#value#">
					
					<cfset textvalue  =  Evaluate("Form.#field##Attributes.NameSuffix#_#Code#")>
					

					<cfset operationalvalue = 0>
					<cfif Attributes.ShowLanguageOperational eq 1 and isDefined("Form.Operational_#field##Attributes.NameSuffix#_#Code#")>
						<cfset operationalvalue = 1>
					</cfif>
					<cfif SystemDefault eq 1 and attributes.enforceDefault eq "1">
						<cfset operationalvalue = 1>
					</cfif>
								
					<cfquery name="Check" 
					   datasource="#ds#" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
							SELECT *
							FROM   #table#_language
							WHERE  #Key1# = '#Attributes.Key1Value#'
							<cfif key2 neq "">
							AND    #Key2# = '#Attributes.Key2Value#'
							</cfif>
							<cfif Key3 neq "">
							AND    #Key3# = '#Attributes.Key3Value#'
							</cfif>
							<cfif Key4 neq "">
							AND    #Key4# = '#Attributes.Key4Value#'
							</cfif>
							AND    LanguageCode = '#Code#' 
					</cfquery>
																				
					<cfif Check.recordcount eq "0">
				
					 <cfquery name="InsertLanguage" 
						datasource="#ds#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO #table#_language
							 (#Key1#,	
							  <cfif Key2 neq "">#Key2#,</cfif>  
							  <cfif Key3 neq "">#Key3#,</cfif>  
							  <cfif Key4 neq "">#Key4#,</cfif>  
							  LanguageCode,
							  <cfif Attributes.ShowLanguageOperational eq 1>Operational,</cfif>
							  #field#,
							  OfficerUserId)
						  VALUES (
						          '#Attributes.Key1Value#',	
								  <cfif Key2 neq "">'#Attributes.Key2Value#',</cfif>
								  <cfif Key3 neq "">'#Attributes.Key3Value#',</cfif>
								  <cfif Key4 neq "">'#Attributes.Key4Value#',</cfif>
						       	  '#Code#',
								  <cfif Attributes.ShowLanguageOperational eq 1>#operationalvalue#,</cfif>
								  N'#TextValue#',   
								  '#SESSION.acc#'
								  )
						</cfquery>
				
				    <cfelse>
					
					   <cfquery name="Update" 
						datasource="#DS#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">						
							UPDATE #table#_language
							SET    #field#       = N'#textValue#',
							       OfficerUserId = '#SESSION.acc#',
								   <cfif Attributes.ShowLanguageOperational eq 1>Operational = #operationalvalue#,</cfif>
								   Created       = getDate()
							WHERE  #Key1#        = '#Attributes.Key1Value#' 
							<cfif Key2 neq "">
							AND    #Key2#        = '#Attributes.Key2Value#'
							</cfif>
							<cfif Key3 neq "">
							AND    #Key3#        = '#Attributes.Key3Value#'
							</cfif>
							<cfif Key4 neq "">
							AND    #Key4#        = '#Attributes.Key4Value#'
							</cfif>
							AND    LanguageCode  = '#Code#'
						</cfquery>

				    </cfif>
					
					<!--- sync table with source --->					
					
						<cfquery name="Check" 
						 datasource="#ds#" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">						 
							INSERT INTO #table#_language
							         (#Key1#,	
									  <cfif table neq "Ref_ModuleControl">
										  <cfif Key2 neq "">#Key2#,</cfif>  
										  <cfif Key3 neq "">#Key3#,</cfif>  
										  <cfif Key4 neq "">#Key4#,</cfif>  	
									  </cfif>							 
									  LanguageCode,
									  <cfif Attributes.ShowLanguageOperational eq 1>Operational,</cfif>
									  OfficerUserId)
		    				SELECT    S.#Key1#, 
							          <cfif table neq "Ref_ModuleControl">
								          <cfif Key2 neq "">S.#Key2#,</cfif> 
										  <cfif Key3 neq "">S.#Key3#,</cfif>
										  <cfif Key4 neq "">S.#Key4#,</cfif>  
									  </cfif>
							          '#Code#',			
									  <cfif Attributes.ShowLanguageOperational eq 1>ISNULL(L.Operational,1),</cfif>					  
									  'SyncTool'
									  
							FROM         #table# S  LEFT OUTER JOIN
	                                     #table#_language L 
										 ON  S.#Key1# = L.#Key1# 
										 <cfif table neq "Ref_ModuleControl">
											 <cfif key2 neq "">	 AND  S.#Key2# = L.#Key2#  </cfif>
											 <cfif key3 neq "">	 AND  S.#Key3# = L.#Key3#  </cfif>
											 <cfif key4 neq "">	 AND  S.#Key4# = L.#Key4#  </cfif>
										 <cfelse>
										 AND L.Mission = ''	 
										 </cfif>	 
										 AND  LanguageCode = '#Code#'
										 
										 
							GROUP BY  S.#Key1#, 
							          <cfif table neq "Ref_ModuleControl">
								          <cfif Key2 neq "">S.#Key2#,</cfif> 
										  <cfif Key3 neq "">S.#Key3#,</cfif>
										  <cfif Key4 neq "">S.#Key4#,</cfif>  
									  </cfif> 
									  LanguageCode
									  <cfif Attributes.ShowLanguageOperational eq 1>,L.Operational</cfif>
							HAVING    (LanguageCode IS NULL)
						</cfquery>								
					
					</cfoutput>
				
				</cfloop>				
							
		   </cfif>	
		   
	</cfif>		   