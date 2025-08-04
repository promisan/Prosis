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

<div align="left" ID='textespan' style="position:relative;width:795;height:650; overflow: auto; scrollbar-face-color: F4f4f4;">
	<cfset url.format = "html">
	<cfinclude template="doPortalClone.cfm">
</div>

<div ID='clonePortal' style="display:none;">
	<cfset url.format = "text">
	<cfinclude template="doPortalClone.cfm">
</div>