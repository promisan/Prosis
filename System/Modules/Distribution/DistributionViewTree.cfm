
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
				<td height="50" class="labelit">
				<img src="#SESSION.root#/Images/attention.gif" alt="Last Run" border="0"> : 
				<a href="DistributionLog.cfm?ID=#Check.BatchId#" target="right">
				<b>#DateFormat(Check.ProcessStart, CLIENT.DateFormatShow)#</b></a>
				</td>
			<cfelse>
			<td align="center" height="40">
			<cfoutput>
				<button onClick="javascript:batch('manual')" style="width:170" class="button10g" ><font face="Calibri" size="3">Run #dateFormat(now(), "dd MMM")#</font></button>
			</cfoutput>
			</td>	
			</cfif>		
			</tr>
				
		</cfoutput>
	  
	    <tr class="labelmedium" style="height:35px">
           <td><a href="javascript:refreshTree()"><cf_tl id="Refresh Log"></a>&nbsp;|&nbsp;<a title="All Reports are prepared but are not distributed by Mail" href="javascript:batch('trial')">Test run</a></td>
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

