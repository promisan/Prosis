    
	<cfparam name="url.id" default="">
    <!--- to handle when template is called outside of jQuery environment --->
    <cfparam name="url.sfx" default="1">
	<cfparam name="url.mode" default="quirks">

    <cfif url.sfx eq "1">
    	<cfset hide = "yes">
    <cfelse>
       	<cfset hide = "no">
	</cfif>
	<!---
	div window width and height are set dinamically on the AjaxOnLoad function
	--->
	<cfoutput>

	<cf_divscroll id="preferences" mode="#url.mode#" hide="#hide#" drag="no" width="900" height="490" float="yes" modal="yes" overflowy="hidden" zindex="9110" padding="5px">
		<cf_tableround mode="modal" totalheight="100%" totalwidth="100%">
		
			<table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="white" align="center">
				<tr>
					<td valign="middle" align="center">
					<cfoutput>
						<iframe src="../Preferences/UserEdit.cfm?ID=#SESSION.acc#&webapp=#url.id#" frameborder="0" marginheight="0" marginwidth="0" allowtransparency="yes" style="background-color:white" height="455px" width="100%" scrolling="no"></iframe>
					</cfoutput>
					</td>
				</tr>
			</table>

        </cf_tableround>
    </cf_divscroll>
    </cfoutput>
	

<!--- no client.veffects restriction is here because this function re sizes the div --->
<!--- and since hide="no" for explorer 6/7, it does not do the fade in effect anyway --->
	<cfset AjaxOnLoad("xchangePreferences")> 


    
