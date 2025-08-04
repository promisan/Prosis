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

<table width="350" height="100%" border="0" class="formspacing" cellspacing="0" cellpadding="0"> 

<tr><td height="4"></td></tr>
<tr>

<cfset wd = "25">
<cfset ht = "25">
				
	<cf_menutab item       = "1" 
	            iconsrc    = "note1.gif" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				padding    = "0"
				type       = "Horizontal"
				name       = "New Note"
				source     = "javascript:noteentry('#url.objectid#','','','notes','','regular','notecontainerdetail')">

	<cf_menutab item       = "2" 
	            iconsrc    = "logos/system/email.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				padding    = "0"
				type       = "Horizontal"
				name       = "New Mail"
				source     = "javascript:noteentry('#url.objectid#','','','mail','','regular','notecontainerdetail')">

	<cf_menutab item       = "3" 
	            iconsrc    = "print.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				padding    = "0"
				type       = "Horizontal"
				name       = "Print"
				source     = "javascript:printme()">
			
		
<cfparam name="url.mode" default="regular">

</tr>

</table>
