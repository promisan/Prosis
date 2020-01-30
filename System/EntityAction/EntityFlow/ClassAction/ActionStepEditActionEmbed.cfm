
<cfparam name="URL.ID2" default="">

<cfif url.publishNo neq "">
	
	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO Ref_EntityActionPublishDocument
					(ActionPublishNo,ActionCode,DocumentId,ListingOrder)
		SELECT      DISTINCT '#URL.PublishNo#','#URL.ActionCode#',R.DocumentId,S.DocumentOrder
		FROM        Ref_EntityActionDocument R, Ref_EntityDocument S
		WHERE       R.ActionCode = '#URL.ActionCode#'
		AND         R.DocumentId = S.DocumentId 
		AND         S.DocumentType = 'report'
		AND         S.Operational = '1'
		AND         R.DocumentId NOT IN (SELECT DocumentId 
		                         FROM   Ref_EntityActionPublishDocument
								 WHERE  ActionPublishNo = '#URL.PublishNo#'
								 AND    ActionCode = '#URL.ActionCode#')						 
	</cfquery>
	
	<cfquery name="Detail" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    R.*, A.ListingOrder, A.DocumentLanguageCode,A.ForceDocument, A.Operational as Valid
		FROM      Ref_EntityDocument R INNER JOIN
		          Ref_EntityActionPublishDocument A ON R.DocumentId = A.DocumentId 
				  	AND A.ActionPublishNo = '#URL.PublishNo#' 
					AND A.ActionCode      = '#URL.ActionCode#'		
		WHERE     R.DocumentType IN ('report','question')		
		AND       R.EntityCode = '#url.entityCode#'			
		UNION ALL
		SELECT    *,0 as ListingOrder, 'ENG' as DocumentLanguageCode, 0 as ForceDocument,0 as Valid
		FROM      Ref_EntityDocument 
		WHERE     DocumentType IN  ('report','question')			
		AND       DocumentId NOT IN (SELECT DocumentId 
		                             FROM   Ref_EntityActionPublishDocument
									 WHERE  ActionPublishNo = '#URL.PublishNo#'	
									 AND    ActionCode       = '#URL.ActionCode#')	                      
		AND       EntityCode = '#URL.EntityCode#'	
		AND       DocumentId IN (SELECT DocumentId FROM Ref_EntityActionDocument WHERE ActionCode = '#URL.ActionCode#')
		ORDER BY  R.DocumentType, R.DocumentOrder
	</cfquery>

<cfelse>

	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO Ref_EntityClassActionDocument
					(EntityCode, EntityClass,ActionCode,DocumentId,ListingOrder)
		SELECT      '#URL.EntityCode#','#URL.EntityClass#','#URL.ActionCode#',R.DocumentId,S.DocumentOrder
		FROM        Ref_EntityActionDocument R, Ref_EntityDocument S
		WHERE       R.ActionCode = '#URL.ActionCode#'
		AND         R.DocumentId = S.DocumentId 
		AND         S.DocumentType = 'report'
		AND         S.Operational = '1'
		AND         R.DocumentId NOT IN (SELECT DocumentId 
				                         FROM   Ref_EntityClassActionDocument
										 WHERE  EntityCode = '#URL.EntityCode#'
										 AND    EntityClass = '#URL.EntityClass#'
										 AND    ActionCode = '#URL.ActionCode#')						 
	</cfquery>
	
	<cfquery name="Detail" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    R.*, A.ListingOrder, 'ENG' as DocumentLanguageCode, A.ForceDocument, A.Operational as Valid
		FROM      Ref_EntityDocument R INNER JOIN
		          Ref_EntityClassActionDocument A ON R.DocumentId = A.DocumentId 
				  	AND A.EntityCode      = '#URL.EntityCode#' 
					AND A.EntityClass     = '#URL.EntityClass#' 
					AND A.ActionCode      = '#URL.ActionCode#'
		WHERE     R.DocumentType IN  ('report','question')		
		AND       R.EntityCode = '#url.entityCode#'	
		UNION ALL
		SELECT    *,
		          0 as ListingOrder, 
				  'ENG' as DocumentLanguageCode,
				  0 as ForceDocument,
				  0 as Valid
		FROM      Ref_EntityDocument 		
		WHERE     DocumentType IN  ('report','question')		
		AND       DocumentId NOT IN (SELECT DocumentId 
		                             FROM   Ref_EntityClassActionDocument
									 WHERE  EntityCode       = '#URL.EntityCode#'	
									 AND    EntityClass      = '#URL.EntityClass#'
									 AND    ActionCode       = '#URL.ActionCode#')	                      
		AND       EntityCode = '#URL.EntityCode#'	
		AND       DocumentId IN (SELECT DocumentId 
		                         FROM   Ref_EntityActionDocument 
								 WHERE  ActionCode = '#URL.ActionCode#')
		ORDER BY  R.DocumentType, R.DocumentOrder
	</cfquery>

</cfif>
	
