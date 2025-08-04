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
<cfparam name="Attributes.id"   			default="monthPicker">
<cfparam name="Attributes.defaultYear"   	default="#year(now())#">
<cfparam name="Attributes.defaultMonth"   	default="#month(now())#">
<cfparam name="Attributes.fontSize"		  	default="20">
<cfparam name="Attributes.font"		  		default="verdana">
<cfparam name="Attributes.onSelect"		  	default="">

<cfoutput>

	<cf_tl id="January" var="1">	<input type="Hidden" name="__monthPickerMonth_1" id="__monthPickerMonth_1" value="#lt_text#">
	<cf_tl id="February" var="1">	<input type="Hidden" name="__monthPickerMonth_2" id="__monthPickerMonth_2" value="#lt_text#">
	<cf_tl id="March" var="1">		<input type="Hidden" name="__monthPickerMonth_3" id="__monthPickerMonth_3" value="#lt_text#">
	<cf_tl id="April" var="1">		<input type="Hidden" name="__monthPickerMonth_4" id="__monthPickerMonth_4" value="#lt_text#">
	<cf_tl id="May" var="1">		<input type="Hidden" name="__monthPickerMonth_5" id="__monthPickerMonth_5" value="#lt_text#">
	<cf_tl id="June" var="1">		<input type="Hidden" name="__monthPickerMonth_6" id="__monthPickerMonth_6" value="#lt_text#">
	<cf_tl id="July" var="1">		<input type="Hidden" name="__monthPickerMonth_7" id="__monthPickerMonth_7" value="#lt_text#">
	<cf_tl id="August" var="1">		<input type="Hidden" name="__monthPickerMonth_8" id="__monthPickerMonth_8" value="#lt_text#">
	<cf_tl id="September" var="1">	<input type="Hidden" name="__monthPickerMonth_9" id="__monthPickerMonth_9" value="#lt_text#">
	<cf_tl id="October" var="1">	<input type="Hidden" name="__monthPickerMonth_10" id="__monthPickerMonth_10" value="#lt_text#">
	<cf_tl id="November" var="1">	<input type="Hidden" name="__monthPickerMonth_11" id="__monthPickerMonth_11" value="#lt_text#">
	<cf_tl id="December" var="1">	<input type="Hidden" name="__monthPickerMonth_12" id="__monthPickerMonth_12" value="#lt_text#">

	
	<input type="Hidden" name="#Attributes.id#_year"  id="#Attributes.id#_year"  value="#Attributes.defaultYear#">
	<input type="Hidden" name="#Attributes.id#_month" id="#Attributes.id#_month" value="#Attributes.defaultMonth#">
	
	<table>
		<tr>
			<td valign="middle">
				<cf_tl id="Select a month" var="1">
				<img name="#Attributes.id#_button" id="#Attributes.id#_button" src="#session.root#/Images/calendarBlue.gif" align="absmiddle" style="height:#Attributes.fontSize#px; cursor:pointer;" title="#lt_text#">
			</td>
			<td valign="middle" style="padding-left:3px;">
				<input type="Text" name="#Attributes.id#" id="#Attributes.id#" style="border:0px; font-size:#Attributes.fontSize#px; font-face:#Attributes.font#; cursor:pointer;" readonly="yes" onfocus="this.blur();">
			</td>
		</tr>
	</table>
	
	<script>
		__initMonthPicker("#Attributes.id#","#Attributes.defaultYear#","#Attributes.onSelect#");
	</script>

</cfoutput>