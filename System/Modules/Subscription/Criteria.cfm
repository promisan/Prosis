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
<cfquery name="Report" 
 datasource="AppsSystem" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT U.ReportId, L.LayoutId, L.ControlId
 FROM  UserReport U, Ref_ReportControlLayout L 
 WHERE U.ReportId = '#URL.ID#' 
 AND  L.LayoutId = U.LayoutId
</cfquery>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Crit">

	<cfquery name="MakeTmpFile" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 INTO userQuery.dbo.#SESSION.acc#Crit
	 FROM  UserReportCriteria 
	 WHERE ReportId = '#URL.ID#' 
	</cfquery>

	<cfquery name="Criteria" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT R.CriteriaName, 
		        U.CriteriaValue, 
				U.CriteriaValueDisplay,
				U.CriteriaId,
				R.CriteriaDefault,
		        R.CriteriaDescription, 
				R.CriteriaDateRelative,
				R.CriteriaWidth, 
				R.CriteriaValues,
				R.CriteriaDatePeriod,
				LookupDataSource,
				LookupTable, 
				LookupFieldValue, 
				LookupFieldDisplay, 
				CriteriaType, 
				R.LookupMultiple, 
				U.Created
		 FROM   Ref_ReportControlCriteria R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#Crit U ON R.CriteriaName = U.CriteriaName  
		 WHERE  R.ControlId = '#Report.ControlId#' 	
		 ORDER BY CriteriaOrder
	</cfquery>
	
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Crit">

	<table width="100%" bgcolor="transparent">
	    
	  <tr>
	    <td width="100%" class="regular">
	    <table width="100%" align="center">
			
	    <TR class="fixrow">
		   <td height="20" width="20"></td>
		   <td width="19%" class="labelmedium2">Variant Parameter</b></td>
		   <td width="80%" class="labelmedium2">Selected Value</b></td>
		   <td></td>
	    </TR>	
				
		<tr><td colspan="6" class="line"></td></tr>
		
		<tr><td height="2" colspan="6"></td></tr>	
		
		<cfoutput query="Criteria">
		
		<cfif CriteriaValue neq "">  <!--- hide non selected value --->
				
		<TR>
		   
		   <td width="20"></td>
		   <td class="labelit" valign="top" style="padding-top:1px">#CriteriaDescription#</td>
		   <td class="labelit">
		  		  		   
		    <cfif CriteriaType eq "Date" and CriteriaDateRelative eq "1">
		
		       <b>#CriteriaValueDisplay#</b>
			   
			   <cfif CriteriaDatePeriod eq "1">
			   
			    <cfquery name="DateEnd" 
				 datasource="AppsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT *
				 FROM  UserReportCriteria 
				 WHERE ReportId = '#URL.ID#' 
				 AND   CriteriaName = '#criteriaName#_end'
				</cfquery>
		
		       - <b>#DateEnd.CriteriaValueDisplay#</b>
			   
			   </cfif>
			  			   
		   <cfelseif CriteriaType eq "Date" and CriteriaDatePeriod eq "1">
		
		       Between <b>#CriteriaValueDisplay#</b>
			  			  			   
			   <cfquery name="DateEnd" 
				 datasource="AppsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT *
				 FROM  UserReportCriteria 
				 WHERE ReportId = '#URL.ID#' 
				 AND   CriteriaName = '#criteriaName#_end'
				</cfquery>
				
				<cfif dateend.recordcount eq "1">
				
				and <b>#DateEnd.CriteriaValueDisplay#</b>
				
				</cfif>
				
			<cfelseif CriteriaType eq "Unit">
				        			   
			   <cfquery name="Org" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT *
				 FROM  Organization 
				 WHERE OrgUnit IN (#PreserveSingleQuotes(criteriavalue)#)				
				</cfquery>
								
				<cfif org.recordcount gte "1">
				
				<cfloop query="Org">
				- #Org.OrgUnitCode# #Org.OrgUnitName#<br>
				</cfloop>
				
				<cfelse>
				
				- #CriteriaValue#
				
				</cfif>	
				
			 <cfelseif CriteriaType eq "Text" and CriteriaDatePeriod eq "1">
		
		       - Range from <b>#CriteriaValue#</b> 	
			  			  			   
			   <cfquery name="DateEnd" 
				 datasource="AppsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT *
				 FROM  UserReportCriteria 
				 WHERE ReportId = '#URL.ID#' 
				 AND   CriteriaName = '#criteriaName#_end'
				</cfquery>
				
				<cfif dateend.recordcount eq "1">
				
				to <b>#DateEnd.CriteriaValue#</b>
				
				</cfif>				   	   
		   
		   <cfelseif CriteriaType neq "Lookup" and CriteriaType neq "Extended">
		   
		   	   - #CriteriaValue# <cfif CriteriaValue eq "">default:<i>#CriteriaDefault#</i></cfif>
					  		         
 		   <cfelse>
		   
		       <!--- lookup and extended retrieve from lookup table the values --->
		   
		       <table cellspacing="0" cellpadding="0" >
			 			 			   
			   <cfset filter = "">
			  
			   <cfloop index="itm" list="#CriteriaValue#" delimiters=",">
        	 	<cfif filter eq "">
		    		<cfset filter = "'#itm#'">
			 	<cfelse>
			    	<cfset filter = "#filter#,'#itm#'">
			 	</cfif>
			   </cfloop>
			  			   
			   <cfif filter neq "">
			   
			       <cfset Crit = replaceNoCase("#CriteriaValues#", "@userid", "#SESSION.acc#" , "ALL")>
				   
				   <cfif FindNoCase("WHERE", "#preserveSingleQuotes(Crit)#") 
				         and FindNoCase("ORDER BY", "#preserveSingleQuotes(Crit)#")>
				   
					   <cfset cnt = 1>
					   <cfloop index="itm" list="#crit#" delimiters="ORDER BY">
					      <cfif cnt eq "1">
						      <cfset crit = itm>
						  </cfif>
						  <cfset cnt = 2>
					   </cfloop>
					   
				   <cfelseif FindNoCase("ORDER BY", "#preserveSingleQuotes(Crit)#")>
				   
				      <cfset crit = "WHERE 1=1 ">	   
				   
				   </cfif>				   						   
			   	  
				   <cftry>
			  			   
					   <cfquery name="ListDescription" 
				        datasource="#LookupDataSource#" 
			       	    username="#SESSION.login#" 
				        password="#SESSION.dbpw#">
					      SELECT DISTINCT #LookupFieldValue# as PK, 
						                  #LookupFieldDisplay# as Display
			        	  FROM   #LookupTable#
						  <cfif crit gte "a" and crit neq "WHERE">
								#preserveSingleQuotes(Crit)#
								AND #LookupFieldValue# IN (#PreserveSingleQuotes(filter)#)
						  <cfelse>
								WHERE  #LookupFieldValue# IN (#PreserveSingleQuotes(filter)#) 
						  </cfif>				       
			           </cfquery>
					   
					  					   
					   <cfloop Query="ListDescription">						 
			   			  <tr><td>- #Display#</td></tr>					
					   </cfloop> 
				   
				   	   <cfcatch>
						    <tr><td>- #PreserveSingleQuotes(filter)#											
							</td></tr>	
					   </cfcatch>
				   
				   </cftry>
				
				</cfif>
				  
			   </table>
		   </cfif>
		   </td>
		   <td align="right" valign="top">
			<cfif CriteriaValue neq "">
			<!---
		    <A href="CriteriaPurge.cfm?ID=#URL.ID#&ID1=#CriteriaId#&row=#URL.row#">
			<img src="#SESSION.root#/images/cancelN.JPG" alt="" width="12" height="12" border="0">
			<a>&nbsp;
			--->
			</cfif>
		  </td>
		</tr> 	
		
		<cfif currentrow neq recordcount>
		<tr><td colspan="3" class="line" height="1"></td></tr>
		</cfif>
		
		</cfif>
		
		</cfoutput>
		
		<tr><td colspan="3" height="4"></td></tr>
						
	</table>		