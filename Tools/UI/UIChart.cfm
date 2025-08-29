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
<cfparam name="Attributes.Name"            default="">
<cfparam name="Attributes.Title"           default="">
<cfparam name="Attributes.TitlePosition"   default="Bottom">
<cfparam name="Attributes.chartheight"     default="">
<cfparam name="Attributes.chartwidth"      default="">
<cfparam name="Attributes.showlabel"       default="yes">
<cfparam name="Attributes.seriesplacement" default="">
<cfparam name="Attributes.showvalue"       default="No">
<cfparam name="Attributes.transitions"     default="false">
<cfparam name="Attributes.url"             default="">
<cfparam name="Attributes.legend"          default="No">
<cfparam name="Attributes.fontsize"        default="14">
<cfparam name="Attributes.suffixvalue"     default="">
<!--- last change was made because of the size of the font requested by Hanno --->

<cfif thisTag.executionmode is 'start'>
    <cfoutput>
        <cfscript>
            SESSION.chartSeries = ArrayNew(1);
        </cfscript>
        <div id="_#Attributes.Name#"></div>

    </cfoutput>

    <cfelseif thisTag.ExecutionMode is 'end'>

    <cfoutput>
        <cfsavecontent variable="kChart">
            $(window).on("resize", function() {
            $("##_#Attributes.Name#").data("kendoChart").redraw();
        });

        $("##_#Attributes.Name#").kendoChart({
        transitions: #Attributes.transitions#,
        title: {
        position: "#attributes.TitlePosition#",
        text: "#Attributes.Title#"
        },
        legend: {
        visible: <cfif Attributes.legend eq "No">false<cfelse>true</cfif>
            },
            chartArea: {
            background: "",
            <cfif attributes.chartheight neq "">
                height:#attributes.chartheight#,
            </cfif>
            <cfif attributes.chartwidth neq "">
                width:#attributes.chartwidth#,
            </cfif>
            margin:20
            },
            seriesDefaults: {
            <cfif Attributes.seriesplacement eq "stacked">
                stack: true,
            </cfif>
            labels: {
            <cfif Attributes.fontsize neq "">
                font: "#Attributes.fontsize#px sans-serif",
            </cfif>
            <cfif Attributes.showlabel eq "Yes">
                visible: true,
                background: "transparent",
                template: "##= category ##"
            <cfelse>
                <cfif Attributes.showvalue eq "Yes">
                    visible: true,
                    template: "##= kendo.format('{0:n0}',value)##"
                <cfelse>
                    visible: false,
                    background: "transparent"
                </cfif>
            </cfif>,

        }
        },

            <cfset vColorCount  = 0>
            <cfloop array="#Session.chartSeries#" index="itm">
                <cfloop list="#itm.seriesColor#" item='color'>
                    <cfset vColorCount = vColorCount + 1>
                    <cfif vColorCount eq 1>
                        seriesColors: [
                    </cfif>
                    "#color#",
                </cfloop>
            </cfloop>
            <cfif vColorCount neq 0>
                ],
            </cfif>

            <cfif Attributes.fontsize neq "">
                axisDefaults:
                {labels:
                {
                font: "#Attributes.fontsize#px Arial,Helvetica,sans-serif"
            }
            },
            </cfif>

            series:[
            <cfloop array="#Session.chartSeries#" index="itm">
                {
                type: "#itm.type#",
            categoryField: "category",
            currentField : "value",
            targetField : "value",
            name:"#itm.serieslabel#",
            data:[
                <cfloop query="itm.query">
                    <cfset vCategoryField = Evaluate("#itm.categoryField#")>
                    <cfset vField = VAL(Evaluate("#itm.field#"))>
                    <cfif Evaluate("#itm.reference#") neq "">
                        <cfset vReference = Evaluate("#itm.reference#")>
                    <cfelse>
                        <cfset vReference = "">
                    </cfif>
                    {
                    category: "#vCategoryField#",
                value : #NumberFormat(vField,'______.__')#,
                reference : "#vReference#"
                },
                </cfloop>
                ]
                },
            </cfloop>
            ],
            tooltip: {
            visible: true,
            format:"{0:n0}",
            template: "##= dataItem.category ##: ##= dataItem.value ###Attributes.suffixvalue# ##if (dataItem.reference !== '') {##(##=dataItem.reference##)##}##"
        },
        seriesClick: function(e){

        $.each(e.sender.dataSource.view(), function() {
        this.explode = false;
        });

        e.sender.options.transitions = false;

        e.dataItem.explode = true;

            <cfif Attributes.url neq "">
                <cfset vUrl = replace(Attributes.url,"javascript:","")>
                <cfset vUrl = replace(vUrl,"$ITEMLABEL$'","'+$ITEMLABEL$")>
                <cfset vUrl = replace(vUrl,"$ITEMLABEL$&","'+$ITEMLABEL$")>
                <cfset vUrl = replace(vUrl,"$ITEMLABEL$","e.dataItem.category")>
                #PreserveSingleQuotes(vUrl)#
            </cfif>

            e.sender.refresh();
            }


            });
        </cfsavecontent>
<!---
<cf_logpoint>
    #kChart#
</cf_logpoint>
--->


        <cfset AjaxOnLoad("function(){#kChart#}")>
    </cfoutput>


</cfif>

<cfset thisTag.GeneratedContent = "">
