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
<cfprogressbar 
	name="DSSProgressBar"
	autodisplay=false
	bind="cfc:service.process.workorder.routing.getProgressData()"
 	style="bgcolor:white;progresscolor:green;margin:auto;position:absolute;top:0;left:0;bottom:0;right:0;width: 10%;height: 2%;"
 	onComplete="hideProgressBar">		