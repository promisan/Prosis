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
<cf_menuscript>
<cfajaximport tags="cfdiv,cfform">

<table width="95%"
	   height="100%"
	   align="center"
	   cellspacing="0"
       cellpadding="0">

	<tr>
		<td align="center" valign="top">
		
			<table width="100%" align="center">
				<tr>
				<cfset wd = "28">
				<cfset ht = "28">
				
				<cf_menutab item  = "1" 
			       iconsrc    = "Logos/Warehouse/ItemInfo.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   class      = "highlight1"
				   name       = "Logon Validation">
				   
				 <cf_menutab item  = "2" 
			       iconsrc    = "Logos/Warehouse/pricing.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   name       = "Claim Submission">
				   
				 <cf_menutab item  = "3" 
			       iconsrc    = "Logos/CaseFile/vis_Theme.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   name       = "Fund IMIS">
				   
			  	<cf_menutab item  = "4" 
			       iconsrc    = "Logos/Warehouse/Monitor.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   name       = "Application Settings">
				   
				   <td width="10%"></td>
				 </tr>
			 </table>
		
		<td>
	</tr>
	<tr><td class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<tr>
	<td height="100%" valign="top">
	   <table width="100%" height="100%" cellspacing="0" cellpadding="0">
		<cf_menucontainer item="1" class="regular">
			 <cfinclude template="ParameterLogon.cfm"> 
	 	<cf_menucontainer>	
		<cf_menucontainer item="2" class="hide">
			 <cfinclude template="ParameterSubmission.cfm"> 
	 	<cf_menucontainer>	
		<cf_menucontainer item="3" class="hide">
			 <cfinclude template="ParameterFundStatus.cfm"> 
	 	<cf_menucontainer>	
		<cf_menucontainer item="4" class="hide">
			 <cfinclude template="ParameterSystem.cfm"> 
	 	<cf_menucontainer>	
	   </table>	
	</td>
	</tr>
	<tr><td height="1"></td></tr>
</table>
