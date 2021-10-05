
<HTML><head><title><cfoutput>#SESSION.welcome#</cfoutput> </title></head>

		<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<body bgcolor="ffffff" leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0"></body>

<cfparam name="client.formselect"    default="preview">
<cfparam name="client.browser"       default="explorer">
<cfparam name="client.languageid" 	 default="ENG">
<cfparam name="client.virtualdir" 	 default="">
<cfparam name="URL.FormSelect" 	     default="#client.formselect#">

<!--- use this variable to determine which button the the user selected and apply further
instead of parameter exists --->

<cfparam name="URL.GUI"     	default="HTML">
<cfparam name="URL.Mode"     	default="distribution">
<cfparam name="URL.Category"   	default="Launch report">
<cfparam name="URL.UserId"     	default="#SESSION.acc#">
<cfparam name="URL.ReportId" 	default="00000000-0000-0000-0000-000000000000">

<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFRStage\User\#SESSION.acc#\")>

	<cfdirectory action="CREATE"
			directory="#SESSION.rootDocumentPath#\CFRStage\User\#SESSION.acc#\">

</cfif>

<cfset URL.ReportId = replace(URL.ReportId,' ','','ALL')>

<cfparam name="URL.ControlId" 	default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.LayoutId"    default="00000000-0000-0000-0000-000000000000">

<cfquery name="List"
		datasource="AppsSystem">
	DELETE FROM stReportStatus
	WHERE ControlId     = '#URL.ControlId#'
AND   OfficerUserId = '#SESSION.acc#'
</cfquery>

<!--- set trigger result default 1 --->
<cfset Condition = 1>

<!--- provision for instant eMail --->
<cfset URL.Status = 1>

<cfif URL.Mode eq "Form" and url.formselect eq "email">
	<cfset URL.Status = "5">
</cfif>

<!--- progress status --->
<cfif Not IsDefined("Session.Status")>
	<cfset session.status = 0>
</cfif>

<cfset session.status = session.status + 0.01>

<!--- define the criteria from the report --->
<cfparam name="Form.LayoutId"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="Form.FileFormat" default = "PDF">

<cfif ParameterExists(Form.Load)>
	<cfset show = "attachment">
<cfelse>
	<cfset show = "inline">
</cfif>

<!--- prepare report variables --->
<script>
	var rpt = document.getElementById ('report');
</script>

<cfparam name="cnt" default="">

<cfif URL.Mode eq "Form" and (url.formselect eq "email" or url.formselect eq "preview")>

	<script language="JavaScript">

		{

			// Reporting framework stop the progress bar just in case
			se = parent.document.getElementById("pBar")
			if (se) {
				parent.ColdFusion.ProgressBar.hide('pBar')
				parent.ColdFusion.ProgressBar.stop('pBar', true)
			}

			frm  = parent.document.getElementById("start");
			if (frm) {
				frm.click();
				abo  = parent.document.getElementById("stop");
				if (abo) {	abo.className = "btn" }
				abo  = parent.document.getElementById("preview");
				if (abo) {  abo.className = "hide" }
			}
		}

	</script>

</cfif>



<cfset FileNo = round(Rand()*1000)>

<cfset answer1    = "tAnswer1_#FileNo#">
<cfset answer2    = "tAnswer2_#FileNo#">
<cfset answer3    = "tAnswer3_#FileNo#">
<cfset answer4    = "tAnswer4_#FileNo#">
<cfset answer5    = "tAnswer5_#FileNo#">
<cfset answer6    = "tAnswer6_#FileNo#">
<cfset answer7    = "tAnswer7_#FileNo#">
<cfset answer8    = "tAnswer8_#FileNo#">
<cfset answer9    = "tAnswer9_#FileNo#">
<cfset answer10   = "tAnswer10_#FileNo#">
<cfset answer11   = "tAnswer11_#FileNo#">
<cfset answer12   = "tAnswer12_#FileNo#">
<cfset answer13   = "tAnswer13_#FileNo#">
<cfset answer14   = "tAnswer14_#FileNo#">
<cfset answer15   = "tAnswer15_#FileNo#">
<cfset answer16   = "tAnswer16_#FileNo#">
<cfset answer17   = "tAnswer17_#FileNo#">
<cfset answer18   = "tAnswer18_#FileNo#">
<cfset answer19   = "tAnswer19_#FileNo#">
<cfset answer20   = "tAnswer20_#FileNo#">
<cfset answer21   = "tAnswer21_#FileNo#">
<cfset answer22   = "tAnswer22_#FileNo#">
<cfset answer23   = "tAnswer23_#FileNo#">
<cfset answer24   = "tAnswer24_#FileNo#">
<cfset answer25   = "tAnswer25_#FileNo#">
<cfset answer26   = "tAnswer26_#FileNo#">
<cfset answer27   = "tAnswer27_#FileNo#">
<cfset answer28   = "tAnswer28_#FileNo#">
<cfset answer29   = "tAnswer29_#FileNo#">
<cfset answer30   = "tAnswer30_#FileNo#">
<cfset answer31   = "tAnswer31_#FileNo#">
<cfset answer32   = "tAnswer32_#FileNo#">
<cfset answer33   = "tAnswer33_#FileNo#">
<cfset answer34   = "tAnswer34_#FileNo#">
<cfset answer35   = "tAnswer35_#FileNo#">
<cfset answerOrg  = "tAnswer99_#FileNo#">
<cfset answerOrgAccess = "tAnswer99_Access_#FileNo#">

