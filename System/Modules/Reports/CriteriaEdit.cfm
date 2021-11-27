<cf_screentop height="100%" 
  html="yes" 
  scroll="Yes" 
  jquery="Yes"
  label="Edit Report Parameter Definition" 
  layout="webapp" 
  line="no"
  banner="gray">

<cfajaximport tags="cfform,cfinput-autosuggest">

<cf_criteriascript>
	
<table width="99%"       
	   align="center"
	   height="100%"	  
	   class="formpadding">
	   
<tr class="hide"><td id="fields"></td></tr>	   
	
<tr><td colspan="2" bgcolor="white" valign="top">	

  <cf_divscroll>   
	
	<cfinclude template="CriteriaEditForm.cfm">
	
  </cf_divscroll>	
	
</td></tr>

</table>

<cf_screenbottom layout="webapp">