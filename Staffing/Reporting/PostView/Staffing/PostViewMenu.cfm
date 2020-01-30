	  			
<table width="100%" align="center">
	
	<cfoutput>
	
	
	<tr>
	
	<!---
	<td width="220" class="labelit" style="height:30px;padding-left:20px">	
	 #url.mandate#: #dateformat(mandate.dateeffective,CLIENT.DateFormatShow)# - #dateformat(mandate.dateexpiration,CLIENT.DateFormatShow)#&nbsp;&nbsp;&nbsp;|	 
	</td>
	--->
	
	<td class="labelmedium">
		
			<table class="formpadding">
			<tr class="labelit">
			
			<cfif maintain neq "NONE">	
			
				<td>		
				<cf_tl id="Workforce maintenance" var="1">
				&nbsp;
				<a href="javascript:maintain()" title="Maintain Workforce table">#lt_text#<img style="vertical-align:middle;top:-1px;position: relative;" src="#SESSION.root#/Images/Maintenance.png"  align="absmiddle" alt="" border="0" height="24" width="24"></a>	
				&nbsp;			
				</td>
			
			</cfif>
			
			<!--- determine global access to the inquiry functions of the staffing table --->
			
			<cfinvoke component = "Service.Access"  
			   method           = "RoleAccess" 
			   mission          = "#url.mission#" 
			   anyunit          = "No"			 
			   Role             = "'HRInquiry'"
			   returnvariable   = "inquiryaccess">			
			
			<cfif maintain neq "NONE" or inquiryaccess eq "GRANTED">	
				
				<!---		
				<cfif CGI.HTTPS eq "off">
				--->
				
					<td>|</td>
				
					<td style="padding-left:5px">
			
					<cfinvoke component="Service.Analysis.CrossTab"  
									  method      = "ShowInquiry"
									  buttonName  = "Analysis"
									  buttonClass = "variable"		  
									  buttonIcon  = "#SESSION.root#/Images/dataset.png"					  
									  buttonStyle = "height:29px;width:120px;"
									  reportPath  = "Staffing\Reporting\PostView\Staffing\"
									  SQLtemplate = "FactTableMission.cfm"
									  queryString = "Mission=#URL.Mission#&Sel=#dt#"
									  dataSource  = "appsQuery" 
									  module      = "Staffing"
									  reportName  = "Facttable: Staffing Table Inquiry"
									  olap        = "1"
									  target      = "analyse"
									  table1Name  = "Positions"
									  table2Name  = "Assignments"
									  table3Name  = "Vacancy"
									  filter      = "1"
									  returnvariable = "script"> 	
					
					<cf_tl id="Extended Analysis" var="1">
					&nbsp;		
					<a href="javascript:#script#" title="Review Workforce Structure.">#lt_text#<img style="vertical-align:middle;top:-1px;position: relative;" src="#SESSION.root#/Images/Analyze.png" align="absmiddle" alt="" border="0" height="24" width="24"></a>	
					&nbsp;	
					
					</td>
				
				<!---				
				</cfif>
				--->
								
				<td>|</td>
				
				<td style="padding-left:5px">
					<cf_tl id="Org Chart" var="1">	
					
					&nbsp;
					<a href="javascript:treeview('#URL.Mission#','#url.mandate#','#url.tree#')" title="Review Workforce Structure in grahical representation.">#lt_text#<img style="vertical-align:middle;top:-1px;position: relative;" src="#SESSION.root#/Images/Logos/Staffing/OrgUnit.png" align="absmiddle" alt="" border="0" height="24" width="24"></a>	
					&nbsp;	
				
				</td>
			
			</cfif>	
			
			</tr>			
			
			</table>	
			
	</td>		
	
	<td class="labelit" align="right" style="padding-right:20px">
	    <a href="javascript:refresh()" title="Review Workforce Structure in grahical representation."><u><cf_tl id="Refresh Matrix"></a>	
	</td>
	
	</cfoutput>
		
</tr>

</table>