<HTML><HEAD>
<TITLE>Vacancy - Reissue</TITLE>
</HEAD><body background="<cfoutput>#SESSION.root#</cfoutput>/Images/background.gif" bgcolor="#FFFFFF">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="URL.ID" default="">
<cfparam name="DocumentNoTrigger" default="#URL.ID#">

<cfquery name="Get" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Document
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="Deployment" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_GradeDeployment
	ORDER BY ListingOrder
</cfquery>

<cfquery name="Class"
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  FlowClass
</cfquery>

<body onLoad="window.focus()">

<script>

function showpost(form,mis,pst,fun,unit,grd)
{

 	window.open("../../DWarehouse/InquiryPost/LookupSearch.cfm?FormName= " + form + "&mission=" + mis + "&postnumber=" + pst + "&functionaltitle=" + fun + "&organizationunit=" + unit + "&postgrade=" + grd, "IndexWindow", "width=600, height=550, toolbar=yes, scrollbars=yes, resizable=no");
}

</script>

<cfform action="DocumentEntrySubmitOld.cfm?ID=#DocumentNoTrigger#" method="POST" name="documententry">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
    <td width="100%" height="30" align="left" valign="middle" class="BannerN">
	<font face="Times New Roman" size="3" color="FFFFFF"><b>&nbsp;Document Action</b></font>
	</td>
  </tr> 	
  
  <tr>
    <td width="100%" height="16" align="left" class="topN">
	<font face="tahoma" size="1" color="FFFFFF">&nbsp;Identification</font>
	 </td>
  </tr> 	
     
  <tr>
    <td width="100%">
    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
	
	<tr><td height="10" class="header"></td></tr>
	
	<cfoutput>
	
	<TR>
    <TD class="header">&nbsp;Trigger :</TD>
    <TD>&nbsp;
	
		<input type="text" name="documentnotrigger" value="#get.documentno#" size="20" maxlength="20" class="disabled" readonly>
		<input type="hidden" name="postnumber" value="#get.postnumber#" size="20" maxlength="20" class="disabled" readonly>
		
			
	</td>
	</TR>	
	
	<tr><td height="2" class="header"></td></tr>	
	
	<!---
	
	 <td class="header"> <font size="1" face="Tahoma">&nbsp;Vacancy No (old): </font> </td>
	<td>&nbsp;
      	 <input type="text" name="vacancynumber" size="30" maxlength="30" class="regular">
	</td>
	</TR>		
	
	--->
	
	 <TR>
    
    <td class="header">&nbsp;Organization:</font> </td>
	<td>&nbsp;
      	 <input type="text" name="mission" value = "#get.mission#" size="30" maxlength="30" class="disabled" readonly>
	    </td>
	</TR>		
	
	<tr><td height="2" class="header"></td></tr>	
	
    <!--- Field: Unit --->
    <TR>
    
    <td class="header"> <font size="1" face="Tahoma">&nbsp;Unit: </font> </td>
	<td>&nbsp;
    	 <input type="text" name="organizationunit" value = "#get.organizationunit#" size="80" maxlength="80" class="regular">
	</td>
	</TR>		
	
	<tr><td height="2" class="header"></td></tr>	
	
    <!--- Field: DueDate --->

    <tr> 		
	
	<TD class="header">&nbsp;<cf_tl id="Due date"></td>
    
	<td>&nbsp;<cfset end = DateAdd("m",  2,  now())> 
   	   	<cf_intelliCalendarDate
		FieldName="DueDate" 
		Default="#Dateformat(end, CLIENT.DateFormatShow)#">	
	</td>
	</TR>
	
	<tr><td height="2" class="header"></td></tr>		
			
    <TR>
    <TD class="header">&nbsp;<cf_tl id="Functional title">:</TD>
    <TD> &nbsp;
	     <input type="text" name="functionaltitle" value="" class="regular" size="60" maxlength="60" readonly> 
  	     <input type="button" class="button10g" name="search2" value=" ... " onClick="selectfunction('documententry','functionno','functionaltitle','','','')"> 
	     <input type="hidden" name="functionno" value="" class="disabled" size="6" maxlength="6" readonly>		
   	  
	</TD>
	</TR>	
	
	<tr><td height="2" class="header"></td></tr>	
	
	<TR>
    <TD class="header">&nbsp;<cf_tl id="Post grade">:</TD>
    <TD>&nbsp;
	  	<input type="text" name="postgrade" value = "#get.postgrade#" size="10" maxlength="10" class="disabled" readonly>
	</TD>
	</TR>	
	
	<tr><td height="2" class="header"></td></tr>	
	
	</cfoutput>
    
    <!--- Field: DeploymentLevel --->
    <TR>
    <td class="header">&nbsp;<cf_tl id="Roster search level">:</td>
	<td>&nbsp;
	    <cfselect name="GradeDeployment" required="Yes">
	    <cfoutput query="Deployment"> 
		<option value="#GradeDeployment#" <cfif #get.GradeDeployment# eq "#GradeDeployment#">selected</cfif>>#Description#</option>
		</cfoutput>
	    </cfselect>			
	</td>
	</TR>	   	   
	  
	<tr><td height="3" class="header"></td></tr>	  
 	
    <!--- Field: ParameterFillThrough --->
    <TR>
    <TD class="header">&nbsp;<cf_tl id="Fill through">:</TD>
    <TD>&nbsp;
	    <cfselect name="ActionClass" required="Yes">
	    <cfoutput query="Class">
		<option value="#ActionClass#" <cfif #get.ActionClass# eq "#ActionClass#">selected</cfif>>#Description#</option>
		</cfoutput>
	    </cfselect>			
			
	</TD>
	</TR>	
	
	<tr><td height="3" class="header"></td></tr>	
		
   
	<TR>
<td class="header">
  &nbsp;Remarks<p></td>
 <TD>&nbsp;&nbsp;<textarea cols="60" rows="3" name="Remarks" class="regular"></textarea>
</TD>
	</TR>
	
	<tr><td height="10" class="header"></td></tr>

</TABLE>

</table>

<HR>	

<input class="button1" type="button" name="cancel" value="  Cancel  " onClick="window.close()">
<input class="button1" type="submit" name="Submit" value="  Submit  ">

</CFFORM>

</BODY></HTML>