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
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Program</title>
</head>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<link href="../../../print.css" rel="stylesheet" type="text/css" media="print">

<script>

function reload()
{ 
   opener.location.reload();
   window.close();
}

function more(bx,AUDIT)
	
	 {
	 
		se   = document.getElementById(bx);
    	frm  = document.getElementById("i"+bx);
			 		 
		if (se.className=="hide")
		 {
			 se.className = "regular";
			 
 	 		 se2  = document.getElementById(bx+"Exp");
			 se2.className="hide"
			 
 	 		 se3  = document.getElementById(bx+"Min");
			 se3.className="regular"
		 
			 <cfoutput>
			 window.open(root+"/ProgramREM/Application/Audit/Observation/ObservationView.cfm?now=#now()#&row="+bx+"&AuditId="+AUDIT, "i"+bx)
			 </cfoutput>
	         window.scrollBy(30,30)
		 }
		 
		 else
		 
		 {
			 se.className  = "hide";
 	 		 se2  = document.getElementById(bx+"Min");
			 se2.className="hide"
			 
  	 		 se3  = document.getElementById(bx+"Exp");
			 se3.className="regular"
		 
		 }
			 		
 }	

 function AddAudit(Period, OrgUnit)

{
        w = screen.width-100;
        h = screen.height-100;
	    window.open(root + "/ProgramREM/Application/Audit/AuditEntry.cfm?Period=" + Period + "&OrgUnit=" + OrgUnit, "AddAudit", "left=20, top=20, width="+w+", height="+h+", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
}
 

 function EditAudit(AuditId)

{
        w = screen.width-100;
        h = screen.height-100;

	    window.open(root + "/ProgramREM/Application/Audit/AuditEntry.cfm?EditCode="+AuditId+"&AuditId=" + AuditId, "AddAudit", "left=20, top=20, width="+w+", height="+h+", status=yes, toolbar=no, scrollbars=yes, resizable=yes");


}
 
</script>

<cfquery name="Audit" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    ProgramAudit.dbo.Audit
WHERE   Period='#URL.Period#' and OrgUnit='#Par.OrgUnit#'
</cfquery>


<body onLoad="window.focus()">

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="e4e4e4" rules="rows">

<tr><td>
  
  <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="silver">
  
  <tr>
  	<td height="25" class="bannerN2">&nbsp;
  	<cfoutput>
		       &nbsp;|&nbsp;
			   <button onClick="javascript:mail('mail','#Par.OrgUnit#')" class="button3">
			     <img src="#SESSION.root#/Images/email_send.gif" alt="eMail project"  border="0" align="absmiddle">
			   </button>&nbsp;|&nbsp;
			   <button onClick="javascript:mail('print','#Par.OrgUnit#')" class="button3">
			     <img src="#SESSION.root#/Images/print_small3.gif" alt="Print project" border="0" align="absmiddle">
			   </button>&nbsp;|
			
		
	<input type="button" name="Add" id="Add" value="Add Audit" class="buttonNav" onClick="javascript:AddAudit('#URL.Period#','#Par.OrgUnit#');">&nbsp;
	</cfoutput>	
    </td>
  </tr>
  <tr><td bgcolor="e4e4e4"></td></tr>	

  <tr>
    <td width="100%" colspan="1">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

	<TR bgcolor="f4f4f4">
	
	    <td width="4%" height="18" align="center"></td>
		<TD width="6%">No</TD>
		<TD width="50%">Description</TD>
		<TD width="6%">Reference</TD>
		<td width="10%">Start Date</td>
		<td width="10%">Target Date</td>
	
	</TR>	
	
	<tr><td colspan="7" bgcolor="e4e4e4"></td></tr>		
   
	<cfoutput query="Audit"> 
     <tr>
		 <td height="20" align="center">
	      <img src="#SESSION.root#/Images/contract.gif"
		     alt=""
		     name="img0_#AuditNo#"
		     id="img0_#AuditNo#"
		     width="13"
		     height="14"
		     border="0"
		     align="absmiddle"
		     style="cursor: pointer;"
		     onClick="javascript:EditAudit('#AuditId#')"
		     onMouseOver="document.img0_#AuditNo#.src='#SESSION.root#/Images/button.jpg'"
		     onMouseOut="document.img0_#AuditNo#.src='#SESSION.root#/Images/contract.gif'">
     	 </td>
         <td>
		<!--- to busy..
		   <img src="http://promisan/prosis//Images/zoomin.jpg" alt="Expand" 
		   id="#CurrentRow#Exp" border="0" class="regular" 
		   align="middle" style="cursor: pointer;" onClick="more('#CurrentRow#','#AuditId#')">
		   <img src="http://promisan/prosis//Images/zoomout.jpg" 
		    id="#CurrentRow#Min" class="hide" 
		    alt="Hide" border="0" align="middle" class="#CurrentRow#" style="cursor: pointer;" 
		   onClick="more('#CurrentRow#','#AuditId#')">
		   --->
		   <a href="javascript:more('#CurrentRow#','#AuditId#')">
		   #AuditNo#
		   </a>
		   </td>		
         <td><a href="javascript:more('#CurrentRow#','#AuditId#')">#Description#</a></td>
		  <td><a href="javascript:more('#CurrentRow#','#AuditId#')">#Reference#</a></td>		
        
         <td>#Dateformat(AuditDateStart, CLIENT.DateFormatShow)# </td>
         <td>#Dateformat(AuditDateEnd, CLIENT.DateFormatShow)# </td>
     </tr>
	 <tr>
	    <td></td>
		<td></td>
		<td colspan="5">#Objective#</td>
	   </tr>
     <tr id="#CurrentRow#" class="hide">
		 <td colspan="6">
			 <iframe name="i#CurrentRow#" 
			 id="i#CurrentRow#" 
			 width="100%" 
			 align="middle" 
			 scrolling="no" 
			 frameborder="0"></iframe>
		 </td>
	  </tr>	 
	  
	 <cfif #CurrentRow# neq #Recordcount#>
	  <tr><td colspan="7" bgcolor="e4e4e4"></td></tr>		
	 </cfif> 
	  
	  </cfoutput>	  
 	  	
	</table>
	
	</tr>
	
	</table>
	
	</tr>
	
</table>

   
</body>

</html>