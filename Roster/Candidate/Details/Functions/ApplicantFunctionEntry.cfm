
<cfparam name="url.scope"  default="profile">  
<cfparam name="url.source" default="">  

<cf_dialogstaffing>

<cfif url.scope eq "profile">
	
	<cf_screentop height="100%" 
		  scroll="Yes" 
		  user="yes" 
		  bannerheight="55" 
		  jquery="Yes"
		  banner="gray" 
		  line="no"
		  html="No"
		  label="Function Entry" 
		  layout="webapp"> 

</cfif>	  
	  
<cfquery name="getEdition" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Ref_SubmissionEdition S
		 WHERE  SubmissionEdition = '#url.id1#'				
</cfquery>

<cfif getEdition.EnableManualEntry eq "1">
					    
	   <cfinvoke component="Service.AccessGlobal"  
	      method      = "global" 
		  role        = "AdminRoster" 
		  parameter   = "#getEdition.Owner#"
		  returnvariable="Access">
	  
	  	<cfif Access eq "EDIT" or Access eq "ALL" >
	  
	    <cfelse>
		
			No access granted
			<cfabort>
			
	 	 </cfif>	
		 
</cfif> 	
	 	
<script language="JavaScript">
	
	function hl(fld,row,grp){
	
		 itm = document.getElementById("row"+row)
		 occ = document.getElementById(grp+"Min")
	 		 	 		 	
		 if (fld != false){		
		 itm.className = "highLight2";				 
		 }else{		 
		 itm.className = "regular";			    	 
		 }
	  }	  
	  
	function expand(cls) {	
		if ($('.'+cls).is(':visible'))	{	   
			$('.'+cls).hide()		
		} else {
			$('.'+cls).show()			
		}		
	}
	
	function validate(){
	
		var functionSelected = false;
		$('input[type="checkbox"]').each(function() {
		    if ($(this).attr("name") == "FunctionId" && $(this).is(":checked")) {
		        functionSelected = true;
		    }
		});
		
		if (!functionSelected){
			alert('Please select a bucket in order to submit candidacy.');
			return false;
		}
		
		return true;
	}

</script>


<cfinclude template="../Applicant/Applicant.cfm">

<cfparam name="URL.ID" default="0000">

<cfset FileNo = round(Rand()*100)>

<CF_DropTable dbName="AppsQuery" tblName="v#SESSION.acc#Roster#FileNo#">

<!--- check for full listing in default roster to select --->

<!--- add to defualt roster in case 
a. function is roster function 
b. function is not enabled for manual entry in another edition
c. function is part of an edition that is enabled
d. does not exist in the default roster yet --->

<cfquery name="Edition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_SubmissionEdition
	WHERE  SubmissionEdition = '#URL.ID1#' 
</cfquery>

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ParameterOwner
	WHERE   Owner = '#Edition.Owner#' 
</cfquery>

<cfquery name="Roster" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  DISTINCT FunctionNo, OrganizationCode, GradeDeployment
	INTO 	userQuery.dbo.v#SESSION.acc#Roster#FileNo#
	FROM    FunctionOrganization
	WHERE   SubmissionEdition = '#Parameter.DefaultRoster#'
</cfquery>

<cfif Parameter.DefaultRosterAdd eq "1">
	
	<cfquery name="Roster" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO FunctionOrganization
		       (FunctionNo, OrganizationCode, GradeDeployment, SubmissionEdition, ReferenceNo, Status, OfficerUserId, OfficerLastName, OfficerFirstName)
		SELECT DISTINCT F1.FunctionNo, 
		                F1.OrganizationCode, 
						F1.GradeDeployment, 
						'#Parameter.DefaultRoster#' as SubmissionEdition,
						'Direct',
						'1',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
		FROM      FunctionOrganization F1 INNER JOIN
		          Ref_SubmissionEdition S ON F1.SubmissionEdition = S.SubmissionEdition LEFT OUTER JOIN
		          userQuery.dbo.v#SESSION.acc#Roster#FileNo# F2 ON F1.FunctionNo = F2.FunctionNo AND F1.OrganizationCode = F2.OrganizationCode AND 
		          F1.GradeDeployment    = F2.GradeDeployment
		WHERE     F1.SubmissionEdition != '#Parameter.DefaultRoster#'
		AND       S.Owner               = '#Edition.Owner#'
		AND       S.EnableManualEntry   = 1
		AND       S.EnableAsRoster      = 1
		AND       F1.FunctionNo IN (SELECT FunctionNo 
		                            FROM   FunctionTitle 
									WHERE  FunctionRoster = '1' and FunctionNo = F1.FunctionNo)
		GROUP BY F1.FunctionNo, F1.OrganizationCode, F1.GradeDeployment, F2.FunctionNo
		HAVING     F2.FunctionNo IS NULL
	</cfquery>

