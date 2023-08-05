
<cfparam name="url.assignmentclass" default="">
<cfparam name="url.mission" default="">
<cfparam name="url.imcumbency" default="100">

<cfquery name="AssignmentClass" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	     SELECT *
	     FROM   Ref_AssignmentClass
		 WHERE (Incumbency = '#url.incumbency#' or AssignmentClass = 'regular')
		 AND    Operational = 1
		 AND    AssignmentClass in (SELECT AssignmentClass FROm Ref_AssignmentClassMission WHERE Mission = '#url.mission#')
		 ORDER BY ListingOrder
</cfquery>	

<cfif AssignmentClass.recordcount eq "0">
	
	<cfquery name="AssignmentClass" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		     SELECT *
		     FROM   Ref_AssignmentClass
			 WHERE (Incumbency = '#url.incumbency#' or AssignmentClass = 'regular')
			  AND    Operational = 1
			  ORDER BY ListingOrder
	</cfquery>	

</cfif>

<select name="AssignmentClass" id="assignmentclass" size="1" class="regularxl">
	    <cfoutput query="AssignmentClass">
		<option value="#AssignmentClass#" <cfif url.AssignmentClass eq AssignmentClass>selected</cfif>>#Description#</option>
		</cfoutput>
</select>