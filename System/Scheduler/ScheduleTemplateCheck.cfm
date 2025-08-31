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
<cfif not FileExists("#SESSION.rootPath#\#url.file#")>

	<b><font color="#FF0000">
	You entered an invalid schedule template path/file name
	</b>
	</font>
	
	<script>
		document.getElementById("update").className = "hide"
	</script>

<cfelse>

	<b><font color="green">
	You entered a valid schedule template path/file name
	</b>
	</font>

	<script>
		document.getElementById("update").className = "button10g"
	</script>
	
</cfif>