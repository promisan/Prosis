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

<cfparam name="attributes.type"         default="numeric">
<cfparam name="attributes.buttonwidth"  default="70">
<cfparam name="attributes.buttonheight" default="70">
<cfparam name="attributes.buttoncolor"  default="white">
<cfparam name="attributes.fontsize"     default="20">

<cfset wi  = attributes.buttonwidth>
<cfset ht  = attributes.buttonheight>
<cfset ft =  attributes.fontsize>

<cfoutput>

<cfset style = "font-size:#ft#;width:#wi#px;height:#ht#px;border:1px solid silver;background-color:#attributes.buttoncolor#">

<cfswitch expression="#attributes.type#">
	
	<cfcase value="numeric">
	
		<table cellspacing="0" cellpadding="0" style="border-radius:4px;border:0px solid silver" class="formspacing">
			<tr>
				<td><input class="button10s"  style="#style#" type="button" name="n7" id="n7" value="7" onclick="javascript:presskey('7');"></td>
				<td><input class="button10s"  style="#style#" type="button" name="n8" id="n8" value="8" onclick="javascript:presskey('8');"></td>
				<td><input class="button10s"  style="#style#" type="button" name="n9" id="n9" value="9" onclick="javascript:presskey('9');"></td>								
				<td style="padding-left:2px" rowspan="3"><input class="button10s"  style="font-size:#ft#;width:#wi#px;height:#ht*3+12#px;;border:1px solid silver" type="button" name="erase" id="eraase" value="<-" onclick="javascript:presskey('back');"></td>												
			</tr>
			
			<tr>
				<td><input class="button10g"  style="#style#" type="button" name="n4" id="n4" value="4" onclick="javascript:presskey('4');"></td>
				<td><input class="button10g"  style="#style#" type="button" name="n5" id="n5" value="5" onclick="javascript:presskey('5');"></td>
				<td><input class="button10g"  style="#style#" type="button" name="n6" id="n6" value="6" onclick="javascript:presskey('6');"></td>								
			</tr>
			<tr>
				<td><input class="button10g"  style="#style#" type="button" name="n1" id="n1" value="1" onclick="javascript:presskey('1');"></td>
				<td><input class="button10g"  style="#style#" type="button" name="n2" id="n2" value="2" onclick="javascript:presskey('2');"></td>
				<td><input class="button10g"  style="#style#" type="button" name="n3" id="n3" value="3" onclick="javascript:presskey('3');"></td>								
			</tr>
			<tr>
				<td id="tdn0" name="tdn0" colspan="2"><input class="button10g"  style="font-size:#ft#;width:#wi*2+16#px;height:#ht#px;background-color:#attributes.buttoncolor#;border:1px solid silver" type="button" name="n0" id="n0" value="0" onclick="javascript:presskey('0');"></td>
				<td style="padding-left:0px" id="tddot" name="tddot"><input class="button10g"  style="font-size:#ft#;width:#wi#px;height:#ht#px;background-color:#attributes.buttoncolor#;border:1px solid silver" type="button" name="dot" id="dot" value="." onclick="javascript:presskey('.');"></td>								
				
				<cf_tl id="erase" var="1">
				
				<td style="padding-left:2px"><input class="button10g"  style="font-size:13;width:#wi#px;height:#ht#px;border:1px solid silver" type="button" name="ce" id="ce" value="#lt_text#" onclick="javascript:presskey('ce');"></td>												
			</tr>

		</table>
	</cfcase>

</cfswitch>

</cfoutput>


