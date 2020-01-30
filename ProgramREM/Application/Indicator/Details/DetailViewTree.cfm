
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset Criteria = ''>

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td>

<table width="95%" align="right" border="0" cellspacing="0" cellpadding="0" rules="cols" style="border-collapse: collapse">

<cfform action="" method="POST" name="treeform">

   <tr><td height="8"></td></tr>	
      
	<cfquery name="Indicator" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM  Ref_Indicator
	WHERE IndicatorCode = '#URL.Indicator#'
	</cfquery>
   	
  <cfif Indicator.IndicatorTemplate neq "" and Indicator.IndicatorTemplateAjax eq "1">
  
	  <tr>
	  <td width="80">&nbsp;Hide Header</td>
	  <td><input type="checkbox" name="hidetop" value="1" checked></td>
	  </tr>	
  
  </cfif>
  
  <tr><td height="6"></td></tr>	
  <tr><td colspan="2"> 						
		<cf_ProgramIndicatorAudit mode="details"
				targetid = "#URL.targetid#"
				period =  "#URL.Period#">
	 </td>
  </tr>	 
  <tr><td height="4"></td></tr>	
  <tr><td height="1" colspan="2" class="line"></td></tr>	
  <tr><td height="6"></td></tr>	
  
  </cfform>
  
</table>       	
</td></tr></table>
