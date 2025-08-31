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
<cf_screentop html="No" jQuery="Yes" scroll="No">

<cf_calendarScript>

<cf_windowNotification marginTop="-15px">

<cf_param name="url.source"  default="" type="String"> 

<cfquery name="Source" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_Source 
		WHERE  Source = '#url.source#'
</cfquery>

<cf_param name="heading"            default="0"          type="String"> 
<cf_param name="url.section"		default=""           type="String">
<cf_param name="URL.entryScope"     default="Backoffice" type="String">
<cf_param name="URL.Mode"           default="1"          type="String"> 
<cf_param name="URL.Topic"          default=""           type="String">

<cf_ProfileAccess 
	Scope   = "#url.entryscope#"
	Source  = "#url.source#"
	Owner   = "#url.owner#"
	Section = "#url.section#">	
	
			
<cfif accessmode eq "READ" and url.id eq "">

	<table align="center">
	   <tr><td style="padding-top:10px" class="labelmedium" align="center"><font color="FF0000"><cf_tl id="You have no authorization to perform this action"></font></td></tr>
    </table>
	
	<cfabort>

</cfif>

<cfquery name="Person" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
	    FROM    Applicant
		WHERE   PersonNo = '#URL.ID1#'		
</cfquery>


<cfif url.id eq "">
	
	<cf_param name="url.applicantno"		 default="0" type="String">	
	<cf_param name="url.id1"		    	 default=""	 type="String">		
	<cf_param name="url.id2"		    	 default="Employment" type="String">		
	<cf_param name="URL.Source"           	 default="Manual" 	  type="String">
	<cf_param name="URL.Owner"            	 default="" 		  type="String">
	<cf_param name="Form.ExperienceType"  	 default="#URL.ID2#"  type="String">	
	
	<cfquery name="Background" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  TOP 1
		           F.ApplicantNo, 
		           ExperienceId, 
				   ExperienceCategory, 
				   ExperienceDescription, 
				   ExperienceStart, 
				   ExperienceEnd, 
				   SupervisorName,
				   StaffSupervised,
				   OrganizationName, 
				   OrganizationClass, 
				   OrganizationAddress, 
				   OrganizationZIP, 
				   OrganizationCity, 
				   OrganizationCountry, 
				   OrganizationTelephone, 
				   OrganizationEmail,
				   F.Created,
				   F.Updated,
				   SalaryCurrency, 
				   SalaryStart, SalaryEnd, S.Source
	    FROM     ApplicantBackGround F, ApplicantSubmission S
		WHERE    S.PersonNo = '#URL.ID1#'
		AND      F.ApplicantNo = S.ApplicantNo
		ORDER BY ExperienceStart DESC
	</cfquery>
		
<cfelse>

	<cfquery name="Background" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   F.ApplicantNo, 
		         ExperienceId, 
				 ExperienceCategory, 
				 ExperienceDescription, 
				 ExperienceStart, 
				 ExperienceEnd, 
				 SupervisorName,
				 StaffSupervised,
				 OrganizationName, 
				 OrganizationClass, 
				 OrganizationAddress, 
				 OrganizationZIP, 
				 OrganizationCity, 
				 OrganizationCountry, 
				 OrganizationTelephone, 
				 OrganizationEmail,
				 F.Created,
				 F.Updated,
				 SalaryCurrency, 
				 SalaryStart, 
				 SalaryEnd, 
				 S.PersonNo,
				 S.Source
	    FROM     ApplicantBackGround F, ApplicantSubmission S
		WHERE    F.ExperienceId = '#URL.ID#'
		AND      F.ApplicantNo = S.ApplicantNo
		ORDER BY ExperienceStart DESC
	</cfquery>
	
	<cf_param name="url.applicantno"	 default="#Background.ApplicantNo#"        type="String">	
	<cf_param name="url.id1"		     default="#Background.PersonNo#"           type="String">	
	<cf_param name="url.id2"		     default="#Background.ExperienceCategory#" type="String">			
	<cf_param name="URL.Source"          default="#Background.Source#"             type="String">	
	<cf_param name="URL.Owner"           default="SysAdmin"                        type="String">	
	<cf_param name="Form.ExperienceType" default="#url.id2#"                       type="String">	
	