<cfif url.formselect neq "sql">

	<cfset session.status = session.status + 0.01>

	<cf_wait text="Report : Initializing report request."
			flush="yes"
			controlid="#URL.controlid#">

</cfif>

<!--- the below also drop the temp tables and genertates the answerOrg table --->
<cfinclude template="ReportCriteria.cfm">

<cfif URL.Status eq "5" and (UserReport.LayoutClass eq "View" and UserReport.enableAttachment eq "0")>

	<cf_message
			report  = "1"
			message = "Sorry, but eMail of a view is currently not supported."
			return = "back">
	<cfabort>

</cfif>

<cfif UserReport.LayoutClass eq "View">

	<cfset suf = FileNo>

<cfelse>

	<cfquery name="Check"
			datasource="AppsSystem">
		SELECT  *
		FROM    UserNames
		WHERE   Account = '#SESSION.acc#'
	</cfquery>

	<cfif URL.ReportId neq "00000000-0000-0000-0000-000000000000">
		<cfset fileNo = "#fileNo##mid(url.reportid,2,4)#">
	</cfif>

	<cfif Check.AllowMultipleLogon eq "1">
		<cfset suf = "#SESSION.acc#_#FileNo#">
	<cfelse>
		<cfset suf = "#SESSION.acc#">
	</cfif>

</cfif>

<!--- final table3 place holders --->

<cfloop index="no" from="1" to="10">

	<cfset tab = "T#cnt##UserReport.LayOutCode#_qTable#no#_#suf#">
	<cfset CLIENT["table#no#"]    = tab>
	<cfset SESSION["table#no#"]   = tab>

	<cfif UserReport.LayOutCode eq "">
		<cfset CLIENT["table#no#_ds"]  = tab>
		<cfset SESSION["table#no#_ds"] = tab>
	</cfif>

</cfloop>


<cfset st = "1">

<cfif url.formselect neq "sql">
	<cfinclude template="SQLDropTable.cfm">
</cfif>

<cfset variable1    =  "">
<cfset variable2    =  "">
<cfset variable3    =  "">
<cfset variable4    =  "">
<cfset variable5    =  "">
<cfset variable6    =  "">
<cfset variable7    =  "">
<cfset variable8    =  "">
<cfset variable9    =  "">
<cfset variable10   =  "">

<!--- process the request from the form or directly --->


<cfif url.formselect eq "sql">

	<cfoutput>

		<cfset session.parscript = parscript>

		<script>
		ColdFusion.navigate('ReportViewSQL.cfm?layoutid=#UserReport.LayoutId#','reportselection')
	</script>

	</cfoutput>

	<cfabort>

	<cfelseif url.formselect eq "insert" or url.formselect eq "update">

	<cfif validate eq "1">
		<cfinclude template="SelectReportSave.cfm">
	</cfif>

	<cfelseif ParameterExists(Form.Global)>

	<cfinclude template="SelectReportSave.cfm">

	<script>
		window.close()
		self.returnValue = "reload"
	</script>

<cfelse>
<!--- get report definitions --->
	<cf_ReportLocation layoutid="#UserReport.LayoutId#">

<!--- ------------------------------------------- --->
<!--- now create the tables needed for the report --->
<!--- ------------------------------------------- --->

	<cfif URL.mode eq "Form">

		<script language="JavaScript">
			sve  = parent.document.getElementById("email");
			if (sve) { sve.className = "btn" }
		</script>
	</cfif>

	<cfset Status = "1"> <!--- go --->

	<cf_assignId>
	<cfset url.distribid = rowguid>

	<cfif URL.ReportId neq "00000000-0000-0000-0000-000000000000">

