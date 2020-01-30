
<cfoutput>

<cf_screentop height="100%" jquery="Yes" title="Program Audit Tree View" html="No" scroll="Yes">

<cf_dialogStaffing>

	<script language="JavaScript">
	
	function distribution(id) {
		window.open("#SESSION.root#/System/Access/User/Audit/ListingReportDetail.cfm?drillid=" + id, id);
	}	
	
	function schedule(id) {
	    w = #CLIENT.width# - 100;
	    h = #CLIENT.height# - 32;
		window.open("#SESSION.root#/tools/cfreport/SubmenuReportView.cfm?source=library&id=" + id, id);
	}
	
	function listing(row,id) {
     		
	icM  = document.getElementById("d"+row+"Min");
    icE  = document.getElementById("d"+row+"Exp");
	se   = document.getElementById("d"+row);
		 		 
	if (se.className == "hide") {	 				
     	 icM.className = "regular";
	     icE.className = "hide";
		 se.className  = "regular";
		 ColdFusion.navigate('DistributionLogDetail.cfm?batchid=#URL.ID#&row=' + row + '&Id=' + id,'i'+row)
	 } else {	 	     
     	 icM.className = "hide";
	     icE.className = "regular";
     	 se.className  = "hide";		 	 
	 }
		 		
  }
  
  function recordedit(id1) {
         ptoken.open("../Reports/RecordEdit.cfm?ID=" + id1, "Edit", "left=40, top=15, width=1090, height=890, toolbar=no, status=yes, scrollbars=no, resizable=yes");
  }
	
</script>	
	
</cfoutput>

<cfquery name="Header" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM ReportBatchLog
   WHERE BatchId = '#URL.ID#'
</cfquery>

<cfquery name="Avg" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT Avg(AvgTimeEmail) as AvgTimeEmail
   FROM ReportBatchLog
</cfquery>

<cfquery name="Mode" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT     DistributionCategory, COUNT(*) AS Mode
	FROM         UserReportDistribution
	WHERE BatchId = '#URL.ID#'
	AND  DistributionStatus = '1'
	AND  DistributionCategory != 'ERROR'
	GROUP BY DistributionCategory
</cfquery>

<cfquery name="Failed" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT     M.Description, R.FunctionName, RL.LayOutName, 
	           U.DistributionName, U.ReportId, R.ControlId,
			   U.DistributionEMail
	FROM       UserReportDistribution UR INNER JOIN
               UserReport U ON UR.ReportId = U.ReportId INNER JOIN
               Ref_ReportControlLayout RL ON U.LayoutId = RL.LayoutId INNER JOIN
               Ref_ReportControl R ON RL.ControlId = R.ControlId INNER JOIN
               Ref_SystemModule M ON R.SystemModule = M.SystemModule
	WHERE      UR.DistributionStatus  = '9'
	AND        UR.BatchId = '#URL.ID#'
	ORDER BY M.Description, R.FunctionName, RL.LayOutName, U.DistributionName
</cfquery>

<cfquery name="Module" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT     M.Description, COUNT(*) AS Module
   FROM       UserReportDistribution D INNER JOIN
              UserReport UR ON D.ReportId = UR.ReportId INNER JOIN
              Ref_ReportControlLayout RL ON UR.LayoutId = RL.LayoutId INNER JOIN
              Ref_ReportControl R ON RL.ControlId = R.ControlId INNER JOIN
              Ref_SystemModule M ON R.SystemModule = M.SystemModule
   WHERE BatchId = '#URL.ID#'		  
   AND       DistributionStatus = '1'  
   GROUP BY M.Description
</cfquery>   

<cfquery name="Log" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     M.Description, R.FunctionName, RL.LayOutName, RL.LayoutId, R.ControlId,
           RL.TemplateReport, COUNT(*) AS Prepared
FROM         UserReportDistribution UR INNER JOIN
                      UserReport U ON UR.ReportId = U.ReportId INNER JOIN
                      Ref_ReportControlLayout RL ON U.LayoutId = RL.LayoutId INNER JOIN
                      Ref_ReportControl R ON RL.ControlId = R.ControlId INNER JOIN
                      Ref_SystemModule M ON R.SystemModule = M.SystemModule
