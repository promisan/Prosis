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
<cfparam name="url.warehouse" default="">
<cfparam name="url.location" default="">
<cfparam name="url.mode"   default="issue">

<cfoutput>
	
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" align="center">		
							
		<TR id="submitbox9" class="cchide"> 	
			<td style="height:90;padding:5px" class="labelmedium" align="center">
				
				<img src="#session.root#/images/Scanner.jpg" alt="" width="180" height="180" border="0">
				
				<font color="0080C0">Obtained transactions from scanner/device will be shown here and will be updated the moment the transaction occurs (Blue tooth)								
					
			</td>
		</tr>
				
	</table>
				
</cfoutput>

