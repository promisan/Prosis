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

<cfquery name="GetTopics" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_Topic
	  WHERE  Operational = 1		
</cfquery>
  
<cfquery name="Clean" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM PersonMedical
		WHERE PersonNo = '#URL.ID#'
</cfquery>

<cftransaction>
								
<cfloop query="getTopics">

	    <cfif ValueClass eq "List">
		
			<cfparam name="Form.Topic_#Code#" default="">			
 		        <cfset value  = Evaluate("Form.Topic_#Code#")>
															
			 <cfquery name="GetList" 
					  datasource="AppsEmployee" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT *
					  FROM Ref_TopicList T
					  WHERE T.Code = '#Code#'
					  AND   T.ListCode = '#value#'				  
			</cfquery>
						
			<cfif value neq "">
						
			<cfquery name="InsertTopics" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO PersonMedical
			 		 (PersonNo,Topic,ListCode,TopicValue)
			  VALUES ('#URL.Id#','#Code#','#value#','#getList.ListValue#')
			</cfquery>
			
			</cfif>
			
		<cfelse>
		
			<cfif ValueClass eq "Boolean">
			
				<cfparam name="Form.Topic_#Code#" default="0">
				
			</cfif>
			
			<cfparam name="Form.Topic_#Code#" default="">			
							
 		        <cfset value  = Evaluate("Form.Topic_#Code#")>
			
			<cfif value neq "">
			
				<cfquery name="InsertTopics" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO PersonMedical
				 		 (PersonNo, Topic, TopicValue)
				  VALUES ('#URL.Id#','#Code#','#value#')
				</cfquery>	
			
			</cfif>
		
		</cfif>	
				
	</cfloop>		 
 
 </cftransaction>
