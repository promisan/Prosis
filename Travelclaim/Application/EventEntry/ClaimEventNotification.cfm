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
<cfsilent>
 <proUsr>administrator</proUsr>
�<proOwn>Dev van Pelt</proOwn>
 <proDes>Annotated Template</proDes>
 <proCom></proCom>
 <proCM></proCM>
</cfsilent>


<body leftmargin="5" topmargin="0" rightmargin="0" bottommargin="0">

<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0" bordercolor="#e4e4e4" bgcolor="FFFFFF" frame="hsides">

	<tr><td height="6"></td></tr>
	
	<tr><td>
		<cfinclude template="ClaimPreparation.cfm">
	</td></tr>
			
	<tr>
		<td >
		<table cellspacing="0" cellpadding="0"><tr>
		<td width="25"><cfoutput><img src="#SESSION.root#/Images/join.gif" alt="" border="0"></cfoutput></td>					
		<td height="24"><b><font face="Verdana" size="2"><b>Introduction to the Portal</b></td>
		</tr>
		</table></td>
	</tr>
	<tr><td height="1" bgcolor="C0C0C0"></td></tr>
	
	<tr><td valign="top" height="100%">
	
		<!--- load help file in embedded in template, 
		as opposed to dialog --->
	
		 <cf_helpfile 	
		 	code = "TravelClaim" 
			id   = "info"
			name = "Introduction to the Portal"
			display = "embed">
					
		</td></tr>
		
			
	<cfif claim.actionStatus lte "1" and editclaim eq "1">
	
	<tr><td height="1" colspan="4" valign="bottom" bgcolor="C0C0C0"></td></tr>
			
	<tr><td valign="bottom" height="30">
		
		<cfif Object.recordcount eq "0" and Claim.ExportNo is "">
		
		    <!--- allow a reset = restart or home only if the claim has NOT been  
			exported nor has already been part of a workflow = submitted before --->
			
		    <cfset reset = "1">			
		<cfelse>
	    	<cfset reset = "0">		
		</cfif>
		
		<!--- refer to Tools/Process/Navigation/Navigation.cfm for a more complete explanation of the below custom tag --->
	  
	    <cf_Navigation
		 Alias         = "AppsTravelClaim"
		 Object        = "Claim"
		 Group         = "TravelClaim" 
		 Section       = "#URL.Section#"
		 Id            = "#URL.ClaimId#"
		 ButtonClass   = "ButtonNav1"
		 SetNext       = "1" <!--- automatically set the section as completed upon loading of this page --->
		 BackEnable    = "0"
		 HomeEnable    = "#reset#"
		 ResetEnable   = "#reset#"
		 ProcessEnable = "0"
		 NextEnable    = "1"
		 NextMode      = "1"> <!--- allow user to indeed click on the next option, otherwise next button will give a message --->
				 	
	 </td></tr>	 
		 
	 </cfif>	
	 	
	</table>	 
	
  