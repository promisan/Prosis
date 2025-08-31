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
    SELECT   DISTINCT E.*
    FROM     Ref_EntityUsage E
	WHERE    E.EntityCode = '#URL.EntityCode#'
	ORDER BY Owner,ObjectUsageName
</cfquery>

<cfquery name="MyOwner" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_AuthorizationRoleOwner
</cfquery>

<cfif Detail.recordcount eq "0">
   <cfparam name="URL.ID2" default="new">
<cfelse>
   <cfparam name="URL.ID2" default="">   
</cfif>
		
<cfform action="ActionUsageSubmit.cfm?EntityCode=#URL.EntityCode#&ID2=#URL.ID2#" method="POST" name="action">

	<table width="98%" align="right">
	    
	  <tr>
	    <td width="100%">
		
	    <table width="100%" class="navigation_table formpadding">
			
	    <TR class="linedotted fixlengthlist labelmedium2">		   
		   <td><cf_tl id="Code"></td>
		   <td><cf_tl id="Owner"></td>
		   <td><cf_tl id="Description"></td>
		   <td style="width:30px" align="center">Op.</td>
		   <td style="width:30px"></td>
		   <td align="right" style="width:30px">
	         <cfoutput>
				 <cfif URL.ID2 neq "new">
				     <A href="javascript:ptoken.navigate('ActionUsage.cfm?EntityCode=#URL.EntityCode#&ID2=new','iuse')">[<cf_tl id="add">]</a>
				 </cfif>
			 </cfoutput>
		   </td>
		  
	    </TR>			
					
		<cfoutput query="Detail">
								
		<cfset cd = EntityCode>
		<cfset nm = ObjectUsage>
		<cfset ow = Owner>
		<cfset de = ObjectUsageName>
		<cfset op = Operational>
												
		<cfif URL.ID2 eq nm>
		
		    <input type="hidden" name="EntityCode" id="EntityCode" value="<cfoutput>#cd#</cfoutput>">
												
			<TR class="fixlengthlist">
			   
			   <td>#nm#</td>
			   <td>
			      <select name="Owner" id="Owner" class="regularxl" style="width:100%">
				   <option value="">All</option>
				   <cfloop query="MyOwner">
				   <option value="#Code#" <cfif ow eq "#Code#">selected</cfif>>#Code#</option>
				   </cfloop>
			   </select>					   
			   </td>
			   <td style="padding-left:2px"><cfinput type="Text" value="#de#" name="ObjectUsageName" message="You must enter a description" required="Yes" size="50" maxlength="50" class="regularxl"></td>
			 
			    <td align="center">
			      <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>>
				</td>
				
			    <td colspan="2" align="right" style="padding-left:5px;padding-right:4px"><input type="submit" value="Update" style="width:80" class="button10g"></td>
		    </TR>	
					
		<cfelse>
		
			<cfset edit = "javascript:ptoken.navigate('ActionUsage.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','iuse')">
					
			<TR class="navigation_row linedotted fixlengthlist">
			    
			    <td>#nm#</td>
				<td>#ow#</td>
			    <td>#de#</td>
				<td align="right"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
			    <td align="right">
				   <cf_img icon="edit" navigation="Yes" onclick="#edit#">			   
			    </td>
			    <td align="right" style="padding-right:3px">
			   
				   <cfquery name="Detail" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_EntityDocument
					WHERE EntityCode  = '#EntityCode#'
					AND   ObjectUsage = '#ObjectUsage#'
					AND   Operational  = 1
				   </cfquery>
					   
				    <cfif Detail.recordcount eq "0">					
						<cf_img icon="delete" navigation="Yes" onclick="ptoken.navigate('ActionUsagePurge.cfm?EntityCode=#URL.EntityCode#&ID2=#nm#','iuse')">					  
					</cfif>
					
			  </td>
			   
		    </TR>	
					
		</cfif>
				
		</cfoutput>
									
		<cfif URL.ID2 eq "new">
				
			<TR>
			
				<td height="25" style="padding-right:3px">
				    <cfinput type="Text" value="" name="ObjectUsage" message="You must enter a code" required="Yes" size="20" maxlength="20" class="regularxl">
		        </td>
						
				<td>
				  <select name="Owner" id="Owner" class="regularxl" style="width:100%">
					   <option value="">All</option>
					   <cfoutput query="MyOwner">
					   <option value="#Code#">#Code#</option>
					   </cfoutput>
				   </select>		
				</td>			
				
				<td style="padding-left:3px">
				   <cfinput type="Text" name="ObjectUsageName" message="You must enter a description" required="Yes" size="50" maxlength="50" class="regularxl">
				</td>			
				
				<td align="center">
				   <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked>
				</td>
									   
				<td colspan="2" align="right" style="padding-left:5px;padding-right:4px">
				    <input type="submit" value="Add" style="width:50px" class="button10g">
				</td>
			    
			</TR>	
		
		</cfif>	
					
		</table>
		</td>
		</tr>
									
	</table>
	
</cfform>	

<cfset ajaxonload("doHighlight")>	