WHERE     (UR.DistributionCategory <> 'ERROR')
AND       BatchId = '#URL.ID#'
AND       DistributionStatus = '1'
GROUP BY M.Description,
         R.FunctionName, 
		 RL.LayOutName, 
		 RL.TemplateReport, 
		 RL.LayoutId, 
		 R.ControlId
</cfquery>

<cfoutput query="Header">

<cfif ProcessEnd neq "">
	<cfset sec = (ProcessEnd-ProcessStart)>
	<cfset sec = int(sec*24*60*60)>
	<cfif sec gt "60">
	   <cfset min = sec/60>
	<cfelse>
	   <cfset min = "0">   
	</cfif>
<cfelse>
    <cfset sec = "0">
	<cfset min = "0">   
</cfif>

<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

 <tr><td height="4"></td></tr>
 
 <tr class="line">
	 <td height="42" style="font-size:24px;font-weight:200" colspan="2">Reporter Log for : <b>#DateFormat(Created, "DDDD, DD-MM-YYYY")#</b></td>  
 </tr> 
 <tr class="line labelmedium">
   <td width="160">Server IP:</td>
   <td width="80%">#OfficerUserId#</td>
 </tr>  
 <tr class="line labelmedium">
   <td>Batch status:</td>
   <td><cfif ProcessStatus eq "Empty"><font color="red">Empty batch<cfelse><font color="408080"><b>#ProcessClass# #ProcessStatus#</cfif></td>
 </tr>
 <tr class="line labelmedium">
   <td height="20">Process period:</td>
   <td>from: <b>#TimeFormat(ProcessStart,"HH:MM:SS")#</b> - until: <b>#TimeFormat(ProcessEnd,"HH:MM:SS")#</b></td>
 </tr>
 <tr class="line labelmedium">  
   <td>Duration</td>
   <td><cfif min neq "0"><b>#int(min)#</b> minutes<cfelse><b>#sec#</b> second(s)</cfif></td>   
 </tr>
   
 <cfset sent = EMailSent - Failed.recordcount>
  
 <tr class="line labelmedium">  
   <td>No of eMail sent:</td>
   <td><b>#Sent#</b> message(s) successfully delivered to CF defined mail engine</td>
 </tr>
 
 <cfif sent gt "0">
 
 <tr class="line labelmedium">  
   <td>Average time per eMail</td>
   <td><b>#numberformat(sec/Sent,"__,_._")#&nbsp;</b><cfif #numberformat(sec/Sent,"__,_._")# eq "1">second<cfelse>seconds</cfif>
   &nbsp;[System average : #numberformat(Avg.AvgTimeEmail,"__,_._")# seconds]
   </td>
 </tr>

 </cfif>
  
 </cfoutput>
 
 <cfif Header.ProcessStatus neq "Empty">
 
 <tr class="line">  
   <td height="20" class="labelmedium" valign="top" style="padding-top:3px">Total by format:</td>
   <td>    
	<table width="100%" >
	<cfoutput query="Mode">
 		 <tr class="labelmedium">  
		   <td width="150">#DistributionCategory#</td>
		   <td>#Mode#</td>
		 </tr>
		  <cfif Mode.recordcount neq "#CurrentRow#">
		 <tr class="line"><td height="1" colspan="2"></td></tr>
		 </cfif>
	</cfoutput>	 
	</table>	    
   </td>   
 </tr>
  
 <tr class="line labelmedium">  
   <td height="20" valign="top" style="padding-top:3px">Total by module:</td>
   <td>
    
	<table width="100%">
	<cfoutput query="Module">
 		 <tr>  
		   <td class="labelmedium" width="150">#Description#</td>
		   <td class="labelmedium">#Module#</td>
		 </tr>
		 <cfif Module.recordcount neq "#CurrentRow#">
		 <tr class="line"><td height="1" colspan="2"></td></tr>
		 </cfif>
	</cfoutput>	 
	</table>	 
   
   </td>   
 </tr>
  
 <cfoutput>
 
 <tr class="line labelmedium">  
   <td height="20">Preparation failed for:</td>
   <td class="labelmedium"><cfif Failed.recordcount gt "0"><b>
   <img src="#SESSION.root#/Images/caution.gif" alt=""  border="0">
   <font color="FF0000">#Failed.recordcount#</b> report variants!<cfelse>None</cfif></td>
 </tr>
 
 </cfoutput>
 
 <cfif Failed.recordcount gt "0">
 
 <tr>  
   <td colspan="2" class="labellarge"><font size="3" color="FF0000">Error log</td>
 </tr>

 <tr>  
   <td height="20" colspan="2"> <table width="100%">
        <cfoutput query="Failed" group="Description">
		
         <tr class="line labelmedium"><td colspan="4" height="20"><b>#Description#</td></tr>
				 
		 <cfoutput>
 		 <tr class="labelmedium line">  
		   <td style="padding-left:3px">
		   
		  <cfinvoke component="Service.AccessReport"  
	          method="editreport"  
			  ControlId="#ControlId#" 
			  returnvariable="access">
		  
		  <cfif Access eq "EDIT" or Access eq "ALL">
		  
		  	<cf_img icon="open" onClick="schedule('#reportid#')">
				  
		  </cfif>
				  
		   </td> 
		   <td style="padding-left:4px">
		   <cfif Access eq "EDIT" or Access eq "ALL">
		       <a href="javascript:recordedit('#ControlId#')">#FunctionName#</a>
		   <cfelse>
		       #FunctionName#
		   </cfif>
		   </td>
		   <td>#LayoutName#</td>
		   <td>#DistributionName#</td>
		   <td>#DistributioneMail#</td>
		 </tr>
		
		 </cfoutput>
		 
	  </cfoutput>	
	  </table> 
   
   </td>
 </tr>
 </cfif> 
 
 <tr>  
   <td colspan="2" class="labelmedium" style="height:50px;font-size:26px;font-weight:200">Distribution details</td>
 </tr> 
 
 <tr>  
   <td colspan="2"> <table width="100%" cellspacing="0" cellpadding="0" border="0">
   
        <cfoutput query="Log" group="Description">
		
         <tr class="line labelmedium"><td colspan="5" style="height:35px;font-size:20px;font-weight:200">#Description#</td></tr>
		 
		 <cfoutput>		
		 
 		 <tr class="line labelmedium">  
		 
		   <td height="20" align="center" style="width:30px;padding-top:2px">
		   
			  <cfinvoke component="Service.AccessReport"  
		          method="editreport"  
				  ControlId="#ControlId#" 
				  returnvariable="access">
			  
			  <cfif Access eq "EDIT" or Access eq "ALL">
			  
				   	<img src="#SESSION.root#/Images/arrowright.gif" alt="Show reports" 
						name="d#currentrow#Exp" id="d#currentrow#Exp" 
						border="0" 
						align="absmiddle" class="regular" style="cursor: pointer;" 
						onClick="listing('#currentrow#','#LayoutName#')">
						 
					<img src="#SESSION.root#/Images/arrowdown.gif" 
						id="d#currentrow#Min" alt="Hide reports" border="0" 
						align="absmmiddle" class="hide" style="cursor: pointer;" 
						onClick="listing('#currentrow#','#LayoutName#')">					
					
			   </cfif>
		   		
		   </td> 
		   
		   <td>
		   
			   <cfif Access eq "EDIT" or Access eq "ALL">
			   
			       <a title="Report configuration" href="javascript:recordedit('#ControlId#')"><font color="0080C0">#FunctionName#</font></a>
				   
			   <cfelse>
			   
			       #FunctionName#
				   
			   </cfif>
		   
		   </td>
		   <td>#LayoutName#</td>
		   <td>#TemplateReport#</td>
		   <td>#Prepared#</td>
		 </tr>
		 
		 <tr class="hide" id="d#currentrow#">		 
			 <td colspan="5" style="padding-left:10px;padding-right:10px"><cfdiv id="i#currentrow#"></td>
		 </tr>		 
		 
		 </cfoutput>
		 
	  </cfoutput>	
	  
	  </table> 
   
   </td>
 </tr>
 
 </cfif>
  
</table>
