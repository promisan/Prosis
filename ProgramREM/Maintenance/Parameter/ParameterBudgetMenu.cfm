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
<cfparam name="url.selected" default="1">

<table width="95%" align="center">
	<tr>
	
	<td>
			
	<table width="100%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">		  		
					
		<cfset ht = "64">
		<cfset wd = "64">
				
		<tr>		
		
				<cfset cl = "regular">
				<cfif url.selected eq 1>				
					<cfset cl = "highlight">
				</cfif>			
					
				<cf_menutab base       = "budget" 
							item       = "1" 
				            iconsrc    = "Logos/System/Maintain.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							class      = "#cl#"
							target     = "boxbudget"
							targetitem = "1"
							name       = "Settings">	
							
				<cfset cl = "regular">
				<cfif url.selected eq 2>
					<cfset cl = "highlight1">
				</cfif>			
								
				<cf_menutab base       = "budget" 
							item       = "2" 
				            iconsrc    = "Ceiling.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							class      = "#cl#"
							target     = "boxbudget"
							targetitem = "2"								
							name       = "Ceiling">
							
				<cfset cl = "regular">
				<cfif url.selected eq 3>
					<cfset cl = "highlight1">
				</cfif>	
							
				<cf_menutab base       = "budget" 
							item       = "3" 
				            iconsrc    = "Portal.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 	
							class      = "#cl#"
							target     = "boxbudget"
							targetitem = "3"							
							name       = "Portal">
												
				<td width="20%"></td>
													 		
			</tr>
	</table>
	
	</td>
	</tr>
	
	<tr><td class="line"></td></tr>		
	
	<tr><td height="100%">
		
		<table width="100%" 
		      border="0"
			  height="100%"
			  cellspacing="0" 
			  cellpadding="0" 
			  align="center" 
		      bordercolor="d4d4d4">	
			  
			  	<cfset cl = "hide">
				<cfif url.selected eq 1>
					<cfset cl = "regular">
				</cfif>  	 		
							
				<cf_menucontainer name="boxbudget" item="1" class="#cl#">
				     <cfinclude template="ParameterEditAllotment.cfm">		
				<cf_menucontainer>
				
				<cfset cl = "hide">
				<cfif url.selected eq 2>
					<cfset cl = "regular">
				</cfif>
				
				<cf_menucontainer name="boxbudget" item="2" class="#cl#">
				     <cfinclude template="ParameterEditCeiling.cfm">		
				<cf_menucontainer>
				
				<cfset cl = "hide">
				<cfif url.selected eq 3>
					<cfset cl = "regular">
				</cfif>
				
				<cf_menucontainer name="boxbudget" item="3" class="#cl#">
				     <cfinclude template="ParameterEditPortal.cfm">		
				<cf_menucontainer>
							
		</table>
		</td>
</tr>

</table>