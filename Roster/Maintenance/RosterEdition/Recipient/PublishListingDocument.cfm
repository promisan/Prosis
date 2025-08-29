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
<cfquery name="get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_SubmissionEditionPublishMail
		WHERE  RecipientId= '#URL.RecipientId#' 
</cfquery>

<table width="94%" align="center">

<tr><td class="labellarge">Generated documents</td></tr>

<tr><td style="padding-left:20px;padding-right:20px">
	
	<cf_filelibraryN
		DocumentPath="Broadcast/#get.BroadcastId#"
		SubDirectory="#get.orgunit#" 
		Filter=""
		Presentation="all"
		Insert="no"
		Remove="no"
		width="100%"	
		Loadscript="no"				
		border="1">	
	
</td></tr>	
	
</table>	
		
