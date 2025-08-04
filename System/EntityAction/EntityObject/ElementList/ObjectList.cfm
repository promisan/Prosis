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
<cf_screentop height="100%" html="No" jquery="Yes">

<cfoutput>
<script>
	function saveList(id,id2) {
	    document.getElementById('formlist').onsubmit()				
		if (_CF_error_messages.length == 0) {
			_cf_loadingtexthtml='';	
			ptoken.navigate('../../EntityObject/ElementList/ObjectListSubmit.cfm?DocumentId=' + id + '&id2=' + id2, 'lresult', '', '', 'POST', 'formlist')
		}	
	}	
</script>
</cfoutput>

<cfajaximport tags = "cfform">

<cfquery name="List" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_EntityDocumentItem
	WHERE DocumentId = '#URL.DocumentId#'
	ORDER BY ListingOrder
</cfquery>

<cfquery name="Last" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Max(ListingOrder)+1 as Last
    FROM   Ref_EntityDocumentItem
	WHERE  DocumentId = '#URL.DocumentId#'	
</cfquery>

<cfif List.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>

<cfset cnt = 0>

<div id="lresult" height="100"></div>

<cfform name="formlist" id="formlist">

	<table width="100%" align="center">
	 
	 	<tr>
	
	    <td width="100%">
	    <table width="100%" class="navigation_table">
				
	    <TR class="labelmedium line" height="18">
		   <td style="padding-left:4px;width:40px"><cf_tl id="Code"></td>
		   <td width="80%"><cf_tl id="Description"></td>
		   <td style="min-width:40px;text-align:center"><cf_tl id="Sort"></td>
		   <td style="min-width:40px" align="center"><cf_tl id="Active"></td>
		   <td colspan="2" align="right" style="min-width:40px">
	       <cfoutput>
			 <cfif URL.ID2 neq "new">
			     <A href="#ajaxLink('../../EntityObject/ElementList/ObjectList.cfm?DocumentId=#URL.DocumentId#&ID2=new')#">
				 [add]</a>
			 </cfif>
			 </cfoutput>&nbsp;
		   </td>		  
	    </TR>
							
		<cfoutput>
		
		<cfloop query="List">
					
			<cfset nm = DocumentItem>
			<cfset de = DocumentItemName>
			<cfset ls = ListingOrder>
			<cfset op = Operational>
																					
			<cfif URL.ID2 eq nm>		
											
			    <input type="hidden" name="DocumentItem" id="DocumentItem" value="<cfoutput>#nm#</cfoutput>">
													
				<TR style="height:30px;padding-left:4px" class="labelmedium2 line navigation_row">
				   <td style="padding-left:4px">#nm#</td>
				   <td>
				   	   <cfinput type="Text" 
					   	value="#de#" 
						name="DocumentItemName" 
						message="You must enter a description" 
						required="Yes" 
						size="80" 
						style="width:99%"
						maxlength="200" 
						class="regularxxl">
				  
		           </td>
				   <td>
				   	<cfinput type="Text"
					       name="ListingOrder"
						   style="text-align:center"
					       value="#ls#"
					       validate="integer"
					       required="Yes"
						   message="Please enter an order value" 
					       visible="Yes"
					       enabled="Yes"
					       typeahead="No"
					       size="1"
					       maxlength="2"
					       class="regularxxl">
				   			   
				     </td>
				  
				   <td align="center">
				      <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>>
					</td>
					
				   <td colspan="2">
				 
				   <input type	= "button"
						onclick = "javascript:saveList('#URL.DocumentId#','#url.id2#')" 
				        value	= "Save" 
						class	= "button10g" 
						style	= "width:50px;height:25px">
					</td>
			    </TR>	
				
				<cfset cnt = cnt + 30>			
															
			<cfelse>
							
				<cfquery name="Field" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT top 1 *
				    FROM  OrganizationObjectInformation
					WHERE DocumentId = '#URL.DocumentId#'
					AND   DocumentItem = '#DocumentItem#'
				</cfquery>	
				
				<cfquery name="Mail" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT top 1 *
				    FROM  OrganizationObjectActionMail
					WHERE DocumentId   = '#URL.DocumentId#'
					AND   DocumentItem = '#DocumentItem#'
				</cfquery>	
						
				<TR class="labelmedium2 line navigation_row" bgcolor="fcfcfc">
				   <td height="15" style="padding-left:4px">#nm#</td>
				   <td>#de#</td>
				   <td style="text-align:center">#ls#</td>
				   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
				   <td align="right" width="20" style="padding-top:2px">				   
				      	<cf_img icon="edit" onclick="javascript:_cf_loadingtexthtml='';ptoken.location('../../EntityObject/ElementList/ObjectList.cfm?DocumentId=#URL.DocumentId#&ID2=#nm#')">				   					   
				   </td>
				   <td style="padding-left:1px;padding-top:3px">
				       <cfif Field.recordcount eq "0" and Mail.recordcount eq "0">					      		
							<cf_img icon="delete" onclick="javascript:_cf_loadingtexthtml='';ptoken.location('../../EntityObject/ElementList/ObjectListPurge.cfm?DocumentId=#URL.DocumentId#&ID2=#nm#')">					   
					   </cfif>
				    </td>
				 </TR>	
										
			</cfif>
			
			<cfset cnt = cnt + 26>	
						
		</cfloop>
		</cfoutput>
													
		<cfif URL.ID2 eq "new">		
					
			<TR>
			<td height="30">
				    <cfinput type="Text" 
				         value="" 
						 name="DocumentItem" 
						 message="You must enter a code" 
						 required="Yes" 
						 size="2" 
						 maxlength="20" 
						 class="regularxxl">
	        </td>
						   
			    <td>
				   	<cfinput type="Text" 
				         name="DocumentItemName" 
						 message="You must enter a name" 
						 required="Yes" 
						 size="80" 
						 style="width:99%"
						 maxlength="200" 
						 class="regularxxl">
				</td>								 
				<td>
				   <cfinput type="Text" 
				      name="ListingOrder" 
					  message="You must enter an order" 
					  required="Yes" 
					  size="1" 
					  style="text-align:center"
					  value="#last.Last#"
					  validate="integer"
					  maxlength="2" 
					  class="regularxxl">
				</td>
			
			<td align="center">
				<input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked>
			</td>
								   
			<td colspan="2">
				<cfoutput>
			    	<input type="button"
						onclick = "javascript:saveList('#URL.DocumentId#','new')" 
						value="Add" 
						class="button10g" 
						style="width:50px;height:25px">
				</cfoutput>
									
			</td>			    
			</TR>	
		
			<cfset cnt = cnt + 40>						
											
		</cfif>								
		</table>		
		</td>
		</tr>	
								
	</table>	
</cfform>				

<cfoutput>
<script language="JavaScript">
	
	frm  = parent.document.getElementById("frm_#URL.documentid#");
	he = #cnt+25#;
	frm.height = he
	
</script>
</cfoutput>

<cfset ajaxonload("doHighlight")>