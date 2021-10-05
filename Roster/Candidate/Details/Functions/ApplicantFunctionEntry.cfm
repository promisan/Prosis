
<cfparam name="url.scope"    default="profile">
<cfparam name="url.source"   default="">

<cfif url.scope eq "profile">

	<cf_dialogstaffing>

	<cf_screentop height="100%"
			scroll="Yes"
			user="yes"
			jquery="Yes"
			banner="gray"
			line="no"
			html="No"
			label="Function Entry"
			layout="webapp">

</cfif>

<cfif url.scope eq "Profile">

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

</cfif>

<script language="JavaScript">

	function hl(fld,row,grp){

		itm = document.getElementById("row"+row)
		occ = document.getElementById(grp+"Min")

		if (fld != false){
			itm.className = "labelmedium line highLight2";
		}else{
			itm.className = "labelmedium line";
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

<cfif url.scope neq "vactrack">

	<cfinclude template="../Applicant/Applicant.cfm">

</cfif>

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

<cfif Parameter.DefaultRosterAdd eq "1">

<!--- Hanno : the sole purpose of this is sync any qualifying buckets from this
owner to the default roster under DIRECT (no VA related)
and use this to manage candidates in general to be rostered in general. --->

	<cfquery name="Roster"
			datasource="AppsSelection"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		SELECT  DISTINCT FunctionNo, OrganizationCode, GradeDeployment
		INTO 	userQuery.dbo.v#SESSION.acc#Roster#FileNo#
		FROM    FunctionOrganization
		WHERE   SubmissionEdition = '#Parameter.DefaultRoster#'
	</cfquery>

	<cfquery name="Roster"
			datasource="AppsSelection"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		INSERT INTO FunctionOrganization
		(FunctionNo, OrganizationCode, GradeDeployment, SubmissionEdition, ReferenceNo, Status, OfficerUserId, OfficerLastName, OfficerFirstName)
		SELECT     DISTINCT F1.FunctionNo,
		F1.OrganizationCode,
		F1.GradeDeployment,
		'#Parameter.DefaultRoster#' as SubmissionEdition,
	'Direct',
	'1',
	'#SESSION.acc#',
	'#SESSION.last#',
	'#SESSION.first#'
	FROM       FunctionOrganization F1 INNER JOIN
	Ref_SubmissionEdition S ON F1.SubmissionEdition = S.SubmissionEdition LEFT OUTER JOIN
	userQuery.dbo.v#SESSION.acc#Roster#FileNo# F2 ON F1.FunctionNo = F2.FunctionNo AND F1.OrganizationCode = F2.OrganizationCode AND
	F1.GradeDeployment    = F2.GradeDeployment
	WHERE      F1.SubmissionEdition != '#Parameter.DefaultRoster#'
	AND        S.Owner               = '#Edition.Owner#'
	AND        S.EnableManualEntry   = 1
	AND        S.EnableAsRoster      = 1
	AND        F1.FunctionNo IN (SELECT FunctionNo
	FROM   FunctionTitle
	WHERE  FunctionRoster = '1'
	AND    FunctionNo = F1.FunctionNo)
	GROUP BY   F1.FunctionNo, F1.OrganizationCode, F1.GradeDeployment, F2.FunctionNo
	HAVING     F2.FunctionNo IS NULL
	</cfquery>

</cfif>

<!--- make listing for this person by excluding existing selections if not '9' --->

<cfquery name="FunctionAll"
		datasource="AppsSelection"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">

	SELECT V.*,
	(SELECT TOP 1 RSPL.FunctionDescription FROM Ref_SubmissionEditionPosition RSP INNER JOIN
	Ref_SubmissionEditionPosition_Language RSPL ON RSP.PositionNo = RSPL.PositionNo
	AND RSP.SubmissionEdition = RSPL.SubmissionEdition
	WHERE RSPL.SubmissionEdition = V.SubmissionEdition
	AND RSP.reference=V.ReferenceNo
	AND RSPL.LanguageCode = '#client.LanguageId#'
) as CustomFunctionDescription,

(SELECT TOP 1 O.OrgUnitName FROM Ref_SubmissionEditionPosition RSP INNER JOIN
Employee.dbo.Position P ON P.PositionNo = RSP.PositionNo INNER JOIN
Organization.dbo.Organization AS O ON P.OrgUnitOperational = O.OrgUnit
WHERE RSP.SubmissionEdition = V.SubmissionEdition
AND RSP.reference=V.ReferenceNo
) as OrgUnitName,



(SELECT MAX(R.Status)
FROM   ApplicantFunction M,
ApplicantSubmission S,
Ref_StatusCode R

WHERE  S.PersonNo          = '#URL.ID#'
AND    S.ApplicantNo       = M.ApplicantNo
AND    R.Id                = 'FUN'
AND    R.Status            = M.Status
AND    M.FunctionId        = V.FunctionId
AND    R.ShowRosterSearch = 1  <!--- was AND    M.Status NOT IN ('5','9') out of roster or cancelled --->
	) as ApplicantFunctionStatus

	FROM   vwFunctionOrganization V

	WHERE  V.SubmissionEdition = '#URL.ID1#'

	<cfif Parameter.DefaultRoster eq "#URL.ID1#">
		AND   V.FunctionRoster = '1'
<!--- remove by hanno to enable for titles that are intended for the roster
AND   R.ReferenceNo IN ('Direct','direct')
--->
	</cfif>

<!---
AND    FunctionId NOT IN (SELECT FunctionId FROM ApplicantFunction M,
               ApplicantSubmission S WHERE  S.PersonNo      = '#URL.ID#'
                                     AND    S.ApplicantNo    = M.ApplicantNo
                                        AND    R.Status NOT IN ('5','9'))
                                     --->

	ORDER BY PostGradeBudget,
	OccupationGroupDescription,
	OrganizationDescription,
	HierarchyOrder,
	ListingOrder,
	FunctionDescription

</cfquery>


<CF_DropTable dbName="AppsQuery" tblName="v#SESSION.acc#Roster#FileNo#">

<table width="96%" align="center" class="formpadding">


<!--- Check if there is a submission worfklow defined for this edition --->

<cfif Edition.EntityClass neq "">

	<cfoutput>

		<cfquery name="Submission"
				datasource="AppsSelection"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT *
				FROM   ApplicantSubmission
				WHERE  PersonNo          = '#URL.ID#'
			AND    SubmissionEdition = '#URL.ID1#'
			AND    Source            = '#URL.Source#'
			ORDER BY Created DESC
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

<tr class="line">
<td class="labellarge" style="font-size:20px;height:35px;padding-top:15px;"><cf_tl id="Bucket Nominations"></td>
</tr>

<tr><td>

		<form action="<cfoutput>#client.root#</cfoutput>/Roster/Candidate/Details/Functions/ApplicantFunctionEntrySubmit.cfm?<cfoutput>scope=#url.scope#</cfoutput>" method="POST" name="applicantentry">

<table width="100%">

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

<cfquery name="CheckOrgUnitName" dbtype="query">
		SELECT DISTINCT OrgUnitName
		FROM FunctionAll
		WHERE OrgUnitName IS NOT NULL
</cfquery>



<cfset showOcc = 0>
<cfif CheckOcc.RecordCount gte 8>
	<cfset showOcc = 1>
</cfif>

	<TR class="labelmedium fixrow line">
	<td style="padding-left:3px">
	<cfif CheckOcc.recordcount gt 8> <cf_tl id="Area"> </cfif>
	</td>
	<TD><cf_tl id="No"></TD>
	<cfif CheckOrgUnitName.recordcount neq 0>
			<TD><cf_tl id="Organization"></TD>
	</cfif>
	<TD><cf_tl id="Function"></TD>
	<TD><cf_tl id="Level"></TD>
	<TD><cf_tl id="Reference"></TD>
	<td width="20" style="padding-right:4px"><cf_tl id="Select"></td>
	</TR>

<cfoutput query="FunctionAll" group="OccupationGroupDescription">

	<cfif showOcc eq 1>
		<cfset clGroup = "regular">
		<cfset clDetail = "hide">
	<cfelse>
		<cfset clGroup = "hide">
		<cfset clDetail = "show">
	</cfif>

		<tr class="#clGroup#  fixrow2"><td colspan="6">

	<table width="100%" class="formpadding">
	<tr>
	<td width="20" style="padding-top:8px">
		<cf_img icon="expand" toggle="yes" onclick="expand('#OccupationalGroup#')">
		</td>
		<td class="labelmedium" style="font-size:17px;height:32px">#OccupationGroupDescription#</td>
	</tr>
	</table>

	</td></tr>

	<cfoutput group="OrganizationDescription">

		<cfif showOcc eq 1>
				<TR class="#OccupationalGroup# #clDetail#">
			<td style="padding-left:30px" colspan="5" class="labelmedium">#OrganizationDescription#</td>
			</tr>
		</cfif>

		<CFOUTPUT>

			<cfif ApplicantFunctionStatus eq "">
					<TR class="labelmedium #OccupationalGroup# #clDetail# line" id="row#currentrow#" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
					<TD style="height:17" width="5%"></TD>
				<TD>#FunctionNo#</TD>
					<cfif CheckOrgUnitName.recordcount neq 0>
							<TD>#OrgUnitName#</TD>
					</cfif>
					<TD>
					<cfif CustomFunctionDescription neq "">
						#CustomFunctionDescription#
					<cfelseif AnnouncementTitle neq "">
						#AnnouncementTitle#
					<cfelse>
						#FunctionDescription#
					</cfif>
					</TD>
					<TD>
					<cfif CustomFunctionDescription neq "">
						#PostGradeBudget#
					<cfelse>
						#GradeDeployment#
					</cfif>
					</TD>
					<TD>#ReferenceNo#</TD>
				<td style="padding-right:4px">
						<input type="checkbox" class="radiol" name="FunctionId" value="#FunctionId#" onClick="javascript:hl(this.checked,'#currentrow#','#OccupationalGroup#')" <cfif ApplicantFunctionStatus neq "">checked</cfif>>
				</TD>
				</TR>
			<cfelse>
					<TR class="labelmedium #OccupationalGroup# #clDetail# line" bgcolor="ffffcf">
					<td height="20"></td>
				<TD>#FunctionNo#</TD>
					<cfif CheckOrgUnitName.recordcount neq 0>
							<TD>#OrgUnitName#</TD>
					</cfif>
					<TD>
					<cfif CustomFunctionDescription neq "">
						#CustomFunctionDescription#
					<cfelseif AnnouncementTitle neq "">
						#AnnouncementTitle#
					<cfelse>
						#FunctionDescription#
					</cfif>
					</TD>
					<TD>
					<cfif CustomFunctionDescription neq "">
						#PostGradeBudget#
					<cfelse>
						#GradeDeployment#
					</cfif>
					</TD>
					<TD>#ReferenceNo#</TD>
				<td>

					<cfquery name="getStatus"
							datasource="AppsSelection"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							SELECT *
							FROM   Ref_StatusCode
							WHERE  Owner = '#Edition.Owner#'
						AND    Id     = 'FUN'
						AND    Status = '#ApplicantFunctionStatus#'
					</cfquery>
					#getStatus.Meaning#

					</TD>
					</TR>
			</cfif>

		</CFOUTPUT>

	</CFOUTPUT>

		<tr><td colspan="6" class="line"></td></tr>

</CFOUTPUT>

	<tr><td height="6"></td></tr>
<tr><td height="3" colspan="6" style="padding-left:5px">

<table cellspacing="0" align="center" class="formspacing">
<tr>

<cfoutput>

	<cfif url.scope eq "entry">

<!--- the scope applies to adding a new person and immediately assign to buckets --->

		<input type="hidden" name="Source" value="#url.source#">

		<td><input type="submit" style="width:160px;height:25px;" name="Submit" value="Submit Candidacy" onclick="return validate();" class="button10g"></td>

		<cfquery name="Submission"
				datasource="AppsSelection"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT *
				FROM ApplicantSubmission
				WHERE PersonNo = '#url.id#'
		</cfquery>

		<cfif submission.created gte now()-1>
				<td><input class="button10g" style="width:150px;height:25px;" type="button"  name="remove" value="Remove Candidate" onclick="purgecandidate('#url.id#')"></td>
		</cfif>
			<td><input class="button10g" style="width:150px;height:25px;" type="button"  name="remove" value="New Candidate" onclick="newcandidate('#url.id#')"></td>


	<cfelse>

<!--- this scope applies to the candidate dialog screen allowing to add candidate to a seelcted edition --->

		<td class="labelmedium" style="padding-right:6px"><cf_tl id="Add candidacy">:</td>
	<td><cf_ProfileSource PersonNo= "#url.id#" Selected="#url.source#" ShowAll="Yes" label=""></td>
		<td>
			<input type="submit" style="width:120;height:27;" name="Submit" value="Submit" class="button10g">
		</td>

	</cfif>

</cfoutput>

</tr>

</table>
</td></tr>

	<tr><td colspan="6" class="line"></td></tr>

</table>

</FORM>

</td></tr>

</table>
