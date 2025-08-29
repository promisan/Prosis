<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<HTML><HEAD>
    <TITLE>Activity search</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD><body onLoad="window.focus()">

<cf_ObjectControls>

<cfform action="SearchSubmit.cfm?Mission=#URL.Mission#" method="POST" enablecab="Yes" name="search">

<table><tr><td height="9"></td></tr></table>

<table width="85%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350">

 <tr bgcolor="#002350">
    <td height="30" class="bannerN">
	  <b>&nbsp;Select criteria:</b>
	</td>
	<td align="right" class="bannerN">
	<input class="button1" type="reset"  value=" Reset  ">
	<input type="submit" name="Submit" value="  Continue  " class="button1">
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
    FROM #CLIENT.LanPrefix#Ref_Resource
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

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">
 
<TR bgcolor="6688aa">  
   <td colspan="1" height="18" class="topN">&nbsp;Identification</td>
   <td colspan="1" class="topN"></td>
   <td colspan="1" class="topN"></td> 
</TR>
	<!--- Field: Staff.OnBoard=CHAR;20;TRUE --->
<TR>
   <td height="5" colspan="3" valign="middle"></td>
</TR> 
	
<TR>
	
   <TD class="regular" width="90%">	
   
   <table border="0" cellspacing="0" cellpadding="0">
   <tr>
   <TD class="regular">&nbsp;Program code:&nbsp;</TD>
   <TD><INPUT type="text" name="ProgramCode" size="20" class="regular"></td>
   </tr>
   <tr>
   <TD class="regular">&nbsp;Program name:&nbsp;</TD>
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

   <TR>
     <td height="1" colspan="6" valign="middle"></td>
   </TR>     

   <TR>  
    <td width="33%" height="18" colspan="2" class="top3N">&nbsp;Category</td>
	<td width="33%" colspan="2" class="top3N">&nbsp;Funding</td>
	<td width="33%" colspan="2" class="top3N">&nbsp;Resource</td>
  </TR>
   
   <TR>
   <td height="3" colspan="6" valign="middle"></td>
   </TR>   
		
	
	<TD valign="top" class="regular">

	<input type="radio" name="CategoryStatus" id="CategoryStatus" value="ANY" checked onClick="uncheckList('Category')">ANY
	</TD>
	<TD>
    	<select name="Category" id="Category" size="8"  required="No" multiple onClick="uncheckRadio('CategoryStatus')">
	    <cfoutput query="Category">
		<option value="'#Code#'">#Code#<cfif Len(Code) eq "3">00</cfif> #Description#</option>
		</cfoutput>
	   	</select>
	</TD>	
	    
	
	<TD valign="top" class="regular">

	<input type="radio" name="FundingStatus" id="FundingStatus" value="ANY" checked  onClick="uncheckList('Funding')">ANY
    
	</TD>
	<TD>
  	<select name="Funding" id="Funding" size="8"  required="No" multiple onClick="uncheckRadio('FundingStatus')">
	    <cfoutput query="Funding">
		<option value="'#Code#'">#Description#</option>
		</cfoutput>
	   	</select>		
	</TD>	

	<TD valign="top" class="regular">

	<input type="radio" name="ResourceStatus" id="ResourceStatus" value="ANY" checked onClick="uncheckList('Resource')">ANY

	</TD>
	<TD>
    	<select name="Resource" id="Resource" size="8"  required="No" multiple onClick="uncheckRadio('ResourceStatus')">
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

      
   <TR bgcolor="002350">
     <td height="1" colspan="6" valign="middle"></td>
   </TR>     

   <TR bgcolor="6688aa">  
   <td colspan="2" height="18" class="top3N">&nbsp;Tree</td>
   <td colspan="2" class="top3N">&nbsp;Period</td>
   <td colspan="2" class="top3N">&nbsp;Has activities under</td>
   </TR>
   
   <TR>
   <td height="3" colspan="6" valign="middle"></td>
   </TR>   
   
	
	<TD valign="top" class="regular">

	<input type="radio" name="MissionStatus" id="MissionStatus" value="ANY" checked onClick="uncheckList('Mission')">ANY
	
	</TD>
	
	<TD>
    	
    	<select name="Mission" id="Mission"size="5" multiple required="No" onClick="uncheckRadio('MissionStatus')">
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

	<input type="radio" name="ActivityClassStatus" id="ActivityClassStatus" value="ANY" checked  onClick="uncheckList('ActivityClass')">ANY
    
	</TD>

		<TD>
    	<select name="ActivityClass" id="ActivityClassStatus" size="5"  required="No" multiple onClick="uncheckRadio('ActivityClassStatus')">
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

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="Cols" style="border-collapse: collapse">

<TR>
   <td width="25%"></td>
   <td></td>
   <td width="30%"></td>
   <td height="5" colspan="3" valign="middle"></td>
</TR>   

     
   <TR bgcolor="002350">
     <td height="1" colspan="6" valign="middle"></td>
   </TR>     

   <TR bgcolor="6688aa">  
   <td class="top3N" height="18"><b>&nbsp;</td>
   <td colspan="2" class="top3N">&nbsp;Progress Reporting Period</td>
   <td colspan="3" class="top3N">&nbsp;Status</td>
   </TR>
   
   <TR>
   <td height="3" colspan="6" valign="middle"></td>
   </TR>   
   
				
	<td width="20%"></td>			   
	
	<TD valign="top" class="regular">

	<input type="radio" name="ActivityDates" value="ANY" checked onclick="unhighlightitem('dates')">ANY
	<p>
	<input type="radio" name="ActivityDates" value="SPECIFIC" onclick="highlightitem('dates')">SPECIFIC
    
	</TD>

	   <td id="dates" valign="top" width="10%" class="regular">
	   Start Date:&nbsp;
   	   	<cf_intelliCalendarDate
		FormName="search"
		FieldName="StartDate" 
		DateFormat="#APPLICATION.DateFormat#"
		Default="#Dateformat(now()-30, CLIENT.DateFormatShow)#"
		AllowBlank="False">	
		
		<P>
		
	   End Date:&nbsp;&nbsp;&nbsp;
   	   	<cf_intelliCalendarDate
		FormName="search"
		FieldName="EndDate" 
		DateFormat="#APPLICATION.DateFormat#"
		Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
		AllowBlank="False">	
	</td>
	
		
    <!--- Field: ActivityStatus  --->
	
		<td></td>
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
   <td height="5" colspan="5" valign="middle"></td>
</TR> 		

</TABLE>

</td></tr>


</TABLE>

</td></tr>

</TABLE>

<HR>

<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
<td align="right" valign="middle" class="regular">
<!---
<button name="Prior" value="Next" type="button" onClick="history.back()">
<img src="<cfoutput>#SESSION.root#</cfoutput>/images/prev.gif" alt="" border="0"> &nbsp;<b>Back</b>&nbsp;  
</button>
--->
<button name="Prios" value="Prior" type="submit"><b>Submit</b>
<img src="<cfoutput>#SESSION.root#</cfoutput>/images/next.gif" border="0"> 
</button>


</td></tr>
</table>

</CFFORM>

</BODY></HTML>