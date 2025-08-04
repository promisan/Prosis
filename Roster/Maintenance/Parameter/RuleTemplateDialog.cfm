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

<cfparam name="url.openas" default="edit">

<cf_screentop label="Edit #path#" height="100%" scroll="No" layout="webapp">
	
	<cfoutput>

		<iframe src="#SESSION.root#/Tools/Document/FileContent.cfm?openas=#url.openas#&mode=edit&path=#SESSION.rootpath#\#path#&subdir=&name="
		  width="100%" height="100%" frameborder="0">
	    </iframe>
	
	</cfoutput>

<cf_screenbottom layout="webapp">
