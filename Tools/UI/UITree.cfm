<cfparam name="ATTRIBUTES.name"     default="">
<cfparam name="ATTRIBUTES.id"       default="#Attributes.name#">
<cfparam name="ATTRIBUTES.expand"   default="true">
<cfparam name="ATTRIBUTES.title"    default="">
<cfparam name="ATTRIBUTES.img"      default="">
<cfparam name="Attributes.href"     default="">
<cfparam name="Attributes.target"   default="">
<cfparam name="Attributes.Root"     default="Yes">

<cfif Attributes.expand eq "Yes">
    <cfset Attributes.expand = "true">
</cfif>

<cfif thisTag.ExecutionMode is 'start'>
    <cfscript>
        SESSION.tree = ArrayNew(1);
        SESSION.treeBind = "";
    </cfscript>

<cfelseif thisTag.ExecutionMode is 'end'>

        <cfif SESSION.treeBind eq "">
            <cfoutput>
            <div id="_#Attributes.id#" class="hide">
                <ul id="#ATTRIBUTES.id#">
                <cfif Attributes.Root eq "Yes">
                    <li data-expanded="#ATTRIBUTES.expand#" data-url="#attributes.href#" data-target="#attributes.target#">
                </cfif>
                <cfif Attributes.Root eq "Yes">
                    <cfif attributes.img neq "">
                        <img src="#attributes.img#" style="width:16px;height:16px;padding:0px">
                    </cfif>
                    <cfif Attributes.title neq "">
                        #ATTRIBUTES.title#
                    <cfelse>
                        #Attributes.id#
                    </cfif>
                </cfif>
                <cfif Attributes.Root eq "Yes">
                    <ul>
                </cfif>
                <cfloop array="#Session.Tree#" index="itm">
                    <cfif itm.parent eq "#attributes.id#">
                        <li data-expanded="#itm.expand#" data-url="#itm.href#" data-target="#itm.target#">
                        <cfif itm.img neq "">
                                <img src="#itm.img#" style="width:16px;height:16px;padding:0px">
                        </cfif>#itm.display#

                        <cfset checkChildren('#itm.value#')>
                        </li>
                    </cfif>
                </cfloop>
                <cfif Attributes.Root eq "Yes">
                    </ul>
                    </li>
                </cfif>
                </ul>
            </div>
            <cfset AjaxOnLoad("function(){ProsisUI.doTree('#ATTRIBUTES.id#');}")>
            </cfoutput>
        <cfelse>
            <cfoutput>
                <div id="#Attributes.id#"></div>
            </cfoutput>
            <cfscript>
                bind = SESSION.treeBind;

                pattern="{[^}]+}"; //not allowing empty brackets

                fields=rematch(pattern,bind);

                pattern="[(][^)]*[)]"; //not allowing empty brackets

                parametersToken =rematch(pattern,bind);
                for (i=1;i<=arraylen(parametersToken);i++){
                    parameters = parametersToken[i];
                }

                parameters = replace(parameters,"(","");
                parameters = replace(parameters,")","");

                aParameters = ListToArray(parameters);

                pattern=":[^(]+[(]"; //not allowing empty brackets

                serviceTokens=rematch(pattern,bind);
                for (i=1;i<=arraylen(serviceTokens);i++){
                    service = serviceTokens[i];
                }

                service = replace(service,":","");
                service = replace(service,"(","");
                pattern="[.][^(]+[(]"; //not allowing empty brackets

                methodTokens=rematch(pattern,bind);
                for (i=1;i<=arraylen(methodTokens);i++){
                    methodList = methodTokens[i];
                }

                methodArray = ListToArray(methodList,'.');
                method = replace(methodArray[arrayLen(methodArray)],"(","");

                service = replace(service,"." & method,"");

                serviceURL = replaceNoCase(service,"service","component");
                serviceURL = replace(serviceURL,".","/","all");
            </cfscript>

            <cfobject
                    component = "#service#"
                    name = "treeDS">

            <cfset vFunction =treeDS['#method#']>

            <cfset objMetaData = GetMetaData(vFunction) />

            <cffunction name="getParameters">
                <cfset i = 0>
                <cfset j = 0>
                <cfset vReturn = arrayNew(1)>

                <cfloop array="#objMetaData.Parameters#" index="element">
                    <Cfset i++>
                    <cfif arrayLen(aParameters) gte i >
                        <cfif NOT arrayFind(fields,aParameters[i])>
                            <cfset j++>
                            <cfset vReturn[1]['#element.name#']=Replace(aParameters[i],"'","","all")>
                        </cfif>
                    </cfif>
                </cfloop>
                <cfset vReturnJSon = SerializeJSON(vReturn)>
                <cfreturn vReturnJSon>

            </cffunction>

            <cfoutput>
                <cfset AjaxOnLoad("function(){ProsisUI.doTreeBinder('#ATTRIBUTES.id#','#client.root#/#serviceURL#','#method#',#getParameters()#);}")>
            </cfoutput>

        </cfif>




</cfif>



<cffunction name="checkChildren">
    <cfargument name="parent" required="true"/>
    <cfoutput>
    <cfset var j = 0>
    <cfloop array="#Session.Tree#" index="child">
        <cfif child.parent eq arguments.parent>
            <cfif j eq 0>
                <cfset j = j + 1>
                <ul>
            </cfif>
                <li data-expanded="#child.expand#"  data-url="#child.href#" data-target="#child.target#">
                <cfif child.img neq "">
                        <img src="#child.img#" style="width:16px;height:16px;padding:0px">
                </cfif>#child.display#
                    <cfset checkChildren('#child.value#')>
                </li>
        </cfif>
    </cfloop>
    <cfif j neq 0>
        </ul>
    </cfif>
    </cfoutput>

</cffunction>