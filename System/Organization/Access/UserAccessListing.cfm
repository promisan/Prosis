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
<cf_param name="URL.id" 	default="" type="String">
<cf_param name="URL.Search" default="" type="String">

<cfquery name="Clear" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM OrganizationAuthorization
	WHERE UserAccount = '#URL.ID#'
	AND OrgUnit is not NULL
	AND OrgUnit NOT IN (SELECT OrgUnit 
	                    FROM   Organization)
</cfquery>

<cfquery name="Clear" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM OrganizationAuthorization
	WHERE  UserAccount = '#URL.ID#'
	AND    ClassParameter NOT IN (SELECT ActionCode 
	                              FROM   Ref_EntityAction)
	AND    ClassIsAction = 1
</cfquery>

<!--- ------------ --->
<!--- tab contents --->
<!--- ------------ --->

<cfoutput>

<cfparam name="URL.Search" default="">

<table width="100%" height="100%" border="0" cellspacing="0" align="center" class="formpadding">
	
<cfinvoke component="Service.Access"  
		method="UserAdmin" 
		returnvariable="access">		  	

	<cfsavecontent variable="client.header">
		
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		 <cfset ht = "64">
		 <cfset wd = "64">
  
		  <cf_menutab item  = "1" 
		      iconsrc    = "Logos/System/Global.png" 
			  iconwidth  = "#wd#" 
			  iconheight = "#ht#" 
			  targetitem = "1"
			  class      = "highlight"
			  name       = "Global and Tree Level"
			  source     = "#SESSION.root#/System/Organization/Access/UserAccessListingGlobal.cfm?id=#url.id#&search=#url.search#">		
			  
		  <cf_menutab item  = "2" 
		      iconsrc    = "Logos/System/Tree.png" 
			  iconwidth  = "#wd#" 
			  iconheight = "#ht#" 
			  targetitem = "1"
			  name       = "Tree and Unit Level"
			  source     = "#SESSION.root#/System/Organization/Access/UserAccessListingTree.cfm?id=#url.id#&search=#url.search#">		
		
		  <cfif access eq "ALL">	  
		  
			  <cf_menutab item = "3" 
			      iconsrc    = "Access-Granted.png" 
				  iconwidth  = "#wd#" 
				  iconheight = "#ht#" 
				  targetitem = "1"
				  name       = "Access Granted"
				  source     = "#SESSION.root#/System/Organization/Access/UserAccessListingGranted.cfm?id=#url.id#">					  		  	
				  
			  <cf_menutab item = "4" 
			      iconsrc    = "Access-Clear.png" 
				  iconwidth  = "#wd#" 
				  iconheight = "#ht#" 
				  targetitem = "1"
				  name       = "Clear Access"
				  source      = "#SESSION.root#/System/Organization/Access/UserAccessListingPending.cfm?id=#url.id#&search=#url.search#">		
				  
		   </cfif>	  		
		
		</tr>
		</table>
		
	</cfsavecontent>	
	
	<tr id="log">
	
	    <td width="100%" height="100%" valign="top" colspan="7">
				
			<table width="98%" height="100%" align="center">	
			<tr><td height="1" class="line"></td></tr>	
			<tr><td width="100%" height="28">#client.header#</td></tr>
			<tr><td height="1" style="border-top:1px solid silver"></td></tr>	
			<tr><td>
				<table width="100%" height="100%">
				<tr>
				<td width="100%" height="100%" style="padding-bottom:10px">
	
		   	    <cf_divscroll id="contentbox" style="height:80%;width:100%">			   		  
				<table width="100%" height="100%">				
				   <cf_menucontainer item="1" class="regular">  
				     	<cfinclude template="UserAccessListingGlobal.cfm">		   
				   </cf_menucontainer>		   
			    </table>		   		  
			    </cf_divscroll> 		
				
				</td>
			   
			    </tr>
			   </td>  
			   
			   </table>
			   
			  </td></tr> 	  
									
			</table>	
		
		</td>
	</tr>

</table>
	
</cfoutput>

