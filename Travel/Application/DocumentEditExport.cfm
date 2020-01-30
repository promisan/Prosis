<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD>
    <TITLE>Vacancy - Export</TITLE>
</HEAD><body background="../Images/background.gif" bgcolor="#FFFFFF">

<style>

BODY { 
	background : white; 
	color : 002350; 
	font-family : Times New Roman;
	 } 
	 
BODY.main {
	margin-bottom : 0px;
	margin-left : 1px;
	margin-right : 0px;
	margin-top : 0px;
} 	 

BODY.dialog {
	margin-bottom : 0px;
	margin-left : 0px;
	margin-right : 0px;
	margin-top : 0px;
} 	 

TABLE { 
	font-family : Times New Roman; 
	color : 002350; 
	}
 TD { 
 	font-family : Times New Roman; 
 	color : 002350; 
 	}
	
 TD.label {
	font-family : tahoma; 
	border : 1px; 	font-size : 8pt; 	
	background  : 002350; 	
	color : white; 
	}
 TD.top { 
 	font-family : tahoma; 
	border : 1px; 
	font-size : 8pt; 
	background :  6688aa; 
	color : white; 
	} 
TD.top2 { 
 	font-family : tahoma; 
	border : 1px; 
	font-size : 8pt; 
	background :  8EA4BB; 
	color : white; 
	} 	
TD.header { 
	font-family : tahoma; 
	font-size : 8pt; 
	background : f6f6f6; 
	} 
TD.regular { 
	font-family : tahoma; 
	font-size : 8pt; 
	height : 15px; 
	} 
TD.regularlist { 
	font-family : tahoma; 
	font-size : 8pt; 
	height : 15px; 
	}
	
TR.highLight { 
	BACKGROUND-COLOR: #8EA4BB; 
	color : black; 
	}
TR.highLight2 { 
	BACKGROUND-COLOR: #ffffcf; 
	color : black; 
	}	
TR.regular { 
	color: Black; 	
	}
	
A { 
	text-decoration: none; 
	color: black; 
	} 
A:Hover { 
	text-decoration: underline; 
	color: Maroon; 
	} 
HR { 
	color: 6688aa; 
	height: 1pt; 
	} 
SELECT { 
	color : 6688aa; 
	font-size : 8pt; 
	}
TEXTAREA { 
	font-size : 8pt; 
	color : 6688aa; 
	}
TEXTAREA.regular { 
	font-size : 8pt; 
	color : 6688aa; 
	BACKGROUND-COLOR: #FFFFFF;   
  	border : 1px solid; 
	}
TEXTAREA.disabled { 
	font-size : 8pt; 
	color : gray; 
	BACKGROUND-COLOR: #F6F6F6; 
  	border : 1px solid; 
  	} 
INPUT { 
    font-size : 8pt; 
    color : 6688aa; 
    }
INPUT.regular { 
	font-size : 8pt; 
	color : 6688aa; 
	border : 1px solid; 
	background  : transparent; 
	} 
INPUT.disabled { 
	font-size : 8pt; 
	color : black; 
	border : 1px solid Gray; 
	background : transparent; 
	}
INPUT.button1 { 
 	font-size : 7.5pt; 
	background: #6688aa; 
	color: white; 
	border : 1px solid #002350; 
	} 
INPUT.button2 { 
	font-size : 7.5pt; 
	background: white; 
	border  : 1px solid; 
	}
BUTTON { 
	font-size : 7.5pt; 
	color : 6688aa; 
	}
BUTTON.button1 { 
 	font-size : 7.5pt; 
	background: #6688aa; 
	color: white; 
	border : 1px solid black; 
	} 	
BUTTON.button2 { 
 	font-size : 7.5pt; 
	background: white; 
	color: #6688aa; 
	border : 1px solid #6688aa; 
	} 		
BUTTON.button3 { 
 	font-size : 7.5pt; 
	background: white; 
	color: #6688aa; 
	border : 0px solid #6688aa; 
	} 			
 
</style>

<body class="dialog" onLoad="window.focus()">

<cfparam name="Attributes.MailFilter" default="0">
<cfparam name="URL.ID" default="#Attributes.MailFilter#">

<cfquery name="Parameter" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
	WHERE Identifier = 'A'
