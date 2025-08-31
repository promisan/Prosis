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
<cfparam name="openmode"           default="close">
<cfparam name="client.stafftoggle" default="#openmode#">
<cfparam name="url.scope"          default="backoffice">

<cfif client.stafftoggle eq "">
	
	<cfif openmode eq "close">	
		<cfset cl  = "hide">
		<cfset cla = "regular">		
	<cfelse>	
		<cfset cl  = "regular">
		<cfset cla = "hide">	
	</cfif>
	
<cfelse>

	<cfset openmode = client.stafftoggle>
	
	<cfif openmode eq "close">	
		<cfset cl  = "hide">
		<cfset cla = "regular">		
	<cfelse>	
		<cfset cl  = "regular">
		<cfset cla = "hide">	
	</cfif>

</cfif>	

<cfoutput>	

	<!--- table height="100%" fixes an issue in Chrome but messes up this screen in the backoffice (profile), unless we adjust the container in that BO screeen--->	
	
	<cfif url.scope eq "backoffice">
		<cfset bg = "##f1f1f1">
		<cfset vSize = 20>		
		<cfset vBackground = "background: ##f1f1f1;">
	<cfelse>
		<cfset bg="##f5f5f5">
		<cfset vSize = 15>
		<cfset vBackground = "background: ##ededed;">		
	</cfif>
	
	<table border="0" style="width:100%;background:##f1f1f1; border-radius: 0 0 10px 10px;padding-bottom: 2px;">		

		
	<tr class="hide"><td id="toggleprocess"></td></tr></tr>
	
	<tr class="fixrow">
		
		<td id="personinfo" class="#cl#">	
				
		    <cfinclude template="../../../Staffing/Application/Employee/PersonViewHeader.cfm">
			
             <div onclick="personviewtoggle('person')" class="clsNoPrint"
                style="padding-left:20px;cursor: pointer;display: block;margin: 0 auto 3px;height: 100%">
				<!---
				<cf_tl id="Hide"> 
				--->
				<img src="#Client.VirtualDir#/images/Up3.png" width="20" height="20" 
			    id="personcol"
				style="cursor: pointer;padding: 2px;margin:0;position: relative;top: 3px;"
				class="#cl#">
			</div>
			
		</td>
		
		<td id="personshort" class="#cla#" onclick="personviewtoggle('person')" 
		  style="height:35px;cursor:pointer;padding:0 0 0 20px!important;">		
		  						    			  
		   <font style="color:##033F5D;font-size:19px;text-transform: uppercase; width: auto;"><cfoutput>#Employee.FirstName# #Employee.LastName# <cfif Employee.indexno neq "">(#Employee.IndexNo#)</cfif></cfoutput></font>
            
            <img src="#Client.VirtualDir#/Images/Down3.png" width="24" height="24"  		    
			id="personexp"					
			align="absmiddle"
			style="cursor: pointer;padding-right: 14px;float: right;margin: 0 5px 3px;"
            class="#cla#">
			
		</td>
	</tr>	
		
	
	<tr><td height="3"></td></tr>	
	
	</table>

</cfoutput>	