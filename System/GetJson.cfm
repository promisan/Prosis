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
<cfset vComponent = "#URLDecode(url.service)#">
<cfset vComponent = Replace(vComponent,"/",".","all")>
<cfset vComponent = Replace(vComponent,"component.","service.")>

<cfinvoke
        component="#vComponent#"
        method="#url.method#"
        returnVariable="res">
        <cfloop collection="#url#" item="key" >
            <cfif key neq "method" and key neq "getAdministrator" and key neq "service">
                <cfinvokeargument name="#key#"  value="#url[key]#">
            </cfif>
        </cfloop>
</cfinvoke>
<cfif Left(res,2) eq "//">
    <cfset vNew = Mid(res,3,Len(res))>
<cfelse>
    <cfset vNew = res>
</cfif>
<cfoutput>#vNew#</cfoutput>