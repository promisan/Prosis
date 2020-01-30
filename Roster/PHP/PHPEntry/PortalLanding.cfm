
<cf_PreventCache>

<cfparam name="Client.appPersonNo" default="">

<cfif client.appPersonNo eq "">
    <cfabort>
</cfif>

<cf_dialogStaffing>

<script language="JavaScript">
   
 function profile() {
   location = "../PHPEntry/PHPProfile.cfm"
 }
 
 function bucket() {
   location = "../Apply/Buckets.cfm?menu=profile"
 }
 
 function summary() {
   location = "../PHP/PHPSummary.cfm"
 }
  
</script>

<title>PHP Portal</title>

<cfquery name="Parameter" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Parameter
</cfquery>

<cfparam name="URL.Scope"          default="regular">
<cfparam name="URL.menu"           default="intro">
<cfparam name="SESSION.login" default="">

<cfparam name="URL.Code"        default="0">
<cfparam name="URL.k"           default="">
<cfparam name="URL.ID"          default="PHP">
<cfparam name="URL.ID1"         default="{00000000-0000-0000-0000-000000000000}">

<cfset CLIENT.submission    = Parameter.PHPEntry>

</head>

<cfoutput>

<cf_LoginTop FunctionName = "PHP">
  
<table width="96%" align="center" cellspacing="0" cellpadding="0">
<tr><td>
	<cfinclude template="PHPBanner.cfm"> 
</td></tr>

<tr>
<td valign="top" height="100%">

<table width="100%">

  	   <cfquery name="Applicant" 
		datasource="AppsSelection">
			SELECT *
			FROM   Applicant
			WHERE  PersonNo = '#CLIENT.AppPersonNo#' 
		</cfquery>		
		
		<tr><td>
		<cfinclude template="PHPProfileIntro.cfm">
		</td></tr>
		
	   <cfoutput>
	   	   
	   <cfif Applicant.CandidateStatus eq "0">
	   
	   		<tr><td align="center" height="50"><font size="2" color="FF0000"><u>We are sorry but your account is currently not available. Please contact #SESSION.welcome#</td></tr>
	   
	   <cfelse>
		
		   <tr><td>
		   <table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		 	   
		   <tr>
		   <td width="20">		  	  
		   
		   <img src="#SESSION.root#/Images/bullet.png" alt="" border="0" align="absmiddle">
		   		   
		   </td>
		   <td><a href="javascript:profile()"><b><cf_tl id="My Profile"></a></td>		
		   </tr>
		   <tr><td></td><td>Update your Personal Background Profile</td></tr>
		   
		   <tr>
		   <td><img src="#SESSION.root#/Images/bullet.png" alt="" border="0" align="absmiddle"></td>
		   <td><a href="javascript:summary()"><b><cf_tl id="Skill Summary"></a></td>
		   </tr>
		   <tr><td></td><td>A summary of your Profile based on submitted Keywords</td></tr>
		   
		   <tr>
		   <td><img src="#SESSION.root#/Images/bullet.png" alt="" border="0" align="absmiddle"></td>
		   <td><a href="javascript:bucket()"><b><cf_tl id="Application Agent"></a></td>
		   </tr>
		   <tr><td></td><td>Review jobs that match your profile and submit your application</td></tr>
		   
		   </table>
		   </td>
		   </tr>
		   
		  </cfif> 
	   
	   </cfoutput>	
	   
</table>

</td>
</table>

<cf_LoginBottom FunctionName = "PHP">

</cfoutput>
