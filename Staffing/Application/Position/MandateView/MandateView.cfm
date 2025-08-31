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
<html>
<head>
<cfoutput>
<title><cf_tl id="Workforce Table"> #URL.Mission#</title> 
</head>

<cfparam name="URL.Mission" default="">

<cfif URL.Mission eq "">
  <cf_message message = "I am not able to identify the tree/mission. Please consult your administrator" return = "">
</cfif> 
	
<script>
   window.location = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
</script>	
	
</cfoutput>

</html>