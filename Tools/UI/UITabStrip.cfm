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
<cfparam name="ATTRIBUTES.id"       default="">


<cfif thisTag.ExecutionMode is 'start'>
    <cfscript>
        SESSION.TabOptions = ArrayNew(1);
        SESSION.TabSources = ArrayNew(1);
    </cfscript>


<cfelseif thisTag.ExecutionMode is 'end'>

        <div class="k-content">
            <cfoutput>
            <div id="tabstrip_#attributes.id#">
                <ul>
                    <cfoutput>
                    <cfset i = 0>
                    <cfloop array="#SESSION.TabOptions#" index="itm">
                        <cfset i = i + 1>
                        <li <cfif i eq 1>class="k-state-active"</cfif>>
                            #itm.name#
                        </li>
                        <cfscript>
                            ArrayAppend(SESSION.TabSources,#itm.source#);
                        </cfscript>
                    </cfloop>
                    </cfoutput>
                </ul>
            </div>
            </cfoutput>
        </div>

        <cffunction name="getTabOptions">
            <cfset vReturnJSon = SerializeJSON(SESSION.TabSources)>
            <cfreturn vReturnJSon>
        </cffunction>

        <cfoutput>
            <cfset AjaxOnLoad("function(){ProsisUI.doTabStrip('#ATTRIBUTES.id#',#getTabOptions()#);}")>
        </cfoutput>

</cfif>


