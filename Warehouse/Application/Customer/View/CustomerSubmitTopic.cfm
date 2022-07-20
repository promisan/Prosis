<cfquery name="Customer" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Customer
		WHERE 	CustomerId = '#CustomerId#'
</cfquery>

<cfquery name="getTopics" 
		datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT	 P.Description,P.SearchOrder, T.*
			FROM     Ref_Topic T INNER JOIN Ref_TopicParent P ON T.Parent = P.Parent							
			WHERE    T.TopicClass = 'Customer'	
			AND      ValueClass IN ('List','Lookup')	
					
</cfquery>

<cfquery name="Classification" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	CustomerTopic C
		WHERE 	Customerid = '#CustomerId#'
</cfquery>

<cfquery name="TopicList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	* 
		FROM 	Ref_TopicList
</cfquery>

<cfloop query="getTopics">
									
	<cfquery name="Classification" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			SELECT 	*
			FROM 	CustomerTopic C
			WHERE 	CustomerId = '#CustomerId#'
	</cfquery>
			
	<cfif isDefined("Form.Topic_#getTopics.Code#")>
	
		<cfset vValue = Evaluate("Form.Topic_#getTopics.Code#")>
		
		<cfparam name="Form.TopicSub_#getTopics.Code#" default="">
		
		<cfset sValue = Evaluate("Form.TopicSub_#getTopics.Code#")>
						
		<cfquery name="qItemClassification" dbtype="query">
			SELECT 	*
			FROM 	Classification
			WHERE 	Topic = '#Code#'
		</cfquery>
		
		<cfquery name="qTopicList" dbtype="query">
			SELECT 	*
			FROM 	TopicList
			WHERE 	Code     = '#Code#'
			<cfif sValue neq "">
			AND 	ListCode = '#sValue#'
			<cfelse>
			AND 	ListCode = '#vValue#'
			</cfif>
		</cfquery>
				
		<cfif trim(vValue) eq "">
				
			<cfquery name="Delete" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE 
					FROM	CustomerTopic
					WHERE   CustomerId = '#CustomerId#'
					AND     Topic = '#getTopics.code#'
			</cfquery>
		
		<cfelse>
						
			<cfif qItemClassification.recordCount eq 0>			
											
				<cfquery name="Insert" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						INSERT INTO CustomerTopic (
								CustomerId,
								Topic,	
								<cfif valueClass eq "List">		
								ListCode,					
								</cfif>
								TopicValue,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							) VALUES (
								'#customerid#',
								'#code#',	
								<cfif valueClass eq "List">		
									<cfif sValue neq "">
									'#sValue#',
									<cfelse>
									'#vValue#',
									</cfif>							
								</cfif>	
								'#qTopicList.ListValue#',
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
						UPDATE CustomerTopic
						SET	   <cfif sValue neq "">
								ListCode = '#sValue#'
								<cfelse>
								ListCode = '#vValue#'
							   </cfif>
						       <cfif valueClass eq "List">
							   , TopicValue = '#qTopicList.ListValue#'</cfif>
						WHERE  CustomerId = '#customerid#'
						AND    Topic      = '#getTopics.code#'
				</cfquery>
			
			</cfif>
		
		</cfif>
		
	</cfif>

</cfloop>
