
	<cfparam name="url.mode" default="quirks">
    <!--- to handle when template is called outside a jQuery page --->
    <cfparam name="url.sfx" default="1">

    <cfif url.sfx eq "1">
    	<cfset hide = "yes">
    <cfelse>
       	<cfset hide = "no">
	</cfif>
    
    <cfoutput>
	<cf_divscroll id="resetpassword" mode="#url.mode#" hide="#hide#" drag="no" float="yes" modal="yes" width="400" height="395" overflowy="hidden" zindex="9110" padding="3px">
		<cf_tableround mode="modal" totalheight="100%">

            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="white" align="center">
                <tr>
                    <td valign="middle" align="center">
                       <iframe src="../../PasswordAssist.cfm?mode=portal&id=resetpassword" frameborder="0" marginheight="0" marginwidth="0" allowtransparency="yes" height="350px" width="100%" scrolling="no"></iframe>
                    </td>
                </tr>
            </table>

        </cf_tableround>
    </cf_divscroll>
    </cfoutput>
	
<cfif url.sfx eq "1">
	<cfset AjaxOnLoad("xresetPassword")>
</cfif>
