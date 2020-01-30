	
	<table width="100%"><tr><td height="60">						 	 	
	<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
			
	 <tr><td height="7" bgcolor="FF8080" align="center" style="padding:7px;border:1px solid gray;border-radius:5px">
	   
		   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		   <tr><td align="center" class="labellarge" style="color:#FFFFFF;">			   
		   <b><cf_tl id="Attention">:&nbsp;</b> <cf_tl id="Report preparation was interrupted on request of the user">
		   </td></tr>
		   </table>
	   
	  	</td>
	</tr>
	  
	</table>
	
	</td></tr></table>		
	
	 <cfquery name="List" 
     datasource="AppsSystem">
		 DELETE FROM stReportStatus
		 WHERE  ControlId     = '#URL.ControlId#'
		 AND    OfficerUserId = '#SESSION.acc#'
     </cfquery>