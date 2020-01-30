<cf_screentop height="100%" 
  html="yes" 
  scroll="Yes" 
  label="Edit Report Parameter Definition" 
  layout="webapp" 
  line="no"
  banner="gray">

<cfajaximport tags="cfform,cfinput-autosuggest">

<cf_criteriascript>
	
<table width="99%"
       border="0"
	   align="center"
	   height="100%"
	   cellspacing="0"
       cellpadding="0"
	   class="formpadding">
	
<tr><td colspan="2" bgcolor="white" valign="top" id="fields">	

  <cf_divscroll>   
	
	<cfinclude template="CriteriaEditForm.cfm">
	
  </cf_divscroll>	
	
</td></tr>

</table>

<cf_screenbottom layout="webapp">