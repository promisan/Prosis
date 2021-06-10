<cfoutput>

	<cfquery name="getPost"
			datasource="AppsSelection"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		SELECT  L.FunctionDescription,
		P.PostGrade,
		O.OrgunitName,
		O.OrgUnit
		FROM   Employee.dbo.Position P INNER JOIN Organization.dbo.Organization O ON
		P.OrgunitOperational = O.OrgUnit
		INNER JOIN Applicant.dbo.Ref_SubmissionEditionPosition SEP
		ON SEP.SubmissionEdition = '#url.submissionedition#' AND SEP.PositionNo=P.PositionNo
	INNER JOIN Applicant.dbo.Ref_SubmissionEditionPosition_Language L ON
	L.SubmissionEdition = SEP.SubmissionEdition AND SEP.PositionNo = L.PositionNo
	AND L.LanguageCode = '#language.code#'
	WHERE  PositionParentId = '#Parent.PositionParentId#'
	</cfquery>


	<cfset vLogo       = "<img src='#SESSION.root#/Images/UN_LOGO_BLUE.gif' alt='' width='64' height='57' border='0'>">
	<cfset vTitleLine1 = "United Nations">
	<cfset vTitleLine2 = "Nations Unies" >
	<cfset vTitleLine3 = "">
	<cfset vTitleLine4 = "">

	<cfset ref = replace(qJOs.Reference,"/","_","ALL")>

	<cfset vFile = "/#SESSION.rootDocumentPath#/RosterEdition/#URL.SubmissionEdition#/#ref#-#URL.lcode#.pdf">

	<cfset strFileToZip=listappend(strFileToZip,vFile)>

	<cfdocument format="PDF"
			pagetype="letter"
			margintop="0.1"
			marginright="0.1"
			marginleft="0.1"
			marginbottom = "0.1"
			unit = "in"
			bookmark="true"
			filename="#vFile#"
			overwrite="true">

		<cfdocumentsection name="Body">

			<cf_LayoutDocument
					Logo			= "#vLogo#"
					Class		    = "Letter"
					TitleLine1      = "#vTitleLine1#"
					TitleLine2      = "#vTitleLine2#"
					TitleLine3      = "#vTitleLine3#"
					TitleLine4      = "#vTitleLine4#"
					Closing			= "">

