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
<cfparam name="Attributes.parent" default="root">
<cfparam name="Attributes.value" default="">
<cfparam name="Attributes.expand" default="true">
<cfparam name="Attributes.display" default="">
<cfparam name="Attributes.img" default="">
<cfparam name="Attributes.href" default="">
<cfparam name="Attributes.target" default="">
<cfparam name="Attributes.bind" default="">

<cfif Attributes.expand eq "Yes">
    <cfset Attributes.expand = "true">
</cfif>


<cfif thisTag.executionmode is 'start'>
    <cfif Attributes.bind eq "">
    <cfoutput>
        <cfscript>
                ArrayAppend(SESSION.Tree,{parent:"#attributes.parent#", value:"#attributes.value#", expand:"#attributes.expand#", display:"#attributes.display#",img:"#attributes.img#",href:"#attributes.href#",target:"#attributes.target#" });
        </cfscript>
    </cfoutput>

    <cfelse>
        <cfset SESSION.TreeBind = "#Attributes.bind#">
    </cfif>
</cfif>

