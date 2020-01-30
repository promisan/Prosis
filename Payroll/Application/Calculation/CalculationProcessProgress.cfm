	
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding" style="padding-left:15px;padding-right:15px">
	
	<cfquery name="LogStepDetail" 
		datasource="appsPayroll">
		SELECT   *
		FROM     CalculationLogDetail
		WHERE    ProcessNo = '#url.Processno#'	
		ORDER BY StepTimeStamp
	</cfquery>
	
	<!---
	
	<cfif LogStepDetail.recordcount lte "3">

		<cfif Client.LanguageId eq "ENG">
		
			<tr><td colspan="2" class="labelit">The payroll, personal and miscellaneous entitlement calculation engine is designed to ensure a HIGH performance salary entitlement and settlement calculation.	</td></tr>
			<tr><td colspan="2" class="labelit">Calculation can be performed for one or several entitlement periods at once (no limitations)</td></tr>
			<tr><td colspan="2" class="labelit">Calculation is performed in five steps:</td></tr>
			<tr><td colspan="2" class="labelit">&nbsp;1. Initialization of the database</td></tr>
			<tr><td colspan="2" class="labelit">&nbsp;2. Determination of staff on board with valid contracts</td></tr>
			<tr><td colspan="2" class="labelit">&nbsp;3. Entitlement calculation</td></tr>
			<tr><td colspan="2" class="labelit">&nbsp;4. Settlement (payslip generation)</td></tr>
			<tr><td colspan="2" class="labelit">&nbsp;5. Final Payment procesinng</td></tr>
			<tr><td colspan="2"></td></tr>
			<tr><td colspan="2" class="labelit"><b>Progress</b></td></tr>
		
		<cfelseif Client.LanguageId eq "ESP">
		
			<tr><td colspan="2" class="labelit">El sistema de PROSIS-NOMINA esta dise�ado para asegurar un alto rendimiento en el calculo de los descuentos y beneficios.</td></tr>
			<tr><td colspan="2" class="labelit">El Calculo es realizado a travez de varios periodos. 
			<tr><td colspan="2" class="labelit">Los pasos que se realizan son:</td></tr>
			<tr><td colspan="2" class="labelit">&nbsp;1. Inicializaci�n de la base de datos de NOMINA</td></tr>
			<tr><td colspan="2" class="labelit">&nbsp;2. Determinaci�n de los empleados que tiene un "assignment" valido y un contrato vigente</td></tr>
			<tr><td colspan="2" class="labelit">&nbsp;3. Calculo de descuentos y bonos</td></tr>
			<tr><td colspan="2" class="labelit">&nbsp;4. Generaci�n de la boleta de pago (Settlement)</td></tr>
			<tr><td colspan="2" class="labelit">&nbsp;5. Procesamiento de indemnizaciones</td></tr>
			<tr><td colspan="2"></td></tr>
			<tr><td colspan="2" class="labelit"><b>Progreso:</b></td></tr>
			
		</cfif>
	
	</cfif>
	
	--->
		
	<cfquery name="Current" 
		datasource="appsPayroll">
		SELECT   TOP 1 *
		FROM     CalculationLogDetail
		WHERE    Processno = '#url.processno#'	
		ORDER BY StepTimeStamp DESC
	</cfquery>
	
	<cfquery name="Process" 
		datasource="appsPayroll">
		SELECT   TOP 1 *
		FROM     CalculationLog
		WHERE    ProcessNo = '#url.Processno#'		
		ORDER BY Created
	</cfquery>	
		
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<cfoutput>
	<tr class="labelmedium">
	<td width="120">#TimeFormat(Process.Created,"HH:MM:SS")#</td>
	<td><font color="408080">Started</td>
	</tr>
	</cfoutput>
	
	<cfquery name="Process" 
		datasource="appsPayroll">
		SELECT   *
		FROM     CalculationLog
		WHERE    ProcessNo = '#url.Processno#'		
		ORDER BY Created DESC
	</cfquery>
		
	<cfoutput query="Process">
	
		<cfif currentrow eq "1">
		
			<tr class="labelmedium">
			<td colspan="1"><b><cf_tl id="Schedule">:</b></td><td>#Mission#&nbsp;#SalarySchedule# &nbsp;&nbsp; #dateformat(PayrollStart,CLIENT.DateFormatShow)#</b></td>		
			</tr>
		
			<cfquery name="Detail" 
			datasource="appsPayroll">
			SELECT   *
			FROM     CalculationLogDetail
			WHERE    ProcessNo = '#Processno#'	
			AND      ProcessBatchId = '#ProcessBatchId#'		
			</cfquery>
					
			<cfloop query="Detail">
						    	
					<cfif stepStatus eq "9">
					  <cfset color = "red">
					<cfelse>
					  <cfset color = "white">	  
					</cfif>
					<tr bgcolor="#color#" class="labelmedium" style="height:20px">
						<td width="120" style="padding-left:10px">#TimeFormat(StepTimeStamp,"HH:MM:SS")#</td>
						<td>#StepDescription#</td>		
					</tr>
					<cfif stepException neq "">
						<tr><td></td>
						    <td>#StepException#</td>
						</tr>
					</cfif>
				
			</cfloop>		
			
		<cfelse>
		
			<tr class="labelmedium line">
				<td style="padding-left:10px">Payroll:</td>
			    <td>#Mission#&nbsp;#SalarySchedule#&nbsp;#dateformat(PayrollStart,CLIENT.DateFormatShow)#</td>		
			</tr>	
			
		</cfif>	
	
	</cfoutput>
	
	<!--- fully completed --->	
			
	<cfif Process.ActionStatus eq "2">
	
		<script>
			stopprogress()
		</script>
		
		<cfquery name="Process" 
		datasource="appsPayroll">
		SELECT   DATEDIFF ( ms , timeStart , timeEnd )  as Diff
		FROM (
		SELECT   MIN(StepTimeStamp) as timeStart, MAX(StepTimeStamp) as timeEnd
		FROM     CalculationLogDetail L
		WHERE    ProcessNo = '#url.Processno#'		
		) as D
						
	    </cfquery>
		
		<cfoutput>	
					
			<cfset sec = Process.diff/1000>
			<tr class="labelmedium" bgcolor="C9F5D2">
				<td colspan="2" style="padding-left:5px">Process took <b>#numberformat(sec,'.___')#</b> second<cfif sec gt "1">s</cfif> to complete</td>				
				<td></td>
			</tr>	
		</cfoutput>
		
	<cfelseif Process.ActionStatus eq "9">
	
		<script>
			stopprogress()
		</script>
		
		<cfoutput>	
			<tr class="labelmedium">
			   <td colspan="3" align="center">
			   	<font color="FF0000">#Process.actionMemo#</font>
			   </td>			
			</tr>	
		</cfoutput>			
		
	<cfelse>
	
		<cfoutput>
			<tr>
				<td colspan="3" align="center">
					<img src="#SESSION.root#/Images/busy2.gif" alt="" border="0">
				</td>
			</tr>	
		</cfoutput>			
		
	</cfif>
	
</table>
