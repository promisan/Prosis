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
<cfparam name="Attributes.radius"   default="100">
<cfparam name="Attributes.color"   default="0.5">

<cfoutput>

	<cfset vCenter = Attributes.radius + 3>
	<cfset vSize = vCenter * 2>
	<iframe src="#SESSION.root#/Tools/jsGraphics/graphSphere/iGraphSphere.cfm?radius=#Attributes.radius#&color=#Attributes.color#&center=#vCenter#&size=#vSize#" 
		width="#vSize#" 
		height="#vSize#" 
		marginwidth="0" 
		marginheight="0" 
		frameborder="0" 
		AllowTransparency>
	</iframe>
</cfoutput>