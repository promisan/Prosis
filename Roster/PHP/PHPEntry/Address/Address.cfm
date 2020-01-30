<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes">

<cf_param name="url.ApplicantNo" default="" type="String">	
<cf_param name="url.owner" 		 default="" type="String">	
<cf_param name="url.mission" 	 default="" type="String">	
<cf_param name="url.section" 	 default="" type="String">	
<cf_param name="url.id1" 	 default="" type="String">	

<cfajaximport tags="cfform,cfmap">

<cf_uiGadgets gadget="notification">
<cf_windowNotification>
<cf_mapscript>
<cf_dialogstaffing>

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   S.PersonNo, S.Source
	FROM     Applicant A, 
	         ApplicantSubmission S
	WHERE    A.PersonNo = S.PersonNo
	AND      S.ApplicantNo = '#URL.ApplicantNo#'
</cfquery>

<cfset url.id    	  = Get.PersonNo>
<cfset url.entryScope = "Portal">
<cfset URL.edit  	  = "edit">

<cfoutput>
	
<script language="JavaScript">
		
	function validate(sc) {
		var a = document.getElementById('addressprocess');
		document.forms['formaddress'].onsubmit();
		if(!_CF_error_exists) {   
		    if (sc == "") {                
				ColdFusion.navigate('#SESSION.root#/Roster/Candidate/Details/Address/AddressEntrySubmit.cfm?applicantno=#url.applicantno#&mission=#url.mission#&owner=#url.owner#&section=#url.section#&id=#url.id#&entryScope=Portal','addressprocess','','','POST','formaddress')
			} else {
				ColdFusion.navigate('#SESSION.root#/Roster/Candidate/Details/Address/AddressEditSubmit.cfm?applicantno=#url.applicantno#&mission=#url.mission#&owner=#url.owner#&section=#url.section#&id=#url.id#&entryScope=Portal&id1='+sc,'addressprocess','','','POST','formaddress')
			}
		}   			
	}
		
	function show_error(form, ctrl, value, msg)	{
		Prosis.notification.show('Error', msg, 'error', 2500); //error, success, information		
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

<table width="100%" height="100%">
	
	<tr class="hide">
		<td id="addressprocess"></td>
	</tr>
	
	<tr>		
		<td height="100%" width="100%" id="addressbox" valign="top">
			
			<table height="100%" width="100%">
				<tr>
					<td height="100%" valign="top" style="padding:20px">
						<cfinclude template="../../../Candidate/Details/Address/Address.cfm" >
					</td>
				</tr>
				
				<tr>
					<td height="40" class="linedotted" style="padding-top:20px;">	
						
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
			 				SectionTable  = "Ref_ApplicantSection"
			 				Section       = "#URL.Section#"
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