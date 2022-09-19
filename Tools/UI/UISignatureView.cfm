<cfparam name="Attributes.Class"   default="">
<cfparam name="Attributes.Width"   default="200">
<cfparam name="Attributes.Height"  default="80">
<cfparam name="Attributes.Buttons"  default="Yes">
<cfparam name="Attributes.Style"   default="border: 1px solid black;background-color:white">

<cfoutput>

    <table class="formpadding">
    <cfif Attributes.Buttons eq "Yes">
        <cfset vHidden = "block">
    <cfelse>
        <cfset vHidden = "none">
    </cfif>

    <tr>
    <td>
    <div style="padding-right:0px; display:#vHidden#">
       <button type="button"  onclick="javascript:getSignatureWidth()" id="bSign" <cfif Attributes.class neq "">class="#Attributes.Class#"</cfif>><cf_tl id="Sign"></button>
    </div>
    </td>
    <td>
    <div style="padding-right:0px;">
      <button type="button"  onclick="javascript:clearSignature()" id="bClear" <cfif Attributes.class neq "">class="#Attributes.Class#"</cfif> style="display:none"><cf_tl id="Reset"></button>
    </div>
    </td>
    <td>
    <div style="padding-right:0px; display:#vHidden#">
      <button type="button"  onclick="javascript:saveSignature()" id="bDone" <cfif Attributes.class neq "">class="#Attributes.Class#"</cfif> style="display:none"><cf_tl id="Done"></button>
    </div>
    </td>
    </tr>

	<tr>
	<td colspan="3">
	
	    <input type="hidden" id="SignatureContent" name="SignatureContent">
	        <div id="dCanvasDesktop" style="display:none">
	        <cf_UISignature mode="Desktop" Width="#attributes.Width#" height="#attributes.height#" Style="#Attributes.Style#">
	    </div>
	
	    <div id="dCanvasMobile" style="display:none">
	        <cf_UISignature mode="Mobile"  Width="#attributes.Width#" height="#attributes.height#" Style="#Attributes.Style#">
	    </div>
	    <div id="dSave">
	    </div>
	
	    </td>
		
	    </tr>
    </table>
</cfoutput>

<cfif Attributes.Buttons eq "No">
    <cfset AjaxOnLoad("function() { getSignatureWidth();}")>
</cfif>