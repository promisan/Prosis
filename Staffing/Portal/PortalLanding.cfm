
<cf_screentop html="no">


<table cellpadding="0" cellspacing="0" width="100%" height="100%">
	<tr>
		<td>
			<table cellpadding="0" cellspacing="0" width="100%" height="100%">
			
				<!--- menu --->
				<tr>
					<td height="39px" valign="bottom" style="padding-left:50px; background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Portal/Selfservice/Extended/Images/menu/bar_bg2.png'); background-position:bottom; background-repeat:repeat-x">
						<cfinclude template="../../Portal/SelfService/Extended/LogonProcessMenu.cfm">
					</td>
				</tr>
				
				<tr>
				<td height="100%">
					<table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">						
						<tr>
							<td id="menucontent" name="menucontent" valign="top" bgcolor="white" height="100%">																		
								<cfinclude template="../../Portal/SelfService/PortalFunctionOpen.cfm"> 
							</td>
						</tr>
					</table>
				</td>
			   </tr>	
				
			</table>
		</td>
	</tr>
</table>
