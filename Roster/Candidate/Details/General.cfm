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

<cfoutput>
<cf_listingscript>

<script language="JavaScript">

function addorder(mission,customerid) {	
	ptoken.open("#SESSION.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderAdd.cfm?mission="+mission+"&customerid=" + customerid,"_blank");		
}	

<!--- parent.stopload(); --->

function minimize(itm,icon) {

	 se   = document.getElementById(itm)
	 icM  = document.getElementById(itm+"Min")
     icE  = document.getElementById(itm+"Exp")
	 se.className  = "hide" ;
	 icM.className = "hide" ;
	 icE.className = "regular" ;			 
  }
  
function maximizeit(itm,icon) {
    	
	 se   = document.getElementById(itm)
	 icM  = document.getElementById(itm+"Min")
     icE  = document.getElementById(itm+"Exp")
	 se.className  = "regular" ;
	 icM.className = "regular" ;
	 icE.className = "hide" ;			
  }  

function fileOpen(f) {
	window.open(f);
} 

function selectall(chk) {
	
	var count=1
	while (count < 30) {
		se = document.getElementById("selected_"+count)
		if (se)	{
		ln = document.getElementById("line"+count)    
		if (chk == true) {
		     ln.className = "highLight2";
			 se.checked = true;
		} else {      
		   ln.className = "regular";
		   se.checked = false; 
		}		   
		}
	    count++;
	   }	
	}

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }	 
	 	 		 	
	 if (fld != false){		
	 itm.className = "highLight2";
	 }else{		
     itm.className = "regular";		
	 }
  }  
 
function workflowdrill(key,box){
	if (document.getElementById(box).className == "hide") {
		document.getElementById(box).className = "regular";
		ptoken.navigate('#client.root#/Roster/Candidate/Details/Applicant/ApplicantSubmissionWorkflow.cfm?ajaxid='+key,key);	
	}else{
		document.getElementById(box).className = "hide";
	}		
}

function openschedule(wla) {
	workplan(wla,'dialog')
}	

function workflowdrill(key) {
		    
    se = document.getElementById(key)		
				
	if (se.className == "hide") {		
	   se.className = "regular" 		   		  	  		  
	   ptoken.navigate('#client.root#/Roster/Candidate/Details/Applicant/ApplicantDetailWorkflow.cfm?ajaxid='+key,key)	
  		  
	} else {  se.className = "hide" } 	
	
	}		

</script> 

</cfoutput>

<cf_screentop height="100%" scroll="yes" html="No" jQuery="Yes">
	
<cfset w = "97%">

<cfparam name="URL.ProgramLayout" default="Program">

<cfquery name="OwnerSelect"
   datasource="AppsSystem"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
      SELECT   *
	  FROM     UserNames
	  WHERE    Account = '#SESSION.acc#'
</cfquery>

<cfif OwnerSelect.AccountOwner neq "">
	<cfparam name="URL.Owner" default="#OwnerSelect.AccountOwner#">		 
</cfif>

<!--- define the application --->
<cfset CLIENT.Submission = "Manual">
 
<cfparam name="URL.ID" default="">

<cfif CLIENT.submission eq "MANUAL">
	<cfparam name="URL.Section" default="Profile">
<cfelse>
	<cfparam name="URL.Section" default="Profile">
</cfif>

<cfparam name="URL.Topic" default="All">

<cfquery name="Candidate"
    datasource="AppsSelection"
    username="#SESSION.login#"
    password="#SESSION.dbpw#">
      SELECT   A.*
      FROM     Applicant A
      WHERE    A.PersonNo = '#URL.ID#'
	  ORDER BY PersonNo DESC
</cfquery>

<!--- scripts --->

<cfif client.googlemap eq "1" and url.topic eq "address">
     <cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#">  
	 <cf_mapscript width="360" height="300" scope="embed">
</cfif>

<cfajaximport tags="cfform"> 
	
<cf_dialogStaffing>
<cf_mapscript width="360" height="300" scope="embed">
<cf_picturescript>
<cf_dialogworkorder>
<cf_dialogMaterial>
<cf_layoutscript>
<cf_menuscript>
<cf_textareascript>

<table width="100%" height="100%" align="center" border="0" cellspacing="0" class="formpadding">

<tr><td height="30">

<cfif CLIENT.submission eq "MANUAL">  
 
	<cfinclude template="Applicant/Applicant.cfm">	
	
