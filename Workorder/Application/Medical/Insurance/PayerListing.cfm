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

<!--- this section is geared for the portal --->

<cfset URL.edit  	  = "edit">
<cfparam name="url.section" default="general">

<cfif url.section eq "general">
  <cfset url.entryScope = "backoffice">
<cfelse>
  <cfset url.entryScope = "portal">	  
</cfif>

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

<cfif url.entryScope eq "Portal">
	<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes">
<cfelse>
	<cf_uiGadgets gadget="notification" jQuery="Yes">
</cfif>

<cfparam name="url.owner" default="">
<cfparam name="url.Id" 	  			  default="">
<cfparam name="url.ApplicantNo" 	  default="">

<cfajaximport tags="cfform,cfmap">
<cf_calendarScript>

<cf_windowNotification>
<cf_mapscript>
<cf_DialogOrganization>	

<cfif url.applicantNo neq "">
	
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
	
	<cfset url.id  = Get.PersonNo>

</cfif>

<cf_tl id="Insurance Information" var="vInsuranceInformation">
<cf_tl id="Do you want to remove this record ?" var="deleteQuestion">

<cfoutput>
	
<script language="JavaScript">
		
	function validate(sc) {
		var a = document.getElementById('insuranceprocess');
		document.forms['formaddress'].onsubmit();
		if(!_CF_error_exists) {   
		    if (sc == "") {                
				ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Insurance/PayerEntrySubmit.cfm?mission=#URL.mission#&applicantno=#url.applicantno#&section=#url.section#&id=#url.id#&entryScope=Portal','addressprocess','','','POST','formpayer')
			} else {
				ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Insurance/PayerEditSubmit?mission=#URL.mission#&applicantno=#url.applicantno#&section=#url.section#&id=#url.id#&entryScope=Portal&id1='+sc,'addressprocess','','','POST','formpayer')
			}
		}   			
	}
		
	function show_error(form, ctrl, value, msg)	{
		Prosis.notification.show('Error', msg, 'error', 2500); //error, success, information		
	}  		
	
	function newInsurance(own,id) {			    
		_cf_loadingtexthtml='';	
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Insurance/PayerEntry.cfm?mission=#URL.mission#&owner=' + own + '&id=' + id,'dPayerListing') 		
	}	

	function editInsurance(payerid,own,id) {		   
        _cf_loadingtexthtml='';		
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Insurance/PayerEntry.cfm?mission=#URL.mission#&payerId='+payerid+'&owner='+own+ '&id=' + id,'dPayerListing') 		
	}
		
	function closeInsurance(own,id) {
	    Prosis.busy('yes')
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Insurance/PayerListingDetail.cfm?mission=#URL.mission#&owner='+own+'&id='+id,'dPayerListing') 
	}
	
	function addInsurance(own,id) {
	    Prosis.busy('yes')
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Insurance/PayerEntrySubmit.cfm?mission=#URL.mission#&owner=' + own + '&id=' + id,'process','','','POST','formpayer'); 
	}

	function updateInsurance(payerid,own,id) {
	    Prosis.busy('yes')
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Insurance/PayerEntrySubmit.cfm?mission=#URL.mission#&payerid=' + payerid+'&owner=' + own + '&id=' + id,'process','','','POST','formpayer'); 
	}

	function deleteInsurance(payerid,own,id) {
		if (confirm('#deleteQuestion#')) {
			ptoken.navigate('#SESSION.root#/WorkOrder/Application/Medical/Insurance/PayerDelete.cfm?mission=#URL.mission#&payerid=' + payerid+'&owner=' + own + '&id=' + id,'dPayerListing'); 
		}
	}
		
</script>

<script>
	Prosis.busy('no')
</script>

</cfoutput>

<cfparam name="URL.Next" default="Default">

<table width="94%" height="100%" align="center">
			
	 <tr><td height="27"></td></tr>
	  <tr>
	    <td style="height:35;font-size:30px;padding-left:20px" class="labellarge">
		<cfoutput>
		   <img src="#session.root#/images/logos/staffing/blue/insurance.png" alt="" border="0" height="55">
		</cfoutput>
		<cf_tl id="Insurance Information"></td>
	  
	   </tr>
	
	<tr>		
		<td height="100%" width="100%" id="addressbox" valign="top">
			
			<table height="100%" width="100%">
				<tr>
					<td height="100%" valign="top" id="dPayerListing">				
						<cfinclude template="PayerListingDetail.cfm">											
					</td>
				</tr>
				
				<cfif url.entryScope eq "Portal">
				
				  <tr>
					<td height="40" class="line" style="padding-top:20px;">	
						
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
				  </cfif>				  
			</table>			
		</td> 
	</tr>	
</table>	