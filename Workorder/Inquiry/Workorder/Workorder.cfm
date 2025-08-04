<!--
    Copyright © 2025 Promisan

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
<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Agency for Internal Development</title>
</head>

<link href="../../pkdb.css" rel="stylesheet" type="text/css">

 <!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
javascript:window.history.forward(1);
</script> 

<cf_DialogMaterial>

<cfparam name="URL.Show" default="Hide">
<cfparam name="URL.ID1" type="string" default="WO-3186">
<cfparam name="URL.ID2" type="string" default="11">
<cfparam name="URL.ID3" type="string" default="11">
<cfparam name="URL.ID4" type="string" default="11">
<cfparam name="URL.ID5" type="string" default="11">
<cfparam name="URL.ID6" type="string" default="11">

<cfoutput>
<FORM action="javascript:ShowMAARDDecision('#URL.ID1#','#URL.ID2#','#URL.ID3#','#URL.ID4#','#URL.ID5#','#URL.ID6#')" method="post">
</cfoutput>

<cfquery name="Workorder" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  WorkOrd 
WHERE WorkorderNo = '#URL.ID1#'
</cfquery>

<cfquery name="Progress" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  WorkProg 
WHERE WorkorderNo = '#URL.ID1#'
</cfquery>

<cfquery name="Costing" 
datasource="AppsWorkorder"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  WorkCost 
WHERE WorkorderNo = '#URL.ID1#'
ORDER BY CostType
</cfquery>

<cfquery name="Requested" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  WorkReq 
WHERE WorkorderNo = '#URL.ID1#'
</cfquery>

<cfoutput>
<script>

var id1 = "#URL.ID1#";
var id2 = "#URL.ID2#";
var id3 = "#URL.ID3#";
var id4 = "#URL.ID4#";
var id5 = "#URL.ID5#";
var id6 = "#URL.ID6#";

function resetm(ref, amd, trig)
{
	window.open("DecisionFormReset.cfm?ID1=" + ref + "&ID6=" + trig, "DialogWindow", "width=600, height=300, scrollbars=no, resizable=yes");
}

function reload()
{
window.close();
opener.location.reload();
}

function reloadForm(shw) {
  	window.location="Workorder.cfm?ID1=" + id1 + "&Show=" + shw;
}
	
</script>
</cfoutput>


<select name="view" id="view" size="1" onChange="javascript:reloadForm(this.value)">
     <OPTION value="hide" <cfif #URL.Show# eq "Hide">selected</cfif>>Hide Progress history
     <OPTION value="show" <cfif #URL.Show# eq "Show">selected</cfif>>Show Progress history
</SELECT>  

<input type="button" name="eMail" id="eMail" value=" eMail " onClick="javascript:email('#URL.ID#');">
<INPUT TYPE="button" VALUE="  Print " onClick="window.print();"> 
<input type="button" name="Continue" id="Continue" value="  Close  " onClick="javascript:reload();">

<hr>

<cfif #URL.Show# eq "show">
 <table width="92%" border="1" cellspacing="1" cellpadding="3" align="center" bordercolor="#C0C0C0" style="border-collapse: collapse">

   <tr bgcolor="#000000">
    <TD><b>
   <font size="1" face="Tahoma" color="FFFFFF">Date</font></b></TD>
   <TD><b>
   <font size="1" face="Tahoma" color="FFFFFF">Status</font></b></TD>	
   <TD><b>
   <font size="1" face="Tahoma" color="FFFFFF">Description</font></b></TD>		
   <TD><b>
   <font size="1" face="Tahoma" color="FFFFFF">Officer</font></b></TD>
   </TR>
   
   <CFOUTPUT query="Progress">
   <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('E0E0E0'))#">
   <td width="10%"><font size="1" face="Tahoma" color="000000">#DateFormat(ProgressDate, CLIENT.DateFormatShow)#</A></font></td>
   <td width="20%"><font size="1" face="Tahoma" color="000000">#WorkStatus#</font></td>
   <td width="10%" align="center"><font size="1" face="Tahoma" color="000000">#ProgressDescription#</font></td>
   <td width="50%"><font size="1" face="Tahoma" color="000000">#EnteredFirstName# #EnteredLastName#</font></td>
   </TR>
   </CFOUTPUT>   
	   
 </table>
