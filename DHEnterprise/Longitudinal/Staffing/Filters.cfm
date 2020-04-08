<cfparam name="URL.Mission" default="SCBD">

<cfoutput>
	<cf_mobileRow>

		<cf_mobileCell class="col-lg-2 text-center m-t-md">

			<cfquery name="qMission" 
				datasource="appsOrganization">		 
					SELECT   DISTINCT Mission
					FROM     Ref_Mission
			</cfquery>

			<select class="form-control" name="pMission" id="pMission" 
				onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
				<cfloop query="qMission">
					<cfset vEntity=Trim(qMission.Mission)>		
					<option value="#vEntity#" <cfif vEntity eq URL.Mission>selected='selected'</cfif>>#vEntity#</option>
				</cfloop>
			</select>
			
		</cf_mobileCell>

		<cf_mobileCell class="col-lg-2 text-center m-t-md">

			<cfquery name="qDate" 
				datasource="appsOrganization">		 
					SELECT   DISTINCT SelectionDate
					FROM     NYVM1617.MartStaffing.dbo.Position
					ORDER BY 1 DESC
			</cfquery>
			
			<cfparam name="URL.Date" default="#qDate.SelectionDate#">

			<select class="form-control" name="pDate" id="pDate" 
				onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')">
				<cfloop query="qDate">		
					<option value="#SelectionDate#" <cfif SelectionDate eq URL.date>selected='selected'</cfif>>#SelectionDate#</option>
				</cfloop>
			</select>
		
			
		</cf_mobileCell>
		
		<cf_mobileCell class="col-lg-2 text-center m-t-md">

			<cfquery name="qGrade" 
				datasource="appsOrganization">		 
					SELECT   DISTINCT PostGrade, PostOrder
					FROM     NYVM1617.MartStaffing.dbo.Position
					ORDER BY PostOrder
			</cfquery>
			
			<cfparam name="URL.level" default="#qGrade.PostGrade#">

			<select name="pLevel" id="pLevel" multiple="multiple" onchange="applyFilter('#vTemplate#','#URL.showdivision#', 'statsDetail')" style="width:200px;">
				<cfloop query="qGrade">		
					<option value="#PostGrade#" <cfif PostGrade eq URL.level>selected='selected'</cfif>>#PostGrade#</option>
				</cfloop>
			</select>
		
			
		</cf_mobileCell>

	</cf_mobileRow>
	
</cfoutput>

<cfset ajaxOnload("function(){ $('##pLevel').multipleSelect().multipleSelect('checkAll'); }")>

<br>