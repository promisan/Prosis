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
<cfif url.mode eq "Formula">
	
	<cfquery name="Update" 
	 datasource="appsSystem">
	 UPDATE UserReportOutput 
	 SET    GroupFormula = '#URL.action#'
	 WHERE  UserAccount  = '#SESSION.acc#'
	 AND    OutputId     = '#URL.ID#'
	 AND    OutputClass  = 'Detail'
	 AND    FieldName    = '#URL.Name#' 
	</cfquery>
	
	<cfoutput>

		<cfif url.action eq "None">
		   <a href="javascript:update('formula','#url.name#','SUM','#url.id#','#url.box#')">Yes</a>&nbsp;|&nbsp;<font color="0080FF">No</font></b>
		<cfelseif url.action eq "SUM">
		   <font color="800000">Yes&nbsp;</font>|&nbsp;<a href="javascript:update('formula','#url.name#','None','#url.id#','#url.box#')">No</a>
		</cfif>
	
	</cfoutput>

<cfelseif url.mode eq "Sorting">

	<cfquery name="Update" 
	 datasource="appsSystem">
	 UPDATE UserReportOutput 
	 SET    OutputSorting = '#URL.action#'
	 WHERE  UserAccount   = '#SESSION.acc#'
	 AND    OutputId      = '#URL.ID#'
	 AND    OutputClass   = 'Detail'
	 AND    FieldName     = '#URL.Name#' 
	</cfquery>
	
	<cfoutput>
	
	<cfif url.action eq "">
		   <a href="javascript:update('sorting','#url.name#','ASC','#url.id#','#url.box#')">ASC</a>&nbsp;|
		   <a href="javascript:update('sorting','#url.name#','DESC','#url.id#','#url.box#')">DESC</a>&nbsp;|
		   <font color="800000">NONE</font>
	<cfelseif url.action eq "ASC">
		   <font color="800000">ASC</font>&nbsp;|			   
		   <a href="javascript:update('sorting','#url.name#','DESC','#url.id#','#url.box#')">DESC</a>&nbsp;|
		   <a href="javascript:update('sorting','#url.name#','','#url.id#','#url.box#')">NONE</a>			  
	<cfelse>
		   <a href="javascript:update('sorting','#url.name#','ASC','#url.id#','#url.box#')">ASC</a>&nbsp;|
		   <font color="800000">DESC</font>&nbsp;|			   
		   <a href="javascript:update('sorting','#url.name#','','#url.id#','#url.box#')">NONE</a>	  
	</cfif>

	</cfoutput>
	
<cfelseif url.mode eq "Label">	

	<cfquery name="Update" 
	 datasource="appsSystem">
		 UPDATE UserReportOutput 
		 SET    OutputHeader  = '#URL.action#'
		 WHERE  UserAccount   = '#SESSION.acc#'
		 AND    OutputId      = '#URL.ID#'
		 AND    OutputClass   = 'Detail'
		 AND    FieldName     = '#URL.Name#' 
	</cfquery>
	
<cfelseif url.mode eq "ap">	

	  <cfquery name="getfields" datasource="appsSystem">
	     SELECT *
		 FROM   UserReportOutput 		 
		 WHERE  UserAccount   = '#SESSION.acc#'
		 AND    OutputId      = '#URL.ID#'
		 AND    OutputClass   = 'Detail'	
		 ORDER BY FieldNameOrder DESC	 
	  </cfquery>	
	  
      <cfloop query="getfields">
	  
	      <cfparam name="Form.Order_#fieldname#" default="">
		  		  
		  <cfset sort = evaluate("Form.Order_#fieldname#")>
		  
		  <cfif sort neq "">
		  
		      <cfif FieldNameOrder neq Sort>
		  		  		  
				  <cfquery name="Update" 
					 datasource="appsSystem">
						 UPDATE UserReportOutput 
						 SET    FieldNameOrder = '#sort#',
						        Created        = getDate()
						 WHERE  UserAccount    = '#SESSION.acc#'
						 AND    OutputId       = '#URL.ID#'
						 AND    OutputClass    = 'Detail'
						 AND    FieldName      = '#fieldname#' 
					</cfquery>
				
				</cfif>
			
			</cfif>
					    
	  </cfloop>
	  
	   <cfquery name="getfieldorder" datasource="appsSystem">
		     SELECT   *
			 FROM     UserReportOutput 		 
			 WHERE    UserAccount   = '#SESSION.acc#'
			 AND      OutputId      = '#URL.ID#'
			 AND      OutputClass   = 'Detail'	
			 ORDER BY FieldNameOrder, Created DESC	 
	  </cfquery>	
	  
	  <cfloop query="getfieldorder">
	 	  
	  	<cfquery name="Update" 
			 datasource="appsSystem">
				 UPDATE UserReportOutput 
				 SET    FieldNameOrder = '#currentrow#',  
				        Created        = getDate()
				 WHERE  UserAccount    = '#SESSION.acc#'
				 AND    OutputId       = '#URL.ID#'
				 AND    OutputClass    = 'Detail'
				 AND    FieldName      = '#fieldname#' 
			</cfquery>
	    
	  </cfloop>
	  
	  <cfinclude template="FormatExcelDetailSelected.cfm">		
	  
	
