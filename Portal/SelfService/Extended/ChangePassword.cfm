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
