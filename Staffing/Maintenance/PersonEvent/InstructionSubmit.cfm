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
<cfparam name="Form.SubmissionMode" default="1">
<cfparam name="Form.OrgUnitMode" default="0">

<cfset color = mid(form.MenuColor,2,7)>
 
<cfquery name="setMission" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE Ref_PersonEventMission
		SET    Instruction    = '#form.instruction#',
		       MenuColor      = '#color#',
			   MenuImagePath  = '#form.MenuImagePath#',
			   ReasonMode     = '#Form.ReasonMode#',
			   SubmissionMode = '#Form.SubmissionMode#',
			   OrgUnitMode    = '#Form.OrgUnitMode#'
		WHERE  PersonEvent    = '#url.Code#'
		AND    Mission        = '#url.mission#' 
</cfquery>	

<script>
	parent.ProsisUI.closeWindow('instruction')
</script>

