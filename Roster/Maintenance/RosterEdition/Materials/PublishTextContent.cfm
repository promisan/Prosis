<cfparam name="Action.ActionId" default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.languagecode" default="0">
<cfparam name="URL.ActionId" default="#Action.ActionId#">
<cfparam name="URL.Scope" default="workflow">
<cfset access = "edit">

<cfoutput>

<cfquery name="Edition"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ExerciseClass E INNER JOIN Ref_SubmissionEdition S
	ON      E.ExcerciseClass    = S.ExerciseClass
	WHERE   S.SubmissionEdition = '#url.submissionedition#'
</cfquery>

<!---
<cfquery name="Area"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_TextArea
	WHERE   TextAreaDomain = 'Edition'	
</cfquery>

<cfloop query="Area">

	<cfquery name="get"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">				
		SELECT *
		FROM   Ref_SubmissionEditionProfile
		WHERE  SubmissionEdition = '#Edition.SubmissionEdition#'
		AND    LanguageCode      = '#languagecode#' 	
		AND    ActionId          = '#url.actionid#'							
	</cfquery>			
	
	<cfif get.recordcount eq "0">
	
		<cfquery name="insert"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">				
			INSERT INTO Ref_SubmissionEditionProfile
			(SubmissionEdition,LanguageCode,TextareaCode,Actionid,OfficerUserid,OfficerLastName,OfficerFirstName)
			VALUES
			('#Edition.SubmissionEdition#','#languagecode#','#code#','#url.actionid#','#session.acc#','#session.last#','#session.first#') 								
		</cfquery>		
				
	</cfif>

</cfloop>
--->

<!--- Disable all records that were not sent and were created in prior steps --->
<cfquery name="get"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">				
	UPDATE Ref_SubmissionEditionProfile
	SET    ActionStatus = '9'
	WHERE  SubmissionEdition = '#Edition.SubmissionEdition#'	
	AND    ActionId          != '#url.actionid#'
	AND    ActionStatus IN ('0','1')
</cfquery>	

<cfquery name="Language"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   L.* 
	FROM     Ref_SystemLanguage L
	WHERE    L.LanguageCode IN (
					SELECT LanguageCode
					FROM   Applicant.dbo.Ref_SubmissionEditionProfile
					WHERE  SubmissionEdition = '#url.submissionedition#'
					AND    ActionId = '#url.actionid#'
					AND    ActionStatus = '0') <!--- Under preparation --->
	ORDER BY L.LanguageCode	
</cfquery>

<!--- Getting Previous Texts for easy maintenance by Armin 5/18/2021 ---->
<cfloop query="Language">

	<cfquery name="getPrevious"
			datasource="AppsSelection"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		SELECT  TOP 1 *
		FROM Ref_SubmissionEditionProfile
		WHERE ActionId != '#url.actionid#'
	AND LanguageCode = '#Language.LanguageCode#'
	AND ActionStatus = '9'
	ORDER BY Created DESC
	</cfquery>


	<cfif getPrevious.TextAreaCode neq "" and getPrevious.EditionNotes neq "">
		<cfquery name="getCurrent"
				datasource="AppsSelection"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			SELECT  TOP 1 *
			FROM Ref_SubmissionEditionProfile
			WHERE ActionId = '#url.actionid#'
		AND LanguageCode = '#Language.LanguageCode#'
		AND TextAreaCode = '#getPrevious.TextAreaCode#'
		AND ActionStatus = '0'
		</cfquery>


		<cfif getCurrent.recordcount neq 0 AND getCurrent.EditionNotes eq "">
			<cfquery name="updateCurrent"
					datasource="AppsSelection"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
				UPDATE Ref_SubmissionEditionProfile
				SET EditionNotes = '#getPrevious.EditionNotes#'
			WHERE ActionId = '#url.actionid#'
			AND LanguageCode = '#Language.LanguageCode#'
			AND TextAreaCode = '#getPrevious.TextAreaCode#'
			AND ActionStatus = '0'
			</cfquery>
		</cfif>
	</cfif>
