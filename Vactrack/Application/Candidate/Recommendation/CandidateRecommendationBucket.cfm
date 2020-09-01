
<cfparam name="url.scope"    default="profile">  
<cfparam name="url.source"   default="">  
<cfparam name="url.occgroup" default="">

<cfparam name="URL.ID" default="0000">

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

<!---

<cfif Parameter.DefaultRosterAdd eq "1">

	<cfset FileNo = round(Rand()*100)>

	<CF_DropTable dbName="AppsQuery" tblName="v#SESSION.acc#Roster#FileNo#">

	<!--- Hanno : the purpose of this is to add something to the default rostered as a generic bucket for rostering --->
		
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
		
	<CF_DropTable dbName="AppsQuery" tblName="v#SESSION.acc#Roster#FileNo#">

</cfif>

--->

<!--- make listing for this person by excluding existing selections if not '9' --->

<cfquery name="FunctionAll" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT V.*, 
	
	        <!--- we check the highest status in any submission for this person to be shown --->
			
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
	
	<!--- same edition as this track is associated to --->
	WHERE  V.SubmissionEdition = '#fun.submissionedition#' 
	<!--- filter by occupational group of the track to keep the list limited to relevant --->
	AND    V.OccupationalGroup = '#doc.occupationalgroup#' 	
	<!--- we show only titles that are enabled as rostered --->
	<cfif Parameter.DefaultRoster eq fun.submissionedition>
		AND   V.FunctionRoster = '1'
		<!--- removed by hanno to enable for titles that are intended for the roster 
		AND   R.ReferenceNo IN ('Direct','direct')
		--->
	</cfif>	
										 
	ORDER BY OccupationGroupDescription, 
	         OrganizationDescription, 
			 HierarchyOrder, 
			 ListingOrder, 
			 FunctionDescription						 
				
</cfquery>

<table width="99%" align="left">

<tr class="line">
   	<td class="labellarge" style="font-size:20px;height:35px">
	<cf_tl id="Roster for future selection">
	<!--- we take the default submission source to capture the bucket candidacy --->
	<cfoutput>
	<input type="hidden" id="source" name="Source" value="#Parameter.DefaultPHPEntry#">
	</cfoutput>
	<!--- <cf_ProfileSource PersonNo= "#url.id#" ShowAll="Yes" label=""> --->	 
	</td>
</tr>	

<tr><td>

<table width="100%" class="navigation_table">

<!--- -----------------------------------------------------------  --->
<!--- check the default source through the user or the background  --->
<!--- -----------------------------------------------------------  

<cfquery name="CheckOcc" dbtype="query">
	SELECT DISTINCT OccupationGroupDescription
	FROM FunctionAll 
</cfquery>

<cfset showOcc = 0>
<cfif CheckOcc.RecordCount gte 8>
	<cfset showOcc = 1>
</cfif>

--->

 	
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
	

</script>

<TR class="labelmedium fixrow line">
    <td height="20" style="padding-left:3px"><cf_tl id="Area"></td>
	<TD><cf_tl id="No"></TD>
    <TD><cf_tl id="Function"></TD>
    <TD><cf_tl id="Level"></TD>
	<TD><cf_tl id="Reference"></TD>
	<td><cf_tl id="Current"></td>
	<td width="20" style="padding-right:4px"><cf_tl id="S"></td>
</TR>

<cfoutput query="FunctionAll" group="OccupationGroupDescription">
	
	<cfset clGroup = "regular">
	<cfset clDetail = "regular">
		
	<tr class="#clGroup# fixrow2"><td colspan="7">
		
		<table width="100%" class="formpadding">
		<tr>
		<!---
		<td width="20" style="padding-top:2px">
			<cf_img icon="expand" toggle="yes" onclick="javascript:expand('#OccupationalGroup#')">
		</td>
		--->
		<td class="labelmedium" style="font-size:17px;height:32px">#OccupationGroupDescription#</td>
		</tr>
		</table>
		
	</td></tr>			

	<cfoutput group="OrganizationDescription">
				
		<TR class="#OccupationalGroup# #clDetail#">
			<td></td>
		    <td colspan="6" class="labelmedium">#OrganizationDescription#</td>
		</tr>
				
		<CFOUTPUT>
						
			<TR class="navigation_row labelmedium #OccupationalGroup# #clDetail# line" id="row#currentrow#" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
			    <TD style="height:17;width:1px"></TD>
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
				<td>
				
					<cfquery name="getStatus" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Ref_StatusCode
							WHERE  Owner = '#edition.Owner#'
							AND    Id     = 'FUN'
							AND    Status = '#ApplicantFunctionStatus#'
					</cfquery>					
					#getStatus.Meaning#
					
				</TD>
				<td align="center" style="padding-right:4px">	
				
				  	<cfif ApplicantFunctionStatus neq "3">
					<input type="checkbox" class="radiol" name="FunctionId" value="#FunctionId#" onClick="hl(this.checked,'#currentrow#','#OccupationalGroup#')" <cfif ApplicantFunctionStatus eq "3">checked</cfif>>				
					</cfif>
				</TD>
			</TR>
						
		</CFOUTPUT>
	
	</CFOUTPUT>

	<tr><td colspan="6" class="line"></td></tr>

</CFOUTPUT>

</table>

</td></tr>

</table>

<cfset ajaxonload("doHighlight")>
