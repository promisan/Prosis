

    <!--- to handle when template is called outside a jQuery page --->
    <cfparam name="url.sfx" default="1">
	<cfparam name="url.quirks" default="1">
	
	<cfif url.quirks eq "1">
		<cfset quirks = "quirks">
	<cfelse>
		<cfset quirks = "strict">
	</cfif>

    <cfif url.sfx eq "1">
    	<cfset hide = "yes">
    <cfelse>
       	<cfset hide = "no">
	</cfif>
	<!---
	<cf_divscroll id="changepassword" float="yes" modal="yes" width="630px" height="460px" overflowy="hidden" top="50%" left="50%" marginleft="-315" margintop="-250" zindex="11">
	--->
    <cfoutput>
	<cf_divscroll id="changepassword" mode="#quirks#" hide="#hide#" drag="no" float="yes" modal="yes" width="630" height="460" overflowy="hidden" zindex="9110" padding="5px">
		<cf_tableround mode="modal" totalheight="100%">

            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="white" align="center">
                <tr>
                    <td valign="middle" align="center">
                    	<cfoutput>
                       <iframe src="../../Portal/selfservice/SetInitPassword.cfm?id=#url.id#&mode=#url.mode#&window=#url.window#&link=#url.link#" frameborder="0" marginheight="0" marginwidth="0" allowtransparency="yes" height="420px" width="100%" scrolling="no"></iframe>
                    	</cfoutput>
                    </td>
                </tr>
            </table>

        </cf_tableround>
    </cf_divscroll>
    </cfoutput>
	
	<cfif url.sfx eq "1">
	<cfset AjaxOnLoad("passwordFadeIn")> 
    </cfif>