</cfloop>



<table width="96%" cellspacing="0" cellpadding="0" align="center">

<tr>
	<td colspan="2" style="padding-top:10px;">
		<table>
			<tr valign="top">
				<td style="padding-top:4px" class="labelmedium" width="100"><cf_tl id="Languages">:</b></td>
				<td>
				
				<cfquery name="LanguageList"
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   L.*,
							 (SELECT COUNT(*)
							  FROM   Applicant.dbo.Ref_SubmissionEditionProfile
							  WHERE  SubmissionEdition = '#url.submissionEdition#'
							  AND    ActionId = '#url.actionid#'
							  AND    LanguageCode = L.LanguageCode
							  AND    ActionStatus = '0'
							  ) AS InUse
					FROM     Ref_SystemLanguage L
					WHERE    LanguageCode != '' AND LanguageCode IS NOT NULL
					ORDER 	 BY LanguageName
				</cfquery>
				<table>
					<tr>
					<cfloop query="LanguageList">
						<td style="padding:5px;padding-right:5px" class="labelmedium">
							<input type="checkbox" 
									name="language" 
									id="language" 
									class="radiol"
									onclick="if(!this.checked){ if (!confirm('Are you sure that you want to remove #LanguageName#?')){this.checked=true; return;}}ColdFusion.navigate('#client.root#/Roster/Maintenance/RosterEdition/Materials/setEditionProfileLanguage.cfm?actionid=#url.actionid#&scope=#url.scope#&submissionedition=#url.submissionedition#&language='+this.value+'&checked='+this.checked,'dialog');"
									value="#LanguageCode#" <cfif InUse eq 1>checked</cfif>></td><td class="labelmedium" style="padding-left:2px;padding-right:10px">#LanguageName#</td>
						</td>
					</cfloop>
					</tr>
				</table>
				
				</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
	<td colspan="2" class="linedotted"></td>
</tr>