</cfquery>

<cfquery name="Get" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Document
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="GetPost" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM DocumentPost
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<form action="DocumentEditSubmit.cfm" method="POST" name="documentedit" onSubmit="return ask();">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
    <td height="30" align="left" valign="middle" bgcolor="#002350">
	<font face="Times New Roman" size="3" color="FFFFFF">
	<b>&nbsp;VA: <cfoutput>#get.DocumentNo# [for #get.Mission# / #Get.PostGrade#]</cfoutput></b>
	</font>
	&nbsp;&nbsp;
	<cfoutput>
	<font color="FFFFFF">
	
	</td>
	
	<td height="30" align="right" valign="middle" bgcolor="002350">
	
	</font>
	<cfif #Get.Status# is "0" or #Get.Status# is "9">
	  </cfif>
	</cfoutput>
		
    <input type="button" class="input.button1" name="Close" value=" Close " onClick="javascript:closing()">
		
    </td>
			
  </tr> 	
  
  <tr>
    <td height="16" align="left" bgcolor="6688aa" class="top">
		
	&nbsp;Associated post(s): 
	<cfoutput query="GetPost"><
            <font color="FFFFFF">#PostNumber#</font>&nbsp;
	</cfoutput>


    </td>
	
	<td align="right" class="top" bgcolor="6688aa">
	<cfif #Get.Status# is "0" or #Get.Status# is "9">
		
	  	   
	<cfelse>
	    <input type="hidden" name="Status" value="1" hidden="text">
		<input type="text" name="StatusShow" value="Completed" size="8" maxlength="8" readonly style="color: Black; text-align: center; border-bottom-style: solid; border-bottom-width: 1px;">   
    </cfif>&nbsp;
	
	</td>

  </tr> 	
     
  <tr>
    <td width="100%" colspan="2">
    <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
	
	<tr><td height="10"></td></tr>
		
	<cfoutput>
	 
    <TR>
    <TD class="header">&nbsp;Reference:</TD>
    <TD class="regular">#get.ReferenceNo#</TD>
	</TR>	
	
	<TR>
    <TD class="header">&nbsp;Document class:</TD>
    <TD class="regular">#get.ActionClass#</td>

	
    <!--- Field: Unit --->
    <TR>
    
    <td class="header"> <font size="1" face="Tahoma">&nbsp;Unit: </font> </td>
	<TD class="regular">#get.OrganizationUnit#</td>
	
	</TR>		
		
    <!--- Field: DueDate --->

    <tr> 		
	
	<TD class="header">&nbsp;Due date</td>
    <TD class="regular">#Dateformat(Get.DueDate, CLIENT.DateFormatShow)#</td>
	</TR>
	
	<TR>
			
    <TR>
    <TD class="header">&nbsp;Functional title:</TD>
    <TD class="regular">#get.FunctionalTitle#</td>
	</TR>	
	
 	<TR>
	
    <td class="header">&nbsp;Remarks<p></td>
	<TD class="regular">#get.Remarks#</td>
    </TR>
	
	</cfoutput>
	
	<tr bgcolor="#FFFFFF"><td height="10" colspan="2"></td></tr>
	 
    <tr><td colspan="2" align="center"></td>
	
    <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

    <tr bgcolor="#6688AA" bordercolor="#808080">
      <TD class="top">&nbsp;St</TD>
	  <TD class="top">Lvl</TD>
      <TD class="top">Activity</font></TD>
	  <TD class="top">Planning</font></TD>
	  <TD class="top">Started</font></TD>
      <TD class="top">Completed</font></TD>
   	  <TD class="top">Officer</font></TD>
  	  <TD class="top">Date</font></TD>	
	  <TD class="top">Action</font></TD>
     </TR>

<cfset element = 1>
<cfset elementundo = 1>
<cfset show = "1">

<tr><td height="10" colspan="8"></td></tr>

<cfinclude template="Template/DocumentEdit_Lines.cfm">
     
</table>

</td>

<tr><td height="10" colspan="2" class="top"></td></tr>

</table>

<hr>
&nbsp;&nbsp;
<input type="button1" name="Close" value="  Close  " onClick="javascript:closing()">


</FORM>

</BODY></HTML>