<!--- capture report --->
		<cfif (URL.mode eq "Form" or URL.Mode eq "Link" or URL.mode eq "Dashboard")
		and (URL.Status neq "5" or UserReport.LayoutName eq "Export Fields to MS-Excel")>

			<cfparam name="UserReport.DistributionEMail" default="">

<!--- progress status --->
			<cfset session.status = session.status + 0.01>

			<cfif URL.Mode neq "Form">

					<cfinvoke component = "Service.Audit.AuditReport"
							method              = "LogReport"
							DistributionId      = "#rowguid#"
							SystemModule        = "#UserReport.SystemModule#"
							FunctionName        = "#UserReport.FunctionName#"
							LayoutClass         = "#UserReport.LayoutClass#"
							LayoutName          = "#UserReport.LayoutName#"
							FileFormat          = "#UserReport.FileFormat#"
							DistributionPeriod  = "#UserReport.DistributionPeriod#"
							DistributionName    = "#UserReport.DistributionName#"
							DistributionSubject = "#UserReport.DistributionSubject#"
							DistributionEMail   = "#UserReport.DistributionEMail#"
							ControlId           = "#URL.ControlId#"
							ReportId            = "#URL.ReportId#"
							Category            = "#url.category#"
							StatusMode          = "#URL.Mode#"
							Status              = "0"
							UserId              = "#url.userid#">

			<cfelse>

					<cfinvoke component = "Service.Audit.AuditReport"
							method              = "LogReport"
							DistributionId      = "#rowguid#"
							SystemModule        = "#UserReport.SystemModule#"
							FunctionName        = "#UserReport.FunctionName#"
							LayoutClass         = "#UserReport.LayoutClass#"
							LayoutName          = "#UserReport.LayoutName#"
							FileFormat          = "#UserReport.FileFormat#"
							ControlId           = "#UserReport.ControlId#"
							ReportId            = "#URL.ReportId#"
							Category            = "#url.category#"
							StatusMode          = "#URL.Mode#"
							Status              = "0"
							UserId              = "#url.userid#">

			</cfif>

		<cfelse>

			<cfif url.mode eq "Instant">
				<cfset url.category = "Direct Mail">
			</cfif>

			<cfset distributionid = rowguid>

				<cfinvoke component  = "Service.Audit.AuditReport"
						method              = "LogReport"
						DistributionId      = "#rowguid#"
						SystemModule        = "#UserReport.SystemModule#"
						FunctionName        = "#UserReport.FunctionName#"
						LayoutClass         = "#UserReport.LayoutClass#"
						LayoutName          = "#UserReport.LayoutName#"
						FileFormat          = "#UserReport.FileFormat#"
						ControlId           = "#UserReport.ControlId#"
						ReportId            = "#URL.ReportId#"
						Category            = "#url.category#"
						StatusMode          = "#URL.Mode#"
						Status              = "0"
						UserId              = "#url.userid#">

		</cfif>

		<cfif url.mode eq "Instant">

			<cftry>

				<cfif UserReport.TemplateSQLIsolation eq "1">

					<cftransaction isolation="READ_UNCOMMITTED">

						<cfinclude template="#reportSQL#">

					</cftransaction>

				<cfelse>

					<cfinclude template="#reportSQL#">

				</cfif>

				<cfcatch>

					<cfoutput>

						<script language="JavaScript">
						alert("Problem.  Report could not be prepared. Check you subscription or contact your administrator.");
						#ajaxLink('#SESSION.root#/tools/cfreport/ReportSQLInstant.cfm?status=9')#
						</script>

						<cfabort>

					</cfoutput>

				</cfcatch>

			</cftry>

		<cfelse>

			<cfif UserReport.TemplateSQL eq "Application" or UserReport.TemplateSQL eq "External" or UserReport.TemplateSQL eq "">

<!--- data preparation was already finished --->

			<cfelse>

