<cfset vStatusList = "Pending,InProgress,ResolutionDetermined,Completed">

<cfloop list="#vStatusList#" index="st">

	<cfset vEndStatus = "GETDATE()">
	
	<cfif st eq "Pending">
		<cfset vStatus = 0>
	</cfif>
	<cfif st eq "InProgress">
		<cfset vStatus = 1>
	</cfif>
	<cfif st eq "ResolutionDetermined">
		<cfset vStatus = 2>
	</cfif>
	<cfif st eq "Completed">
		<cfset vStatus = 3>
		<cfsavecontent variable="vEndStatus">
			(
				SELECT TOP 1 OfficerDate
				FROM	Organization.dbo.OrganizationObjectAction
				WHERE	ObjectId = O.ObservationId
				ORDER BY ActionFlowOrder DESC
			)
		</cfsavecontent>
	</cfif>
	
	<cfquery name="getTickets#st#" 
			datasource="AppsControl" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT	CAST(CAST(Year AS varchar) + '-' + CAST(Month AS varchar) + '-01' AS DATETIME) as MonthValue,
						DateValue,
						ROUND(AVG(LeadTime/24.0),1) as LeadTime
				FROM	
					(
						SELECT	YEAR(O.Created) AS Year,
								MONTH(O.Created) AS Month,
								CONVERT(VARCHAR(7),O.Created,120) as DateValue,
								DATEDIFF(HOUR, O.Created, #vEndStatus#) as LeadTime
						FROM	Observation O
						WHERE	O.ActionStatus = '#vStatus#'
						AND		O.Created BETWEEN #vInit# AND #vEnd#
					) as Data
				GROUP BY
						Year,
						Month, 
						DateValue
				ORDER BY 
						1 DESC
	
	</cfquery>

</cfloop>

<cfset vColorList = "">
<cfset vShuffleColorArray = colorArray>
<cfset CreateObject("java","java.util.Collections").Shuffle(vShuffleColorArray)>
<cfloop index="cl" from="1" to="1">
	<cfset vColorList = vColorList & vShuffleColorArray[cl] & ",">
</cfloop>
<cfset vColorList = mid(vColorList, 1, len(vColorList)-1)>

<cfif vGenerateFile eq 1>

	<cfchart 
		<!--- style="#chartStyleFile#"  --->
		name="myChart"
		format="png"
		showLegend="yes" 
		seriesplacement="#vPlacement#"
	   	chartheight="350" 
	   	chartwidth="650" 
		pieslicestyle="sliced">
			
			<cfloop list="#vStatusList#" index="st">
			
				<cfchartseries 
						type="#url.type#" 
						query="getTickets#st#" 
						serieslabel="#st#" 
						itemcolumn="DateValue" 
						valuecolumn="LeadTime" 
						colorlist="#vColorList#">
				</cfchartseries>
			
			</cfloop>
			
	</cfchart>

<cfelse>
	
	<cfchart 
		<!--- style="#chartStyleFile#"  --->
		format="png"
		showLegend="yes" 
		seriesplacement="#vPlacement#"
	   	chartheight="350" 
	   	chartwidth="650" 
		pieslicestyle="sliced"
		url="javascript:supportDrill('$VALUE$','$ITEMLABEL$','$SERIESLABEL$','#url.id#')">
			
			<cfloop list="#vStatusList#" index="st">
			
				<cfchartseries 
						type="#url.type#" 
						query="getTickets#st#" 
						serieslabel="#st#" 
						itemcolumn="DateValue" 
						valuecolumn="LeadTime" 
						colorlist="#vColorList#">
				</cfchartseries>
			
			</cfloop>
			
	</cfchart>


</cfif>
