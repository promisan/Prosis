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
<cfparam name="attributes.pageNum" 	default="1a">
<cfparam name="attributes.fontSize" default="12px">

<cfoutput>
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="2" height="1" style="border-top:1px solid ##333333;"></td></tr>
		<tr>
			<td style="padding:10px; padding-left:0px; color:##666666; font-size:#attributes.fontSize#; font-face:Verdana; font-family:Verdana;">
				#session.first# #session.last# [#session.acc#] @ #dateformat(now(), client.dateformatshow)# - #timeformat(now(), "hh:mm:ss tt")#
			</td>
			<td style="padding:10px; color:##666666; font-size:#attributes.fontSize#; font-face:Verdana; font-family:Verdana;" align="right">
				<!--- Page #attributes.pageNum# --->
			</td>
		</tr>
	</table>
</cfoutput>