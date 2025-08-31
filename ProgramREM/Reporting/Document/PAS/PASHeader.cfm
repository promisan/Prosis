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
<cfparam name="attributes.fontSize" 	default="12px">
<cfparam name="attributes.StaffName" 	default="">

<cf_tl id="Performance Appraisal Report" var="lblHeader">

<cfoutput>
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<cf_reportLogo size="28">
			</td>
			<td style="padding:10px; padding-right:0px; color:##666666; font-size:#attributes.fontSize#; font-family:Verdana; font-face:Verdana;" align="right">
				#ucase(lblHeader)# - #ucase(attributes.StaffName)#
			</td>
		</tr>
		<tr><td height="1" colspan="2" style="border-bottom:1px solid ##333333;"></td></tr>
	</table>
</cfoutput>