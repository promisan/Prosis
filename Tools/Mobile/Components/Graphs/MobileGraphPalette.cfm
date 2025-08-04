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
<cfparam name="attributes.color"				default="green">
<cfparam name="attributes.transparency"			default="0.6">
<cfparam name="attributes.mode"					default="regular">

<cfset caller.colors = "">
<cfset caller.highlightColor = "">
<cfset colors = []>	
<cfset highlightColor = "">

<cfif trim(lcase(attributes.mode)) eq "regular" OR trim(lcase(attributes.mode)) eq "">
	
	<cfswitch expression="#attributes.color#">
		
		<cfcase value="green">
			<cfset colors = ["rgba(63, 195, 128, #attributes.transparency#)","rgba(162, 222, 208, #attributes.transparency#)","rgba(135, 211, 124, #attributes.transparency#)",
							"rgba(144, 198, 149, #attributes.transparency#)","rgba(38, 166, 91, #attributes.transparency#)","rgba(3, 201, 169, #attributes.transparency#)",
							"rgba(104, 195, 163, #attributes.transparency#)","rgba(101, 198, 187, #attributes.transparency#)","rgba(27, 188, 155, #attributes.transparency#)",
							"rgba(27, 163, 156, #attributes.transparency#)","rgba(102, 204, 153, #attributes.transparency#)","rgba(54, 215, 183, #attributes.transparency#)",
							"rgba(200, 247, 197, #attributes.transparency#)","rgba(134, 226, 213, #attributes.transparency#)","rgba(78, 205, 196, #attributes.transparency#)",
							"rgba(22, 160, 133, #attributes.transparency#)","rgba(46, 204, 113, #attributes.transparency#)","rgba(1, 152, 117, #attributes.transparency#)",
							"rgba(3, 166, 120, #attributes.transparency#)","rgba(77, 175, 124, #attributes.transparency#)","rgba(42, 187, 155, #attributes.transparency#)",
							"rgba(0, 177, 106, #attributes.transparency#)","rgba(30, 130, 76, #attributes.transparency#)","rgba(4, 147, 114, #attributes.transparency#)",
							"rgba(38, 194, 129, #attributes.transparency#)"]>
			<cfset highlightColor = "##57b32c">	
		</cfcase>

		<cfcase value="gray">
			<cfset colors = ["rgba(218, 223, 225, #attributes.transparency#)","rgba(171, 183, 183, #attributes.transparency#)","rgba(149, 165, 166, #attributes.transparency#)",
							"rgba(189, 195, 199, #attributes.transparency#)","rgba(108, 122, 137, #attributes.transparency#)","rgba(52, 73, 94, #attributes.transparency#)",
							"rgba(103, 128, 159, #attributes.transparency#)","rgba(44, 62, 80, #attributes.transparency#)","rgba(191, 191, 191, #attributes.transparency#)"]>
			<cfset highlightColor = "##2C3E50">
		</cfcase>

		<cfcase value="orange">
			<cfset colors = ["rgba(248, 148, 6, #attributes.transparency#)","rgba(235, 149, 50, #attributes.transparency#)","rgba(232, 126, 4, #attributes.transparency#)",
							"rgba(244, 179, 80, #attributes.transparency#)","rgba(242, 120, 75, #attributes.transparency#)","rgba(235, 151, 78, #attributes.transparency#)",
							"rgba(245, 171, 53, #attributes.transparency#)","rgba(211, 84, 0, #attributes.transparency#)","rgba(243, 156, 18, #attributes.transparency#)"]>						
			<cfset highlightColor = "##2C3E50">
		</cfcase>

		<cfcase value="red">
			<cfset colors = ["rgba(236, 100, 75, #attributes.transparency#)","rgba(210, 77, 87, #attributes.transparency#)","rgba(242, 38, 19, #attributes.transparency#)",
							"rgba(150, 40, 27, #attributes.transparency#)","rgba(217, 30, 24, #attributes.transparency#)","rgba(224, 130, 131, #attributes.transparency#)",
							"rgba(246, 71, 71, #attributes.transparency#)","rgba(214, 69, 65, #attributes.transparency#)","rgba(226, 106, 106, #attributes.transparency#)"]>
			<cfset highlightColor = "##F64747">
		</cfcase>

		<cfdefaultcase>
			<cfset colors = []>
			<cfset vSingleColor = attributes.color>
			<cfloop from="1" to="200" index="thisSingleColor">
				<cfset ArrayAppend(colors, vSingleColor, true)>	
			</cfloop>	
			<cfset highlightColor = vSingleColor>	
		</cfdefaultcase>
		
	</cfswitch>

</cfif>

<cfif trim(lcase(attributes.mode)) eq "custom">
	<cfset colors = attributes.color>
</cfif>

<cfset vUndefColor = "rgba(235, 235, 235, #attributes.transparency#)">
<cfloop from="1" to="32000" index="thisUndefColor">
	<cfset ArrayAppend(colors, vUndefColor, true)>	
</cfloop>

<cfset caller.colors = colors>
<cfset caller.highlightColor = highlightColor>