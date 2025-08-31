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
<cfparam name = "url.submissionedition" default="">
<cfparam name = "url.rowguid" default="">

<cfquery name="GetEdition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  	SELECT   *
	FROM     Ref_SubmissionEdition
    WHERE    SubmissionEdition = '#url.submissionedition#'			  
</cfquery>

<!---
<cfif GetEdition.EntityClass eq "">
--->

	<tr> 
    <TD colspan="4" style="padding-left:10px;padding-right:10px">

	 <cf_filelibraryN
			DocumentPath="Submission"
			SubDirectory="#url.rowguid#" 			
			Insert="yes"
			Filter=""	
			LoadScript="No"
			Box="submission"
			Remove="yes"
			ShowSize="yes">
			
     </TD>
    </TR>	
	
<!---			
</cfif>
--->	