<p></p> 
<hr>
</cfif>

<body onLoad="window.focus()">

<table width="92%" border="0" cellspacing="1" cellpadding="1" align="center" bordercolor="#111111" style="border-collapse: collapse">
  <tr>
    <td width="100%" height="124" valign="top" colspan="2">
    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" height="125">
      <tr>
        <td width="7%" height="125" bgcolor="#336699"><font face="Tahoma" size="2">
        &nbsp;<img border="2" src="../../Images/usaid.JPG" width="113" height="109"></font></td>
        <td width="59%" height="125" bgcolor="#336699">
        <p align="center"><b><font face="Tahoma" size="3" color="#FFFFFF">Agency for 
        Internal Development&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>
        </b></p>
        <p align="center"><font face="Tahoma" size="5" color="#FFFFFF"><b>Internal Workorder&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></font></td>
        
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td width="100%" valign="top" colspan="2">
    <table border="1" cellspacing="1" style="border-collapse: collapse" bordercolor="#C0C0C0" width="100%" height="34">
      <tr>
        <td width="25%" height="17" valign="top" bgcolor="#6688AA">
        <b>
        <font face="Tahoma" size="2" color="#FFFFFF">&nbsp;1. 
        Class</font></b></td>
        <td width="25%" height="17" valign="top" bgcolor="#6688AA">
        <b>
        <font face="Tahoma" size="2" color="#FFFFFF">&nbsp;2. 
        WorkorderNo.</font></b></td>
        <td width="25%" height="17" valign="top" bgcolor="#6688AA">
        <b>
        <font face="Tahoma" size="2" color="#FFFFFF">&nbsp;3. 
        Category</font></b></td>
        <td width="25%" height="17" valign="top" bgcolor="#6688AA">
        <b>
        <font face="Tahoma" size="2" color="#FFFFFF">&nbsp;4. 
        Order Date</font></b></td>
      </tr>
      <tr>
        <td width="25%" height="17" align="center" valign="top"><CFOUTPUT query="Workorder"><font face="Tahoma" size="2" color="000000"><b>#WorkorderClass#</b></font></cfoutput></td>
        <td width="25%" height="17" align="center" valign="top"><CFOUTPUT query="Workorder"><font face="Tahoma" size="2" color="000000"><b>#WorkorderNo#</b></font></cfoutput></td>
        <td width="25%" height="17" align="center" valign="top"><CFOUTPUT query="Workorder"><font face="Tahoma" size="2" color="000000"><b>#WorkCategory#</b></font></cfoutput></td>
        <td width="25%" height="17" align="center" valign="top"><CFOUTPUT query="Workorder"><font face="Tahoma" size="2" color="000000"><b>#DateFormat(WorkorderDate, CLIENT.DateFormatShow)#</b></font></cfoutput></td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
  <td width="100%" colspan="2">
    <table border="1" cellspacing="1" style="border-collapse: collapse" bordercolor="#C0C0C0" width="100%" height="34">
      <td width="20%" valign="top"><b><font face="Tahoma" size="2">&nbsp;5. 
      Order briefs</font></b></td>
      <td width="80%" valign="top"><CFOUTPUT query="Workorder"><font face="Tahoma" size="2" color="000000">&nbsp;<b>#WorkBriefs#</b></font></cfoutput></td>
    </table>	
  </td> 	
  </tr>
  
  <tr>
    
     <td colspan="2" width="100%">
    
    <table border="1" cellspacing="1" style="border-collapse: collapse" bordercolor="#C0C0C0" width="100%">
  
    <tr>
      <td width="100%" bgcolor="#FFFFFF">
      <b>
      <font face="Tahoma" color="#000000" size="2">&nbsp;6. Requested by:</font></b></td>
    </tr>
	<tr>
	<td>
	
  <div align="center">
    <center>
	
  <table width="100%" border="1" cellspacing="1" cellpadding="3" style="border-collapse: collapse" bordercolor="#C0C0C0">

    <TR bgcolor="#84A4BB">
   <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">RequestNo</font></b></TD>	
    <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">Date</font></b></TD>
    <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">Officer</font></b></TD>	
    <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">Category</font></b></TD>		
    <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">Request description</font></b></TD>
    
    </TR>
	   
   <cfoutput query = "Requested"> 
   <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
   <td width="10%"><font size="1" face="Tahoma" color="000000"><A href="javascript:ShowWorkView('#Reference#')">#Reference#</A></font></td>   
   <td width="6%"><font size="1" face="Tahoma" color="000000">#DateFormat(Created, CLIENT.DateFormatShow)#</font></td>
   <td width="20%"><font size="1" face="Tahoma" color="000000">#RequesterFirstName# #RequesterLastName#</font></td>
   <td width="10%"><font size="1" face="Tahoma" color="000000">#RequestClass#</font></td>
   <td width="54%"><font size="1" face="Tahoma" color="000000">#ParagraphFormat(Specification)#</font></td>
   </TR>
   </cfoutput>
      
  </TABLE>		

	</center>
  </div>
	
	</td>
	</tr>
	
  </table>	
  </tr>
    
  
  <tr>
    <td width="100%" colspan="2">
    <table border="1" cellspacing="1" style="border-collapse: collapse" bordercolor="#C0C0C0" width="100%">
      <tr>
        <td width="50%" bgcolor="#6688AA">
        <b>
        <font face="Tahoma" size="2" color="#FFFFFF">&nbsp;7. Supervisor</font></b></td>
        <td width="50%" bgcolor="#6688AA">
        <b>
        <font face="Tahoma" size="2" color="#FFFFFF">&nbsp;8. Contractor</font></b></td>
      </tr>
      <tr>
        <td width="50%"><font face="Tahoma" size="2">&nbsp;&nbsp; a. Name:<b>
		<CFOUTPUT query="Workorder">#OfficerFirstName# #OfficerLastName#</cfoutput></b></font></td>
        <td width="50%"><font face="Tahoma" size="2">&nbsp; a. Name:</font>
        <font face="Tahoma" size="2" color="000000"><b>
		<CFOUTPUT query="Workorder">#ContractorName#</cfoutput></b></font></td>
 		</td>
      </tr>
      <tr>
        <td width="50%"><font face="Tahoma" size="2">&nbsp;&nbsp; b. Status:</font>
        <CFOUTPUT query="Workorder"><font face="Tahoma" size="2" color="000000"><b>#Status#</b></font></cfoutput>
       		
        </td>
        <td width="50%"><font face="Tahoma" size="2">&nbsp; b. Location: </font>
        <CFOUTPUT query="Workorder"><font face="Tahoma" size="2" color="000000"><b>#LocationDescription#</b></font></cfoutput>
		</td>
 		
      </tr>
      <tr>
        <td width="50%"><font face="Tahoma" size="2">&nbsp;&nbsp; c. DueDate:</font>
        <CFOUTPUT query="Workorder"><font face="Tahoma" size="2" color="000000"><b>#DateFormat(WorkorderDueDate, CLIENT.DateFormatShow)#</b></font></cfoutput>
 		
        </td>
        <td width="50%"><font face="Tahoma" size="2">&nbsp; c. Duedate:</font>
        <CFOUTPUT query="Workorder"><font face="Tahoma" size="2" color="000000"><b>#DateFormat(WorkorderFinished, CLIENT.DateFormatShow)#</b></font></cfoutput>
		
		</td>
      </tr>
    </table>
    </td>
  </tr>
   <tr>
   <td colspan="2" width="100%">
    
  <table border="1" cellspacing="1" style="border-collapse: collapse" bordercolor="#C0C0C0" width="100%">
  
    <tr>
      <td width="100%" bgcolor="#FFFFFF">
      <b>
      <font face="Tahoma" color="#000000" size="2">&nbsp;9. Costing:</font></b></td>
    </tr>
	<tr>
	<td>
	
  <div align="center">
    <center>
	
  <table width="100%" border="1" cellspacing="1" cellpadding="3" style="border-collapse: collapse" bordercolor="#C0C0C0">

    <TR bgcolor="#84A4BB">
    <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">Category</font></b></TD>
    <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">Date</font></b></TD>	
    <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">Item</font></b></TD>		
    <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">Quantity</font></b></TD>
    <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">UoM</font></b></TD>	
    <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">Price</font></b></TD>
    <TD bgcolor="#6688AA">
    <b>
    <font size="1" face="Tahoma" color="FFFFFF">Amount</font></b></TD>
    </TR>
	
   <cfset sum = 0>
   <cfoutput query="Costing" group="CostType">
   <td width="6%"><font size="1" face="Tahoma" color="000000">#CostType#</font></td>
   <cfoutput>
   <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
   <td width="6%"></td>
   <td width="6%"><font size="1" face="Tahoma" color="000000">#DateFormat(CostDate, CLIENT.DateFormatShow)#</font></td>
   <td width="30%"><font size="1" face="Tahoma" color="000000">#CostItem# #CostDescription#</font></td>
   <td width="10%"><font size="1" face="Tahoma" color="000000">#CostQuantity#</font></td>
   <td width="18%"><font size="1" face="Tahoma" color="000000">#CostUoM#</font></td>
   <td width="10%"><font size="1" face="Tahoma" color="000000">#CostPrice#</font></td>   
   <td width="20%" align="right"><font size="1" face="Tahoma" color="000000">#NumberFormat(CostTotal,'$___,_____')#</font></td>
   </TR>
   <cfset sum = sum + #CostTotal#>
   </cfoutput>
   </CFOUTPUT>
   
   <tr><td><font size="1" face="Tahoma">Total:</font></td><td colspan="6" align="right"><cfoutput><font size="2" face="Tahoma" color="000000"><b>#NumberFormat(sum,'$_____,____')#</b></font></cfoutput></td></tr>

  </TABLE>		

	</center>
  </div>
	
	</td>
	</tr>
	
  </table>	
  
  </tr></td>
  
  <tr><td colspan="2" width="100%">
	
  <table border="1" cellspacing="1" style="border-collapse: collapse" bordercolor="#C0C0C0" width="100%">
 	
    <tr>
      <td width="100%" bgcolor="#FFFFFF">
      <b>
      <font face="Tahoma" color="#000000" size="2">&nbsp;10. Instructions:</font></b></td>
    </tr>
	<tr><td><CFOUTPUT query="Workorder"><font face="Tahoma" size="1" color="000000">#ParagraphFormat(WorkDescription)#</font></cfoutput></td></tr>
	
  </table>	
  
  </tr></td>
    
  <tr>
    
    <td width="100%" colspan="2">
   <table border="1" cellspacing="1" style="border-collapse: collapse" bordercolor="#C0C0C0" width="100%" height="32">
       <tr>
        <td width="50%" bgcolor="#993300" height="16">
        <font face="Tahoma" size="2" color="#FFFFFF">&nbsp;11a. Inspection by:</font></td>
        <td width="50%" bgcolor="#993300" height="16">
        <font face="Tahoma" size="2" color="#FFFFFF">&nbsp;11b. Inspection remarks:</font></td>		
        </tr>
        <tr>
            <td width="50%" height="9">&nbsp;<CFOUTPUT query="Workorder"><font face="Tahoma" size="2"><b>#InspectorFirstName# #InspectorLastName# on: #DateFormat(InspectionDate, CLIENT.DateFormatShow)#</b></font></cfoutput></td>
			<td width="50%" height="9">&nbsp;<CFOUTPUT query="Workorder"><font face="Tahoma" size="2"><b>#InspectionRemarks#</b></font></cfoutput></td>
          </tr>
   </table>
   </td>
  
  </tr>
</table>

</form>


</body>

</html>