</cfif>

<!--- make listing for this person by excluding existing selections if not '9' --->

<cfquery name="FunctionAll" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT DISTINCT R.*, M.Meaning, M.FunctionNo as Curr
	
	FROM   vwFunctionOrganization R LEFT OUTER JOIN  
	
	       (SELECT DISTINCT F1.FunctionNo, 
		                    F1.OrganizationCode, 
							F1.GradeDeployment, 
							R.Meaning
							
			FROM   ApplicantFunction M,
			       ApplicantSubmission S,
				   FunctionOrganization F1,
				   Ref_StatusCode R
				   
			WHERE  S.PersonNo          = '#URL.ID#'
			AND    S.ApplicantNo       = M.ApplicantNo
			AND    F1.FunctionId       = M.FunctionId
			AND    R.Id                = 'FUN'
			AND    R.Status            = M.Status
			AND    M.Status NOT IN ('5','9')
 			AND    F1.SubmissionEdition = '#URL.ID1#' 
		 ) as M	 
		 
		 ON    M.FunctionNo       = R.FunctionNo 
		   AND M.OrganizationCode = R.OrganizationCode 
		   AND M.GradeDeployment  = R.GradeDeployment	
	
	WHERE  SubmissionEdition = '#URL.ID1#' 
	
	<cfif Parameter.DefaultRoster eq "#URL.ID1#">
		AND   R.FunctionRoster = '1'
		AND   R.ReferenceNo IN ('Direct','direct')
	</cfif>
	
	<!---
	AND    FunctionId NOT IN (SELECT FunctionId FROM ApplicantFunction M,
			       ApplicantSubmission S WHERE  S.PersonNo      = '#URL.ID#'
			                             AND    S.ApplicantNo    = M.ApplicantNo
                           			     AND    R.Status NOT IN ('5','9'))
										 --->
	ORDER BY OccupationGroupDescription, 
	         OrganizationDescription, 
			 HierarchyOrder, 
			 ListingOrder, 
			 FunctionDescription
		
</cfquery>

<CF_DropTable dbName="AppsQuery" tblName="v#SESSION.acc#Roster#FileNo#">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">


<!--- Check if there is a submission worfklow defined for this edition --->
<cfif Edition.EntityClass neq "">

	<cfoutput>		

		<cfquery name="Submission" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   ApplicantSubmission
			WHERE  PersonNo = '#URL.ID#'
			AND    SubmissionEdition = '#URL.ID1#'
			AND    Source = '#URL.Source#'
		</cfquery>
		
		<cfif Submission.recordcount eq 1>
		
  			 <cfset url.ajaxid = Submission.ApplicantNo>
			
			   <input type="hidden" 
			   name="workflowlink_#URL.ajaxid#" 
			   id="workflowlink_#URL.ajaxid#" 				   
			   value="../Applicant/ApplicantSubmissionWorkflow.cfm">		
			   
			   <tr><td class="linedotted">&nbsp;</td></tr>
			   
			   <tr class="linedotted">
			   	<td class="labellarge"> <i>Submission Workflow</i> </td>
			   </tr>	
			   							
			   <tr>
				  <td id="#URL.ajaxid#" style="padding-left:25px;">	
				    <cfinclude template="../Applicant/ApplicantSubmissionWorkflow.cfm">					  
				  </td>
			   </tr>		
	
		<cfelse>
			<tr>
				<td>
					<cf_message message = "Alert: Applicant Submission could not be determined for this candidate.">
			   </td>
			</tr>
		</cfif>
	
	</cfoutput>

</cfif>

<tr class="linedotted">
   	<td class="labellarge" style="padding-top:15px;"> Nominations</td>
</tr>	

<tr><td style="padding-left:25px;">

<form action="<cfoutput>#client.root#</cfoutput>/Roster/Candidate/Details/Functions/ApplicantFunctionEntrySubmit.cfm?<cfoutput>scope=#url.scope#</cfoutput>" method="POST" name="applicantentry"> 

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<cfoutput>  
	<input type="hidden" name="PersonNo" value="#URL.ID#">
	<input type="hidden" name="Edition"  value="#URL.ID1#">	
</cfoutput>

<!--- -----------------------------------------------------------  --->
<!--- check the default source through the user or the background  --->
<!--- -----------------------------------------------------------  --->

<cfquery name="CheckOcc" dbtype="query">
	SELECT DISTINCT OccupationGroupDescription
	FROM FunctionAll 
</cfquery>

<cfset showOcc = 0>
<cfif CheckOcc.RecordCount gte 8>
	<cfset showOcc = 1>
</cfif>

