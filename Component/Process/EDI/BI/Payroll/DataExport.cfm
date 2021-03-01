<cfparam name="Object.ObjectKeyValue4" default="00000000-0000-0000-0000-000000000000">

<cfquery name="get" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   *
	FROM     TransactionHeader
	WHERE    TransactionId = '#Object.ObjectKeyValue4#'  
</cfquery>	

<cfquery name="getCalculationPeriod" 
    datasource="AppsPayroll" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   *
	FROM     SalarySchedulePeriod
	WHERE    CalculationId = '#get.ReferenceId#'   
</cfquery>	

<cfquery name="Staff" 
    datasource="AppsPayroll" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   P.PersonNo, P.FullName
	FROM     EmployeeSettlementDistribution S INNER JOIN
                Employee.dbo.Person P ON S.PersonNo = P.PersonNo
	WHERE    Mission        = '#getCalculationPeriod.Mission#'
	AND      SalarySchedule = '#getCalculationPeriod.SalarySchedule#'
	AND      PaymentDate    = '#getCalculationPeriod.PayrollEnd#'						
</cfquery>	

<cfquery name="getHeader" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM Accounting.dbo.TransactionHeader
	WHERE TransactionId = '#Object.ObjectKeyValue4#'
</cfquery>	


<table width="94%" cellspacing="0" cellpadding="0" align="center">
	
	<tr>
		<td style="padding-top:25px">&nbsp;</td>
	</tr>
	
	<TR>
		<TD style="width:95%;height:40px;padding:5px;padding-left:5px;border:1px solid silver;border-radius:5px;" align="center" id="setABN">	
		
			<cfquery name="qXMLCheck" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   Attachment 
				WHERE  DocumentPathName = 'GLTransaction'  
				AND    Server 		    = '#SESSION.rootdocumentpath#'
				AND    ServerPath 	    = 'GLTransaction/#Object.ObjectKeyValue4#/'
				AND    FileName 	   LIKE '001_%.xml'
				AND    FileStatus 	    = 1
			</cfquery>	
		
			<cfif qXMLCheck.recordcount eq 0>
			
			  	<cf_tl id= "ABN XML Generation" var="buttonValue">
				<cfoutput>
					<input type="button" 
					       id="SendABN" 
						   name="SendABN" 
						   value="#buttonValue#" 
						   class="button10g"
					       style="height:28;width:260" 
						   onclick="doXML('#Object.ObjectKeyValue4#','#URL.ID#')">			
				</cfoutput>
				
			<cfelse>
			
				<cfset URL.TransactionId = Object.ObjectKeyValue4>
				<cfset URL.DocumentType  = "001">
				<cfinclude template = "ViewFiles.cfm">	
							
			</cfif>	
			
			<cfset Session.Status = 0>
			
			<cfprogressbar name="pBar1" 
			    style="height:40px;bgcolor:silver;progresscolor:black;border:0px" 					
				height="20" 
				bind="cfc:service.Authorization.AuthorizationBatch.getstatus()"				
				interval="#staff.recordcount/2#" 
				autoDisplay="false" 
				width="506"/> 
				   
		</TD>		
	</TR>
	
	<tr>
		<td style="padding-top:25px">&nbsp;</td>
	</tr>
	
	<!---
	
	<TR>
		<TD style="width:95%;height:40px;padding:5px;padding-left:5px;border:1px solid silver;border-radius:5px;" align="center" id="setSUN">	

			<cfquery name="qSUNCheck" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM Attachment 
				WHERE 
				    DocumentPathName = 'GLTransaction'  
				AND Server 			 = '#SESSION.rootdocumentpath#'
				AND ServerPath 		 = 'GLTransaction/#Object.ObjectKeyValue4#/'
				AND FileName 		 = '002_#getHeader.Journal#_#getHeader.JournalSerialNo#_PPost.dat'
				AND FileStatus 		 = 1
			</cfquery>						
		
			<cfset Session.Status = 0>

			<cfprogressbar name="pBar2" 
			    style="height:40px;bgcolor:silver;progresscolor:black;border:0px" 					
				height="20" 
				bind="cfc:service.Authorization.AuthorizationBatch.getstatus()"				
				interval="#staff.recordcount/2#" 
				autoDisplay="false" 
				width="506"/> 
		
		
			<cfif qSUNCheck.recordcount eq 0>
			  	<cf_tl id= "SUN Posting" var="buttonValue2">
				<cfoutput>
					<input type="button" 
					       id="SendSUN" 
						   name="SendSUN" 
						   value="#buttonValue2#" 
						   class="button10g"
					       style="height:28;width:260" 
						   onclick="doSUN('#Object.ObjectKeyValue4#','#URL.ID#')">			
				</cfoutput>
			<cfelse>

				<cfset URL.TransactionId = Object.ObjectKeyValue4>
				<cfset URL.DocumentType  = "002">
				<cfinclude template = "ViewFiles.cfm">				
				
			</cfif>
			
				   
		</TD>		
	</TR>
	
	--->
	
</table>