<!--- ------------------- --->
<!--- rundata preparation --->
<!--- ------------------- --->

				<cfif UserReport.TemplateSQLIsolation eq "1">

					<cftransaction isolation="READ_UNCOMMITTED">

						<cfinclude template="#reportSQL#">

					</cftransaction>

				<cfelse>

					<cfinclude template="#reportSQL#">

				</cfif>



			</cfif>

		</cfif>

		<cfif (URL.mode eq "Form" or URL.Mode eq "Link" or URL.mode eq "Dashboard")
		and (URL.Status neq "5" or UserReport.LayoutName eq "Export Fields to MS-Excel")>

			<cfset session.status = session.status + 0.01>

				<cfinvoke component="Service.Audit.AuditReport"
						method              = "EndReport"
						DistributionId      = "#rowguid#">

		<cfelse>

				<cfinvoke component="Service.Audit.AuditReport"
						method              = "EndReport"
						DistributionId      = "#rowguid#">


		</cfif>


		<cf_wait text="Report : Launching.."
				controlid="#ControlId#"
				last="1">

	<cfelse>


		<cfif URL.Status eq "5" and Form.LayOutName eq "Export Fields to MS-Excel">

			<cf_message message = "EMailing an Excel/Analysis is not supported."
					report="1" return = "no">

			<cfexit method="EXITTEMPLATE">

			<cfelseif UserReport.TemplateSQL eq "External">

			<cfoutput>

				<cfset suf = "">

				<cfif FileExists("#rootpath#/#UserReport.ReportPath#/#UserReport.LayoutCode##filecrit#.pdf")>
					<cfset suf = "pdf">
					<cfelseif FileExists("#rootpath#/#UserReport.ReportPath#/#UserReport.LayoutCode##filecrit#.doc")>
					<cfset suf = "doc">
					<cfelseif FileExists("#rootpath#/#UserReport.ReportPath#/#UserReport.LayoutCode##filecrit#.rtf")>
					<cfset suf = "rtf">
					<cfelseif FileExists("#rootpath#/#UserReport.ReportPath#/#UserReport.LayoutCode##filecrit#.xls")>
					<cfset suf = "xls">
					<cfelseif FileExists("#rootpath#/#UserReport.ReportPath#/#UserReport.LayoutCode##filecrit#.htm")>
					<cfset suf = "htm">
					<cfelseif FileExists("#rootpath#/#UserReport.ReportPath#/#UserReport.LayoutCode##filecrit#.xml")>
					<cfset suf = "xml">
					<cfelseif FileExists("#rootpath#/#UserReport.ReportPath#/#UserReport.LayoutCode##filecrit#.swf")>
					<cfset suf = "swf">
				</cfif>

				<cfif suf neq "">

					<cfset attach = "#UserReport.ReportPath#/#UserReport.LayoutCode##filecrit#.#suf#">

					<cfif URL.status eq "5">

						<cffile action="COPY"
								source="#rootpath#/#attach#"
								destination="#SESSION.rootpath#/CFRStage/User/#SESSION.acc#/#UserReport.LayoutCode##filecrit#.#suf#">

						<script language="JavaScript">
								window.location = "#SESSION.root#/Tools/Mail/Mail.cfm?ID1=#UserReport.FunctionName#&ID2=#UserReport.LayoutCode##filecrit#.#suf#&Source=Report&Sourceid=#URL.ReportId#&Mode=Full&GUI=#URL.GUI#"
						</script>

					<cfelse>

						<cfset attach = "#UserReport.ReportPath#/#UserReport.LayoutCode##filecrit#.#suf#">

						<script language="JavaScript">
								window.location = "#root#/#attach#"
						</script>

					</cfif>

				<cfelse>

					<script language="JavaScript">
					alert("Your selected report could not be located. (#root#/#UserReport.ReportPath#/#UserReport.LayoutCode##filecrit#.*)")
				</script>

					<cfabort>

				</cfif>

			</cfoutput>


			<cfelseif UserReport.TemplateSQL eq "Application" or UserReport.TemplateSQL eq "External" or UserReport.TemplateSQL eq "">

			<cfset session.status = "1">

			<cf_wait text  = "Launching report.."
					controlid = "#ControlId#"
					last      = "1">

<!--- skip data preapration as this is done already --->

		<cfelse>

<!--- record report seq actions --->

				<cfinvoke component  = "Service.Audit.AuditReport"
						method              = "LogReport"
						DistributionId      = "#rowguid#"
						SystemModule        = "#UserReport.SystemModule#"
						FunctionName        = "#UserReport.FunctionName#"
						LayoutClass         = "#UserReport.LayoutClass#"
						LayoutName          = "#UserReport.LayoutName#"
						FileFormat          = "#UserReport.FileFormat#"
						ControlId           = "#URL.ControlId#"
						ReportId            = "#URL.ReportId#"
						Category            = "#url.category#"
						StatusMode          = "#URL.Mode#"
						Status              = "0"
						UserId              = "#url.userid#">

			<cfset distributionid = rowguid>

			<cfset session.status = "0.05">

