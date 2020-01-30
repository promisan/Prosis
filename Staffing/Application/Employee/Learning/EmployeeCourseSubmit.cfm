
<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateCompleted#">
<cfset DTE = dateValue>

<!--- check --->

<cfquery name="Check" 
	datasource="AppsLearning" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM PersonCourse 
		WHERE PersonNo    = '#Form.PersonNo#'
		AND   CourseCode  = '#Form.Code#'
		AND   DateCompleted = #DTE#		
</cfquery>

<cfif check.recordcount eq "0" and form.id neq "">

	<cfquery name="Course" 
	datasource="AppsLearning" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO  PersonCourse 
			( RecordId,
			  PersonNo, 
			  CourseCode,
			  DateCompleted,
			  CourseResult,
			  CourseMemo,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
		VALUES 
			( '#Form.Id#',
			  '#Form.PersonNo#',
			  '#Form.Code#',
			  #DTE#,
			  '#Form.CourseResult#',
			  '#Form.CourseMemo#',
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#') 
	</cfquery>
	
<cfelse>

	<cfquery name="Course" 
	datasource="AppsLearning" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE PersonCourse 
		SET    CourseResult = '#Form.CourseResult#',
		       CourseMemo   = '#Form.CourseMemo#'
		<cfif form.id eq "">
		WHERE  RecordId = '#Check.RecordId#'	
		<cfelse>	
		WHERE  RecordId = '#Form.Id#'		
		</cfif>
	</cfquery>
	
</cfif>	

<cfoutput>

	<script>
		ColdFusion.Window.hide('dialog')	
		ColdFusion.navigate('EmployeeCourseDetail.cfm?code=#Form.code#&personno=#form.personNo#','#Form.code#')	
	</script>	
		
</cfoutput>

	
