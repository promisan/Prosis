<cfparam name="Attributes.Mode"     default="Desktop">
<cfparam name="Attributes.Width"    default="200">
<cfparam name="Attributes.Height"   default="80">
<cfparam name="Attributes.Style"    default="border: 1px solid black;background-color:white">
<cfparam name="Attributes.Value"    default="">


<cfoutput>

    <cfif Attributes.Value eq "">
        <cfset vShow = "display:block;">
    <cfelse>
        <cfset vShow = "display:none;">
    </cfif>
    <div id="surface-container#Attributes.Mode#">
    <input type="hidden" name="SignatureValue" id="SignatureValue" value="#Attributes.Value#">

    <cfif Attributes.Mode eq "Desktop">
            <div id="surface#Attributes.Mode#" style="#vShow#width: #Attributes.Width#px; height: #Attributes.Height#px;#Attributes.style#">
            </div>
            <div id="image#Attributes.Mode#" style="width: #Attributes.Width#px; height: #Attributes.Height#px;#Attributes.style#">
                <cfif Attributes.Value neq "">
                    <img src="#Attributes.Value#" style="width: #Attributes.Width#px; height: #Attributes.Height#px;">
                </cfif>
            </div>

    <cfelse>
            <div id="surface#Attributes.Mode#" style="#vShow#max-width:100%; height: #Attributes.Height#px;#Attributes.style#">
            </div>

            <div id="image#Attributes.Mode#" style="width: #Attributes.Width#px; height: #Attributes.Height#px;#Attributes.style#">
                <cfif Attributes.Value neq "">
                    <img src="#Attributes.Value#" style="width: #Attributes.Width#px; height: #Attributes.Height#px;">
                </cfif>
            </div>

    </cfif>
    </div>


    <cfset AjaxOnLoad("function() { initSignatureCanvas#Attributes.Mode#();}")>

</cfoutput>





