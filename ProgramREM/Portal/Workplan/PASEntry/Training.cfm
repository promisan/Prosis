
<body leftmargin="5" topmargin="5" rightmargin="0" bottommargin="0">

<link href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cfquery name="Section" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ContractSection
	WHERE Code = '#URL.Section#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>


<cfform action="TrainingSubmit.cfm?ContractId=#URL.Contractid#&Section=#URL.Section#" method="POST">

<table width="100%" bgcolor="ffffff" height="92%" border="0" cellspacing="0" cellpadding="0" bordercolor="#C0C0C0" bgcolor="#FFFFFF" style="border: 1pt ridge inline d3d3d3;">

<tr><td valign="top">

	<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
	
	<tr>
	    <td class="regular" height="25" align="left" valign="middle">
			<cfoutput>
		    	&nbsp;<b>#Section.Description#</b></font>
			</cfoutput>
	    </td>
    </tr> 	
	
	<cfquery name="Training" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  T.*, 'Activity' AS Class, '' as DescriptionName, B.ActivityDescription AS Description
	FROM    ContractTraining T INNER JOIN
            ContractActivity B ON T.ContractId = B.ContractId AND T.ActivityId = B.ActivityId 
	WHERE   T.ContractId = '#URL.ContractId#'		
	UNION
    SELECT  T.*, 'Behavior' AS Class, R.BehaviorName AS DescriptionName, B.BehaviorDescription AS Description
	FROM    ContractTraining T INNER JOIN
            ContractBehavior B ON T.ContractId = B.ContractId AND T.BehaviorCode = B.BehaviorCode INNER JOIN
            Ref_Behavior R ON B.BehaviorCode = R.Code
	WHERE   T.ContractId = '#URL.ContractId#'			
	ORDER BY Class, Description		
	</cfquery>
	
	<cfset task = 0>
		
	<tr>
		<td>
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">		
	
		<cfoutput query="training" group="Class">
	
	    <tr><td height="22" colspan="2"><cf_interface cde="#Class#"><b>#Name#:</b></td></tr>
		
		<cfoutput>
		
		 <cfset task = task+1>
		
		 <tr><td colspan="2" bgcolor="C0C0C0"></td></tr>
		 <tr bgcolor="f4f4f4"><td colspan="2">&nbsp;&nbsp;<b>#DescriptionName#</td></tr>
		 <tr><td width="60"></td><td>
		 <cfinclude template="TrainingEntry.cfm">
		</td></tr>
		</cfoutput>
		
		</cfoutput>
	
		</table>
		
	</table>
	
</table>	

 
    <cf_Navigation
	 Alias         = "AppsEPAS"
	 Object        = "Contract"
	 Group         = "Contract"
	 Section       = "#URL.Section#"
	 Id            = "#URL.ContractId#"
	 BackEnable    = "1"
	 HomeEnable    = "1"
	 ResetEnable   = "1"
	 ResetDelete   = "0"
	 ProcessEnable = "1"
	 ProcessName   = "Save"
	 NextSubmit    = "1"
	 NextMode      = "1"
	 setNext       = "0">
 
 </cfform>
	