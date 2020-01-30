<cfparam name="url.SettlementPhase" default="">
<cfparam name="url.sendemail" 		default="0">
<cfparam name="url.TransactionId" 	default="">
<cfparam name="url.Password" 	    default="Yes">

<cfquery name="Settle" 
	datasource="AppsPayroll">
	 SELECT   *
     FROM     EmployeeSettlement S INNER JOIN
              Employee.dbo.Person P ON S.PersonNo = P.PersonNo INNER JOIN
              SalarySchedule R ON S.SalarySchedule = R.SalarySchedule
     WHERE    SettlementId = '#url.settlementid#'		
</cfquery>

<cfquery name="Contract" 
	datasource="AppsEmployee">
	 SELECT  TOP 1 C.*, T.Description as ContractDescription
     FROM    PersonContract C, Ref_ContractType T
	 WHERE   T.ContractType  = C.ContractType
	 AND     PersonNo        = '#Settle.PersonNo#'
	 AND     SalarySchedule  = '#Settle.SalarySchedule#'
	 AND     ActionStatus   != '9'
	 AND     Mission         = '#Settle.Mission#'
	 AND     DateEffective  <= '#settle.PaymentDate#'
	 AND     DateExpiration >= '#settle.PaymentDate#' 
	 ORDER BY DateEffective		 
</cfquery>

<cfif contract.recordcount eq "0">
	
	<cfquery name="Contract" 
		datasource="AppsEmployee">
		 SELECT  TOP 1 C.*, T.Description as ContractDescription
	     FROM    PersonContract C, Ref_ContractType T
		 WHERE   T.ContractType  = C.ContractType
		 AND     PersonNo        = '#Settle.PersonNo#'
		 AND     SalarySchedule  = '#Settle.SalarySchedule#'
		 AND     ActionStatus   != '9'
		 AND     Mission         = '#Settle.Mission#'
		 AND     DateEffective  <= '#settle.PaymentDate#'	
		 ORDER BY DateEffective		 
	</cfquery>

</cfif>

<cfset per = dateformat(Settle.PaymentDate,"YYYYMM")>

<cfif url.sendemail eq 1>

	<cfquery name="get" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT   *
			FROM     TransactionHeader
			WHERE    TransactionId = '#URL.TransactionId#'  
	</cfquery>	
	
	<cfif get.referenceNo neq "">	
		<cfset path = "#Settle.Mission#_#Settle.SalarySchedule#\#per#_#get.referenceNo#">		
	<cfelse>	
		<cfset path = "#Settle.Mission#_#Settle.SalarySchedule#\#per#">	
	</cfif>

	<cfif url.serial eq "0">
		<cfset url.filename = "#SESSION.rootDocumentPath#\Payslip\#path#\#Settle.PersonNo#.pdf">
	<cfelse>
		<cfset url.filename = "#SESSION.rootDocumentPath#\Payslip\#path#\#Settle.PersonNo#_#url.serial#.pdf">
	</cfif>
	
<cfelse>

	<cfset url.filename = "#SESSION.rootPath#\CFRStage\User\#session.acc#\Payslip_#Settle.settlementid#.pdf">	

</cfif>

<cfif url.password eq "Yes">
	<cfset pwd = Settle.eMailAddress>
<cfelse>
    <cfset pwd = "">
</cfif>

<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT * 
		FROM Parameter
		WHERE HostName = '#CGI.HTTP_HOST#'  
</cfquery>

<cfquery name="getParameter" 
	datasource="AppsPayroll">
		SELECT   *
		FROM     Ref_ParameterMission
		WHERE 	  Mission = '#Settle.mission#' 
</cfquery>	

<cfquery name="getScheduleMission" 
	datasource="AppsPayroll">
		SELECT   *
		FROM     SalaryScheduleMission
		WHERE 	 Mission = '#Settle.mission#'
		AND 	 SalarySchedule = '#Settle.SalarySchedule#' 
</cfquery>

<cfdocument name="Payslip"
          filename="#url.filename#"
          format="PDF"
          pagetype="letter"
          margintop=".5"
          marginbottom=".5"
          marginright=".5"
          marginleft=".5"
		  userpassword="#pwd#"
          orientation="portrait"
          unit="cm"
          encryption="128-bit"
          permissions="AllowPrinting"
          fontembed="Yes"
          overwrite="Yes"
          backgroundvisible="No"
          bookmark="False"
          localurl="Yes">
		  
	<cfset label = "font-size: 15px; font-family: Calibri;">
	<cfset field = "font-size: 17px;font-family: Calibri;">		  

	<cfoutput>			
		
		<cfif getParameter.payslipTemplate eq "">		
		    <cfinclude template="SalarySlipPrintDocumentContent.cfm">
		<cfelse>				
			<cfinclude template="#getParameter.PayslipTemplate#">
		</cfif>
				
	</cfoutput>

</cfdocument>

<cfif url.sendemail eq 1>

	<cfif getScheduleMission.DisableMailPayslip eq "0">
		<cf_MailSalarySlip
			SettlementId    = "#url.settlementId#"
			SettlementPhase = "#url.settlementPhase#"
			Serial          = "#url.Serial#"
			TransactionId   = "#url.TransactionId#"> 
	</cfif> 
	
<cfelse>

	<cfoutput>
		<script>
			window.location = '#SESSION.root#/CFRStage/user/#SESSION.acc#/Payslip_#Settle.settlementid#.pdf'
		</script>
	</cfoutput>
	
</cfif>