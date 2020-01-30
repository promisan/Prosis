
<cfparam name="url.id"      default="">
<cfparam name="url.drillid" default="#url.id#">

<cfquery name="Log" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		SELECT * FROM UserError
		WHERE ErrorId = '#url.drillid#'		
</cfquery>		

<!---
<cf_screentop height="100%" scroll="no" layout="webapp" label="Exception Log : #Log.ErrorNo#" band="No" bannerheight="50" banner="gray">
--->

<table width="100%" height="100%" border="0" cellpadding="0" align="center" bordercolor="silver">

<tr><td height="5"></td></tr>

<cfoutput query="log">

<tr><td valign="top">

		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">				
							
		<tr>
	    		 
		 <td>
		 
		 <table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
						 
			 <tr>
	         	<td height="17" style="padding-left:20px">CF server:</B></td>
				<td>#Log.HostName#</td>
			 </tr>
			 
			 <tr>
	         	<td height="17" style="padding-left:20px">User account:</B></td>
				<td>#log.Account# [#NodeIp#]</td>
			 </tr>
			
		     <tr>
	         	<td height="17" style="padding-left:20px">Browser:</B></td>
				<td>#left(log.NodeVersion,70)#</td>
			 </tr>
			 
			 <tr>
	         	<td height="17" style="padding-left:20px">Date and Time:</td>
				<td><b>#DayOfWeekAsString(DayOfWeek(log.ErrorTimeStamp))#</b> #dateformat(log.ErrorTimeStamp,CLIENT.DateFormatShow)# at #timeformat(log.ErrorTimeStamp,"HH:MM:SS")#</td>
			</tr>
			
			<tr>
	         	<td height="17" style="padding-left:20px">Directory:</B></td>
				<td>#TemplateGroup#</td>
			 </tr>
			
			<cfif log.errorreferer neq "">
			<tr>
		    	<td height="17" width="160" style="padding-left:20px">Referer:</td>
				<td style="word-wrap: break-word; word-break: break-all;">#log.ErrorReferer#</td>
			</tr>
			</cfif>
			
			<tr>
		    	<td height="17" width="160" style="padding-left:20px">Page:</td>
				<td style="word-wrap: break-word; word-break: break-all;"><b>#log.ErrorTemplate#</td>
			</tr>
			
			<tr>
		    	<td height="17" style="padding-left:20px">String:</td>
				<td style="word-wrap: break-word; word-break: break-all;">#log.ErrorString#</td>
			</tr>
			
			<tr>
		    	<td colspan="2"></td>			
			</tr>
									
			<tr>
	        	 
				 <td colspan="2" align="center">

					 <table width="99%" align="center" bgcolor="ffffdf" border="0" cellspacing="0" cellpadding="0" bordercolor="C0C0C0" class="formpadding">
					 <tr>
					 <td align="center">
					 <font color="gray"><b>
					 <cfset diag = replace(log.ErrorDiagnostics,".",".<br>","ALL")>
					 #diag#</b>
					 </td>
					 </tr>
					 </table>
					 
				 </td>
			</tr>
			
		
									
			
			</table>
		</tr>
		
		</table>
		
</td></tr>

<tr>
   	<td colspan="2" height="20" style="padding-left:20px;padding-right:10px">&nbsp;<B>Detailed Log</td>			
</tr>

<tr>
	        	 
	 <td height="100%" colspan="2"  align="center" style="padding-left:17px;padding-right:17px">
	 <table height="99%" width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="C0C0C0" class="formpadding"><tr>
	 <td style="word-break: break-all; word-wrap: break-word;" height="300">
	 	<cf_divscroll>
			<font color="gray">#Log.ErrorContent#</b></font>
		</cf_divscroll>
	 </td></tr></table>
	 </td>
</tr>		

</cfoutput> 	

</table>

<cf_screenbottom layout="webapp">