<!--- ------------------------------------------------------------------------- --->
<!--- NOW run the query underlying the report to create answer and final tables --->
<!--- ------------------------------------------------------------------------- --->
			<cftry>

				<cfif UserReport.TemplateSQLIsolation eq "1">

					<cftransaction isolation="READ_UNCOMMITTED">

						<cfinclude template="#reportSQL#">

					</cftransaction>

				<cfelse>

					<cfinclude template="#reportSQL#">

				</cfif>

				<cfcatch>

					<cfset errorMessage = cfcatch.type & cfcatch.message & cfcatch.detail >

					<cfoutput>

						<script>

						if (rpt)
								rpt.src = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=#errorMessage#"
						else
								window.location = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=#errorMessage#"
						</script>

					</cfoutput>

					<cfabort>

				</cfcatch>
			</cftry>

<!--- ---------------------------------------------------- --->
<!--- Query has been completed, and report can be launched --->
<!--- ---------------------------------------------------- --->

			<cfset session.message = "Launching report">
			<cfset session.status = "1">

			<cf_wait text = "Launching report.." controlid = "#ControlId#" last = "1">

<!--- ------------------------ --->
<!--- ----- audit logging ---- --->
<!--- ------------------------ --->

				<cfinvoke component = "Service.Audit.AuditReport"
						method              = "EndReport"
						DistributionId      = "#rowguid#">

		</cfif>


	</cfif>

<!--- ------------------------------------------------------------------------- --->
<!--- NOW output the result of the content in the desired format of the report- --->
<!--- ------------------------------------------------------------------------- --->

<!--- drop temp tables --->
	<cfinclude template="SQLDropAnswer.cfm">

	<cfif url.status eq "0" and URL.Mode neq "Instant">
		<cfparam name="url.statusMessage" default="Processing has finished, no output was generated">
		<cfoutput>
			<script>
			if (rpt)
					rpt.src = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=#url.statusMessage#"
			else
					window.location = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=#url.statusMessage#"
			</script>
		</cfoutput>
		<cf_wait text      = "Stopping report.."
				controlid = "#ControlId#"
				last      = "1">

	<cfelse>

		<cfif (URL.mode eq "Form" or URL.Mode eq "Link"  or URL.mode eq "Dashboard")
		and (URL.Status neq "5" or UserReport.LayoutName eq "Export Fields to MS-Excel")>

			<cfoutput>

				<cfif validate eq "1">

					<cfset URL.ControlId = userreport.controlid>

					<script>
						var tscClientTimeSpan = new Date();
						var tscYear    = tscClientTimeSpan.getFullYear();
						var tscMonth   = tscClientTimeSpan.getMonth() + 1;
						var tscDay     = tscClientTimeSpan.getDate();
						var tscHours   = tscClientTimeSpan.getHours();
						var tscMinutes = tscClientTimeSpan.getMinutes();
						var tscSeconds = tscClientTimeSpan.getSeconds();
					</script>

					<cfif url.mode eq "Dashboard">

						<script language="JavaScript">
						window.open("#SESSION.root#/Tools/CFReport/ReportView.cfm?tscYear="+tscYear+"&tscMonth="+tscMonth+"&tscDay="+tscDay+"&tscHours="+tscHours+"&tscMinutes="+tscMinutes+"&tscSeconds="+tscSeconds+"&distributionid=#rowguid#&Status=#URL.Status#&FileFormat=#Form.FileFormat#&ControlId=#URL.ControlId#&ReportId=#URL.Reportid#&LayoutId=#Form.LayoutId#&Mode=#URL.Mode#&Table1=#table1#&Table2=#table2#&Table3=#table3#&Table4=#table4#&Table5=#table5#&Table6=#table6#&Table7=#table7#&Table8=#table8#&Table9=#table9#&Table10=#table10#&var1=#variable1#&var2=#variable2#&var3=#variable3#&var4=#variable4#&var5=#variable5#&var6=#variable6#&var7=#variable7#&var8=#variable8#&var9=#variable9#&var10=#variable10#&show=#show#","_self")
					</script>

					<cfelse>

