<cfparam name="attributes.id" default="">
<cfparam name="attributes.size" default="medium">
    <!---
        "small"
        "medium"
        "large"
        "none"
    --->            
<cfparam name="attributes.placeholder" default="">

<cfoutput>
    <input name="#attributes.id#" id="#attributes.id#" type="text" >        

    <cfsavecontent  variable="vScript">

        $("###attributes.id#").kendoTextBox({
            size: "#attributes.size#",
            placeholder: "#attributes.placeholder#"
        });    

    </cfsavecontent>

</cfoutput>

<cfset ajaxOnLoad("function(){ #vScript# }")>