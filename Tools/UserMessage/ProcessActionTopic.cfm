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

<cfparam name="attributes.name"   default="">
<cfparam name="attributes.color"  default="black">
<cfparam name="attributes.class"  default="labelmedium2">
<cfparam name="attributes.title"  default="">
<cfparam name="attributes.height" default="20">
<cfparam name="attributes.mode"   default="Collapsed">
<cfparam name="attributes.click"  default="alert('a')">
<cfparam name="attributes.line"   default="Yes">

<cfif attributes.mode eq "Collapsed">
  <cfset ex = "regular">
  <cfset cl = "hide">
<cfelse>
  <cfset ex = "hide">
  <cfset cl = "regular">
</cfif>

<cfoutput>

<tr><td style="width:20" class="#attributes.class#" height="#attributes.height#">
	
	<img src="#SESSION.root#/Images/expand5.gif" alt="Expand" 
	    onMouseOver="document.#attributes.name#Exp.src='#SESSION.root#/Images/expand-over.gif'" 
	    onMouseOut="document.#attributes.name#Exp.src='#SESSION.root#/Images/expand5.gif'"
		name="#attributes.name#Exp" id="#attributes.name#Exp" border="0" class="#ex#" 
		align="absmiddle" style="cursor: pointer;"
		onClick="#preservesinglequotes(attributes.click)#">
	
	<img src="#SESSION.root#/Images/collapse5.gif" 
		onMouseOver="document.#attributes.name#Min.src='#SESSION.root#/Images/collapse-over.gif'" 
		onMouseOut="document.#attributes.name#Min.src='#SESSION.root#/Images/collapse5.gif'"
		name="#attributes.name#Min" id="#attributes.name#Min" alt="Collapse" border="0" 
		align="absmiddle" class="#cl#" style="cursor: pointer;"
		onClick="#preservesinglequotes(attributes.click)#">
	
	</td>	
	<td width="100%" class="#attributes.class#" style="height:30px;font-size:20px">
	<a style="color:#attributes.color#" href="javascript:#preservesinglequotes(attributes.click)#">#attributes.title#</a>
	</td>
			
</tr>

<cfif attributes.line eq "Yes">
<tr><td height="1" colspan="2" class="line"></td></tr>
</cfif>

</cfoutput>