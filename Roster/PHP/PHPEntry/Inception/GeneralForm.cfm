
<cfparam name="row"       default="0">
<cfparam name="url.scope" default="applicant">
<cfparam name="url.mode"  default="php">

<!--- used for case file match script --->

<cfif url.scope neq "casefile">
	<cfparam name="locmatch" default="">
</cfif>	

<cfif get.recordcount eq "0">

    <cftry>	  
	
		<cfset frm = session.myForm>
							
		<cfif url.entrymode eq "extended">				
			<cfif IsDefined("frm.lastname2")> 		   				
		     	<cfset get = session.myform>
		    </cfif>
		<cfelse>
			 <cfif IsDefined("frm.lastname")> 	
		     	<cfset get = session.myform>
		    </cfif>		
		</cfif>		
					  
	    <cfset mydob = get.dob>	
	     	
	<cfcatch>
		
	    <cfset mydob = get.dob>	
		
	</cfcatch>
	
	</cftry>
	
<cfelse>

	<cfset mydob = dateformat(get.dob,client.dateformatshow)>
	
</cfif>

<table border="0" class="formpadding">

<cfoutput>
					
		<cfset row=row+1>		
		
		<!--- 13/10 in the initial request of an account we no longer ask for the picture, this is reserved for the portal --->
		
		<tr>
				
		<cfif url.action neq "create">
				
			<td valign="top" rowspan="30" align="left" style="padding-top:5px;width:240px;padding-right:10px">
				<table>
					<tr>
						<td style="width:140px;height:170px;border:1px solid C0C0C0;">
						
						    <cfif get.PersonNo eq "">
						
							 <cfquery name="AssignNo" 
							     datasource="AppsSelection">
							     	UPDATE Parameter 
									SET    PersonNo    = PersonNo+1
								</cfquery>
							
							    <cfquery name="LastNo" 
							     datasource="AppsSelection">
							     SELECT *
							     FROM Parameter
								</cfquery>
								
								<cf_tl id="Picture" var="1">
																													
								<cf_userProfilePicture 
										acc         = "Picture_#LastNo.personNo#" 
										height      = "170px" 
										width       = "145px" 
										title       = "#lt_text#" 
										destination = "Applicant/#LastNo.personNo#" 
										module      = "applicant">
										
								<input type="hidden" name="PersonNo" value="#LastNo.personNo#">	
								
							<cfelse>	
						
								<cf_tl id="Change my picture" var="1">
								<cf_userProfilePicture 
										acc         = "Picture_#get.personNo#" 
										height      = "170px" 
										width       = "145px" 
										title       = "#lt_text#" 
										destination = "Applicant/#get.personNo#" 
										module      = "applicant">
										
							</cfif>			
						</td>
					</tr>
					
					<tr><td align="center" valign="middle" class="labelmedium" style="color:808080; height:30px; border:1px solid C0C0C0;"><cf_tl id="My Picture"></td></tr>
				</table>
			</td>
			
		<cfelse>
		
			<input type="hidden" name="PersonNo" value="">		
		
		</cfif>			
		
		</TR>	
		
		<!---  --->
		
		<cfquery name="qSalutation" 
				datasource="appsSelection">
					SELECT   *
					FROM Ref_Salutation
		</cfquery>		
		
		<cfif qSalutation.recordcount eq "0">
		
		    <!--- NA --->
					
		<cfelse>
		
		    <TR id="personfield" name="personfield">			
		    <TD class="labelmedium" style="min-width:160px;width:23%" align="left"><cf_tl id="Salutation">  : <cfif get.CandidateStatus neq "1"><font color="FF0000">&nbsp;*&nbsp;</font></cfif></TD>
		    <TD class="labelmedium" style="width:50%"  align="left">	
							
					<select name="salutation" id="salutation" class="regularxl">
					    <option value=""></option>
						<cfloop query="qSalutation">
							<option value="#Code#" <cfif Code eq get.salutation>selected</cfif>>#qSalutation.Description#</option>
						</cfloop>
					</select>				
				
			</TD>
			</TR>
												
			<cfset row=row+1>	
		
		</cfif>
					
	    <!--- Field: Applicant.LastName --->
	    <TR id="personfield" name="personfield">		
	    <TD class="labelmedium" style="min-width:160px;width:23%" align="left"><cf_tl id="LastName">  : <cfif get.CandidateStatus neq "1"><font color="FF0000">&nbsp;*&nbsp;</font></cfif></TD>
	    <TD class="labelmedium" align="left" style="height:27px">	
				
		   <cf_tl class="Message" id="LastName:Entry" var="1">
		   
		   <cfif url.mode neq "view" and get.CandidateStatus neq "1">		   	   
		
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
			       onError="show_error"
			       class="regularxl enterastab">
			   
			<cfelse>
			
			   #get.lastname#
			
			</cfif>   
			
		</TD>
		</TR>
				
		<cfif url.entrymode eq "Extended">
							
		    <!--- Field: Applicant.LastName --->
		    <TR id="personfield" name="personfield">			
		    <TD class="labelmedium" align="left"><cf_tl id="LastName2"> :</TD>
		    <TD align="left">		
			   
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
		
		</cfif>
		
		<cfset row=row+1>	
						
	    <!--- Field: Applicant.LastName --->
	    <TR id="personfield" name="personfield">		
	    <TD class="labelmedium"><cf_tl id="MaidenName"> :</TD>
	    <TD>	
		
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
				
		<cfset row=row+1>	
							
	    <!--- Field: Applicant.FirstName --->
	    <TR id="personfield" name="personfield">
		<TD class="labelmedium" align="left"><cf_tl id="FirstName"> : <font color="FF0000"><cfif get.CandidateStatus neq "1">&nbsp;*&nbsp;</cfif></font></TD>
	    <TD class="labelmedium" align="left" style="height:27px">
					
		   <cf_tl class="Message" id="FirstName:Entry" var="1">
		   
		    <cfif url.mode neq "view" and get.CandidateStatus neq "1">
		
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
			       onError="show_error"
			       class="regularxl enterastab">
			   
			   <cfelse>
			
			   #get.FirstName#
			
			</cfif>     
			
		</TD>
		</TR>
		
		<cfif url.entrymode eq "Extended">
								
		    <!--- Field: Applicant.MiddleName --->
		    <TR id="personfield" name="personfield">			
		    <TD class="labelmedium" align="left"><cf_tl id="FirstName2"> :</TD>
		    <TD align="left">		
			
			    <cfif url.mode neq "view">				 
					<INPUT type="text" class="regularxl enterastab" name="MiddleName" value="#Get.MiddleName#" maxLength="20" size="20">					
				<cfelse>				
					#Get.MiddleName#				
				</cfif>		
				
			</TD>
			</TR>		
			
			<cfset row=row+1>	
												
		    <TR id="personfield" name="personfield">			
		    <TD class="labelmedium" align="left"><cf_tl id="FirstName3"> :</TD>
		    <TD align="left">
			
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
		
		</cfif>
		
		<cfset row=row+1>					
	  
	    <TR id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left">
	    	<cf_tl id="#client.IndexNoName#">:
    	</TD>
	    <TD align="left" width="60%">
		
			<cfif url.mode eq "edit" or url.action eq "create" or url.mode eq "php">
			
				     <input type="text"
				       name="indexno"
				       value="#get.IndexNo#"
				       size="20"
					   onchange="#locmatch#"
				       maxlength="20"
					   <cfif get.candidateStatus eq "1">readonly</cfif>
				       class="regularxl enterastab">				
			   
			  <cfelse>
			  
			      #get.IndexNo#
				  
			  </cfif> 
		</TD>
		</tr>
		
		<cfset row=row+1>					
	  
	    <TR id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left">
	    	<cf_tl id="Reference">:
    	</TD>
	    <TD align="left" width="60%">
		
			<cfif url.mode eq "edit" or url.action eq "create" or url.mode eq "php">
			
				     <input type="text"
				       name="reference"
				       value="#get.Reference#"
				       size="20"
					   onchange="#locmatch#"
				       maxlength="20"					   
				       class="regularxl enterastab">				
			   
			  <cfelse>
			  
			      #get.Reference#
				  
			  </cfif> 
		</TD>
		</tr>
						
		<cfset row=row+1>	
				
	    <!--- Field: Applicant.Gender --->
	    <TR id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left"><cf_tl id="Gender"> : <cfif get.CandidateStatus neq "1"><font color="FF0000">&nbsp;*&nbsp;</font></cfif></TD>
	    <TD align="left" class="labelmedium" style="height:27px">
		
		    <cfif url.mode neq "view" and get.CandidateStatus neq "1">
			
				<table>
				<tr class="labelmedium" style="height:26px">
				<td><INPUT type="radio" name="Gender" class="enterastab radiol" value="M" <cfif Get.Gender IS "M" or Get.Gender is "">checked</cfif>> 
				</td><td style="padding-left:3px"><cf_tl id="Male"></td>
		    	<td style="padding-left:10px"><INPUT type="radio" name="Gender" class="enterastab radiol" value="F" <cfif Get.Gender IS "F">checked</cfif>> 
				</td><td style="padding-left:3px"><cf_tl id="Female"></td>
				<cfif url.scope eq "casefile">
				<td style="padding-left:10px">
				<INPUT type="radio" name="Gender" class="enterastab radiol" value="U" <cfif Get.Gender IS "U">checked</cfif>>
				</td><td style="padding-left:3px"><cf_tl id="Undefined"></td>				
				</cfif>				
				</tr>
				</table>
						
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
		
		<cfif entrymode eq "Extended">
		
			<cfset row=row+1>	
						
		    <!--- Field: Applicant.MiddleName --->
		    <tr id="personfield" name="personfield">			
		    <td class="labelmedium" align="left"><cf_tl id="BirthCity">:</TD>
		    <td align="left" style="height:27px">
			
				<cfif url.mode neq "view">			
					<INPUT type="text" class="regularxl enterastab" name="BirthCity" value="#Get.BirthCity#" maxLength="50" size="40">			
				<cfelse>			
					#Get.BirthCity#			
				</cfif>
				
			</td>
			</tr>
		
		</cfif>			
		
		<cfset row=row+1>	
				
	    <!--- Field: Applicant.DOB --->
	    <TR id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left"><cf_tl id="DOB"> : <cfif url.scope neq 'casefile'><cfif get.CandidateStatus neq "1"><font color="FF0000">&nbsp;*&nbsp;</font></cfif></cfif></TD>
	    <TD align="left" class="labelmedium" style="z-index:20; position:relative;padding:0px">	
		
		<cf_calendarscript>
		
		<cfif url.mode neq "view" and get.CandidateStatus neq "1">	
		
			<cfif url.scope eq "casefile">
		
				<cf_intelliCalendarDate9
					FieldName="DOB" 
					Default="#mydob#"
					AllowBlank="True"		
					DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"			
					class="regularxl enterastab">	
					
			<cfelse>
			
				<cf_intelliCalendarDate9
					FieldName="DOB" 
					Default="#mydob#"
					AllowBlank="False"
					onError="show_error"	
					DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"				
					class="regularxl enterastab">				
			
			</cfif>		
				
		<cfelse>
		
			#DateFormat(Get.DOB, CLIENT.DateFormatShow)#
		
		</cfif>		
		
		</TD>
		</TR>
		
		<tr><td style="height:2px"></td></tr>
		
		<!--- Field: Applicant.MaritalStatus --->
	    <TR id="personfield" name="personfield">		
	    <TD class="labelmedium"><cf_tl id="Marital Status">:<font color="FF0000">&nbsp;*</font></TD>
	    <TD>
			<cfoutput>
			<cfquery name = "qMarital" datasource = "AppsSelection">
				SELECT    * 
				FROM      Ref_MaritalStatus
				ORDER BY  Code DESC
			</cfquery>

	  	 	<cfselect name="MaritalStatus" id="maritalstatus" required="Yes" class="regularxl enterastab">
			<option value=""><cf_tl id="Select"></option>
		    <cfloop query="qMarital">
	        	 <option value="#Code#" <cfif Code IS get.MaritalStatus>selected</cfif>><cf_tl id="#Description#"></option>
			</cfloop> 
		    </cfselect>	
			
			</cfoutput>
		</TD>
		</TR>		
						
		<cfset row=row+1>	
				
	    <!--- Field: Applicant.Nationality --->
	    <tr id="personfield" name="personfield">		
	    <td class="labelmedium" align="left"><cf_tl id="Nationality"> : <cfif get.CandidateStatus neq "1"><font color="FF0000">&nbsp;*&nbsp;</font></cfif></TD>
	    <td align="left" class="labelmedium" style="height:27px">
		
		
			<cfif url.mode neq "view" and get.CandidateStatus neq "1">
								
	    	<cfselect name="Nationality" style="width:268px" required="No" class="regularxl enterastab">
				
				<cfset nat = Get.Nationality>
				<cfif nat eq "">
					<cfset nat= PHPParameter.PHPNationality>
				</cfif>
			
			    <cfloop query="Nation">
		        		 <option value="#Code#" <cfif Code IS nat>selected</cfif>>#Name#</option>
				</cfloop> 
				
		    </cfselect>	
						
			<cfelse>
			
			#get.Nationality#
			
			</cfif>
			
	    </td>
		
		<cfif URL.action neq "Create">
		
			<cfset row=row+1>	
			
			<tr id="personfield" name="personfield">			
			<td class="labelmedium" align="left"><cf_tl id="Nationality2"> :</TD>
			<td align="left" class="labelmedium">
			
				<cfif url.mode neq "view">	
		
		  	 	<select name="NationalityAdditional" class="regularxl enterastab">
				<cfset nat = Get.NationalityAdditional>
				<option value="">n/a</option>
			    <cfloop query="Nation">
		        		 <option value="#Code#" <cfif Code IS nat>selected</cfif>>#Name#</option>
				</cfloop> 
			    </select>	
				
				<cfelse>
				
				 #get.nationalityAdditional#
				
				</cfif>
				
			</td>
			</tr>
		
		</cfif>		
				
		<cfset row=row+1>	
				
	    <input type="hidden" name="SubmissionEdition" value="Generic" class="hidden">
		
	    <!--- Field: Applicant.EmailAddress --->
		
		<!--- validate if email address should be mandatory or not --->
		
		<cfset req = "Yes"> 
		
		<cfquery name="GetSource" datasource="AppsSelection">
			SELECT PHPMode
			FROM   Ref_Source
			WHERE  Source = '#Get.SubmissionSource#'
		</cfquery>
		
		 <cfif url.mode neq "view">	
		   
		   	<cfif url.scope eq "casefile">
			
			  <cfset req = "No">
			  
			<cfelse>

			  <cfif GetSource.recordcount gt 0>
					<!--- if php mode is set to basic, then we make email not mandatory --->
					<cfif GetSource.PHPMode eq "Basic">
						<cfset req="No">
					</cfif>
				
			  </cfif>
			  
			</cfif>
			
		</cfif>		
		
	    <TR id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left"><cf_tl id="e-mail Address"> : <cfif req eq "Yes"><cfif get.CandidateStatus neq "1"><font color="FF0000">&nbsp;*&nbsp;</font></cfif></cfif></TD>
	    <TD align="left" class="labelmedium">
									
		   <cf_tl class="Message" id="eMail:Entry" var="1">
		   
		   <cfif url.mode neq "view">	
		  		   
				<cfinput type="Text"
			       name="emailaddress"
			       value="#Get.EmailAddress#"
			       message="#lt_text#"
			       validate="email"
			       required="#req#"
			       visible="Yes"
			       enabled="Yes"
			       size="40"
			       maxlength="50"
			       onError="show_error"
			       class="regularxl enterastab">
			   
			<cfelse>
			
			   #get.eMailAddress#			
			
			</cfif>   
		   
		</TD>
		</TR>
		
		<TR id="personfield" name="personfield">		
	    <TD class="labelmedium" align="left"><cf_tl id="Mobile Number"> : <cfif req eq "Yes"><cfif get.CandidateStatus neq "1"><font color="FF0000">&nbsp;*&nbsp;</font></cfif></cfif></TD>
	    <TD align="left" class="labelmedium">
									
		   <cf_tl class="Message" id="Phone:Entry" var="1">
		   
		   <cfif url.mode neq "view">	
		  		   
				<cfinput type="Text"
			       name="MobileNumber"
			       value="#Get.MobileNumber#"
			       message="#lt_text#"			       
			       required="#req#"
			       visible="Yes"
			       enabled="Yes"
			       size="40"
			       maxlength="50"
			       onError="show_error"
			       class="regularxl enterastab">
			   
			<cfelse>
			
			   #get.MobileNumber#			
			
			</cfif>   
		   
		</TD>
		</TR>
				
		<!--- include initial topics --->
								
		<cfquery name="Master" 
		datasource="AppsSelection">
		     SELECT *
			 FROM (
		 	  SELECT   C.ListingOrder as ClassOrder,
			           C.Description as ClassDescription,
					   C.Tooltip as ClassTooltip,
					   C.ListingMode,
					   (
					   SELECT ListCode
					   FROM   ApplicantSubmissionTopic
					   WHERE  ApplicantNo = '#url.ApplicantNo#'
					   AND    Topic       = R.Topic ) as ListCode,
					   
					   R.*
			  FROM     #CLIENT.LanPrefix#Ref_Topic R LEFT OUTER JOIN #CLIENT.LanPrefix#Ref_TopicClass C ON R.TopicClass = C.TopicClass				  
			  
			  WHERE    R.Operational = 1			  
			  
			  <!--- passed from the section tab --->
			  AND      R.Parent   = 'Miscellaneous'  
			  
			  <cfif url.scope eq "applicant" or url.scope eq "Backoffice">					
				  AND      R.Source   = 'Portal'		<!--- = Portal --->			  
			  <cfelse>
			  	  AND      1=0	  
			  </cfif>
			  
			  <!--- topic is enabled for this owner --->
			  AND      R.Topic IN (SELECT Topic FROM Ref_TopicOwner WHERE Owner = '#url.owner#')
			  			  			 		  			 												  				  
			  ) as T
			  
			  ORDER BY T.ClassOrder, T.ListingOrder, T.Description
		</cfquery>		
					
		<cfloop query="Master">
									   
			 <cfset row=row+1>							  									  	 						  	 
			 
			  <tr> 					 								
								  
				  <cfif valueClass eq "List">	
														  	
					  <!--- show help and show right inspection											  
					  											  
					  <cfif len(Tooltip) gte "4">
					  <td valign="top" style="padding-top:6px;padding-right:4px" onclick="showtopic('#topic#','#listcode#');"><img src="#session.root#/Images/help1.png" alt="" width="16" height="16" border="0"></td>  											 										  
					  <cfelse>
					  <td></td>
					  </cfif>
					   --->	
					  														  				  
					  <td width="50%"
					    class="labelit" 
						onclick="showtopiccode('#topic#','#listcode#',document.getElementById('Value_#topic#_selected').value)"
					    style="font-size:15px;padding-top:2px;height:14px" align="left">#Question# <cfif ValueObligatory eq "1"><font color="D90000">*</font></cfif>
					  </td>				
					  
				  <cfelse>										  
				  					
					 <!--- show help and show right inspection	
														  
				      <cfif len(Tooltip) gte "4">
				  	  <td align="right" style="padding-top:6px;padding-right:4px" onclick="showtopic('#topic#','#listcode#');"><img src="#session.root#/Images/help1.png" alt="" width="16" height="16" border="0"></td>  											 	
					  <cfelse>
					  <td></td>
					  </cfif>
					  
					  --->
				  
					  <td class="labelit ccontent navigation_action" 
					    style="font-size:15px;padding-top:2px;height:14px" align="left">#Question# <cfif ValueObligatory eq "1"><font color="D90000">*</font></cfif>
					  </td>										  
					  										  
				  </cfif>		
				  	  
				  <td style="width:600px;padding-left:0px;padding-right:5px">
				  										  										  										
					   <cf_TopicEntry 
					       Mode="#url.mode#"									   
					       ApplicantNo="#URL.ApplicantNo#" 
						   Attachment="#Attachment#"
						   Tooltip="1"												   
				           Topic="#Topic#">
				
				  </td>
				 
			  </tr>
									  
			  <cfif QuestionCondition neq "">
				  
				  <tr>
					  <td></td>
					  <td class="labelmedium" colspan="4"><b>Note:&nbsp;</b>#QuestionCondition#</i></td>
				  </tr>
				  
			  </cfif>
														  		  
		</cfloop>		  		
				
		<cfif entrymode eq "Extended" and get.CandidateStatus neq "1">	     						
			
				 <cfset row=row+1>	
			
				 <TR id="personfield" name="personfield">					 <
				     <td valign="top" style="padding-top:4px" class="labelmedium" align="left"><cf_tl id="More information"> :</td>
				     <TD colspan="2" class="labelmedium" align="left">	 
					 <cfif url.mode neq "view">	
					 <textarea rows="2" name="Remarks" class="regular" style="width:100%;font-size:13px;padding:3px;scrollbar-track-color: silver;">#Get.Remarks#</textarea>
					 <cfelse>
					 #Get.Remarks#
					 </cfif>
				    </TD>
				 </TR>
				 
		<cfelse>	
			
		 <input type="hidden" name="Remarks" value="#Get.Remarks#">
		 
		</cfif> 					
		
		<cfif entrymode eq "Extended" and url.action neq "Create">
				
		<cfset row=row+1>	
		<tr style="padding-top:6px;">			
			<td valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Attachments">:</td>
			<td>
						
				 <cf_filelibraryN
					DocumentPath="Submission"
					SubDirectory="#SubmissionId#" 			
					Insert="yes"
					Filter=""	
					Box="submission"
					showsize="no"
					Remove="yes">	
					
			</td>
		</tr>
		
		</cfif>
		
		<TR id="personfield" name="personfield"><td height="1" colspan="3"></td></tr>		
				   	   
</cfoutput>	 

</table>	  
