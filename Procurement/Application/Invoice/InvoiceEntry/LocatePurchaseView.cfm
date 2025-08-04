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

<cfsavecontent variable="option">
	
	<cfoutput>
		
		    <cf_tl id="Close" var="1">
					
			<input type="button" 
				onclick="toggle('locatebox')" 
				class="button10g" 
				style="height:23px"
				name="togglebutton" 
				id="togglebutton"
				value="Hide Search Criteria">
			
	</cfoutput>

</cfsavecontent>

<cf_tl id="Record Incoming Invoice" var="1">

<cf_screenTop bannerheight="75" 
	    option="#option#" 
		label="#lt_text#" 
		layout="webapp" 
		jquery="Yes"
		SystemModule="Procurement"
		FunctionClass="Window"
		FunctionName="Invoice entry"	 
		banner="gray" 
		scroll="no" 
		user="Yes">
		
<cfoutput>

<table style="height:100%;width:100%">
	<tr style="height:1px">
		<td id="locatebox" class="regular" valign="top">
		<cfinclude template="LocatePurchase.cfm">		
		</td>
	</tr>
	<tr class="hide"><td height="100" id="processmanual"></td></tr>
	<tr>	
		<td align="center" style="padding-left:10px;padding-right:10px">
		
			<iframe src="" 
			    name="detail"
				id="detail"
		        width="99%"
		        height="97%"
		        align="middle"
		        scrolling="no"
		        frameborder="0"></iframe>
				
		</td>
	</tr>
</table>

</cfoutput>
