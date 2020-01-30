<HTML><HEAD>
    <TITLE>Staffing Table</TITLE>
</HEAD><body>
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<CF_RegisterAction 
SystemFunctionId="0106" 
ActionClass="Nationality" 
ActionType="Inquiry" 
ActionReference="" 
ActionScript="">    

<b><font face="BondGothicLightFH">

<table width="100%">
<TD><font size="4"><b>Nationality Statistics</b></font></TD>
<TD><img src="../../../warehouse.JPG" alt="" width="40" height="40" border="1" align="right"></TD>
</table>
<hr>

<cfquery name="Nation" 
datasource="WarehousePMSS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#"
cachedwithin="#CreateTimeSpan(0,2,0,0)#">
    SELECT CODE, NAME 
    FROM Ref_Nationality
	WHERE NAME > 'A'
	ORDER BY NAME
</cfquery>

<cfquery name="MissionNow" 
datasource="WarehousePMSS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT Ref_Mission.Mission
    FROM Ref_Mission
	WHERE MissionStatus = 'Current'
	ORDER BY Ref_Mission.Mission
</cfquery>

<!--- Search form --->
<cfform action="Nationality.cfm" method="post" name="MyForm">

<TABLE width="329" height="123">
	
   <!--- Field: Staff.Nationality=CHAR;40;FALSE --->
		<TR>
	<TD valign="top" align="left">
    
   <font size="1" face="Tahoma"><b>Nationality</b></font><P>
      <font face="Tahoma" size="1">
		
	</TD>
	
	<TD>
    	<cfselect name="Nationality" size="14" message="Please select a nationality" required="Yes" multiple>
	    <cfoutput query="Nation">
		
		<option value="'#Code#'">
		#Name#
		</option>
		</cfoutput>
	    </cfselect>
		
	</TD>
	</TR>
	
		<!--- Field: AssignmentEnd=DATETIME;16;FALSE --->
		
	<INPUT type="hidden" name="Crit3_FieldName" value="W.AssignmentEnd">
	<INPUT type="hidden" name="Crit3_Value_date">
	<INPUT type="hidden" name="Crit3_FieldType" value="DATETIME">
	
    <TD valign="center" width="200" height="41">
    <b>
    <font size="1" face="Tahoma"><b>Selection date</b></font><P>
      <font face="Tahoma" size="1">	
	  
	<TD height="26">	
   	   	<cf_intelliCalendar
		FieldName="SelDate" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="TODAY">	
	</TD>
	</TR>
	<TR>
	
 <!--- Field: Staff.Mission=CHAR;20;FALSE --->
 	<TR>
	  <td valign="top"><font size="1" face="Tahoma"><b>Organization:</b></font><font face="Tahoma" size="1"></td>
	<td width="118">
    	<cfselect name="Mission" size="5" message="Please select a mission" required="Yes" multiple>
	    <cfoutput query="MissionNow">
		
		<option value="'#Mission#'" selected>
		#Mission#
		</option>
		</cfoutput>
	    </cfselect>
		
	</td>
	</TR>
	
	

<!--- Field: W.Source=CHAR;40;FALSE --->
<Tr>
	<INPUT type="hidden" name="Crit4_FieldName" value="W.Source">
	
	<INPUT type="hidden" name="Crit4_FieldType" value="CHAR">
	<INPUT type="hidden" name="Crit4_Operator" value="CONTAINS">

	<TD valign="center" width="200" height="41">
    <b>
    <font size="1" face="Tahoma"><b>Assignment Source</b></font><P>
    </TD>	
    <TD width="204" height="41">	
	
	<input type="radio" name="Crit4_Value" value="PKDB" checked></font><font size="2" face="Albertus Medium">PKDB</font><font face="Albertus Medium">
	<input type="radio" name="Crit4_Value" value="IMIS"><font size="2" face="Albertus Medium">IMIS</font><font face="Albertus Medium">
    <input type="radio" name="Crit4_Value" value="FPMS"></font><font size="2" face="Albertus Medium">FPMS</font><font face="Albertus Medium">&nbsp;
    </font>
	</td>
	</tr>	
	
<!--- Field: W.Graph --->
<Tr>

	<TD valign="center" width="200" height="41">
    <b>
    <font size="1" face="Tahoma"><b>Graph format</b></font><P>
    </TD>	
    <TD width="204" height="41">	
    <input type="radio" name="Graph" value="png" checked></font><font size="2" face="Albertus Medium">PNG</font><font face="Albertus Medium">&nbsp;
	<input type="radio" name="Graph" value="flash" ></font><font size="2" face="Albertus Medium">Flash</font><font face="Albertus Medium">
	<input type="radio" name="Graph" value="jpg"><font size="2" face="Albertus Medium">JPG</font><font face="Albertus Medium">&nbsp;
    </font>
	</td>
	</tr>		
	

	
</TABLE>
<HR>
<input type="submit" name="detailed" value=" Detailed Statistics ">
</CFFORM>

</BODY></HTML>