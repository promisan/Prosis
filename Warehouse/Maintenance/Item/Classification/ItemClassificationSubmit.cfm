<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
		
		SELECT	 T.*
		FROM     Ref_Topic T INNER JOIN Ref_TopicCategory C ON T.Code = C.Code
					AND C.Category   = '#Item.Category#'
					AND T.Operational  = 1 					
					-- AND  ValueClass IN ('List','Lookup')
		WHERE    T.TopicClass = 'Category'						
		
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
	
	<cfparam name="Form.Topic_#getTopics.Code#_Oper" default="0">

	<cfset oper = evaluate("Form.Topic_#getTopics.Code#_Oper")>
			
	<cfif isDefined("Form.Topic_#getTopics.Code#")>
	
		<cfset vValue = Evaluate("Form.Topic_#getTopics.Code#")>
		
		<!--- sub topics --->
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
					FROM	#tbcl#
					WHERE   ItemNo = '#url.id#'
					AND     Topic = '#getTopics.code#'
			</cfquery>
		
		<cfelse>
						
			<cfif qItemClassification.recordCount eq 0>			
												
				<cfif TopicClass eq "Details">				
													
					<cfquery name="Insert" 
						datasource="appsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO ItemTopic (
									ItemNo,
									Topic,		
									Operational,														
									OfficerUserId,
									OfficerLastName,
									OfficerFirstName
								) VALUES (
									'#url.id#',
									'#getTopics.code#',
									'#oper#',															
									'#SESSION.acc#',
									'#SESSION.last#',
									'#SESSION.first#'
								)
					</cfquery>
										
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
								<cfif TopicClass neq "Details">	
								Operational,
								</cfif>
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							) VALUES (
								'#url.id#',
								'#code#',	
								<cfif valueClass eq "List">	
									<cfif sValue neq "">'#sValue#'<cfelse>'#vValue#'</cfif>,			
									'#qTopicList.ListValue#',	
								<cfelse>
									<cfif sValue neq "">'#sValue#'<cfelse>'#vValue#'</cfif>,						
								</cfif>		
								<cfif TopicClass neq "Details">
								'#oper#',					
								</cfif>	
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#'
							)
				</cfquery>
	
			<cfelse>
			
				<cfif TopicClass eq "Details">	
				
					<cfquery name="Update" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE ItemTopic
						SET	   Operational = '#oper#'
						WHERE  ItemNo      = '#url.id#'
						AND    Topic       = '#getTopics.code#'
				    </cfquery>			
																				
				</cfif>
						
				<cfquery name="Update" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE #tbcl#
						SET	  <cfif TopicClass neq "Details">	
								Operational = '#oper#',								
							   </cfif>
						
						       <cfif valueClass eq "List">
							    ListCode = <cfif sValue neq "">'#sValue#'<cfelse>'#vValue#'</cfif>,
								TopicValue = '#qTopicList.ListValue#'
							   <cfelse>
							    TopicValue = <cfif sValue neq "">'#sValue#'<cfelse>'#vValue#'</cfif>
							   </cfif>
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