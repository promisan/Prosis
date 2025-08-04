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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<!--- define expenditure periods --->

<cfparam name="url.ProgramHierarchy" default="">
<cfparam name="url.UnitHierarchy"    default="">
<cfparam name="URL.isParent"         default="0">
<cfparam name="url.resource"         default="">
<cfparam name="url.editionid"        default="">


<cfquery name="Object" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Object
	WHERE  Code = '#url.objectcode#'	
</cfquery>	

<cfif url.resource eq "resource">
   <cfset res = Object.Resource>
<cfelse>
   <cfset res = "">  
</cfif>

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Program 
	WHERE    ProgramCode = '#URL.ProgramCode#' 	
</cfquery>

<cfquery name="Expenditure" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    DISTINCT Period, AccountPeriod
FROM      Ref_MissionPeriod
WHERE     Mission = '#Program.Mission#'
<cfif url.editionid eq "">
AND       EditionId IN (SELECT   EditionId
						FROM     Ref_MissionPeriod
						WHERE    Mission = '#Program.Mission#'
						AND      Period  = '#URL.Period#') 
<cfelse>
AND       EditionId = '#url.editionid#'
</cfif>			

</cfquery>

<cfset persel = "">
<cfset peraccsel = "">

<cfloop query="Expenditure">

  <cfif persel eq "">
     <cfset persel = "'#Period#'"> 
	 <cfset peraccsel = "'#AccountPeriod#'"> 
  <cfelse>
     <cfset persel = "#persel#,'#Period#'">
	 <cfset peraccsel = "#peraccsel#,'#AccountPeriod#'"> 
  </cfif>
  
</cfloop>

<cfset prghier = ProgramHierarchy>
<cfset orghier = UnitHierarchy>
<cfif ProgramHierarchy eq "undefined">
	   <cfset prghier = "">
</cfif>
<cfif UnitHierarchy eq "undefined">
	   <cfset orghier = "">
</cfif>
		
<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Disbursement" 
		   mission          = "#Program.mission#"
		   programHierarchy = "#prghier#"
		   unithierarchy    = "#orghier#"
		   period           = "#persel#" 
		   accountperiod    = "#peraccsel#"
		   currency         = "#application.basecurrency#"
		   fund             = "#url.fund#"
		   Resource         = "#res#"
		   Object           = "#url.objectCode#"
		   ObjectParent     = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "View"
		   ReturnVariable   = "Invoice">	
		   
	  		   

<table border="0" width="96%" align="center"><tr><td>		

