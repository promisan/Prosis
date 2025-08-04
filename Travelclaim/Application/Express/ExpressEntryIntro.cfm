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
<cfsilent>
 	<proOwn>Huda Seid</proOwn>
	<proDes>Changed the expression on line 13. Just made grammatical changes as per gloria's request </proDes>
	<proCom> As of 15/01/08</proCom>
</cfsilent>
<cfset bullet = "select5.gif">
	
<cfoutput>

	<table width="100%">
	
	<tr><td>	
	
	 <cf_helpfile 	
				 	code = "TravelClaim" 
					id   = "info"
					name = "Introduction to the Portal"
					display = "embed">
					
		</td>			
	</tr>	
		
	<tr id="choice">
		<td colspan="2" align="center" bgcolor="FFFFFF">
		
		<tr><td colspan="3" align="center">
		
			<table cellspacing="2" cellpadding="2">
			<tr><td>
							
				<td>
				
					<input name="Agree" 
					class   = "ButtonNav1"
					value   = "Continue" 
					type    = "button"
					style   = "width:150"
					onclick = "step('hide','regular','hide','hide')"
					onMouseOver = "change(this,'ButtonNav11')"
					onMouseOut  = "change(this,'ButtonNav1')">
				
				</td>
								
			</tr>
			</table>
							
		</td></tr>					
			
		</td>
		</tr>
	
	</table>
	
</cfoutput>		