<cfelseif URL.Topic eq "All">

    <script language="JavaScript">
	<cfoutput>
		ptoken.location('Summary/Skill.cfm?now=#now()#&ID1=#URL.ID#')
	</cfoutput>
	</script>
	
<cfelseif URL.Topic eq "Candidacy">	

<cfelse>

    <cfinclude template="Applicant/Applicant.cfm">
    
</cfif>

</td></tr>

<cfoutput>

<cfswitch expression="#URL.Section#">

<cfcase value="General">

<cfif URL.Topic eq "Recapitulation">

	   <tr><td valign="top">	
	   <table width="#w#" align="center" border="0" cellpadding="0" cellspacing="0" class="show formpadding" id="attach" bgcolor="white">
		
		<tr><td>
			<cfset url.personno = url.id>									
			<cfinclude template="../../PHP/PHPEntry/Topic/TopicRecapitulation.cfm">
		</td></tr>
		</table>	
		</td></tr>

</cfif>

<cfif URL.Topic eq "Customer">

	   <tr><td valign="top">	
	   <table width="#w#" align="center" border="0" cellpadding="0" cellspacing="0" class="show formpadding" id="attach" bgcolor="white">
		
		<tr><td>
			<cfset url.personno = url.id>			
			<cfinclude template="../../../System/Organization/Customer/Entity/Entity.cfm">
		</td></tr>
		</table>	
		</td></tr>

</cfif>

<cfif URL.Topic eq "Complaint">

	    <tr><td height="100%" valign="top">	
	    <table height="100%" width="#w#" align="center" border="0" cellpadding="0" cellspacing="0" class="show formpadding" id="attach" bgcolor="white">
										
		<tr><td height="100%">

			<cfset url.applicantNo = url.id>
			<cfset url.entryScope = "BackOffice">
			<cfinclude template="../../../WorkOrder/Application/Medical/Complaint/Listing/ComplaintListing.cfm">
		   			
		</td></tr>
		</table>	
		</td></tr>	

</cfif>



<cfif URL.Topic eq "MedicalAction">

	    <tr><td height="100%" valign="top">	
	    <table height="100%" width="#w#" align="center" border="0" cellpadding="0" cellspacing="0" class="show formpadding" id="attach" bgcolor="white">
										
		<tr><td height="100%">

			<cfset url.personno = url.id>
			<cfset url.entryScope = "BackOffice">
			<cfinclude template="../../../WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Action/ActionListing.cfm">
		   			
		</td></tr>
		</table>	
		</td></tr>	

</cfif>

<cfif URL.Topic eq "Payer">

	   <tr><td valign="top">	
	   <table width="#w#" align="center" border="0" cellpadding="0" cellspacing="0" class="show formpadding" id="attach" bgcolor="white">
		
		<tr><td>
			<cfset url.personno = url.id>
			<cfinclude template="../../../WorkOrder/Application/Medical/Insurance/PayerListing.cfm">
		</td></tr>
		</table>	
		</td></tr>

</cfif>

<cfif URL.topic eq "Medical">

		<!--- check if candidate has a profile --->
		   
	   <cfquery name="Customer" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      Customer
			WHERE     PersonNo = '#url.id#' 				
		</cfquery>
					
		<cfif customer.recordcount gte "1">
			
		    <tr><td height="100%" valign="top">	
		    <table height="100%" width="#w#" align="center" border="0" cellpadding="0" cellspacing="0" class="show formpadding" id="attach" bgcolor="white">
											
			<tr><td height="100%">
						     			
				<cfset url.personno = url.id>
				<cfinclude template="../../../System/Organization/Customer/Activities/ActivityListing.cfm">
				
			</td></tr>
			</table>	
			</td></tr>	
			
		 <cfelse>
		 
		 	<tr><td height="100%" valign="top">	
			
		    <table width="#w#" align="center" border="0" cellpadding="0" cellspacing="0" class="show formpadding" id="attach" bgcolor="white">
			
			<tr><td class="labellarge" align="center" style="padding-top:25px">
						     			
				<font color="red"><b><cf_tl id="Attention"></b>:<font color="gray"><cf_tl id="No customer profile found for this person"></font>
				
			</td></tr>
			</table>	
			</td></tr>					
		
		</cfif>

</cfif>

<cfif URL.Topic eq "Document">

	   <tr>
	   <td valign="top">	
	   <table width="#w#" align="center" border="0" cellpadding="0" cellspacing="0" class="show formpadding" id="attach" bgcolor="white">
		
		<tr><td>
			<cfinclude template="Attachments/DocumentFileForm.cfm">
		</td></tr>
	   </table>	
	   </td>
	   </tr>

