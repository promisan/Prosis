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
<cfparam name="Attributes.number"    default="0">

<cfswitch expression="#Attributes.number#">

<cfcase value="0">
   <cfset val = "___,__">
</cfcase>

<cfcase value="1">
   <cfset val = "___,__._">
</cfcase>

<cfcase value="2">
   <cfset val = "___,__.__)">
</cfcase>

<cfcase value="3">
   <cfset val = "___,__.___">
</cfcase>

<cfdefaultcase>
    <cfset val = "___,__">
</cfdefaultcase>

</cfswitch>

<cfset caller.pformat = val>