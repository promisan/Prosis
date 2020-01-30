
<cfquery name="Variant" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	SELECT     R.SystemModule, R.FunctionClass, R.FunctionName, R.MenuClass, R.FunctionMemo, RL.LayOutName, 
	           UP.* 
	FROM         UserReport UP INNER JOIN
	                      Ref_ReportControlLayout RL ON UP.LayoutId = RL.LayoutId INNER JOIN
	                      Ref_ReportControl R ON RL.ControlId = R.ControlId
	WHERE     (UP.Account = '#URL.ID#') AND (UP.Status IN ('0', '1'))
	ORDER BY R.SystemModule, R.FunctionClass
</cfquery>

	<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<tr>
	   <td colspan="2" style="height:50;font-weight:200;font-size:25px" class="labellarge">
			<cf_tl id="Report Variants set for this user">
       </td> 
	</tr>			
	
	<tr><td height="1" colspan="7" class="linedotted"></td></tr>
			
	<cfif Variant.recordcount eq "0">
	
		<tr>
		  <td colspan="2" height="45" align="center" style="padding-top:30" class="verdana">No subscriptions found</td>		 
		</tr>
		
	<cfelse>
	
		<tr>
		  <td width="20%" class="labelit">Module</td>
		  <td width="80%" class="labelit">Name</td>
		</tr>	
	
	</cfif>
		
	<cfoutput query="variant" group="SystemModule">
	
	<cfoutput group="FunctionName">
				
		<tr class="labelmedium line navigation_row">
		   <td>#SystemModule#</a></td>
		   <td>#FunctionName#</a></td>
		</tr>
		
		<cfoutput>
		
		<tr class="navigation_row">  
	    <td colspan="2">
	      <table width="100%" cellspacing="0" cellpadding="0">
	        
	 		 <tr class="labelmedium line">  
			   <td width="5%"></td>
			   <td width="5%" style="padding-top:1px">
			     <cf_img icon="edit" onClick="schedule('#reportid#')">
			   </td> 
			   <td width="25%">#DistributionSubject#</td>
			   <td width="30%"><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#DistributionName#</a></td>
			   <td width="15%">#NodeIP#</td>
			   <td width="10%">#FileFormat#</td>
			   <td width="10%">#DistributionPeriod#</td>
			 </tr>	 
							 
		  </table> 
	   </td>
	 </tr>
				
	</cfoutput>
		
	</cfoutput> 	
				
	</cfoutput> 
	
	</table>
	
	<cfset ajaxonload("doHighlight")>
	