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

<cfset vTelephone = trim(vTelephone)>

<cfset _vTelephoneTemp = vTelephone>
<cfset _vTelephoneTemp = replace(_vTelephoneTemp, " ", "", "ALL")>
<cfset _vTelephoneTemp = replace(_vTelephoneTemp, "	", "", "ALL")>
<cfset _vTelephoneTemp = replace(_vTelephoneTemp, "-", "", "ALL")>
<cfset _vTelephoneTemp = replace(_vTelephoneTemp, ".", "", "ALL")>
<cfset _vTelephoneTemp = replace(_vTelephoneTemp, "(", "", "ALL")>
<cfset _vTelephoneTemp = replace(_vTelephoneTemp, ")", "", "ALL")>
<cfset _vTelephoneTemp = replace(_vTelephoneTemp, "[", "", "ALL")>
<cfset _vTelephoneTemp = replace(_vTelephoneTemp, "]", "", "ALL")>
<cfset _vTelephoneTemp = replace(_vTelephoneTemp, "/", "", "ALL")>

<!--- UN Extension --->
<cfif len(_vTelephoneTemp) eq 5>
	<cfif mid(_vTelephoneTemp, 1, 1) eq "3">
		<cfset _vTelephoneTemp = "21296" & _vTelephoneTemp>
	</cfif>
	<cfif mid(_vTelephoneTemp, 1, 1) eq "7">
		<cfset _vTelephoneTemp = "91736" & _vTelephoneTemp>
	</cfif>
</cfif>

<!--- 8 digits --->
<cfif len(_vTelephoneTemp) eq 8>
	<cfset vFormattedTelephone = "#left(_vTelephoneTemp,4)#-#right(_vTelephoneTemp,4)#">
</cfif>

<!--- 8 digits plus area code --->
<cfif len(_vTelephoneTemp) eq 11>
	<cfset vFormattedTelephone = "(#left(_vTelephoneTemp,3)#) #mid(_vTelephoneTemp,4,4)#-#right(_vTelephoneTemp,4)#">
</cfif>

<!--- 7 digits plus area code --->
<cfif len(_vTelephoneTemp) eq 10>
	<cfset vFormattedTelephone = "(#left(_vTelephoneTemp,3)#) #mid(_vTelephoneTemp,4,3)#-#right(_vTelephoneTemp,4)#">
	<cfif vHighlightExtension eq 1>
		<cfset vFormattedTelephone = "#left(vFormattedTelephone,8)#<span class='text-info' style='font-weight:bold;'>#mid(vFormattedTelephone,9,len(vFormattedTelephone))#</span>">
	</cfif>
<cfelse>
	<!--- other format --->
	<cfset vFormattedTelephone = vTelephone>
</cfif>