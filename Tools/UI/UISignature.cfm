<!--
    Copyright © 2025 Promisan

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
<cfparam name="Attributes.Mode"     default="Desktop">
<cfparam name="Attributes.Width"    default="200">
<cfparam name="Attributes.Height"   default="80">
<cfparam name="Attributes.Style"    default="border: 1px solid black;background-color:white">
<cfparam name="Attributes.Value"    default="">

<cfoutput>

    <cfif Attributes.Value eq "">
        <cfset vShow = "display:block;">
        <cfset vShowValue = "display:none;">
    <cfelse>
        <cfset vShow = "display:none;">
        <cfset vShowValue = "display:block;">
    </cfif>
    <div id="surface-container#Attributes.Mode#">
    <input type="hidden" name="SignatureValue" id="SignatureValue" value="#Attributes.Value#">

    <cfif Attributes.Mode eq "Desktop">
            
			<div id="surface#Attributes.Mode#" style="#vShow#width: #Attributes.Width#px; height: #Attributes.Height#px;#Attributes.style#"></div>
            <div id="image#Attributes.Mode#" style="#vShowValue#width: #Attributes.Width#px; height: #Attributes.Height#px;#Attributes.style#">
			
                <cfif Attributes.Value neq "">
                    <img src="#Attributes.Value#" style="width: #Attributes.Width#px; height: #Attributes.Height#px;">
                </cfif>
            </div>
			
    <cfelse>
	
            <div id="surface#Attributes.Mode#" style="#vShow#max-width:100%; height: #Attributes.Height#px;#Attributes.style#">
            </div>

            <div id="image#Attributes.Mode#" style="#vShowValue#width: #Attributes.Width#px; height: #Attributes.Height#px;#Attributes.style#">
                <cfif Attributes.Value neq "">
                    <img src="#Attributes.Value#" style="width: #Attributes.Width#px; height: #Attributes.Height#px;">
                </cfif>
            </div>

    </cfif>
    </div>

    <cfset AjaxOnLoad("function() { initSignatureCanvas#Attributes.Mode#();}")>

</cfoutput>





