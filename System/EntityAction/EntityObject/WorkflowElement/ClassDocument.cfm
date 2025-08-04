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

<cfparam name="URL.ID2" default="">

<!--- attention associated information elements are automatically propagated to the step of a published workflow 
and can be diabled --->
	
<cfquery name="ActionMode" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_EntityAction
	WHERE  ActionCode  = '#URL.ActionCode#'
</cfquery>	
 
<cfif url.publishNo neq "">
	
	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO Ref_EntityActionPublishDocument
					(ActionPublishNo,ActionCode,DocumentId,ListingOrder,Operational)
		SELECT      '#URL.PublishNo#','#URL.ActionCode#',R.DocumentId,S.DocumentOrder,0
		FROM        Ref_EntityActionDocument R INNER JOIN 
		            Ref_EntityDocument S ON R.DocumentId = S.DocumentId
		WHERE       R.ActionCode      = '#URL.ActionCode#'		
		<cfif actionMode.ProcessMode gte "1">			
		AND         S.DocumentType IN  ('function','dialog','field','attach','session','action')
		<cfelse>
		AND         S.DocumentType IN  ('dialog','field','attach','session','action')
		</cfif>
		AND         S.Operational = '1'
		AND         R.DocumentId NOT IN (SELECT DocumentId 
		                                 FROM   Ref_EntityActionPublishDocument
								         WHERE  ActionPublishNo = '#URL.PublishNo#'
								         AND    ActionCode      = '#URL.ActionCode#')		
										 
													 
	</cfquery>
	
	<!--- remove globally disabled --->
	
	<cfquery name="Clean" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE  FROM  Ref_EntityActionPublishDocument
		WHERE   DocumentId IN (SELECT DocumentId 
		                       FROM   Ref_EntityDocument 
							   WHERE  EntityCode = '#ActionMode.EntityCode#'
							   AND    Operational = 0)							 
	</cfquery>	
	
	<cfquery name="Detail" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    R.*, A.ListingOrder, A.ObjectFilter,A.UsageParameter,A.Operational as Valid
		FROM      Ref_EntityDocument R INNER JOIN
		          Ref_EntityActionPublishDocument A ON R.DocumentId = A.DocumentId 
				  	AND A.ActionPublishNo = '#URL.PublishNo#' 
					AND A.ActionCode      = '#URL.ActionCode#'
		<cfif actionMode.ProcessMode gte "1">			
		WHERE     R.DocumentType IN  ('function','dialog','field','attach','session','action')
		<cfelse>
		WHERE     R.DocumentType IN  ('dialog','field','attach','session','action')
		</cfif>
		AND       R.EntityCode = '#url.entityCode#'	
		
		<!--- no longer needed as above they are added already --->
		
		<cfif actionMode.ProcessMode gte "1">	
		
			UNION ALL
			SELECT    *,0 as ListingOrder, '' as ObjectFilter, '' as UsageParameter, 0 as Valid
			FROM      Ref_EntityDocument 			
			WHERE     DocumentType IN  ('function')		
			AND       Operational = '1'
			AND       DocumentId NOT IN (SELECT DocumentId 
			                             FROM   Ref_EntityActionPublishDocument
										 WHERE  ActionPublishNo = '#URL.PublishNo#'	
										 AND    ActionCode       = '#URL.ActionCode#')	                      
			AND       EntityCode = '#URL.EntityCode#'					
		
		</cfif>
		
		ORDER BY  R.DocumentType DESC, R.DocumentOrder
		
	</cfquery>
	

<cfelse>

	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO Ref_EntityClassActionDocument
					(EntityCode, EntityClass,ActionCode,DocumentId,ListingOrder,Operational)
		SELECT      '#URL.EntityCode#','#URL.EntityClass#','#URL.ActionCode#',R.DocumentId,S.DocumentOrder,0
		FROM        Ref_EntityActionDocument R INNER JOIN Ref_EntityDocument S ON R.DocumentId = S.DocumentId 
		WHERE       R.ActionCode = '#URL.ActionCode#'		    
		<cfif actionMode.ProcessMode gte "1">			
		AND         S.DocumentType IN  ('function','dialog','field','attach','session')
		<cfelse>
		AND         S.DocumentType IN  ('dialog','field','attach','session')
		</cfif>
		AND         S.Operational = '1'
		AND         R.DocumentId NOT IN (SELECT DocumentId 
				                         FROM   Ref_EntityClassActionDocument
										 WHERE  EntityCode  = '#URL.EntityCode#'
										 AND    EntityClass = '#URL.EntityClass#'
										 AND    ActionCode  = '#URL.ActionCode#')						 
	</cfquery>
	
	<!--- remove globally disabled --->
	
	<cfquery name="Clean" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE  FROM  Ref_EntityClassActionDocument
		WHERE   DocumentId IN (SELECT DocumentId 
		                       FROM   Ref_EntityDocument 
							   WHERE  EntityCode = '#URL.EntityCode#'
							   AND    Operational = 0)							 
	</cfquery>	
	
	<cfquery name="Detail" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    R.*, A.ListingOrder, A.ObjectFilter, A.UsageParameter,A.Operational as Valid
		FROM      Ref_EntityDocument R INNER JOIN
		          Ref_EntityClassActionDocument A ON R.DocumentId = A.DocumentId 
				  	AND A.EntityCode      = '#URL.EntityCode#' 
					AND A.EntityClass     = '#URL.EntityClass#' 
					AND A.ActionCode      = '#URL.ActionCode#'
		<cfif actionMode.ProcessMode gte "1">			
		WHERE     R.DocumentType IN  ('function','dialog','field','attach','session')
		<cfelse>
		WHERE     R.DocumentType IN  ('dialog','field','attach','session')
		</cfif>
		AND       R.EntityCode = '#url.entityCode#'	
		
		<cfif actionMode.ProcessMode gte "1">		
		
			UNION ALL
			
			SELECT    *,0 as ListingOrder, '' as objectFilter, '' as UsageParameter, 0 as Valid
			FROM      Ref_EntityDocument as R		
			WHERE     R.DocumentType IN  ('function')	
			
			AND       DocumentId NOT IN (SELECT DocumentId 
			                             FROM   Ref_EntityClassActionDocument
										 WHERE  EntityCode       = '#URL.EntityCode#'	
										 AND    EntityClass      = '#URL.EntityClass#'
										 AND    ActionCode       = '#URL.ActionCode#')	                      
			AND       EntityCode = '#URL.EntityCode#'	
			AND       Operational = 1	
		
		</cfif>
		
		ORDER BY  R.DocumentType DESC, R.DocumentOrder
	</cfquery>

