<cfquery name="Item" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Item
		WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<cfquery name="ItemMaster" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemMaster
		WHERE 	Code = '#Item.ItemMaster#'
</cfquery>

<cfquery name="getTopics" 
	datasource="AppsMaterials"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	T.*
		FROM    Ref_Topic T
				INNER JOIN Ref_TopicEntryClass C
					ON T.Code = C.Code
					AND C.EntryClass = '#ItemMaster.EntryClass#'
					AND T.Operational = 1 
					AND C.ItemPointer != 'UoM'
					AND ValueClass IN ('List','Lookup')
		
		UNION 
		
		SELECT   T.*
		FROM     Ref_Topic T
		WHERE    T.TopicClass = 'Details'
		
		ORDER BY T.ListingOrder ASC 
</cfquery>

<cfquery name="Classification" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemClassification C
		WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<cfquery name="TopicList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	* 
		FROM 	Ref_TopicList
</cfquery>

<cfloop query="getTopics">

	<cfif TopicClass eq "Details">
	
		<cfset tbcl = "ItemTopicValue">					
		
		<cfquery name="Classification" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	ItemTopicValue C
				WHERE 	ItemNo = '#URL.ID#'				
		</cfquery>
		
	<cfelse>
		
		<cfset tbcl = "ItemClassification">
		
						
		<cfquery name="Classification" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT 	*
				FROM 	ItemClassification C
				WHERE 	ItemNo = '#URL.ID#'
		</cfquery>
				
	</cfif>	
		
	<cfif isDefined("Form.Topic_#getTopics.Code#")>
	
		<cfset vValue = Evaluate("Form.Topic_#getTopics.Code#")>
		
		<cfquery name="qItemClassification" dbtype="query">
			SELECT 	*
			FROM 	Classification
			WHERE 	Topic = '#Code#'
		</cfquery>
		
		<cfquery name="qTopicList" dbtype="query">
			SELECT 	*
			FROM 	TopicList
			WHERE 	Code     = '#Code#'
			AND 	ListCode = '#vValue#'
		</cfquery>
		
		
		<cfif trim(vValue) eq "">
				
			<cfquery name="Delete" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE 
					FROM	#tbcl#
					WHERE   ItemNo = '#url.id#'
					AND     Topic = '#getTopics.code#'
			</cfquery>
		
		<cfelse>
						
			<cfif qItemClassification.recordCount eq 0>
			
												
				<cfif TopicClass eq "Details">					
				
					<cftry>			
									
					<cfquery name="Insert" 
						datasource="appsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO ItemTopic (
									ItemNo,
									Topic,	
									<cfif valueClass eq "List">
									ListCode,
									</cfif>
									TopicValue,							
									OfficerUserId,
									OfficerLastName,
									OfficerFirstName
								) VALUES (
									'#url.id#',
									'#getTopics.code#',		
									<cfif valueClass eq "List">
									'#vValue#',
									</cfif>
									'#vValue#',						
									'#SESSION.acc#',
									'#SESSION.last#',
									'#SESSION.first#'
								)
					</cfquery>
					
					<cfcatch></cfcatch>
					
					</cftry>
					
				</cfif>
			
				<cfquery name="Insert" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						INSERT INTO #tbcl# (
								ItemNo,
								Topic,	
								<cfif valueClass eq "List">		
								ListCode,					
								</cfif>
								TopicValue,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							) VALUES (
								'#url.id#',
								'#code#',	
								<cfif valueClass eq "List">	
								'#vValue#',					
								</cfif>	
								'#vValue#',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#'
							)
				</cfquery>
	
			<cfelse>
						
				<cfquery name="Update" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE #tbcl#
						SET	   TopicValue = '#vValue#'
						       <cfif valueClass eq "List">
							   , ListCode = '#vValue#'</cfif>
						WHERE  ItemNo     = '#url.id#'
						AND    Topic      = '#getTopics.code#'
				</cfquery>
			
			</cfif>
		
		</cfif>
		
	</cfif>

</cfloop>

<cfoutput>
	<script>
	    _cf_loadingtexthtml='';	
		ptoken.navigate('Classification/ItemClassification.cfm?id=#url.id#&mode=#url.mode#&idmenu=#url.idmenu#','contentbox2');
	</script>
</cfoutput>