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
<cfoutput>

		<cfswitch expression="#TopicLabel#">
		
		<cfcase value="IndexNo">
	  	
	    <TR>
		<td class="labelmedium" height="20">#row#.</td>
	    <TD class="labelmedium" align="left">#client.IndexNoName#:</TD>
	    <TD align="left" class="labelmedium">
		
			<cfif url.mode eq "edit" or url.mode eq "create" or url.mode eq "php">
			
		     <input type="text"
		       name="indexno"
		       value="#get.IndexNo#"
		       size="8"
			   onchange="#locmatch#"
		       maxlength="8"			  
		       class="regularxl enterastab"
		       style="text-align: center;">				
			   
			  <cfelse>
			  
			      #get.IndexNo#
				  
			  </cfif> 
		</TD>
		</TR>	
		
		</cfcase>

		<cfcase value="LastName">	
										
		    <!--- Field: Applicant.LastName --->
		    <TR>
			<td class="labelmedium" height="20">#row#.</td>
		    <TD class="labelmedium" align="left"><cf_tl id="LastName">  : <font color="FF0000">&nbsp;*&nbsp;</font></TD>
		    <TD class="labelmedium" align="left">			
			   <cf_tl class="Message" id="LastName:Entry" var="1">
			   
			   <cfif url.mode neq "view">
			
				<cfinput type="Text"
			       name="LastName"
			       value="#Get.LastName#"
			       message="#lt_text#"
				   onchange="#locmatch#"
			       required="Yes"
			       visible="Yes"
			       enabled="Yes"
			       size="40"
			       maxlength="40"
			       class="regularxl enterastab">
				   
				<cfelse>
				
				   #get.lastname#
				
				</cfif>   
				
			</TD>
			</TR>

		</cfcase>
		
		<cfcase value="LastName2">
		
		    <!--- Field: Applicant.LastName --->
		    <TR>
			<td class="labelmedium" height="20">#row#.</td>	
		    <TD class="labelmedium" align="left"><cf_tl id="LastName2"> :</TD>
		    <TD class="labelmedium" align="left">		
			   
			   <cfif url.mode neq "view">
			   	
				<cfinput type="Text"
			       name="LastName2"
			       value="#Get.LastName2#"
			       required="No"
			       visible="Yes"
			       enabled="Yes"
			       size="40"
			       maxlength="40"
			       class="regularxl enterastab">
				   
				<cfelse>
				
				   #get.lastname2#
				
				</cfif>      
				
			</TD>
			</TR>
			
		</cfcase>
		
		<cfcase value="MaidenName">
		
		    <!--- Field: Applicant.LastName --->
		    <TR>
			<td class="labelmedium" height="20">#row#.</td>
		    <TD class="labelmedium"><cf_tl id="MaidenName"> :</TD>
		    <TD class="labelmedium">	
			
			    <cfif url.mode neq "view">
						
				<cfinput type="Text"
			       name="MaidenName"
			       value="#Get.MaidenName#"
			       required="No"
			       visible="Yes"
			       enabled="Yes"
			       size="40"
			       maxlength="40"
			       class="regularxl enterastab">
				   
				  <cfelse>
				
				   #get.MaidenName#
				
				</cfif>    
				
			</TD>
			</TR>
			
		</cfcase>

		<cfcase value="FirstName">
			
		    <TR>
			<td class="labelmedium" height="20">#row#.</td>
		    <TD class="labelmedium" align="left"><cf_tl id="FirstName"> : <font color="FF0000">&nbsp;*&nbsp;</font></TD>
		    <TD align="left" class="labelmedium">
						
			   <cf_tl class="Message" id="FirstName:Entry" var="1">
			   
			    <cfif url.mode neq "view">
			
				<cfinput type="Text"
			       name="FirstName"
			       value="#Get.FirstName#"
				   onchange="#locmatch#"
			       message="#lt_text#"
			       required="Yes"
			       visible="Yes"
			       enabled="Yes"
			       size="30"
			       maxlength="30"
			       class="regularxl enterastab">
				   
				   <cfelse>
				
				   #get.FirstName#
				
				</cfif>     
				
			</TD>
			</TR>
			
		</cfcase>
		
		<cfcase value="MiddleName">
											
		    <!--- Field: Applicant.MiddleName --->
		    <TR>
			<td class="labelmedium" height="20">#row#.</td>	
		    <TD class="labelmedium" align="left"><cf_tl id="FirstName2"> :</TD>
		    <TD class="labelmedium" align="left">		
			
			     <cfif url.mode neq "view">
				 
				<INPUT type="text" class="regularxl enterastab" name="MiddleName" value="#Get.MiddleName#" maxLength="20" size="20">	
				
				<cfelse>
				
				#Get.MiddleName#
				
				</cfif>		
			</TD>
			</TR>
			
		</cfcase>
		
		<cfcase value="MiddleName2">
														
		    <TR>
			<td class="labelmedium" height="20">#row#.</td>	
		    <TD class="labelmedium" align="left"><cf_tl id="FirstName3"> :</TD>
		    <TD class="labelmedium" align="left">
						
			    <cfif url.mode neq "view">
			
				<cfinput type="Text"
			       name="MiddleName2"
			       value="#Get.MiddleName2#"
			       required="No"
			       visible="Yes"
			       enabled="Yes"
			       size="20"
			       maxlength="20"
			       class="regularxl enterastab">
				   
				 <cfelse>
				 
				 #Get.MiddleName2#
				 
				 </cfif>  
				
			</TD>		
			</TR>
			
		</cfcase>

		<cfcase value="Gender">
		
		    <!--- Field: Applicant.Gender --->
		    <TR>
			<td class="labelmedium" height="20">#row#.</td>	
		    <TD class="labelmedium" align="left"><cf_tl id="Gender"> : <font color="FF0000">&nbsp;*&nbsp;</font></TD>
		    <TD class="labelmedium" style="height:30px">
			
			    <cfif url.mode neq "view">
						
		    		<INPUT type="radio" class="radiol enterastab" name="Gender" value="M" <cfif Get.Gender IS "M" or Get.Gender is "">checked</cfif>> <cf_tl id="Male">
			    	<INPUT type="radio" class="radiol enterastab" name="Gender" value="F" <cfif Get.Gender IS "F">checked</cfif>> <cf_tl id="Female"> 					
					<INPUT type="radio" class="radiol enterastab" name="Gender" value="U" <cfif Get.Gender IS "U">checked</cfif>> <cf_tl id="Undefined"> 
												
				<cfelse>
				
					<cfif get.gender eq "M">
					   <cf_tl id="Male">
					<cfelseif get.gender eq "U">
					   <cf_tl id="Undefined">   
					<cfelse>
					   <cf_tl id="Female">  
					</cfif>
				
				</cfif>
				
			</TD>
			</TR>
			
		</cfcase>
		
		<cfcase value="DOB">
							
		    <!--- Field: Applicant.DOB --->
		    <TR class="labelmedium" >
			<td height="20">#row#.</td>	
		    <TD align="left" class="labelmedium"><cf_tl id="DOB"> :</TD>
		    <TD align="left" style="z-index:20; position:relative;padding:0px" class="labelmedium">	
			
			<cfif url.mode neq "view">	
			
					<cf_intelliCalendarDate8
						FieldName="DOB" 
						Default="#DateFormat(Get.DOB, CLIENT.DateFormatShow)#"
						AllowBlank="True"											
						class="regularxl enterastab">					
									
			<cfelse>
			
				#DateFormat(Get.DOB, CLIENT.DateFormatShow)#
			
			</cfif>		
			
			</TD>
			</TR>	
					
		</cfcase>
		
		<cfcase value="BirthCity">
								
		    <!--- Field: Applicant.MiddleName --->
		    <TR class="labelmedium" >
			<td height="20">#row#.</td>	
		    <TD><cf_tl id="BirthCity">:</TD>
		    <TD>
			
				<cfif url.mode neq "view">	
			
				<INPUT type="text" class="regularxl enterastab" name="BirthCity" value="#Get.BirthCity#" maxLength="50" size="50">
				
				<cfelse>
				
				#Get.BirthCity#
				
				</cfif>
				
			</TD>
			</TR>
		
		</cfcase>
		
		<cfcase value="Nationality">		
								
		    <!--- Field: Applicant.Nationality --->
		    <TR class="labelmedium" >
			<td>#row#.</td>	
		    <TD><cf_tl id="Nationality"> : <font color="FF0000">&nbsp;*&nbsp;</font></TD>
		    <TD>
			
				<cfif url.mode neq "view">	
			
			    	<cfselect name="Nationality" required="No" class="regularxl enterastab">
					<cfset nat = Get.Nationality>
					<cfif nat eq "">
					
						<cfquery name="PHPParameter" datasource="AppsSelection" username="#SESSION.login#" password="#SESSION.dbpw#">
							SELECT TOP 1 *
							FROM   Parameter
						</cfquery>
					
						<cfset nat= PHPParameter.PHPNationality>
					</cfif>
					
				    <cfloop query="Nation">
			        		 <option value="#Code#" <cfif Code IS nat>selected</cfif>>#Name#</option>
					</cfloop> 
				    </cfselect>	
				
				<cfelse>
				
				#get.Nationality#
				
				</cfif>
				
		    </TD>
			</TR>
			
		</cfcase>
		
		<cfcase value="MaritalStatus">
		
			<cfif URL.Mode neq "Create">
								
				<TR>
				<td class="labelmedium" height="20">#row#.</td>	
				<TD class="labelmedium" align="left"><cf_tl id="Marital Status"> :</TD>
				<TD align="left" class="labelmedium">
				
					<cfif url.mode neq "view">	
			
						<cfquery name = "qMarital" datasource = "AppsSelection">
							SELECT * FROM Ref_MaritalStatus
						</cfquery>

				  	 	<select name="MaritalStatus" required="No" class="regularxl enterastab">
						<cfset ms = Get.MaritalStatus>
						<option>
					    <cfloop query="qMarital">
				        		 <option value="#Code#" <cfif Code IS ms>selected</cfif>>#Description#</option>
						</cfloop> 
					    </select>	
					
					<cfelse>
					
						 #get.MaritalStatus#
					
					</cfif>
					
				</TD>
				</TR>
			
			</cfif>
			
		</cfcase>		
		
		<cfcase value="NationalityAdditional">
		
			<cfif URL.Mode neq "Create">
								
				<TR>
				<td class="labelmedium" height="20">#row#.</td>	
				<TD align="left" class="labelmedium"><cf_tl id="Nationality2"> :</TD>
				<TD align="left" class="labelmedium">
				
					<cfif url.mode neq "view">	
			
				  	 	<select name="NationalityAdditional" required="No" class="regularxl enterastab">
						<cfset nat = Get.NationalityAdditional>
						<option>
					    <cfloop query="Nation">
				        		 <option value="#Code#" <cfif Code IS nat>selected</cfif>>#Name#</option>
						</cfloop> 
					    </select>	
					
					<cfelse>
					
						 #get.nationalityAdditional#
					
					</cfif>
					
				</TD>
				</TR>
			
			</cfif>
			
		</cfcase>
		
		<cfcase value="eMailAddress">
								
		     <input type="hidden" name="SubmissionEdition" value="Generic" class="hidden">
			
		    <!--- Field: Applicant.EmailAddress --->
		    <TR>
			<td class="labelmedium" height="20">#row#.</td>	
		    <TD align="left" class="labelmedium"><cf_tl id="eMailAddress"> :</TD>
		    <TD align="left" class="labelmedium">
			
			   <cf_tl class="Message" id="eMail:Entry" var="1">
			   
			   <cfif url.mode neq "view">	
			   			   
					<cfinput type="Text"
				       name="emailaddress"
				       value="#Get.EmailAddress#"
				       message="#lt_text#"
				       validate="email"
				       required="no"
				       visible="Yes"
				       enabled="Yes"
				       size="40"
				       maxlength="50"
				       class="regularxl enterastab">
				   
				<cfelse>
				
				   #get.eMailAddress#			
				
				</cfif>   
			   
			</TD>
			</TR>
		
		</cfcase>
		
		<cfcase value="Remarks">		
			 <input type="hidden" name="Remarks" value="#Get.Remarks#">				
			 <TR><td height="1" colspan="3"></td></tr>				
		</cfcase>
		
		</cfswitch>
		
</cfoutput>	   
	   