
<cfoutput>

<cfquery name="Get" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT  DISTINCT 
	         S.Description as ProgressStatus, 
			 count(*) as Counted    
	 FROM    Claim C, Ref_Status S, Organization.dbo.Organization O
	 WHERE   C.ActionStatus  = S.Status
	  AND    S.StatusClass   = 'clm'
	  AND    O.OrgUnit = C.OrgUnit
	  AND    O.ParentOrgUnit IN (SELECT ConditionValue 
	                       FROM  System.dbo.UserModuleCondition
						   WHERE SystemFunctionId = '#SystemFunctionId#'
						   AND   Account          = '#SESSION.acc#'
						   AND   ConditionField   = 'OrgUnit'
						   ) 
	 GROUP BY S.Description 
</cfquery> 

<cfquery name="output" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT  count(*) as Total
	 FROM Claim C
</cfquery> 
 
<cfif CLIENT.width lte "800">
	<cfset topics = "400">
<cfelse>
	<cfset topics = "600">
</cfif>

<table width="#topics#" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<cfoutput>
<tr><td height="18" align="center"><b>Insurance Claims by Status&nbsp;&nbsp;&nbsp;</b>[Total:#Output.Total#]</td></tr>
</cfoutput>
<tr><td height="1" class="line"></td></tr>
<tr><td height="4"></td></tr>
<tr><td align="center" class="regular">

<cfif Get.recordcount gt 0>
	
	<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="png" 
	         chartheight="260" 
			 chartwidth="#topics-100#" 
			 showxgridlines="no" 
			 showygridlines="no" 
			 showborder="no" 
			 fontbold="no" 
			 fontitalic="no" 
			 labelformat="number" 
			 show3d="yes" 
			 rotated="no" 
			 sortxaxis="yes" 
			 showlegend="yes" 
			 tipbgcolor="##FFFFCC" 
			 showmarkers="no" 
			 pieslicestyle="solid">
	
	      <cfchartseries type="pie" 
	               query="Get" 
				   itemcolumn="ProgressStatus" 
				   valuecolumn="Counted" 
				   serieslabel="Status" 
				   seriescolor="##CCCC66" 
				   paintstyle="raise" 
				   markerstyle="circle" 
				   colorlist="##CCCC66,green,blue">
	     </cfchartseries>
	
	</cfchart>

</cfif>
</td>
</tr>

<tr><td height="4"></td></tr>

</table>

</cfoutput>

