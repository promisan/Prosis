
<script language="JavaScript">

		function text(id) {
		
		   se = document.getElementById("va")			
		   url = "../../../vactrack/Application/Announcement/Announcement.cfm?id="+id+"&header=0"
		  	
			AjaxRequest.get({
			'url':url,
			   'onSuccess':function(req) {
					
					se.innerHTML = req.responseText;
					
				},
			   'onError':function(req) { 
					se.innerHTML = req.responseText;
				}	
			}
			);			
		}
		
		
</script>		


<tr><td colspan="4">
            
	  <table width="100%" cellspacing="0" cellpadding="0">
	   <tr><td height="1" bgcolor="silver"></td></tr>
	   <tr><td>
	   <table width="100%">
		    <tr><td align="center" width="30" height="25">
		    <cfoutput>
			<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
				id="textExp" border="0" class="regular" 
				align="middle" style="cursor: pointer;" 
				onClick="more('text','show')">
					
				<img src="#SESSION.root#/Images/arrowdown.gif" 
				id="textMin" alt="" border="0" 
				align="middle" class="hide" style="cursor: pointer;" 
				onClick="more('text','hide')">
					
			</cfoutput>	&nbsp;
			</td>
			<td><a href="javascript: more('text','show')">Announcement text</a></b></td>
			</tr>
	  </table>
	  </td></tr>
	 
	  <tr><td class="hide" id="text">
	  <table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	  <tr><td id="va">
	    <cfset URL.ID = "#URL.IDFunction#">
		<cfset URL.Header = "No">
	  	<cfinclude template="../../../Vactrack/Application/Announcement/Announcement.cfm">
	  </td></tr>
	  </table>
	  </td></tr>
	  </table>
</td></tr>	  