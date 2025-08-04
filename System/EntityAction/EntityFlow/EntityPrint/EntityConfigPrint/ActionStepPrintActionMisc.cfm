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
<cfoutput>

<table width="97%" align="center" cellspacing="0" cellpadding="0">
	<tr><td height="6"></td></tr>
    <TR>
	<TD width="30%">&nbsp;Lead-time:</b></TD>
	<TD>
	#GetAction.ActionLeadtime# days
	</TD>
	</TR>
				
	<TR>
	<TD>&nbsp;Color of the completed step (Box):</b></TD>
	<TD>
	#GetAction.ActionCompletedColor# 	   
	</TD>
	</TR>
				
	<TR>
	<TD>&nbsp;Show Reference:</b></TD>
	<TD>
	<cfif #GetAction.ActionReferenceShow# eq "1">Yes<cfelse>No</cfif>
	</td>
	<TR>				
</table>
		
</cfoutput>		
	