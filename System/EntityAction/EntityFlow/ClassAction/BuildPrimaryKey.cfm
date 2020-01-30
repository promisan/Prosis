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