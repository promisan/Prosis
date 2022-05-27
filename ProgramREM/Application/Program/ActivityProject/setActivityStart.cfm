
<!--- script to set the activity based on the dependency as this was set --->

<cfoutput>

<!--- reset all dependencies of that action --->

	<cfquery name="Activity"
			datasource="AppsProgram"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		SELECT * FROM ProgramActivity
		WHERE  ActivityId  = '#URL.ActivityID#'
	</cfquery>

<!--- This full delete was removed by Armin on 25/2/20202 as Evotecnos had issues now that they are retaking this feature. Instead a new field named Operational was added
	<cfquery name="RemoveDependency"
	     datasource="AppsProgram"
	     username="#SESSION.login#"
	     password="#SESSION.dbpw#">
			DELETE FROM ProgramActivityParent
			WHERE  ActivityId  = '#URL.ActivityID#'
			AND    ProgramCode = '#Activity.ProgramCode#'
	</cfquery>
--->
	<cfquery name="qUpdateOperational"
			datasource="AppsProgram"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		UPDATE ProgramActivityParent
		SET Operational = 0
		WHERE  ActivityId  = '#URL.ActivityID#'
		AND    ProgramCode = '#Activity.ProgramCode#'
	</cfquery>


<!--- record all entered dependencies of this action --->

	<cfparam name="form.parent" default="">

	<cfif Form.parent neq "">

		<cfloop index="Itm"
				list="#Form.Parent#"
				delimiters="' ,">



			<cfparam name="Form.StartAfter#itm#" default="Completion">
			<cfparam name="Form.StartAfterDays#itm#" default="1">

			<cfset sa = evaluate("Form.StartAfter#itm#")>
			<cfset sd = evaluate("Form.StartAfterDays#itm#")>

			<cfquery name="qCheck"
					datasource="AppsProgram"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
				SELECT * FROM ProgramActivityParent
				WHERE
				ProgramCode = '#Activity.ProgramCode#'
				AND ActivityPeriod = '#Activity.ActivityPeriod#'
				AND ActivityId = '#URL.ActivityId#'
				AND ActivityParent = '#Itm#'
			</cfquery>

			<cfif qCheck.recordcount eq 0>
				<cfquery name="InsertClass"
						datasource="AppsProgram"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
					INSERT INTO ProgramActivityParent
					(ProgramCode,
					ActivityPeriod,
					ActivityId,
					ActivityParent,
					StartAfter,
					StartAfterDays,
					Operational,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName)
					Values (
					'#Activity.ProgramCode#',
				'#Activity.ActivityPeriod#',
				'#URL.ActivityID#',
				'#Itm#',
				'#sa#',
				'#sd#',
				1,
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
				</cfquery>
			<cfelse>
				<cfquery name="qUpdate"
						datasource="AppsProgram"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
					UPDATE ProgramActivityParent
					SET StartAfter = '#sa#',
					StartAfterDays = '#sd#',
					Operational = 1
				WHERE
					ProgramCode = '#Activity.ProgramCode#'
					AND ActivityPeriod = '#Activity.ActivityPeriod#'
					AND ActivityId = '#URL.ActivityId#'
					AND ActivityParent = '#Itm#'
				</cfquery>
			</cfif>

		</cfloop>

		<!---
		<cfquery name="RemoveDependency"
				datasource="AppsProgram"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			DELETE FROM ProgramActivityParent
			WHERE  ActivityId  = '#URL.ActivityID#'
			AND    ProgramCode = '#Activity.ProgramCode#'
			AND Operational = 0
		</cfquery>
		--->

	</cfif>

<!--- ---------------  METHOD  --------------------------- --->
<!--- define all tasks that are dependent on this activity --->
<!--- ---------------------------------------------------- --->

	<cf_ActivityRelation
			ProgramCode="#Activity.ProgramCode#"
			ActivityId="#URL.ActivityId#">

<!--- determine the earliest start date of the activiy based on its parents --->

	<cfquery name="Date"
			datasource="AppsProgram"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		SELECT  *
		FROM    ProgramActivity A,
		ProgramActivityParent B
		WHERE   A.ActivityId = B.ActivityParent
		AND     B.ActivityId = '#url.ActivityId#'
	</cfquery>

	<cfif date.recordcount eq "0">

		<cfset dateValue = "">
		<CF_DateConvert Value="#form.activitydatestart#">
		<cfset earliest = dateValue>

	<cfelse>

		<cfset earliest = "">

		<cfloop query="date">

			<cfif startafter eq "completion">

				<cfset dte = DateAdd("d", StartAfterDays, ActivityDate)>

			<cfelse>

				<cfset dte = DateAdd("d", StartAfterDays, ActivityDateStart)>

			</cfif>

			<cfif earliest eq "">
				<cfset earliest = dte>
				<cfelseif dte gt earliest>
				<cfset earliest = dte>
			</cfif>

		</cfloop>

	</cfif>

	<cfset ActDateStart = earliest>

	<cfif Form.Selectme eq "Duration">

		<cfset ActDate = DateAdd("d", form.activitydays, ActDateStart)>

	<cfelse>

		<cfset dateValue = "">
		<CF_DateConvert Value="#form.activitydate#">
		<cfset ActDate = dateValue>

	</cfif>

<!--- now determine the correct start date without saving the action itself --->

	<cfset str = dateformat(ActDateStart,CLIENT.DateFormatShow)>
	<cfset end = dateformat(ActDate,CLIENT.DateFormatShow)>
	<cfset day = DateDiff("d", ActDateStart,ActDate)>

	<cfif date.recordcount eq "0">

		<script language="JavaScript">
			datePickerController.disable("activitydatestart")
			datePickerController.enable("activitydatestart")
		</script>

	<cfelse>

		<script>
		datePickerController.disable("activitydatestart")
				document.getElementById("activitydatestart").value = '#str#'
		document.getElementById("activitydate").value      = '#end#'
		document.getElementById("activitydays").value      = '#day#'
		</script>

	</cfif>

</cfoutput>

