
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td height="21">

<cfmenu 
          name="detmenu"
          font="verdana"
          fontsize="14"
          bgcolor="transparent"
          selecteditemcolor="C0C0C0"
          selectedfontcolor="gray">
	  
 		  <cf_tl id="Depreciation History" var="1">
		  	  
		  <cfmenuitem 
          display="#lt_text#"
          name="detdep"		
		  href="javascript:topicdetail('dep')"/>	

 		  <cf_tl id="Movement History" var="1">
		  
		  <cfmenuitem 
          display="#lt_text#"
          name="detmov"		
		  href="javascript:topicdetail('unit')"/>	
		  		  
 		  <cf_tl id="Locations" var="1">
		  		  
		  <cfmenuitem 
          display="#lt_text#"
          name="detloc"		
		  href="javascript:topicdetail('loc')"/>	
    
</cfmenu>

<input type="hidden" name="topic" id="topic" value="dep">
<input type="hidden" name="assetid" id="assetid" value="">

</td></tr>

<tr><td height="1"></td></tr>
<tr><td class="line"></td></tr>
<tr><td height="1"></td></tr>

<tr>
<td height="99%" bgcolor="white" valign="top">

	<table width="98%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
  
	<tr><cfdiv id="detailbox" style="vertical-align: top;height: 100%; overflow: auto;" tagname="td"></tr>
	
	<td></td>
	 
</td>
</tr>

</table>
