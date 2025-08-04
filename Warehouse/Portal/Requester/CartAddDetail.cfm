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
		
<table width="100%" cellspacing="0" cellpadding="0">

	<tr><td height="4"></td></tr>
	
	<cfif detail.ItemUoMSpecs neq "">
	
		<tr><td>    	
				
			<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				<tr><td height="6"><font face="Verdana" size="2">Specifications:</td></tr>
				<tr><td>&nbsp;
				#Detail.ItemUoMSpecs#
				</td></tr>
			</table>
				
			</td>
		</tr>	
	
	</cfif>	
	
	<cfif special.shippingMemo neq "">
		
		<tr><td>		
			
			<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				
					<tr><td height="6"><font face="Verdana" size="2">Shipping Instructions</td></tr>
					<tr><td height="6"></td></tr>
					<tr><td bgcolor="f4f4f4" align="center" colspan="2"><img src="#SESSION.root#/images/finger.gif" alt="" border="0" align="absmiddle">#special.shippingMemo#.</td></tr>	
				
			</table>
		   		
		  </td>
		</tr>
	
	</cfif>
	
	<tr><td height="4"></td></tr>
	
</table>

</cfoutput>