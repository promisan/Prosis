<!--- modification history
100811 (MM) -  added 'Operational = 1' to WHERE clause (line 93)
---->

<!--- define documents that are part of this step and inherit from the last available copy --->
									   
<!--- listing of reports --->

<cfquery name="Format" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   C.OfficerLastName as LastName,
	         C.OfficerFirstName as FirstName, 
		     C.ActionId as CurrentDocument, 
		     C.SignatureBlock,
			 C.DocumentFormat,
			 C.DocumentLanguageCode,
	         R.*
	FROM     Ref_EntityDocument R LEFT OUTER JOIN
             OrganizationObjectActionReport C ON R.DocumentId = C.DocumentId AND C.ActionId = '#URL.Id#'   
    WHERE    R.DocumentId IN (SELECT DocumentId 
	                        FROM   Ref_EntityActionPublishDocument 
							WHERE  ActionPublishNo = '#Action.ActionPublishNo#' 
							AND    ActionCode      = '#Action.actioncode#' 
							AND    Operational     = 1)
	AND      R.DocumentType  = 'Report'	
	AND      R.DocumentId IN (
					SELECT  D.DocumentId
				    FROM    Ref_EntityDocument D, 
				            Ref_EntityActionDocument R		
				    WHERE   R.ActionCode   = '#Action.ActionCode#'
				    AND     R.DocumentId   = D.DocumentId 
				    AND     D.DocumentType = 'report' 
				    AND     (D.DocumentStringList = '' or D.DocumentStringList = '#Object.ObjectFilter#')				   
				    AND     D.Operational  = 1
				)
	ORDER BY DocumentOrder
</cfquery>

<cfif format.recordcount gte "1">
	   
