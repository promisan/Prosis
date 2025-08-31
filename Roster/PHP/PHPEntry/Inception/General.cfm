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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>S CHANGE</proDes>
	<proCom>S CHANGE</proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cf_screentop html="No" jquery="Yes">

<cfparam name="URL.Next"          	default="Default">
<cfparam name="URL.ApplicantNo"   	default="">
<cfparam name="URL.ID"            	default="">
<cfparam name="URL.Code"          	default="">
<cfparam name="URL.Section"       	default="">
<cfparam name="URL.Action"        	default="Edit">
<cfparam name="URL.Public"        	default="0">
<cfparam name="URL.DefaultCountry"	default="GT">

<cfparam name="url.Scope"         	default="">
<cfparam name="url.Owner"         	default="">
<cfparam name="url.Class"         	default="0">
<cfparam name="URL.Mission"       	default="">
<cfparam name="URL.parent"        	default="Miscellaneous">

<cf_windowNotification marginTop="-15px">
<cf_pictureProfileStyle>
<cfif url.public eq "0">
	<cf_dialogStaffing>
</cfif>
<cf_filelibraryscript>
<cf_calendarscript>	

<cfoutput>
	<link rel="stylesheet" href="#session.root#/scripts/mobile/resources/vendor/bootstrap/dist/css/bootstrap.css" />
	<script src="#session.root#/scripts/mobile/resources/vendor/bootstrap/dist/js/bootstrap.min.js"></script>
</cfoutput>


<cfquery name="Section" 
	datasource="appsSelection">
	SELECT   *
	FROM     Ref_ApplicantSection
	WHERE    Code = '#URL.Section#' 
</cfquery>

<cfparam name="URL.entrymode" default="#section.TemplateCondition#">

<!--- harcoding Dev 21/11/2015 --->
<cfif url.mission eq "EAD">
	<cfset URL.entrymode = "Standard">
</cfif>

<cfset row = 0>

<cfquery name="PHPParameter" 
  datasource="AppsSelection">
	  SELECT  TOP 1 *
	  FROM    Parameter
</cfquery>

<cfquery name="Get" 
  datasource="AppsSelection">
	SELECT    *, 
	          S.Source AS SubmissionSource
	FROM      Applicant A INNER JOIN ApplicantSubmission S ON A.PersonNo    = S.PersonNo
	WHERE     S.ApplicantNo = '#url.ApplicantNo#' 
</cfquery>

<cfquery name="Nation" 
  datasource="AppsSystem">
    SELECT     Code, Name 
    FROM       Ref_Nation
	WHERE      Operational = '1'
	ORDER BY   Name
</cfquery>

<cfoutput>

<script>

	function show_error(form, ctrl, value, msg)	{
		Prosis.notification.show('Error', msg, 'error', 2500); //error, success, information	
		try {	
			parent.Prosis.busy('no');	
		}catch(ee) {}		
		try {
			Prosis.busy('no');
		}catch(eee){}
	}  
	
	function myformvalidate() {
	
		 parent.Prosis.busy('no')
		 document.entry.onsubmit(); 				  
		 if(!_CF_error_exists) { 	 		    		
		   ptoken.navigate('#SESSION.root#/Roster/PHP/PHPEntry/Inception/GeneralSubmit.cfm?scope=#url.scope#&parent=#url.parent#&action=edit&entrymode=#url.entrymode#&Code=#URL.Code#&Section=#URL.Section#&ApplicantNo=#url.ApplicantNo#&owner=#url.owner#&applicantclass=#url.class#&mission=#url.mission#','detailcontent','','','POST','entry')
		   return true
		 } else {		
		  return false
		 } 
		 		
	}	
	
</script>	

</cfoutput>

<cfif url.scope eq "BackOffice" or url.scope eq "">	
<table align="center" style="width:96%;height:100%">
<cfelse>
<table align="center" border="0" style="width:96%;height:100%">
</cfif>

