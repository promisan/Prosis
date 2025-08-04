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


<table width="100%" border="0" cellspacing="2" cellpadding="2">

<tr><td colspan="2" style="padding-top:6px" class="labellarge"><b>Exact Delivery Location:</td></tr>
<tr>

<td valign="top" class="label" style="padding-left:6px;padding-right:5px">
<br>
In the screen you may verify the location of the delivery. 
<br><br>
If you note a discrepancy just click on the exact position of the delivery and a red incon will appear then click <i>[set the FORM coordinate of MAP center]</i>. 
<br><br>
So we know where we need to deliver exatly and will be able to serve you better.
 
</td>

<td width="650px" align="right" style="padding-right:15px">

	
	 <cfif client.googlemap eq "1">
													
			<cf_mapshow scope="embed" width="650" height="420">				
						
	<cfelse>
					
			<cfset maplink = "">
						
	</cfif>
				
</td></tr>

<tr><td colspan="2" class="line"></td></tr>
<tr><td colspan="2" style="padding-left:4px" class="labelit">Kuntz Delivery Planner 2012</td></tr>

</table>				