</cfif>

<cfquery name="Nation" 
    datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT Code,Name 
	    FROM   Ref_Nation
		WHERE  Operational = '1'
		ORDER BY NAME
</cfquery>

<cfswitch expression="#URL.ID2#">

<cfcase value="University">
	
    <cfset Group   = "'Education'">
	<cf_tl id="Education record" var="1">
    <cfset Heading = " #lt_text#">
	<cf_tl id="Study" var="1">
	<cfset Field   = "#lt_text#">
	<cf_tl id="Field of study" var="1">
	<cfset FieldT  = "#lt_text#:">
	<cfset Level   = "Degree">
	<cf_tl id="Degree" var="1">
	<cfset LevelT  = "#lt_text#:">
	<cf_tl id="Region" var="1">
	<cfset Geo     = "#lt_text#">
	<cf_tl id="Special regional studies" var="1">
	<cfset GeoT    = "#lt_text#:">
	<cf_tl id="Study period" var="1">
	<cfset Per     = "#lt_text#:">
	<cf_tl id="Name Institue" var="1">
	<cfset Org     = "#lt_text#">
	
</cfcase>

<cfcase value="School">
	
    <cfset Group   = "'School'">
	<cf_tl id="School record" var="1">
    <cfset Heading = " #lt_text#">
	<cf_tl id="StudyField" var="1">
	<cfset Field   = "#lt_text#">
	<cf_tl id="Field of training/education" var="1">
	<cfset FieldT  = "#lt_text#:">
	<cf_tl id="Diploma" var="1">
	<cfset Level   = "Diploma">
	<cfset LevelT  = "#lt_text#:">
	<cf_tl id="Region" var="1">
	<cfset Geo     = "#lt_text#">
	<cf_tl id="Special regional studies" var="1">
	<cfset GeoT    = "#lt_text#:">
	<cf_tl id="Period" var="1">
	<cfset Per     = "#lt_text#:">
	<cf_tl id="School name" var="1">
	<cfset Org     = "#lt_text#">
	
</cfcase>
<cfcase value="Training">

	<cfset Group   = "'Training'">
	<cf_tl id="Training record" var="1">
    <cfset Heading = " #lt_text#">
	<cf_tl id="StudyField" var="1">
	<cfset Field   = "#lt_text#">
	<cf_tl id="Field of training/education:" var="1">
	<cfset FieldT  = "#lt_text#">
	<cf_tl id="Diploma" var="1">
	<cfset Level   = "Diploma">
	<cfset LevelT  = "#lt_text#:">
	<cf_tl id="Region" var="1">
	<cfset Geo     = "#lt_text#">
	<cf_tl id="Special regional studies" var="1">
	<cfset GeoT    = "#lt_text#">
	<cf_tl id="Period" var="1">
	<cfset Per     = "#lt_text#:">
	<cf_tl id="Name Institute" var="1">
	<cfset Org     = "#lt_text#">
	
</cfcase>

<cfcase value="Employment">
	
    <cfset Group   = "'Experience','Region'">
	<cf_tl id="Employment record" var="1">
    <cfset Heading = " #lt_text#">
	<cf_tl id="Profession" var="1">
    <cfset Field   = "#lt_text#"> 
	<cf_tl id="Area(s) of expertise" var="1">
	<cfset FieldT  = "#lt_text#:">
	<cf_tl id="Level" var="1">
	<cfset Level   = "Level"> 
	<cfset LevelT  = "Level:">
	<cfset Geo     = "Region">
	<cfset GeoT    = "Employment region:">
	<cfset Per     = "Employment Period:">
	<cfset Org     = "Organization name">
</cfcase>

