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

<cfparam name="url.documentNo"   default="">
<cfparam name="url.actioncode"   default="">
<cfparam name="url.personno"     default="">
<cfparam name="url.mode"         default="View">
<cfparam name="url.modality"     default="Test">
<cfparam name="url.mid"          default="">

<cfoutput>
<cfif url.mode eq "edit">
<!--- this modality is only to record received test answers --->
<iframe src="#session.root#/Vactrack/Application/Candidate/Interaction/AssessmentTest.cfm?documentno=#url.documentno#&personno=#url.personno#&actioncode=#url.actioncode#&mode=#url.mode#&modality=#url.modality#&mid=#url.mid#" width="100%" height="100%" marginwidth="5" marginheight="5" frameborder="0"></iframe>
<cfelse>
<iframe src="#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewContent.cfm?documentno=#url.documentno#&personno=#url.personno#&actioncode=#url.actioncode#&mode=#url.mode#&modality=#url.modality#&mid=#url.mid#" width="100%" height="100%" marginwidth="5" marginheight="5" frameborder="0"></iframe>
</cfif>
</cfoutput>



