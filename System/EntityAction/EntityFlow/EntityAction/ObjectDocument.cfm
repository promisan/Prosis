<HTML><HEAD>
<TITLE>Fields</TITLE>
</HEAD><body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfset cnt = 0>

<script language="JavaScript">

function template(file) {  
 	window.open("../EntityAction/TemplateDialog.cfm?path="+file, "Template", "left=40, top=40, width=860, height= 732, toolbar=no, status=yes, scrollbars=yes, resizable=yes");
}
</script>

<cfquery name="Entity" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Entity
	WHERE EntityCode = '#URL.EntityCode#'
</cfquery>

<cfquery name="Detail" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT E.*, R.DocumentId as Used
    FROM   Ref_EntityDocument E LEFT OUTER JOIN Ref_EntityActionDocument R ON E.DocumentId = R.DocumentId
	WHERE  E.EntityCode   = '#URL.EntityCode#'
	AND    E.DocumentType = '#URL.Type#'
</cfquery>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>
	
<cfform action="ObjectDocumentSubmit.cfm?EntityCode=#URL.EntityCode#&ID2=#URL.ID2#&type=#URL.type#" method="POST" enablecab="Yes" name="action">

	<div style="position:absolute;top:0; overflow: auto; width:100%; height:100%; scrollbar-face-color: F4f4f4; clip: auto;">

	<table width="100%" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" align="center"  class="formpadding">
	
	    <td width="100%">
	    <table width="100%" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" rules="rows">
			
	    <TR bgcolor="f6f6f6" height="18">
		   <td width="30">&nbsp;Code&nbsp;
				   
		   </td>
		   <cfif url.type neq "Attach"> 
		   <td width="18%">Name</td>
		   <cfelse>
		   <td width="60%">Name</td>
		   </cfif>
		   <td width="8%">Mode</td>
		   <cfif url.type neq "Attach"> 
		   <td width="44%">Template <b>root/</b></td>
		   </cfif>
		   <td width="30" align="center">Active</td>
		   <td colspan= "2" align="right">
	       <cfoutput>
			 <cfif URL.ID2 neq "new">
			     <A href="ObjectDocument.cfm?EntityCode=#URL.EntityCode#&ID2=new&type=#URL.type#">[add]</a>
			 </cfif>
			 </cfoutput>&nbsp;
		   </td>
		  
	    </TR>	
		
		<cfset cnt = cnt + 20>
	
		<cfoutput>
		<cfloop query="Detail">
		
		<tr><td height="1" colspan="7" bgcolor="e4e4e4"></td></tr>
		
		<cfset nm = DocumentCode>
		<cfset de = DocumentDescription>
		<cfset ps = DocumentPassword>
		<cfset op = Operational>
		<cfset md = DocumentMode>
																	
		<cfif URL.ID2 eq nm>
		
			<cfset cnt = cnt + 26>
		
		    <input type="hidden" name="ActionCode" id="ActionCode" value="<cfoutput>#nm#</cfoutput>">
												
			<TR bgcolor="ffffdf">
			   <td>&nbsp;#nm#</td>
			   <td>
			   <cfif url.type eq "Attach"> 
			   	   <cfinput type="Text" value="#de#" name="DocumentDescription" message="You must enter a document description" required="Yes" size="60" maxlength="80" class="regular">
			   <cfelse>
			   	   <cfinput type="Text" value="#de#" name="DocumentDescription" message="You must enter a document description" required="Yes" size="20" maxlength="80" class="regular">
			   </cfif>   
	           </td>
			   <td height="25">
			   
			   <cfif URL.type eq "dialog">
			      <select name="DocumentMode" id="DocumentMode">
				   <option value="Embed" <cfif #md# eq "Embed">selected</cfif>>Embed</option>
				   <option value="Popup" <cfif #md# eq "Popup">selected</cfif>>Popup</option>
				  </select>
				<cfelseif URL.type eq "mail"> 
				 <select name="DocumentMode" id="DocumentMode">
				   <option value="AsIs" <cfif #md# eq "AsIs">selected</cfif>>AsIs</option>
				   <option value="Edit" <cfif #md# eq "Edit">selected</cfif>>Edit</option>
				  </select> 
				<cfelseif URL.type eq "attach"> 
				 <select name="DocumentMode" id="DocumentMode">
				   <option value="Header" <cfif #md# eq "Header">selected</cfif>>Header</option>
				   <option value="Step" <cfif #md# eq "Step">selected</cfif>>Step</option>
				  </select>   
			    <cfelse>
					<input type="hidden" name="DocumentMode" id="DocumentMode" value="Embed">
					Embed
				</cfif>  
			     </td>
			   <cfif url.type neq "Attach">   
			   <td>
			      <cfinput type="Text" value="#documenttemplate#" name="DocumentTemplate" message="You must enter a template" required="Yes" size="60" maxlength="80" class="regular">
	           </td>
			   </cfif>
			   <td align="center">
			      <input type="checkbox" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>>
				</td>
			   <td colspan="2" rowspan="2" align="right">
			   <input type="submit" value="Save" class="button10s" style="width:50">&nbsp;</td>
		    </TR>	
			
			<cfif url.type neq "Attach">
			
			<cfset cnt = cnt + 26>
			
			<tr bgcolor="ffffdf">
			    <td></td>
				
				<td colspan="3" align="right">
					<table width="100%" cellspacing="0" cellpadding="0">
						<tr>
						<td class="labelit" style="padding-left:4px;padding-right:4px">Passtru (?WParam=) :</td>
						<td colspan="1"><cfinput type="Text" class="regularxl" value="#documentstringList#" name="DocumentStringList" required="No" size="60" maxlength="80"></td>
						
						<cfif URL.type eq "report">
						<td class="labelit" style="padding-left:4px;padding-right:4px">Password:</td>
						<td>
							<cfinput type="Text" name="DocumentPassword" value="#ps#" required="No" size="10" maxlength="20" class="regularxl">
						</td>
						<cfelseif URL.type eq "dialog">
						<td class="labelit" style="padding-left:4px;padding-right:4px">Log Content:</td>
						<td>
						    <input type="checkbox" 
							       name="LogActionContent" 
								   id="LogActionContent" class="radiol"
								   value="1" 
								   <cfif "1" eq LogActionContent>checked</cfif>>
						</td>
						</cfif>
						</td>
						</tr>
					</table>
				</td>
				<td></td>
				
			</tr>
			
			</cfif>
					
		<cfelse>
		
			<cfset cnt = cnt + 26>
	
			<TR>
			    <td height="20">&nbsp;#nm#</td>
			   <td>#de#</td>
			   <td>#md#</td>
			   <cfif url.type neq "Attach">  
				   <td>
				   <cfif not FileExists("#SESSION.rootpath#/#DocumentTemplate#") and left("#DocumentTemplate#","11") neq "javascript:">
				     	 <font color="FF0000"><b>Error: #documenttemplate#</b>
				   <cfelse> 	
				       <cfset ln = #replace(documenttemplate,"\","\\","ALL")#>		 
				         <a href="javascript:template('#ln#')">#documenttemplate#</a>
				       </cfif> 	 
				   </td>
				</cfif>
				<td align="center"><cfif #op# eq "0"><b>No</b><cfelse>Yes</cfif></td>
				<td align="center">
				   <A href="ObjectDocument.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#&Type=#URL.Type#">[edit]</a>&nbsp;
				</td>
			   	<td align="right">
			       <cfif Used eq "">
			 	       <A href="ObjectDocumentPurge.cfm?EntityCode=#URL.EntityCode#&ID2=#DocumentId#&Type=#URL.Type#">
					   <img src="#SESSION.root#/images/trash2.gif" alt="delete" width="14" height="16" border="0" align="absmiddle">
					   </a>
				   </cfif>
			    </td>
			 </TR>	
		
		</cfif>
						
		</cfloop>
		</cfoutput>
									
		<cfif URL.ID2 eq "new">
		
			<cfset cnt = cnt + 24>
			
			<tr><td height="1" colspan="7" bgcolor="e4e4e4"></td></tr>
					
			<TR bgcolor="ffffdf">
			<td height="24">&nbsp;
			    <cfinput type="Text" value="" name="DocumentCode" message="You must enter a code" required="Yes" size="2" maxlength="20" class="regular">
	        </td>
			
			   <cfif url.type neq "Attach"> 
			    <td>
			   	<cfinput type="Text" name="DocumentDescription" message="You must enter a name" required="Yes" size="20" maxlength="80" class="regular">
				</td>
			   <cfelse>
			    <td width="60%">
			   	<cfinput type="Text" name="DocumentDescription" message="You must enter a name" required="Yes" size="70" maxlength="80" class="regular">
				</td>
			   </cfif>
			
			 <td>
			 
			    <cfif URL.type eq "dialog">
			      <select name="DocumentMode" id="DocumentMode">
				   <option value="Embed" selected>Embed</option>
				   <option value="Popup">Popup</option>
				  </select>
				<cfelseif URL.type eq "mail"> 
				 <select name="DocumentMode" id="DocumentMode">
				   <option value="AsIs" selected>AsIs</option>
				   <option value="Edit">Edit</option>
				  </select>   
				<cfelseif URL.type eq "attach"> 
				 <select name="DocumentMode" id="DocumentMode">
				   <option value="Header" selected>Header</option>
				   <option value="Step">Step</option>
				  </select>    
				<cfelse>
					<input type="hidden" name="DocumentMode" id="DocumentMode" value="Embed">
					Embed
				</cfif>   
			     
		       </td>
			<cfif url.type neq "Attach">  
			 
			<td>
			   <cfinput type="Text" name="DocumentTemplate" message="You must enter a template path" required="Yes" size="60" maxlength="80" class="regular">
			</td>
			</cfif>
			<td align="center">
				<input type="checkbox" name="Operational" id="Operational" value="1" checked>
			</td>
								   
			<td colspan="2" rowspan="2" align="right">
			<input type="submit" value="Add" class="button10s" style="width:50"> &nbsp;</td>			    
			</TR>	
			
			<cfif url.type neq "Attach">  
				<cfset cnt = cnt + 26>
				<tr bgcolor="ffffdf">
				    <td></td>
				
				<td colspan="3" align="right">
						<table width="100%" cellspacing="0" cellpadding="0">
							<tr>
							<td class="labelit" style="padding-left:4px;padding-right:4px">Passtru (?WParam=) :</td>
							<td colspan="1"><cfinput type="Text" value="" name="DocumentStringList" required="No" size="60" maxlength="80" class="regularxl"></td>
							
							<cfif URL.type eq "report">
								<td class="labelit" style="padding-left:4px;padding-right:4px">Password:</td>
								<td><cfinput type="Text" name="DocumentPassword" required="No" size="10" maxlength="20" class="regularxl"></td>
							<cfelseif URL.type eq "dialog">
							<td class="labelit" style="padding-left:4px;padding-right:4px">Log Content:</td>
							<td>
							    <input type="checkbox" 
								       name="LogActionContent" 
									   id="LogActionContent" class="radiol" 
									   value="1" checked>
							</td>
							</cfif>
							</td>
							</tr>
						</table>
				</td>
				<td></td>				
				</tr>	
			
			</cfif>
											
		</cfif>	
					
		</table>
		
		</td>
		</tr>
					
	</table>	
	
	</div>
		
</cfform>
		
<cfoutput>
	<script language="JavaScript">
	{
	frm  = parent.document.getElementById("i#url.type#");
	frm.height = #cnt+10#
	}
	
</script>
</cfoutput>

</BODY></HTML>