

<cftry>

<cfinvoke component = "Service.Process.Program.Execution"  
	   method           = "Budget" 
	   period           = "#url.period#" 
	   mission          = "#url.mission#"
	   currency         = "#application.basecurrency#"
	   unithierarchy    = "#hier#"
	   editionid        = "#valueList(Edition.EditionId)#"
	   mode             = "table"
	   status           = "0"
	   table            = "#SESSION.acc#Requirement">		   

<cfinvoke component = "Service.Process.Program.Execution"  
	   method           = "Budget" 
	   period           = "#url.period#" 
	   mission          = "#url.mission#"
	   currency         = "#application.basecurrency#"
	   unithierarchy    = "#hier#"
	   editionid        = "#valueList(Edition.EditionId)#"
	   status           = "1"
	   mode             = "table"
	   table            = "#SESSION.acc#Release">			 	   
	   
<cfinvoke component = "Service.Process.Program.Execution"  
	   method           = "Requisition" 
	   mission          = "#url.mission#"
	   currency         = "#application.basecurrency#"
	   unithierarchy    = "#hier#"
	   period           = "#persel#" 
	   status           = "planned"
	   mode             = "table"
	   table            = "#SESSION.acc#Planned">		
	  		   
<cfinvoke component = "Service.Process.Program.Execution"  
	   method           = "Requisition" 
	   mission          = "#url.mission#"
	   currency         = "#application.basecurrency#"
	   unithierarchy    = "#hier#"
	   period           = "#persel#" 
	   status           = "cleared" 
	   mode             = "table">		 
		   
<cfinvoke component = "Service.Process.Program.Execution"  
	   method           = "Obligation" 
	   mission          = "#url.mission#"
	   currency         = "#application.basecurrency#"
	   unithierarchy    = "#hier#"
	   period           = "#persel#" 
	   mode             = "table">		
	   	   
<cfinvoke component = "Service.Process.Program.Execution"  
	   method           = "Disbursement" 
	   mission          = "#url.mission#"
	   currency         = "#application.basecurrency#"
	   unithierarchy    = "#hier#"
	   period           = "#persel#" 
	   accountperiod    = "#peraccsel#"	   
	   mode             = "table">			      	  	     	      
	   	 
<cfoutput>

<cfparam name="SelectBase.EditionId" default="">
<cfparam name="ed" default="">
<cfset spc = 22>

<!--- ---------------------------------------- --->
<!--- show the total for this orgunit selected --->
<!--- ---------------------------------------- --->
		
<tr class="line">
	
	<td height="22" width="100%" class="labelmedium" style="padding-left:3px">
	
		<cf_UIToolTip  tooltip="This information is shown only for reference, the amounts below do not necessarily add up to this amount">
		<b>#hier# <!--- #URL.Period# ---> #OrgName# (in <cfoutput>#Application.BaseCurrency#</cfoutput>.000)
		</cf_UIToolTip>
		
	</td>
		
	<td colspan="1" align="right" style="border-left: 1px solid Gray;">	
	
		<!--- budget --->
	
		<cfquery name="Total" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    SUM(Total) AS Total 
			FROM      #SESSION.acc#Requirement	
		</cfquery>	
					
		<cfif total.total eq "">
			  <cfset rsc = 0>
		<cfelse>
			  <cfset rsc =  total.total>
		</cfif>
		
		<cf_space align="right" label="#numberformat(rsc/1000,"_,_._")#" spaces="#spc#">
	
	</td>
	
	<td colspan="1" align="right" style="border-left: 1px solid Gray">	
	
	    <!--- allotment --->
	
		<cfquery name="Total" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    SUM(Total) AS Total  
			FROM      #SESSION.acc#Release				
		</cfquery>	
					
		<cfif total.total eq "">
			  <cfset all = 0>
		<cfelse>
			  <cfset all =  total.total>
		</cfif>
		
		<cf_space align="right" label="#numberformat(all/1000,"_,_._")#" spaces="#spc#">
	
	</td>
	
	<td colspan="1" align="right" style="border-left: 1px solid Gray;">
	
		<!--- define reservations --->
		<cfquery name="Planned" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   SUM(ReservationAmount) as PlanningAmount 
			FROM     #SESSION.acc#Planned
		</cfquery>
		
		<cfif Planned.PlanningAmount eq "">
		  <cfset pla = 0>
		<cfelse>
		  <cfset pla =  Planned.PlanningAmount>
		</cfif>
		
		<cf_space align="right" label="#numberformat(pla/1000,"_,_._")#" spaces="#spc#">
	
	</td>
	
	<td colspan="1" align="right" style="border-left: 1px solid Gray;">
	
		<!--- define reservations --->
		<cfquery name="Reservation" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   SUM(ReservationAmount) as ReservationAmount 
			FROM     #SESSION.acc#Requisition
		</cfquery>
		
		<cfif Reservation.ReservationAmount eq "">
		  <cfset res = 0>
		<cfelse>
		  <cfset res =  Reservation.ReservationAmount>
		</cfif>
		
		
		<cf_space align="right" label="#numberformat(res/1000,"_,_._")#" spaces="#spc#">
	
	</td>
	
	<td colspan="1" align="right" style="border-left: 1px solid Gray;">
				
		<cfquery name="Obligation" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   SUM(ObligationAmount) as ObligationAmount 
			FROM     #SESSION.acc#Obligation		
		</cfquery>		
			
		<cfif Obligation.ObligationAmount eq "">
		  <cfset obl = 0>
		<cfelse>
		  <cfset obl =  Obligation.ObligationAmount>
		</cfif>
		
		<cf_space align="right" label="#numberformat(obl/1000,"_,_")#" spaces="#spc#">
		
	</td>
		
	<td align="right" bgcolor="ffffcf" style="border-left: 1px solid Gray;">
	
	<cfif Parameter.FundingCheckCleared eq "0">
			
		<cfif rsc-pla-res-obl gte 0>
		<cf_space align="right" label="#numberformat((rsc-pla-res-obl)/1000,"_,_")#" spaces="#spc#">	
		<cfelse>
		<cf_space align="right" label="#numberformat((rsc-pla-res-obl)/1000,"_,_")#" spaces="#spc#" color="red">	
		</cfif>
		
	<cfelse>
	
		<cfif all-pla-res-obl gte 0>
		<cf_space align="right" label="#numberformat((all-pla-res-obl)/1000,"_,_")#" spaces="#spc#">	
		<cfelse>
		<cf_space align="right" label="#numberformat((all-pla-res-obl)/1000,"_,_")#" spaces="#spc#" color="red">	
		</cfif>
		
	</cfif>	
	
	</td>
	
	<td colspan="1" align="right" style="border-left: 1px solid Gray;">
		
		<cfquery name="Invoice" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   SUM(InvoiceAmount) as InvoiceAmount
			FROM     #SESSION.acc#Invoice		
		</cfquery>		
		
		<cfif Invoice.InvoiceAmount eq "">
			  <cfset inv = 0>
		<cfelse>
			  <cfset inv =  Invoice.InvoiceAmount>
		</cfif>	
		
		<cf_space align="right" label="#numberformat(inv/1000,"_,_._")#" spaces="#spc#">
		
	</td>
	
	<td bgcolor="white" style="border-left: 1px solid Gray;"><cf_space spaces="2"></td>
		
</tr>

<!--- show the funds --->

</cfoutput>


<cfcatch>

	<tr><td height="100">

	<cf_message message="Funding information could not be retrieved, close this screen and try again" return="no">
	<script>
	Prosis.busy('no')
	</script>
	<cfabort>
	
	</td></tr>

</cfcatch>

</cftry>

