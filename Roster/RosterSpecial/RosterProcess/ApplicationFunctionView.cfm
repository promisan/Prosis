
<cf_screentop height="100%" 
    html="Yes" 
	layout="webapp" 
	banner="gray" 
	jquery="Yes" 
	line="no" 	
	scroll="no" 
	label="Process Roster Application">


<cf_UserProfilePictureContainer>

<script>

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
	 if (se.className == "regular") {
	  se.className  = "hide" ;
	 icM.className = "hide" ;
	 icE.className = "regular" ;	
	 } else {
	 se.className  = "regular" ;
	 icM.className = "regular" ;
	 icE.className = "hide" ;			
	 }
  }  
  
function submitkeywords(app,fun,own) {
    Prosis.busy('yes');
	_cf_loadingtexthtml='';	
	ptoken.navigate('<cfoutput>#session.root#</cfoutput>/Roster/RosterSpecial/RosterProcess/ApplicationFunctionSubmissionSubmit.cfm?applicantno='+app+'&functionid='+fun+'&owner='+own,'contentbox2','','','POST','edit')
}  
  
function refreshkeywords(app,fun,own) {
	_cf_loadingtexthtml='';	
	ptoken.navigate('<cfoutput>#session.root#</cfoutput>/Roster/RosterSpecial/RosterProcess/ApplicantFunctionSummary.cfm?id='+app+'&IDFunction='+fun+'&owner='+own,'dSummary')
}  


</script>  
	
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT F.*, 
	       FT.FunctionDescription,  
		   FO.GradeDeployment,
		   FO.DocumentNo,
		   FO.ReferenceNo,
		   FT.FunctionNo,
		   FT.OccupationalGroup,
		   R.Owner,
		   Ref_Organization.OrganizationDescription,
		   A.PersonNo,
		   A.LastName, 
		   A.FirstName, 
		   A.IndexNo,
		   A.eMailAddress,
		   A.DOB,
		   A.Gender,
		   A.PersonNo,
		   A.Nationality,
		   A.ApplicantClass
	FROM   ApplicantFunction F, 
	       FunctionOrganization FO, 
		   Ref_SubmissionEdition R,
		   Ref_Organization,
		   FunctionTitle FT, 
		   ApplicantSubmission S,
		   Applicant A
	WHERE S.ApplicantNo         = '#URL.ID#' 
	  AND A.PersonNo            = S.PersonNo
	  AND F.ApplicantNo         = S.ApplicantNo
	  AND F.FunctionId          = '#URL.ID1#'
	  AND R.SubmissionEdition   = FO.SubmissionEdition
	  AND F.FunctionId          = FO.FunctionId
	  AND FO.FunctionNo         = FT.FunctionNo
	  AND FO.OrganizationCode   = Ref_Organization.OrganizationCode 
</cfquery>

<!--- added to inherit relevant PHP data in case a new PHP was received from Inspira on the same
recordId --->

<cfinvoke component = "Service.Process.Applicant.Applicant"  
   method           = "SyncApplicantBackground" 
   PersonNo         = "#Get.PersonNo#">	   

<cfquery name="Steps" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_StatusCode
	WHERE  Owner = '#Get.Owner#'
	AND    Id = 'Fun'
	<!--- exclude outdated --->
	AND    Status != '5' 
</cfquery>

<cfquery name="Status" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   ApplicantAssessment
	WHERE  Owner = '#Get.Owner#'
	AND    PersonNo = '#Get.PersonNo#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterOwner
	WHERE Owner = '#Get.Owner#'
</cfquery>

<cfquery name="Employee" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 PersonNo, IndexNo
	FROM   Person
	WHERE  IndexNo = '#Get.IndexNo#'
</cfquery>
	   
