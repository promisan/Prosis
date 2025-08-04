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

<cf_screentop html="No" jquery="Yes">
<cfajaximport>

<cfparam name="CLIENT.ApplicantNo" default="">
<cfparam name="url.ApplicantNo"    default="#CLIENT.ApplicantNo#">

<cf_listingscript>
<cf_textAreaScript>	
<cf_PresentationScript>
<cf_FileLibraryScript>
<cf_LayoutScript>
<cf_DialogStaffing>

<table width="100%" height="100%">
<tr><td style="width:100%;height:100%">

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
	 
<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
	   	position  = "top"
	   	name      = "phptop"
	   	minsize	  = "30px"
		maxsize	  = "30px"
		size 	  = "30px">	
		
	<table width="100%" height="100%">
	<tr class="line"><td style="padding-left:15px;background-color:f1f1f1;padding-top:5px;padding:2px;font-size:30px" class="labellarge">
		<cfoutput>Exchange Messages with #url.owner# candidates </cfoutput>
	</td>
	</tr>
	</table>	
						 			  
	</cf_layoutarea>		
	
	<cf_layoutarea position="center" name="box">	
	
	<table width="100%" height="100%">
	<tr><td valign="top" style="padding:5px">
	    
		<cfset url.systemfunctionid = url.idmenu>
		
		<cfinclude template="MessagingListing.cfm">	
		
	</td>
	</tr>
	</table>	
	
	</cf_layoutarea>
	
	<cf_layoutarea size="29%" 
	    style= "border-left:1px solid ##d0d0d0;" 
		minsize = "300px" 
		position="right" 
		name="right" 
		collapsible="Yes">
			
		<table height="100%" width="100%"><tr><td align="center" id="messaging" valign="top"></td></tr></table>					
					
	</cf_layoutarea>
			
</cf_layout>	

</td></tr></table>

