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
<cf_param name="URL.ID"     		default=""  type="string">
<cf_param name="URL.applicantno"    default=""  type="string">

<head>

	<cf_LayoutScript>
	<cf_listingscript mode="Standard">			
	<cf_textAreaScript>
	<cf_PresentationScript>	
	<cf_FileLibraryScript mode="Standard">
		
	<script language="JavaScript">
	
	function memo(topic,row) {
		
		se   = document.getElementById(topic+row);
				
		if (se.className =="hide") {		   
			 se.className  = "regular";						 
			 } else {		   
		   	 se.className  = "hide";
		 }
	}
		 
	</script>	 
	
</head>		

<cfparam name="CLIENT.ApplicantNo" default="">
<cfparam name="url.ApplicantNo"    default="#CLIENT.ApplicantNo#">

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cfquery name="submission" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ApplicantSubmission A
	WHERE    ApplicantNo = '#url.applicantNo#'
</cfquery>

<cfset url.PersonNo = submission.PersonNo>
	 
<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
	   	position  = "top"
	   	name      = "phptop"
	   	minsize	  = "40px"
		maxsize	  = "40px"
		size 	  = "40px">	
		
		<table width="100%"><tr><td style="padding-top:8px">
		<cfinclude template="../PHPEntry/PHPIdentity.cfm">	
		</td></tr></table>
						 			  
	</cf_layoutarea>		
	
	<cf_layoutarea position="center" name="box">	
	
		<table width="100%" height="100%">
		
		<tr><td class="labelmedium" style="font-size:17px;padding-bottom:10px;padding-top:10px;padding-left:40px;padding-right:40px">
		<font color="258792">
		If you wish to exchange comments with respect to one of the below messages we sent, HIGHLIGHT the message and expand the RIGHT panel of this screen; You may send us comments and we will respond to you.</td></tr>
		<tr><td valign="top" style="padding:10px">
				
			<cf_securediv id="divListingContainer" style="height:100%" bind="url:#session.root#/Roster/PHP/Messaging/MessagingContent.cfm?applicantno=#url.applicantno#&id=#url.id#">        	

			
		</td>
		</tr>
		</table>	
	
	</cf_layoutarea>
	
	<cf_layoutarea size = "29%" 
	    style           = "border-left:1px solid ##d0d0d0;" 
		minsize         = "300px" 
		position        = "right" 
		name            = "right" 
		initcollapsed   = "Yes"
		collapsible     = "Yes">
			
		   <table height="100%" width="100%">
		       <tr class="hide"><td id="process"></td></tr>
			   <tr><td align="center" id="messaging" valign="top"></td></tr>
		   </table>					
					
	</cf_layoutarea>
			
</cf_layout>	

