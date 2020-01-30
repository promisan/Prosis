
<cfquery name="removeTopics"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM	FunctionRequirementLine
		WHERE	RequirementId = '#url.reqid#'
		AND		Parent = '#url.area#'
</cfquery>

<cfquery name="get"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	T.Topic, 
				TL.ListCode,
				TL.ListValue
		FROM	Ref_Topic T
				INNER JOIN Ref_TopicList TL
					ON T.Topic = TL.Code
		WHERE	T.Operational = 1
		AND		T.Parent = '#url.area#'
		ORDER BY  T.ListingOrder ASC,
				  TL.ListOrder ASC
</cfquery>

<cfoutput query="get" group="topic">

	<cftransaction>
	
		<cfquery name="getLastLine"
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM	FunctionRequirementLine
				WHERE	RequirementId = '#url.reqid#'
				ORDER BY RequirementLineNo DESC
		</cfquery>
		
		<cfset vNewLine = 0>
		<cfif getLastLine.recordCount eq 1>
			<cfset vNewLine = getLastLine.RequirementLineNo + 1>
		</cfif>
	
		<cfquery name="insertLine"
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				INSERT INTO FunctionRequirementLine
					(
						RequirementId,
						RequirementLineNo,
						Parent,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.reqid#',
						'#vNewLine#',
						'#url.area#',
						'#session.acc#',
						'#session.last#',
						'#session.first#'
					)
			
		</cfquery>
	
		<cfset cnt = 0>
		
		<cfoutput>
		
			<cfif isDefined("Form.level_#topic#_#ListCode#")>
			
				<cfquery name="insertTopic"
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						INSERT INTO FunctionRequirementLineTopic
						(
							RequirementId,
							RequirementLineNo,
							Topic,
							ListCode,
							TopicValue,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
						VALUES
						(
							'#url.reqid#',
							'#vNewLine#',
							'#topic#',
							'#ListCode#',
							'#ListValue#',
							'#session.acc#',
							'#session.last#',
							'#session.first#'
						)
					
				</cfquery>
				
				<cfset cnt = cnt + 1>
				
			</cfif>
			
		</cfoutput>
		
		<cfif cnt eq 0>
		
			<cfquery name="deleteEmptyLine"
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					DELETE
					FROM 	FunctionRequirementLine
					WHERE	RequirementId = '#url.reqid#'
					AND		RequirementLineNo = '#vNewLine#'
				
			</cfquery>
		
		</cfif>
	
	</cftransaction>
	
</cfoutput>


<cfoutput>
	<script>
		ColdFusion.navigate('#session.root#/Roster/Maintenance/FunctionalTitles/FunctionBuilder/FunctionRequirementLine.cfm?ID=#URL.ID#&ID1=#URL.ID1#&idMenu=#url.idmenu#&box=#url.box#&parentCode=#url.area#&requirementId=#url.reqid#','#url.box#');
		ColdFusion.Window.destroy('mytopic');
	</script>
</cfoutput>
