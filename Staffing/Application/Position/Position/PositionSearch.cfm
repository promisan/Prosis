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
    <TITLE>Employee Inquiry</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD><body>

<b><font face="BondGothicLightFH">

<table width="100%">
<TD><font size="4"><b>Position Management</b></font></TD>
<TD></TD>
</table>
<hr>

<cfquery name="Posttype" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_PostType
</cfquery>

<cfquery name="OccGroup" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM OccGroup
</cfquery>

<cfquery name="Postgrade" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Postgrade
</cfquery>

<!--- Search form --->
<cfform action="MandateView/MandateViewTree.cfm" method="post" name="positionsearch" id="positionsearch" target="left">

<table width="70%" frame="hsides" bordercolor="silver"border="1" cellspacing="0" cellpadding="0" align="center">

 <tr>
    <td height="30" colspan="2">
	  <b>&nbsp;Filter by any or all of the criteria below:</b>
	</td>
	
 </tr> 	
  
  <tr><td colspan="2" >
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">

    <Td>&nbsp;</TD>
					
	
    <TR><td height="30"></td>
	<TD align="left"><b>Occupational group:</b>
    </TD>
	<TD>
	
    	<select name="OccupationalGroup" size="1">
		<option value="">All groups</option>
	    <cfoutput query="OccGroup">
		<option value="'#OccupationalGroup#'">
    		#Description#
		</option>
		</cfoutput>
	    </select>
				
	</TD>
		
	</TR>	
	
    <TR><td height="30"></td>
	<TD align="left"><b>Grade:</b>
    </TD>
	<TD>
	
    	<select name="PostGrade" size="1">
		<option value="">All grades</option>
	    <cfoutput query="PostGrade">
		<option value="'#PostGrade#'">
    		#PostGrade#
		</option>
		</cfoutput>
	    </select>
				
	</TD>
		
	</TR>	
	
	   <TR><td height="30"></td>
	<TD align="left"><b>Posttype:</b>
    </TD>
	<TD>
	
    	<select name="PostType" size="1">
		<option value="">All posttypes</option>
	    <cfoutput query="PostType">
		<option value="'#PostType#'">
    		#PostType#
		</option>
		</cfoutput>
	    </select>
				
	</TD></TR>	
	
	<TR><td height="30"></td>
		
	<INPUT type="hidden" name="Crit1_FieldName" value="P.DateExpiration">
	<!--- Date convert hanno <INPUT type="hidden" name="Crit3_Value_date"> --->
	<INPUT type="hidden" name="Crit1_FieldType" value="DATETIME"> 
	
	<TD width="134" class="regular"><b>Expiration:</b></td>

    <td colspan="1">
    <SELECT name="Crit1_Operator">
		
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
		    <OPTION value="GREATER_THAN" selected>after
	</SELECT>
		
   	   	<cf_intelliCalendar
		FieldName="Crit1_Value" 
		Default="TODAY">	
	</td>
	</TR>	
 	
	</TD></TR>
	
	<TR><TD>&nbsp;</TD></TR>
	
	</TABLE>
	
    </td></tr>

</table>	
	

<HR>
<input type="submit" name="Submit" value="Submit" class="button10g">

</cfFORM>

</BODY></HTML>