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

<tr class="line"><td colspan="2" class="labelmedium" style="font-weight:200;height:40px;font-size:22px;padding-left:10px"> 	
	<cf_tl id="Select Documents">:
	</td>
</tr>
   
<tr><td colspan="2" style="padding-top:4px">

	<cfform action="ProcessActionSubmit.cfm?reload=1&wfmode=8&process=#url.process#&ID=#URL.ID#&ajaxId=#url.ajaxid#" 
       method="post" name="processaction"  id="processaction">

	<table width="95%" align="center" cellspacing="0" cellpadding="0">
	   		 
	<tr><td class="hide"></td></tr>	
					
		 <!--- Element 3 of 3 GENERATE DOCUMENT --->
		 
		<cfoutput query="Format">  	
		    	   
		  		   
		   <!--- new form to capture the results of the selected report(s) to be generated --->
		   	   
					 <cfoutput>
						<input name="Key1" id="Key1" type="hidden" value="#Object.ObjectKeyValue1#">
						<input name="Key2" id="Key2" type="hidden" value="#Object.ObjectKeyValue2#">
						<input name="Key3" id="Key3" type="hidden" value="#Object.ObjectKeyValue3#">
					    <input name="Key4" id="Key4" type="hidden" value="#Object.ObjectKeyValue4#">
					 </cfoutput>
									  			
					    <cfset cls = "">	
							      
						   <cfif CurrentDocument eq "">
						        <TR class="regular line">
					       <cfelse>
						        <TR class="highlight1 line">
					       </cfif> 
						   
						   <td width="40" id="docoption#documentid#">
						  						   
							<table cellspacing="0" cellpadding="0" class="formpadding"><tr><td>
																    
								<cfif CurrentDocument eq "">
								
								 <button class="button3" 
								 type="button"
								   onclick="savereportfields('0');embedtabdoc('#url.id#','#documentid#',document.getElementById('signatureblock#documentcode#').value,document.getElementById('languagecode#documentcode#').value,document.getElementById('format#documentcode#').value,'#currentrow#','add')"
								   style="width:26;height:19">
								 <img src="#SESSION.root#/Images/write.gif" alt="Add" border="0" align="absmiddle">
								 </button>
								<cfelse>
								 <button class="button3" 
								    style="width:26;height:19"
									type="button"
								    onclick="savereportfields('0');embedtabdoc('#url.id#','#documentid#',document.getElementById('signatureblock#documentcode#').value,document.getElementById('languagecode#documentcode#').value,document.getElementById('format#documentcode#').value,'#currentrow#','delete')">
								 <img src="#SESSION.root#/Images/delete5.gif" height="13" width="13" alt="Remove" border="0" align="absmiddle">
								 </button>
								 </td>
								 <td>
								 <button class="button3" 
								 style="width:26;height:19"
								 type="button"
								   onclick="savereportfields('0');embedtabdoc('#url.id#','#documentid#',document.getElementById('signatureblock#documentcode#').value,document.getElementById('languagecode#documentcode#').value,document.getElementById('format#documentcode#').value,'#currentrow#','refresh')">
								 <img src="#SESSION.root#/Images/refresh3.gif" alt="Refresh" border="0" align="absmiddle">									
								 </button>
								</cfif>
							</td></tr>
							</table>								
						   
						   </td>	
						   <TD class="labelmedium" style="height:28px;padding-left:4px">#CurrentRow#.</TD>
					       <TD class="labelmedium">#DocumentDescription#</TD>
						   <TD class="labelmedium">#DocumentCode#</TD>
						   						   
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
							   
							   <td>
							   
							      <select name="languagecode#documentcode#" id="languagecode#documentcode#" size="1" class="regularxl">
									  <cfloop query="Language">
										  <option value="#code#" <cfif presetlan eq Code>selected</cfif>>#Code#</option>
									  </cfloop>
								  </select>								   
							   
							   </td>
							   
						   <cfelse>
							
								<input type="hidden" name="languagecode#documentcode#" id="languagecode#documentcode#" value="#language.code#">   
							   
						   </cfif>   
						   
						   <cfif DocumentFramework eq "1">					   
							
							   <td>

			   						<!--- Getting data of the template ---> 
									<cfset l = len(Format.DocumentTemplate)>		
							        <cfset path = left(Format.DocumentTemplate,l-4)>		
									<cfset vList = "Memo,Letter,Fax,Note">
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
										
									</cfif>
																			
							        <select name="format#documentcode#" id="format#documentcode#" style="width:90px" size="1" class="regularxl">
										<cfloop list="#vListFinal#" index="vItem">
											<option value="#vItem#" <cfif Format.DocumentFormat eq "#vItem#">selected</cfif>>#vItem#</option>
										</cfloop>
									</select>										   
							   
							   </td>
						   
						   <cfelse>
							   
								<td><input type="hidden" name="format#documentcode#" id="format#documentcode#" value=""></td>
						   
						   </cfif>
						   								   
						   <td>						   		   
						   
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
						   
						   		<select name="signatureblock#documentcode#" id="signatureblock#documentcode#" size="1" class="regularxl">
								<cfloop query="Signature">
								    <option value="#code#" <cfif Format.SignatureBlock eq "#Code#">selected</cfif>>#Code# #BlockLine1#</option>
								</cfloop>
								</select>
								
						   <cfelse>
						   
						   	<input type="hidden" name="signatureblock#documentcode#" id="signatureblock#documentcode#" value="">
						   
						   </cfif>		
								  
						   </td>
						   <td class="labelmedium"><cfif CurrentDocument neq "">#LastName#</cfif></td>
						   <TD class="labelmedium">#DateFormat(Created,CLIENT.DateFormatShow)#</TD>
							
						   </TR>
						 
						   <tr><td colspan="9" id="docaction#documentid#"></td></tr>
							
					   </td></tr>						 	   	
						
		  	
		 </CFOUTPUT>	
		 
		 </table>			      

		</cfform>
		
		</td>
		
	</tr>	
					
</cfif>					

