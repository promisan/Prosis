<!--- Create Criteria string for query from data entered thru search form --->

<!---
<cf_screentop height="100%" scroll="Yes" layout="webapp" user="No" Label="Select Topic">
--->

<cfparam name="URL.view" default="1">

<table width="100%" height="100%" bgcolor="white" border="0" cellspacing="0" cellpadding="0">
  
  <tr><td colspan="2" valign="top">

	<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	<tr>
	 
	 	 <td width="4%" height="22" bgcolor="ffffff" align="right">
				
				<cfoutput>
			     <button type="button" class="button3" onClick="selectnew('#url.frm#','#url.loc#','','Topic')">
				 <img src="#SESSION.root#/Images/select4.gif" alt="" name="img5" 
					  onMouseOver="document.img5.src='#SESSION.root#/Images/button.jpg';" 
					  onMouseOut="document.img5.src='#SESSION.root#/Images/select4.gif';"
					  style="cursor: pointer;" alt="" align="middle" >
				  </button>	
				 </cfoutput> 	  
						
		 </td>
			
		 <td width="3%" bgcolor="ffffff" align="right"></td>
		 	 
    	 <TD class="labelit"><b>Empty</TD>	
         <TD></TD>
		 <TD></TD>
      </TR>
	  
	   <tr><td height="1" colspan="5" class="linedotted"></td></tr>
	
		<cfquery name="get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    M.*
			FROM      Ref_ModuleControl M
			WHERE     M.SystemModule = 'Portal'
			 AND      M.Operational = '1'
			 AND      M.MenuClass = 'Topic' 
			 AND      SystemFunctionId NOT IN (SELECT DISTINCT ReportId
				                            FROM          UserDashBoard
		        		                    WHERE      Account = '#SESSION.acc#' 
											AND ReportId IS NOT NULL)
			ORDER BY M.FunctionClass, M.MenuOrder
		</cfquery>
	
	 <cfoutput query="get">
	    
     <tr>
	 
	 	 <td width="4%" height="22" bgcolor="ffffff" align="right">
				
			     <button type="button" class="button3" onClick="selectnew('#url.frm#','#url.loc#','#SystemFunctionId#','topic')">
				 <img src="#SESSION.root#/Images/select4.gif" alt="" name="img4_#currentrow#" 
					  onMouseOver="document.img4_#currentrow#.src='#SESSION.root#/Images/button.jpg';" 
					  onMouseOut="document.img4_#currentrow#.src='#SESSION.root#/Images/select4.gif';"
					  style="cursor: pointer;" alt="" align="middle" >
				  </button>		  
						
		 </td>
			
		 <td width="3%" bgcolor="ffffff" align="right"></td>
		
    	 <TD class="labelit">#FunctionName#</TD>	
         <TD class="labelit">#FunctionMemo#</TD>
		 <TD class="labelit">Topic</TD>
      </TR>
	  <tr><td height="1" colspan="5" class="linedotted"></td></tr>
	 
    </CFOUTPUT>
	  
	<cfquery name="SearchResult" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT U.*, R.*, L.TemplateReport, L.LayoutName, S.Description
		FROM  UserReport U,
		      Ref_ReportControlLayout L,
		      Ref_ReportControl R, 
		      Ref_SystemModule S
		WHERE U.LayoutId    = L.LayoutId
		AND   L.ControlId   = R.ControlId
		AND   R.SystemModule = S.SystemModule
		AND   U.Account = '#SESSION.acc#'
		AND   L.Operational = '1'
		AND   S.Operational = '1'
		AND   L.Dashboard = 1
		AND   U.Status NOT IN ('5','6')
		AND   U.ReportId NOT IN (SELECT DISTINCT ReportId
		                            FROM          UserDashBoard
        		                    WHERE      Account = '#SESSION.acc#' 
									AND ReportId IS NOT NULL)
		ORDER BY R.SystemModule, R.MenuClass, R.FunctionName, U.DateExpiration
	</cfquery>
	
	<cfoutput query="SearchResult">
	
	 <cfif Operational eq "1">
		
			<cfinvoke component="Service.AccessReport"  
		          method="report"  
				  ControlId="#ControlId#" 
				  returnvariable="access">
				  
				<cfif access is "GRANTED">
								
					  <cfset color = "ffffff">
					  <cfset color1 = "f4f4f4">
									
				<cfelse>
				    <cfset color = "FAD5CB">
					<cfset color1 = "FAD5CB">
				</cfif>	  
			
	 <cfelse>
			
				   <cfset access = "DIS">
				   <cfset color = "silver">
				   <cfset color1 = "silver">
					
	 </cfif>
	 
	 <cfquery name="criteria" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT U.CriteriaName, 
			    count(U.CriteriaName) as Counted, 
				Max(U.CriteriaValue) as CriteriaValue,
				Max(U.CriteriaValueDisplay) as CriteriaValueDisplay 
		     FROM  UserReportCriteria U
			 WHERE U.ReportId = '#ReportId#' 
			 AND   U.CriteriaName IN (SELECT CriteriaName 
			                          FROM Ref_ReportControlCriteria
									  WHERE ControlId = '#ControlId#') 
			 GROUP BY U.CriteriaName
			 ORDER BY U.CriteriaName
     </cfquery>
	
	 <tr bgcolor="#color#">
	 
	 	 <td width="4%" rowspan="#criteria.recordcount+1#" height="25" bgcolor="ffffff" align="right">
				
				<cf_img icon="open"	onClick="javascript: selectnew('#url.frm#','#url.loc#','#ReportId#','report')">
				
		 </td>
			
		 <td width="3%" bgcolor="ffffff" align="right"></td>
		
    	 <TD class="labelit">#LayoutName#</TD>	
         <TD class="labelit">#DistributionSubject#</TD>
		 <TD class="labelit">Report</TD>
		 
      </TR>			 
			 <cfloop query="criteria">
			 
			 <tr>
				 <td></td>
				 <td colspan="3" bgcolor="f9f9f9">
				 <table cellspacing="0" cellpadding="0" class="formpadding">
				 	<tr>
					 <td width="150" align="right" class="labelit">#CriteriaName#:</td>
					 <td class="labelit">
					 <b>
					 <cfif Find(",","#CriteriaValue#")>Multiple...
					 <cfelseif counted gt "1">Multiple...
					 <cfelse>
					 	<cfif CriteriaValueDisplay neq "">#CriteriaValueDisplay#
						<cfelse>#CriteriaValue#
						</cfif>
					 </cfif> 
					 </td>
					 </tr>
				 </table>
				 </td>
			  </tr>
			 
			 </cfloop>
	  
	  <tr><td height="1" colspan="6" class="linedotted"></td></tr>	
	
	</CFOUTPUT>
			   	  
</table> 
</td>
</tr> 

</TABLE>

