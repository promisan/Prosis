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
		<cfset PK="">
		<cfloop query="qPK">
			<cfswitch expression="#Trim(qPK.Field)#"> 
				   <cfcase value="EntityCode"> 
						<cfif PK eq "">
							<cfset PK="EntityCode='#URL.EntityCode#'">
						<cfelse>
							<cfset PK="#PK# AND EntityCode='#URL.EntityCode#'">
						</cfif>
				   </cfcase> 
				   <cfcase value="EntityClass"> 
						<cfif PK eq "">
							<cfset PK="EntityClass='#URL.EntityClass#'">
						<cfelse>
							<cfset PK="#PK# AND EntityClass='#URL.EntityClass#'">
						</cfif>				   
				   </cfcase> 				   
				   <cfcase value="PublishNo,ActionPublishNo"> 
						<cfif PK eq "">
							<cfset PK="#qPK.Field#='#URL.PublishNo#'">
						<cfelse>
							<cfset PK="#PK# AND #qPK.Field#='#URL.PublishNo#'">
						</cfif>				   
				   </cfcase> 				   
				   <cfcase value="QuestionId,LanguageCode"> 
						<cfif PK eq "">
							<cfset PK="#qPK.Field# in (SELECT QuestionId FROM Ref_EntityDocumentQuestion WHERE DocumentId in (SELECT DocumentId FROM Ref_EntityDocument WHERE EntityCode='#URL.EntityCode#'))">
							
						</cfif>				   
				   </cfcase> 				   				   
				   <cfdefaultcase> 
				   		
				   
				   </cfdefaultcase> 
			</cfswitch> 
				
		</cfloop>