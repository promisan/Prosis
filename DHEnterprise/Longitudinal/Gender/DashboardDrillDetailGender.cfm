<cfparam name="url.personGrade"		default="">
<cfparam name="thisPeriodicity"   default="0">

<cfset thisTemplate = "DashboardRetirement.cfm">
<cfinclude template = "getMenu.cfm">

<cfif url.level eq "null">
	<cfset url.level = "">
</cfif>
<cfset url.level = replace(url.level, "'", "", "ALL")>
<cfset url.level = ListQualify(url.level, "'")>

<cfquery name="getData" 
	datasource="martStaffing">		 
		SELECT   *,
				 #vField# as GradeField,
				 #vField#Order as GradeOrderField,
				 #vField#Parent as GradeParentField
		FROM     Gender G
		WHERE    1=1
		AND 	 Mission        = '#URL.Mission#'
		AND      Incumbency     = '100'
		AND      SelectionDate  = '#URL.Date#'
		AND    TransactionType 	  = '#thisPeriodicity#'
		
		<cfif URL.Seconded eq "1">
			AND    AppointmentType NOT IN ('04')
			AND    ContractTerm NOT IN ('100','125','250')
			AND    left(#vField#,1) IN ('P','D')

			<cfif url.personGrade neq "">
				AND   #getParams.GenderField# = '#url.personGrade#'
				</cfif>	
		<cfelseif URL.Seconded eq "5">
		AND       PositionSeconded   = '#URL.Seconded#'	
		<cfif url.personGrade neq "">
				AND   #getParams.CurrentField# = '#url.personGrade#'
				</cfif>
		<cfelse>
		
		<cfif url.personGrade neq "">
				AND   #getParams.CurrentField# = '#url.personGrade#'
				</cfif>	
		</cfif>	
		
		<cfif URL.Uniformed eq "1">	
			AND    PositionSeconded   = '1'
		<cfelseif URL.Uniformed eq "0">
			AND    PositionSeconded   = '0' 
		</cfif>		
		
		<cfif url.level neq "">
		
			<!-----
			<cfif URL.Seconded eq "1">		
			AND     left(GradeContract,2) IN (#preserveSingleQuotes(url.level)#)
			<cfelse>
			AND     left(PositionGrade,2) IN (#preserveSingleQuotes(url.level)#)
			</cfif>
			this logic was used in the call of this template, so we avoid here.
			----->
			AND     left(#vField#,2) IN (#preserveSingleQuotes(url.level)#)
		
		</cfif>
		
		<cfif trim(url.division) neq "">
		AND      MissionParent = '#url.division#'
		</cfif>
		<cfif trim(url.gender) neq "">
		AND 	Gender = '#url.gender#'
		</cfif>
		<cfif trim(url.context) neq "" AND trim(url.context) neq "undefined" AND trim(url.contextValue) neq "" AND trim(url.contextValue) neq "undefined">
		AND 	#url.context# = '#url.contextValue#'
		</cfif>
		ORDER BY #vField#Order ASC
</cfquery>

<table class="detailContent table table-striped table-bordered table-hover clsNoPrint" style="width:100%">
	<thead>
		<tr>
			<th><cf_tl id="Index"></th>
			<th><cf_tl id="Name"></th>
			
			<th><cf_tl id="S"></th>
						<!---
			<th><cf_tl id="Parent"></th>
			--->
			<th><cf_tl id="Grade"></th>

			<th><cf_tl id="Order"></th>
			<th><cf_tl id="Function"></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="getData">
			<tr>
				<td>
					<cfif vDrillAccess>
						<a href="#session.root#/Staffing/Application/Employee/PersonView.cfm?ID=#indexno#" target="_blank" style="color:##358FDE;">#IndexNo#</a>
					<cfelse>
						#IndexNo#
					</cfif>
				</td>
				<td>#Lastname#, #FirstName#</td>				
				<td>#Gender#</td>				
				<!---
				<td>#GradeParentField#</td>
				--->
				<td>#GradeField#</td>
				<td>#GradeOrderField#</td>
				<td>#JobCodeName#</td>
			</tr>
		</cfoutput>
	</tbody>
</table>

<!--- USED FOR PRINTING --->
<table class="detailContentExpanded table table-striped table-bordered table-hover" style="width:100%; display:none;">
	<thead>
		<tr>
			<th><cf_tl id="IndexNo"></th>
			<th><cf_tl id="Name"></th>
			<th><cf_tl id="Gender"></th>
			<th><cf_tl id="Parent"></th>
			<th><cf_tl id="Grade"></th>
			<th><cf_tl id="Function"></th>
		</tr>
	</thead>
	
	<tbody>
		<cfoutput query="getData">
			<tr>
				<td>
					<a href="#session.root#/Staffing/Application/Employee/PersonView.cfm?ID=#indexno#" target="_blank" style="color:##358FDE;">#IndexNo#</a>
				</td>
				<td>#Lastname#, #FirstName#</td>
				<td>#Gender#</td>
				<td>#GradeParentField#</td>
				<td>#GradeField#</td>
				<td>#JobCodeName#</td>
			</tr>
		</cfoutput>
	</tbody>
</table>