<tr>
	  <td valign="top" style="padding:10px 5px">
   		<table>
		
		<tr><td height="15"></td></tr>
					
		<cfloop query="language">
		
			<tr>
					<cfif languagecode eq url.languagecode>
						<td align="center" bgcolor="ffff00"><img height="50" width="66" src="#client.root#/images/flag/#code#.gif"></td>					
					<cfelse>
						<cfif url.scope eq "backoffice">
						<td style="cursor:pointer" align="center" onclick="parent.window.open('#client.root#/Roster/Maintenance/RosterEdition/Materials/PublishText.cfm?actionid=#url.actionid#&submissionedition=#url.submissionedition#&languagecode=#languagecode#','languagebox')">
						<img height="50" width="66" src="#client.root#/images/flag/#code#.gif" >
						</td>
					    <cfelse>
						<td style="cursor:pointer" 
							align="center" 
							onclick="ColdFusion.navigate('#client.root#/Roster/Maintenance/RosterEdition/Materials/PublishText.cfm?actionid=#url.actionid#&scope=#url.scope#&submissionedition=#url.submissionedition#&languagecode=#languagecode#','dialog')">
								<img height="50" width="66" src="#client.root#/images/flag/#code#.gif" >
								</td>
						</cfif>	
					</cfif>
					<td width="5%"></td>
			</tr>		
			<tr>
				<cfif languagecode eq url.languagecode>
					<td class="labelmedium" align="center" bgcolor="ffff00"><b>#LanguageName#</b></td>					
				<cfelse>
					<td class="labelmedium" align="center" style="color:lightgray;">#LanguageName#</td>
				</cfif>
				<td width="5%"></td>					
			</tr>	
			
			<tr><td height="10"></td></tr>
				
		</cfloop>				
		
		</table>
   </td>

   <td width="98%" style="border-left:1px dotted silver">
	
	<table width="100%">
	
	<cfoutput>
		
		<tr><td id="process#url.languagecode#" width="60"></td></tr>
		
	</cfoutput>	
	
	<cfquery name="Profile"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT *
		FROM   Ref_SubmissionEditionProfile
		WHERE  SubmissionEdition = '#Edition.SubmissionEdition#'
		AND    LanguageCode      = '#url.languagecode#' 
		AND    ActionId          = '#url.actionid#'
		AND	   ActionStatus		 = '0' <!--- Record is under preparation --->
		
	</cfquery>	
	
	<cfif Profile.RecordCount gt 0 >
	
		<tr><td height="2" colspan="2" style="padding:4px">		
	
			<table width="100%" align="center">		
		
			<cfloop query="Profile">
			
				<tr valign="top">				
	
					<td>
						<cfset toggle = "Yes">
						<cfif url.scope eq "workflow">
							<cfset toggle = "No">
						</cfif>		
																		
						<cfif findNoCase("cache","#cgi.query_string#")>						
							<cfset ajax = "Yes">
						<cfelse>						
							<cfset ajax = "No">	
						</cfif>
																	
						<cf_ApplicantTextArea
							Table           = "Applicant.dbo.Ref_SubmissionEditionProfile" 
							Code			= "#Profile.TextAreaCode#"
							Domain          = "Edition"
							FieldOutput     = "EditionNotes"			
							LanguageCode    = "#url.languagecode#"
							Mode            = "#access#"
							Toggle			= "#toggle#"
							Format          = "RichTextFull"
							Ajax            = "#ajax#"
							Height			= "520"						
							Key01           = "SubmissionEdition"
							Key01Value      = "#url.submissionedition#"
							Key02           = "ActionId"
							Key02Value      = "#url.actionId#"
							PathDefault     = "#edition.PathPublishText#">	<!--- get default text --->
							
					</td>
					
				</tr>
				
			</cfloop>
	
			</table>
			
			</td></tr>
			
			<cfif access eq "edit">
			
				<tr><td colspan="2" align="left" style="padding-left:15px">
				
					<cfoutput>
					<input type="submit" 
					       name="Save" 
						   value="Save" 
						   style="width:180;font-size:13px"
						   onclick="updateTextArea()"
						   class="button10g">
					</cfoutput>			   
				
				</td></tr>
			
			</cfif>
	
	<cfelse>
	
		<tr><td colspan="2" align="center" style="padding-left:15px" class="labellarge">
				
					No language has been selected.
				
		</td></tr>
		
	</cfif>
		
	</table>
		
	</td>
	
</tr>
		
<tr><td height="5" colspan="2"></td></tr>
<tr><td colspan="2" class="linedotted"></td></tr>

<!---
<tr><td colspan="2">
		
	<table width="97%" align="center">
	<tr>
		   <td>
			    <table width="100%" cellspacing="0" cellpadding="0">
				<tr><td style="height:35" align="left" style="padding:0px" class="labellarge"><b><font color="0080C0">Other Documents</font></b></td></tr>
				</table>
		   </td>
	</tr>
	<tr>
		<td>
			<cfif access eq "edit">
			
				<cf_filelibraryN
					DocumentPath = "RosterEdition"
					SubDirectory = "#url.submissionedition#" 
					Filter       = "other_"
					Presentation = "all"
					Insert       = "yes"
					Remove       = "yes"
					width        = "100%"	
					Loadscript   = "no"				
					border       = "1"
					box          = "r_#url.submissionedition#">	
									
			<cfelse>
			
				<cf_filelibraryN
					DocumentPath = "RosterEdition"
					SubDirectory = "#url.submissionedition#" 
					Filter       = ""
					Presentation = "all"
					Insert       = "no"
					Remove       = "no"
					width        = "100%"	
					Loadscript   = "no"				
					border       = "1"
					box          = "r_#url.submissionedition#">					
			
			</cfif>	
		</td>
	</tr>
	</table>

</td></tr>

<tr><td colspan="2" class="linedotted"></td></tr>

--->

</table>

</cfoutput>

<cfset AjaxOnload("initTextArea")>	