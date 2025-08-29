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
<table width="97%" height="100%">
<tr><td class="labelmedium2">
	
	<cfparam name="box"  default="1">
	<cfparam name="name" default="">
	<cfparam name="attributes.ajaxid" default="">
				
	<cfif Mode eq "Inquiry">
	
	        <cf_fileexist
				DocumentPath  = "#EntityCode#"
				SubDirectory  = "#ObjectId#" 				
				Filter        = "#DocumentCode#">	
				
				
		<cfif files eq "0">
		 
		 <cf_tl id="No attachments found">
		
		<cfelse>		
	
		<cf_filelibraryN
				DocumentPath  = "#EntityCode#"
				SubDirectory  = "#ObjectId#" 
				Mode          = "portal"
				Filter        = "#DocumentCode#"
				LoadScript    = "No"
				AttachDialog  = "Yes"
				Width         = "100%"
				Box           = "#Box#"
				rowheader     = "No"
				Memo          = "#name#"
				Insert        = "no"
				Remove        = "no">	
				
		  </cfif>		
	
	<cfelse>
	
		<cf_filelibraryN
				DocumentPath  = "#EntityCode#"
				SubDirectory  = "#ObjectId#" 
				Mode          = "portal"
				Filter        = "#DocumentCode#"
				LoadScript    = "No"
				AttachDialog  = "Yes"				
				Width         = "100%"
				Box           = "#Box#"
				Memo          = "#name#"
				Insert        = "yes"
				Remove        = "yes">	
			
	</cfif>	
		
</td></tr>
</table>
		