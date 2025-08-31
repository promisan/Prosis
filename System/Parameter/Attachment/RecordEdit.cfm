<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.idmenu" default="">

<script language="JavaScript">

function change_multiple (m) {

    se = document.getElementsByName('bMultiple')   
    cnt = 0

	if (m == 1)	{	
			
		while (se[cnt]) {
		  se[cnt].className = "regular"
		  cnt++
		}			   	
		
	} else {
				
		while (se[cnt]) {
		  se[cnt].className = "hide"
		  cnt++
		}				   
      	
	}
	
	}
	
function showTechDetails(value){
	s = document.getElementById('rdetails');
	if (value>8){
		s.className = 'show';
	}else{
		s.className = 'hide';
	}
}

</script>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray" 
			  label="Attachment Configuration" 			
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfparam name="URL.ID1" default="">

<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Attachment
	where  DocumentPathName = '#URL.ID1#'
	
</cfquery>

<cfoutput query="List">

	<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">
								
		<input type="hidden" name="DocumentPathName" id="DocumentPathName" value="<cfoutput>#DocumentPathName#</cfoutput>">
	
		<table width="95%" align="center" class="formpadding formspacing" cellspacing="0" cellpadding="0">
	
				 <tr><td height="4"></td></tr>
		
				 <TR class="labelmedium2">
					 <TD width="25%">Document path:&nbsp;</TD>  
					 <td>
					 	<cfinput type = "Text" 
					   	value        = "#DocumentFileServerRoot#" 
						name         = "DocumentFileServerRoot" 
						required     = "No" 
						size         = "40" 
						maxlength    = "80" 
						class        = "regularxxl">	#DocumentPathName#\<br>
					 </td>
				</tr>
				 
				<tr class="labelmedium2">
					 <td>System module:&nbsp;</td>  
					 <td>
					 	<cfquery name="Module" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT SystemModule
							FROM  Ref_SystemModule
						</cfquery>
						<select class="regularxxl" name="SystemModule" id="SystemModule">
							<option value=""></option>
					 	<cfloop query="Module">
							<option value="#SystemModule#" <cfif SystemModule eq List.SystemModule>selected</cfif>> #SystemModule# </option>
						</cfloop>
						</select>
					 </td>
				</tr>
	
				<tr class="labelmedium2">
				 
					 <td>Xythos server:</td>  
					 <td>
					 	<cfinput type = "Text" 
					   	value        = "#DocumentServer#" 
						name         = "DocumentServer" 
						required     = "No" 
						size         = "15" 
						maxlength    = "80" 
						class        = "regularxxl">	
						
					 </td>
				</tr>
				
				<tr class="labelmedium2">
				 
					 <td>Login:</td>  
					 <td>
					 
					    <table><tr class="labelmedium2"><td>
					 	
						<cfinput type = "Text" 
					   	value        = "#DocumentServerLogin#" 
						name         = "DocumentServerLogin" 
						required     = "No" 
						size         = "20" 
						maxlength    = "80" 
						class        = "regularxxl">	
						
						</td>
						
						<td style="padding-left:5px;padding-right:5px">Password:</td>
						
						<td>
						<cfinput type = "Password" 
					   	value        = "#DocumentServerPassword#" 
						name         = "DocumentServerPassword" 
						required     = "No" 
						size         = "15" 
						maxlength    = "80" 
						class        = "regularxxl">	
						
						</td></tr></table>
					 </td>
				</tr>
				 
				<tr class="labelmedium2">
					 <td>Attach multiple:&nbsp;</td>  
					 <td>
					 	<select name="attachmultiple" id="attachmultiple" class="regularxxl" onChange = "javascript:change_multiple(this.value)">
							 <option value="1" <cfif attachmultiple eq 1>selected</cfif>>Enabled</option>
							 <option value="0" <cfif attachmultiple eq 0>selected</cfif>>Disabled</option>
						</select>
					 </td>
				</tr>
				 
				<cfif attachmultiple eq 0>
				 	<cfset vClass="hide">
				<cfelse>	
					<cfset vclass="labelmedium2">
				</cfif>				 
				 
				<tr class="#vClass#" name="bMultiple"> 
					 <td height="25" colspan="2">Attach <b>Multiple</b> Files settings:&nbsp;</td>  
				</tr>	 
				
				<tr class="#vClass#" name="bMultiple">
					<td align="right" width="25%" style="padding-left:2px">Number of files:</td>
					<td align="left">
					 	<select name="AttachMultipleFiles" id="AttachMultipleFiles" class="regularxxl">
							<cfloop index="vSelected" from="1" to="20" step="1">
							 <option value="#vSelected#" <cfif AttachMultipleFiles eq vSelected>selected</cfif>>#vSelected#</option>
							</cfloop> 
						</select>						
					</td>
				</tr>			
					
				<tr class="#vClass#" name="bMultiple">
					<td class="labelit" align="right" width="25%">
						Size per file (MB) : 
					</td>
					<td align="left" >
					 	<select name="AttachMultipleSize" id="AttachMultipleSize" class="regularxxl" onChange="javascript:showTechDetails(this.value);">
						<cfloop index="vSize" from="1" to="25" step="1">
						 <option value="#vSize#" <cfif AttachMultipleSize eq vSize>selected</cfif>>#vSize#</option>
						</cfloop> 
						</select>	
					</td>
				</tr>
				
				<tr>
					<td></td>
					<td class="labelit">
						<a href="http://www.promisan.net/wiki/index.php?title=Big_Files_in_PROSIS_under_IIS" target="_blank" >
							<font color="0080C0">[How to Configure IIS File Size - Click here]</font>
						</a>
					</td>
				</tr>
				
				<tr class="#vClass#" name="bMultiple">
					<td class="labelit" align="right" width="25%">File Extension Filter:				
					</td>
					<td align="left">
					
					<cfinput type = "Text" 
					   	value        = "#AttachExtensionFilter#" 
						name         = "AttachExtensionFilter" 
						required     = "No" 
						size         = "40" 
						maxlength    = "60" 
						class        = "regularxxl">	
					 						
					</td>
				</tr>			
						 
				<tr class="labelmedium2">
					 <td>Logging:&nbsp;</td>  
					 <td>
					 	<select name="attachlogging" id="attachlogging" class="regularxxl">
							 <option value="1" <cfif attachlogging eq 1>selected</cfif>>Enabled</option>
							 <option value="0" <cfif attachlogging eq 0>selected</cfif>>Disabled</option>
						</select>
					 </td>
				</tr>
				 
				<tr class="labelmedium2">
					 <td>Open Mode:&nbsp;</td>  
					 <td>
					 	<select name="attachmodeopen" class="regularxxl">
							 <option value="0" <cfif attachModeOpen eq 0>selected</cfif>>Secure copy</option>
							 <option value="1" <cfif attachModeOpen eq 1>selected</cfif>>Streaming</option>
						</select>
					 </td>
				</tr>
				 
				<tr class="labelmedium2">
					 <td>Memo:&nbsp;</td>  
					 <td>
					 	<cfinput type = "Text" 
					   	value        = "#Memo#" 
						name         = "Memo" 
						required     = "No" 
						size         = "50" 
						maxlength    = "80" 
						class        = "regularxxl">	
					 </td>
				</tr>
				 			
				<tr><td colspan="2" class="line"></td></tr>
					
				<tr>	
					<td align="center" colspan="2">
						<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
						<input class="button10g" type="submit" name="Update" id="Update" value="Update">
					</td>
				</tr>
				
		</table>		
				
	</cfform>
			
</cfoutput>