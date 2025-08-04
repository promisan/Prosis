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

<cfparam name="ATTRIBUTES.id"       default="">


<cfif thisTag.ExecutionMode is 'start'>
    <cfscript>
        SESSION.UIMenu = ArrayNew(1);
    </cfscript>
    <cfoutput>
    <ul id="Menu_#ATTRIBUTES.id#" class="hide">
    </cfoutput>

<cfelseif thisTag.ExecutionMode is 'end'>


    </ul>

    <cfoutput>
        <cfset AjaxOnLoad("function(){ProsisUI.doMenu('#ATTRIBUTES.id#');}")>
    </cfoutput>

</cfif>



