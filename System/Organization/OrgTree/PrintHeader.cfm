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
<cfparam name="url.missionName" default="">
<cfparam name="url.label" 		default="">

<cfoutput>
	<div style="background-color:##005B9A; color:##FAFAFA; border-bottom:3px solid ##606060; padding:15px; margin-bottom:10px;">
		<div class="pull-left" style="padding-right:15px;">
			<img src="logo.png" style="height:50px">
		</div>
		<div>
			<span style="font-size:140%;">#url.missionName#</span>
			<br>
			<span class="clsPrintHeaderSubtitle">#url.label#</span>
		</div>
		<div style="float:right; margin-top:-42px; padding-right:10px;">
			<i class="fa fa-users" style="font-size:45px;"></i>
		</div>
	</div>
</cfoutput>