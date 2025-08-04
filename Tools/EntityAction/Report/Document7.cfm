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
<!--- modification history
100811 (MM) -  added 'Operational = 1' to WHERE clause (line 81)
--->
 
<cfquery name="Format" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT C.OfficerLastName as LastName,
	       C.OfficerFirstName as FirstName, 
		   C.ActionId as CurrentDocument, 
		   C.SignatureBlock,
	       R.*
	FROM   Ref_EntityDocument R INNER JOIN
           Ref_EntityActionDocument R1 ON R.DocumentId = R1.DocumentId LEFT OUTER JOIN
           OrganizationObjectActionReport C ON R.DocumentId = C.DocumentId 
		   AND C.ActionId     = '#URL.Id#'   
    WHERE  R1.ActionCode   = '#Action.ActionCode#' 
	AND    R.DocumentType  = 'Report'
	AND    R.Operational   = 1
	ORDER BY DocumentOrder
</cfquery>
 

<cfif format.recordcount gte "1">

<cfform action="ProcessActionSubmit.cfm?reload=1&wfmode=8&process=#url.process#&ID=#URL.ID#&ajaxId=#url.ajaxid#" method="post" name="processaction"  id="processaction">
	   
	   <tr><td height="15"></td></tr>
		<tr><td><b><font size="2" color="gray"><cf_tl id="Select documents to be included"></td></tr>
		<tr><td bgcolor="E0E0E0"></td></tr>
		<tr><td>
			
		<!--- Element 3 of 3 GENERATE DOCUMENT --->
		  	    	   
		   <cfquery name="Document" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			   SELECT D.*
			   FROM   Ref_EntityDocument D, 
			          Ref_EntityActionDocument R		
			   WHERE  R.ActionCode   = '#Action.ActionCode#'
			   AND    R.DocumentId     = D.DocumentId 
			   AND    D.DocumentType   = 'report' 
			   AND    D.Operational = 1
		   </cfquery>
		   
		   <!--- new form to capture the results of the selected report(s) to be generated --->
		   	   	   	  	   
		   <cfif Document.recordcount gte "1">		   
		   	
				<table width="100%" align="right" border="0" cellspacing="0" cellpadding="0" bgcolor="ffffff">
		   				
		    	<tr>
			    	<td colspan="2">			

					 <cfoutput>
						<input name="Key1" id="Key1" type="hidden" value="#Object.ObjectKeyValue1#">
						<input name="Key2" id="Key2" type="hidden" value="#Object.ObjectKeyValue2#">
						<input name="Key3" id="Key3" type="hidden" value="#Object.ObjectKeyValue3#">
					    <input name="Key4" id="Key4" type="hidden" value="#Object.ObjectKeyValue4#">
					 </cfoutput>
					
					<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
								
					<TR>
					    <td width="186"></td>
					    <TD colspan="1">
						
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
										
							<table width="100%"
					       border="0"
					       cellspacing="0"
					       cellpadding="0"
					       align="center"
					       bordercolor="C0C0C0"
					       frame="hsides"
					       rules="rows">
						   
						    <tr><td colspan="3">
									
								<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
									  			
							    <cfset cls = "">		
								<cfoutput query="Format">
									      
								   <cfif CurrentDocument eq "">
								        <TR class="regular">
							       <cfelse>
								        <TR class="highlight2">
							       </cfif> 
								   <TD>&nbsp;#CurrentRow#.</TD>
							       <TD>#DocumentDescription#</TD>
								   <TD>#DocumentCode#</TD>
								   <TD>
							     	  <cfif CurrentDocument eq "">
								         <input type="checkbox" name="DocumentId" id="DocumentId" value="'#DocumentId#'" onClick="hl(this,this.checked)">
							    	  <cfelse>
								         <input type="checkbox" name="DocumentId" id="DocumentId" value="'#DocumentId#'" checked onClick="hl(this,this.checked)">
							           </cfif>
									</td>
									<td><cfif CurrentDocument neq "">Embedded by #firstName# #LastName#</cfif></td>
									<TD>#DateFormat(Created,CLIENT.DateFormatShow)#</TD>
									<td width="30">
									
									</td>
								    </TR>
								
							   </CFOUTPUT>
							     
							   </table>
					   
						   </td></tr>
						   
						   <cfif signature.recordcount gte "1">
						   
						   <tr bgcolor="f8f8f8">
							
								<td height="30" width="20%">&nbsp;&nbsp;Signature block:</td>
								<td colspan="2">
								<select name="SignatureBlock" id="SignatureBlock" size="1">
								<cfoutput query="Signature">
								    <option value="#code#" <cfif Format.SignatureBlock eq "#Code#">selected</cfif>>#Code# #BlockLine1#</option>
								</cfoutput>
								  </select>
							    </td>					
								
						   </TR>
						   
						   </cfif>
						   
						   						   
						   <tr><td height="5"></td></tr>
						   
						   <tr><td colspan="3" height="35" align="center">
								
								  <input type="submit" 
								     name="CustomDocument" 
									 id="CustomDocument"
									 value="Generate" 
									 onclick="saveforms()"
									 class="button10g">		 
								
								</td>
							</tr>
							
								
					   </table>
					   
					   </td></tr>
						 	   	
					</TABLE>
					
				</td>
				</tr>
				
				<tr><td height="3"></td></tr>	
				
				</table>
				
		   </cfif>	
		   
		</td>
		</tr>  	   
	   
	</cfform>
				
</cfif>					

