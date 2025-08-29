<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

	
