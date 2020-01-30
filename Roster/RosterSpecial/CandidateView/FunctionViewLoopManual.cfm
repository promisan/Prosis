<!--- ------------ --->
<!--- MANUAL block --->
<!--- ------------ --->    
             
<table width="100%" cellspacing="0" cellpadding="0">
   <tr><td height="1" bgcolor="silver"></td></tr>
   <tr><td>
   <table width="100%">
	    <tr><td width="30" align="center" height="25">
	    <cfoutput>
		<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
			id="dmanualExp" border="0" class="regular" 
			align="middle" style="cursor: pointer;" 
			onClick="listing('manual','show','','','','','0','','1','LastName')">
			
			<img src="#SESSION.root#/Images/arrowdown.gif" 
			id="dmanualMin" alt="" border="0" 
			align="middle" class="hide" style="cursor: pointer;" 
			onClick="listing('manual','hide','','','','','0','','1','LastName')">
			
		</cfoutput>	&nbsp;
		</td>
		<td><a href="javascript: listing('manual','show','','','','','0','','1','LastName')">Manually Registered Candidates</a></b></td>
		</tr>
  </table>
  </td></tr>
  			  
  <tr><td class="hide" bgcolor="ffffbf" height="1" id="wmanual">&nbsp;Retrieving information ...</td></tr>
  <tr id="dmanual" class="hide"><td id="imanual"></td></tr>		   

</table>
	  