

<table class="formpadding"><tr><td align="center">Work in progress</td></tr></table>

<cfabort>

<html>

<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Employee edit</title>
</head>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<link href="../../../print.css" rel="stylesheet" type="text/css" media="print">

<cfquery name="Parameter"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM        Parameter
</cfquery>

<script>

function reload()
{ 
   opener.location.reload();
   window.close();
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=600, height=550, toolbar=no, status=yes, scrollbars=yes, resizable=no");
}

</script>

<cf_dialogStaffing>

 
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT F.*, O.Description
FROM FunctionTitle F, OccGroup O
WHERE F.OccupationalGroup = O.OccupationalGroup
AND   F.FunctionNo= '#URL.ID#'
</cfquery>

<cfquery name="Grade" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT F.*
FROM FunctionTitleGrade F
WHERE F.FunctionNo= '#URL.ID#'
</cfquery>

<cfquery name="Parent" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT F.*
FROM FunctionTitle F
WHERE   F.FunctionNo= '#Get.ParentFunctionNo#'
</cfquery>

<cfquery name="Unit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT O.OrgUnitName
FROM Organization O
WHERE   O.OrgUnit = '#Get.OrgUnitAdministrative#'
</cfquery>

<body onLoad="window.focus()" class="dialog2">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="silver">
  <tr class="noprint">
    <td class="top3nd" height="23">
	<cfoutput>
	<font face="Verdana" size="2"><b>&nbsp;#Get.FunctionNo# #Get.FunctionDescription#</b></font>
	</cfoutput>
    </td>
	<td align="right" class="top3nd">
		
	<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="FunctionAdmin" 
		  returnvariable="Access">  		  
	
		
	</td>
  </tr> 	
 
  <tr>
    <td width="100%" colspan="2">
    <table border="0" cellpadding="0" cellspacing="0" width="98%" align="center">
	 
	 <tr>
        <td width="20%" height="5"></td>
        <td colspan="1"></td>
      </tr>		

	 <cfoutput> 
    
	  
	  <tr><td height="5"></td></tr>
	  
      <tr>
        <td height="15"><cf_tl id="Description">:</td>
        <td colspan="1">&nbsp;<b>#get.FunctionDescription#</td>
      </tr>
	  
	  <tr><td height="5"></td></tr>
	  
	  <tr>
        <td height="15"><cf_tl id="Occupational group">:</td>
        <td colspan="1">&nbsp;<b>#Get.Description# (#Get.OccupationalGroup#)</td>
      </tr>
	  	  	  
	  <tr><td height="5"></td></tr>
	  
	  <tr>
        <td height="15"><cf_tl id="Parent">:</td>
        <td colspan="1">&nbsp;<b>#Parent.FunctionDescription#</td>
      </tr>
	  
	  <tr><td height="5" ></td></tr>
	  
	   <tr>
        <td height="15"><cf_tl id="Administrative unit">:</td>
        <td colspan="1">&nbsp;<b>#Unit.OrgUnitName#
      </tr>
	  
	  <tr><td height="5"></td></tr>
	  
	  <tr>
        <td height="15"><cf_tl id="Memo">:</td>
        <td colspan="1">&nbsp;<b>#Get.Memo#</td>
      </tr>
	 
	  <tr><td height="5"></td></tr>
	   
	  <tr>
        <td><cf_tl id="Generic description">:</td>
		
   	    <td valign="top">
							
		   <cf_filelibraryN
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#Get.FunctionNo#" 
			Filter="Generic"
			Insert="yes"
			Remove="yes"
			Highlight="no"
			Listing="yes">
			
		</td>
		
	   </tr>	
	   	 	   
	   <!---
	   
	   <cfloop query="Grade">
	   <tr>
        <td align="right"> #Grade.GradeDeployment#:&nbsp;&nbsp;&nbsp;</td>
   	    <td width="100%" colspan="1">
	   <cf_filelibraryN
    	DocumentURL="#Parameter.DocumentURL#"
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#Get.FunctionNo#" 
		Filter="#GradeDeployment#"
		Insert="yes"
		Remove="yes"
		Highlight="no"
		Listing="yes">
		</td>
	   </tr>	
	   </cfloop>
	   
	   --->
	  
      </cfoutput> 
	 	 		  
   
    </table>
    </td>
  </tr>
</table>

</body>

</html>