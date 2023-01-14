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
