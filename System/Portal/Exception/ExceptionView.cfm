<!--
    Copyright © 2025 Promisan

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

<cfparam name="url.errorid"  default="">
<cfparam name="url.drillid"  default="#url.errorid#">

<cfajaximport tags="cfdiv">
<cf_ActionListingScript>
<cf_FileLibraryScript>

<cfquery name="get" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT * 
	FROM   UserError
	WHERE  ErrorId = '#url.errorid#'		
</cfquery>		

<cf_screentop height="100%" scroll="no" layout="webapp" label="Exception Log : #get.ErrorNo#" band="No" jquery="Yes" bannerheight="50" banner="gray">
<cf_divscroll>

<table width="100%" border="0" cellpadding="0" align="center" bordercolor="silver">

<tr><td height="5"></td></tr>

<tr><td>

		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">				
					
		<cfoutput query="get">
		
		<tr>
	    		 
		 <td>
		 
		 <table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
						 
			 <tr>
	         	<td height="17" style="padding-left:20px">CF server:</B></td>
				<td>#HostName#</td>
			 </tr>
			 
			 <tr>
	         	<td height="17" style="padding-left:20px">User account:</B></td>
				<td>#Account# [#NodeIp#]</td>
			 </tr>
			
		     <tr>
	         	<td height="17" style="padding-left:20px">Browser:</B></td>
				<td>#left(NodeVersion,70)#</td>
			 </tr>
			 
			 <tr>
	         	<td height="17" style="padding-left:20px">Date and Time:</td>
				<td><b>#DayOfWeekAsString(DayOfWeek(ErrorTimeStamp))#</b> #dateformat(ErrorTimeStamp,CLIENT.DateFormatShow)# at #timeformat(ErrorTimeStamp,"HH:MM:SS")#</td>
			</tr>
			
			<tr>
		    	<td height="17" width="160" style="padding-left:20px">Referer:</td>
				<td style="word-wrap: break-word; word-break: break-all;">#ErrorReferer#</td>
			</tr>
			
			<tr>
		    	<td height="17" width="160" style="padding-left:20px">Page:</td>
				<td style="word-wrap: break-word; word-break: break-all;"><b>#ErrorTemplate#</td>
			</tr>
			
			<tr>
		    	<td height="17" style="padding-left:20px">String:</td>
				<td style="word-wrap: break-word; word-break: break-all;">#ErrorString#</td>
			</tr>
			
			<tr>
		    	<td colspan="2"></td>			
			</tr>
									
			<tr>
	        	 
				 <td colspan="2" align="center" style="padding-left:20px">

					 <table width="99%" align="center" bgcolor="ffffdf" border="0" cellspacing="0" cellpadding="0" bordercolor="C0C0C0" class="formpadding">
					 <tr>
					 <td align="center">
					 <font color="gray"><b>
					 <cfset diag = replace(ErrorDiagnostics,".",".<br>","ALL")>
					 #diag#</b>
					 </td>
					 </tr>
					 </table>
					 
				 </td>
			</tr>
			
			<tr>
		    	<td colspan="2" height="20" style="padding-left:20px">Detailed Log</td>			
			</tr>
									
			<tr>
	        	 
				 <td colspan="2"  align="center" style="padding-left:20px">
				 	<table width="99%" border="0" cellspacing="0" cellpadding="0" bordercolor="C0C0C0" class="formpadding">
						<tr>
				 			<td style="word-break: break-all; word-wrap: break-word;" height="200">
								<cf_divscroll>
									<font color="gray">#ErrorContent#</b></font>
								</cf_divscroll>								
				 			</td>
						</tr>
					</table>
				 </td>
			</tr>			
			    
			</tr>
			</table>
		</tr>
							
		</cfoutput> 
		
		</table>
		
</td></tr>

<tr><td style="padding-left:10px">

    <table width="97%" align="center"><tr><td>

    <cfoutput>

    <cfset wflnk = "ExceptionViewWorkflow.cfm">
   
    <input type="hidden" 
          name="workflowlink_#get.errorid#" 
		  id="workflowlink_#get.errorid#"
          value="#wflnk#"> 
 
    <cf_securediv id="#get.errorid#" 
	       bind="url:#wflnk#?ajaxid=#get.errorid#"/>
		   
	</cfoutput>	   
	
	</td></tr></table>
	
</td></tr>

</table>
</cf_divscroll>