<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
  
  <tr><td style="height:40px" class="labellarge">Documents to be generated through this workflow step</b></td></tr>	
  <tr>
    <td width="100%" style="padding:15px">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		
    <TR>
	   <td height="17" class="labelit" width="15%">Code</td>
	   <td width="20%" class="labelit">Name</td>
	   <td width="6%" class="labelit">Mode</td>
	   <td width="40%" class="labelit">Template</td>
	   <td width="10%" class="labelit">Language</td>
	   <td width="10%" class="labelit" align="center" style="padding-left:4px">Passtru</td>
	   <td width="10%" class="labelit" align="center" style="padding-left:4px">Force</td>
	   <td width="7%" class="labelit" align="center" style="padding-left:4px">Sort</td>
	   <td width="10%" class="labelit" style="padding-left:4px">Enabled</td>
    </TR>	
	<tr><td height="1" colspan="9" class="line"></td></tr>
		
	<cfif detail.recordcount eq "0">
		<tr><td colspan="9" 
		        height="30" class="labelit"
				align="center">There are no output documents configured for this action.</td></tr>
	</cfif>
		
	<cfoutput query="Detail">
	
		<cfif DocumentType eq "report">
		   <cfset cl = "regular">
		<cfelse>
		   <cfset cl = "hide">
		</cfif>
									
		<cfset cd  = DocumentCode>
		<cfset ord = "1">
																
		<cfif URL.ID2 eq documentId>
							
		<cfelse>
		
			<TR class="cellcontent line">
			   <td height="20">#cd#</td>			   
			   <td>#DocumentDescription#</td>			   
			   <td>#DocumentMode#</td>				   
			   <td style="word-break: break-all;padding-right:10px">
			   		<cfset vDocumentTemplate = replace(DocumentTemplate,"\","\\","ALL")>
			   		<a href="javascript:template('#vDocumentTemplate#')">#DocumentTemplate#</a>
			   	</td>					   	
			   <td>
			   
			   	  <table cellspacing="0" cellpadding="0"><tr><td class="#cl#">
			   
			      <cfquery name="Language" 
						datasource="appsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_SystemLanguage
						WHERE  Operational IN ('1','2')
				  </cfquery>	
				   
				  <cfif language.recordcount gte "2">
					   					   					   
					      <select name="languagecode#currentrow#" id="languagecode#currentrow#" size="1" 
						     class="regularxl"
							 onchange="ColdFusion.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&frc='+document.getElementById('forcedocument#currentrow#').checked+'&lan='+this.value+'&lo='+document.getElementById('listingorder#currentrow#').value+'&op='+this.checked,'saverep')">
							  <cfloop query="Language">
								  <option value="#code#" <cfif detail.DocumentLanguageCode eq Code>selected</cfif>>#Code#</option>
							  </cfloop>
						  </select>								   					   
					 					   
				   <cfelse>
					
						<input type="hidden" name="languagecode#currentrow#" id="languagecode#currentrow#" value="#language.code#">   
					   
				   </cfif>   
				   
				   </td>
				   
				   </tr>
				   
				   </table>
				   
			   </td>		
			      
			   <td align="center" style="padding-left:4px">#DocumentStringList#</td>
			   
			   <td align="center" style="padding-left:4px">
			   
			   	 <table cellspacing="0" cellpadding="0"><tr><td class="#cl#">
			   
			     <input type="checkbox"
				        name="forcedocument#currentrow#" 
						id="forcedocument#currentrow#"
						value="1" 
					    onclick="ColdFusion.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&frc='+this.checked+'&lan='+document.getElementById('languagecode#currentrow#').value+'&lo='+document.getElementById('listingorder#currentrow#').value+'&op='+this.checked,'saverep')"
				        <cfif forcedocument eq "1">checked</cfif>>
						
					</td></tr></table>	
								 
			   </td>		
			   
			   <td align="center" style="padding-left:4px">
			   
			        <table cellspacing="0" cellpadding="0">
					
					<tr><td class="#cl#">
			   
			        <input type="Text" 
					    value="#ord#" 
						name="listingorder#currentrow#" 
						id="listingorder#currentrow#"
						required="No" 
						visible="Yes" 
						enabled="Yes" 
						style="text-align:center;width:20"
						size="1" 
						onchange="ColdFusion.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&frc='+document.getElementById('forcedocument#currentrow#').checked+'&lan='+document.getElementById('languagecode#currentrow#').value+'&lo='+this.value+'&op='+document.getElementById('operational#currentrow#').checked,'saverep')"
						maxlength="2" 
						class="regularxl">
						
					</td></tr>
						
					</table>
						
			   </td>
			   
			   </td>
			   
			   <td align="center" style="padding-left:4px">
			   
			     <input type   = "checkbox"
					   name    = "operational#currentrow#"
					   id="operational#currentrow#" 
					   value   = "1" 
					   onclick = "ColdFusion.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&frc='+document.getElementById('forcedocument#currentrow#').checked+'&lan='+document.getElementById('languagecode#currentrow#').value+'&lo='+document.getElementById('listingorder#currentrow#').value+'&op='+this.checked,'saverep')"
				       <cfif valid eq "1">checked</cfif>>					
			 
			   </td>	
			   			  			   
		    </TR>	
				
		</cfif>
		
		<tr><td height="1" colspan="9" class="linedotted"></td></tr>
					
	</cfoutput>
						
	</table>
	</td>
	</tr>
	<tr><td id="saverep"></td></tr>
						
</table>	
	
