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
	
	<table width="100%"><tr><td height="60">						 	 	
	<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
			
	 <tr><td height="7" bgcolor="FF8080" align="center" style="padding:7px;border:1px solid gray;border-radius:5px">
	   
		   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		   <tr><td align="center" class="labellarge" style="color:#FFFFFF;">			   
		   <b><cf_tl id="Attention">:&nbsp;</b> <cf_tl id="Report preparation was interrupted on request of the user">
		   </td></tr>
		   </table>
	   
	  	</td>
	</tr>
	  
	</table>
	
	</td></tr></table>		
	
	 <cfquery name="List" 
     datasource="AppsSystem">
		 DELETE FROM stReportStatus
		 WHERE  ControlId     = '#URL.ControlId#'
		 AND    OfficerUserId = '#SESSION.acc#'
     </cfquery>