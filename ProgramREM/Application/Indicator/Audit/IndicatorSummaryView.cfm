<cfparam name="managerAccess" default="NONE">

<cfset col = 3+(Milestones.recordcount*2)-1>		

<cfset list = "">

<cfloop query="Milestones">
  
   <cfif AuditDate lt now()>
       <cfset show[milestone] = "1">
   <cfelse>
       <cfset show[milestone] = "0">
   </cfif>
    
   <cfif list eq "">
      <cfset list = "#milestone#">
   <cfelse>
      <cfset list = "#list#,#milestone#">
   </cfif>
   
</cfloop> 

<cfquery name="Period"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">			  
	SELECT * 
	FROM   Ref_Period
	WHERE  Period = '#URL.Period#'
</cfquery>

<cfquery name="Param" 
datasource="AppsProgram"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterMission
	WHERE     Mission = '#url.id2#' 
</cfquery>	

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">

<cfif url.mode eq "Print">

<title><cf_tl id="Print Score Card"></title>

<tr class="noprint"><td colspan="<cfoutput>#col#</cfoutput>" bgcolor="f4f4f4" height="40" align="center">
	
			<cfoutput>		
	
				<button name="Print" class="button10g"
				onclick="window.print()"
				value="Graph" style="height:28px;width:150px">
					<img src="#SESSION.root#/Images/print.gif" align="absmiddle" alt="Edit" border="0">&nbsp;&nbsp;<cf_tl id="Print">
				</button>	
				
			</cfoutput>		
				
	</td></tr>
</cfif>		
 	 
