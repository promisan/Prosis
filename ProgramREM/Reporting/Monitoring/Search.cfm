
<HTML><HEAD>
    <TITLE>Employee Inquiry</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD><body onLoad="window.focus()">

<cf_ObjectControls>

<cfform action="SearchSubmit.cfm?Mission=#URL.Mission#" method="POST" enablecab="Yes" name="search">

<!--- <cfform action="javascript:ShowResult()" method="POST"> --->

<table><tr><td height="9"></td></tr></table>

<table width="85%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" rules="rows">

 <tr>
    <td height="30" class="top4n">
	  <b>&nbsp;Program/Project search criteria:</b>
	</td>
	<td align="right" class="top4n">
	<input style="width:100px" class="buttonNav" type="reset"  value=" Reset  ">
	<input style="width:100px"  type="submit" name="Submit" value="  Continue  " class="buttonNav">
    &nbsp;
	</td>
 </tr> 	
   
  <tr><td colspan="2">

<cfquery name="Category" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_ProgramCategory
	ORDER BY CODE
</cfquery>

<cfquery name="Funding" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_Fund
</cfquery>

<cfquery name="Resource" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_Resource
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT M.Mission 
    FROM Ref_Mission M, Ref_MissionModule R
	WHERE M.Mission   = R.Mission
	AND R.SystemModule = 'Program'
</cfquery>

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT Period 
    FROM ProgramPeriod
	ORDER BY Period
</cfquery>

<cfquery name="SubPeriod" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_SubPeriod 
</cfquery>

<cfquery name="Status" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Description, Status
    FROM Ref_Status 
	WHERE ClassStatus = 'Progress'
</cfquery>

<cfquery name="ActivityClass" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_ActivityClass
</cfquery>

<!--- Search form --->

</font>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" rules="cols">

<tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" rules="cols">
 
<TR>  
   <td colspan="1" height="18" class="top4n">&nbsp;Identification</td>
   <td colspan="1" class="top4n"></td>
   <td colspan="1" class="top4n"></td> 
</TR>
	<!--- Field: Staff.OnBoard=CHAR;20;TRUE --->
<TR>
   <td height="5" colspan="3" valign="middle"></td>
</TR> 
	
<TR>
	
   <TD class="regular" width="90%">	
   
   <table border="0" cellspacing="0" cellpadding="0">
   <tr>
   <TD class="regular">&nbsp;Code:&nbsp;</TD>
   <TD><INPUT type="text" name="ProgramCode" size="20" class="regular"></td>
   </tr>
   <tr>
   <TD class="regular">&nbsp;Name:&nbsp;</TD>
   <TD><INPUT type="text" name="ProgramName" size="40" class="regular"></td>
   </tr>
    <tr>
   <TD class="regular">&nbsp;Goal [enter a keyword]:&nbsp;&nbsp;</TD>
   <TD><INPUT type="text" name="ProgramGoal" size="30" class="regular"></td>
   </tr>
   </table>
 	
   </TD>
	
    <td class="regular" width="17%"></td>
	<td class="regular" width="17%"></td>
  
  <TR>
   <td height="3" colspan="6" valign="middle"></td>
   </TR>   

</TR>

</Table>
</td></tr>		

<tr><td width="100%" colspan="3">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

    <TR bgcolor="silver>
     <td height="2" colspan="7" valign="middle"></td>
   </TR>     

   <TR>  
    <td width="33%" height="18" colspan="2" class="top4n">&nbsp;Category</td>
	<td width="33%" colspan="2" class="top4n">&nbsp;Funding</td>
	<td width="33%" colspan="2" class="top4n">&nbsp;Resource</td>
	<td class="top4n">&nbsp;</td>
   </TR>
   
   <TR>
   <td height="3" colspan="9" valign="middle"></td>
   </TR>   
		
	<TD valign="top" class="regular">
	<table>
	    <tr><td>
		<input type="radio" name="CategoryStatus" id="CategoryStatus" value="ANY" checked onClick="uncheckList('Category')">ANY
		</td></tr>
		<tr><td>
		<input type="radio" name="CategoryStatus" id="CategoryStatus" value="ALL">ALL
		</td></tr>
	
	</table>
    
	</TD>
	<TD>
    	<select name="Category" id="Category" size="8"  required="No" multiple <!--- onClick="uncheckRadio('CategoryStatus') --->">
	    <cfoutput query="Category">
		<option value="'#Code#'">#Code# #Description#</option>
		</cfoutput>
	   	</select>
	</TD>	
	    
	
	<TD valign="top" class="regular">
	
	<table>
	    <tr><td>
		<input type="radio" name="FundingStatus" value="ANY" checked>ANY
		</td></tr>
		<tr><td>
		<input type="radio" name="FundingStatus" value="ALL">ALL
		</td></tr>
	
	</table>
	 
	</TD>
	<TD>
  	<select name="Funding" id="Funding" size="8"  required="No" multiple <!--- onClick="uncheckRadio('FundingStatus')" --->>
	    <cfoutput query="Funding">
		<option value="'#Code#'">#Description#</option>
		</cfoutput>
	   	</select>		
	</TD>	

	<TD valign="top" class="regular">
	
	<table>
	    <tr><td>
		<input type="radio" name="ResourceStatus" value="ANY" checked>ANY
		</td></tr>
		<tr><td>
		<input type="radio" name="ResourceStatus" value="ALL">ALL
		</td></tr>
	
	</table>
  
	</TD>
	<TD>
    	<select name="Resource" id="Resource" size="8"  required="No" multiple <!--- onClick="uncheckRadio('ResourceStatus')" --->>
	    <cfoutput query="Resource">
		<option value="'#Code#'">#Description#</option>
		</cfoutput>
	   	</select>
	</TD>	

	
	</TR>	
	
	