<table width="100%" 
     border="0" 
	 bgcolor="ffffff" 
	 cellspacing="0" 
	 cellpadding="0" 
	 align="right">
  	   
 <cfif Invoice.recordcount eq "0">		   

 <tr><td align="center" height="30">There are no disbursement records for this project to show in this view. You must select the underlying project directly.</td></tr> 
 
 <cfelse>
 
 	<tr> 
	  <td colspan="6">
	  
	     <table width="100%" border="0" cellspacing="0" cellpadding="0">
	     <tr>
		  
		   <td width="2"></td>
		  	  		  
				   <td colspan="1" height="18">		
					</td>	
					
					<td width="90%"></td>
					
				    <td align="right">
		   
				   <cfoutput>
		   
				   	<img src = "#SESSION.root#/Images/close3.gif" 
						alt="hide" 
						border="0" 
						align  = "right" 
						class="regular" 
						style="cursor: pointer;" 
						onClick= "document.getElementById('inv#url.box#').className='hide'">
	
				</cfoutput>	
		   
		   </td>			
						  
		 </tr>
		 </table>
	 </td>
	 
	 </tr>
   		 
	 <tr>
	 
	 <td bgcolor="F3F3DA">
	     <table width="100%" cellspacing="0" cellpadding="0">
		 <tr><td colspan="6" height="1" class="line"></td></tr>
	    		 
		  <cfquery name="Total"
			         dbtype="query">
			SELECT    sum(InvoiceAmount) as Amount
			FROM      Invoice
			
		  </cfquery>
	 
	 	  <cfoutput>
		  <tr class="labelmedium">		
		       <td></td>  
			   <td colspan="2" height="18" style="padding-left:4px">Disbursements #Period#</td>		  		   
			   <td width="125">
			   
				   	<table  width="125" cellspacing="0" cellpadding="0" class="formpadding">
					    <tr></tr>
					</table>		  			
			   
			   </td>		   
			   <td align="right"><b>#NumberFormat(Total.Amount,",__.__")#</td>
			   <td width="20"></td>
		 </tr>
		 </cfoutput>
		 
		 <tr><td colspan="6" height="1" class="line"></td></tr>
		 </table>
	 </td>
	 
	 </tr>
	 	  
	 <tr>
		 
	 <td>
	 
	 <table width="100%" border="0" cellspacing="0" cellpadding="0">
	 	  
	 <cfif Invoice.recordcount neq "0">
	    
		 <cfoutput query="Invoice">
		 	  
			 <tr class="labelit">
			 
			 	<td width="4%" align="center" height="18" style="padding-left:8px">				
					<cfif ReferenceId neq "">
				    <img src="#SESSION.root#/Images/contract.gif" alt="Open Invoice" name="i#URL.ObjectCode#_#currentrow#" 
						  onMouseOver="document.i#URL.ObjectCode#_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="document.i#URL.ObjectCode#_#currentrow#.src='#SESSION.root#/Images/contract.gif'"
						  style="cursor: pointer;" alt="" width="11" height="12" border="0" align="absmiddle" 
						  onClick="invoiceedit('#ReferenceId#')">
					<cfelse>
						<img src="#SESSION.root#/Images/contract.gif" alt="Open Transaction" name="i#URL.ObjectCode#_#currentrow#" 
						  onMouseOver="document.i#URL.ObjectCode#_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="document.i#URL.ObjectCode#_#currentrow#.src='#SESSION.root#/Images/contract.gif'"
						  style="cursor: pointer;" alt="" width="11" height="12" border="0" align="absmiddle" 
						  onClick="ShowTransaction('#Journal#','#journalSerialNo#')">
					
					</cfif>	  
			   </td>
			  
			   <td width="20%">
			   <cfif ReferenceId neq "">
			   
			   <a href="javascript:invoiceedit('#ReferenceId#')"><font color="0080C0">#ReferenceNo#</a>
			   <cfelse>
			   <a href="javascript:ShowTransaction('#Journal#','#journalSerialNo#')"><font color="0080C0">#ReferenceNo#</a>
			   </cfif>
			   </td>
			   <td width="50">#ObjectCode#</td>
			   <td width="30%">
			   <cfif ReferenceId neq "">
			   <a href="javascript:invoiceedit('#ReferenceId#')">#ReferenceName#</a>
			   <cfelse>
			   <a href="javascript:ShowTransaction('#Journal#','#journalSerialNo#')">#ReferenceName#</a>
			   </cfif>
			   </td>
			   <td width="100"><cfif Reference eq "">
			   <a href="javascript:ShowTransaction('#Journal#','#journalSerialNo#')">
			   #Journal#-#JournalSerialNo#
			   </a>
			   <cfelse>#Reference#</cfif></td>
			   <td width="10%">#DateFormat(TransactionDate, CLIENT.DateFormatShow)#</td>
			   <td align="right"><cfif APPLICATION.BaseCurrency neq Currency>#Currency# #NumberFormat(InvoiceCurrency,",__.__")#</cfif></td>
			   <td align="right">#NumberFormat(InvoiceAmount,",__.__")#</td>	 
			   <td width="20"></td>	  
			 </tr>
			 
			 <cfif CurrentRow neq Invoice.recordcount>
			 <tr><td class="linedotted" colspan="8"></td></tr> 
			 </cfif>
					 	 
		 </cfoutput>
	 
	 </cfif>
	    
	</table>
	 
	</td></tr>

</cfif>

</table>

</td></tr>

</table>
