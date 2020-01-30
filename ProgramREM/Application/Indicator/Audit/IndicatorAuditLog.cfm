
<cfquery name="Action" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    PIAA.*
	FROM      ProgramIndicatorAudit PIA INNER JOIN
	          ProgramIndicatorAuditAction PIAA ON PIA.MeasurementId = PIAA.MeasurementId
	WHERE     (PIA.MeasurementId = '#URL.Id#')
	ORDER BY PIAA.Created DESC	
</cfquery>
			
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	<tr class="labelit line" bgcolor="f4f4f4">
	  <td width="30"></td> 
	  <td width="120"><cf_tl id="Timestamp"></td>
	  <td width="160"><cf_tl id="Name"></td>
	  <td width="130"><cf_tl id="Measurement"></td>
	  <td width="45%"><cf_tl id="Memo"></td>	 
	</tr>	
	
	<cfoutput query="Action">
		
		<tr class="labelit line" bgcolor="F5FBFE">
		  <td height="18" align="center">#currentRow#.&nbsp;</td> 
		  <td>#DateFormat(Created,CLIENT.DateFormatShow)# #TimeFormat(Created,"HH:MM")#</td>
		  <td>#OfficerFirstName# #OfficerLastName#</td>
		  <td>#numberformat(AuditTargetValue,"__,__")# <cfif audittargetcount neq "0">(#audittargetcount# / #audittargetbase#)</cfif></td>
		  <td>		  
		  	 <table cellspacing="0" cellpadding="0">		  
		  	   <cfif AuditRemarks neq "">			
					<tr><td>#AuditRemarks#</td></tr>			
			   </cfif>		  			  
			  </table>			  
		  </td>
		</tr> 
				
	</cfoutput>		
		
</table>
