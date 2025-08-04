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

<cfparam name="url.scope" default="portal">

<cfif url.scope neq "website">

	<cfinclude template="ApplyScript.cfm">
	
	<cf_LoginTop FunctionName = "PHP" Graphic="No">
	
	<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr><td valign="top" height="40">		
			<cfinclude template="../PHP/PHPBanner.cfm">	
	</td></tr>
		
	<tr><td>
	
		<cfinclude template="ApplyBucket.cfm">
	 
	</td></tr>
	
	</table>
	
	<cf_LoginBottom FunctionName = "PHP" Graphic="No">

<cfelse>

    <!--- -------------------------------------------- --->
    <!--- script needs to be loaded from source screen --->
	<!--- -------------------------------------------- --->

	<!---
	<cf_screentop height="100%" title="My Application Agent" html="Yes" scroll="Yes" layout="innerbox">
	--->

	<table width="100%" cellspacing="0" cellpadding="0">
	
	<!---
	<tr><td height="5"></td></tr>
	
	<tr><td align="center" height="30" class="top4n">
	<input type="button" name="Close" value="Close" class="button10g" onclick="window.close()">
	</td></tr>
	
	<tr><td height="1" bgcolor="gray"></td></tr>
	
	--->
	
	<tr><td height="8"></td></tr>
	<tr><td valign="top" height="20">		
		<cfinclude template="../PHP/PHPIdentity.cfm">	
	</td></tr>
	
	<tr><td>
		<cfinclude template="ApplyBucket.cfm">
	</td></tr>
	
	</table>
	
	<!---
	<cf_screenbottom layout="Innerbox">
	--->

</cfif>



