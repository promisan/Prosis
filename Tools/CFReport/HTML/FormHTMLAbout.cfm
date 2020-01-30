 <!--- user must have selected his variant --->
	
<cfquery name="Report" 
 datasource="AppsSystem" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM   Ref_ReportControl
 WHERE  ControlId = '#URL.ControlId#' 
</cfquery>
    
  <cfoutput>
  <table width="97%" align="center" cellspacing="0" cellpadding="0">	
  
   <tr>
	  	<td>
            <img src="#SESSION.root#/Images/report/about.png" align="absmiddle" border="1" width="48" height="48" style="float: left;">&nbsp;<h1 style="float:left;color:##333333;font-size:28px;font-weight:200;padding:0;position: relative;top: 5px;margin: 0 0 30px;">About this report</h1></td>
  </tr>

  <tr><td colspan="1" class="labelmedium" bgcolor="f0f0f0" height="23" style="border: 1px solid silver;">
			&nbsp;
			<img src="#SESSION.root#/Images/bullet.png" alt="" border="0" align="absmiddle">
			<b><cf_tl id="Report details"></td>
  </tr>
					
  <tr>
	   <td>
	   
	   <cf_tabletop size="100%" omit="true">
	   	   
	     <table width="100%" align="center" cellspacing="0" cellpadding="0" class="formpadding">	
			  	  
			    <tr><td height="7"></td></tr>
				<tr><td valign="top">
			  
			  		<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
					<tr>
					    <td class="labelmedium" width="130"><cf_tl id="Name">:</td><td class="labelmedium">#Report.FunctionName#</td>
					</tr>
					<tr>
						<td class="labelmedium"><cf_tl id="Title">:</td><td class="labelmedium">#Report.FunctionMemo#</td>
					</tr>
					<tr>
						<td class="labelmedium"><cf_tl id="Owner">:</td><td class="labelmedium">#Report.Owner#</td>
					</tr>
					<tr>
						<td class="labelmedium"><cf_tl id="Language">:</td><td class="labelmedium">#Report.LanguageCode#</td>
					</tr>
					<tr>
						<td class="labelmedium"><cf_tl id="Module">:</td><td class="labelmedium">#Report.SystemModule#</td>
					</tr>
					<tr>
						<td class="labelmedium"><cf_tl id="Deployed by">:</td><td class="labelmedium">#Report.OfficerFirstName# #Report.OfficerLastName#</td>
					</tr>
					<tr>
						<td class="labelmedium"><cf_tl id="Date">:</td><td class="labelmedium">#dateformat(Report.created,CLIENT.DateFormatShow)#</td>
					</tr>
					<tr>
						<td class="labelmedium"><cf_tl id="eMail">:</td><td class="labelmedium">#Report.NotificationEMail#</td>
					</tr>
					<tr>
						<td class="labelmedium"><cf_tl id="Anonymous Access">:</td><td class="labelmedium"><cfif Report.EnableAnonymous eq "1">Yes<cfelse>No</cfif></td>
					</tr>	
					
					<cfquery name="Subscription" 
					 datasource="AppsSystem" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT *
						 FROM   UserReport
						 WHERE  ReportId = '#url.reportid#' 	
						 AND    DateExpiration >= getDate()				 
					</cfquery>
					
					<tr>
						<td class="labelmedium"><cf_tl id="Active Subscriptions">:</td><td class="labelmedium">#Subscription.Recordcount#</td>
					</tr>				
					
					
					</table>
				</td></tr>
				<tr><td height="7"></td></tr>
				</table> 	
	   
	   <cf_tablebottom size="100%">
	   </td>					
  </tr>
  
  <tr><td colspan="1" bgcolor="f0f0f0" class="bannerN9 labelmedium" height="23" style="border: 1px solid Silver;">
			&nbsp;
			<img src="#SESSION.root#/Images/bullet.png" alt="" border="0" align="absmiddle">
			<b><cf_tl id="Rules">/<cf_tl id="Legend"></td>
  </tr>
  
  <cfquery name="Memo" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ReportControlMemo
			WHERE  ControlId = '#URL.ControlId#'
			ORDER BY Created				
		</cfquery>
					
  <tr>
	   <td>
	   <cf_tabletop size="100%" omit="true">
	   
	    <table width="97%" align="center" bordercolor="e4e4e4" cellspacing="0" cellpadding="0" class="formpadding">
	   <tr><td height="9"></td></tr>
	     <!---
		 <tr>
		    <td width="16"></td>
			<td width="98%">Memo</td>
			<!---
			<td>Officer</td>
			<td>Date/Time</td>					
			--->
		</tr>
		--->
	
		<cfloop query="Memo">
							    
			<tr>
			    <td valign="top">#currentrow#.</td>
				<td width="98%">#paragraphformat(ReportMemo)#</td>
				<!---
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td width="100">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>				
				--->
			</tr>
					
		</cfloop>
		<tr><td height="9"></td></tr>
		</table>  
	   
	   
	   <cf_tablebottom size="100%">
	   </td>					
  </tr>
  
  
  
  <tr><td colspan="1" bgcolor="f0f0f0" class="bannerN9 labelmedium" height="23" style="border: 1px solid Silver;">
			&nbsp;
			<img src="#SESSION.root#/Images/bullet.png" alt="" border="0" align="absmiddle">
			<b><cf_tl id="Additional information"></td>
  </tr>
					
  <tr>
	   <td>
	   <cf_tabletop size="100%" omit="true">
	   
		   <table width="97%" align="center" cellspacing="0" cellpadding="0">	
		   <tr><td height="9"></td></tr>
		   <tr>
		   			<cfif Report.FunctionAbout neq "">
						<td class="labelmedium">#Report.FunctionAbout#</td>
					<cfelse>
					    <td align="center" class="labelmedium">
					    <cf_tl id="No additional information">				
						</td>
					</cfif>
		   </td></tr>	
		   <tr><td height="9"></td></tr>			
		   </table>			
	   
	   <cf_tablebottom size="100%">
	   </td>					
  </tr>
			
			
</table> 	

</cfoutput>  