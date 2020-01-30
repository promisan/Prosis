
<!--- show buckets
- same occgroup
- within default roster edition
- authorised for user (inherited)
- not applied to by applicant
--->

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterOwner
	WHERE  Owner = '#Get.Owner#'
</cfquery>

<cfquery name="FunctionAll" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT   DISTINCT R.*
	
	FROM     vwFunctionOrganization R <cfif SESSION.isAdministrator eq "No" and not findNoCase(get.owner,SESSION.isOwnerAdministrator)>,RosterAccessAuthorization A</cfif>
	
	WHERE    SubmissionEdition = '#Parameter.DefaultRoster#'
	AND      OccupationalGroup = '#get.OccupationalGroup#' 

	AND      R.ReferenceNo IN ('Direct','direct')
	AND      R.FunctionId NOT IN 	(
						 SELECT FunctionId
						 FROM   ApplicantFunction M, 
				    		    ApplicantSubmission S
						 WHERE  S.PersonNo     = '#Get.PersonNo#'
						 AND    S.ApplicantNo  = M.ApplicantNo
						 )

	AND      R.FunctionRoster = '1'

	<cfif SESSION.isAdministrator eq "No" and not findNoCase(get.owner,SESSION.isOwnerAdministrator)>
		AND    R.FunctionId     = A.FunctionId
		AND    A.UserAccount    = '#SESSION.acc#' 	
		<!--- only initial clearer --->
		AND    A.AccessLevel IN ('1') 
	</cfif>

	ORDER BY ListingOrder  
</cfquery>

<cfif FunctionAll.recordcount eq "0">

	<table align="center"><tr><td class="labelit"><font color="808080">No records in this view</td></tr></table>

<cfelse>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

	<tr>
	<td>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<cfoutput query="FunctionAll" group="HierarchyOrder">
		<cfoutput group="OccupationalGroup">	
			<CFOUTPUT>
			<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
			    <TD></TD>
				<td class="labelit">#OrganizationDescription#</td>
				<TD class="labelit">#FunctionNo#</TD>
			    <TD class="labelit">#FunctionDescription#</TD>
			    <TD class="labelit">#GradeDeployment#</TD>
				<td><input type="checkbox" name="FunctionIdSelect" value="#FunctionId#"></TD>
			</TR>
			</CFOUTPUT>
		</CFOUTPUT>
	</CFOUTPUT>
	</table>
	
	</td>
	</tr>
	
</table>

</cfif>
