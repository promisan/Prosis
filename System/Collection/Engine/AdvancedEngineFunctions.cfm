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

<cffunction name="generateElementsPool">

	<cfargument name="SearchId"		   type="string">
	<cfargument name="TableName"	   type="string">
	
	<cfquery name = "GetCaseFiles" 
	datasource = "AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   CollectionLogCriteria
		WHERE  Layout = '3'
		AND    SearchId = '#SearchId#'
	</cfquery>
	
	<cfset inStatement = "">
	
	<cfloop query="GetCaseFiles">
	
		<cfif inStatement eq "">
			<cfset inStatement = "'#GetCaseFiles.Condition1#'" >
		<cfelse>
			<cfset inStatement = inStatement & ",'#GetCaseFiles.Condition1#'" >
		</cfif>
	
	</cfloop>
	
	<cfquery name = "GenerateElementsPool" 
	datasource = "AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		INTO   #ElementsPool#
		FROM   Element E
		WHERE  ElementId IN
		(
			SELECT ElementId 
			FROM ClaimElement T 
			WHERE T.Element = E.ElementId
			WHERE T.ClaimId IN (
				SELECT ClaimId
				FROM Claim 
				WHERE ClaimTypeClass IN (#PreserveSingleQuotes(inStatement)#)
				AND   ClaimId = T.ClaimId
			)
		)
	</cfquery>

</cffunction>

<!---																				--->
<!--- Person can have data in Applicant and also									--->
<!--- in ElementTopic. This function detects if the Field belongs to applicant		--->
<!--- or ElementTopic and proceed accordingly to build the condition				--->
<!---																				--->

<cffunction name="getConditionPerson">

	<cfargument name="SearchFieldType" type="string">
	<cfargument name="Operator"		   type="string">
	<cfargument name="SearchField"	   type="string">
	<cfargument name="ListValue"	   type="string">
	<cfargument name="Condition1"	   type="string">
	<cfargument name="Condition2"	   type="string">

	<cfset var tempCondition= StructNew()>
			
	<cfquery name="qTopic" 
	datasource= "AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_Topic
		WHERE  Code = '#SearchField#'
	</cfquery>			
	
	<cfif qTopic.recordcount neq 0>
	
		<cfif qTopic.TopicClass eq 'Element'>
			<!--- Field belongs to Element --->
			<cfreturn getConditionElement(SearchFieldType,Operator,SearchField,ListValue,Condition1,Condition2)>
		</cfif>
	
		<!--- Field belongs to Person --->
		<cfswitch expression = "#SearchFieldType#">
		
			<cfcase value = "Lookup,List">

				<cfset tempCondition.left = "E.#qTopic.TopicLabel#" >
				<cfset tempCondition.operator = " = ">
				<cfset tempCondition.right = "'#ListValue#'">
				
			</cfcase>	
			
			<cfcase value = "Date">
				<cfif Condition1 neq "">
					<cfset tempCondition.left = "E.#qTopic.TopicLabel#" >
					<cfset tempCondition.operator = ">=">
					<cfset tempCondition.right = "CONVERT(datetime,'#Condition1#',103)">
				</cfif>
				
				<cfif Condition2 neq "">
					<cfif Condition1 neq "">
						<cfset tempCondition.right = " #tempCondition.right#  AND E.#qTopic.TopicLabel# <= CONVERT(datetime,'#Condition2#',103)">
					<cfelse>
						<cfset tempCondition.left = "E.#qTopic.Description#" >
						<cfset tempCondition.operator = "<=">
						<cfset tempCondition.right = "CONVERT(datetime,'#Condition2#',103)">
					</cfif>
				</cfif>
				
			</cfcase>
			
			<cfcase value = "Text">
			
				<cfset tempCondition.left = "E.#qTopic.TopicLabel#" >
				<cfif Operator neq "Like">
					<cfset tempCondition.operator = " = ">
				<cfelse>
					<cfset tempCondition.operator = " LIKE ">
				</cfif>
				<cfset tempCondition.right = "'%#Condition1#%'">
			
			</cfcase>	
									
		</cfswitch>
		
	</cfif>	
	
	<cfreturn tempCondition>

</cffunction>

<cffunction name="generatePersonData">

	<cfargument name="DataSource"	   type="string">
	<cfargument name="Answer"		   type="string">
	<cfargument name="Condition"	   type="array">

	
	<!--- 	This section builds the query.  						---->
	<!---	DifferentTopics: uses AND, SameTopics: uses OR			---->
	<!---   Handles when topics belong to ElementTopic or Applicant ---->
	
	<cfset joinStatement = "">
	<cfset whereStatement = "">
	<cfset totalConditions = ArrayLen(Condition)>
	<cfset conditionLine   = "">

	<!--- what topics belong to Applicant table? ---->
	<cfquery name = "ApplicantTopics" 
	datasource = "AppsCaseFile"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TopicLabel FROM
		Ref_Topic
		WHERE TopicClass = 'Person'
		AND Operational = '1'
	</cfquery>
	
	<cfloop index="index" from="1" to="#totalConditions#">

		<cfquery name="verify" dbtype ="query">
			SELECT * FROM ApplicantTopics
			WHERE TopicLabel = '#Replace(Condition[index].left,'E.','')#'
		</cfquery>

		<cfset isApplicantTopic= FALSE>
		<cfloop query="verify">
			<cfset isApplicantTopic = TRUE>
		</cfloop>
		
		<!---- use OR if user is searching for the same topic more than once --->
		<cfif index lt totalConditions and Condition[index].left eq Condition[index+1].left >

			<cfif isApplicantTopic>
				<cfset conditionLine = "(#Condition[index].left# #Condition[index].operator# #Condition[index].right#) OR #conditionLine#">
			<cfelse> 
				<cfset conditionLine = "#conditionLine# (#Condition[index].right#) OR">
			</cfif>
		
		<!---- use AND if user is searching for different topics --->
		<cfelse>
		
			<cfif isApplicantTopic gt 0>
				<cfset whereStatement = whereStatement & " AND (" & conditionLine & "(#Condition[index].left# #Condition[index].operator# #Condition[index].right#))">
			<cfelse>
			
				<cfset conditionLine = " (#Condition[index].left# AND (#conditionLine# #Condition[index].right#))">
				<cfoutput>
					<cfsavecontent variable = "join"> 
						INNER JOIN 
						(
							SELECT ElementId 
							FROM ElementTopic ET
							WHERE #conditionLine#
						) C#index#
						ON E.ElementId = C#index#.ElementId
					</cfsavecontent>
				</cfoutput>
				
				<cfset joinStatement = joinStatement & join>
			</cfif>
				
			<cfset conditionLine = "">
			
		</cfif>
		
	</cfloop>

	<!--- 								  --->
	<!--- This section generates the data --->
	<!---								  --->
	
	<cfquery name="GetData" dataSource="AppsCaseFile" username="#SESSION.login#"  password="#SESSION.dbpw#">
		
		INSERT INTO userQuery.dbo.#Answer#
		SELECT 'Person', E.ElementId, '','0' 
		FROM
		(
			SELECT PE.ElementId, 
			       PE.PersonNo, 
				   PE.IndexNo as NIT, 
				   PE.LastName, 
				   PE.LastName2, 
				   PE.MaidenName, 
				   PE.FirstName,
				   PE.MiddleName,
				   PE.MiddleName2, 
				   PE.Gender, 
				   PE.Nationality, 
				   PE.DOB,
				   PE.MaritalStatus,
				   PE.ElementCreated
				   FROM 
			(
				SELECT E.ElementId, E.Created as ElementCreated, A.* FROM Element E
				INNER JOIN Applicant.dbo.Applicant A
				ON E.PersonNo = A.PersonNo
			) PE
		) E

		<cfif joinStatement neq "">
		 #PreserveSingleQuotes(joinStatement)# 
		</cfif>
		
		WHERE 1=1
		
		<cfif whereStatement neq "">
		 #PreserveSingleQuotes(whereStatement)# 
		</cfif>
		

		<cfif url.time neq "">			
			 AND    E.ElementCreated between '#datefrom#' AND '#dateto#' 
		</cfif>		

		
	</cfquery>
	
</cffunction>


<cffunction name="getConditionElement">

	<cfargument name="SearchFieldType" type="string">
	<cfargument name="Operator"		   type="string">
	<cfargument name="SearchField"	   type="string">
	<cfargument name="ListValue"	   type="string">
	<cfargument name="Condition1"	   type="string">
	<cfargument name="Condition2"	   type="string">
		
	<cfset var tempCondition= StructNew()>	
		
	<cfquery name="qTopic" 
	datasource= "AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_Topic
		WHERE  TopicClass = 'Element' 
		AND    Code       = '#SearchField#'
	</cfquery>			

	<cfif qTopic.recordcount neq 0>

		<cfset tempCondition.left     = "ET.Topic='#SearchField#'" >
		<cfset tempCondition.operator = " AND ">
	
		<cfswitch expression = "#SearchFieldType#">
	
			<cfcase value = "Lookup,List,Boolean,ZIP">
				<cfset tempCondition.right    = "ET.ListCode = '#ListValue#'">
			</cfcase>	
		
			<cfcase value = "Date">

				<cfif Condition1 neq "">
					<cfset tempCondition.right = "CONVERT(datetime,ET.TopicValue,101) >= CONVERT(datetime,'#Condition1#',103)">	
				</cfif>
			
				<cfif Condition2 neq "">
					<cfif Condition1 neq "">
						<cfset tempCondition.right = "( #tempCondition.right# AND CONVERT(datetime,ET.TopicValue,101) <= CONVERT(datetime,'#Condition2#',103) )">	
					<cfelse>
						<cfset tempCondition.right = "( CONVERT(datetime,ET.TopicValue,101) <= CONVERT(datetime,'#Condition2#',103) )">	
					</cfif>
				</cfif>
			</cfcase>
			
			<cfcase value = "Memo,Text,Map">
				<cfif condition1 neq "">	
					<cfif Operator neq "Like">
						<cfset tempCondition.right = "CONVERT(varchar, ET.TopicValue) = '#Condition1#'">
					<cfelse>
						<cfset tempCondition.right = "CONVERT(varchar, ET.TopicValue) Like '%#Condition1#%'">				
					</cfif>	
				</cfif>
			</cfcase>		
								
		</cfswitch>
		
	</cfif>	

	<cfreturn tempCondition>
	
</cffunction>


<cffunction name="generateElementData">

	<cfargument name="DataSource"	   type="string">
	<cfargument name="SearchClass"	   type="string">
	<cfargument name="Answer"		   type="string">
	<cfargument name="Condition"	   type="array">
	
	<!--- 	Builds the query.  							---->
	<!---	DifferentTopics, uses AND					---->
	<!---   SameTopic, uses OR							---->
	
	<cfset finalCondition  = "">
	<cfset conditionLine   = "">
	<cfset totalConditions = ArrayLen(Condition)>
	
	<cfloop index="index" from="1" to="#totalConditions#">
  		
		<cfif index lt totalConditions and Condition[index].left eq Condition[index+1].left >
		
			<cfset conditionLine = "#conditionLine# (#Condition[index].right#) OR">
			
		<cfelse>
		
			<cfset conditionLine = " (#Condition[index].left# AND (#conditionLine# #Condition[index].right#))">
			<cfoutput>
				<cfsavecontent variable = "join"> 
					INNER JOIN 
					(
						SELECT ElementId 
						FROM ElementTopic ET
						WHERE #conditionLine#
					) C#index#
					ON E.ElementId = C#index#.ElementId
				</cfsavecontent>
			</cfoutput>
			
			<cfset finalCondition = finalCondition & join>
				
			<cfset conditionLine = "">
			
		</cfif>
		
	</cfloop>
 
	<cfquery name="GetData" dataSource="AppsCaseFile" username="#SESSION.login#" password="#SESSION.dbpw#">

		INSERT INTO UserQuery.dbo.#Answer#
		SELECT '#SearchClass#', E.ElementId, '','0' 			
		FROM Element E 
		
		<cfif finalCondition neq "">
			#PreserveSingleQuotes(finalCondition)#
		</cfif>

		<cfif url.time neq "">	
			WHERE E.Created between '#datefrom#' AND '#dateto#'
		</cfif>		
		
	</cfquery>
	
</cffunction>