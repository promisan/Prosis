

<!--- default client parameters --->
<cfinclude template="LogonClient.cfm">

<!--- added by hanno on 14/9/2011 --->
<cfparam name="url.mission" 		default="">

<!--- the purchase of this template is to pass thru to the correct Prosis portal opening page --->

<cfquery name="SelfService" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  = 'SelfService'
	AND    (MenuClass     = 'Main' or MenuClass = 'Mission')
	AND    FunctionName   = '#URL.ID#'
</cfquery>

<cfif selfservice.recordcount neq 1 or selfservice.operational neq 1>

	<cf_screentop layout="webapp" banner="gray" label="#SESSION.welcome# Portal Manager" user="no" line="no" bannerheight="60" validateSession="No" doctype="HTML5">

	<table width="100%" height="100%" cellpadding="0" cellspacing="0" align="center" bgcolor="ffffff">
		<tr>
			<td align="center" valign="top" style="padding-top:100px">	
				<cf_tableround mode="modal" totalheight="180px" totalwidth="80%" onmouseover="this.style.backgroundColor='gray'" onmouseout="this.style.backgroundColor='white'">
					<table cellpadding="0" cellspacing="0" height="100%">
						<tr>
							<td valign="middle" align="right"  style="padding-right:10px">
							<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/attention3.gif" border="0">
							</td>
							<td  align="left" style="padding-left:10px; border-left:1px dotted silver; line-height:12px">
								<font face="Verdana" size="3">
									<cfoutput>#URL.ID#</cfoutput> Portal was disabled or may not exist &nbsp;&nbsp;&nbsp;<hr style="border:1px dotted silver">
									<font size="2" color="gray">Please contact your IT Focal Point for assistance.</font>
								</font>
							</td>
						</tr>
					</table>
				</cf_tableround>	
			</td>
		</tr>
	</table>

<cfelse>		
	
	<cfif selfservice.functiontarget eq "basic">	
	
	   	<!--- initial mode for action logon --->	  
	   	<cfset mode = "logon">  	   
	   	<cfinclude template="Basic/Logon.cfm">		
	     
	<cfelseif selfservice.functiontarget eq "extended">	
	   	<cfinclude template="Extended/Default.cfm">	   	   
	<cfelseif lcase(selfservice.functiontarget) eq "html5">			
		<cfinclude template="HTML5/Default.cfm">	
	<cfelse>		
	    <!--- default is not HTML5 --->
	    <cfinclude template="HTML5/Default.cfm">		 		 
	</cfif>

</cfif>
