<!--- select documents for this step that already have content in the database from a prior step --->

<cfparam name="URL.actionId" default="#URL.ID#">
<cfparam name="URL.wparam" 	 default="">


<cfquery name="Exist" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    D.DocumentId, 
			  R.DocumentCode,
	          R.DocumentMode, 
			  R.DocumentLayout,
			  R.DocumentTemplate, 
			  R.DocumentStringList,
			  'ENG' as DocumentLanguageCode,
			  R.DocumentFramework
	FROM      Ref_EntityActionDocument D INNER JOIN
	          Ref_EntityDocument R ON D.DocumentId = R.DocumentId 
	WHERE     ActionCode = '#Action.ActionCode#' 
	<!--- already created documents to be refreshed with content --->
	AND       D.DocumentId IN
	                    (SELECT     DocumentId
	                     FROM       OrganizationObjectActionReport
						 WHERE      ActionId IN
	                                      (SELECT  ActionId
	                                       FROM    OrganizationObjectAction
	                                       WHERE   ObjectId = '#Object.ObjectId#'
										   AND     ActionId != '#URL.ID#')) 
										   
	UNION
	
	<!--- forced documents to be refreshed with content --->
	SELECT    D.DocumentId, 
			  R.DocumentCode,
	          R.DocumentMode, 
			  R.DocumentLayout,
			  R.DocumentTemplate, 
			  R.DocumentStringList,
			  D.DocumentLanguageCode,
			  R.DocumentFramework
	FROM      Ref_EntityActionPublishDocument D INNER JOIN
	          Ref_EntityDocument R ON D.DocumentId = R.DocumentId 
	WHERE     ActionCode = '#Action.ActionCode#'
	AND       ActionPublishNo = '#Object.ActionPublishNo#'
	AND       D.Operational   = 1
	AND       D.ForceDocument = 1 
									   
</cfquery>

<!--- loop through the documents, if they exist already for this
action, add a record by a generating (ASIS) or copying (EDIT) --->

	<cfoutput query="Exist">
	
		<cfquery name="Check" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      OrganizationObjectActionReport
			WHERE     ActionId   = '#URL.ID#'
			AND       DocumentId = '#DocumentId#' 
		</cfquery>
		
		<cfif check.recordcount eq "0" or (check.recordcount eq "1" and Check.documentContent eq "")>
				
			<cfquery name="Last" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     OrganizationObjectActionReport 
				WHERE    DocumentId = '#DocumentId#' 
				AND      ActionId IN (SELECT ActionId 
				                      FROM OrganizationObjectAction 
									  WHERE ObjectId = '#Object.ObjectId#')
				AND      ActionId <> '#URL.ID#'
				ORDER BY Created DESC
				</cfquery>					
		
			<cfif DocumentMode eq "AsIs" and DocumentLayout neq "PDF">
			
				<!--- parse the document --->				   
					    
				<cfquery name="Language" 
					 	datasource="AppsSystem">
						 	SELECT  *
						 	FROM    Ref_SystemLanguage
						 	WHERE   Code = '#DocumentLanguageCode#'  
				</cfquery>
				
				<cfif Language.SystemDefault eq "1" or Language.Operational eq "1">
				   <cfset vLanguagecode = "">
				<cfelseif DocumentLanguageCode eq "">
				  	   <cfset vLanguagecode = "">
				<cfelse>   
					   <cfset vLanguagecode  = "xl#document.DocumentLanguageCode#_">
				</cfif>		 
						
				<cfif Language.SystemDefault eq "1" or Language.Operational eq "1">
					 <cfset vLanguagecode = "">
				<cfelse>   
					 <cfset vLanguagecode  = "xl#DocumentLanguageCode#_">
				</cfif>				
			
				<cfsavecontent variable="text">
				    <cfset url.WParam = DocumentStringList>
					<cftry>
						<cfinclude template="../../../#DocumentTemplate#">
					<cfcatch>
						Error in Template #DocumentTemplate#?WParam=#url.wparam#
						#cfcatch.message#
					</cfcatch>		
					</cftry>		
				</cfsavecontent>			
		
			<cfelseif DocumentMode eq "AsIs" and DocumentLayout eq "PDF">
			
			
				 	<cftry>		  				  		
						<cfdirectory action="CREATE" 
				          directory="#SESSION.rootDocumentPath#\WFObjectReport\#URL.ActionID#">
				    <cfcatch></cfcatch>
					</cftry>
						
					 <cfsavecontent variable="text">
					 				 					 
		 				 <cfset wfrpt = "#SESSION.rootDocumentPath#\WFObjectReport\#URL.ActionID#\#DocumentCode#.pdf">
						 <cftry>
						 <cfinclude template="../../../#DocumentTemplate#">	
						 <cfcatch>
						   Error in Template #DocumentTemplate#?WParam=#url.wparam#
						  
					     </cfcatch>		
					     </cftry>					 
						
					</cfsavecontent>														
					
			
			<cfelseif DocumentMode neq "Blank">
						
				<cfif Last.DocumentContent neq "">
					
					<cfset text = Last.DocumentContent>
										
				<cfelse>
								
					<cfset text = Last.DocumentContent>
											
					<cfset URL.Language = DocumentLanguageCode>
					
					<!--- Getting the default mode --->
					<cfset vList = "Memo,Letter,Fax,Note">
					<cfset vListFinal = "">
					
					<cfset l = len(DocumentTemplate)>		
				    <cfset path = left(DocumentTemplate,l-4)>		
					
					<cfloop index="vItem" list="#vList#">
						<cfif FileExists("#SESSION.rootPath#/#path#_#vItem#.cfm")> 
							<cfif vListFinal eq "">
								<cfset vListFinal = vItem>
								<cfbreak>
							</cfif>
						</cfif>	
					</cfloop>		
															
					
					<cfif vListFinal eq "">
					
						
					<cfelse>
					
						<cfset URL.format = vListFinal>
						
						<cfset URL.Signature         = ""> 	<!--- As it is initial generation, we do not know the signatory block, we are safe with nothing --->
						<cfset URL.Description       = "">	<!--- As it is initial generation --->
						<cfset URL.DocumentFramework = "#DocumentFramework#">
						<cfset URL.DocumentTemplate  = "#DocumentTemplate#">
													
						<cfinclude template = "DocumentFramework.cfm">
				
					</cfif>
														
				
				</cfif>		
				
			</cfif>
	
			<cfif DocumentMode neq "Blank">
				
				<cfif check.recordcount eq "0">
							
					<cfquery name="Insert" 
						datasource="appsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO OrganizationObjectActionReport
								 (ActionId,
								 DocumentId,
								 DocumentContent,
								 <cfif DocumentLayout eq "PDF">
									 DocumentPath,
								 </cfif>
								 SignatureBlock,
								 OfficerUserId, 
								 OfficerLastName,
								 OfficerFirstName) 
						  VALUES ('#URL.ID#', 
								  '#DocumentId#',
								  '#text#',
								  <cfif DocumentLayout eq "PDF">
									  '\WFObjectReport\#URL.ActionID#\#DocumentCode#.pdf',
								  </cfif>	  
								  '#Last.SignatureBlock#',
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#')
					</cfquery>			
				
				<cfelse>
				
					<cfquery name="Update" 
						datasource="appsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE    OrganizationObjectActionReport
							SET       DocumentContent = '#text#',
							          SignatureBlock  = '#last.SignatureBlock#'
							WHERE     ActionId        = '#URL.ID#'
							AND       DocumentId      = '#DocumentId#'			
					</cfquery>			
						
				</cfif>
			
			</cfif>
			
		</cfif>
	
	</cfoutput>


