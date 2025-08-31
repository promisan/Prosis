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
<cfoutput>

<cfparam name="URL.Search" default="">
	
<cfsavecontent variable="header">
	
	<table cellspacing="0" width="100%">
	
	<tr style="border-top:1px solid silver">
	
	 	 <cfset ht = "48">
		 <cfset wd = "48">
  
		  <cf_menutab item  = "1" 
		      iconsrc    = "Logos/System/Activity.png" 
			  iconwidth  = "#wd#" 
			  iconheight = "#ht#" 
			  targetitem = "1"
			  class      = "highlight"
			  name       = "User Activity"
			  source     = "#SESSION.root#/System/Access/User/Audit/UserOnLine.cfm?id=#url.id#">		
			  
		  <cf_menutab item  = "2" 
		      iconsrc    = "Logos/System/Sent-Mail.png" 
			  iconwidth  = "#wd#" 
			  iconheight = "#ht#" 
			  iframe     = "logbox"
			  targetitem = "2"
			  name       = "Mail Sent"
			  source     = "iframe:#SESSION.root#/System/Access/User/Audit/ListingMail.cfm?id=#url.id#">		
			  
		  <cf_menutab item = "3" 
		      iconsrc    = "Logos/System/Reports.png" 
			  iconwidth  = "#wd#" 
			  iconheight = "#ht#" 
			  targetitem = "2"
			  iframe     = "logbox"
			  name       = "Reports Generated"
			  source     = "iframe:#SESSION.root#/System/Access/User/Audit/ListingReport.cfm?id=#url.id#">					  		  	
			  
		  <cf_menutab item = "4" 
		      iconsrc    = "Logos/System/Errors.png" 
			  iconwidth  = "#wd#" 
			  iconheight = "#ht#" 
			  targetitem = "2"
			  iframe     = "logbox"
			  name       = "System Errors"
			  source     = "iframe:#SESSION.root#/System/Access/User/Audit/ListingError.cfm?id=#url.id#">				
		
		<td style="width:20%"></td>
		</tr>
		
	</table>
	
</cfsavecontent>	

<table width="100%" height="99%" align="center">
	
<tr>

    <td valign="top" colspan="7">
	
		<table width="98%" height="100%" align="center">		
			<tr><td height="28">#header#</td></tr>
			<tr><td height="1" class="line"></td></tr>	
			<tr><td height="100%">
			    				
				<table width="100%" height="100%">	
				
				 <cf_menucontainer item="1" class="regular"> 					 		
				 	<cfset init = "1">		
					<cfinclude template="UserOnLine.cfm">
					<!--- <cf_securediv bind="url:#SESSION.root#/System/Access/User/Audit/UserOnLine.cfm?id=#url.id#">	--->						  		
				 </cf_menucontainer>
				 				 
				 <cf_menucontainer item="2" class="hide" iframe="logbox">
				
				 </table>
				
			 </td>
			 </tr>
		</table>
	
	</td>
</tr>

</table>

</cfoutput>