<cfelseif url.mode eq "up" or url.mode eq "down">

	<!--- reset ordering --->
	
	<cfquery name="list" 
	 datasource="appsSystem">
		 SELECT   *
		 FROM     UserReportOutput 	 
		 WHERE    UserAccount = '#SESSION.acc#'
		 AND      OutputId    = '#URL.ID#'
		 AND      OutputClass = 'Detail'
		 AND      OutputShow = 1
		 ORDER BY FieldNameOrder		
	</cfquery>
	
	<cfloop query="list">
	
		<cfquery name="reset" datasource="appsSystem">
			 UPDATE UserReportOutput 
			 SET    FieldNameOrder = '#currentrow#'
			 WHERE  UserAccount    = '#SESSION.acc#'
			 AND    OutputId       = '#URL.ID#'
			 AND    OutputClass    = 'Detail'
			 AND    FieldName      = '#FieldName#' 
		</cfquery>
		
	</cfloop>
	
	<cfquery name="Current" 
	 datasource="appsSystem">
		 SELECT FieldNameOrder
		 FROM   UserReportOutput 	 
		 WHERE  UserAccount = '#SESSION.acc#'
		 AND    OutputId    = '#URL.ID#'
		 AND    OutputClass = 'Detail'
		 AND    FieldName   = '#URL.Name#' 
	</cfquery>
	
	<cfquery name="Above" 
	 datasource="appsSystem">
		 SELECT   TOP 1 FieldName
		 FROM     UserReportOutput 	 
		 WHERE    UserAccount  = '#SESSION.acc#'
		 AND      OutputId     = '#URL.ID#'
		 AND      OutputClass  = 'Detail'
		 AND      OutputShow = 1
		 <cfif url.mode eq "up">
		 AND      FieldNameOrder < '#Current.FieldNameOrder#' 
		 ORDER BY FieldNameOrder DESC
		 <cfelseif url.mode eq "down">
		  AND    FieldNameOrder > '#Current.FieldNameOrder#' 
		 ORDER BY FieldNameOrder ASC
		 </cfif>
	</cfquery>
		
	<cfquery name="MoveOther" 
	 datasource="appsSystem">
		 UPDATE UserReportOutput 
		 SET    FieldNameOrder = '#Current.FieldNameOrder#'
		 WHERE  UserAccount    = '#SESSION.acc#'
		 AND    OutputId       = '#URL.ID#'
		 AND    OutputClass    = 'Detail'
		 AND    FieldName      = '#Above.FieldName#' 
	</cfquery>

	<cfquery name="MoveUpDown" 
	 datasource="appsSystem">
	 UPDATE UserReportOutput 
	 <cfif url.mode eq "up">
	 SET    FieldNameOrder = '#Current.FieldNameOrder-1#'
	 <cfelse>
	 SET    FieldNameOrder = '#Current.FieldNameOrder+1#'
	 </cfif>
	 WHERE  UserAccount    = '#SESSION.acc#'
	 AND    OutputId       = '#URL.ID#'
	 AND    OutputClass    = 'Detail'
	 AND    FieldName      = '#URL.Name#' 
	</cfquery>
	
	<cfinclude template="FormatExcelDetailSelected.cfm">		

</cfif>


