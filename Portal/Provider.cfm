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
<cfoutput>

<table width="100%" height="100%">

<tr>
	<td colspan="2" height="97%" align="center">
	<div style="margin-top:-87%;">
	<img src="#session.root#/#parameter.AppLogoPath#/#Parameter.AppLogoFileName#" width="65%" />
	</div>
	</td>
</tr>



<tr><td colspan="2" class="linedotted"></td></tr>
<tr>						
	<td align="left" class="label" style="padding-left:8px">
		 <font color="FFFFFF">cf:#Server.Coldfusion.ProductVersion#</font>
	</td>
	
	<td align="right" class="label" style="padding-right:8px">
		  
	    <font color="FFFFFF">#clientbrowser.name# #clientbrowser.release# <cfif clientbrowser.pass eq 0><b>NOT supported</b></cfif></font>
			
	</td>

</tr>

</table>

</cfoutput>