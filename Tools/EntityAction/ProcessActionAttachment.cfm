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

<table width="100%" height="100%" align="center" class="formpadding">
<tr><td>
		
	<cfparam name="box" default="1">
	<cfset color = "ffffff">
	<cfparam name="script" default="yes">
		
	<cfif Mode eq "Inquiry">
	
		<cfif SESSION.isAdministrator eq "Yes"  or session.acc eq Object.OfficerUserid>
			 <cfset md = "yes">
		<cfelse>
			 <cfset md = "no"> 
		</cfif>
	
		<cf_filelibraryN
				DocumentPath = "#EntityCode#"
				SubDirectory = "#ActionId#" 
				Filter       = ""		
				Color        = "#color#"		
				Width        = "100%"
				Box          = "reg#Box#"
				AttachDialog = "Yes"
				LoadScript   = "#script#"
				rowheader    = "No"
				Insert       = "#md#"
				Remove       = "#md#">	
	
	<cfelse>
	
		<cf_filelibraryN
				DocumentPath  = "#EntityCode#"
				SubDirectory  = "#ActionId#" 
				Filter        = ""			
				Color        = "#color#"		
				Width         = "100%"
				AttachDialog  = "Yes"
				LoadScript    = "#script#"
				Box           = "reg#Box#"
				Insert        = "yes"
				Remove        = "yes">	
			
	</cfif>	
		
</td></tr>
</table>
		