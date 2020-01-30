
<HTML><HEAD>
    <TITLE>Job profile</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD>

<div style="position:absolute;width:100%;height:100%; overflow: auto; scrollbar-face-color: F4f4f4;">

<body leftmargin="7" topmargin="7" rightmargin="7" bottommargin="7"></body>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Grade" 
 datasource="AppsSelection">
 SELECT *,
 		(SELECT Description FROM Ref_GradeDeployment WHERE GradeDeployment = G.GradeDeployment) as GradeDeploymentDescription
 FROM  FunctionTitleGrade G, 
       FunctionTitle F
 WHERE F.FunctionNo= '#URL.ID#'
 AND   F.FunctionNo = G.FunctionNo
 AND   G.GradeDeployment = '#URL.ID1#'
</cfquery>

<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0">

<tr><td style="height:45" class="labellarge">Generic Job Profile</td></tr>	

<tr><td>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<cfoutput>
	<tr><td height="4"></td></tr>
	<tr class="labelmedium">
	   <td class="labelmedium" width="120">&nbsp;Function:</td>
	   <td class="labelmedium" width="90%">#Grade.FunctionDescription#</td>
	</tr>
	<tr><td height="4"></td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr><td height="4"></td></tr>
	<tr  class="labelmedium">
	   <td class="labelmedium">&nbsp;Grade:</td>
	   <td class="labelmedium">#Grade.GradeDeployment# - #Grade.GradeDeploymentDescription#</td>
	</tr>
	</cfoutput>
	<tr><td height="4"></td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr><td height="4"></td></tr>
	<tr>
	   <td colspan="2" align="center">         
		 
		   <cf_ApplicantTextArea
			Table           = "FunctionTitleGradeProfile" 
			Domain          = "JobProfile"
			FieldOutput     = "ProfileNotes"
			Mode            = "View"
			Key01           = "FunctionNo"
			Key01Value      = "#URL.ID#"
			Key02           = "GradeDeployment"
			Key02Value      = "#URL.ID1#">
	   
	   </td>
	</tr>
	<tr><td height="4"></td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr><td height="4"></td></tr>
	<tr><td height="4" colspan="2" align="center" class="noprint">
		<input type="button" name="Print" value="Print profile" style="width:150;height:25" class="button10g" onclick="window.print();">
		<input type="button" name="Close" class="button10g" style="width:150;height:25" onclick="window.close();" value="Close profile">
	</td></tr>
	
	</table>

</td></tr>

</table>