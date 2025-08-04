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

<cfparam name="url.mode" default="regular">

<cfoutput>

	<cfif URL.mode eq "Shipped">
		
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		<cfform method="POST" name="formfilter" onsubmit="return false">		
					
			<TR height="30">
			
			<TD style="padding-left:10px"><cf_tl id="Reference">:</TD>
			<TD>	
			<input type="text" name="Reference" id="Reference" value="" size="20">
			</TD>
		
			<TD style="padding-left:10px"><cf_tl id="Requested during">:</TD>
			<TD width="120" style="z-index:10; position:relative;padding:0px">	
			
			<cf_space spaces="35">
			
			 <cf_intelliCalendarDate8
				FieldName="datestart" 
				Default=""
				Class="regularh"
				AllowBlank="True">	
				
			</TD>
			
			<TD><cf_tl id="and">:&nbsp;</TD>
			<TD width="110" style="z-index:10; position:relative;padding:0px">
			
			<cf_space spaces="35">
			
			<cf_intelliCalendarDate8
				FieldName="dateend" 
				Default=""
				Class="regularh"
				AllowBlank="True">				
				
			</TD>
			
			<td>
			
			
			<button name="go" id="go"
		       value="Filter"
		       class="button3"
		       style="height:20;width:26"
		       onClick="reqstatusfilter('#url.mode#')">
			   <img src="<cfoutput>#SESSION.root#</cfoutput>/images/go1.gif" alt="" border="0">
			</button>
							
			</td>
			<td width="40%"></td>
			</tr>
			<tr><td height="1" bgcolor="silver" colspan="8"></td></tr>
		</cfform>	
		</table>	
		
	<cfelse>
	
		<cf_compression>	
	
	</cfif>
	
</cfoutput>