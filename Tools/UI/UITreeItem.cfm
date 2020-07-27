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
                ArrayAppend(SESSION.Tree,{parent:"#attributes.parent#", value:"#attributes.value#", value:"#attributes.value#", expand:"#attributes.expand#", display:"#attributes.display#",img:"#attributes.img#",href:"#attributes.href#",target:"#attributes.target#" });
        </cfscript>
    </cfoutput>

    <cfelse>
        <cfset SESSION.TreeBind = "#Attributes.bind#">
    </cfif>
</cfif>