</cfif>

<cfif url.topic eq "warehousesales">

   <tr>
	   <td valign="top" height="100%">		  	
		<cfinclude template="../../../Warehouse/Application/Customer/History/RecordListing.cfm">		
	   </td>
   </tr>

</cfif>

<cfif URL.Topic eq "eMail">

		<cfoutput>

        <tr><td valign="top" height="100%">
		<table width="#w#" height="100%" align="center" cellpadding="0" cellspacing="0" class="show" id="mail">
		<tr><td height="20" style="padding-left:10px" class="labellarge">
		<img src="#session.root#/Images/exchange.png.png" alt="" width="50" height="50" border="0">
		&nbsp;&nbsp;
		<cf_tl id="Official Messages"></td></tr>
		<tr><td height="1" class="linedotted"></td></tr>
		<tr><td style="height:100%">
			<cfinclude template="eMail/eMailSent.cfm">
		</td></tr>
		</table>	
		</td></tr>
		
		</cfoutput>	
	
</cfif>

<cfif URL.Topic eq "All" or URL.Topic eq "Interview">				
	
	    <tr><td valign="top">
		<table width="#w#" border="0" cellspacing="0" cellpadding="0" align="center" id="interview" class="regular">		
		<tr><td style="height:70px;padding-left:10px" class="labellarge">
		<img src="#session.root#/Images/interview.png" alt="" width="70" height="60" border="0">&nbsp;
		<cf_tl id="Interviews"></font></td></tr>
		<tr><td height="1" class="linedotted"></td></tr>
		<tr><td>
			<cfinclude template="Interview/Interview.cfm"> </td></tr>
		</table>	
		</td></tr>				
		
</cfif>		


<cfif URL.Topic eq "All" or URL.Topic eq "IssuedDocument">				
	
		<tr><td valign="top">
		<table width="#w#" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" align="center" id="document" class="regular">
		
		<tr><td>
			<cfinclude template="Document/Document.cfm"> </td></tr>
		</table>	
		</td></tr>				
		
</cfif>		

<cfif URL.Topic eq "All" or URL.Topic eq "Assessment">		

		<tr><td valign="top" height="100%">
			 
			<table width="99%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				  
		    <tr><td valign="top" align="center" height="100%" style="padding-left:10px">				
				<cfinclude template="Assessment/Assessment.cfm">			
			</td>
			</tr>
			
			</table>	
			
		</td></tr>				
		
</cfif>		

<cfif URL.Topic eq "All" or URL.Topic eq "Review">	

		<cfquery name="Topic" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Ref_ReviewClass R
			WHERE      R.Code = '#URL.ID1#'
		</cfquery>

		<tr><td valign="top">		
		<table width="#w#" border="0" cellspacing="0" cellpadding="0" align="center" id="review" class="regular">
		    <tr><td style="height:30;padding-left:8px" class="labellarge"><b><cfoutput><cf_tl id="Review"> #Topic.Description#</cfoutput></font></td></tr>
			<tr><td>
			<cfinclude template="Review/ReviewListing.cfm">
			</td></tr>
		</table>	
		</td></tr>
		
</cfif>					

</cfcase>

<cfcase value="Contact">

<cfif URL.Topic eq "All" or URL.Topic eq "Address">	
		
	<script language="JavaScript">
		
		function validate(sc) {
			var a = document.getElementById('addressprocess');
			document.forms['formaddress'].onsubmit();
			if( _CF_error_messages.length == 0 ) {   
			    if (sc == "") {                
					ptoken.navigate('Address/AddressEntrySubmit.cfm?id=#url.id#','addressprocess','','','POST','formaddress')
				} else {
					ptoken.navigate('Address/AddressEditSubmit.cfm?id=#url.id#&id1='+sc,'addressprocess','','','POST','formaddress')
				}
			}   
			
		}
		
	</script>

	<tr><td valign="top">
   	<table width="#w#" border="0" cellspacing="0" cellpadding="0" align="center" class="regular">
	
	    <tr class="hide"><td id="addressprocess"></td></tr>
		<tr><td id="addressbox">
			 <cfset URL.edit = "edit">
		     <cfinclude template="Address/Address.cfm">					
		</td></tr>
		
	</table>
	</td></tr>	
			
</cfif>