<cfquery name="Organization" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    P.PersonNo, P.IndexNo, Org.OrgUnitName AS OrgUnitName, Org.Mission AS Mission
    FROM      PersonAssignment PA INNER JOIN
              Organization.dbo.Organization Org ON PA.OrgUnit = Org.OrgUnit INNER JOIN
              Person P ON PA.PersonNo = P.PersonNo AND PA.PersonNo = P.PersonNo
    WHERE     (PA.DateEffective <= GETDATE()) 
	AND (PA.DateExpiration >= GETDATE()) 
	AND (PA.AssignmentStatus IN ('0', '1')) 
	AND (PA.AssignmentClass = 'Regular')
	
	AND P.IndexNo = '#Employee.IndexNo#'
</cfquery> 
 
<cfquery name="Language" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   DISTINCT R.LanguageName
	FROM     dbo.ApplicantLanguage L, dbo.Ref_Language R
	WHERE    L.LanguageId = R.LanguageId
	AND      L.ApplicantNo = '#URL.ID#'  
	ORDER BY R.LanguageName
</cfquery>
	
<cftry>
   
	<cfquery name="LastGrade" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	    FROM stPersonContract
	    WHERE IndexNo = '#Get.IndexNo#'
	</cfquery>

	<cfcatch>
	
		 <cfquery name="LastGrade" 
		    datasource="AppsEmployee" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT  TOP 1 *
			FROM    PersonContract
			WHERE   PersonNo IN (SELECT PersonNo FROM Person WHERE IndexNo = '#Get.IndexNo#')
			ORDER BY DateEffective DESC
		</cfquery> 
		
	</cfcatch>

</cftry>

<cfinvoke component="Service.Access"  
  method="Bucket" 
  role="RosterClear" 
  functionId="#URL.IDFunction#"
  level="1"
  returnvariable="Access1">
  
<cfinvoke component="Service.Access"  
  method="Bucket" 
  role="RosterClear" 
  functionId="#URL.IDFunction#"
  level="2"
  returnvariable="Access2">   	
  
<!--- last sumitted competence --->

<cfparam name="URL.Box" default="">
<cfparam name="URL.Mode" default="0">
<cfparam name="URL.Print" default="0">

<cfajaximport tags="cfform,cfdiv">

<cf_ActionListingScript>
<cf_FileLibraryScript>	
<cf_DialogStaffing>  

<cfinclude template="ApplicationFunctionEditScript.cfm">
  
<cfif Get.Recordcount eq "0">
	<cf_message message="Candidacy record could not be located">
	<cfabort>
</cfif>	
	
<cf_LayoutScript>
<cf_keywordEntryScript>
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

    <!--- move to center 
	
	<cf_layoutarea position="header" name="header" minsize= "80px" maxsize="80px" size="80px">
	
		 <table width="100%" bgcolor="ffffff">
		   <tr><td colspan="2" style="padding:4px">
		     <table width="100%">		
		     <tr><td colspan="2" style="border:0px solid silver;padding:3px;-moz-border-radius:3px;border-radius:3px;padding-top:7px;padding-left:15px;padding-right:10px;padding-bottom:6px">  	 
			    <cfinclude template="ApplicationFunctionEditCandidate.cfm">	
			<td>
		    </tr>
			</table>
		    </td>
		  </tr>	
		  </table>
							
	</cf_layoutarea>	
	
	--->
		
	<cf_layoutarea position="center" name="box" maxsize= "800" size="60%" minsize="800">				
			<cfinclude template="ApplicationFunctionEdit.cfm">	
	</cf_layoutarea>	
	
	<cf_layoutarea 
	    position    = "right" 
		name        = "treebox" 
		maxsize     = "800" 		
		size        = "430" 
		minsize     = "430"
		collapsible = "true" 
		splitter    = "true"
		overflow    = "scroll">
		
			<div id="dSummary">
				<cfset URL.Owner = "#Get.Owner#">
				<cfinclude template="ApplicantFunctionSummary.cfm">	
			</div>	
				
	</cf_layoutarea>		
		
</cf_layout>
