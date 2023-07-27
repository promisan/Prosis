<!--- select documents for this step that already have content in the database from a prior step --->

<cfparam name="URL.actionId" default="#URL.ID#">
<cfparam name="URL.wparam" 	 default="">



<cfquery name="Exist" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    <!--- removed by Hanno 26/11/2020 only documents that are set to be forced will be populated here 
	
	SELECT    D.DocumentId, 
			  R.DocumentCode,
	          R.DocumentMode, 
			  R.DocumentLayout,
			  R.DocumentTemplate, 
			  R.DocumentStringList,
			  'ENG' as DocumentLanguageCode,
			  R.DocumentFramework,
			  0 as ForceDocument
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
	
	--->
	
	<!--- forced documents to be refreshed with content --->
	
	SELECT    D.DocumentId, 
			  R.DocumentCode,
	          R.DocumentMode, 
			  R.DocumentLayout,
			  R.DocumentTemplate, 
			  R.DocumentStringList,
			  D.DocumentLanguageCode,
			  R.DocumentFramework,
			  D.ForceDocument
	FROM      Ref_EntityActionPublishDocument D INNER JOIN
	          Ref_EntityDocument R ON D.DocumentId = R.DocumentId 
	WHERE     ActionCode        = '#Action.ActionCode#'
	AND       ActionPublishNo   = '#Object.ActionPublishNo#'
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
		
		<cfset priorsign = "">
		<cfset priorlanguage = "">
		<cfset priorformat = "">			
								
		<cfif check.recordcount eq "0" or (check.recordcount eq "1" and Check.documentContent eq "")>
				
			<cfquery name="Last" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     OrganizationObjectActionReport 
				WHERE    DocumentId = '#DocumentId#' 
				AND      ActionId IN (SELECT ActionId 
				                      FROM   OrganizationObjectAction 
									  WHERE  ObjectId = '#Object.ObjectId#')
				AND      ActionId <> '#URL.ID#'
				ORDER BY Created DESC				
			</cfquery>					
			
			<cfset priorsign     = last.SignatureBlock>
			<cfset priorlanguage = last.DocumentLanguageCode>
			<cfset priorformat   = last.DocumentFormat>
			
			<!--- added to ensure the default works with the header --->
			<cfif priorformat eq "">
      			<cfset priorformat   = "Letter">
				
			</cfif>
						
			<cfquery name="Signature" 
			 datasource="appsOrganization" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_EntityDocumentSignature
				WHERE  EntityCode = '#Object.EntityCode#'
				AND    Code       = '#priorsign#' 
				AND    Operational= 1
		    </cfquery>		
							
			<cfif DocumentMode eq "AsIs" and DocumentLayout neq "PDF">
						
				<!--- parse the document --->				   
					    
				<cfquery name="Language" 
					 	datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
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
								
				<cfif priorformat neq "">				
										
					<cfset url.format            = priorformat>
					<cfset url.signature         = "">
					<cfset url.description       = "">
					<cfset URL.DocumentFramework = "#DocumentFramework#">
					<cfset URL.DocumentTemplate  = "#DocumentTemplate#">
					<cfset url.language          = priorlanguage>
				    <cfset url.WParam            = DocumentStringList>
				    <cfset URL.actionId          = "#URL.ID#">
									
					<cfinclude template          = "../Report/DocumentFramework.cfm"> 		
							
									
				<cfelse>
				
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
				
				</cfif>					
													
		
			<cfelseif DocumentMode eq "AsIs" and DocumentLayout eq "PDF">			
			
				 	<cftry>		  				  		
						<cfdirectory action="CREATE" 
				          directory="#SESSION.rootDocumentPath#\WFObjectReport\#URL.ActionID#">
				    <cfcatch></cfcatch>
					</cftry>
						
					 <cfsavecontent variable="text">
					 				 					 
		 				 <cfset wfrpt = "#SESSION.rootDocumentPath#\WFObjectReport\#URL.ActionID#\#DocumentCode#.pdf">
						 <cftry>
						 					 
						 <cfset URL.Signature         = "#signature.blockline1#<br>#signature.blockline2#<br>#signature.blockline3#<br>#signature.blockline4#<br>#signature.blockline5#">
						 <cfset URL.Description       = "">
						 <cfset URL.DocumentFramework = "#DocumentFramework#">
						 <cfset URL.Language          = "#Last.DocumentLanguageCode#">
						 <cfset URL.Format            = "#Last.DocumentFormat#">
												 												
						  <!--- this will freshly generate the document along with the framework --->							
						 <cfinclude template = "DocumentFramework.cfm">
						 					 
						 <cfcatch>
						   Error in AS-IS Template #DocumentTemplate#?WParam=#url.wparam#						  
					     </cfcatch>		
					     </cftry>					 
						
					</cfsavecontent>					
			
			<cfelseif DocumentMode neq "Blank">
						
				<cfif Last.DocumentContent neq "">
				
					<!--- if forcedocument = 1 then we freshly generate the document and do not inherit it from the prior --->
													
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
												
						<!--- this will freshly generate the document along with the framework --->							
						<cfinclude template = "DocumentFramework.cfm">
				
					</cfif>		
																			
				
				</cfif>		
				
			</cfif>
			
			<cfparam name="text" default="">
	
			<cfif DocumentMode neq "Blank" and text neq "">
			
				<!--- new feature to apply a signature block content to the document on the spot where it is intended --->								
																						
		        <cfset path = left(DocumentTemplate,len(DocumentTemplate)-4)>						
				
				<cfif FileExists("#SESSION.rootpath#\#path#_Signature.cfm")>	
				
					<cfsavecontent variable="signatureblock">
						<cfinclude template="../../../#path#_Signature.cfm">	
					</cfsavecontent>
						
					<cfif signatureblock neq "">
						
						<cfset start = findNoCase("<sign>",text)> 
						<cfset start = start>
						<cfset end   = findNoCase("</sign>",text)> 
						<cfset cnt   = end-start+7>
						<cfif start gt "1" and cnt gt "1">
							<cfset prior = mid(text,start,cnt)>									
							<cfset text = replace("#text#", "#prior#", "<sign>#signatureblock#</sign>")>
						</cfif>
															
					</cfif>		
					
				</cfif>	
											
				
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
								  DocumentFormat,
								  DocumentLanguageCode,
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
								  '#priorformat#',
								  '#priorlanguage#',  
								  '#priorsign#',
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
							          SignatureBlock  = '#priorsign#'
							WHERE     ActionId        = '#URL.ID#'
							AND       DocumentId      = '#DocumentId#'			
					</cfquery>	
						
						
				</cfif>
			
			</cfif>
			
		</cfif>
	
	</cfoutput>


