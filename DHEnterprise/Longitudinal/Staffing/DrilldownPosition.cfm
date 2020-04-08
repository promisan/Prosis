
<cfinclude template="../CheckDrillAccess.cfm">

<cfif url.level eq "null">
	<cfset url.level = "">
</cfif>
<cfset url.level = replace(url.level, "'", "", "ALL")>
<cfset url.level = ListQualify(url.level, "'")>

<cfquery name="getData" 
	datasource="AppsOrganization">
	SELECT   *,
			(SELECT TOP 1 PositionNo FROM Employee.dbo.Position Px WHERE LTRIM(RTRIM(SourcePostNumber)) = LTRIM(RTRIM(P.PositionId)) ORDER BY Created DESC) as PositionNo		 
	FROM     NYVM1617.MartStaffing.dbo.Position P
	WHERE    (SelectionDate = '#URL.Date#') and Mission = '#URL.Mission#'
	AND		PostGrade = '#url.postgrade#'
	AND 	PostType = '#url.posttype#'
	<cfif url.level neq "">
	AND 	Postgrade IN (#preserveSingleQuotes(url.level)#)
	</cfif>
	ORDER BY PostOrder, PostType
</cfquery>

<div style="padding-top:50px;" class="table-responsive">
	<table class="detailContentPositions table table-striped table-bordered table-hover">
		<thead>
			<tr>
				<th><cf_tl id="PositionId"></th>
				<th><cf_tl id="Function"></th>
				<th><cf_tl id="IndexNo"></th>
				<th><cf_tl id="Name"></th>
				<th><cf_tl id="Gender"></th>
				<th><cf_tl id="Unit"></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="getData">
				<tr>
					<td>
						<cfif trim(PositionNo) neq "" AND vDrillAccess>
							<a href="javascript:showPosition('#PositionNo#')" style="color:##2F98F4;">#PositionId#</a>
						<cfelse>
							#PositionId#
						</cfif>
					</td>
					<td>#FunctionTitle#</td>
					<td>
						<cfif vDrillAccess>
							<a href="javascript:showPerson('#IndexNo#')" style="color:##2F98F4;">#IndexNo#</a>
						<cfelse>
							#IndexNo#
						</cfif>
					</td>
					<td>#ucase(LastName)#, #FirstName#</td>
					<td>#Gender#</td>
					<td>#OrgUnitNameShort#</td>
				</tr>
			</cfoutput>
		</tbody>
	</table>
</div>

<cfset ajaxOnLoad("function(){ $('.detailContentPositions').DataTable({ responsive:true }); }")>