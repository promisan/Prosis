



<cfoutput>

<cfquery name="Object" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       OrganizationObject O, OrganizationObjectAction A
WHERE      O.Objectid = A.Objectid
AND        A.ActionId = '#url.ActionId#'
</cfquery>

<cfquery name="Format" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_EntityDocument
	WHERE    DocumentId = '#url.docid#'
</cfquery>

<cfif Format.DocumentMode eq "AsIs" and Format.DocumentLayout eq "PDF">
	
	<cftry>
		
		<cfquery name="Doc" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  * 
				FROM    OrganizationObjectActionReport
				WHERE   ActionId   = '#URL.ActionID#' 
				AND     DocumentId = '#URL.docid#'
		</cfquery>
		
		<cffile action="DELETE" 
		        file="#SESSION.rootDocumentPath#\#doc.DocumentPath#">
		
		<cfcatch></cfcatch>
		
	</cftry>

</cfif>

<cfquery name="Clear" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE   FROM OrganizationObjectActionReport
		WHERE    ActionId   = '#URL.ActionID#' 
		AND      DocumentId = '#URL.docid#'
</cfquery>

<cfquery name="Check" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM    OrganizationObjectActionReport P, 
		        Ref_EntityDocument R
		WHERE   P.DocumentId = R.DocumentId
		AND     P.ActionId   = '#URL.ActionID#' 
</cfquery>

<cfif url.action eq "add" or url.action eq "refresh">
		
		<cfquery name="Signature" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_EntityDocumentSignature
			WHERE  EntityCode = '#Object.EntityCode#'
			AND    Code       = '#url.Sign#' 
			AND    Operational= 1
		</cfquery>	
		
		<cftry>
		
			 <cfset url.WParam = Format.DocumentStringList>
				
			 <!--- backward compatibility for reports NY --->
			 <cfset Form.Key1 = Object.ObjectKeyValue1>					
			 <cfset Form.Key2 = Object.ObjectKeyValue2>
			 <cfset Form.Key3 = Object.ObjectKeyValue3>
			 <cfset Form.Key4 = Object.ObjectKeyValue4>			 
			 
			 <cfif Format.DocumentMode eq "AsIs" and Format.DocumentLayout eq "PDF">
			 
			  	  <cftry>		  				  		
					<cfdirectory action="CREATE" 
				          directory="#SESSION.rootDocumentPath#\WFObjectReport\#URL.ActionID#">
				   <cfcatch></cfcatch>
				  </cftry>
				  			
				  <cfset wfrpt = "#SESSION.rootDocumentPath#\WFObjectReport\#URL.ActionID#\#Format.DocumentCode#.pdf">
				  					
				  <cfinclude template="../../../#Format.DocumentTemplate#">	
					
				  <cfif Not FileExists(wfrpt)>
						ERROR, file #wfrpt# could not be generated check the custom template #Format.DocumentTemplate#!!
						<cfabort>
				  </cfif> 
										 
			<cfelse>

				<cfset URL.Signature         = "#signature.blockline1#<br>#signature.blockline2#<br>#signature.blockline3#<br>#signature.blockline4#<br>#signature.blockline5#">
				<cfset URL.Description       = "#check.DocumentDescription#">
				<cfset URL.DocumentFramework = "#Format.DocumentFramework#">
				<cfset URL.DocumentTemplate  = "#Format.DocumentTemplate#">
				
			  	<cfinclude template = "DocumentFramework.cfm">
			   
			 </cfif>  
							
			<cfcatch>
				
				<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
				<tr><td bgcolor="ffffaf" align="center">
				#CFCatch.Message# - #CFCATCH.Detail# 
				</td></tr></table>			
				
				<cfabort>
				
			</cfcatch>
		
		</cftry>	
		
		<cftry>	
		
			<cfquery name="Insert" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO OrganizationObjectActionReport
							 (ActionId,
							 DocumentId,
							 <cfif Format.DocumentMode eq "AsIs" and Format.DocumentLayout eq "PDF">
							 DocumentPath,
							 <cfelse>
							 DocumentContent,
							 SignatureBlock,
							 DocumentLanguageCode,
							 DocumentFormat,							 
							 </cfif>
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName) 
				  VALUES ('#URL.actionID#', 
						  '#URL.docid#',
						   <cfif Format.DocumentMode eq "AsIs" and Format.DocumentLayout eq "PDF">
						  '\WFObjectReport\#URL.ActionID#\#Format.DocumentCode#.pdf',
						  <cfelse>
						  '#text#',
						  '#url.sign#',
						  '#url.language#',
						  '#url.format#',						  
						  </cfif>
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
			</cfquery>
			
		<cfcatch>
		
				<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
				<tr><td bgcolor="ffffaf" align="center">#CFCatch.Message# - #CFCATCH.Detail#</td></tr>
				</table>	
							
		</cfcatch>	
		</cftry>	
		
</cfif>

		<cfif url.action eq "Add">
		
		<script>
									
				try {
					 document.getElementById('menudocument').disabled = false } catch(e) { }		
					 
				ColdFusion.navigate('ProcessAction8TabsDocument.cfm?action=add&id=#URL.actionID#&docid=#url.docid#',document.getElementById('documentcontainer').value)	
				document.getElementById('menudocument').className = "regular"
				// se = document.getElementById('documentmenu').value
				// document.getElementById(se).click()
										
		</script>
		
		<cfelseif url.action eq "refresh">
		
			<script>
		
				// ColdFusion.Layout.selectTab("processbox", "document");
				ColdFusion.navigate('ProcessAction8TabsDocument.cfm?id=#URL.actionID#&docid=#url.docid#',document.getElementById('documentcontainer').value); 
						
			</script>	
			
		<cfelse>	
			
			<script>
			
				ColdFusion.navigate('ProcessAction8TabsDocument.cfm?id=#URL.actionID#&action=delete',document.getElementById('documentcontainer').value)	
								
				<cfif check.recordcount eq "0">
				    try {
					 document.getElementById('menudocument').disabled = true 
					 document.getElementById('menudocument').className = "hide"
					  } catch(e) { }					
				</cfif>	
				
			</script>
		
		</cfif>
		
		<script>
		 ColdFusion.navigate("Report/DocumentProcessOption.cfm?action=#url.action#&actionid=#url.actionid#&docid=#url.docid#&documentcode=#format.documentcode#&no=#url.no#",'docoption#url.docid#');	 		
		</script>


</cfoutput>

<!---
<cfset ajaxonload("initTextArea")>				
--->
