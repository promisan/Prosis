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