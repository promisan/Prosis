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
<cfparam name="URL.PositionNo" default="0">
<cfparam name="URL.PublishMode" default="">
<cfparam name="URL.SubmissionEdition" default="">

<cfquery name="setSelection"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SubmissionEditionPosition
		SET    PublishMode = '#PublishMode#'
		WHERE  SubmissionEdition = '#url.SubmissionEdition#'
		AND    PositionNo        = '#url.Positionno#'			
</cfquery>
