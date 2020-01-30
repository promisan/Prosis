<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>SAT CHANGE</proDes>
	<proCom>SAT CHANGE</proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cf_screentop html="No" jquery="Yes">
<cf_uiGadgets gadget="notification">
<cf_windowNotification marginTop="-15px">
<cf_pictureProfileStyle>
<cf_dialogStaffing>

<cfparam name="URL.Next"          default="Default">
<cfparam name="URL.ApplicantNo"   default="">
<cfparam name="URL.ID"            default="">
<cfparam name="URL.Code"          default="">
<cfparam name="URL.Section"       default="">
<cfparam name="URL.Action"        default="Edit">

<cfparam name="url.Scope"         default="">
<cfparam name="url.Owner"         default="">
<cfparam name="url.Class"         default="0">
<cfparam name="URL.Mission"       default="">
<cfparam name="URL.parent"        default="Miscellaneous">

<cfquery name="Section" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ApplicantSection
	WHERE    Code = '#URL.Section#' 
</cfquery>


<cfparam name="URL.entrymode"              default="#section.TemplateCondition#">

<!--- harcoding Hanno 21/11/2015 --->
<cfif url.mission eq "EAD">
	<cfset URL.entrymode = "Standard">
</cfif>

<cfset row = 0>

<cfquery name="PHPParameter" 
  datasource="AppsSelection" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT   TOP 1 *
	  FROM     Parameter
</cfquery>

<cfquery name="Get" 
  datasource="AppsSelection"  
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT  *, 
	        S.Source AS SubmissionSource
	FROM    Applicant A, 
	        ApplicantSubmission S
	WHERE   A.PersonNo    = S.PersonNo
	AND     S.ApplicantNo = '#url.ApplicantNo#' 
</cfquery>

<cfquery name="Nation" 
  datasource="AppsSystem"  
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
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

<table bgcolor="FFFFFF" style="width:100%;height:100%"><tr><td bgcolor="FFFFFF" height="100%">

	<cfform onsubmit="return false"  name="entry"  style="width:100%;height:100%">
	  
		<cfoutput>
		
		<input type="hidden" name="SubmissionSource" value="#get.SubmissionSource#">
		<input type="hidden" name="CandidateStatus"  value="#get.CandidateStatus#">
	    <input type="hidden" name="Mode"             value="#URL.Action#">		
		<input type="hidden" name="Mission"          value="#URL.Mission#">
			
		<cf_divscroll>
			
		<table width="95%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		
			<tr>
			<td height="35">
					
			<cfif URL.action eq "Create">	
													
				<table width="100%">
					<tr><td height="17"></td></tr>
					<tr><td align="left" style="height:60px;font-size:29px" class="labellarge">&nbsp;
						<cfif url.scope neq "BackOffice">
						<cf_tl id="My Profile"> - <cf_tl id="Request an Account">				
						<cfelse>
						<cf_tl id="Create Profile">	
						</cfif>
						
					</td></tr>
					
				</table>
				
				 <cf_assignid>
				 <cfset submissionid = rowguid>
				 
			<cfelse>
			
				 <cfset submissionid = get.SubmissionId>	 
			
			</cfif>
			
			<input type="hidden" name="submissionid" value="#submissionid#">
						
			</td>
			
			</tr>	
										
			<tr>		
			    <td height="100%" valign="top" colspan="2" id="detailcontent" style="padding-left:20px">							
				 <cfinclude template="GeneralForm.cfm">						 										
				</td>			
			</tr>
											
			<cfif URL.Action eq "Create">	
			
				<tr>
				   <td colspan="3" align="center" style="padding-bottom:15px">
				   
				   <cf_assignid>
				   <cfset submissionid = rowguid>
				   
				   <cfsavecontent variable="myscript">
				   
				   document.entry.onsubmit(); 		  			  
					if(!_CF_error_exists) {					    
		           		ptoken.navigate('#SESSION.root#/Roster/PHP/PHPEntry/Inception/GeneralSubmit.cfm?public=#url.public#&scope=#url.scope#&parent=#url.parent#&entrymode=#url.entrymode#&action=#url.action#&mission=#url.mission#&owner=#url.owner#&applicantclass=#url.class#&applicantno=','detailcontent','','','POST','entry')
			       }   		   
				   
				   </cfsavecontent>
					   
				   <cf_tl id="Submit" var="1">
				   				  			             
				   <input style  = "width:240;height:30" 
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
				   <td height="40" colspan="3" align="right" valign="bottom">
				   				   				   													
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
