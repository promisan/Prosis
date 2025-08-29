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
	<proOwn>Dev van Pelt</proOwn>
	<proDes>The changes are done so that If URL mode is empty set to empty as a param statement JG since this screen always expects a mode  </proDes>
	<proCom></proCom>
	<proCM></proCM>
	<proInfo>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	This template is used to load the ajax enabled attachment method of the framework for additional expenses. 
	</td></tr>
	</table>
	</proInfo>

</cfsilent>

<table width="94%" height="100%" cellspacing="0" cellpadding="0"><tr><td>

<link href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">
<cfparam name="URL.Mode" default="">
<!---
<cfif URL.Mode eq "Inquiry">
--->

<cfif claim.actionstatus gte "2" and editclaim eq "0">

	<cf_filelibraryN
			DocumentPath="TravelClaim"
			SubDirectory="Attachment/#URL.ClaimId#" 
			Filter=""
			Box="att"
			rowheader="No"
			Insert="no"
			Remove="no"
			reload="true">	

<cfelse>

	<cf_filelibraryN
			DocumentPath="TravelClaim"
			SubDirectory="Attachment/#URL.ClaimId#" 
			Filter=""
			Box="att"
			Insert="yes"
			Remove="yes"
			reload="true">	
		
</cfif>		
</td></tr></table>