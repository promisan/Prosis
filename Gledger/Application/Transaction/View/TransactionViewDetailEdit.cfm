
<cfparam name="url.mode" default="edit">

<cfquery name="get"
        datasource="AppsLedger" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * 
		 FROM   TransactionHeader		
		 WHERE  Journal             = '#url.journal#'
		 AND    JournalSerialNo     = '#url.Journalserialno#'		
</cfquery>		
  
<cfset link = "journal=#url.journal#&journalserialno=#url.journalserialno#">

<cfswitch expression="#url.fld#">

	<cfcase value="documentdate">  
		  
		  <cfif url.mode eq "save">
		    		
			<!--- ------------------------------------- --->
			<!--- create a log for the edit transaction --->
			<!--- ------------------------------------- --->
			
			<!--- update the line --->
		  
		    <cftransaction>
			
			    <cfif url.selected neq ''>
				 
			      <CF_DateConvert Value="#url.selected#">
				  <cfset dte = dateValue>
			    <cfelse>
			      <cfset dte = 'NULL'>
			    </cfif>	
			
				<cfquery name="Update"
			         datasource="AppsLedger" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
				         UPDATE TransactionHeader
						 SET    DocumentDate        =  #dte#					 
						 WHERE  Journal             = '#url.journal#'
						 AND    JournalSerialNo     = '#url.Journalserialno#'			 
			    </cfquery>		
				
				<!---
				<cfinvoke component    = "Service.Process.GLedger.Transaction"  
				   method              = "LogTransaction" 
				   Journal             = "#url.Journal#"
				   JournalSerialNo     = "#url.JournalSerialNo#"
				   TransactionSerialNo = "#url.transactionSerialNo#"
				   Action              = "Edit Memo">		 							
				   
				   --->
						   
			</cftransaction>   	  	  
		  	  
		  </cfif>	
		 	  
		  <cfoutput>	
		  
			 <cfif url.mode eq "Edit">
		 	 	
				<table>
				<tr><td>
				
		            <cf_setCalendarDate
						      name     = "documentdate"  
							  id       = "documentdate"  
							  value    = "#url.selected#"    								      
							  future   = "Yes"   
						      font     = "15"
						      mode     = "date"
						      edit     = "yes">	
				
				  </td>
				  <td>
				   <input type="button" name="Save" value="Save" class="button10g" style="width:40px" 
				     onclick="ptoken.navigate('TransactionViewDetailEdit.cfm?mode=save&selected='+document.getElementById('documentdate_date').value+'&#link#&fld=documentdate','documentdate')">	
				   </td>
				</tr>
				</table>		 
				   
		     <cfelse>
			 
			 	<cfquery name="get"
				        datasource="AppsLedger" 
				        username="#SESSION.login#" 
				        password="#SESSION.dbpw#">
				        SELECT * 
						 FROM   TransactionHeader		
						 WHERE  Journal             = '#url.journal#'
						 AND    JournalSerialNo     = '#url.Journalserialno#'		
				</cfquery>	
			 
			    <table><tr class="labelmedium2"><td>#dateformat(get.DocumentDate, CLIENT.DateFormatShow)#</td>	  
					   <td style="padding-left:4px"><a href="javascript:ptoken.navigate('TransactionViewDetailEdit.cfm?journal=#journal#&journalserialno=#journalserialno#&fld=documentdate&selected=#dateformat(get.DocumentDate, CLIENT.DateFormatShow)#','documentdate')">[<cf_tl id="edit">]</a></td>	  
					   </tr>
			     </table>
		   
			 		   
			 </cfif>   
			
			</cfoutput>	
		    				  
	</cfcase>	

</cfswitch>
