
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
	
	<cfquery name="Action" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_EntityActionPublish 
	WHERE  ActionPublishNo = '#URL.PublishNo#' 
	AND    ActionCode      = '#URL.ActionCode#'		
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
										 WHERE  EntityCode  = '#URL.EntityCode#'
										 AND    EntityClass = '#URL.EntityClass#'
										 AND    ActionCode  = '#URL.ActionCode#')						 
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
	
	<cfquery name="Action" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_EntityClassAction A
		WHERE  A.EntityCode      = '#URL.EntityCode#' 
		AND    A.EntityClass     = '#URL.EntityClass#' 
		AND    A.ActionCode      = '#URL.ActionCode#'
	</cfquery>

</cfif>
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  
  <tr>
    <td width="100%" style="padding:3px">
	
	<cfoutput>
	    <table width="100%" class="formpadding">
		
			<TR class="labelmedium line"><td>Tab: label questionaire:</td>
			     <td><input type="text" name="LabelQuestionaire" size="50" maxlength="50" value="#Action.LabelQuestionaire#" class="regularxl"
				 onchange="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#SESSION.root#/System/EntityAction/EntityFlow/ClassAction/ClassActionSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&field=questionaire&value='+this.value,'saverep')">
				 </td></tr>
			<TR class="labelmedium line"><td>Tab: label document:</td>
				 <td><input type="text" name="LabelDocument" size="50" maxlength="50" value="#Action.LabelDocument#" class="regularxl"
				 onchange="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#SESSION.root#/System/EntityAction/EntityFlow/ClassAction/ClassActionSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&field=document&value='+this.value,'saverep')"></td>
			</tr>
		
		</table>
	</cfoutput>	
	</td>
  </tr>
  
  <tr><td style="height:40px" class="labellarge">Documents and/or Questionaires to be generated through this workflow step</td></tr>	
 
  
  <tr>	
	<td width="100%" style="padding:3px">
	
	<table width="100%" class="navigation_table">
		
    <TR class="labelmedium line fixlengthlist">
	   <td height="17" style="min-width:50px"><cf_tl id="Code"></td>
	   <td><cf_tl id="Name"></td>
	   <td width="6%"><cf_tl id="Mode"></td>
	   <td><cf_tl id="Template"></td>
	   <td><cf_tl id="Language"></td>
	   <td align="center" style="padding-left:4px"><cf_tl id="Passtru"></td>
	   <td align="center" style="padding-left:4px"><cf_tl id="Force"></td>
	   <td align="center" style="padding-left:4px"><cf_tl id="Sort"></td>
	   <td><cf_tl id="Enabled"></td>
    </TR>	
			
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
		
			<TR class="line labelmedium navigation_row fixlengthlist" style="height:20px">
			   <td style="padding-left:3px">#cd#</td>			   
			   <td>#DocumentDescription#</td>			   
			   <td>#DocumentMode#</td>	
			   <cfset vDocumentTemplate = replace(DocumentTemplate,"\","\\","ALL")>			   
			   <td title="#vDocumentTemplate#" style="padding-right:10px">			   		
			   		<a href="javascript:template('#vDocumentTemplate#')">#DocumentTemplate#</a>
			   	</td>					   	
			   <td>
			   
			   	  <table><tr><td class="#cl#">
			   
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
						     class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver"
							 onchange="ptoken.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&frc='+document.getElementById('forcedocument#currentrow#').checked+'&lan='+this.value+'&lo='+document.getElementById('listingorder#currentrow#').value+'&op='+this.checked,'saverep')">
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
			   
			   <td align="center" style="padding-left:4px;bo4der-left:1px solid silver">
			   
			   	 <table><tr><td class="#cl#">
			   
			     <input type="checkbox"
				        name="forcedocument#currentrow#" 
						id="forcedocument#currentrow#"
						value="1" class="Radiol"						
					    onclick="ptoken.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&frc='+this.checked+'&lan='+document.getElementById('languagecode#currentrow#').value+'&lo='+document.getElementById('listingorder#currentrow#').value+'&op='+this.checked,'saverep')"
				        <cfif forcedocument eq "1">checked</cfif>>
						
					</td></tr></table>	
								 
			   </td>		
			   
			   <td align="center" style="padding-left:4px">
			   
			        <table>
					
					<tr><td>
			   
			        <input type="Text" 
					    value="#ord#" 
						name="listingorder#currentrow#" 
						id="listingorder#currentrow#"
						required="No" 
						visible="Yes" 
						enabled="Yes" 
						style="text-align:center;width:30;border:0px;border-left:1px solid silver;border-right:1px solid silver"
						size="1" 
						onchange="ptoken.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&frc='+document.getElementById('forcedocument#currentrow#').checked+'&lan='+document.getElementById('languagecode#currentrow#').value+'&lo='+this.value+'&op='+document.getElementById('operational#currentrow#').checked,'saverep')"
						maxlength="2" 
						class="regularxl">
						
					</td></tr>
						
					</table>
						
			   </td>
			   
			   </td>
			   
			   <td align="center" style="padding-left:4px">
			   
			     <input type   = "checkbox"
					   name    = "operational#currentrow#"
					   class    = "Radiol"
					   id="operational#currentrow#" 
					   value   = "1" 
					   onclick = "ptoken.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&frc='+document.getElementById('forcedocument#currentrow#').checked+'&lan='+document.getElementById('languagecode#currentrow#').value+'&lo='+document.getElementById('listingorder#currentrow#').value+'&op='+this.checked,'saverep')"
				       <cfif valid eq "1">checked</cfif>>					
			 
			   </td>	
			   			  			   
		    </TR>	
				
		</cfif>
							
	</cfoutput>
						
	</table>
	</td>
	</tr>
	
	<tr><td id="saverep"></td></tr>
						
</table>	

<cfset ajaxonload("doHighlight")>
	
