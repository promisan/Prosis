<cfparam name="url.gender" 		    default="">
<cfparam name="url.context" 		default="">
<cfparam name="url.contextValue" 	default="">
<cfparam name="url.division" 		default="">
<cfparam name="url.level"   		default="">
<cfparam name="url.source" 			default="Gender">

<cfinclude template="../CheckDrillAccess.cfm">

<cfset url.contextValue = URLDecode(url.contextValue)>

<cfif Session.Gender["Mode"] eq "1">
   <cfset vField = "GradeContract">
<cfelse>
   <cfset vField = "PositionGrade">
</cfif>

<cfif url.source eq "Gender">
	<cfinclude template="DashboardDrillDetailGender.cfm">
<cfelse>
	<cfinclude template="DashboardDrillDetailRecruitment.cfm">
</cfif>

<cfset ajaxOnLoad("function(){ $('.detailContent').DataTable({ 'pageLength':25, 'dom':'<\'dataTableWrapper\'f><\'dataTableWrapper\'ip>t<\'dataTableWrapper\'lr>', 'order': [[4, 'asc']], 'columnDefs':[{'orderData':[5], 'targets':[4]},{'targets':[5],'visible':false,'searchable':false}] }); }")>