</cfif>

	<cf_divscroll>
		
	<table width="94%" align="center">
		  
	  <tr>
	    <td width="100%">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
				
		<cfif detail.recordcount eq "0">
		<tr><td colspan="6" align="center" height="80" class="labelmedium">There are no custom supporting objects configured for this action. If you require selection please enable them first on this action.</td></tr>
		</cfif>
						
		<!--- upon creation of the object we can pass a filter to the organizationObject, this will then 
		allow to show the custom fields/templates only if that object at runtime has indeed the filtered value
		as defined below --->
		
		<cfquery name="Filter" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   DISTINCT ObjectFilter
			FROM     OrganizationObject
			WHERE    EntityCode  = '#URL.EntityCode#'
			AND      ObjectFilter > ''
		    ORDER BY ObjectFilter
		</cfquery>	  		
		
		 <TR class="line labelmedium fixrow fixlengthlist">
		   <td style="min-width:40px;padding-left:5px"></td>	
		   <td style="min-width:40px;padding-left:4px"><cf_tl id="Code"></td>
		   <td><cf_tl id="Description"></td>
		   <td><cf_tl id="Apply"></td>
		   <td><cf_tl id="Sort"></td>
		   <td align="center"><cf_tl id="Type"></td>		  
		  	  
	    </TR>	
			
		<cfoutput query="Detail" group="DocumentType">	
		
		<tr><td style="height:3px"></td></tr>		
		
		<cfif DocumentType eq "Attach">
		<tr class="fixlengthlist"><td colspan="6" style="height:38px;font-size:18px;font-weight:bold" class="labelmedium">Attachments</td></tr>
		<cfelseif DocumentType eq "Field">
		<tr class="fixlengthlist"><td colspan="6" style="height:38px;font-size:18px;font-weight:bold" class="labelmedium">Custom Fields</td></tr>
		<cfelseif DocumentType eq "dialog">
		<tr class="fixlengthlist"><td colspan="6" style="height:38px;font-size:18px;font-weight:bold" class="labelmedium">Custom Dialogs <font size="1">(not enabled yet, please use custom dialog on the standard setting tab)</td></tr>
		<cfelse>		
		<tr class="fixlengthlist"><td colspan="6" style="height:38px;font-size:18px;font-weight:bold" class="labelmedium">Standard workflow-only dialogs</td></tr>
		</cfif>						
				
		<cfoutput>		
		
			<cfif documentType neq "dialog">
										
			<cfset cd  = DocumentCode>
			<cfset ord = ListingOrder>
			<cfset fil = ObjectFilter>
			<cfset prm = UsageParameter>
						
			<input type="hidden" name="Code" id="Code" value="<cfoutput>#cd#</cfoutput>">
													
				<TR class="labelmedium line" style="height:25px">
				
					 <td align="center">
				      <input type="checkbox"
					   name="operational#currentrow#" 
					   id="operational#currentrow#"
					   value="1" 
					   style="height:16;width:16"
					   onclick="ptoken.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&fil='+document.getElementById('objectfilter#currentrow#').value+'&lo='+document.getElementById('listingorder#currentrow#').value+'&prm='+document.getElementById('usageparameter#currentrow#').value+'&op='+this.checked,'savedoc')"
				    <cfif valid eq "1">checked</cfif>>
				   </td>
				   
				   <td height="23" style="padding-left:4px;padding-right:5px" width="40">#cd#</td>
				   <td>#DocumentDescription#</td>
				   <td>
				   
				   <cfif DocumentType eq "function" and DocumentCode eq "fled">
				   
				   	<cfquery name="JournalList" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_TransactionCategory						
					</cfquery>	  
					
					<!-- <cfform> -->
					
					     <cfselect name="objectfilter#currentrow#"				         
				          queryposition="below"
				          query="JournalList"
				          value="TransactionCategory"
				          display="Description"
				          visible="Yes"
				          enabled="Yes"
						  selected="#fil#"
						  style="border:0px;border-left:1px solid silver; border-right:1px solid silver"
				          onchange="ptoken.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&fil='+this.value+'&lo='+document.getElementById('listingorder#currentrow#').value+'&prm='+document.getElementById('usageparameter#currentrow#').value+'&op='+document.getElementById('operational#currentrow#').checked,'savedoc')"
				          id="objectfilter#currentrow#"
				          class="regularxl">
							   
					    <option value="">n/a</option>
					  	
						</cfselect>
					   
					   <!-- </cfform> -->
				   
				   
				   <cfelse>
				   
				   	   <cfif documenttype neq "attach">
				   
					   <select name="objectfilter#currentrow#" 		
					   		   id="objectfilter#currentrow#" 
							   class="regularxl"	
							   style="border:0px;border-left:1px solid silver; border-right:1px solid silver"			 						  					   
							   onchange="ptoken.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&fil='+this.value+'&lo='+document.getElementById('listingorder#currentrow#').value+'&prm='+document.getElementById('usageparameter#currentrow#').value+'&op='+document.getElementById('operational#currentrow#').checked,'savedoc')">
							   
					    <option value="">any</option>
					  	 <cfloop query="filter">
					  		<option value="#ObjectFilter#" <cfif fil eq Objectfilter>selected</cfif>>#Objectfilter#</option>		   
					   	</cfloop>
						</select>
						
						<cfelse>
						
						 <select name="objectfilter#currentrow#" 		
					   		   id="objectfilter#currentrow#" 
							   class="regularxl"	
							   style="border:0px;border-left:1px solid silver; border-right:1px solid silver"			 						  					   
							   onchange="ptoken.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&fil='+this.value+'&lo='+document.getElementById('listingorder#currentrow#').value+'&prm='+document.getElementById('usageparameter#currentrow#').value+'&op='+document.getElementById('operational#currentrow#').checked,'savedoc')">
							   
					       <option value="Insert">Insert</option>
						   <option value="Inquiry" <cfif fil eq "Inquiry">selected</cfif>>Inquiry</option>
					  	
						  </select>
						
						
						</cfif>
						
					
				   </cfif>	
				   
				   </td>
				   
				   <td>
				      <input type    = "Text" 
					       value     = "#ord#" 
						   name      = "listingorder#currentrow#" 
						   id        = "listingorder#currentrow#"
						   required  = "No" 
						   visible   = "Yes" 
						   enabled   = "Yes" 						   
						   style     = "text-align:center;border:0px;border-left:1px solid silver; border-right:1px solid silver"
						   size      = "1" 
						   onchange  = "ptoken.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&fil='+document.getElementById('objectfilter#currentrow#').value+'&lo='+this.value+'&prm='+document.getElementById('usageparameter#currentrow#').value+'&op='+document.getElementById('operational#currentrow#').checked,'savedoc')"
						   maxlength = "2" 
						   class     = "regularxl">
						   
				   </td>
				   <td align="center"> 
				   
				    <cfif DocumentType eq "Field">#FieldType#				   
 				      <input type="hidden" name="usageparameter#currentrow#" id="usageparameter#currentrow#" value="">				   
				    <cfelseif documenttype eq "attach">		
					
					    <select name="usageparameter#currentrow#" 		
					   		   id="usageparameter#currentrow#" 
							   class="regularxl"	
							   title     = "Include attachment in the Process mail for this step"
							   style="border:0px;border-left:1px solid silver; border-right:1px solid silver"			 						  					   
							   onchange="ptoken.navigate('#SESSION.root#/System/EntityAction/EntityObject/WorkflowElement/ClassDocumentSubmit.cfm?EntityClass=#URL.EntityClass#&PublishNo=#URL.PublishNo#&entitycode=#URL.EntityCode#&actionCode=#URL.ActionCode#&ID2=#documentid#&fil='+document.getElementById('objectfilter#currentrow#').value+'&lo='+document.getElementById('listingorder#currentrow#').value+'&prm='+this.value+'&op='+document.getElementById('operational#currentrow#').checked,'savedoc')">					
						   
					    <option value="">None</option>
						<option value="Mail" <cfif prm eq "Mail">selected</cfif>>Mail</option>
					  	 
						</select>	
					 <cfelse>					
					  <input type="hidden" value="" name="usageparameter#currentrow#" id="usageparameter#currentrow#">				   
				   </cfif>
				   
				   </td>			  
				   
				  				   
			   </TR>	
			   
			   </cfif>	
			   
		</cfoutput>		
									
		</cfoutput>
							
		</table>
		</td>
		</tr>
		<tr><td id="savedoc"></td></tr>
							
	</table>	
	
	</cf_divscroll>