<TR>
    <td height="20" class="labelit" style="padding-left:3px">
		<cfif CheckOcc.recordcount gt 8> <cf_tl id="Area"> </cfif>
	</td>
	<TD class="labelit"><cf_tl id="No"></TD>
    <TD class="labelit"><cf_tl id="Function"></TD>
    <TD class="labelit"><cf_tl id="Level"></TD>
	<TD class="labelit"><cf_tl id="Reference"></TD>
	<td class="labelit" width="20"><cf_tl id="Select"></td>
</TR>
<tr><td colspan="6" class="linedotted"></td></tr>

<cfoutput query="FunctionAll" group="OccupationGroupDescription">
	
	<cfquery name="check" dbtype="query">
	SELECT  * 
	FROM    FunctionAll
	WHERE   OccupationGroupDescription = '#OccupationGroupDescription#'
	AND     Curr > ''
	</cfquery>
	
	<cfif showOcc eq 1 and check.recordcount eq 0>
		<cfset clGroup = "regular">
		<cfset clDetail = "hide">
	<cfelse>
		<cfset clGroup = "hide">
		<cfset clDetail = "show">
	</cfif>
	
	<tr class="#clGroup#"><td colspan="6">
		
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		<td width="20" style="padding-top:2px">
			<cf_img icon="expand" toggle="yes" onclick="javascript:expand('#OccupationalGroup#')">
		</td>
		<td class="labelmedium">#OccupationGroupDescription#</td>
		</tr>
		</table>
		
	</td></tr>			

	<cfoutput group="OrganizationDescription">
		
		<cfif showOcc eq 1>
		<TR class="#OccupationalGroup# #clDetail#"><td>
		    </td>
		    <td colspan="5" class="labelmedium">#OrganizationDescription#</b></td>
		</tr>
		</cfif>
		
		<CFOUTPUT>
				
			<cfif Curr eq "">
			<TR class="labelit #OccupationalGroup# #clDetail#" id="row#currentrow#" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
			    <TD style="height:17" width="5%"></TD>
				<TD>#FunctionNo#</TD>
			    <TD>
					<cfif AnnouncementTitle neq "">
						#AnnouncementTitle#
					<cfelse>
						#FunctionDescription#
					</cfif>
				</TD>
			    <TD>#GradeDeployment#</TD>
				<TD>#ReferenceNo#</TD>
				<td align="center" style="padding-right:4px">				
					<input type="checkbox" class="radiol" name="FunctionId" value="#FunctionId#" onClick="javascript:hl(this.checked,'#currentrow#','#OccupationalGroup#')" <cfif Curr neq "">checked</cfif>>				
				</TD>
			</TR>
			<cfelse>
			<TR class="labelit #OccupationalGroup# #clDetail#" bgcolor="ffffcf">
			    <td height="20"></td>
				<TD>#FunctionNo#</TD>
			    <TD><cfif AnnouncementTitle neq "">
						#AnnouncementTitle#
					<cfelse>
						#FunctionDescription#
					</cfif></TD>
			    <TD>#GradeDeployment#</TD>
				<TD>#ReferenceNo#</TD>
				<td align="center">#Meaning#</TD>
			</TR>
			</cfif>
			
		</CFOUTPUT>
	
	</CFOUTPUT>

<tr><td colspan="6" class="linedotted"></td></tr>

</CFOUTPUT>

<tr><td height="6"></td></tr>
<tr><td height="3" colspan="6" style="padding-left:5px">
   
    <table cellspacing="0" align="center" class="formspacing">
		<tr>
		
		<cfoutput>	
		
		    <cfif url.scope eq "entry">
			
				<input type="hidden" name="Source" value="#url.source#">
			
				<td><input type="submit" 
							style="width:160;height:25;" 
							name="Submit" 
							value="Submit Candidacy" 
							onclick="return validate();"
							class="button10g"></td>
							
				<td><input style="width:150;height:25;" class="button10g" type="button"  name="remove" value="Remove Candidate" onclick="purgecandidate('#url.id#')"></td>
				<td><input class="button10g" style="width:150;height:25;" type="button"  name="remove" value="New Candidate" onclick="newcandidate('#url.id#')"></td>
				
				
			<cfelse>
							
				<td class="labelmedium" style="padding-right:6px"><i><b>Add candidacy for profile:</td>
				
				<td>
							
					<cf_ProfileSource PersonNo= "#url.id#" Selected="#url.source#" ShowAll="Yes" label="">
					
				</td>							
				
				<td>	
				
				<input type="submit" style="width:120;height:27;" name="Submit" value="Submit" class="button10g">
				
				</td>
				
			
			</cfif>	
			
		</cfoutput>	
		
		</tr>
		
	</table>
</td></tr>

<tr><td colspan="6" class="linedotted"></td></tr>

</table>

</FORM>

</td></tr>

</table>
