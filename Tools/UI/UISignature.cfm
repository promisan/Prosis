<cfparam name="Attributes.Mode"     default="Desktop">
<cfparam name="Attributes.Width"    default="200">
<cfparam name="Attributes.Height"   default="80">
<cfparam name="Attributes.Style"    default="border: 1px solid black;background-color:white">


<cfoutput>

    <div id="surface-container#Attributes.Mode#">
    <cfif Attributes.Mode eq "Desktop">
            <div id="surface#Attributes.Mode#" style="width: #Attributes.Width#px; height: #Attributes.Height#px;#Attributes.style#"></div>
    <cfelse>
            <div id="surface#Attributes.Mode#" style="max-width:100%; height: #Attributes.Height#px;#Attributes.style#"></div>
    </cfif>
    </div>


    <cfset AjaxOnLoad("function() { initSignatureCanvas#Attributes.Mode#();}")>

</cfoutput>





