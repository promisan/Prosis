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
<cfset url.ajaxid = Object.ObjectKeyValue1>

<cfoutput>

<cf_tl id="Identify candidates" var="1">

<table style="width:100%">
<tr><td style="padding:5px" align="center">

<input type="button" name="Identify" onclick="rostersearch('#Action.actioncode#','#Action.actionId#','urldetail1','#url.wParam#')" value="#lt_text#" class="button10g" style="height:30px;font-size:16px;width:360px"></td>
</tr>

<!--- refresh button --->

<tr class="hide">
<td id="workflowbutton_#url.ajaxid#" onclick="javascript:ptoken.navigate('#session.root#/Vactrack/Application/Document/DocumentCandidate.cfm?mode=step&ajaxid=#url.ajaxid#&wparam=#url.wparam#','urldetail1')"></td>
</tr>

<cfset url.mode = "step">

<tr><td id="urldetail1" style="width:100%"><cfinclude template="../../Document/DocumentCandidate.cfm"></td></tr>

<tr><td style="font-size:16px">		

						  
	    <cfinclude template="../../../../Tools/EntityAction/Report/DocumentAttach.cfm">			
		<cfset setattachment = "1"> 
		
		</td>
	</tr>	


</table>

</cfoutput>