<tr><td colspan="3">

	<table class="navigation_table" width="100%" border="0" cellspacing="0" cellpadding="0">	
		
	<cfoutput>
	
	<tr>
	<td colspan="3" class="labellarge" style="height:34;padding-left:1px"><cfoutput>#Org.OrgUnitName#</cfoutput></td>
	<td colspan="<cfoutput>#col-3#</cfoutput>" align="right">
		<table width="400" cellspacing="0" cellpadding="0" align="right" class="formpadding">
		<tr class="labelit">
		<td width="15" bgcolor="E2FEE4" style="border: 1px solid black;">&nbsp;</td>
		<td>&nbsp;= <cf_tl id="On target"></td>
		<td width="15" bgcolor="FFAC59" style="border: 1px solid black;">&nbsp;</td>
		<td>&nbsp;= <cf_tl id="Within range"></td>
		<td width="15" bgcolor="FF8080" style="border: 1px solid black;">&nbsp;</td>
		<td>&nbsp;= <cf_tl id="Outside range"></td>
		</tr>
		</table>
	</td></tr>
		
	<tr class="linedotted"><td colspan="<cfoutput>#col#</cfoutput>" align="center"></td></tr>
	
	<tr>
	   
	   <td colspan="2" align="left" height="28" style="padding-left:10px">
	   
	    <table cellspacing="0" cellpadding="0"><tr>
		
		<cfinvoke component = "Service.Access"
			Method          = "indicator"
			OrgUnit         = "#Org.OrgUnit#"
			Role            = "ProgramAuditor"
			ReturnVariable  = "Access">
						
			<cfif URL.mode neq "print">
			
				<cfif Access eq "ALL" or Access eq "Edit">
					<td>		
					<button name="Graph" class="button10g"
					onclick="AuditProgramDates('#Present.TargetId#','#URL.Period#')" 
					value="Graph" style="height:23px;width:104px">
						<img src="#SESSION.root#/Images/edit2.gif" align="absmiddle" alt="Edit" border="0">&nbsp;<cf_tl id="Maintain">
					</button>
					</td>
				</cfif>
			
				<td style="padding-left:3px">		
				<button name="Print" class="button10g"
				onclick="printme()"
				value="Graph" style="height:23px;width:99px">
					<img src="#SESSION.root#/Images/print.gif" align="absmiddle" alt="Edit" border="0">&nbsp;&nbsp;<cf_tl id="Print">
				</button>
				</td>
		   		
				<td style="padding-left:3px">
				
		        <!--- button to show inquiry function --->
				<cfinvoke component="Service.Analysis.CrossTab"  
				  method="ShowInquiry"
				  buttonName  = "Inquiry"
				  buttonClass = "button10s"
				  buttonIcon  = "#SESSION.root#/Images/sqltable.gif"
				  buttonText  = "Excel"
				  buttonStyle = "height:23px;width:99px"
				  reportPath  = "ProgramREM\Application\Indicator\Audit\"
				  SQLtemplate = "IndicatorSummary.cfm"
				  queryString = "Mission=#URL.Mission#&Mandate=#URL.Mandate#&ID1=#URL.ID1#&Period=#URL.Period#&Mode=excel"
				  dataSource  = "appsQuery" 
				  module      = "Program"
				  reportName  = "HRAP_Export"
				  table1Name  = "Export file"
				  data        = "1"
				  filter      = "1"
				  olap        = "0" 
				  excel       = "1"> 			  
				</td>
			
			<cfelse>
			
			<td colspan="3"></td>
			
			</cfif>
			      
		    <!--- button to show inquiry function --->		  
		 			
			<cfquery name="Parameter"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				SELECT *
				FROM   Ref_ParameterMission
				WHERE  Mission = '#URL.Mission#'
			</cfquery>   
			
			<cfif Parameter.IndicatorOLAPTemplate neq "" and managerAccess neq "NONE">
			 		
			<!--- creates a link to a script to launch OLAP developed for NY --->				
			<td>		  
			<cfinvoke component="Service.Analysis.CrossTab"  
			  method      = "ShowInquiry"
			  buttonName  = "Inquiry"
			  buttonClass = "button10s"
			  buttonIcon  = "#SESSION.root#/Images/sqltable.gif"
			  buttonText  = "Analyse"
			  buttonStyle = "height:23px;width:84px"
			  reportPath  = "#Parameter.IndicatorOLAPTemplate#"
			  SQLtemplate = "IndicatorFactTable.cfm"
			  queryString = "Period=#URL.Period#"
			  dataSource  = "appsQuery" 
			  module      = "Program"
			  reportName  = "HRAP_Analysis"			 
			  data        = "1"
			  filter      = "1"
			  olap        = "1" 
			  excel       = "0"> 	
			 </td> 
			  
			</cfif>  		    			  
			
			</table>
	 
	   </td>
	  
	   <td width="7%" align="center" bgcolor="ffffcf"><cf_tl id="Target"></td>
	   
	   </cfoutput>
	   
	   <cfoutput query="Milestones">
	   
	   <cfif Milestone eq "Current">
	        <td width="6%" align="center" class="labelit" bgcolor="ffffcf">
	    <cfelse>
	   	    <td width="6%" align="center" class="labelit">
	   </cfif>	  
	   
	   #dateformat(Milestones.AuditDate, "MMM")#
	   <br>
	   #dateformat(Milestones.AuditDate, "YYYY")#
	  
	   </td>
	   
	   <!---
	   <cfif #milestones.currentRow# gt "1">
		   <td align="center" bgcolor="E9E9D1">
		   <cfif #milestones.currentrow# eq #milestones.recordcount#>
		   		Result
		   <cfelse>
			   Trend
		   </cfif>
		   </td>
	   </cfif>
	   --->
	   
	   </cfoutput>
	   
	</tr>
		
	<tr><td colspan="<cfoutput>#col#</cfoutput>" class="linedotted"></td></tr>
			 
	<tr><td style="height:30px;padding-left:10px" colspan="<cfoutput>#col#</cfoutput>">
	
	<cfparam name="ManagerAccess" default="NONE">
	
	<cfif ManagerAccess eq "NONE" or ManagerAccess eq "READ">
	      <cfset mode = "inquiry">
	<cfelse>   
	      <cfset mode = "edit">
	</cfif>
	<cfset URL.Org = "#URL.ID1#">
	
	<cfinclude template="IndicatorSummaryAttachment.cfm">
	
	</td></tr>
			
	<cfset cat = "0">
		
	<cfoutput query="Present" group="ProgramCategory">
	
	<cfset cat = cat+1>	
	
	<tr>
	<td colspan="#col#" class="labellarge" style="height:40px;padding-left:4px">
	
	<img src="#SESSION.root#/Images/ct_collapsed.gif"
	     alt="Expand"
	     id="l#cat#_collapse"
	     width="34"
	     height="17"
	     border="0"
	     class="hide"
		 align="absmiddle"
	     style="cursor: pointer;"
	     onClick="javascript:show('#cat#')">
	 
	<img src="#SESSION.root#/Images/ct_expanded.gif"
	     alt="Collapse"
	     id="l#cat#_expand"
	     width="34"
	     height="17"
	     border="0"
	     class="regular"
		 align="absmiddle"
	     style="cursor: pointer;"
	     onClick="javascript:show('#cat#')">
	
	<font color="0080FF"><a href="javascript:show('#cat#')">#CategoryDescription#</a></b>
	</td>
	</tr>	
		
	<cfoutput group="ProgramCode">
	
	<tr name="l#cat#" class="linedotted">
	<td colspan="#col#">
		
	<table width="100%" cellspacing="0" cellpadding="0" class="formspacing">
	<tr>
	
		<td class="labelmedium" style="font-size:21px;height:40px;padding-left:18px">
			<a href="javascript:AuditProgram('#ProgramCode#','#URL.Period#')"><font color="0080C0">#ProgramName#</a>
		</td>
		
		<td align="right">
		
			<cfif mode eq "edit">
			
				<img src="#SESSION.root#/Images/target.gif"
				     alt="maintain targets"
				     name="img2_#currentrow#"
				     id="img2_#currentrow#"
				     width="13"
				     height="14"
				     border="0"
				     align="absmiddle"
				     style="cursor: pointer;"
				     onClick="javascript:target('#ProgramCode#','#URL.Period#')"
				     onMouseOver="document.img2_#currentrow#.src='#SESSION.root#/Images/button.jpg'"
				     onMouseOut="document.img2_#currentrow#.src='#SESSION.root#/Images/target.gif'">
				 
			 </cfif>
			
			 <cfif Param.IndicatorAuditWorkflow eq "0">		
			 
				 <img src="#SESSION.root#/Images/audit.gif"
				     alt="edit"
				     name="img2_#currentrow#"
				     id="img2_#currentrow#"
				     width="15"
				     height="16"
				     border="0"
				     align="absmiddle"
				     style="cursor: pointer;"
				     onClick="javascript:AuditProgram('#ProgramCode#','#URL.Period#')"
				     onMouseOver="document.img2_#currentrow#.src='#SESSION.root#/Images/button.jpg'"
				     onMouseOut="document.img2_#currentrow#.src='#SESSION.root#/Images/audit.gif'">
			
			 </cfif> 		
		 
		 </td>
	 </tr>
	 </table>	
				
	</td>
	</tr>	
				
	<cfoutput group="LocationCode">
	
	<cfif LocationName neq "">
		<tr name="l#cat#">
		 <td colspan="#col#" class="labelit" style="padding-left:8px" bgcolor="f4f4f4">#LocationName#</td>
		</tr>	
	</cfif>	
	
	<cfoutput>
	
		<cfset p = "">
		<cfif IndicatorPrecision gt 0>
		  		<cfset p = ".">
		</cfif>
		<cfloop index="i" from="1" to="#IndicatorPrecision#" step="1">
		 <cfset p = #p#&"_">
		</cfloop> 
		
		<tr name="l#cat#" style="height:10px" class="navigation_row">
		
		  <td width="5%" align="center">
		  
			  <img src="#SESSION.root#/Images/icon_expand.gif" alt="See details" 
				id="#CurrentRow#Exp" border="0" class="show" 
				align="absmiddle" style="cursor: pointer;" 
				onClick="moredetail('#CurrentRow#','show','#TargetId#')">
				
				<img src="#SESSION.root#/Images/icon_collapse.gif" 
				id="#CurrentRow#Min" alt="Hide details" border="0"  
				align="absmiddle" class="hide" style="cursor: pointer;" 
				onClick="moredetail('#CurrentRow#','hide','#TargetId#')">
		 
		  </td>
		  
		  <td>
		  
			  <table width="100%" cellspacing="0" cellpadding="0">
				  <tr>
				  <td class="labelit">#IndicatorDescription#</td>
				  <td width="30" align="right">
				  			  
				  <cf_helpfile 
				        code     = "Program" 
						class    = "Indicator"
						id       = "#IndicatorCode#"
						name     = "#IndicatorDescription#"
						display  = "Icon"
						iconfile = "help5.gif"
						showText = "0">
				  
				  </td>
				  </tr>
			  </table>
		  
		  </td>
		  
		  <td bgcolor="ffffcf" align="center" class="labelit">
		       <cfparam name="Target_04" default="">
		       <cfparam name="Target_01" default="">
		       <cfset val = evaluate("Target_04")>
			   <cfif val neq "">
				<cfif IndicatorType eq "0002">
				#numberFormat(val*100,"__,__._")#%
				<cfelse>
				#numberFormat(val,"__,__#p#")#
				</cfif>
			   <cfelse>
				   <cfif Target_CurrentAlternate neq "">
				       <font color="0080C0">#Target_CurrentAlternate#</font>
				   <cfelse>
					   <font color="blue">N/AP</font>	
				   </cfif>	
			   </cfif>   
		  </td>
		  
		   <cfloop index="itm" list="#list#" delimiters=",">
		   
		    <cfif itm eq "Init">
			   <cfset tgt = "#evaluate('Target_01')#">
			<cfelseif itm eq "Current">
			   <cfset tgt = "#evaluate('Target_04')#"> 
			<cfelse>
			   <cfset tgt = "#evaluate('Target_#itm#')#">
			</cfif>   
					   
		    <cfset val = evaluate("Actual_#itm#")>
			<cfset sta = evaluate("Status_#itm#")>
			
			<cfif val eq "">
			
			      <cfset cl = "F4F4F4">
			
			<cfelse>
						  				
				<cfif tgt neq "">
			
				    <cfif TargetDirection eq "Up">
					
						 <cfif val gte tgt>
						     <cfset cl = "E2FEE4">
						 <cfelseif val gte tgt-(tgt*TargetRange/100)>
						     <cfset cl = "FFAC59">  
						 <cfelse>
						     <cfset cl = "FF8080"> 
						 </cfif>
						 
					<cfelseif TargetDirection eq "Down">
					
						 <cfif val lte tgt>
						     <cfset cl = "E2FEE4">
						 <cfelseif val lte tgt+(tgt*TargetRange/100)>  
						     <cfset cl = "FFAC59"> 
						 <cfelse>
						     <cfset cl = "FF8080"> 
					     </cfif>
						 
					<cfelse>
											
						 <cfif val lte tgt+(tgt*TargetRange/100) or val gte tgt-(tgt*TargetRange/100)>  
						     <!--- range --->
						     <cfset cl = "FFAC59"> 
						 <cfelse>
						     <!--- bad --->
						     <cfset cl = "FF8080"> 
					     </cfif>
							 
					</cfif>

				<cfelse>
				
						<cfset cl = "E2FEE4">	
				
				</cfif> 
			
			</cfif>			 					    
				<cfif val neq "">
				
				    <td align="center" bgcolor="#cl#" class="labelit">
			       					
					<cfif IndicatorType eq "0002">
						#numberFormat(val*100,"__,__._")#%
					<cfelse>
						#numberFormat(val,"__,__#p#")#
					</cfif>
					</td>
					
				<cfelse>				
								
					  <cfif Show[itm] eq "1">
					      <cfif sta eq "0" or sta eq "">						  
					      <td align="center" bgcolor="ffffef" class="labelit">						  
				          <font color="FF8080">
						      N/A
						  </font>	
						  </td>
						  <cfelse>
					      <td class="labelit" align="center" bgcolor="ffffef">
					      <font color="blue">
						      N/Ap
						  </font>	
						  </td>
						  </cfif>
					  <cfelse>
					      <td align="center"></td>	  
					  </cfif>
					  
			  	</cfif>
			</td>
			
			</cfloop> 
	    </tr>	
				
		<div name="l#cat#">	
		
		<tr id="e_#CurrentRow#a" class="hide">
		  <td colspan="#col#">
		  
	         <iframe name="i#CurrentRow#" 
			         id="i#CurrentRow#" 
					 width="100%" 
					 height="240" 
					 align="middle" 
					 scrolling="no" 
					 frameborder="0">
			 </iframe>
			 
		 </td>
		</tr>
		<tr id="e_#CurrentRow#b" class="hide">
			<td colspan="#col#"></td>
		</tr>
		
		</div>			
		
	 </cfoutput>
	 
	 </cfoutput>		
	 
	 </cfoutput>	
	 
	 </cfoutput>
	
	</table>	  

</td></tr>
</table>	  
