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
<cf_listingscript>

<cfparam name="url.owner" default="">

<cfajaximport tags="cfform,cfmap">

<cf_screentop html="No" jquery="Yes">

<cf_calendarScript>
<cf_textAreaScript>

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT S.PersonNo, S.Source
	FROM   Applicant A, 
	       ApplicantSubmission S
	WHERE  A.PersonNo = S.PersonNo
	AND    S.ApplicantNo = '#URL.ApplicantNo#'
</cfquery>

<cfset url.id    	  = Get.PersonNo>
<cfset url.entryScope = "Portal">
<cfset URL.edit  	  = "edit">

<cfoutput>
	
<script language="JavaScript">
		
	function validate(sc) {}
		
	function show_error(form, ctrl, value, msg)	{
		Prosis.notification.show('Error', msg, 'error', 2500); //error, success, information		
	}  	
	
	function loadrequesttype(mode,scope,req,wor,itm) {  	 	   		   				  
		ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Medical/Complaint/Create/DocumentRequestType.cfm?scope='+scope+'&requestid='+req+'&serviceitem='+itm+'&accessmode='+mode+'&workorderid='+wor,'boxrequesttype')     	  
	}
	
	function addComplaint(own,id,sc) {
		document.forms['formrequest'].onsubmit();
		if(!_CF_error_exists) {   
			ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Medical/Complaint/Create/DocumentFormSubmit.cfm?accessmode=Edit&applicantno=#url.applicantno#&section=#url.section#&id=#url.id#&entryScope=Portal&mission=#url.mission#&owner='+own,'requestbox','','','POST','formrequest')
		}   
	}
	
	function updateComplaint(own,id) {
		document.forms['formrequest'].onsubmit();
		if(!_CF_error_exists) {   
			ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Medical/Complaint/Create/DocumentFormEditSubmit.cfm?applicantno=#url.applicantno#&section=#url.section#&id=#url.id#&entryScope=Portal&mission=#url.mission#&owner='+own+'&requestId='+id,'requestbox','','','POST','formrequest')
		}   
	}	

	function deleteComplaint(own,id) {
		ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Medical/Complaint/Create/DocumentDeleteSubmit.cfm?applicantno=#url.applicantno#&section=#url.section#&id=#url.id#&entryScope=Portal&mission=#url.mission#&owner='+own+'&requestId='+id,'requestbox')
	}	

	
	function closeComplaint(own,id) {
		ptoken.location('#SESSION.root#/WorkOrder/Application/Medical/Complaint/Listing/ComplaintListing.cfm?Mission=#URL.Mission#&ApplicantNo=#URL.ApplicantNo#&Section=#URL.section#&owner='+own+'&id='+id);
	}	
		
		
</script>

<script>
Prosis.busy('no')
</script>

</cfoutput>

<cfquery name="Section" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     #CLIENT.LanPrefix#Ref_ApplicantSection
			WHERE    Code = '#URL.Section#'		
</cfquery>

<cfparam name="URL.Next" default="Default">

<table width="94%" border="0" height="100%" align="center">
		
	<tr>
	    <td style="height:35;font-size:30px;padding-top:20px;padding-left:20px" class="labellarge">
		<cfoutput>
		 <img src="#SESSION.root#/images/logos/staffing/blue/appointment.png" height="55"  border="0" align="absmiddle">    	
		 </cfoutput>
		<cf_tl id="Medical Appointment">
		</td>	    
	</tr>
	
	<tr>		
		<td height="100%" width="100%" id="requestbox" valign="top">
			
			<table height="100%" width="100%" class="formpaddding">
			
				<tr>
					<td valign="top" class="labelmedium" style="height:100%;padding:20px" id="dComplaints" name="dComplaints">
						<cfinclude template="EncounterListingContent.cfm">		
					</td>
				</tr>
				
				<tr>
					<td class="line" style="height:40;padding-top:20px;">	
						
						<cfset setNext = 1>
		
						<cfif Section.Obligatory eq 1>
			
							<cfif Check.Total eq 0>
			   					<cfset setNext = 0>
							</cfif>  
		
						</cfif>
	
		 				<cf_Navigation
			 				Alias         = "AppsSelection"
			 				TableName     = "ApplicantSubmission"
			 				Object        = "Applicant"
			 				ObjectId      = "No"
			 				Group         = "PHP"
			 				Section       = "#URL.Section#"
			 				SectionTable  = "Ref_ApplicantSection"
			 				Id            = "#URL.ApplicantNo#"
			 				BackEnable    = "1"
			 				HomeEnable    = "0"
			 				ResetEnable   = "0"
			 				ResetDelete   = "0"	
			 				ProcessEnable = "0"
			 				NextEnable    = "1"
			 				NextSubmit    = "0"
			 				OpenDirect    = "0"
			 				IconWidth 	  = "48"
		 					IconHeight	  = "48"
			 				SetNext       = "#setNext#"
			 				NextMode      = "#setNext#">
		 
					 </td>
				  </tr>
				  
			</table>
			
		</td>
 
	</tr>
	
</table>	 

