<!--
    Copyright © 2025 Promisan

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
<!--- saving custom fields --->
<cfparam name="url.ContributionId" default="">

<!--- define custom topics --->

<cfquery name="GetTopics" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Topic
	WHERE Mission = '#url.Mission#'
	AND TopicClass = 'Contribution'
	AND Operational = 1
 	ORDER BY ListingOrder	  
</cfquery>

<cfloop query="getTopics">

     <cfparam name="FORM.Topic_#Code#" default="">

	 <cfif ValueClass eq "List">

		<cfset value  = Evaluate("FORM.Topic_#Code#")>
		
		 <cfquery name="GetList" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT *
			  FROM   Ref_TopicList
			  WHERE  Code     = '#Code#'
			  AND    ListCode = '#value#'				  
		</cfquery>		
					
		<cfif value neq "">
		
			<cfquery name="SelectCurrentValue" 
			  datasource="AppsProgram" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT   * 
			  FROM     ContributionTopic
			  WHERE    ContributionId  = '#url.ContributionId#'
			  AND      Topic           = '#Code#'
			  AND      Mission         = '#url.Mission#'
		    </cfquery>		
		
	        <!--- check if new value = last value --->
			
			<cfif getList.ListValue neq SelectCurrentValue.TopicValue>
									
				<cfquery name="CleanSameDateEntries" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">			
				  DELETE  FROM  ContributionTopic
				  WHERE    ContributionId  = '#url.ContributionId#'		  
				  AND      Topic           = '#Code#'
				  AND      Mission         = '#url.Mission#'				  
			    </cfquery>
						
				<cfquery name="InsertTopics" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  ContributionTopic
				 		 (ContributionId,
						  Mission,
						  Topic,
						  ListCode,
						  TopicValue,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#url.ContributionId#',
				          '#url.Mission#',
				          '#Code#',
						  '#value#',
						  '#getList.ListValue#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#') 
				</cfquery>
				
			</cfif>	
		
		</cfif>
			
	<cfelse>
	
		<cfquery name="SelectCurrentValue" 
			  datasource="AppsProgram" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT   * 
			  FROM     ContributionTopic
			  WHERE    ContributionId  = '#url.ContributionId#'
			  AND      Topic           = '#Code#'
			  AND      Mission         = '#url.Mission#'
		</cfquery>		
		
		<cfif ValueClass eq "Boolean">					
			<cfparam name="FORM.Topic_#Code#" default="0">						
		</cfif>
		
		<cfset value  = Evaluate("FORM.Topic_#Code#")>
		
		<cfif value neq "">
		
			<cfif value neq SelectCurrentValue.TopicValue>
			
				<cfquery name="CleanSameDateEntries" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">			
				  DELETE  FROM  ContributionTopic
				  WHERE    ContributionId  = '#url.ContributionId#'		  
				  AND      Topic           = '#Code#'
				  AND      Mission         = '#url.Mission#'				  
			    </cfquery>
						
				<cfquery name="InsertTopics" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  ContributionTopic
				 		 (ContributionId,
						  Mission,
						  Topic,
						  TopicValue,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#url.ContributionId#',
				          '#url.Mission#',
				          '#Code#',
						  '#value#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#') 
				</cfquery>						
						
			</cfif>	
		
		</cfif>
		
	</cfif>	

</cfloop>
