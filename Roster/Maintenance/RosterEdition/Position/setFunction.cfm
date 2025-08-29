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
<cfparam name="url.functionno"        default="">
<cfparam name="url.submissionedition" default="">
<cfparam name="url.positionno"        default="0">

<cfquery name="setSelection"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SubmissionEditionPosition
		SET    FunctionNo = '#url.functionno#'
		WHERE  SubmissionEdition = '#url.submissionedition#'
		AND    PositionNo        = '#url.positionno#'			
</cfquery>

<cfquery name="getFunction"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   FunctionTitle
		WHERE  FunctionNo = '#url.functionno#'
</cfquery>
						
<cfoutput>
	<font color="0080C0">#getFunction.FunctionDescription#</font>
</cfoutput>						