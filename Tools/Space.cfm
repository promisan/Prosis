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

<cfparam name="attributes.align"    default="left">
<cfparam name="attributes.spaces"   default="3">
<cfparam name="attributes.class"    default="cellcontent">
<cfparam name="attributes.style"    default="">
<cfparam name="attributes.script"   default="">
<cfparam name="attributes.label"    default="">
<cfparam name="attributes.id"       default="">
<cfparam name="attributes.padding"  default="1">
<cfparam name="attributes.color"    default="black">
<cfparam name="attributes.fontsize" default="">
<cfparam name="attributes.tip"      default="">

<cfoutput>
	
	<table width="100%" cellpadding="0" border="0" cellspacing="0"><tr><td class="space">#RepeatString('&nbsp;', attributes.spaces)#</td></tr>		
			
		<cfif attributes.label neq "">		
		<tr><td align="#attributes.align#" class="cellcontent" style="padding-right: #attributes.padding#px;padding-left: #attributes.padding#px;">
		
			<table cellspacing="0" cellpadding="0">
				<tr>
				<td style="padding-right: #attributes.padding#px;padding-left: #attributes.padding#px;">&nbsp;</td>
				
				<cfif attributes.script neq "">
						<td class="#attributes.class#" style="cursor:pointer;padding: #attributes.padding#px;#attributes.style#" id="#attributes.id#">
						<a href="#attributes.script#" title="#attributes.tip#">
						<font color="#attributes.color#" <cfif attributes.fontsize neq "">size="#attributes.fontsize#"</cfif>>
						#attributes.label#
						</font>
						</a>
						</td>
				<cfelseif attributes.tip neq "">	
						<td class="#attributes.class#" style="#attributes.padding#px;#attributes.style#" id="#attributes.id#" title="#attributes.tip#">		
						#attributes.label#
						    <!---			
							<cf_UIToolTip tooltip="#attributes.tip#">
							<font color="#attributes.color#" <cfif attributes.fontsize neq "">size="#attributes.fontsize#"</cfif>>
							#attributes.label#
							</font>
							</cf_UIToolTip>
							--->
						</td>
				<cfelse>
						<td class="#attributes.class#" style="#attributes.padding#px;#attributes.style#" id="#attributes.id#">
						<font color="#attributes.color#" <cfif attributes.fontsize neq "">size="#attributes.fontsize#"</cfif>>
						#attributes.label#
						</font>
						</td>
				</cfif>
					
				</tr>
			</table>
			
		</td></tr>		
		</cfif>		
	</table>
	
</cfoutput>