<!--- ----------------------------------- --->
<!--- container for presenting the output --->
<!--- ----------------------------------- --->

						<script language="JavaScript">


						try {

							document.getElementById('myprogressbox').className   = "hide"
							document.getElementById('myreportcontent').className = "regular"

							se  = document.getElementById("preview");
							if (se) 	{se.className = "buttonprint"}

							se  = document.getElementById("buttons");
							if (se)		{se.className = "buttonprint"}

							se  = document.getElementById("buttons2");
							if (se)		{se.className = "regular"}

							se  = document.getElementById("stop");
							if (se)		{se.className = "hide"}

							se  = document.getElementById("stopping");
							if (se)		{se.className = "hide"}

							se  = getElementById("requestabort");
							if (se)		{se.className = "hide"}

						} catch(e) {}

						if (rpt) {
								rpt.src = "#SESSION.root#/Tools/CFReport/ReportView.cfm?tscYear="+tscYear+"&tscMonth="+tscMonth+"&tscDay="+tscDay+"&tscHours="+tscHours+"&tscMinutes="+tscMinutes+"&tscSeconds="+tscSeconds+"&distributionid=#rowguid#&Status=#URL.Status#&FileFormat=#Form.FileFormat#&ControlId=#URL.ControlId#&ReportId=#URL.Reportid#&LayoutId=#Form.LayoutId#&Mode=#URL.Mode#&Table1=#table1#&Table2=#table2#&Table3=#table3#&Table4=#table4#&Table5=#table5#&Table6=#table6#&Table7=#table7#&Table8=#table8#&Table9=#table9#&Table10=#table10#&var1=#variable1#&var2=#variable2#&var3=#variable3#&var4=#variable4#&var5=#variable5#&var6=#variable6#&var7=#variable7#&var8=#variable8#&var9=#variable9#&var10=#variable10#&show=#show#"
						} else {
								window.location = "#SESSION.root#/Tools/CFReport/ReportView.cfm?tscYear="+tscYear+"&tscMonth="+tscMonth+"&tscDay="+tscDay+"&tscHours="+tscHours+"&tscMinutes="+tscMinutes+"&tscSeconds="+tscSeconds+"&distributionid=#rowguid#&Status=#URL.Status#&FileFormat=#Form.FileFormat#&ControlId=#URL.ControlId#&ReportId=#URL.Reportid#&LayoutId=#Form.LayoutId#&Mode=#URL.Mode#&Table1=#table1#&Table2=#table2#&Table3=#table3#&Table4=#table4#&Table5=#table5#&Table6=#table6#&Table7=#table7#&Table8=#table8#&Table9=#table9#&Table10=#table10#&var1=#variable1#&var2=#variable2#&var3=#variable3#&var4=#variable4#&var5=#variable5#&var6=#variable6#&var7=#variable7#&var8=#variable8#&var9=#variable9#&var10=#variable10#&show=#show#"
						}
						</script>

					</cfif>

				</cfif>

				<cfabort>

			</cfoutput>

		<cfelse>

			<cfif URL.Status eq "5">

<!--- if mail is selected create a record --->
				<cfset url.saveRefresh = "0">
				<cfinclude template="SelectReportSave.cfm">

			</cfif>

<!--- define suffix -> CFR or CFM --->

			<cfswitch expression="#Form.FileFormat#">
				<cfcase value="FlashPaper"><cfset suffix = "swf"></cfcase>
				<cfcase value="PDF">       <cfset suffix = "pdf"></cfcase>
				<cfcase value="Excel">     <cfset suffix = "xls"></cfcase>
				<cfcase value="RTF">       <cfset suffix = "rtf"></cfcase>
				<cfdefaultcase>			  <cfset suffix = "xls"></cfdefaultcase>
			</cfswitch>

			<cfset fileName = replace(userReport.LayoutName," ","_","ALL")>
			<cfset attach = "#FileName#[#fileNo#].#suffix#">

<!--- prepare the report format for output --->

			<script>

				try {

					document.getElementById('myprogressbox').className   = "hide"
					document.getElementById('myreportcontent').className = "regular"

					se  = document.getElementById("preview");
					if (se) 	{se.className = "buttonprint"}

					se  = document.getElementById("buttons");
					if (se)		{se.className = "buttonprint"}

					se  = document.getElementById("buttons2");
					if (se)		{se.className = "regular"}

					se  = document.getElementById("stop");
					if (se)		{se.className = "hide"}

					se  = document.getElementById("stopping");
					if (se)		{se.className = "hide"}

					se  = getElementById("requestabort");
					if (se)		{se.className = "hide"}

				} catch(e) {}

			</script>

			<cfinclude template="ReportPrepareN.cfm">

		</cfif>

	</cfif>

</cfif>

<cfinclude template="SQLDropAnswer.cfm">