</table>

</td></tr>

<tr><td width="100%" colspan="3">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<TR>
   <td height="5" colspan="6" valign="middle"></td>
</TR>   

      
   <TR class="line">
     <td height="1" colspan="6" valign="middle"></td>
   </TR>     

   <TR>  
   <td colspan="2" height="18" class="top4n">&nbsp;Tree</td>
   <td colspan="2" class="top4n">&nbsp;Period</td>
   <td colspan="2" class="top4n">&nbsp;Has activities under</td>
   </TR>
   
   <TR>
   <td height="3" colspan="6" valign="middle"></td>
   </TR>   
   
	
	<TD valign="top" class="regular">

	<input type="radio" name="MissionStatus" id="MissionStatus" value="ANY" checked onClick="uncheckList('Mission')">ANY
	<p>
    <!--- <input type="radio" name="MissionStatus" value="ALL">ALL  --->
	
	</TD>
	
	<TD>
    	
    	<select name="Mission" id="Mission" size="5" multiple required="No" onClick="uncheckRadio('MissionStatus')">
	    <cfoutput query="Mission">
		<option value="'#Mission#'" <cfif #URL.Mission# eq #Mission#> selected </cfif>>#Mission#</option>
		</cfoutput>
	   	</select>
		
	</TD>	
		
    <!--- Field: Period --->
		
	<TD valign="top" class="regular">
	<input type="radio" id="PeriodStatus" name="PeriodStatus" value="ANY" checked onClick="uncheckList('Period')">ANY    
	</TD>

	<td align="left" class="regular">
    	
    	<select name="Period" id="Period" onClick="uncheckRadio('PeriodStatus')" size="5" multiple required="No">
	    <cfoutput query="Period">
		<option value="'#Period#'">#Period#</option>
		</cfoutput>
	   	</select>
	</td>	
	   
	
    <!--- Field: ActivityClass  --->

	<TD valign="top" class="regular">

	<input type="radio" name="ActivityClassStatus" id="ActivityClassStatus" value="ANY" checked <!--- onClick="uncheckList('ActivityClass')"--->>ANY
    
	</TD>

		<TD>
    	<select name="ActivityClass" id="ActivityClass" size="5"  required="No" multiple <!--- onClick="uncheckRadio('ActivityClassStatus')" --->>
	    <cfoutput query="ActivityClass">
		<option value="'#Code#'">#Description#</option>
		</cfoutput>
	   	</select>
		</TD>	
	
	</TR>	
	
	<TR>
   <td height="5" colspan="6" valign="middle"></td>
</TR> 		

</TABLE>

</td></tr>

<tr><td width="100%" colspan="3">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<TR>
   <td height="5" colspan="5" valign="middle"></td>
</TR>   

<TR class="line">
   <td height="1" colspan="5" valign="middle"></td>
</TR> 
      

   <TR>  
   <td class="top4n" height="18" ><b>&nbsp;Program activity progress</td>
   <td colspan="2" class="top4n">&nbsp;SubPeriod</td>
   <td colspan="2" class="top4n">&nbsp;Status</td>
   </TR>
   
   <TR>
   <td height="3" colspan="5" valign="middle"></td>
   </TR>   
   
				
	<td width="30%"></td>			   
    <!--- Field: Subperiod --->
	
		<TD valign="top" class="regular">
		<input type="radio" id="SubPeriodStatus" name="SubPeriodAny" value="ANY" checked onClick="uncheckList('SubPeriod')">ANY    
		</TD>
	
		<TD>
    	<select name="SubPeriod" id="SubPeriod" size="5" onClick="uncheckRadio('SubPeriodStatus')" required="No">
	    <cfoutput query="SubPeriod">
			<option value="#SubPeriod#" >#Description#</option>
		</cfoutput>
	   	</select>
		</TD>	
	
	
		
    <!--- Field: ActivityStatus  --->
	
		<TD valign="top" class="regular">
		<input type="radio" id="StatusAny" name="StatusAny" value="ANY" checked onClick="uncheckList('ActivityStatus')">ANY    
		</TD>

		<TD>
    	<select name="ActivityStatus" id="ActivityStatus" size="5" onClick="uncheckRadio('StatusAny')" required="No">
	    <cfoutput query="Status">
			<option value="#Status#" >#Description#</option>
		</cfoutput>
	   	</select>
		</TD>	
	
	</TR>	
	
	
	<TR>
   <td height="5" colspan="3" valign="middle"></td>
</TR> 		

</TABLE>

</td></tr>


</TABLE>

</td></tr>

</TABLE>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
<td align="center" height="30">
<!---
<button name="Prior" value="Next" type="button" onClick="history.back()">
<img src="<cfoutput>#SESSION.root#</cfoutput>/images/prev.gif" alt="" border="0"> &nbsp;<b>Back</b>&nbsp;  
</button>
--->
<button name="Prios" class="buttonFlat" style="width:120px" value="Prior" type="submit"><b>Submit</b>
<img src="<cfoutput>#SESSION.root#</cfoutput>/images/next.gif" align="absmiddle" border="0"> 
</button>

</td></tr>
</table>

</CFFORM>

</BODY></HTML>