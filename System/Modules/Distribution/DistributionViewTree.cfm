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
<cfset Criteria = ''>

<cf_divscroll style="height:99%">

<table width="99%" class="tree">

  <tr><td valign="top" style="padding-top:4px">
  
    <table width="91%" align="center">
			
		<cfoutput> 
				
			<cfquery name="Check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     ReportBatchLog
			WHERE    Created > getDate()-1
			AND      ProcessClass != 'Trial'
			ORDER BY EMailSent DESC 
			</cfquery>
			<tr class="line">		
			<cfif Check.recordcount gte "1">
				<td style="height:60px" class="labelmedium2">
				
					<table>
					<tr>
					<td><img src="#SESSION.root#/Images/attention.gif" alt="Last Run" border="0"></td>				
					<td style="padding-left:5px;font-size:20px"> 
					   <a href="javascript:ptoken.open('DistributionLog.cfm?ID=#Check.BatchId#','right')">
					   #DateFormat(Check.ProcessStart, CLIENT.DateFormatShow)#
					   </a>
					</td>
					</tr>
					</table>
					
				</td>
				
			<cfelse>
				<td align="center" height="40">
				<cfoutput>
					<button onClick="javascript:batch('backoffice')" style="width:98%;border:1px solid silver" class="button10g" ><font face="Calibri" size="3">Run #dateFormat(now(), "dd MMM")#</font></button>
				</cfoutput>
				</td>	
			</cfif>		
			</tr>
				
		</cfoutput>
	  
	    <tr class="labelmedium2" style="height:35px">
           <td><a href="javascript:refreshTree()"><cf_tl id="Refresh"></a>&nbsp;|&nbsp;<a title="All Reports are prepared but are not distributed by Mail" href="javascript:batch('trial')">Trial RUN</a></td>
        </tr>
			
	   	  
	 <cfif check.recordcount gte "0">	     
		
		 <tr>
	        <td class="line" style="padding-top:7px"></td>
	     </tr>		  
			  
	     <tr>
	        <td style="padding-top:4px">			
	            <cf_DistributionTreeData> 										
		    </td>
	     </tr>	
	 
	  </cfif>
  
    </table>
	</td>
  </tr>
</table>

</cf_divscroll>