<cfdefaultcase>
	
    <cfset Group   = "'Education'">
	<cf_tl id="Education record" var="1">
    <cfset Heading = " #lt_text#">
	<cf_tl id="Study" var="1">
	<cfset Field   = "#lt_text#">
	<cf_tl id="Field of study" var="1">
	<cfset FieldT  = "#lt_text#:">
	<cfset Level   = "Degree">
	<cf_tl id="Degree" var="1">
	<cfset LevelT  = "#lt_text#:">
	<cf_tl id="Region" var="1">
	<cfset Geo     = "#lt_text#">
	<cf_tl id="Special regional studies" var="1">
	<cfset GeoT    = "#lt_text#:">
	<cf_tl id="Study period" var="1">
	<cfset Per     = "#lt_text#:">
	<cf_tl id="Name Institue" var="1">
	<cfset Org     = "#lt_text#">
	
</cfdefaultcase>

</cfswitch>

<cf_tl id="Please select" var="1">
<cfset Pls  = "#lt_text#">

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Background">

<cfif URL.ID2 eq "Employment">
	<cfset lookup = "'Organization','Level'">
<cfelseif URL.ID2 eq "School" or URL.ID2 eq "Training">	
	<cfset lookup = "'Diploma'">
<cfelse>
	<cfset lookup = "'Degree'">
</cfif>

<cfif URL.ID neq ""> <!--- edit mode --->

	<cfquery name="Lookup" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   F.*, 
		         P.Parent AS Parent, 
				 S.ExperienceFieldId AS Currently
		FROM     #CLIENT.LanPrefix#Ref_ExperienceClass P INNER JOIN
	             #CLIENT.LanPrefix#Ref_Experience F ON P.ExperienceClass = F.ExperienceClass LEFT OUTER JOIN
	             ApplicantBackgroundField S ON F.ExperienceFieldId = S.ExperienceFieldId AND S.ExperienceId = '#URL.ID#'
		WHERE    F.Status = 1 
	</cfquery>
		
