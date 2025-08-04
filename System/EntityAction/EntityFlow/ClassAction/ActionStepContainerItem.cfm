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

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>  

<cfoutput>
	<iframe src="#SESSION.root#/system/entityAction/EntityFlow/ClassAction/ActionStepEdit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#URL.ActionCode#&PublishNo=#URL.PublishNo#&mid=#mid#" 
	width="100%" height="840" scrolling="no" frameborder="0">
	</iframe>
</cfoutput>

