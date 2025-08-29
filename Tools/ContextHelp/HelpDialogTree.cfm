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
<cfquery name="Help" 
			datasource="AppsSystem"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   C.TopicClass, C.TopicClassDescription, T.TopicName, T.TopicId
			FROM     HelpProjectTopic T INNER JOIN
			         HelpProjectClass C ON T.ProjectCode = C.ProjectCode AND T.TopicClass = C.TopicClass INNER JOIN
			         HelpProject P ON C.ProjectCode = P.ProjectCode
			WHERE    P.ProjectCode = '#url.ProjectCode#'		 
			ORDER BY C.TopicClass, T.ListingOrder	
			</cfquery>						
			
	<cfform>
			<cftree name="root"
			        font="Verdana"
			        fontsize="11"		
			        bold="No"   
					format="html"    
			        required="No">					
										
				<cfoutput query="help" group="TopicClass">	
						
				<cftreeitem value="#TopicClass#"
			            display="#TopicClass#"
			            img="#SESSION.root#/Images/bookopen.gif"
						imgopen="#SESSION.root#/Images/bookclose.gif"
						parent="root"				
			            expand="No">	
											
						<cfoutput>	
					
					    <cftreeitem value="#currentrow#"
						            display="#TopicName#"
						            parent="#TopicClass#"
									href="javascript:reloadtext('#topicid#')"
						            img="#SESSION.root#/Images/pointer.gif"
						            expand="No">
									
						</cfoutput>			
					
				 </cfoutput>
			
			</cftree>
			
	</cfform>