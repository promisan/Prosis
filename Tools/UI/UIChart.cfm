<cfparam name="Attributes.Name"           default="">
<cfparam name="Attributes.Title"          default="">
<cfparam name="Attributes.TitlePosition"  default="Bottom">
<cfparam name="Attributes.chartheight"    default="">
<cfparam name="Attributes.chartwidth"    default="">
<cfparam name="Attributes.showlabel"     default="yes">
<cfparam name="Attributes.showvalue"     default="No">
<cfparam name="Attributes.transitions"   default="false">
<cfparam name="Attributes.url"           default="">


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
                $("##_#Attributes.Name#").kendoChart({
                transitions: #Attributes.transitions#,
                title: {
                    position: "#attributes.TitlePosition#",
                    text: "#Attributes.Title#"
                    },
                legend: {
                    visible: false
                    },
                chartArea: {
                    background: "",
                    height:#attributes.chartheight#,
                    width:#attributes.chartwidth#,
                    margin:20
                    },
                seriesDefaults: {
                    labels: {
                        <cfif Attributes.showlabel eq "Yes">
                            visible: true,
                            background: "transparent",
                            template: "##= category ##"
                        <cfelse>
                            <cfif Attributes.showvalue eq "Yes">
                                template: "##= kendo.format('{0:n0}',value)##"
                            <cfelse>
                                visible: false,
                                background: "transparent"
                            </cfif>
                        </cfif>
                    }
                },
                seriesColors: [
                    <cfloop array="#Session.chartSeries#" index="itm">
                        <cfloop list="#itm.seriesColor#" item='color'>
                            "#color#",
                        </cfloop>
                    </cfloop>
                ],

                series:[
                <cfloop array="#Session.chartSeries#" index="itm">
                    {
                        type: "#itm.type#",
                        categoryField: "category",
                        data:[
                            <cfloop query="itm.query">
                                <cfset vCategoryField = Evaluate("#itm.categoryField#")>
                                <cfset vField = Evaluate("#itm.field#")>
                                {
                                    category: "#vCategoryField#",
                                    value : #NumberFormat(vField,'00000')#
                                },
                            </cfloop>
                        ]
                    }
                </cfloop>
                ],
                tooltip: {
                    visible: true,
                    format:"{0:n0}"
                    },
                seriesClick: function(e){

                    $.each(e.sender.dataSource.view(), function() {
                        this.explode = false;
                    });

                    e.sender.options.transitions = false;

                    e.dataItem.explode = true;

                    <cfif Attributes.url neq "">
                        <cfset vUrl = replace(Attributes.url,"javascript:","")>
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
