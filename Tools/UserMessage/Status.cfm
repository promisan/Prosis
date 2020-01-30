
<cfparam name="Attributes.text" default="Please wait . . .">
<cfparam name="Attributes.mode"  default="Status">

<cfif Attributes.mode neq "Status">
	
	<cf_waitEnd>
	
	<cfoutput>
	<table width="70%" align="center" id="busy">
	  
	  <tr><td height="150"></td></tr>
	  
	  <tr><td height="7"></td></tr>
	   
	   <tr>
	    <td align="center" class="regular"><font color="737373">#Attributes.text#</b>
		 
		    <input type="hidden" name="progress" id="progress"> 
		
		 </font>
		 <img src="#SESSION.root#/Images/busy2.gif" alt="" border="0" align="middle">
	   </td>
	   
	  </tr> 
	  <tr><td height="2"></td></tr>
	  <tr><td height="1" bgcolor="silver"></td></tr>
	  <tr><td height="2" bgcolor="gray"></td></tr>
	</table>
	
	<cfflush>

</cfoutput>

</cfif>
	
<cfoutput>
	
<script language="JavaScript">
	
	{
	window.status = "#Attributes.text#";
	}
	
</script>
	
</cfoutput>
	
	