<cfif URL.Topic eq "All" or URL.Topic eq "References">				
	
		<tr><td valign="top">
		<table width="#w#" border="0" cellspacing="0" cellpadding="0" align="center" id="references" class="regular">
		<tr><td>
		    <cfinclude template="References/References.cfm">			
		</td></tr>
		</table>	
		</td></tr>
		
</cfif>		
		
</cfcase>	


<cfcase value="Profile">   	
	
	<cfif Candidate.ApplicantClass eq "4">
		
	       <!--- check if candidate has a profile --->
		   
		   <cftry>
						
			<cfquery name="insert" 
					datasource="AppsSelection">
						INSERT INTO ApplicantInquiryLog 
						(PersonNo, 
						 NodeIP, 
						 HostSessionNo, 
						 PHPSection, 
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
						VALUES 
						('#URL.ID#',					 
						 '#CGI.Remote_Addr#', 
						 '#CLIENT.sessionNo#', 
						 'PHP',
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')
				</cfquery>
				
				<cfcatch></cfcatch>	
				
			</cftry>	
		   
		   <cfquery name="Customer" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Customer
				WHERE     PersonNo = '#url.id#' 				
			</cfquery>
						
			<cfif customer.recordcount eq "1">
				
			    <tr><td height="100%" valign="top">	
			    <table height="100%" width="#w#" align="center" class="show formpadding" id="attach" bgcolor="white">
				
				<tr><td height="100%">
				
					<cfset url.personno = url.id>
					<cfset url.mission = Customer.mission>
					<cfset url.entryScope = "BackOffice">
					<cfinclude template="../../../WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Action/ActionListing.cfm">				     
					
				</td></tr>
				</table>	
				</td></tr>	
				
			 <cfelse>
			 
				<tr><td height="100%" valign="top">	
				
			    <table width="#w#" align="center" border="0" cellpadding="0" cellspacing="0" class="show formpadding" id="attach" bgcolor="white">
				
				<tr><td class="labellarge" align="center" style="padding-top:25px;padding-bottom:20px">
							     			
					<cfif customer.recordcount eq 0>
						<font color="red"><b><cf_tl id="Attention"></b>:<font color="gray"><cf_tl id="No customer profile found"></font>
					<cfelse>
						<font color="red"><b><cf_tl id="Attention"></b>:<font color="gray"><cf_tl id="There are"> #customer.recordcount# <cf_tl id="customer profiles associated to the candidate"></font>
					</cfif>							

				</td></tr>
				
				<cfset url.personno = url.id>			
				<cfinclude template="../../../System/Organization/Customer/Entity/Entity.cfm">
		
				</table>	
				</td></tr>				
			
			</cfif>
	
	<cfelse>
						
		<cfquery name="Skill"
		         datasource="AppsSelection"
		         username="#SESSION.login#"
		         password="#SESSION.dbpw#">
		         SELECT *
		         FROM Ref_ParameterSkill
				 <cfif URL.Topic neq "All">
				 WHERE Code = '#URL.Topic#'
				 </cfif>
				 ORDER BY ListingOrder
			    </cfquery>		
						
				<cfif URL.Topic eq "All">	
				
					<tr><td valign="top" height="100%">
						 
					<table width="99%" height="100%" border="0" cellpadding="0" cellspacing="0" align="center">
							
					<tr><td class="labelmedium" style="height:1px;padding-left:5px">								
						<cf_ProfileSource PersonNo = "#url.id#" showall="Yes">									
						</td>
					</tr>	
					
					<cfif url.source eq "">
					
					<tr><td valign="top" style="padding-top:7px" class="linedotted labelmedium" align="center"><font color="0080C0">No active submissions found</td></tr> 	
					
					<cfelse>
							
						<tr><td class="linedotted"></td></tr> 	 
							  
					    <tr><td valign="top" align="center" height="100%" style="padding-left:20px">
								 		
							<cftry>
						
							<cfquery name="insert" 
									datasource="AppsSelection">
										INSERT INTO ApplicantInquiryLog 
											(PersonNo, 
											 NodeIP, 
											 HostSessionNo, 
											 PHPSection, 
											 OfficerUserId,
											 OfficerLastName,
											 OfficerFirstName)
										VALUES 
										('#URL.ID#',					 
										 '#CGI.Remote_Addr#', 
										 '#CLIENT.sessionNo#', 
										 'PHP',
										 '#SESSION.acc#',
										 '#SESSION.last#',
										 '#SESSION.first#')
								</cfquery>
								
								<cfcatch></cfcatch>	
								
								</cftry>	
												
								<cf_securediv bind="url:GeneralTab.cfm?id=#url.id#&topic=#url.topic#&source={source}" id="tabs">							
												
						</td></tr>
					
					</cfif>
					
					</table>
					
					</td></tr>
						
				<cfelse>
						
						<cfloop query="skill">						
									
						<tr><td valign="top">	    						
							<table width="99%" height="100%" align="center">
							<tr><td id="#lcase(code)#box" valign="top" style="padding-left:4px">				
							<cfinclude template="#template#"></td>
							</tr>
							</table>
						</td></tr>
						
						</cfloop>			
				
				</cfif>
				
		</cfif>		
		
		<cfif CLIENT.Submission eq "MANUAL">
						
	    <cfif URL.Topic eq "All">
				
			<cfif SESSION.isAdministrator eq "Yes" and SESSION.isOwnerAdministrator neq "No">
		
			<cfquery name="Own" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT Owner
			   FROM   Ref_ParameterOwner
			   WHERE  Operational = 1
			   <!---
			   AND    Owner IN (SELECT Owner 
			                    FROM   Ref_Assessment)
								--->
			   
			</cfquery>
						
			<cfelse>
		
			<cfquery name="Own" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    DISTINCT ClassParameter as Owner
				FROM      OrganizationAuthorization
				WHERE     UserAccount = '#SESSION.acc#' 
				AND       Role IN ('AdminRoster', 'RosterClear')
				AND       ClassParameter IN (SELECT Owner 
				                             FROM   Applicant.dbo.Ref_ParameterOwner 
											 WHERE  Operational = 1)
			</cfquery>
		
			</cfif>
						
			<cfloop query="Own">
			
			<tr><td valign="top">	
			
			<table width="#w#" align="center" class="show" id="attach" bgcolor="white">
				<tr><td height="22" style="padding-left:20px;padding-right:10px">	
						
				    <cfset url.owner = owner>
					<cfset url.memo  = 0>					
					<cfinclude template="Attachments/DocumentFileForm.cfm">			    
					
				</td></tr>
				</table>	
			</td></tr>	
				
			</cfloop>									
						
		</cfif>	
				
	</cfif>
	
</cfcase>		

<cfcase value="Vacancy">

	<cfif URL.Topic eq "All" or URL.Topic eq "inspira">	
		
		<tr><td valign="top">
		<table width="#w#" id="shortlist"  border="0" bgcolor="white"  align="center" cellpadding="0" class="formpadding">
		<tr><td class="labelmedium">
			<cfinclude template="Vactrack/CandidateSourceApplication.cfm">			
		</td></tr>
		</table>	
		</td></tr>				

	</cfif>

	<cfif URL.Topic eq "All" or URL.Topic eq "Candidacy">	
	
		<tr><td valign="top">
		<table width="#w#" id="shortlist" align="center" class="regular"  border="0" bgcolor="white" cellpadding="0" cellspacing="0" bordercolor="silver">
		<tr><td>			
		        <cfinclude template="Functions/ApplicantFunction.cfm">
		</td></tr>
		</table>	
		</td></tr>				

	</cfif>

	<cfif URL.Topic eq "All" or URL.Topic eq "Shortlist">	
		
		<tr><td valign="top">
		<table width="#w#" id="shortlist" align="center" class="regular"  border="0" bgcolor="white" cellpadding="0" cellspacing="0" bordercolor="silver">
		<tr><td>
		        <cfinclude template="Vactrack/CandidatePost.cfm">
		</td></tr>
		</table>	
		</td></tr>				

	</cfif>
	
	<cfif URL.Topic eq "All" or URL.Topic eq "selected">	
		
		<tr><td valign="top">
		<table width="#w#" id="shortlist"  border="0" bgcolor="white"  align="center" cellpadding="0" class="formpadding">
		<tr><td>
		     <cfinclude template="Vactrack/CandidatePost.cfm">
		</td></tr>
		</table>	
		</td></tr>				

	</cfif>
	
	<cfif URL.Topic eq "All" or URL.Topic eq "offer">	
	
		<tr><td valign="top">
		<table width="#w#" id="shortlist"  border="0" bgcolor="white"  align="center" cellpadding="0" class="formpadding">
		<tr><td>
		     <cfinclude template="Vactrack/CandidateOffer.cfm">
		</td></tr>
		</table>					
		</td></tr>
		
	</cfif>
	
</cfcase>	
		  
</cfswitch>

</cfoutput>

</table>
