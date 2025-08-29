<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="DisplayPeriod" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Period 
	WHERE  Period = '#URL.Period#'
 </cfquery>
 
<cfparam name="URL.Text" default="None">

<!--- default is today --->		
<cfset cur = now()>	
<cfset DateFilter    = "O.ProgressStatusDate <= '#DateFormat(now(),CLIENT.DateSQL)#'">		
 			
<cfset dts = DisplayPeriod.DateEffective>
<cfset dte = DisplayPeriod.DateExpiration>
<cfset c = 0>
 
<cfloop condition="#dts# lt #dte#">
	
	<cfset check = #dts# + #daysinmonth(dts)# -1>
	<cfset text = "#DaysInMonth(check)# #left(MonthAsString(Month(check)),'3')# #dateformat(check,'yy')#">
	<cfif text eq URL.Text>
		 <cfset DateFilter    = "O.ProgressStatusDate <= '#DateFormat(check,CLIENT.DateSQL)#'">	
	 <cfset cur = #check#>
	</cfif>
	<cfset dts = #dts# + #daysinmonth(dts)#>
							
</cfloop>
  
 <cfparam name="ProgramFilter" default="O.ProgramCode = '#URL.ProgramCode#'">
 <cfparam name="UnitFilter" default="">
 <cfparam name="DateFilter" default="">
 <cfparam name="FileNo" default="">
  
 <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#LastProgress#FileNo#"> 
 <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Output#FileNo#"> 
 <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Status#FileNo#"> 
  
 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Progress#FileNo#"> 
 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ProgressAll#FileNo#"> 
 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#OutputAll#FileNo#"> 
 
 <!--- define output progress for all activities of project and subproject --->
      
	<cfquery name="RolledUpProgress"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT    Pr.ProgramCode AS ProjectCode, Pr.*
		INTO 	  userQuery.dbo.#SESSION.acc#ProgressAll#FileNo#
		FROM      ProgramActivityProgress Pr, ProgramPeriod Pe
		WHERE     Pr.ProgramCode = '#URL.ProgramCode#' 
		AND       Pe.ProgramCode = Pr.ProgramCode
		AND       Pr.RecordStatus != '9'
		AND       Pe.RecordStatus  != '9'
		AND       Pe.Period = '#URL.Period#'
	
		UNION ALL
		SELECT    PeriodParentCode AS ProjectCode, PA.*
		FROM      ProgramActivityProgress PA, Program P, ProgramPeriod Pe
		WHERE     PA.ProgramCode   = P.ProgramCode 
		AND       P.ProgramClass   = 'Project'
		AND       Pe.ProgramCode   = P.ProgramCode
		AND       PA.RecordStatus  != '9' 
		AND       Pe.RecordStatus  != '9'
		AND       Pe.PeriodParentCode = '#URL.ProgramCode#'
		AND       Pe.Period         = '#URL.Period#'
		ORDER BY ProjectCode 
	</cfquery>
	
	<cfquery name="RolledUpOutput"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
	    SELECT    O.ProgramCode AS ProjectCode, O.*
		INTO 	  userQuery.dbo.#SESSION.acc#OutputAll#FileNo#
		FROM      ProgramActivityOutput O, 
		          ProgramPeriod Pe
		WHERE     O.ProgramCode = '#URL.ProgramCode#' 
		AND       Pe.ProgramCode = O.ProgramCode
		AND       O.RecordStatus  != '9'
		AND       Pe.RecordStatus != '9' 
		AND       Pe.Period = '#URL.Period#'
	
		UNION ALL
		
		SELECT    DISTINCT PeriodParentCode AS ProjectCode, O.*
		FROM      ProgramActivityOutput O, 
		          ProgramPeriod Pe,
		          Program P
		WHERE     O.ProgramCode       = P.ProgramCode 
		AND       Pe.ProgramCode      = P.ProgramCode
		AND       Pe.Period           = '#URL.Period#'
		AND       P.ProgramClass      = 'Project'
		AND       O.RecordStatus     != '9' 
		AND       Pe.RecordStatus    != '9' 
		AND       Pe.PeriodParentCode = '#URL.ProgramCode#'
		ORDER BY  ProjectCode 
		
	</cfquery>
  		
    <!--- define last reported output progress per output --->

    <cfquery name="LastOutput" 
     datasource="AppsQuery" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 
		 SELECT   DISTINCT O.OutputId, MAX(O.Created) AS LastSubmitted 
		 INTO     userQuery.dbo.#SESSION.acc#LastProgress#FileNo#
		 FROM     userQuery.dbo.#SESSION.acc#ProgressAll#FileNo# O 
		  <cfif DateFilter neq "">
		 WHERE #preserveSingleQuotes(DateFilter)# 
		 </cfif> 
		 GROUP BY O.OutputId 
		 
    </cfquery>
		
     <!--- retrieve valid output + status--->	
     <cfquery name="OutputStatus" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 
		 SELECT DISTINCT Pr.ProjectCode as ProgramCode, 
		                 PA.ActivityId, 
						 Pr.OutputId, 
						 Pr.ProgressStatus, 
						 Last.LastSubmitted
		 INTO     userQuery.dbo.#SESSION.acc#Output#FileNo#
		 FROM     userQuery.dbo.#SESSION.acc#ProgressAll#FileNo# Pr INNER JOIN
	              userQuery.dbo.#SESSION.acc#LastProgress#FileNo# Last ON Pr.OutputId = Last.OutputId AND Pr.Created = Last.LastSubmitted INNER JOIN
	              ProgramActivityOutput PO ON Pr.ProgramCode = PO.ProgramCode AND Pr.OutputId = PO.OutputId INNER JOIN
	              ProgramActivity PA ON PO.ActivityId = PA.ActivityId AND PO.ActivityId = PA.ActivityId AND PO.ProgramCode = PA.ProgramCode
	     WHERE  PO.RecordStatus <> '9' 
		   AND  PA.RecordStatus <> '9'
		   
	 </cfquery>
		 
	 <!--- complement records for not reported output at that moment --->
	 
	 <!--- retrieve valid output + status--->	
     <cfquery name="OutputStatus" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 
	 INSERT INTO userQuery.dbo.#SESSION.acc#Output#FileNo#
	 (ProgramCode, ActivityId, OutputId, ProgressStatus)
	 SELECT DISTINCT O.ProgramCode, 
	                 PA.ActivityId, 
					 O.OutputId, 
					 '0' 
	 FROM     userQuery.dbo.#SESSION.acc#OutputAll#FileNo# O, 
	          ProgramActivity PA 
	 WHERE    O.ActivityId   = PA.ActivityId
	 AND      PA.RecordStatus != '9'
	 <cfif DateFilter neq "">
	 AND 	  ActivityOutputDate <= #cur# 
	 </cfif>       
	 AND      O.OutputId NOT IN (SELECT OutputId 
	                              FROM   userQuery.dbo.#SESSION.acc#LastProgress#FileNo#
								  WHERE  OutputId = O.OutputId)
							   
     </cfquery>
	 
	  <!--- make a subtable for each status --->
	 
	 <cfquery name="Chart" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT    S.Status, 
	           S.Description, 
			   count(OutputId) as Total
	 FROM      Ref_Status S LEFT OUTER JOIN 
	           userQuery.dbo.#SESSION.acc#Output#FileNo# O ON O.ProgressStatus = S.Status			   
	 WHERE     S.ClassStatus = 'Progress'	 
	 GROUP BY  S.Status, S.Description
	 </cfquery>
	 
	 <cfquery name="Check" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT    count(OutputId) as Total
	 FROM      Ref_Status S LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#Output#FileNo# O ON O.ProgressStatus = S.Status
	 WHERE     ClassStatus = 'Progress'	 
	 </cfquery>
		 
	 <table width="99%" align="center" class="formpadding">
	 
	 <cfoutput>
	 <tr>
	    <td colspan="2" style="padding-left:10px" bgcolor="DAF3F8" class="labelmedium"><cf_tl id="Status of current Project output as per due date"> #dateFormat(cur, CLIENT.DateFormatShow)#</td>
	 </tr>
	 <tr><td height="4"></td></tr>
	 </cfoutput>
	 	 
	 <cfif Check.total eq "0">
	 
	 <tr>
	    <td colspan="2" align="center">&nbsp;</td>
	 </tr>
	 
	 <tr>
	    <td colspan="2" align="center" class="labelit"><b><font color="FF0000"><cf_tl id="No milestone due or reported"></font></b></td>
	 </tr>
	 
	 <cfabort>
	 
	 <cfelse>
	 	 
	 <tr><td width="130" valign="top">
	 
		 <table width="100%" cellspacing="0" cellpadding="0">
						
		 <tr><td>
			 
		 <cfchart
	       format="png"
	       chartheight="200"
	       chartwidth="200"
	       showygridlines="yes"
	       seriesplacement="default"
	       labelformat="number"
		   showlegend="yes"
		   backgroundcolor="ffffff"
		   showborder="no"
		   
	       show3d="no"
		   fontsize="9"
		   font="Verdana"
		   
		   pieslicestyle="solid"
		   showxgridlines="yes"
	       sortxaxis="no"
	       xAxisTitle="Status"
		   yAxisTitle="Projects">
		 
		   <cfchartseries
	        type="pie"
	        query="Chart"
	        itemcolumn="Description"
	        valuecolumn="Total"
	        serieslabel="Output status"
	        paintstyle="light"
	        markerstyle="circle"/> 
										 
		 </cfchart>
		 
				 
		 </td></tr>
		 
		 <!--- check what to show --->
		 
		 <cfquery name="Sub" 
	     datasource="AppsQuery" 
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT   distinct P.ProgramCode, P.ProgramName
		 FROM     userQuery.dbo.#SESSION.acc#OutputAll#FileNo# O,
			      Program.dbo.Program P
		 WHERE    O.ProgramCode = P.ProgramCode		
		 </cfquery>
		 
		 <cfif Sub.recordcount gt "1">
		 		 
				 <!--- subprojects --->
				 												  
				 <cfoutput query="Sub">
				 
					  <cfquery name="Chart" 
			     		datasource="AppsProgram" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						 SELECT    S.Status, 
						           S.Description, 
								   count(OutputId) as Total
						 FROM      Ref_Status S LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#Output#FileNo# O ON 
						           O.ProgressStatus = S.Status
						     AND   O.ProgramCode = '#ProgramCode#'
						 WHERE     ClassStatus = 'Progress'						 
						 GROUP BY S.Status, S.Description 
					  </cfquery>
					  
					     <cfquery name="Checking"
        		          dbtype="query">
       					  SELECT    *
						  FROM      Chart
						  WHERE     Total > 0
						</cfquery>
					  					  
						 <cfif Checking.recordcount gt "0">
						 
						 	<tr><td height="1" colspan="5" class="line"></td></tr>			 
						     <tr><td align="center" bgcolor="ffffef">&nbsp;#ProgramName#</td></tr>
							 <tr><td height="1" colspan="5" class="line"></td></tr>
					 
							 <tr><td>
																  					  				  
							  <cfinclude template="ProgressDrillDetailPie.cfm">
							
							</td></tr>
							
					  </cfif>	
				  
				 </cfoutput>
		 
		 <cfelse>		 

				 <!--- clustered overall --->
						 
				 <cfquery name="Cluster" 
			     datasource="AppsProgram" 
		    	 username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     ProgramActivityCluster O
				 WHERE    #preserveSingleQuotes(ProgramFilter)#		
				 ORDER BY ListingOrder
				  </cfquery>
				  
				 <cfoutput query="Cluster">
				 
					  <cfquery name="Chart" 
			     		datasource="AppsProgram" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						 SELECT    S.Status, 
						           S.Description, 
								   count(OutputId) as Total
						 FROM      Ref_Status S LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#Output#FileNo# O
						   ON      O.ProgressStatus = S.Status
						   AND     O.ActivityId IN (SELECT ActivityId 
						                            FROM ProgramActivity 
													WHERE ActivityClusterId = '#ActivityClusterId#')
						 WHERE     ClassStatus = 'Progress'
						 GROUP BY  S.Status, S.Description
					  </cfquery>
					  
					   <cfquery name="Checking"
        		          dbtype="query">
       					  SELECT  *
						  FROM    Chart
						  WHERE   Total > 0
						</cfquery>
					  					  
						 <cfif Checking.recordcount gt "0">
						 
						  <tr><td height="1" colspan="5" class="line"></td></tr>			 
				     		<tr><td align="center" class="labelit">#ClusterDescription#</td></tr>
							 <tr><td height="1" colspan="5" class="line"></td></tr>
							 <tr><td>					  					  				  
							  <cfinclude template="ProgressDrillDetailPie.cfm">							
							 </td></tr>
							
					  </cfif>		
					 
				 </cfoutput>
				 
		 </cfif> 		 
		 
		 </table>
		 
		 </td>
		
		 <td valign="top" style="border-left: 1px solid silver;">
		 
		 <cfquery name="Detail" 
	     datasource="AppsProgram" 
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT     PA.ProgramCode,
		            P.ProgramName, 
		            PA.ActivityId, 
					PO.OutputId, 
					PA.ActivityDescription, 
					PO.ActivityOutput, 
					PA.ActivityDateStart, 
					PA.ActivityDate, 
					R.Description, 
                    O.LastSubmitted, 
					R.Status, 
					CL.ClusterDescription, 
					CL.ListingOrder
					
		FROM        ProgramActivityOutput PO INNER JOIN
                    ProgramActivity PA ON PO.ActivityId = PA.ActivityId INNER JOIN
                    userQuery.dbo.#SESSION.acc#Output#FileNo# O ON PO.OutputId = O.OutputId INNER JOIN
                    Ref_Status R ON O.ProgressStatus = R.Status INNER JOIN
                    Program P ON PA.ProgramCode = P.ProgramCode LEFT OUTER JOIN
                    ProgramActivityCluster CL ON PA.ActivityClusterId = CL.ActivityClusterId					  			
		
		 WHERE      R.ClassStatus = 'Progress'
		
		 ORDER BY   PA.ProgramCode,
		            CL.ListingOrder, 
		            PA.ActivityDateStart, 
					PA.ActivityId 
		 </cfquery>
				 		 
		 <table width="96%" align="center" id="test">
		  			
			<cfoutput query="Detail" group="ListingOrder">	
			
				<cfif ListingOrder neq "">
				
				 <tr class="line">
				  <td colspan="5">
					  <table width="100%">
					    <tr class="labelmedium">
					      <td width="70%" style="font-size:25px">#ClusterDescription#</td>
					    </tr>					
				   	  </table>
				  </td>
				 </tr>
				 
				 </cfif>  
				 
				 <!---
				   <tr bgcolor="f4f4f4">
			 		 <td width="5%"></td>
					 <td width="5%" colspan="1"></td>
					 <td width="60%"><cf_tl id="MilestoneOutput"></td>
					 <td width="18%" colspan="1"><cf_tl id="Status"></td>
					 <td width="14%"><cf_tl id="Reported"></td>
				</tr>
				--->
								
			<cfoutput group="ActivityDateStart">
			
			<cfoutput group="ActivityId">
			 
			 <tr>
			  
			  <td colspan="5">
			  
			  <table width="97%" align="center">
			  
			    <cfif ProgramCode neq URL.ProgramCode>				
				<tr>
					<td bgcolor="ffffcf" style="height:30;padding-left:6px" colspan="2" class="labelmedium"><cf_tl id="Subproject">:#ProgramName#</td>
				</tr>				
				</cfif>
				
			    <tr class="line labelmedium">
			      <td width="70%">#ActivityDescription#</td>
				  <td align="right">#DateFormat(ActivityDateStart, CLIENT.DateFormatShow)# - #DateFormat(ActivityDate, CLIENT.DateFormatShow)#</td>
			    </tr>
							
		   	  </table>
			  
			  </td>
			  
			 </tr>
			
			 <cfoutput>
			 
			 <tr class="labelmedium">
			 	 <td style="width:20px;padding-left:20px">#CurrentRow#.</td> 
				 <td style="width:30px;padding-left:4px;padding-right:4px">
			  	     <cfif Status eq 0>
					     <cf_tl id="Not available" var="1">
					     <img src="#SESSION.root#/Images/alert_stop.gif" alt="#lt_text#" border="0" align="bottom">
					 <cfelseif Status eq 1>
					     <cf_tl id="Completed" var="1">
						 <img src="#SESSION.root#/Images/alert_good.gif" alt="#lt_text#" border="0" align="bottom">
					 <cfelseif Status eq 2>
					     <cf_tl id="Pending" var="1">
						 <img src="#SESSION.root#/Images/alert_caution.gif" alt="#lt_text#" border="0" align="bottom">
					 <cfelse>
					     <cf_tl id="Not reported" var="1">
						 <img src="#SESSION.root#/Images/alert_caution.gif" alt="#lt_text#" border="0" align="bottom">
					 </cfif>
			  	</td>		 
			  	<td width="70%">#ActivityOutput#</td>
			  	<td width="80">#Description#</td>
			  	<td width="60" style="padding-right:15px">#DateFormat(LastSubmitted, CLIENT.DateFormatShow)#</td>
			 </tr>
			
			</cfoutput>
			
			<tr><td height="1" colspan="5" class="linedotted"></td></tr>
		
			</cfoutput>
			</cfoutput>
			</cfoutput>
			
		</cfif>
						  
	     </table>
		 		 
	 </td>
	 </tr>
	 </table>		 
	 				 
	 <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#LastProgress#FileNo#"> 
	 <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Output#FileNo#"> 
	 <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Status#FileNo#"> 
	 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ProgressAll#FileNo#"> 
	 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#OutputAll#FileNo#">		 			
					