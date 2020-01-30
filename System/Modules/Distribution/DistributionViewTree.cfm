
<cfset Criteria = ''>



<cf_divscroll style="height:99%">

<table width="99%" class="tree" border="0" cellspacing="0" cellpadding="0">

  <tr><td valign="top" style="padding-top:4px">
  
    <table width="91%" border="0" cellspacing="0" cellpadding="0" align="center">
			
		<cfoutput> 
				
			<cfquery name="Check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM ReportBatchLog
			WHERE Created > getDate()-1
			AND   ProcessClass != 'Trial'
			ORDER BY EMailSent DESC 
			</cfquery>
			<tr>		
			<cfif Check.recordcount gte "1">
				<td height="50" class="labelit">
				<img src="#SESSION.root#/Images/attention.gif" alt="Last Run" border="0"> : 
				<a href="DistributionLog.cfm?ID=#Check.BatchId#" target="right">
				<b>#DateFormat(Check.ProcessStart, CLIENT.DateFormatShow)#</b></a>
				</td>
			<cfelse>
			<td align="center" height="40">
			<cfoutput>
				<button onClick="javascript:batch('trial')" style="width:170" class="button10s" ><font face="Calibri" size="3">Run #dateFormat(now(), "dd MMM")#</font></button>
			</cfoutput>
			</td>	
			</cfif>		
			</tr>
				
		</cfoutput>

      <tr>
        <td class="linedotted" height="1"></td>
      </tr>
	  
	  <tr>
        <td height="25"><a href="javascript:refreshTree()" class="labelit"><font face="Calibri" size="2" color="0080C0">Refresh</a></td>
      </tr>
	      
		 <tr>
	        <td class="linedotted"></td>
	     </tr>		
		
	 <tr>
        <td  height="30"><a title="Reports are prepared but are not distributed by Mail" href="javascript:batch('test')"><font face="Calibri" size="3" color="0080C0"><u>Test run</font></a></td>
      </tr>
	  
	 <cfif check.recordcount gte "0">	     
		
		 <tr>
	        <td class="linedotted" style="padding-top:7px"></td>
	     </tr>		  
			  
	     <tr>
	        <td style="padding-top:4px"> 	
				<cfform style="height:99%">
	            <cf_DistributionTreeData> 				
				</cfform>		
		    </td>
	     </tr>
		    
		
	 
	 </cfif>
  
    </table>
	</td>
  </tr>
</table>

</cf_divscroll>

