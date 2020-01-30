<cf_getChartStyle showLegend="yes" chartLocation="#GetCurrentTemplatePath()#">

<cfif url.by eq "average leading days">

	<cfinclude template="LeadingStatistics.cfm">

<cfelse>
	<cfif vGenerateFile eq 1>
			
		<cfchart 
			style="#chartStyleFile#" 
			name="myChart"
			format="png"
			showLegend="yes" 
			seriesplacement="#vPlacement#"
		   	chartheight="400" 
		   	chartwidth="400" 
			pieslicestyle="sliced">
			
				<cfif url.type neq "pie">
			
					<cfquery name="getTicketsDistinctTopics" dbtype="query">
						SELECT DISTINCT Topic, TopicValue
						FROM	getTicketsByDateTopic
						ORDER BY TopicValue
					</cfquery>
					
					<cfset currentColor = -1>
					<cfset previousColor = -1>

					<cfloop query="getTicketsDistinctTopics">
					
						<cfset currentColor = RandRange(1,ArrayLen(colorArray))>
						<cfloop condition="currentColor eq previousColor">
							<cfset currentColor = RandRange(1,ArrayLen(colorArray))>
						</cfloop>
						
						<cfchartseries 
							serieslabel="#TopicValue#" 
							seriescolor="#colorArray[currentColor]#" 
							type="#url.type#">
							<cfquery name="getTicketsGroupedTopic" dbtype="query">
								SELECT 	*
								FROM	getTicketsByDateTopic
								WHERE	Topic = '#Topic#'
							</cfquery>
							<cfloop query="getTicketsGroupedTopic">
								<cfchartdata item="#DateValue#" value="#TopicTotal#">
							</cfloop>
						</cfchartseries>
						
						<cfset previousColor = currentColor>
						
					</cfloop>
				
				<cfelse>
				
					<cfquery name="getTicketsGroupedTopic" dbtype="query">
						SELECT 	Topic,
								TopicValue,
								SUM(TopicTotal) AS TopicTotal
						FROM	getTicketsByDateTopic
						GROUP BY
								Topic,
								TopicValue
					</cfquery>
					
					<cfset vColorList = "">
					<cfset vShuffleColorArray = colorArray>
					<cfset CreateObject("java","java.util.Collections").Shuffle(vShuffleColorArray)>
					<cfloop index="cl" from="1" to="#ArrayLen(vShuffleColorArray)#">
						<cfset vColorList = vColorList & vShuffleColorArray[cl] & ",">
					</cfloop>
					<cfset vColorList = mid(vColorList, 1, len(vColorList)-1)>
					
					<cfchartseries 
							type="#url.type#" 
							query="getTicketsGroupedTopic" 
							itemcolumn="TopicValue" 
							valuecolumn="TopicTotal" 
							colorlist="#vColorList#">
					</cfchartseries>
				
				</cfif>
				
		</cfchart>
	
	<cfelse>
	
		<!--- <cfdump var="#getTicketsByDateTopic#"> --->
	
		<cfchart 
			style="#chartStyleFile#" 
			format="png"
			showLegend="yes" 
			seriesplacement="#vPlacement#"
		   	chartheight="400" 
		   	chartwidth="400" 
			pieslicestyle="sliced"
			url="javascript:supportDrill('$VALUE$','$ITEMLABEL$','$SERIESLABEL$','#url.id#')">
			
				<cfif url.type neq "pie">
					
					<cfset currentColor = -1>
					<cfset previousColor = -1>
					<cfoutput query="getTicketsByDateTopic" group="Topic">
					
						<cfset currentColor = RandRange(1,ArrayLen(colorArray))>
						<cfloop condition="currentColor eq previousColor">
							<cfset currentColor = RandRange(1,ArrayLen(colorArray))>
						</cfloop>
						
						<cfchartseries 
							serieslabel="#TopicValue#" 
							seriescolor="#colorArray[currentColor]#"  
							type="#url.type#">
							<cfoutput>
								<cfchartdata item="#DateValue#" value="#TopicTotal#">
							</cfoutput>
						</cfchartseries>
						
						<cfset previousColor = currentColor>
						
					</cfoutput>
				
				<cfelse>
				
					<cfquery name="getTicketsGroupedTopic" dbtype="query">
						SELECT 	Topic,
								TopicValue,
								SUM(TopicTotal) AS TopicTotal
						FROM	getTicketsByDateTopic
						GROUP BY
								Topic,
								TopicValue
					</cfquery>
					
					<cfset vColorList = "">
					<cfset vShuffleColorArray = colorArray>
					<cfset CreateObject("java","java.util.Collections").Shuffle(vShuffleColorArray)>
					<cfloop index="cl" from="1" to="#ArrayLen(vShuffleColorArray)#">
						<cfset vColorList = vColorList & vShuffleColorArray[cl] & ",">
					</cfloop>
					<cfset vColorList = mid(vColorList, 1, len(vColorList)-1)>
					
					<cfchartseries 
							type="#url.type#" 
							query="getTicketsGroupedTopic" 
							itemcolumn="TopicValue" 
							valuecolumn="TopicTotal" 
							colorlist="#vColorList#">
					</cfchartseries>
				
				</cfif>
				
		</cfchart>
	
	</cfif>

</cfif>

<cftry>
	<cffile action="DELETE" file="#vImagePath##url.id#.png">
	<cfcatch></cfcatch>
</cftry>

<cffile action="WRITE" file="#vImagePath##url.id#.png" output="#myChart#" nameconflict="OVERWRITE">