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
<cfquery name="GetTask" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			
			SELECT *
			FROM   RequestTask
			WHERE  TaskId = '#url.taskid#'
					 
</cfquery>

<cfoutput>

<cfform>


<table style="background-color:white;" height="100%" width="100%" align="center">
<tr><td id="split_result" valign="top" style="padding-top:10px">

<table style="background-color:white;" height="100%" width="100%" align="center">
		
	<tr>
		<td colspan="2" class="labellarge" style="padding-left:10px;">  
			Split #GetTask.TaskQuantity# into:
		</td>
	</tr>
	
	<tr> <td colspan="2" class="linedotted"></td> </tr>
	
	<tr >
		<td class="labelit" style="padding-left:20px">
			Quantity 1: 
		</td>
		<td>
			<cfinput class="regularxl" style="width:100" type="text" id="quantity1" name="quantity1" value="">
		</td>
	</tr>
	
	<tr>
		<td class="labelit" style="padding-left:20px">
			Quantity 2:
		</td>
		<td>
			<cfinput type="text" style="width:100" class="regularxl" id="quantity2" name="quantity2" value="">
		</td>
	</tr>
	
	<tr>
		<td colspan="2" align="center" id="result">
			<cf_button mode="silver" width="80" name="Split" id="Split" value="Split" 
			onclick="splitTask('#GetTask.TaskId#',#GetTask.TaskQuantity#)">
		</td>
	</tr>
	
</table>

</cfform>

</cfoutput>

</td></tr>
</table>