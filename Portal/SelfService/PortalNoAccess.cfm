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

<!--- deny access to portal --->

<table width="100%" align="center" height="100%" bgcolor="white">
<tr><td align="center" height="120">
<font face="Verdana" size="3" color="black">
<cfoutput>
	You do not have access to this #SESSION.welcome# Portal function. <br><br> Please contact your administrator.
    <cfset SESSION.authent = "0">
	<cfset vLogOut = StructClear(SESSION)>	
</cfoutput>	
</font>
</td></tr>
<tr><td height="50%"></td></tr>
</table>