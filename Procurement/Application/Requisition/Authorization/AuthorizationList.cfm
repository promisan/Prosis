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

<cfquery name="User" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT  DISTINCT F.*, E.*
	FROM    RequisitionLineAuthorization F, System.dbo.UserNames E
	WHERE   F.RequisitionNo  =  '#url.RequisitionNo#'
	AND     F.UserAccount    =  E.Account
 	AND     F.Role           = '#URL.Role#'
	 
</cfquery>
	
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">			
  
   <cfif User.recordcount eq "0">
   
   <tr>
    <td colspan="6" align="center" style="height:20px" class="labelit"><font color="red"><cf_tl id="No records to show in this view"></td>
   </tr>
  
   <cfelse>
   
    <tr class="labelmedium">
	   <td width="2%"></td>       
	   <TD width="30%" height="15">Name</TD>
	   <td width="10%" height="15"><cf_tl id="IndexNo"> </td>
	   <TD width="5%"  height="15">S</TD>
	   <TD width="10%" height="15">Account</TD>
	   <!---
	   <td width="20%" width="20%" class="labelit" height="15">Role</td>  
	   --->
	   <td></td>   
   </TR>
   			   
   <cfoutput query="User">
   
   <tr><td colspan="7" class="linedotted"></td></tr>
   <tr class="navigation_row labelmedium">
   	  <td height="20" style="padding-left;2px">#currentrow#.</td>      
	  <td>#FirstName# #LastName#</td>
	  <td>#IndexNo#</td>
	  <td>#Gender#</td>
	  <td>#Account#</td>
	  <!---
	  <td class="labelit">#Role#</td>
	  --->
	  <td align="right" style="padding-right:10px">
	    <cfif url.mode eq "edit">
	    <cf_img icon="delete" navigation="Yes" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/Procurement/application/Requisition/Authorization/AuthorizationAccess.cfm?action=delete&Requisitionno=#URL.Requisitionno#&Role=#url.role#&Account=#UserAccount#','#url.role#')">		
		</cfif>
	  </td>
   </tr> 
     	  
    </CFOUTPUT>   
	
	</cfif>
   
</table>

<cfset AjaxOnLoad("doHighlight")>	   