<cfelse>	

	<!--- view mode --->
	
	<cfquery name="Lookup" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    R.*, NULL as Currently, P.Parent
	    FROM      Ref_Experience R, 
		          Ref_ExperienceClass P
		WHERE     R.ExperienceClass = P.ExperienceClass
		AND       P.Parent IN (#preserveSingleQuotes(lookup)#)
		AND       R.Status = '1'
		ORDER BY  P.Parent, R.ListingOrder, R.Description 
	</cfquery>

</cfif>



<cfoutput>

	 <script language="JavaScript">
	
		 function validateform() {   	 		
			document.getElementById('backgroundform').onsubmit();		 
			if(!_CF_error_exists) {    	    	 
				ptoken.navigate('BackgroundEntrySubmit.cfm?owner=#url.owner#&applicantno=#url.applicantno#&section=#url.section#&entryScope=#url.entryScope#&source=#url.source#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&Topic=#URL.Topic#&Mode=#URL.Mode#','process','','','POST','backgroundform')
			}   
		  }	 
	 
	 </script>
  
</cfoutput>
 
<CFFORM onsubmit="return false" style="height:100%" name="backgroundform" id="backgroundform">



<cfoutput>
	<input type="hidden" name="ExperienceType" value="#URL.ID2#">
</cfoutput>
  
<table width="94%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">

	  <tr style="height:20"> 
	    
		  <cfoutput> 
		  <td>
			  <table width="100%">
			  <tr>
			  	<td class="labellarge" style="font-size:32px;height:59px;padding-top:5px">#Heading#</td>
				<td align="right" style="padding-top:22px">
			    <table cellspacing="0" cellpadding="0" class="formpadding"><tr>
					<td class="labelit"><cf_tl id="Created">:</td>
					<td class="labelit" style="padding-left:5px">#Dateformat(Background.created,dateformatshow)#</td>
					<cfif Background.updated neq "">
						<td class="labelit" style="padding-left:10px"><cf_tl id="Updated">:</td>
						<td class="labelit" style="padding-left:5px">#Dateformat(Background.updated,dateformatshow)#</td>
					</cfif>
					</tr>
				</table>
				</td>	
			  </tr>
			  </table>
		  </td>	  
		  </cfoutput> 
		  
  </tr>
    
  <tr><td class="linedotted" height="1"></td></tr>
	  
  <tr> 
        
  <td style="width:100%;height:100%;padding-left:10px;padding-right:10px">  
 
  	<cf_divscroll>

		  <table width="99%" class="formpadding;formspacing">
		  <tr><td height="8"></td></tr>
		  <tr>  
		  <td>
			  <table width="100%" class="formpadding">
			  
			   <tr>
			   <td width="20%" class="labelmedium"><cfoutput>#org#</cfoutput>:  <cfif accessmode eq "edit"><font color="#FF0000">*</font></cfif></td>
			   <td class="labelmedium">
			   
			      <cfif accessmode eq "edit">
				  
			      <cfif url.id eq "">
				      <cfinput type="Text" class="regularxxl enterastab" name="OrganizationName" message="#pls# #org#" required="Yes" size="60" maxlength="100">			
				  <cfelse>
				      <cfinput type="Text" value="#BackGround.OrganizationName#" class="regularxxl enterastab" name="OrganizationName" message="Please enter the Organization name" required="Yes" size="60" maxlength="100">			
				  </cfif>
				  
				  <cfelse>
				  
				    <cfoutput>
				    #BackGround.OrganizationName#				   
				    <input type="hidden" name="OrganizationName" value="#BackGround.OrganizationName#">					
					</cfoutput>
				  
				  </cfif>
				  
			      <cfoutput>
			         <input type="hidden" name="PersonNo" value = "#URL.ID1#">
				  </cfoutput>
				  
			   </td> 
			   </tr>
			
			   <cfif URL.ID2 eq "Employment">  
			   
				   <tr>
				   <TD class="labelmedium"><cf_tl id="Type of organization">: <cf_space spaces="50"></TD>
				   <TD>
				   
				   <cfquery name="ThisLookup" dbtype="query">
					    SELECT    *
					    FROM      Lookup
						WHERE     Parent = 'Organization'
					</cfquery>

				   <cfquery name="qValue"
						   datasource="AppsSelection"
						   username="#SESSION.login#"
						   password="#SESSION.dbpw#">
						   SELECT   F.*,
						   P.Parent AS Parent,
						   S.ExperienceFieldId AS Currently
						   FROM     Ref_ExperienceClass P INNER JOIN
						   Ref_Experience F ON P.ExperienceClass = F.ExperienceClass INNER JOIN
						   ApplicantBackgroundField S ON F.ExperienceFieldId = S.ExperienceFieldId AND S.ExperienceId = '#Background.ExperienceId#' AND F.Description ='#Background.OrganizationClass#'
					   WHERE    F.Status = 1
					   AND P.Parent = 'Organization'
				   </cfquery>
				   
				   <cf_uiselect name = "OrganizationClass"
							selected       = "#qValue.ExperienceFieldId#"
							size           = "1"
							class          = "regularXL"
							id             = "OrganizationClass"							
							required       = "yes"		
							message        = "#pls# type"
							style          = "width:400px"	
							filter         = "contains"																																
							query          = "#ThisLookup#"							
							value          = "ExperienceFieldId"
							display        = "Description"/>	
				   
				   </TD> 
				   </tr>
				   
			   <cfelse>
			   
			   <input type="hidden" name="OrganizationClass" value="">
			   
			   </cfif> 
			      
			   <tr>
			   <TD class="labelmedium"><cf_tl id="Country">:  <cfif accessmode eq "edit"><font color="#FF0000">*</font></cfif></TD>
			   <TD class="labelmedium">
			   
				    <cfif accessmode eq "edit">					
												
					    <cfif BackGround.OrganizationCountry neq "" and url.id neq "">
							<cfset cou = BackGround.OrganizationCountry>
						<cfelse>
							<cfset cou = Person.Nationality>						
						</cfif>
						
						<cf_uiselect name = "OrganizationCountry"
							selected       = "#cou#"
							size           = "1"
							class          = "regularXL"
							id             = "OrganizationCountry"							
							required       = "yes"		
							message        = "#pls# country"
							style          = "width:400px"	
							filter         = "contains"																																
							query          = "#Nation#"							
							value          = "Code"
							display        = "Name"/>				      
						   
					<cfelse>										
										
						<cfquery name="getNation" 
					    datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT Code,Name 
						    FROM   Ref_Nation
							WHERE  Operational = '1'
							AND Code = '#BackGround.OrganizationCountry#'
							ORDER BY NAME
						</cfquery>
					
						 <cfoutput>
						 
						 #getNation.Name#						 
						 <input type="hidden" name="OrganizationCountry" value="#BackGround.OrganizationCountry#">
						 
						 </cfoutput>
					
					</cfif>
			   </TD> 
			   </tr>
			   
			   <tr>
			   <TD class="labelmedium"><cf_tl id="City">:  </TD>
			   <TD>
			   
			   		<cfif url.id eq "">
					<cfinput type="Text" class="regularxxl enterastab" name="OrganizationCity" message="#lt_text#" required="no" size="40" maxlength="60"> 
					<cfelse>
				   	<cfinput type="Text" value="#Background.OrganizationCity#" class="regularxxl enterastab" name="OrganizationCity" message="#lt_text#" required="no" size="40" maxlength="60">
					</cfif>
				
			   </TD> 
			   </tr>
			  
			   <tr>
			   <TD class="labelmedium"><cf_tl id="Address">: </TD>
			   <TD><cfif url.id eq "">
					<cfinput type="Text" class="regularxxl enterastab" name="OrganizationAddress" message="#lt_text#" required="no" size="60" maxlength="150"> 
					<cfelse>
				   	<cfinput type="Text" value="#Background.OrganizationAddress#" class="regularxxl enterastab" name="OrganizationAddress" message="#lt_text#" required="no" size="60" maxlength="150">
					</cfif> 
			   </TD> 
			   </tr>
			   
			   <tr>			   
			    <td class="labelmedium">
			   		<cfoutput>#Per#</cfoutput> <cfif accessmode eq "edit"><font color="#FF0000">*</font></cfif>
			   	</td>
			    <td>
			   
				   <cfif accessmode eq "edit">
				   
					   <table cellspacing="0" cellpadding="0"><tr>
					   
					   <td class="labelit">
					   
					   <cf_intelliCalendarDate9
							FieldName="ExperienceStart" 
							Class="regularxxl enterastab"
							Default="#DateFormat(Background.ExperienceStart, CLIENT.DateFormatShow)#"
							AllowBlank="False">	 
							
							</td>
							<td>&nbsp;-&nbsp;</td>
						 	<td>
														
							<cfif url.id eq "">
							
								   <cf_intelliCalendarDate9
										FieldName="experienceend" 
										Class="regularxxl enterastab"
										Default=""
										AllowBlank="True">	 		
							<cfelse>
							
								 <cf_intelliCalendarDate9
										FieldName="experienceend" 
										Class="regularxxl enterastab"
										Default="#DateFormat(Background.ExperienceEnd, CLIENT.DateFormatShow)#"
										AllowBlank="True">	 						
							</cfif>
							
							
							</td><td style="padding-left:5px">
						  
					   <input type="button" value="today" style="width:60" class="enterastab button10g" onClick="javascript:document.getElementById('experienceend').value='<cfoutput>#DateFormat(now(),CLIENT.DateFormatShow)#</cfoutput>'">
					   
					   </td></tr>
					   </table>
					   
					  <cfelse>
					  
					  <cfoutput>
					  
					  <table><tr><td class="labelmedium">#DateFormat(Background.ExperienceStart, CLIENT.DateFormatShow)# - <cfif Background.ExperienceEnd eq ""> <cf_tl id="Today"><cfelse>#DateFormat(Background.ExperienceEnd, CLIENT.DateFormatShow)#</cfif></td></tr></table>
					 				  
					  <input type="hidden" name="ExperienceStart" value="#DateFormat(Background.ExperienceStart, CLIENT.DateFormatShow)#">
					  <input type="hidden" name="ExperienceEnd"   value="#DateFormat(Background.ExperienceEnd, CLIENT.DateFormatShow)#">
					  
					  </cfoutput>
					   					  
					  </cfif> 
			      
			   </td>     
			   
			   </tr>
			   
			  
			   
			   <tr>
				   <td class="labelmedium"><cf_tl id="Title">: <cfif accessmode eq "edit"><font color="#FF0000">*</font></cfif></TD>
				   <td class="labelmedium">
				   
					   	<cf_tl id="Please enter your Title (function)" var="1"> 
						
						<cfif accessmode eq "edit">
							<cfif url.id eq "">
								<cfinput type="Text" class="regularxxl enterastab" name="ExperienceDescription" message="#lt_text#" required="Yes" size="60" maxlength="100"> 
							<cfelse>
								<cfoutput>
								   	<cfinput type="Text" value="#Background.ExperienceDescription#" class="regularxxl enterastab" name="ExperienceDescription" message="#lt_text#" required="Yes" size="60" maxlength="100">
								</cfoutput>
							</cfif>
						<cfelse>					
							 <cfoutput>#BackGround.ExperienceDescription#		
							 	<input type="hidden" name="ExperienceDescription" value="#BackGround.ExperienceDescription#">			
							 </cfoutput>	
						</cfif>
				   </td> 
			   </tr>	
			   
			       
			      				
			    <!--- Field: Level --->
			    <TR>
				    <td class="labelmedium"><cfoutput>#LevelT#</cfoutput> <!--- <font color="#FF0000">*</font> ---></td>
				    <td>
					
						<!--- 	 <cfselect name="LevelId" size="1" required="Yes" class="regularxl enterastab" message="Select a #LevelT#"> --->
						
						<cfquery name="ThisLookup" dbtype="query">
						    SELECT    *
						    FROM      Lookup
							WHERE     Parent = '#Level#'
						</cfquery>
							
						   <cf_uiselect name = "LevelId"
								selected       = ""
								size           = "1"
								class          = "regularXL"
								id             = "OrgUnit"							
								required       = "yes"		
								style          = "width:400px"	
								filter         = "contains"																																
								query          = "#thislookup#"							
								value          = "ExperienceFieldId"
								display        = "Description"/>							
									
					</td>	
					</tr>
			   
			   <cfif URL.ID2 eq "Employment">
			   
				   <tr>
					   <td class="labelmedium"><cf_tl id="Name of Supervisor">:</TD>
					   <td>
					   <cfif url.id eq "">
					       <cfinput type="Text" name="Supervisor" required="No" size="40" maxlength="100" class="regularxxl enterastab">
					   <cfelse> 
						   <cfinput type="Text" name="Supervisor" value="#Background.SupervisorName#" required="No" size="40" maxlength="100" class="regularxxl enterastab">
					   </cfif>
					   				   
					   </td> 
				   </tr>
				  
				   <tr>
					   <TD class="labelmedium"><cf_tl id="eMail of Supervisor">:</TD>
					   <TD><cfinput type="Text" name="Email" value="#Background.OrganizationEmail#" required="No" size="40" maxlength="100" class="regularxxl enterastab"></TD> 
				   </tr>
				   
				   
				   <input type="hidden" name="StaffSupervised"   value="<cfoutput>#Background.staffSupervised#</cfoutput>">
				   
				   <tr>
				      
					  <td colspan="2">
					  
					  <table width="100%" style="background-color:fafafa" class="formpadding">
					  
					  <tr class="labelmedium">
					    <td style="padding-left:25px;width:200"><cf_tl id="Reference"></td>
					  	<td style="width:60%"><cf_tl id="Name"></td>
						<td><cf_tl id="eMail"></td>
					  </tr>
					  
					  <cfoutput>
					  
					  <cfloop index="itm" from="1" to="3">
											  
						<cfquery name="getContact" 
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT  *
							    FROM     ApplicantBackGroundContact 
								WHERE    
									<cfif url.id neq "">
										ExperienceId = '#url.id#'
									<cfelse>
										1=0
									</cfif>
								AND      ApplicantNo  = '#applicantno#'
								AND      ContactSerialNo = '#itm#'
						</cfquery>
					  
					  <tr>
					     <td style="padding-left:25px;width:200px">
						 <select class="regularxl" name="ContactClass_#itm#" style="background-color:transparent;width:100">
							 <option value="Supervisor" <cfif getContact.ContactClass eq "supervisor">selected</cfif>>Supervisor</option>
							 <option value="Co-worker" <cfif getContact.ContactClass eq "co-worker">selected</cfif>>Co-worker</option>
							 <option value="Other" <cfif getContact.ContactClass eq "other">selected</cfif>>Other</option>
						 </select>
						 
						 </td>
						 <td style="padding-left:12px"><cfinput type="Text" name="ContactReference_#itm#" value="#getContact.ContactReference#" required="No" style="background-color:fafafa;width:100%" maxlength="100" class="regularxl enterastab"></td>
						 <td style="padding-left:2px;padding-right:30px"><cfinput type="Text" message="Incorrect eMail format" name="ContactCallsign_#itm#"  value="#getContact.ContactCallsign#" style="background-color:fafafa;" required="No" size="25" validate="eMail" maxlength="100" class="regularxl enterastab"></td>						
					  </tr>		  					  
					  
					  </cfloop>
					  
					  <tr><td style="height:10px"></td></tr>
					  
					  </cfoutput>
					  
					  </table>
					  
					  </td>				   				   
				   </tr>
					
				   <!---
				  
				   <tr>
				   <TD class="labelmedium"><cf_tl id="People supervised">:</TD>
				   <TD>
				   		<cf_tl id="Please enter a valid number supervised" var="1">
				   		<cfinput class="regularxl enterastab" style="text-align:center;width:40px" type="Text" name="StaffSupervised" value="#Background.staffSupervised#" message="<cfoutput>#lt_text#</cfoutput>" validate="integer" required="No" size="2" maxlength="2">
				   </TD> 
				   </tr>
				   
				   --->
				   				   				   
				   <!--- text topics --->
				  
					<cfquery name="Detail" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   Topic, Description, Question
							FROM     Ref_Topic
							WHERE    Parent = 'Experience'			
							AND      Source = '#URL.Source#'
							AND      Operational = 1
							AND      ValueClass = 'Memo'
							ORDER BY Topic
						</cfquery>	
													
						<cfif URL.ID eq "">
						
							<cfquery name="Response" 		<!--- in edit mode so create empty query --->
								datasource="AppsSelection" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT TopicValue
								FROM   ApplicantBackgroundDetail
								WHERE  0=1					
							</cfquery>	
							
						</cfif>
											
						<cfloop query="Detail">
			
							<cfif URL.ID neq "">
							
								<cfquery name="Response" 
									datasource="AppsSelection" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT TopicValue
									FROM   ApplicantBackgroundDetail
									WHERE  ApplicantNo  = '#Background.ApplicantNo#'
									AND    ExperienceId = '#URL.ID#' 
									AND    Topic = '#Detail.Topic#'
								</cfquery>					
								
							</cfif>					
							
							<tr>
							<cfoutput>
							<td class="labelmedium" valign="top">#Question#:</td>
							<td><textarea class="regular" style="width:98%;height:90;font-size:15px;padding:4px"  name="DT#Detail.Topic#" type="text">#Response.TopicValue#</textarea>
							</td>    
							</cfoutput>	
							</tr>
							
						</cfloop>
								
				</cfif>
			
				<!--- --->
				<cfif url.id neq "">
				
					<cfquery name="moreDetails" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT R.*, D.TopicValue
							FROM   ApplicantBackgroundDetail D, Ref_Topic R
							WHERE  D.ApplicantNo  = '#ApplicantNo#'
							AND    D.ExperienceId = '#url.id#'
							AND    R.Topic = D.Topic
							AND    R.Operational = 1
					</cfquery>	
													
					<cfif background.ExperienceCategory eq "Employment" and moredetails.recordcount gte "1">
							  				
						<tr id="#currentrow#" class="xxhide">
											
						<td colspan="8" style="padding-top:2px;padding-left:14x;padding-right:5px">
						
						<table width="100%" style="border:0px dotted 0080C0" border="0" cellspacing="0" cellpadding="0" align="center">
						
						    <!---
						    <tr>
								<td class="labelmedium" style="padding-left:13x">
								<a href="javascript:minimize('#CurrentRow#','Min')"><font color="0080C0"><u><cf_tl id="Hide"></a>
								</td>
							</tr>
							--->
						
							<tr><td>
								
								<table width="100%" align="center" class="formpadding">
								
								<cfoutput query="moreDetails">
								
								    <tr><td style="padding-left:0px; padding-top:4px" class="labellarge">#Description#</td></tr>
									<tr><td class="labelmedium" style="padding:20px">#TopicValue#</td></tr>
													
								</cfoutput>
								
								</table>
								
							</td></tr>
							<tr><td height="4"></td></tr>
						</table>
						
						</td>
						</tr>
										
					</cfif>			
				
				</cfif>
												 			
				<cfset cnt = 0>		
				<tr>	
				<td colspan="2" width="99%" align="center">
				
																				
				<cfif source.PHPMode eq "Basic">
				
					<!--- no detailed keyword entry supported for basic mode  --->
				
				<cfelse>
								
					<cf_param name="url.owner" default="" type="String">
					<cf_param name="url.mode" default="1" type="String">
												
					<cfif URL.mode eq "1">																				
					     <cfset URL.Parent = URL.ID2>
					     <cfset URL.Id1    = URL.ID2>	
						 				
					     <cfinclude template="../Keyword/KeywordEntry.cfm"> 						
					<cfelse>
						
					 <cfinclude template="TopicEntryDetail.cfm"> 
					</cfif> 
				
				</cfif>
				
				</td>
				</tr>
				
				<tr><td height="1" colspan="2" class="linedotted"></td></tr>
				<tr><td colspan="2" align="center">
								
					<table align="center" class="formspacing">
					<tr>	
					<cf_tl id="Back" var="1">
					<cfoutput>
					
					<cfif url.entryScope eq "BackOffice">
						
						<cfset backAction = "history.back()">
						
					<cfelseif url.entryScope eq "Track">
						
						<cfset backAction = "parent.ProsisUI.closeWindow('myexperience')">	
						
					<cfelseif url.entryScope eq "Portal">
					
						<cf_param name="url.applicantno" default="0" type="String">	
						<cf_param name="url.section" default="" type="String">	
						<cfif url.id2 eq "Employment">
							<cfset template="Background.cfm">
						<cfelse>
							<cfset template="Education.cfm">
						</cfif>
						
						<cfset backAction = "ptoken.location('#SESSION.root#/Roster/PHP/PHPEntry/Background/#template#?ID=#url.id#&entryScope=#url.entryScope#&applicantno=#url.applicantno#&section=#url.section#&owner=#URL.owner#')">
					
					<cfelseif url.entryScope eq "Validation">
								
						<cfset 	backaction = "parent.window.close()">	
						
					</cfif>
						
						<cf_tl id="Close" var="1">
						<td><input type="button" value="#lt_text#" class="button10g enterastab" onClick="#backAction#"></td> 
						<cf_tl id="Save" var="1">
						<td><input type="button" name="Save" value="#lt_text#" class="button10g" onclick="validateform()"></td>
						<td id="process"></td>
					</cfoutput>
					</tr>	
					
					<tr><td height="6"></td></tr>
					
				    </table>
				
				</td>
				
				</tr>
			
			</TABLE>
		</td>
		</tr>
		</table>
		
		
		</cf_divscroll>
	
	</td>
  </tr>
</table>

</CFFORM>
	
