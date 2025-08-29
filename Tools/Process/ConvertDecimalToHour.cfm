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
<cfparam name="Attributes.DecimalHour">

<cfset vHours = "">
<cfset vMinutes = "">

<cfset vHours = Int(Abs(Attributes.DecimalHour))>
<cfif len(vHours) eq 1>
	<cfset vHours = "0" & vHours>
</cfif>

<cfset vMinutes = Round(60*(Abs(Attributes.DecimalHour) - Int(Abs(attributes.DecimalHour))))>
<cfif len(vMinutes) eq 1>
	<cfset vMinutes = "0" & vMinutes>
</cfif>

<cfset caller.StringHour = vHours & ":" & vMinutes>