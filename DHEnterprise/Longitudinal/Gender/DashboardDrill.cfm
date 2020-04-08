<cfparam name="url.context" 		default="">
<cfparam name="url.contextValue" 	default="">
<cfparam name="url.division" 		default="">
<cfparam name="url.level" 			default="">
<cfparam name="url.personGrade"		default="">
<cfparam name="url.source" 			default="Gender">

<cfset thisTemplate = "DashboardRetirement.cfm">
<cfinclude template = "determineMission.cfm">

<cfset url.contextValue = URLDecode(url.contextValue)>

<cfif url.context neq "">
	<cf vField	=	"#url.context#">
<cfelse>
	<!---- overwrite ---->
	<cfif url.seconded eq "1">
		<cfset vField = "GradeContract">
	<cfelse>
		<cfset vField = "PositionGrade">
	</cfif>
	
</cfif>

<div style="overflow-x:auto; width:95%; margin: 0 auto;">
	<cfif url.source eq "Gender">
		<cfinclude template="DashboardDrillGender.cfm">
	<cfelse>
		<cfinclude template="DashboardDrillRecruitment.cfm">
	</cfif>
</div>