<tr><td colspan="2" style="width:800px">

	<cfform action="ProcessActionSubmit.cfm?reload=1&wfmode=8&process=#url.process#&ID=#URL.ID#&ajaxId=#url.ajaxid#" 
	    method="post" name="processaction" id="processaction">

	<table class="navigation_table formspacing">
						
		 <!--- Element 3 of 3 GENERATE DOCUMENT --->
		
		<cfset row = "0">
		
		<cfoutput query="Format">
		
		<cfset row = row+1>
		
		<cfif row eq "1">
		<tr>
		</cfif>  			    	  
		
		<td style="height:100px">
		
		    <table style="width:96%;height:100%" align="center">
				    		  		   
		    <!--- new form to capture the results of the selected report(s) to be generated --->		   	  
					
			<input name="Key1" id="Key1" type="hidden" value="#Object.ObjectKeyValue1#">
			<input name="Key2" id="Key2" type="hidden" value="#Object.ObjectKeyValue2#">
			<input name="Key3" id="Key3" type="hidden" value="#Object.ObjectKeyValue3#">
		    <input name="Key4" id="Key4" type="hidden" value="#Object.ObjectKeyValue4#">
											  			
		    <cfset cls = "">	
				      
			<cfif CurrentDocument eq "">
			     <TR class="highlight1">
		    <cfelse>
			     <TR class="highlight1">
		    </cfif> 			  
			 
			<td style="padding:2px">
			   			   						  						   
				<table style="width:280px;background-color:ffffff" class="formpadding">
						
					<tr class="labelmedium2 line">
					<td style="border-radius:4px;text-align:center;background-color:ffffff;font-weight:normal;font-size:20px" colspan="2">
					<table>
					<tr>
					<td style="padding-left:5px;padding-right:8px"><img src="#session.root#/images/documentedit.png" style="height:30px;width:30px" alt="" border="0"></td>
					<td class="fixlength" title="#DocumentDescription#"	style="padding-top:0px;font-weight:normal;font-size:17px">#DocumentDescription#</td>
					</tr>
					</table>					
					</td>					
					</tr>
						
					<tr class="labelmedium2" style="height:35px;">
											
						<td colspan="2" id="docoption#documentid#" align="center">
						
							<cf_tl id="Preview" var="1">
															    
							<cfif CurrentDocument eq "">
							
							 <input class="button10g" 
							   type="button" style="border-radius:5px;width:92%;border:1px solid c6c6c6;font-size:15px"
							   onclick="savereportfields('0');embedtabdoc('#url.id#','#documentid#',document.getElementById('signatureblock#documentcode#').value,document.getElementById('languagecode#documentcode#').value,document.getElementById('format#documentcode#').value,'#currentrow#','add')"
							   value="#lt_text#">
							   
							<cfelse>
							 
							 <button class="button3" 
							    style="width:26px;height:19px"
								type="button"
							    onclick="savereportfields('0');embedtabdoc('#url.id#','#documentid#',document.getElementById('signatureblock#documentcode#').value,document.getElementById('languagecode#documentcode#').value,document.getElementById('format#documentcode#').value,'#currentrow#','delete')">
							    <img src="#SESSION.root#/Images/delete5.gif" height="20" width="20" alt="Remove" border="0" align="absmiddle">
							 </button>
							
							 <button class="button3" 
							 style="width:26px;height:19px"
							 type="button"
							   onclick="savereportfields('0');embedtabdoc('#url.id#','#documentid#',document.getElementById('signatureblock#documentcode#').value,document.getElementById('languagecode#documentcode#').value,document.getElementById('format#documentcode#').value,'#currentrow#','refresh')">
							 <img src="#SESSION.root#/Images/refresh3.gif" height="20" width="20" alt="Refresh" border="0" align="absmiddle">									
							 </button>
							</cfif>
						</td>
					
					</tr>
					
								   						   
					<cfquery name="PresetDefault" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   *
						FROM     Ref_EntityActionPublishDocument 
						WHERE    ActionPublishNo = '#Action.ActionPublishNo#'
						AND      ActionCode      = '#Action.actioncode#' 
						AND      DocumentId      = '#Format.DocumentId#'  
					</cfquery>
					
				   <cfif format.documentLanguageCode eq "">						   
					   <cfset presetlan = PresetDefault.DocumentLanguageCode>						   
				   <cfelse>						   
					   <cfset presetlan = Format.DocumentLanguageCode>							
				   </cfif>
				   
				   <cfquery name="Language" 
						datasource="appsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   Ref_SystemLanguage
							WHERE  Operational IN ('1','2')
				   </cfquery>	
				   		   
				   <cfif language.recordcount gte "2">
				   
				       <tr class="fixlengthlist">	
				   
				   	   <td style="padding-left:20px"><cf_tl id="Language">:</td>
					   
					   <td style="padding-right:20px" align="right">
					   
					      <select name="languagecode#documentcode#" id="languagecode#documentcode#" size="1" class="regularxxl" style="border-left:1px solid silver;border-right:1px solid silver">
							  <cfloop query="Language">
								  <option value="#code#" <cfif presetlan eq Code>selected</cfif>>#Code#</option>
							  </cfloop>
						  </select>								   
					   
					   </td>
					   
					   </tr>
					   
				   <cfelse>
					
						<input type="hidden" name="languagecode#documentcode#" id="languagecode#documentcode#" value="#language.code#">   
					   
				   </cfif>   
				   
				   <cfif DocumentFramework eq "1">
				   
				       <tr class="labelmedium2 fixlengthlist">	
				   
				   	   <td style="padding-left:20px"><cf_tl id="Layout">:</td> 					   
					
					   <td style="padding-right:20px" align="right">
	
	   						<!--- Getting data of the template ---> 
							<cfset l = len(Format.DocumentTemplate)>		
					        <cfset path = left(Format.DocumentTemplate,l-4)>		
							<cfset vList = "Memo,Letter,Fax,Note,Legal">
							<cfset vListFinal = "">
							
							<cfloop index="vItem" list="#vList#">
								<cfif FileExists("#SESSION.rootPath#/#path#_#vItem#.cfm")> 
									<cfif vListFinal eq "">
										<cfset vListFinal = vItem>
									<cfelse>
										<cfset vListFinal = vItem & "," & vListFinal >	
									</cfif>
								</cfif>	
							</cfloop>
							
							<cfif vListFinal eq "">
							
							<input type="hidden" name="format#documentcode#" id="format#documentcode#" value="">
							
							<cfelse>																	
																										
					        <select name="format#documentcode#" id="format#documentcode#" 
							     style="border-left:1px solid silver;border-right:1px solid silver" size="1" class="regularxxl">
								<cfloop list="#vListFinal#" index="vItem">
									<option value="#vItem#" <cfif Format.DocumentFormat eq "#vItem#">selected</cfif>>#vItem#</option>
								</cfloop>
							</select>
							
							</cfif>										   
					   
					   </td>
					   
					   </tr>
				   
				   <cfelse>
					   
						<input type="hidden" name="format#documentcode#" id="format#documentcode#" value="">
				   
				   </cfif>
				   								   
				  			   
				   <cfif Object.Orgunit neq "">
				   
				      <cfquery name="OrgUnit" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						 	 SELECT *
							 FROM   Organization
							 WHERE  OrgUnit    = '#Object.OrgUnit#'			 	
						</cfquery>
				   
					   <cfquery name="Signature" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
							SELECT    * 
							FROM      Ref_EntityDocumentSignature
							WHERE     EntityCode = '#Object.EntityCode#'
							AND       Mission = '#Object.Mission#' 
							AND       PersonNo IN
					                      (SELECT  PersonNo
					                       FROM    Employee.dbo.PersonAssignment
					                       WHERE   OrgUnit IN
					                                        (SELECT    OrgUnit
					                                         FROM      Organization
					                                         WHERE     Mission = '#OrgUnit.Mission#' 
															 AND       MandateNo = '#OrgUnit.MandateNo#' 
															 AND       HierarchyCode LIKE ('#orgUnit.HierarchyCode#%')) 
										   AND     DateEffective <= GETDATE() 
										   AND     DateExpiration >= GETDATE() 
										   AND     Incumbency > 0 
										   AND     AssignmentStatus IN ('0','1')) 
						    AND        Operational = 1
						</cfquery>	
				   	
					<cfelse>			   		   
				   
					   <cfquery name="Signature" 
						datasource="appsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_EntityDocumentSignature
						WHERE  EntityCode = '#Object.EntityCode#'
						AND    Code IN (SELECT Code 
							            FROM   Ref_EntityDocumentSignatureMission
										WHERE  EntityCode = '#Object.EntityCode#'
										AND    Mission    = '#Object.Mission#')							
						AND    Operational = 1
						</cfquery>
					
					</cfif>				   		   
				  		
					<cfif Signature.recordcount eq "0">
												
						<cfquery name="Signature" 
						datasource="appsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM Ref_EntityDocumentSignature
							WHERE EntityCode = '#Object.EntityCode#'
							<cfif Object.Mission neq "">
							AND (Mission = '#Object.Mission#' or Mission is NULL)
							</cfif>
							AND Operational = 1
						</cfquery>	
					
					</cfif>
				   	
					<cfif signature.recordcount gte "1">
					
					    <tr class="labelmedium2 fixlengthlist"">
						<td style="padding-left:20px"><cf_tl id="Signature">:</td>
				   
				        <td style="padding-right:20px" align="right" title="Legacy : Hardcoded signature box outside workflow">
				   		<select name="signatureblock#documentcode#" id="signatureblock#documentcode#" 
						   style="border-left:1px solid silver;border-right:1px solid silver;width:100%" size="1" class="regularxxl">
						<cfloop query="Signature">
						    <option value="#code#" <cfif Format.SignatureBlock eq "#Code#">selected</cfif>>#Code# #BlockLine1#</option>
						</cfloop>
						</select>
						</td>
						
						</tr>
						
				   <cfelse>
				   
				   	<input type="hidden" name="signatureblock#documentcode#" id="signatureblock#documentcode#" value="">
				   
				   </cfif>		
						  
				   <tr><td colspan="2" id="docaction#documentid#"></td></tr>			   	   						
							 		 
			 </table>	
		 
			 <td>
			 
			 <cfif row eq "3">
			    </tr>
			  <cfset row = "0">
			  </cfif>		
			  
			 </table> 
		 
		  </CFOUTPUT>		
		  
		 </td>
		 
		 </tr>
		 
		 </table> 	      

		</cfform>
		
		</td>		
	
					
</cfif>					

