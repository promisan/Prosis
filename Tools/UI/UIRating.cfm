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
<cfparam name="Attributes.id"       default="">
<cfparam name="Attributes.min"      default="1">
<cfparam name="Attributes.max"      default="5">
<cfparam name="Attributes.selected" default="">

<cfif thisTag.ExecutionMode is 'start'>

    <cfoutput>	
        <input type="hidden" id="#Attributes.id#" name="#Attributes.id#" value="#Attributes.selected#" >	
        <cfset AjaxOnLoad("function(){$('###Attributes.id#').kendoRating({min: #attributes.min#,max: #attributes.max# });}")>
    </cfoutput>

</cfif>
