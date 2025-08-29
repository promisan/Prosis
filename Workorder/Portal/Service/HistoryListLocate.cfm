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

<cfif URL.Mode eq "Shipped">

	<cfform method="POST" name="formfilter" onsubmit="return false">
	
	<table width="100%" cellspacing="0" cellpadding="3">
		
	<tr><td height="2"></td></tr>
				
		<TR>
		
		<TD>Reference:</TD>
		<TD>	
		<input type="text" name="Reference" class="regular" value="" size="20">
		</TD>
	
		<TD>Requested&nbsp;between:</TD>
		<TD width="120">	
		<cf_space spaces="35">
		 <cf_intelliCalendarDate8
			FieldName="datestart" 
			Default=""
			Class="regular"
			AllowBlank="True">	
			
		</TD>
		
		<TD>and:</TD>
		<TD width="110">
		<cf_space spaces="35">
		<cf_intelliCalendarDate8
			FieldName="dateend" 
			Default=""
			Class="regular"
			AllowBlank="True">				
		</TD>
		<td>
		<button
	       name="go"
	       value="Filter"
	       class="button3"
	       style="height:20;width:26"
	       onClick="reqstatusfilter('#url.mode#')">
		   <img src="<cfoutput>#SESSION.Root#</cfoutput>/images/go1.gif" alt="" border="0">
		</button>
		
				
		</td>
		<td width="40%"></td>
		</tr>
		<tr><td height="1" bgcolor="silver" colspan="8"></td></tr>
		
	</table>	
	
	</cfform>

</cfif>

</cfoutput>