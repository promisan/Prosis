
<!--- assign the position to a submission edition for publishimng --->

<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     Applicant.dbo.Ref_SubmissionEditionPosition
WHERE    PositionNo = '#Object.ObjectKeyValue1#'
</cfquery>	

<cfquery name="getPost"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT P.*, O.OrgunitName
	FROM   Position P, Organization.dbo.Organization O
	WHERE  P.OrgunitOperational = O.OrgUnit
	AND    Positionno = '#Object.ObjectKeyValue1#'
</cfquery>

<cfquery name="getEmployee"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT     PA.DateEffective, 
              PA.DateExpiration, 
			  P.IndexNo, 
			  P.LastName, 
			  P.FirstName, 
			  P.Gender, 
			  P.Nationality,
			  (SELECT Name FROM System.dbo.Ref_Nation WHERE Code = P.Nationality) as NationalityName
   FROM       PersonAssignment AS PA INNER JOIN
              Person AS P ON PA.PersonNo = P.PersonNo
	WHERE     PA.PositionNo = '#Object.ObjectKeyValue1#' 
	AND       PA.DateEffective <= GETDATE() 
	AND       PA.DateExpiration >= GETDATE() 
	AND       PA.AssignmentStatus IN ('0', '1')
</cfquery>

<cfoutput>

<table width="98%" align="center" class="formpadding formspacing">
	
	<tr class="labelmedium2 linedotted"><td width="100">Unit:</td>
		<td width="80%">#getPost.OrgUnitName#</td>
	</tr>
	<tr class="labelmedium2 linedotted"><td>Postnumber:</td>
		<td>#getPost.SourcePostNumber#</td>
	</tr>
	<tr class="labelmedium2 linedotted"><td>Title:</td>
		<td>#getPost.FunctionDescription#</td>
	</tr>
	<tr class="labelmedium2 linedotted"><td>Grade:</td>
		<td>#getPost.PostGrade#</td>
	</tr>
	<tr class="labelmedium2 linedotted"><td>Employee:</td>
		<td>#getEmployee.FirstName# #getEmployee.LastName#</td>
	</tr>
	<tr class="labelmedium2 linedotted"><td>Nationality:</td>
		<td class="labelmedium">#getEmployee.NationalityName#</td>
	</tr>
	<tr class="labelmedium2 linedotted"><td>Expiration:</td>
		<td style="font-weight:bold">#dateformat(getEmployee.DateExpiration,client.dateformatshow)#</td>
	</tr>

</cfoutput>

	<tr>
	<td colspan="2" class="labellarge" style="padding-top:20px" colspan="2">
	Select the campaign to either fill position or determine if position will be filled from the roster:
	<td>
	</tr>
	
	<tr><td></td></tr>
	
	<tr class="labelmedium2">
	<td style="padding-left:15px"><cf_tl id="Edition">:</td>
	<td>
		
		<cfquery name="GetEdition" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    SubmissionEdition, 
			          EditionDescription
			FROM      Ref_SubmissionEdition
			WHERE     1=1 <!--- Owner = '#Object.Owner#' --->
			AND       Operational  = '1' 
			AND       ActionStatus = '0'
			ORDER BY Created DESC
		</cfquery>
					
		<select name="EditionSelect" class="regularxxl">
		<cfoutput query="getEdition">
	   		<option value="#SubmissionEdition#" <cfif Get.SubmissionEdition eq getEdition.SubmissionEdition>selected</cfif>>#getEdition.EditionDescription#</option>
		</cfoutput>
		</select>
		
	</td>
	</tr>
		
	<!----
	<tr>
	<td width="10%"></td>
	<td width="10%" class="labellarge">Reference</td>
	<td style="padding-top:10px">
		<cfoutput>
			<input type="text" name="EditionReference" size="20" maxlength="20" class="regular" value="#Get.Reference#">
		</cfoutput>
	</td>
	<td width="10%"></td>
	</tr>
	---->
	
	<tr class="labelmedium2">
	<td style="padding-left:15px"><cf_tl id="Mode">:</td>
	<td>
		<select name="ModeSelect"  class="regularxxl">
			<option value="1">Published</option>
			<option value="0">Will NOT be Published</option>		
		</select>
	</td>
	</tr>
	
	<tr>	
	<td>
	<cfoutput>
	<input name="Key1" type="hidden" value="#Object.ObjectKeyValue1#">
	</cfoutput>
	
	<input name="savecustom" type="hidden"  value="Roster/Maintenance/RosterEdition/Workflow/ApplyEdition/DocumentSubmit.cfm">
	</td>
	</tr>

</table>