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
<cfquery name="Object" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Object
		WHERE    Code = '#URL.ObjectCode#'		
	</cfquery>

<cfquery name="Type" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ObjectFundType
		WHERE    Code = '#URL.ObjectCode#'		
</cfquery>
	
<cfif action eq "Display">
		
	<table cellspacing="0" cellpadding="0">
		<tr>
		<td height="15" style="padding-left:30px"></td>
		<cfoutput query="Type">
		<cfif CodeDisplay neq "">
		<td class="labelit">#FundType#:</td><td>#CodeDisplay#</td><td>&nbsp;</td>
		</cfif>
		</cfoutput>
		<td class="labelit"><cfoutput>#Object.Description#</cfoutput></td>
		</tr>
	</table>	

<cfelse>

	<cfoutput>
	 <table cellspacing="0" cellpadding="0">
		 <tr>
			 <td height="15" style="padding-left:30px"></td>
			 <td><cf_space spaces="10" class="labelit" padding="0" label="#Object.CodeDisplay#"></td>
			 <td><cf_space spaces="70" class="labelit" padding="0" label="#Object.Description#"></td>
			 </tr>					
	 </table>
	 </cfoutput>

</cfif>
