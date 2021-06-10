
<cfparam name="url.accessmode" default="edit">

<cfquery name="get"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   P.*, O.OrgunitName, O.OrgUnitNameShort
	FROM     Position P INNER JOIN Organization.dbo.Organization O ON P.OrgunitOperational = O.OrgUnit
	AND      PositionNo = '#url.id1#'
</cfquery>

<cfoutput>

<div class="clsPrintContent">

	<table width="98%" align="center" class="formpadding">

		<tr><td style="height:10px"></td></tr>
			
		<cfset buttonlayout = {label= ""}>	
		
		<tr class="line labelmedium2">
		    <td style="height:24" width="100"><cf_tl id="Unit">:</td>
			<td width="80%">#get.OrgUnitNameShort# / #get.OrgUnitName#</td>
			
			<td align="right">
				<span id="printTitle" style="display:none;"><cf_tl id="Profile"> #get.OrgUnitNameShort# / #get.OrgUnitName#</span>
				<cf_tl id="Print" var="1">
				<div class="clsNoPrint">
					<cf_button2 
						mode		= "icon"
						type		= "Print"
						title       = "#lt_text#" 
						id          = "Print"					
						height		= "30px"
						width		= "35px"
						printTitle	= "##printTitle"
						printContent = ".clsPrintContent">
				</div>
			</td>
			
		</tr>	
		<tr class="line labelmedium2"><td style="height:24"><cf_tl id="Postnumber">:</td>
			<td colspan="2">#get.SourcePostNumber#</td>
		</tr>
			
		<tr class="line labelmedium2"><td style="height:24"><cf_tl id="Function">:</td>
			<td colspan="2">#get.FunctionDescription#</td>
		</tr>
		
		<cfparam name="url.submissionedition" default="">
						
		<cfquery name="gettitle"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT     TOP (1) SubmissionEdition, PositionNo, LanguageCode, FunctionDescription, OfficerUserId, Created
			FROM       Ref_SubmissionEditionPosition_Language
			WHERE      SubmissionEdition = '#url.submissionedition#' 
			AND        PositionNo = '#url.id1#'
			AND        LanguageCode = '#url.code#'
		</cfquery>			
			
		<tr class="line labelmedium2"><td style="height:24"><cf_tl id="Title">:</td>
			<td colspan="2">#gettitle.FunctionDescription#
			
			<cfquery name="gettitle"
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
				SELECT    TOP (1) SubmissionEdition, PositionNo, LanguageCode, FunctionDescription, OfficerUserId, Created
				FROM      Ref_SubmissionEditionPosition_Language
				WHERE     SubmissionEdition <> '#url.submissionedition#' 
				AND       PositionNo IN (SELECT  PositionNo
										FROM    Employee.dbo.Position
										WHERE   SourcePostNumber = '#get.SourcePostNumber#') 
				AND    LanguageCode = '#url.code#'
				ORDER BY Created DESC
			
			</cfquery>	
			
			<cfif getTitle.recordcount eq "1">
			&nbsp;<font color="804040">prior: #gettitle.submissionedition# / #gettitle.FunctionDescription#		
			</cfif>		
			
			</td>
		</tr>
		
			
		<tr class="labelmedium2"><td style="height:24"><cf_tl id="Grade">:</td>
			<td colspan="2">#get.PostGrade#</td>
		</tr>
		
		<tr><td colspan="3" id="profilecontent#url.languagecode#">	
			<cfinclude template="PositionProfileContent.cfm">
		</td>
		
		</tr>	
		
	</table>
</div>

</cfoutput>