<tr><td height="100%" valign="top" style="padding-top:8px">

	<cfform onsubmit="return false"  name="entry" style="height:100%">
		  
		<cfoutput>
		
		<input type="hidden" name="SubmissionSource" value="#get.SubmissionSource#">
		<input type="hidden" name="CandidateStatus"  value="#get.CandidateStatus#">
	    <input type="hidden" name="Mode"             value="#URL.Action#">		
		<input type="hidden" name="Mission"          value="#URL.Mission#">
			
		<cf_divscroll>
					
		<table width="98%" height="100%" border="0" class="formpadding">
					
			<cfif URL.action eq "Create">	
			
				<tr>
				<td height="35">
			
				<cfif url.scope eq "BackOffice">	
																	
				<table width="100%">
					<tr><td height="17"></td></tr>
					<tr><td style="height:60px;font-size:29px;padding-left:6px" class="labellarge">						
						   <cf_tl id="Create Profile">												
					</td></tr>
					
				</table>
				
				<cfelse>
								
				</cfif>
				
				</td>			
				</tr>	
							
				<cf_assignid>
				<cfset submissionid = rowguid>
				 
			<cfelse>
			
				 <cfset submissionid = get.SubmissionId>	 
			
			</cfif>
			
			<input type="hidden" name="submissionid" value="#submissionid#">
										
			<tr>		
			    <td height="100%" valign="top" id="detailcontent" style="padding-left:9px;padding-right:9px">		
				<cfif url.action eq "Create" and url.scope neq "BackOffice">
				    <cfinclude template="MobileForm.cfm">
				<cfelse>							
				    <cfinclude template="GeneralForm.cfm">						 										
				</cfif> 
				</td>			
			</tr>
											
			<cfif URL.Action eq "Create">	
			
				<tr>
				   <td align="center" style="padding-bottom:5px">
				   
					   <cf_assignid>
					   <cfset submissionid = rowguid>
					   
					   <cfsavecontent variable="myscript">					   
						   document.entry.onsubmit(); 		  			  
							if(!_CF_error_exists) {					    
				           		ptoken.navigate('#SESSION.root#/Roster/PHP/PHPEntry/Inception/GeneralSubmit.cfm?public=#url.public#&scope=#url.scope#&parent=#url.parent#&entrymode=#url.entrymode#&action=#url.action#&mission=#url.mission#&owner=#url.owner#&applicantclass=#url.class#&applicantno=','detailcontent','','','POST','entry')
					       }   		   					   
					   </cfsavecontent>
						   
					   <cf_tl id="Submit" var="1">
					   				  			             
					   <input style  = "width:240;height:34;font-size:15px" 
							 type    = "button" 
							 class   = "button10g"
							 onclick = "javascript:#myscript#"
							 name    = "Submit"
							 id      = "submitme"
							 value   = "#lt_text#">
		  
		          </td>
				</tr>  
		  
			<cfelse>
			
			  	<tr>
				   <td height="40" align="right" valign="bottom">
				   				   				   													
					    <cf_Navigation
							 Alias         = "AppsSelection"
							 TableName     = "ApplicantSubmission"
							 Object        = "Applicant"
							 ObjectId      = "No"
							 Section       = "#URL.Section#"		
							 SectionTable  = "Ref_ApplicantSection"					
							 Id            = "#url.ApplicantNo#"
							 BackEnable    = "0"
							 HomeEnable    = "0"
							 ResetEnable   = "0"
							 ResetDelete   = "0"	
							 ProcessEnable = "0"
							 NextEnable    = "1"
							 NextSubmit    = "0"
							 NextScript	   = "myformvalidate"
							 SetNext       = "0"
							 NextMode      = "1"
							 IconWidth 	   = "32"
					 		 IconHeight	   = "32">
						 				 				  
				   </td>
				</tr>
				   
			</cfif>
			
		</table>		
		
		</cf_divscroll>
				
		</cfoutput>		   	
	
	</CFFORM>

</td></tr>

</table>
