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
<cf_listingscript>

<cfparam name="url.owner"      default="">
<cfparam name="url.entryScope" default="Portal">

<cfajaximport tags="cfform,cfmap">
<cf_textAreaScript>
<cf_calendarScript>
<cf_actionListingscript>

<cf_screentop html="No" jquery="Yes">

<cfparam name="url.ApplicantNo"  default="">
<cfparam name="url.Id"  default="">

<cfif url.applicantNo neq "" and url.id eq "">
	
	<cfquery name="Get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  S.PersonNo, S.Source
		FROM    Applicant A, 
		        ApplicantSubmission S
		WHERE   A.PersonNo = S.PersonNo
		AND     S.ApplicantNo = '#URL.ApplicantNo#'
	</cfquery>
	
	<cfset url.id  = Get.PersonNo>

</cfif>

<cfset URL.edit = "edit">

<cfoutput>
	
<script language="JavaScript">
		
	function validate(sc) {}
		
	function show_error(form, ctrl, value, msg)	{
		Prosis.notification.show('Error', msg, 'error', 2500); //error, success, information		
	}  	
	
	function loadrequesttype(mode,scope,req,wor,itm) {  	 	   		   				  
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Complaint/Create/DocumentRequestType.cfm?scope='+scope+'&requestid='+req+'&serviceitem='+itm+'&accessmode='+mode+'&workorderid='+wor,'boxrequesttype')     	  
	}	

	function addComplaint(own,id,sc) {
		document.forms['formrequest'].onsubmit();
		if(!_CF_error_exists) {   
			ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Complaint/Create/DocumentFormSubmit.cfm?accessmode=Edit&applicantno=#url.applicantno#&section=#url.section#&id=#url.id#&entryScope=Portal&mission=#url.mission#&owner='+own,'requestbox','','','POST','formrequest')
		}   
	}
	
	function updateComplaint(own,id) {
		document.forms['formrequest'].onsubmit();
		if(!_CF_error_exists) {   
			ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Complaint/Create/DocumentFormEditSubmit.cfm?applicantno=#url.applicantno#&section=#url.section#&id=#url.id#&entryScope=Portal&mission=#url.mission#&owner='+own+'&requestId='+id,'requestbox','','','POST','formrequest')
		}   
	}	

	function deleteComplaint(own,id) {
		 ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Complaint/Create/DocumentDeleteSubmit.cfm?applicantno=#url.applicantno#&section=#url.section#&id=#url.id#&entryScope=Portal&mission=#url.mission#&owner='+own+'&requestId='+id,'requestbox')
	}	
	
	function closeComplaint(own,id) {
		 ptoken.location('#SESSION.root#/WorkOrder/Application/Medical/Complaint/Listing/ComplaintListing.cfm?Mission=#URL.Mission#&ApplicantNo=#URL.ApplicantNo#&Section=#URL.section#&owner='+own+'&id='+id);
	}		
	
	 function medicalopen(actionid) {
    	 ptoken.open('#session.root#/WorkOrder/Application/Medical/Encounter/DocumentView.cfm?drillid='+actionid,'_blank')
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

<cfif Section.Obligatory eq "1">
	
	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   COUNT(*) AS Total
		FROM     ApplicantAddress A
		WHERE    PersonNo = '#Get.PersonNo#'
		AND      ActionStatus != '9'
	</cfquery>	
	
</cfif>

<cfparam name="URL.Next" default="Default">

<table width="99%" border="0" height="100%" align="center">
		
	 <tr>
	    <td style="height:35;font-size:30px;padding-top:15px;padding-left:20px" class="labellarge">
		<cfoutput>
		 <img src="#SESSION.root#/images/logos/workorder/medical.png" height="55"  border="0" align="absmiddle">    	
		 </cfoutput>
		<cf_tl id="Medical Request">
		</td>	    
	</tr>
		
	<tr>		
		<td height="100%" width="100%" valign="top" style="padding-right:20px">
		 
		    <cf_divscroll height="100%" width="100%" id="requestbox">
											
			<table height="100%" width="100%" class="formpaddding">
			
				<tr>
					<td valign="top" class="labelmedium" style="height:100%;padding-left:20px;padding-right:20px" id="dComplaints" name="dComplaints">
						<cfinclude template="ComplaintListingContent.cfm">		
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
						
						<cfif URL.EntryScope eq "Portal">	
						
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
								
			 			</cfif>		 
					 </td>
				  </tr>
				  
			</table>
			
			</cf_divscroll>
						
		</td>
 
	</tr>
	
</table>	