<!---- header ---->
				<cfoutput>

					<table width="100%" align="center">
					<tr>
						<td width="10%"></td>
					<td>
					<table width="100%" align="center" id="tdata_letter">

					<cfswitch expression="#language.languagecode#">

						<cfcase value="0">

							<cfif qJOs.NoPosts gt 1 >
									<tr><td colspan="2" class="linedotted"></td></tr>
								<tr><td class="labelit" width="40%"><b><cf_tl id="Posts"></b>:</td>
							<td class="label">#qJOs.NoPosts#</td>
							</tr>
							</cfif>

								<tr><td colspan="2" class="linedotted"></td></tr>
							<tr><td class="labelit" width="40%"><b><cf_tl id="Job Title"></b>:</td>
						<td class="label">#getPost.FunctionDescription#, #getPost.PostGrade#</td>
						</tr>

							<tr><td height="4"></td></tr>
						<tr><td class="labelit" width="40%"><b><cf_tl id="Department">/<cf_tl id="Office"></b>:</td>
						<td class="label" width="60%">#getPost.OrgUnitName#</td>
						</tr>

							<tr><td colspan="2" class="linedotted"></td></tr>
						<tr><td class="labelit" width="40%"><b><cf_tl id="Location"></b>:</td>
							<td class="label">NEW YORK</td>
						</tr>

							<tr><td colspan="2" class="linedotted"></td></tr>
						<tr><td class="labelit" width="40%"><b><cf_tl id="Posting Period"></b>:</td>
						<td class="label">#DateFormat(qEdition.DateEffective,CLIENT.DateformatShow)# - #DateFormat(qEdition.DateExpiration,CLIENT.DateformatShow)#</td>
						</tr>


							<tr><td colspan="2" class="linedotted"></td></tr>
						<tr><td class="labelit" width="40%"><b><cf_tl id="Job Opening Number"></b>:</td>
						<td class="label">#qJOs.Reference#</td>
						</tr>

							<tr><td colspan="2" class="line"></td></tr>
							<tr>
								<td colspan="2">
									<b>United Nations Core Values: Integrity, Professionalism, Respect for Diversity</b>
								</td>
							</tr>
							<tr><td colspan="2" class="linedotted"></td></tr>
						</cfcase>
						<cfcase value="1">

							<cfif qJOs.NoPosts gt 1 >
									<tr><td colspan="2" class="linedotted"></td></tr>
								<tr><td class="labelit" width="40%"><b>Postes</b>:</td>
								<td class="label">#qJOs.NoPosts#</td>
							</tr>
							</cfif>

								<tr><td colspan="2" class="linedotted"></td></tr>
							<tr><td class="labelit" width="40%"><b>Titre du poste</b>:</td>
							<td class="label">#getPost.FunctionDescription#, #getPost.PostGrade#</td>
						</tr>

							<tr><td height="4"></td></tr>
						<tr><td class="labelit" width="40%"><b>Entité</b>:</td>
						<td class="label" width="60%">
							<cfquery name="getTranslation"
									datasource="AppsOrganization"
									username="#SESSION.login#"
									password="#SESSION.dbpw#">
									SELECT * FROM xlFRA_Organization
									WHERE  OrgUnit ='#getPost.OrgUnit#'
							</cfquery>
							<cfif getPost.recordcount eq 0>
								#getPost.OrgUnitName#
							<cfelse>
								#getTranslation.OrgUnitName#
							</cfif>
							</td>
							</tr>

								<tr><td colspan="2" class="linedotted"></td></tr>
								<tr><td class="labelit" width="40%"><b>Lieu d’affectation</b>:</td>
									<td class="label">NEW YORK</td>
								</tr>

								<tr><td colspan="2" class="linedotted"></td></tr>
							<tr><td class="labelit" width="40%"><b>Délai de dépôt des candidatures</b>:</td>
							<td class="label">#DateFormat(qEdition.DateEffective,CLIENT.DateformatShow)# - #DateFormat(qEdition.DateExpiration,CLIENT.DateformatShow)#</td>
						</tr>


							<tr><td colspan="2" class="linedotted"></td></tr>
						<tr><td class="labelit">Avis de vacance de poste numéro:</td>
						<td class="label">#qJOs.Reference#</td>
						</tr>

							<tr><td colspan="2" class="linedotted"></td></tr>
							<tr>
								<td colspan="2">
									<b>Valeurs fondamentales de l'ONU : Intégrité, professionnalisme, respect de la diversité</b>
								</td>
							</tr>
							<tr><td colspan="2" class="linedotted"></td></tr>

						</cfcase>
					</cfswitch>
				</cfoutput>

				<cfloop query="qTextArea">

					<tr><td colspan="2"><b>#qTextArea.Description#:</b></td></tr>
				<tr><td colspan="2">

					<cfquery name="qPosts"
							datasource="AppsSelection"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							SELECT PPP.JobNotes
							FROM   Employee.dbo.PositionParentProfile PPP
							WHERE  PPP.PositionParentId = '#Parent.PositionParentId#'
						AND    LanguageCode = '#language.languagecode#'
						AND    TextAreaCode = '#qTextArea.Code#'
					</cfquery>

					<cfset vtext = replace(qPosts.JobNotes,"script","disable","all")>
					<cfset vtext = replace(vtext,"iframe","disable","all")>

					<cfoutput>
							<div class="content" align="justify">
							#vText#
							</div>
					</cfoutput>

					</td></tr>
						<tr><td colspan="2" class="linedotted"></td></tr>

				</cfloop>

				</table>
				</td>
					<td width="10%"></td>
				</tr>
				</table>

			</cf_LayoutDocument>

		</cfdocumentsection>
	</cfdocument>

</cfoutput>