<cfquery name="Grade" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_PostGrade
		WHERE  PostGrade = '#url.grade#'
	</cfquery>

<cfoutput>

<select name="contractstep" class="regularxl" style="width:50px;border-top:0px;border-bottom:0px;border-right:0px;border-left:0px">

	<cfloop index="st" from="1" to="#grade.PostGradeSteps#">
		<option value="#st#" <cfif url.step eq st>selected</cfif>>#st#</option>
	</cfloop>	
	
</select>	
</cfoutput>