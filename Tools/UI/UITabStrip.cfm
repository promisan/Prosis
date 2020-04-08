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


