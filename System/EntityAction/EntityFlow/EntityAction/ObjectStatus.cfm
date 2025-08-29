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
<cfquery name="Detail" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT E.*
    FROM  Ref_EntityStatus E
	WHERE E.EntityCode = '#URL.EntityCode#'
</cfquery>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>
	
<cfform method="POST" name="objectstatus">

	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="right">
	 <tr><td height="4"></td></tr>   
	  <tr>
	    <td width="100%" class="regular">
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
			
	    <TR class="line labelmedium">
		   <td width="40" align="center">Code</td>
		   <td width="80%">Description</td>
		   <td width="6%" align="center">Active</td>
		   <td width="7%" align="right" colspan="2" style="padding-right:4px">
		     <cfoutput>
			 <cfif URL.ID2 neq "new">
			     <A href="javascript:ptoken.navigate('ObjectStatus.cfm?EntityCode=#URL.EntityCode#&ID2=new','ista')">[add]</a>
			 </cfif>			
			 </cfoutput>
		   </td>		   
	    </TR>	
							
		<cfoutput query="Detail">
						
		<cfset cd = EntityCode>
		<cfset nm = EntityStatus>
		<cfset de = StatusDescription>
		<cfset op = Operational>
		
		<cfset sel = url.id2>
														
		<cfif sel eq EntityStatus and len(sel) eq len(EntityStatus)>
						
		    <input type="hidden" name="EntityCode" id="EntityCode" value="#cd#">
												
			<TR class="navigation_row">
			   <td style="padding-left:3px" align="center" class="labelmedium">#nm#</td>
			   <td>
			   	   <cfinput type="Text" value="#de#" name="StatusDescription" message="You must enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
	           </td>
			    <td align="center"><input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>></td>
			   <td colspan="2" align="right" style="padding-right:4px">
			   <input type="button" style="height:18;width:60" value="Update" class="button10g" onclick="ptoken.navigate('ObjectStatusSubmit.cfm?EntityCode=#URL.EntityCode#&ID2=#url.id2#','ista','','','POST','objectstatus')">
			   </td>
		    </TR>	
					
		<cfelse>
		
			<TR class="navigation_row linedotted labelmedium">
			   <td align="center" height="17">#nm#</td>
			   <td>#de#</td>
			   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td width="15" align="right" style="padding-top:4px;padding-right:3px">
			   
			   	<cf_img icon="edit" navigation="Yes" onClick="javascript:ptoken.navigate('ObjectStatus.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','ista')">
			   
			   </td>
			   <td width="15" align="left" style="padding-top:4px">
			   
			   <cfquery name="Detail" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  OrganizationObject
					WHERE EntityCode  = '#EntityCode#'
					AND   EntityStatus = '#EntityStatus#'
					AND   Operational  = 1
			   </cfquery>
				   
			    <cfif Detail.recordcount eq "0">				
					<cf_img icon="delete" navigation="Yes" onClick="ptoken.navigate('ObjectStatusPurge.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','ista')">			   							
				</cfif>
				<a>
			  </td>
			   
		    </TR>
		
		</cfif>
				
		</cfoutput>
									
		<cfif URL.ID2 eq "new">
							
			<TR>
			<td style="height:30px;padding-left:20px">
			    <cfinput type="Text" value="" name="EntityStatus" style="text-align:center" message="You must enter a status code" required="Yes" size="1" maxlength="2" class="regularxl">
	        </td>
			
			<td width="70%">
			   <cfinput type="Text" name="StatusDescription" message="You must enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
			</td>
			
			<td align="center">
				<input class="radiol" type="checkbox" name="Operational" id="Operational" value="1" checked>
			</td>
								   
			<td colspan="2" align="right" style="padding-right:4px">
			<cfoutput>
			<input style="width:60px" type="button" 
			onclick="ptoken.navigate('ObjectStatusSubmit.cfm?EntityCode=#URL.EntityCode#&ID2=#url.id2#','ista','','','POST','objectstatus')"
			value="Add" class="Button10g">
			</cfoutput>
			</td>
			    
			</TR>	
											
		</cfif>	
					
		</table>
		
		</td>
		</tr>
						
	</table>	

</cfform>

<cfset ajaxonload("doHighlight")>